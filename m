Return-Path: <kernel-hardening-return-17054-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id B05AEDCD1B
	for <lists+kernel-hardening@lfdr.de>; Fri, 18 Oct 2019 19:55:22 +0200 (CEST)
Received: (qmail 15567 invoked by uid 550); 18 Oct 2019 17:54:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 1540 invoked from network); 18 Oct 2019 17:36:13 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X/WE+Ltkav02W5Zb5upG5+z14WBcxmzY6UajsHAAkG8=;
        b=rqUeUBF2GjWBXilazZj9859Wfei7InxGqjTwVagtcsCAMDedJITzk/dHkG81u/5B25
         Gan6lZGpmCBzOPsFbOcLdMfJHcanUI3ep3+QI28fjn1kEs0jS+efCiF08LN3Uhod55ul
         o8MP7rP7XrPgS4JSx27FU21kQ12QN3Wjs/CPcWCMbRpii0kbteuK5/OL7iTAWeDLTvWA
         jsB/YzyHAUd/9ZRrx4gkDsHmik9l/UDkv60LU9h8R7oCv8bO6FmJh0SKGXfbqcmhOOuj
         TsDMzO/cgJUDzggj3lyoH43dj6kglYl7LaJ+KzJCv+UJh/CE9CVwdjB4QV3MViu23LeS
         hq6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X/WE+Ltkav02W5Zb5upG5+z14WBcxmzY6UajsHAAkG8=;
        b=h6g51p3A3wuhDMfi3b+kXI5yFsjoFm0/ROusN0EIBapsNAADgM1pWHOZilfpYeElJJ
         z98D0UlsDnbZ2wU+wgAd6SuALHtsTHC+vZF+ovmN+M4ZVGr1uPdueTBMS1e7yn0dSLR9
         l6SkhwkNXRmCHrpREcl7WKhXQEZzagEZNou+QgaL5bZ6a7bQOLai+Nppu7JftCwcBU4q
         1KortbG3VhqRgeNm7yTNeRvpojIFWQuZPFRHPDtaFxMVLQWChZBMAwE4Dx60cZtQwBAO
         MvdLRFd186kb3XE1gn/aaBQMzICDI27tFZDQoszIjD8gaOMX3PoMZqLr04gCdNPKxPjv
         wHYw==
X-Gm-Message-State: APjAAAXNtnqf0Z75peMKa7hRqfhcggFXtby8TVe/XWYy4l9J6c2EgDWX
	KdSFYZ9FELnyaTqI//Ap+OnnEgL7LbpnUynX7DWqVA==
X-Google-Smtp-Source: APXvYqyF6j/BTFaba8M4VvcJmblj6dt3v+IOFiO9LsV/Gfg5OdquXzqLTFgu5d+0ejdtz8qWcSto/Fr46l8MKCQgdZE=
X-Received: by 2002:a1f:a8c8:: with SMTP id r191mr6141200vke.35.1571420160894;
 Fri, 18 Oct 2019 10:36:00 -0700 (PDT)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191018161033.261971-19-samitolvanen@google.com> <CAG48ez2Z8=0__eoQ+Ekp=EApawZXR4ec_xd2TVPQExLoyMwtRQ@mail.gmail.com>
 <20191018172309.GB18838@lakrids.cambridge.arm.com>
In-Reply-To: <20191018172309.GB18838@lakrids.cambridge.arm.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Fri, 18 Oct 2019 10:35:49 -0700
Message-ID: <CABCJKue27Aba_MJqB68Bh282zyL=LSQSBXV5TAb-NfsOAqJRnQ@mail.gmail.com>
Subject: Re: [PATCH 18/18] arm64: implement Shadow Call Stack
To: Mark Rutland <mark.rutland@arm.com>
Cc: Jann Horn <jannh@google.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Dave Martin <Dave.Martin@arm.com>, 
	Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, 
	Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, 
	kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Oct 18, 2019 at 10:23 AM Mark Rutland <mark.rutland@arm.com> wrote:
> I think scs_save() would better live in assembly in cpu_switch_to(),
> where we switch the stack and current. It shouldn't matter whether
> scs_load() is inlined or not, since the x18 value _should_ be invariant
> from the PoV of the task.

Note that there's also a call to scs_save in cpu_die, because the
current task's shadow stack pointer is only stored in x18 and we don't
want to lose it.

> We just need to add a TSK_TI_SCS to asm-offsets.c, and then insert a
> single LDR at the end:
>
>         mov     sp, x9
>         msr     sp_el0, x1
> #ifdef CONFIG_SHADOW_CALL_STACK
>         ldr     x18, [x1, TSK_TI_SCS]
> #endif
>         ret

TSK_TI_SCS is already defined, so yes, we could move this to
cpu_switch_to. I would still prefer to have the overflow check that's
in scs_thread_switch though.

Sami
