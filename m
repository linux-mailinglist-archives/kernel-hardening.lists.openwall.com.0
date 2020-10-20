Return-Path: <kernel-hardening-return-20226-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id A4A5E293D6A
	for <lists+kernel-hardening@lfdr.de>; Tue, 20 Oct 2020 15:36:46 +0200 (CEST)
Received: (qmail 26022 invoked by uid 550); 20 Oct 2020 13:36:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 25999 invoked from network); 20 Oct 2020 13:36:39 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1603200988;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mVZ6m+Cc7jrX2IFIwFlzD2+/koe+xRGn+71fVIH3ijg=;
	b=es7y5xiSYWisjlimGD3lF79NSH9D/Y8gb/NQJRuDn/a/Cme8zhN9GYiTDfcroXuWy295UR
	/1U+0Y39s1YE3/K9xfUPKzvOQCQ5ZElwn8lbQJuVhHf75y8nfiCu2O/q91jNT1HlFOow8G
	zAQjtYPIUYp6hAeTc+Tl/GhP3q1vwoE=
X-MC-Unique: c2HPV8IgM6u76NXYrFQqkQ-1
Subject: Re: [PATCH] mm, hugetlb: Avoid double clearing for hugetlb pages
To: Michal Hocko <mhocko@suse.com>,
 "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Cc: linux-mm@kvack.org, kernel-hardening@lists.openwall.com,
 linux-hardening@vger.kernel.org, linux-security-module@vger.kernel.org,
 kernel@gpiccoli.net, cascardo@canonical.com,
 Alexander Potapenko <glider@google.com>,
 James Morris <jamorris@linux.microsoft.com>,
 Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>
References: <20201019182853.7467-1-gpiccoli@canonical.com>
 <20201020082022.GL27114@dhcp22.suse.cz>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <485e9fca-e6f8-7700-1ec9-381eae1367a9@redhat.com>
Date: Tue, 20 Oct 2020 15:36:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201020082022.GL27114@dhcp22.suse.cz>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=david@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 20.10.20 10:20, Michal Hocko wrote:
> On Mon 19-10-20 15:28:53, Guilherme G. Piccoli wrote:
> [...]
>> $ time echo 32768 > /proc/sys/vm/nr_hugepages
>> real    0m24.189s
>> user    0m0.000s
>> sys     0m24.184s
>>
>> $ cat /proc/meminfo |grep "MemA\|Hugetlb"
>> MemAvailable:   30784732 kB
>> Hugetlb:        67108864 kB
>>
>> * Without this patch, init_on_alloc=0
>> $ cat /proc/meminfo |grep "MemA\|Hugetlb"
>> MemAvailable:   97892752 kB
>> Hugetlb:               0 kB
>>
>> $ time echo 32768 > /proc/sys/vm/nr_hugepages
>> real    0m0.316s
>> user    0m0.000s
>> sys     0m0.316s
> 
> Yes zeroying is quite costly and that is to be expected when the feature
> is enabled. Hugetlb like other allocator users perform their own
> initialization rather than go through __GFP_ZERO path. More on that
> below.
> 
> Could you be more specific about why this is a problem. Hugetlb pool is
> usualy preallocatd once during early boot. 24s for 65GB of 2MB pages
> is non trivial amount of time but it doens't look like a major disaster
> either. If the pool is allocated later it can take much more time due to
> memory fragmentation.
> 
> I definitely do not want to downplay this but I would like to hear about
> the real life examples of the problem.
> 
> [...]
>>
>> Hi everybody, thanks in advance for the review/comments. I'd like to
>> point 2 things related to the implementation:
>>
>> 1) I understand that adding GFP flags is not really welcome by the
>> mm community; I've considered passing that as function parameter but
>> that would be a hacky mess, so I decided to add the flag since it seems
>> this is a fair use of the flag mechanism (to control actions on pages).
>> If anybody has a better/simpler suggestion to implement this, I'm all
>> ears - thanks!
> 
> This has been discussed already (http://lkml.kernel.org/r/20190514143537.10435-4-glider@google.com.
> Previously it has been brought up in SLUB context AFAIR. Your numbers
> are quite clear here but do we really need a gfp flag with all the
> problems we tend to grow in with them?
> 
> One potential way around this specifically for hugetlb would be to use
> __GFP_ZERO when allocating from the allocator and marking the fact in
> the struct page while it is sitting in the pool. Page fault handler
> could then skip the zeroying phase. Not an act of beauty TBH but it
> fits into the existing model of the full control over initialization.
> Btw. it would allow to implement init_on_free semantic as well. I
> haven't implemented the actual two main methods
> hugetlb_test_clear_pre_init_page and hugetlb_mark_pre_init_page because
> I am not entirely sure about the current state of hugetlb struct page in
> the pool. But there should be a lot of room in there (or in tail pages).
> Mike will certainly know much better. But the skeleton of the patch
> would look like something like this (not even compile tested).

Something like that is certainly nicer than proposed gfp flags.
(__GFP_NOINIT_ON_ALLOC is just ugly, especially, to optimize such
corner-case features)


-- 
Thanks,

David / dhildenb

