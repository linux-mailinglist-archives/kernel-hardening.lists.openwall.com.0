Return-Path: <kernel-hardening-return-19651-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 720A2247878
	for <lists+kernel-hardening@lfdr.de>; Mon, 17 Aug 2020 23:04:20 +0200 (CEST)
Received: (qmail 5530 invoked by uid 550); 17 Aug 2020 21:04:14 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 5510 invoked from network); 17 Aug 2020 21:04:14 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=NBhHzgcaB0DndO5Bo1sbERPDqEvBm+Tpg5B38O5FP9Y=;
        b=jf29v5YQisQs4CeCl+MkKK1dNHZQyo5Iwl0ioWukZ3HBbL3kfrZbIvXbH1bv+GAlCt
         pNQEj03XF9qPqx4mEBB7A2G3PgryJtHS0WMse8B8ibxvy95qJH9Wzs/yDo8kwvP+heww
         9sS4EtYkeTSBwyG9P4U73fWmFvHTgfM+PnH4pFGLn52hYndMO7w9EYMTvZ/kke9aBrLh
         2Eu/TgjuIlYKDdxuFSDQ7ZHk2Q6CkdWQt3m/5M3hCADgdt57raAbJO6HaCh8gvpLUIpr
         VzlyvRwWorKEYhFpfoZgY4pM403Kn4mKzVwwvCPEJPOZEU4vDDIOwAanGVQxK3JbMBdw
         dDCg==
X-Gm-Message-State: AOAM531x5GwacFHKEhZikV0W35CPDM4vDj6sB30V0tTrp3BhmDFaNtNk
	jHTk67uHnZMsBQMH6KOgYR4=
X-Google-Smtp-Source: ABdhPJx21gsuMXwrpwIahfhha39sWslHHPIeMPjlNl7akMRvTnqOKL03z0f1lBHPX5gqtVcg5l6sIg==
X-Received: by 2002:a17:906:4f8c:: with SMTP id o12mr17336022eju.69.1597698243014;
        Mon, 17 Aug 2020 14:04:03 -0700 (PDT)
Subject: Re: [PATCH RFC 1/2] mm: Extract SLAB_QUARANTINE from KASAN
To: Pavel Machek <pavel@denx.de>, Matthew Wilcox <willy@infradead.org>
Cc: Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>,
 Will Deacon <will@kernel.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>,
 Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>,
 Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
 David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Masahiro Yamada <masahiroy@kernel.org>,
 Masami Hiramatsu <mhiramat@kernel.org>, Steven Rostedt
 <rostedt@goodmis.org>, Peter Zijlstra <peterz@infradead.org>,
 Krzysztof Kozlowski <krzk@kernel.org>,
 Patrick Bellasi <patrick.bellasi@arm.com>,
 David Howells <dhowells@redhat.com>, Eric Biederman <ebiederm@xmission.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Laura Abbott <labbott@redhat.com>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kasan-dev@googlegroups.com,
 linux-mm@kvack.org, kernel-hardening@lists.openwall.com,
 linux-kernel@vger.kernel.org, notify@kernel.org,
 Andrey Konovalov <andreyknvl@google.com>
References: <20200813151922.1093791-1-alex.popov@linux.com>
 <20200813151922.1093791-2-alex.popov@linux.com>
 <20200815185455.GB17456@casper.infradead.org> <20200816195930.GA4155@amd>
From: Alexander Popov <alex.popov@linux.com>
Autocrypt: addr=alex.popov@linux.com; prefer-encrypt=mutual; keydata=
 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
 j3lCqPk=
Message-ID: <c6d3b4ce-cdb1-4bc9-d899-89228b4219cd@linux.com>
Date: Tue, 18 Aug 2020 00:03:57 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200816195930.GA4155@amd>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 16.08.2020 22:59, Pavel Machek wrote:
> On Sat 2020-08-15 19:54:55, Matthew Wilcox wrote:
>> On Thu, Aug 13, 2020 at 06:19:21PM +0300, Alexander Popov wrote:
>>> +config SLAB_QUARANTINE
>>> +	bool "Enable slab freelist quarantine"
>>> +	depends on !KASAN && (SLAB || SLUB)
>>> +	help
>>> +	  Enable slab freelist quarantine to break heap spraying technique
>>> +	  used for exploiting use-after-free vulnerabilities in the kernel
>>> +	  code. If this feature is enabled, freed allocations are stored
>>> +	  in the quarantine and can't be instantly reallocated and
>>> +	  overwritten by the exploit performing heap spraying.
>>> +	  This feature is a part of KASAN functionality.
>>
>> After this patch, it isn't part of KASAN any more ;-)
>>
>> The way this is written is a bit too low level.  Let's write it in terms
>> that people who don't know the guts of the slab allocator or security
>> terminology can understand:
>>
>> 	  Delay reuse of freed slab objects.  This makes some security
>> 	  exploits harder to execute.  It reduces performance slightly
>> 	  as objects will be cache cold by the time they are reallocated,
>> 	  and it costs a small amount of memory.
> 
> Written this way, it invites questions:
> 
> Does it introduce any new deadlocks in near out-of-memory situations?

Linux kernel with enabled KASAN is heavily tested by syzbot.
I think Dmitry and Andrey can give good answers to your question.

Some time ago I was doing Linux kernel fuzzing with syzkaller on low memory
virtual machines (with KASAN and LOCKUP_DETECTOR enabled). I gave less than 1G
to each debian stretch VM. I didn't get any special deadlock caused by OOM.

Best regards,
Alexander
