Return-Path: <kernel-hardening-return-17040-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id C2386DCBE1
	for <lists+kernel-hardening@lfdr.de>; Fri, 18 Oct 2019 18:49:51 +0200 (CEST)
Received: (qmail 13921 invoked by uid 550); 18 Oct 2019 16:49:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 13900 invoked from network); 18 Oct 2019 16:49:46 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6mKQPL/e7dgXDTrUQfJTszcQHu3ycRwNWrvUbHLb4pk=;
        b=avwoHFY5CW3JD7pFCn4n29wE6NiGHkirgHDoIVifZVsZL4y+SlMfOxesI682OTDpPr
         fFMjgep4cFlosOsjjEllbB10AlrvG3W2M8so8tnovxudL3Fnr2jRYL3m20YfhXFXiql4
         YYV2FAqAxa1SUnQUjrvRBLsJzPigiZyieER9bEuAyzFDDpqgXg0PS7F91qEI3rZASNj/
         x1S9cd0eWsR188TqUpS+/Mmf/vhy38JniOEz/ZK0Uhw6NKJX4sswW0+SOrWYXCeoqTVW
         NuHBVQntzhM2hJG8H38DUhHoPaoGsnAGtVvqyZ7liKevC5AP2i2yiIximEnQJ18clNZ6
         PqSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6mKQPL/e7dgXDTrUQfJTszcQHu3ycRwNWrvUbHLb4pk=;
        b=LNNuyoUwd9H4kdq0Z05enu54LE66EQoNGv9XjzVTEEpz0xPoFdH/8sVbZwH+zD0Yoh
         s5oeBJfg3JkvoVFBgS8apRo/dBprcs7sxt3qHHL1n7NEHTjsY2HR/s0eiobJih/lQmgr
         +GW+1BAuN0UIUTtHU4Jeieb73pfS4QoRsccwH+IdrlpG7GxrA6zva9M8qhcvGr7D3FcQ
         mnVYq5g8PThBZiSNo0lZ5VQT7w6THjLWwNOhnQmu79fUSnsporzb9TIYGy3qH1ELhQZC
         W1lXexctcMeFNO4xJLS9JcOWF2MWzz1iTRQFICcOaWuO3UpZSlTWGhSciQtC+N+rDaRc
         gTqw==
X-Gm-Message-State: APjAAAWKhSeN5wd5fyP6W/d/TU+QVCNQSPWz4ARoiHg85MGOEte2Jzxj
	AkC9rdk3nYq9/qbtKw5SgT9x2bBPf3Qh9ZEvJ2EVmQ==
X-Google-Smtp-Source: APXvYqwGHsfE+gcGNX/CNr6xsUAMOGd4jaqDKhx5i50DIeOxIYrr7yFluB8PcrxyB5XuOda6b/Qeh6/IFkeALLNCeCw=
X-Received: by 2002:a17:90a:b285:: with SMTP id c5mr12166608pjr.123.1571417373841;
 Fri, 18 Oct 2019 09:49:33 -0700 (PDT)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20191018161033.261971-14-samitolvanen@google.com>
In-Reply-To: <20191018161033.261971-14-samitolvanen@google.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Fri, 18 Oct 2019 09:49:22 -0700
Message-ID: <CAKwvOd=7g2zbGpL41KC=VgapTYYd7-XqFxf+WQUyHVVJSMq=5A@mail.gmail.com>
Subject: Re: [PATCH 13/18] arm64: preserve x18 when CPU is suspended
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, 
	Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, kernel-hardening@lists.openwall.com, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Oct 18, 2019 at 9:11 AM Sami Tolvanen <samitolvanen@google.com> wrote:
>
> Don't lose the current task's shadow stack when the CPU is suspended.
>
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> ---
>  arch/arm64/mm/proc.S | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
> index fdabf40a83c8..9a8bd4bc8549 100644
> --- a/arch/arm64/mm/proc.S
> +++ b/arch/arm64/mm/proc.S
> @@ -73,6 +73,9 @@ alternative_endif
>         stp     x8, x9, [x0, #48]
>         stp     x10, x11, [x0, #64]
>         stp     x12, x13, [x0, #80]
> +#ifdef CONFIG_SHADOW_CALL_STACK
> +       stp     x18, xzr, [x0, #96]

Could this be a str/ldr of just x18 rather than stp/ldp of x18 +
garbage?  Maybe there's no real cost difference, or some kind of
alignment invariant?

> +#endif
>         ret
>  ENDPROC(cpu_do_suspend)
>
> @@ -89,6 +92,9 @@ ENTRY(cpu_do_resume)
>         ldp     x9, x10, [x0, #48]
>         ldp     x11, x12, [x0, #64]
>         ldp     x13, x14, [x0, #80]
> +#ifdef CONFIG_SHADOW_CALL_STACK
> +       ldp     x18, x19, [x0, #96]
> +#endif
>         msr     tpidr_el0, x2
>         msr     tpidrro_el0, x3
>         msr     contextidr_el1, x4
> --
> 2.23.0.866.gb869b98d4c-goog
>


-- 
Thanks,
~Nick Desaulniers
