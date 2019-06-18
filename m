Return-Path: <kernel-hardening-return-16180-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 2EAA549D93
	for <lists+kernel-hardening@lfdr.de>; Tue, 18 Jun 2019 11:38:49 +0200 (CEST)
Received: (qmail 11327 invoked by uid 550); 18 Jun 2019 09:38:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 11295 invoked from network); 18 Jun 2019 09:38:42 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7fLDkKRkgzc7eE1dlOkMBAFp8cWuW8s86ixr8n9TiM8=;
        b=AmE9Y07JUBPxzGcD1J9f0LpoVT6BW4XFItWxQtWsq1bOY1uSmIME0YmGeM/JuFbck/
         mFMt7hKWfsAFi3I9jHY8FyMesDuRlcSkqWgUAvggg6+SIBx0jkwrKFPuGSs+2N6hVVrw
         up5JrKDu8F2SS9VITpTPV7YlmjOiBwrkYBWGe7B8hlglXyYjYFND8YLX4qfXfiL060Y0
         TnKu57Az1hM5oyh54Erg+zAJHBIEfPfm51z/MWNjRy0LuylnMJYM5JjwpPAwOgbqzEVV
         lor1NIUfbs7NPp+NyNQ5OsK/xDhaGmzixxZUM8eEJTFfp9YayDBVVCUnv9wjiRQ8u2Ti
         k3Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7fLDkKRkgzc7eE1dlOkMBAFp8cWuW8s86ixr8n9TiM8=;
        b=EEDmkvY+I89G5m5+G+541KFSTtGU1qGda/FDIaqRpPqkOXsmW4jjXEd5uKnrfOefZS
         lJs3QMCeW8suekY14Gz+YqT0Okiiu/f4+cDf9zZR54hTNZ7KFUy+egGsy7bVCiYt2yF1
         VGnXeFitXTAPmyP/IySSda39flyFDewbb7KHDPXBk38tCkt72BuvmERjTVhuKOljl4ay
         2jGv0Ki5b/g2ImTpcT1sWZQ8lwn7nR7XcJ0TTgmYG22lBBifXG0myvECAcg1Hs5+8wOz
         9+Lf67MG6F94zzC7Njncuvf8Q2XfSHih/lhwwJkJojmjo3UYK2m+n9yAHwNYIAufGpL1
         dYQA==
X-Gm-Message-State: APjAAAUJceuNBHhR9mAmseAaVUzwDS41VCW/pggYfFae9A8iFxq0W/kZ
	EYmtJSMys/Gf/RI56Ciz6qiMSs7gFqw+0tEow2NtUg==
X-Google-Smtp-Source: APXvYqzDTLUQp01oTuXLSmw8BKDNfkPPwQAiDJmWwDWKcEFSmmLud111OCXmNXIGf5wq52BLBj3yiVgE6U8RxoSEHSc=
X-Received: by 2002:a9d:12b7:: with SMTP id g52mr32902066otg.32.1560850708603;
 Tue, 18 Jun 2019 02:38:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190618045503.39105-1-keescook@chromium.org> <20190618045503.39105-4-keescook@chromium.org>
In-Reply-To: <20190618045503.39105-4-keescook@chromium.org>
From: Jann Horn <jannh@google.com>
Date: Tue, 18 Jun 2019 11:38:02 +0200
Message-ID: <CAG48ez37iY3pfTWn4wiqdt7zdkSPpOcvz3gtwjTWAYz9qKbBNA@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] x86/asm: Pin sensitive CR0 bits
To: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, 
	"the arch/x86 maintainers" <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Dave Hansen <dave.hansen@intel.com>, kernel list <linux-kernel@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Jun 18, 2019 at 6:55 AM Kees Cook <keescook@chromium.org> wrote:
> With sensitive CR4 bits pinned now, it's possible that the WP bit for
> CR0 might become a target as well. Following the same reasoning for
> the CR4 pinning, this pins CR0's WP bit (but this can be done with a
> static value).
>
> Suggested-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  arch/x86/include/asm/special_insns.h | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/include/asm/special_insns.h b/arch/x86/include/asm/special_insns.h
> index c8c8143ab27b..b2e84d113f2a 100644
> --- a/arch/x86/include/asm/special_insns.h
> +++ b/arch/x86/include/asm/special_insns.h
> @@ -31,7 +31,20 @@ static inline unsigned long native_read_cr0(void)
>
>  static inline void native_write_cr0(unsigned long val)
>  {

So, assuming a legitimate call to native_write_cr0(), we come in here...

> -       asm volatile("mov %0,%%cr0": : "r" (val), "m" (__force_order));
> +       unsigned long bits_missing = 0;
> +
> +set_register:
> +       asm volatile("mov %0,%%cr0": "+r" (val), "+m" (__force_order));

... here we've updated CR0...

> +       if (static_branch_likely(&cr_pinning)) {

... this branch is taken, since cr_pinning is set to true after boot...

> +               if (unlikely((val & X86_CR0_WP) != X86_CR0_WP)) {

... this branch isn't taken, because a legitimate update preserves the WP bit...

> +                       bits_missing = X86_CR0_WP;
> +                       val |= bits_missing;
> +                       goto set_register;
> +               }
> +               /* Warn after we've set the missing bits. */
> +               WARN_ONCE(bits_missing, "CR0 WP bit went missing!?\n");

... and we reach this WARN_ONCE()? Am I missing something, or does
every legitimate CR0 write after early boot now trigger a warning?

> +       }
>  }
