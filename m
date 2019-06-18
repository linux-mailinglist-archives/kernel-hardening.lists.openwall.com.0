Return-Path: <kernel-hardening-return-16183-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 6E1094A0B8
	for <lists+kernel-hardening@lfdr.de>; Tue, 18 Jun 2019 14:25:00 +0200 (CEST)
Received: (qmail 5139 invoked by uid 550); 18 Jun 2019 12:24:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 4083 invoked from network); 18 Jun 2019 12:24:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	 bh=tD8Ldis1b1ybeeBuDIwXZsiRf2P3qbbvUlnCoUXwyuY=; b=NAEDJY2YdVxbiTrefTEuYU5Ti
	H/iWv7twG2VncqxpEZ4HA9OiOOSv8QEjwievCiXzhW/NSGfcW/vzV52+aDKkIiNusXXiAF+DNWkTY
	tIi9K4wjN9c191xRkQv3VFdN9ZmA1NyXfKlEBMakvFL+zpjrLT8AxUtW/cKyrNUAVWXkDYkj8Claj
	J7003OnUSqDZwVB6YyRMLERu8/3iIubOn9bCpKNZgaKCCctS982Ivx6+yk77k/TduV8XJ4Xav6ySs
	ghrnWuHcHMe+jBR9qyUGaC8JqHrlvmUN/4AHGMfBs7YIWfs+NWFNLPr3hVX+X7g+DOZXmExLzZOl7
	qOovV3u0w==;
Date: Tue, 18 Jun 2019 14:24:30 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jann Horn <jannh@google.com>
Cc: Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	the arch/x86 maintainers <x86@kernel.org>,
	Dave Hansen <dave.hansen@intel.com>,
	kernel list <linux-kernel@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: [PATCH v3 3/3] x86/asm: Pin sensitive CR0 bits
Message-ID: <20190618122430.GF3419@hirez.programming.kicks-ass.net>
References: <20190618045503.39105-1-keescook@chromium.org>
 <20190618045503.39105-4-keescook@chromium.org>
 <CAG48ez37iY3pfTWn4wiqdt7zdkSPpOcvz3gtwjTWAYz9qKbBNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez37iY3pfTWn4wiqdt7zdkSPpOcvz3gtwjTWAYz9qKbBNA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Jun 18, 2019 at 11:38:02AM +0200, Jann Horn wrote:
> On Tue, Jun 18, 2019 at 6:55 AM Kees Cook <keescook@chromium.org> wrote:
> > With sensitive CR4 bits pinned now, it's possible that the WP bit for
> > CR0 might become a target as well. Following the same reasoning for
> > the CR4 pinning, this pins CR0's WP bit (but this can be done with a
> > static value).
> >
> > Suggested-by: Peter Zijlstra <peterz@infradead.org>
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > ---
> >  arch/x86/include/asm/special_insns.h | 15 ++++++++++++++-
> >  1 file changed, 14 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/include/asm/special_insns.h b/arch/x86/include/asm/special_insns.h
> > index c8c8143ab27b..b2e84d113f2a 100644
> > --- a/arch/x86/include/asm/special_insns.h
> > +++ b/arch/x86/include/asm/special_insns.h
> > @@ -31,7 +31,20 @@ static inline unsigned long native_read_cr0(void)
> >
> >  static inline void native_write_cr0(unsigned long val)
> >  {
> 
> So, assuming a legitimate call to native_write_cr0(), we come in here...
> 
> > -       asm volatile("mov %0,%%cr0": : "r" (val), "m" (__force_order));
> > +       unsigned long bits_missing = 0;

^^^

> > +
> > +set_register:
> > +       asm volatile("mov %0,%%cr0": "+r" (val), "+m" (__force_order));
> 
> ... here we've updated CR0...
> 
> > +       if (static_branch_likely(&cr_pinning)) {
> 
> ... this branch is taken, since cr_pinning is set to true after boot...
> 
> > +               if (unlikely((val & X86_CR0_WP) != X86_CR0_WP)) {
> 
> ... this branch isn't taken, because a legitimate update preserves the WP bit...
> 
> > +                       bits_missing = X86_CR0_WP;

^^^

> > +                       val |= bits_missing;
> > +                       goto set_register;
> > +               }
> > +               /* Warn after we've set the missing bits. */
> > +               WARN_ONCE(bits_missing, "CR0 WP bit went missing!?\n");
> 
> ... and we reach this WARN_ONCE()? Am I missing something, or does
> every legitimate CR0 write after early boot now trigger a warning?

bits_missing will be 0 and WARN will not be issued.

> > +       }
> >  }
