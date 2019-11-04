Return-Path: <kernel-hardening-return-17276-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 2C3F5EEB4B
	for <lists+kernel-hardening@lfdr.de>; Mon,  4 Nov 2019 22:38:59 +0100 (CET)
Received: (qmail 24219 invoked by uid 550); 4 Nov 2019 21:38:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 24199 invoked from network); 4 Nov 2019 21:38:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=erA0+CgO32nkALAW/U97P1GwaRL1ou+VA5YnrGmuWIY=;
        b=AMgSst2hoIv0GZSG/6Hv3sj7G4QTMHoXZaK+uecCN92VkYk2ZpXGLlGKNE7LaQkMOV
         GALbiSTH4QXZuxCs4vXVQ+PvBEvuBmB7k5aqf+G9gnmvHWB5/Y+uNebLr8WkNd+bS+Ov
         /XXES1wI9li/uMeZkpl2e89se5snh4JkYGrWHWMFeboxhZVboLE1Ab4qQKsBrgjgaJ0Z
         TPALZl6SFGfHwCWeRXmzVYpIwJ+aRCFQbHaYCGtjIRAIEY7ObGDK19pVPN3DP2bzseFq
         kO3Sq+THrsVH8U3L8DmX49sKk84SksyJMDaTiPQHmYPUwA9Od1QsJS2NmYqwVYjSpzCB
         i+5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=erA0+CgO32nkALAW/U97P1GwaRL1ou+VA5YnrGmuWIY=;
        b=tLZZbNAJvhGe0xn+4Ve2gTPY4xwBnQKH1ZnoEzwsJhuX9FBu/3Q9+yt2//mda5VZCL
         v5yLsC7OoILdkIKosVldy2e4kqCyCfo8Nw7nDKNanwlIEnAtRoMyFT1XhqFglh83zmBY
         97uo2FE0ZC9Tb24ZlhnNsaW8etyxrJF2iMnMcimZMPnKCCoxeA3np1mP5hLix+soRn+c
         pR42+ojzElB1SNpt332lkp2hos3z6reisK9nTEGpygztJadWouYgCSahvjnlIxD0aGL/
         /CcWAebcdCkdpHTmaGAAUpUqrlhKBAvDH2c7qpHaCy6IoKiYOmVX0M3HhgZmHoNFdm22
         3xNg==
X-Gm-Message-State: APjAAAWTtjLFCkPf4o6GuFFn/wnJUlUV1Oerd+d05hjknEux08l5wWxU
	+U9aCB3NrFmm0v1jy8+K0q3FIZaVRQw48xcoOd+buQ==
X-Google-Smtp-Source: APXvYqwHIA8tjMB/idsGTHUTWfDb2R4/Q6AYLqiE/ovPTmnmanOsh2FI1AtdGkwKNIfH3EsSyXxnypTSqw/H2MHfj8Y=
X-Received: by 2002:a1f:7d88:: with SMTP id y130mr12696794vkc.71.1572903521740;
 Mon, 04 Nov 2019 13:38:41 -0800 (PST)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191101221150.116536-1-samitolvanen@google.com> <20191101221150.116536-14-samitolvanen@google.com>
 <02c56a5273f94e9d832182f1b3cb5097@www.loen.fr>
In-Reply-To: <02c56a5273f94e9d832182f1b3cb5097@www.loen.fr>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Mon, 4 Nov 2019 13:38:30 -0800
Message-ID: <CABCJKucVON6uUMH6hVP7RODqH8u63AP3SgTCBWirrS30yDOmdA@mail.gmail.com>
Subject: Re: [PATCH v4 13/17] arm64: preserve x18 when CPU is suspended
To: Marc Zyngier <maz@kernel.org>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Dave Martin <dave.martin@arm.com>, 
	Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, 
	Mark Rutland <mark.rutland@arm.com>, Nick Desaulniers <ndesaulniers@google.com>, 
	Jann Horn <jannh@google.com>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, Nov 4, 2019 at 5:20 AM Marc Zyngier <maz@kernel.org> wrote:
> >  ENTRY(cpu_do_suspend)
> >       mrs     x2, tpidr_el0
> > @@ -73,6 +75,9 @@ alternative_endif
> >       stp     x8, x9, [x0, #48]
> >       stp     x10, x11, [x0, #64]
> >       stp     x12, x13, [x0, #80]
> > +#ifdef CONFIG_SHADOW_CALL_STACK
> > +     str     x18, [x0, #96]
> > +#endif
>
> Do we need the #ifdefery here? We didn't add that to the KVM path,
> and I'd feel better having a single behaviour, specially when
> NR_CTX_REGS is unconditionally sized to hold 13 regs.

I'm fine with dropping the ifdefs here in v5 unless someone objects to this.

Sami
