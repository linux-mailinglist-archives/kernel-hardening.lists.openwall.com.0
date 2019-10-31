Return-Path: <kernel-hardening-return-17207-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 97E6BEB633
	for <lists+kernel-hardening@lfdr.de>; Thu, 31 Oct 2019 18:35:22 +0100 (CET)
Received: (qmail 14294 invoked by uid 550); 31 Oct 2019 17:35:17 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 14266 invoked from network); 31 Oct 2019 17:35:16 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6vxne2J2U+zueRlGB+uihx88K5obGcz7JfVVNIfE6MI=;
        b=Zkd+dczqhPUCvaVxq3B8963P3V8Y9R+M6ldUJWVSSAWMYKxKqeHtnfr2PdTP/xQu2b
         M24kRR6f+BemlR/4Y0IvK/z1JsB3EOLUV7taiH84F2Ii6S/051a5P0kFaw58bDYFmRYl
         aNg+ivt2iWFLU8ljqbd20wQiN/S62lqFSuUkwS/f02KuHQnSP26/xslqjUm0PxnUl/nM
         qI0N36UakRSXzfSUr6wSxS+I2jAHofRSRz2rGKpUptLXuoFXn9q5tA4/x48cLuSowzWM
         m7sGquCCjWRdIn+Z2H+0+h0T7us+31n+XfF8IpapK82l/iCdOiiKW9oFk4wdTg6QArPU
         kr1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6vxne2J2U+zueRlGB+uihx88K5obGcz7JfVVNIfE6MI=;
        b=fVaMEwQgSpuutPDeM22ZiKPwGexfidWqN5j7kVf1Ik/yb3fzwBK1ihwIgD5z8X+27s
         F3sswqdci0nY8oPd6ULXAOWpo4n80vHB8KMp2czG3plcBx5hHneL1REhGeXDreJhlMB1
         TwxxHqs9aTskdd4vEqRvY6nTMfLgCISz0B30lt5CtS537IW3R/plzlEfACUXenc5OtOp
         shv67/smRnzRG/mb9Xjfd5AKlaJUDeRkUe+zLypK9T4c7xT8GzTjk8TnKYei7dp2rQUS
         Wc6vaJUx0m9HiBbb1qb0+xLT32yT22e12POS8JxvE7q3c/wpmT2uv+9wvQoVAP8HRXJD
         fFaA==
X-Gm-Message-State: APjAAAWmf++jnDAF5DJeyOE/DrOrhirG4LH0L8rwJa+x7McDtU32M60Q
	CFQgrZyLSlkmv98GPyjTvVs/UOnvEvFdYtGGxiDR/w==
X-Google-Smtp-Source: APXvYqz/lhCOKKkE7+XVjZtp5lyRajdclaBkyDSosLmDck7GxCYMMFfzkg348/A5b/zQnTjld0uu3Efy3NYsSqb59C8=
X-Received: by 2002:a17:90a:1f4b:: with SMTP id y11mr8889337pjy.123.1572543304777;
 Thu, 31 Oct 2019 10:35:04 -0700 (PDT)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191031164637.48901-1-samitolvanen@google.com> <20191031164637.48901-14-samitolvanen@google.com>
 <CAKwvOd=kcPS1CU=AUjOPr7SAipPFhs-v_mXi=AbqW5Vp9XUaiw@mail.gmail.com> <CABCJKudb2_OH5CRFm64rxv-VVnuOrO-ZOrXRHg8hR98Vj+BzVw@mail.gmail.com>
In-Reply-To: <CABCJKudb2_OH5CRFm64rxv-VVnuOrO-ZOrXRHg8hR98Vj+BzVw@mail.gmail.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Thu, 31 Oct 2019 10:34:53 -0700
Message-ID: <CAKwvOd=dO2QjiRWegjCtnMmVguaJ2YHacJRP3SbVVy9jhx-BWw@mail.gmail.com>
Subject: Re: [PATCH v3 13/17] arm64: preserve x18 when CPU is suspended
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Dave Martin <Dave.Martin@arm.com>, 
	Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, 
	Mark Rutland <mark.rutland@arm.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, Oct 31, 2019 at 10:27 AM Sami Tolvanen <samitolvanen@google.com> wrote:
>
> On Thu, Oct 31, 2019 at 10:18 AM Nick Desaulniers
> <ndesaulniers@google.com> wrote:
> > > +#ifdef CONFIG_SHADOW_CALL_STACK
> > > +       ldr     x18, [x0, #96]
> > > +       str     xzr, [x0, #96]
> >
> > How come we zero out x0+#96, but not for other offsets? Is this str necessary?
>
> It clears the shadow stack pointer from the sleep state buffer, which
> is not strictly speaking necessary, but leaves one fewer place to find
> it.

That sounds like a good idea.  Consider adding comments or to the
commit message so that the str doesn't get removed accidentally in the
future.
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
-- 
Thanks,
~Nick Desaulniers
