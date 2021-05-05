Return-Path: <kernel-hardening-return-21246-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 3A55F37481A
	for <lists+kernel-hardening@lfdr.de>; Wed,  5 May 2021 20:39:02 +0200 (CEST)
Received: (qmail 30421 invoked by uid 550); 5 May 2021 18:38:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 30384 invoked from network); 5 May 2021 18:38:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=POQGQj7ALoCPENTaHpI2WeLM1iSFaDi818aVBMGOLqw=;
        b=Db7y3p0IEKbFRtxFUuYHcc68qZZR873peN9d0aGG9tlw2rZmwTOGIz/dx5FTZ5Lphi
         6fuBUvVN2bTS1kqRzIhmnlmKpakG8unMK8hTv9EYWQRvwhYHW7AFphwdkFb7ZpM7neay
         rktKL9ozidaqOd0M8nj1aEFODm3v9hbv8k6+Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=POQGQj7ALoCPENTaHpI2WeLM1iSFaDi818aVBMGOLqw=;
        b=OT7lbr7kVzrGyTskd+H8b1Hek6P712MEtyD8wSkSvyWYyeYapy6QetkEl/wtaNkRS/
         YvWy8JC0psEw/Ugf95BxEzdrRx2mL1mN43KlUDAvKFT2HkNL3jSjMe+r4FmpyyqAr67d
         KGtiEnO39ZMXdQlgnIVi5eVUjBG7wET7mM1q25lvD4JXYznb/2Hj4p3qvxoluDA5peml
         hjmXrtQA4x7Vb+VJJzJ5zV5V3wZhBFljZnBK6otKtuWbVQd0CMvL733Oh4KiDVc8wTm/
         0oi1sVb92oE1fQ8TRRT0673aXSN0wpPYRsltjsq5BkbK5nsreTxAVfvr8FlQJlpfbDul
         YaJA==
X-Gm-Message-State: AOAM531g6FOVIye0iV8X87R7G6MG9hObU4h8H+NUlRrTtdqTWuCz9ytE
	vSNyf5ljYmahQRi6u3jJmhuT8A==
X-Google-Smtp-Source: ABdhPJxiN86yOamEdzSsvtrqNATfjczZniozKJJExXyIhzlZO4VwUnelTWDRAcgOFOWnS4+Z9USU8g==
X-Received: by 2002:a17:90a:302:: with SMTP id 2mr13376430pje.34.1620239921095;
        Wed, 05 May 2021 11:38:41 -0700 (PDT)
Date: Wed, 5 May 2021 11:38:39 -0700
From: Kees Cook <keescook@chromium.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, dave.hansen@intel.com,
	luto@kernel.org, linux-mm@kvack.org, x86@kernel.org,
	akpm@linux-foundation.org, linux-hardening@vger.kernel.org,
	kernel-hardening@lists.openwall.com, ira.weiny@intel.com,
	rppt@kernel.org, dan.j.williams@intel.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 0/9] PKS write protected page tables
Message-ID: <202105051132.7958C3B@keescook>
References: <20210505003032.489164-1-rick.p.edgecombe@intel.com>
 <202105042253.ECBBF6B6@keescook>
 <YJJZSdVoP6yBbIjN@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJJZSdVoP6yBbIjN@hirez.programming.kicks-ass.net>

On Wed, May 05, 2021 at 10:37:29AM +0200, Peter Zijlstra wrote:
> On Tue, May 04, 2021 at 11:25:31PM -0700, Kees Cook wrote:
> 
> > It looks like PKS-protected page tables would be much like the
> > RO-protected text pages in the sense that there is already code in
> > the kernel to do things to make it writable, change text, and set it
> > read-only again (alternatives, ftrace, etc).
> 
> We don't actually modify text by changing the mapping at all. We modify
> through a writable (but not executable) temporary alias on the page (on
> x86).
> 
> Once a mapping is RX it will *never* be writable again (until we tear it
> all down).

Yes, quite true. I was trying to answer the concern about "is it okay
that there is a routine in the kernel that can write to page tables
(via temporary disabling of PKS)?" by saying "yes, this is fine -- we
already have similar routines in the kernel that bypass memory
protections, and that's okay because the defense is primarily about
blocking flaws that allow attacker-controlled writes to be used to
leverage greater control over kernel state, of which the page tables are
pretty central. :)

-- 
Kees Cook
