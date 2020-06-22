Return-Path: <kernel-hardening-return-19048-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id DE3F8204447
	for <lists+kernel-hardening@lfdr.de>; Tue, 23 Jun 2020 01:07:30 +0200 (CEST)
Received: (qmail 22221 invoked by uid 550); 22 Jun 2020 23:07:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 22185 invoked from network); 22 Jun 2020 23:07:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=z20zxmu7BXaJTc0tzUXoDHwEuwGLB9cwURxhD+oh4+g=;
        b=XG1VeH52GZUyvhcE9tbM4IoixaqvBmVHBTbaAPa1sHlwz6UTK5qC09lefX0IGKu1sw
         vcczs5K9f5eGPiFG77ESmvfY4NW193Q4M2tAwPqTwmKe/Aw8vn4j561cnqYHf7qIoFQz
         RUWRINhgB754vJIqeOOwfgYGnA7h4+Ot4qxfo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=z20zxmu7BXaJTc0tzUXoDHwEuwGLB9cwURxhD+oh4+g=;
        b=HUmv8ZysgHyA7O0q0/95Cdp+n5J9jkWaLkrMkl5zGkUjw03gakxEkIuibfKOuIRhaE
         ZJxHlPtwOqkYyX+0GDuEMk6ZXCuJBciZaL2+nAx9F1AZJZ9bR/vpS8l8IKfNHQCBHj//
         JN/QZ2eAdxo5/pRWTqV8jfOAzo1T+xkZcJ2OJ2M6B5L05hjBmyMAZ83P/Ti0SHXgFklc
         QN1daL00B4FOJ78OfK9K9zyzHwpSGR5FCoVgDt/GBFsPaWpQiFn8AE1IvTe6hHgEHC9m
         4XnQ4dCPbhWPdKfVs1vPa9h6DAJgnitEhm+U2SKECab9bHz2IF1QMhCubx6UChlH9ssI
         MN3w==
X-Gm-Message-State: AOAM530aI2glb9yF1iWg46+1UzNXD5KUwsJNSqDChE2C24QNyecuK/4y
	tBSKrPWjoG743unhvW94QXcCoA==
X-Google-Smtp-Source: ABdhPJx/PfvGuvPHST8NkvXqx8YdMlxhEJDw3qi2G3DLjazOqp+Vo/e1zvIb/b99UCM7dwt0/xj29g==
X-Received: by 2002:a17:902:7611:: with SMTP id k17mr21505128pll.255.1592867232960;
        Mon, 22 Jun 2020 16:07:12 -0700 (PDT)
Date: Mon, 22 Jun 2020 16:07:11 -0700
From: Kees Cook <keescook@chromium.org>
To: Arvind Sankar <nivedita@alum.mit.edu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Elena Reshetova <elena.reshetova@intel.com>, x86@kernel.org,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Alexander Potapenko <glider@google.com>,
	Alexander Popov <alex.popov@linux.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Jann Horn <jannh@google.com>, kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/5] stack: Optionally randomize kernel stack offset
 each syscall
Message-ID: <202006221604.871B13DE3@keescook>
References: <20200622193146.2985288-1-keescook@chromium.org>
 <20200622193146.2985288-4-keescook@chromium.org>
 <20200622225615.GA3511702@rani.riverdale.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200622225615.GA3511702@rani.riverdale.lan>

On Mon, Jun 22, 2020 at 06:56:15PM -0400, Arvind Sankar wrote:
> On Mon, Jun 22, 2020 at 12:31:44PM -0700, Kees Cook wrote:
> > +
> > +#define add_random_kstack_offset() do {					\
> > +	if (static_branch_maybe(CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT,	\
> > +				&randomize_kstack_offset)) {		\
> > +		u32 offset = this_cpu_read(kstack_offset);		\
> > +		u8 *ptr = __builtin_alloca(offset & 0x3FF);		\
> > +		asm volatile("" : "=m"(*ptr));				\
> > +	}								\
> > +} while (0)
> 
> This feels a little fragile. ptr doesn't escape the block, so the
> compiler is free to restore the stack immediately after this block. In
> fact, given that all you've said is that the asm modifies *ptr, but
> nothing uses that output, the compiler could eliminate the whole thing,
> no?
> 
> https://godbolt.org/z/HT43F5
> 
> gcc restores the stack immediately, if no function calls come after it.
> 
> clang completely eliminates the code if no function calls come after.

nothing uses the stack in your example. And adding a barrier (which is
what the "=m" is, doesn't change it.

> I'm not sure why function calls should affect it, though, given that
> those functions can't possibly access ptr or the memory it points to.

It seems to work correctly:
https://godbolt.org/z/c3W5BW

-- 
Kees Cook
