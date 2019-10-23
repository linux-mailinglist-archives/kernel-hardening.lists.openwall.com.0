Return-Path: <kernel-hardening-return-17096-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 045D6E2134
	for <lists+kernel-hardening@lfdr.de>; Wed, 23 Oct 2019 18:59:40 +0200 (CEST)
Received: (qmail 9398 invoked by uid 550); 23 Oct 2019 16:59:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 9377 invoked from network); 23 Oct 2019 16:59:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oiXTugK+glDXdJjZWJtXYSMgUR2uLVi/MAVMaB3F35U=;
        b=NQgD49Nz1FMbQT18HMLMCXz8AgV0WCkf006/YUznJf+3Ipz7NMjqeC2D/k5EAlN0/t
         nJVzfXQMkmOEB0gib3vBf8erowFTJOm5qjJaOs1Eb/RW6pzbK2BDP79mM6rksf9Y8+aj
         BJ0DPjReMffW5qFqvs/6b+ugvel1yOtCyIGIh/ClbZONxGCVxVbdNSXeTSCweh3hL9cu
         Vz0voRu/R6+IY98n6jLUZeKwAjG1FEibO0VIHstd/fmjmeYU0EmyWqWiyBvrGV7Tdguu
         n+UiY/XMLvkLH23E9uESUscCmkQ47unt7KrZbMWIK40hjbUz+Z7oCm/X+x38XKXz8RBw
         +LyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oiXTugK+glDXdJjZWJtXYSMgUR2uLVi/MAVMaB3F35U=;
        b=NsQGsTJa5LVmIpLfYmBgyjgQvpbHuTj3kOGeYEr0nRNdu/hZz7JT/WHbW/DCqm0YBV
         XmfxnBGsGFwvi0qhrrdVP18eRY6vJurD6oQgpPH4i/povkO1VgXnaGnRcT5YSB0BjGpc
         RyBEUUPyziN5hZ1UwkCglwZONVzuJOHMinugtQGLLecos39gbwqmFeeKZThz9W4pmvaQ
         zJahdb/74P8zAVjA5mV5sf4tiMPg7b8jVmI2fWdzfU6Nag1LumOUs2kRqDMLW7wLgLX4
         plGl0Geohy9wyx+54zNzH1Q6US/FNh9OvWDh2Ip2atNSq1iSx/cRDfxj4Em0t2yD1XNf
         7M4g==
X-Gm-Message-State: APjAAAUWy2pdRODQc8401Sn4ad3YE/akFgJpN5gGV9TicBlQxV4gSEXi
	RoywP3wQ6/Di7vNpJlUFr6kWCX04OHHuopQBinzwOA==
X-Google-Smtp-Source: APXvYqwpR9GdHU5UA4nzyjfo+qvuhnpsktbqKSujsET0zjiSwqQ8iK3jjEiXPXLcBxBc59n7vUzXDYX4PbBLe56acZ4=
X-Received: by 2002:a1f:b202:: with SMTP id b2mr6005570vkf.59.1571849961694;
 Wed, 23 Oct 2019 09:59:21 -0700 (PDT)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191018161033.261971-7-samitolvanen@google.com> <20191022162826.GC699@lakrids.cambridge.arm.com>
In-Reply-To: <20191022162826.GC699@lakrids.cambridge.arm.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Wed, 23 Oct 2019 09:59:09 -0700
Message-ID: <CABCJKudsD6jghk4i8Tp4aJg0d7skt6sU=gQ3JXqW8sjkUuX7vA@mail.gmail.com>
Subject: Re: [PATCH 06/18] add support for Clang's Shadow Call Stack (SCS)
To: Mark Rutland <mark.rutland@arm.com>, Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, 
	Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, Oct 22, 2019 at 9:28 AM Mark Rutland <mark.rutland@arm.com> wrote:
> I think it would be preferable to follow the example of CC_FLAGS_FTRACE
> so that this can be filtered out, e.g.
>
> ifdef CONFIG_SHADOW_CALL_STACK
> CFLAGS_SCS := -fsanitize=shadow-call-stack
> KBUILD_CFLAGS += $(CFLAGS_SCS)
> export CC_FLAGS_SCS
> endif
>
> ... with removal being:
>
> CFLAGS_REMOVE := $(CC_FLAGS_SCS)
>
> ... or:
>
> CFLAGS_REMOVE_obj.o := $(CC_FLAGS_SCS)
>
> That way you only need to define the flags once, so the enable and
> disable falgs remain in sync by construction.

CFLAGS_REMOVE appears to be only implemented for objects, which means
there's no convenient way to filter out flags for everything in
arch/arm64/kvm/hyp, for example. I could add a CFLAGS_REMOVE
separately for each object file, or we could add something like
ccflags-remove-y to complement ccflags-y, which should be relatively
simple. Masahiro, do you have any suggestions?

Sami
