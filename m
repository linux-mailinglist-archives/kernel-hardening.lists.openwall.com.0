Return-Path: <kernel-hardening-return-16184-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 1B9534A7F1
	for <lists+kernel-hardening@lfdr.de>; Tue, 18 Jun 2019 19:13:20 +0200 (CEST)
Received: (qmail 9682 invoked by uid 550); 18 Jun 2019 17:13:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 9649 invoked from network); 18 Jun 2019 17:13:12 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8dfHJTcLRV8CC1mU6B4Yjhb5Vh1wRhQVUvut0lc2uNw=;
        b=mbMHRGKIlQDxbHcba0Ej6Fw/3WXDqNBISRpyYauUMAwFrj9x3zRQ0crkJLJBmtD9SC
         e/XpkcddKgQfCxNWz9pWl3k0vJxjwAqWKq1Mxm7Gh+NM4U5Hcxp17f/sMWkxYTkPwgUv
         p9lUUjvxkAqHt/oYiRNGpEhGsjurbAYxwyG3I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8dfHJTcLRV8CC1mU6B4Yjhb5Vh1wRhQVUvut0lc2uNw=;
        b=ExUg/Y1aJA5E7YiCvzJLhJE56giw9WlP4cbtxdprZMOEu9nJx+PRnc011xvqRW59jT
         xoYnAw/DSc7WZ2OlVXchVoxXhDuIFvSk5whzvWEqaRIca20z3qYln0CWW7IFesufz73T
         2bf/yX/2BolDc6Xy1lbTwiouF6Nd3+1Igcx3NDcpSbmz87g2csGYS4ZZKwMpLffvl4QQ
         z9/bvdF3/rPdS/u/DGpRIfYY1ozznItyr7jrR/5z2jTNlqLvnYaJC5Yia3g52SFV7tjl
         J6uOch8sDyO1M9gVbXZnbv1kECoTgpGcH5+3XuczIDPa3CFP7FAvbkaCdKrJyzpxXamh
         mVXQ==
X-Gm-Message-State: APjAAAXQh5Xd4TLmBd8nI90MsYXpBhyH5RfkkC1i4ZTUXzSopXJNvcz/
	C8Jex40JbVcph/1y6clT9pIvUw==
X-Google-Smtp-Source: APXvYqxV8NKnUFLTcZUcTOBY3j1D9IobFFuP7NnutOUhZzEvenssp4iBrpo3lTyuwqKyPxfqoDBojg==
X-Received: by 2002:a17:90a:aa0d:: with SMTP id k13mr5949863pjq.53.1560877980386;
        Tue, 18 Jun 2019 10:13:00 -0700 (PDT)
Date: Tue, 18 Jun 2019 10:12:58 -0700
From: Kees Cook <keescook@chromium.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jann Horn <jannh@google.com>, Thomas Gleixner <tglx@linutronix.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	the arch/x86 maintainers <x86@kernel.org>,
	Dave Hansen <dave.hansen@intel.com>,
	kernel list <linux-kernel@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: [PATCH v3 3/3] x86/asm: Pin sensitive CR0 bits
Message-ID: <201906181010.922CE96EC@keescook>
References: <20190618045503.39105-1-keescook@chromium.org>
 <20190618045503.39105-4-keescook@chromium.org>
 <CAG48ez37iY3pfTWn4wiqdt7zdkSPpOcvz3gtwjTWAYz9qKbBNA@mail.gmail.com>
 <20190618122430.GF3419@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190618122430.GF3419@hirez.programming.kicks-ass.net>

On Tue, Jun 18, 2019 at 02:24:30PM +0200, Peter Zijlstra wrote:
> On Tue, Jun 18, 2019 at 11:38:02AM +0200, Jann Horn wrote:
> > On Tue, Jun 18, 2019 at 6:55 AM Kees Cook <keescook@chromium.org> wrote:
> > > With sensitive CR4 bits pinned now, it's possible that the WP bit for
> > > CR0 might become a target as well. Following the same reasoning for
> > > the CR4 pinning, this pins CR0's WP bit (but this can be done with a
> > > static value).
> > >
> > > Suggested-by: Peter Zijlstra <peterz@infradead.org>
> > > Signed-off-by: Kees Cook <keescook@chromium.org>
> > > ---
> > >  arch/x86/include/asm/special_insns.h | 15 ++++++++++++++-
> > >  1 file changed, 14 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/arch/x86/include/asm/special_insns.h b/arch/x86/include/asm/special_insns.h
> > > index c8c8143ab27b..b2e84d113f2a 100644
> > > --- a/arch/x86/include/asm/special_insns.h
> > > +++ b/arch/x86/include/asm/special_insns.h
> > > @@ -31,7 +31,20 @@ static inline unsigned long native_read_cr0(void)
> > >
> > >  static inline void native_write_cr0(unsigned long val)
> > >  {
> > 
> > So, assuming a legitimate call to native_write_cr0(), we come in here...
> > 
> > > -       asm volatile("mov %0,%%cr0": : "r" (val), "m" (__force_order));
> > > +       unsigned long bits_missing = 0;
> 
> ^^^
> 
> > > +
> > > +set_register:
> > > +       asm volatile("mov %0,%%cr0": "+r" (val), "+m" (__force_order));
> > 
> > ... here we've updated CR0...
> > 
> > > +       if (static_branch_likely(&cr_pinning)) {
> > 
> > ... this branch is taken, since cr_pinning is set to true after boot...
> > 
> > > +               if (unlikely((val & X86_CR0_WP) != X86_CR0_WP)) {
> > 
> > ... this branch isn't taken, because a legitimate update preserves the WP bit...
> > 
> > > +                       bits_missing = X86_CR0_WP;
> 
> ^^^
> 
> > > +                       val |= bits_missing;
> > > +                       goto set_register;
> > > +               }
> > > +               /* Warn after we've set the missing bits. */
> > > +               WARN_ONCE(bits_missing, "CR0 WP bit went missing!?\n");
> > 
> > ... and we reach this WARN_ONCE()? Am I missing something, or does
> > every legitimate CR0 write after early boot now trigger a warning?
> 
> bits_missing will be 0 and WARN will not be issued.
> 
> > > +       }
> > >  }

Yup, as Peter points out, bits_missing is only non-zero when bits went
missing. The normal case will skip the WARN_ONCE() (which is also
internally wrapped in unlikely()). And I would have noticed the very
loud WARN at every boot if this wasn't true. ;)

-- 
Kees Cook
