Return-Path: <kernel-hardening-return-18926-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 014CD1EE639
	for <lists+kernel-hardening@lfdr.de>; Thu,  4 Jun 2020 16:02:17 +0200 (CEST)
Received: (qmail 21768 invoked by uid 550); 4 Jun 2020 14:02:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 21743 invoked from network); 4 Jun 2020 14:02:09 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RyahCwj7GWFMqqvRbPUi/TlPiAHD4KqpSE60TAEaL9A=;
        b=gjHkdzUMhdyHJkapNYoxi9E/bvX0FBFiSvfqIhYHEmYQTT7TsTNlVhAesWRAL7isYP
         lsna+Fr7cHbRtH48eiLL8jfUvf8a5+6nuqcuxFZt/wGr1wGuhifGi+ylwfCLPZBAO82I
         Q3OvNuGkRmpIli8heThK0uGKWFAxsAIWwF1U54EWDKNOJlKtVaXqUX+JzWrUVavBKvqB
         iFXYlKgXAdF4Q95WyKBxD8X1AdyHA5WeZRKC8nk2uz5BDKsKTZl+l3QGpqv+NeShBwcv
         eMXXQFW75HJDx5wd1ToS/HhRrjtFKP+7hSfuFsfKEYeHvp1RvkiP5BS3ZElqqVJpanMo
         9Pig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RyahCwj7GWFMqqvRbPUi/TlPiAHD4KqpSE60TAEaL9A=;
        b=l+i0bYleOUxbL65A5mUnHT9RTWbA9lYS4Sy57HH/XNhtq1zN9/7xg8I9k143ilw/To
         33OmyiztLSb8QgkTDEzaeJXWypD5OcEDqGHfmlRpONSR8XNuz2DL9v3I1b0DjKDjuIMB
         Nn8wF2Ln/XzK373xHuNcq3LtR3fmaGHAmY52nhgSxpAM2npej3pcCGDo+ZRSVMYVZtQ+
         5/Umjl6Fl2SWjG0PHX+mYo+hKIURWbfXYkGwCIHlNkonz41n1ceijQrDZHPNY9cxRqcM
         GHN2mhbJK5vWIRULvvkXEK0btnFBpO/JQ5ay92UnKNGAw58OsLaHA4SZBI415X0vUBIj
         kSxg==
X-Gm-Message-State: AOAM532Omivb74YfokidpenX7rtIwfjlgNOgDS0vPK4jthgD4/7V9MFV
	zM/jN/fyBted6ggppo8nwcugrjKZ6KTmRbPe6AtdMA==
X-Google-Smtp-Source: ABdhPJwB31t3SsgcUaqovXgGt8jFxRPQdX0SXfXfNcrhI263Zb2nRLIjrQ392jUb57HBWnL6OVG/nj7aV6lYdX+datU=
X-Received: by 2002:a19:cb92:: with SMTP id b140mr2706702lfg.63.1591279318209;
 Thu, 04 Jun 2020 07:01:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200604134957.505389-1-alex.popov@linux.com> <20200604134957.505389-2-alex.popov@linux.com>
In-Reply-To: <20200604134957.505389-2-alex.popov@linux.com>
From: Jann Horn <jannh@google.com>
Date: Thu, 4 Jun 2020 16:01:30 +0200
Message-ID: <CAG48ez05JOvqzYGr3PvyQGwFURspFWvNvf-b8Y613PX0biug8w@mail.gmail.com>
Subject: Re: [PATCH 1/5] gcc-plugins/stackleak: Exclude alloca() from the
 instrumentation logic
To: Alexander Popov <alex.popov@linux.com>, Kees Cook <keescook@chromium.org>, 
	Elena Reshetova <elena.reshetova@intel.com>
Cc: Emese Revfy <re.emese@gmail.com>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, Michal Marek <michal.lkml@markovi.net>, 
	Andrew Morton <akpm@linux-foundation.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, 
	Thiago Jung Bauermann <bauerman@linux.ibm.com>, Luis Chamberlain <mcgrof@kernel.org>, Jessica Yu <jeyu@kernel.org>, 
	Sven Schnelle <svens@stackframe.org>, Iurii Zaikin <yzaikin@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Peter Collingbourne <pcc@google.com>, Naohiro Aota <naohiro.aota@wdc.com>, 
	Alexander Monakov <amonakov@ispras.ru>, Mathias Krause <minipli@googlemail.com>, 
	PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, 
	Laura Abbott <labbott@redhat.com>, Florian Weimer <fweimer@redhat.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-kbuild@vger.kernel.org, 
	"the arch/x86 maintainers" <x86@kernel.org>, Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	kernel list <linux-kernel@vger.kernel.org>, gcc@gcc.gnu.org, notify@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, Jun 4, 2020 at 3:51 PM Alexander Popov <alex.popov@linux.com> wrote:
> Some time ago Variable Length Arrays (VLA) were removed from the kernel.
> The kernel is built with '-Wvla'. Let's exclude alloca() from the
> instrumentation logic and make it simpler. The build-time assertion
> against alloca() is added instead.
[...]
> +                       /* Variable Length Arrays are forbidden in the kernel */
> +                       gcc_assert(!is_alloca(stmt));

There is a patch series from Elena and Kees on the kernel-hardening
list that deliberately uses __builtin_alloca() in the syscall entry
path to randomize the stack pointer per-syscall - see
<https://lore.kernel.org/kernel-hardening/20200406231606.37619-4-keescook@chromium.org/>.
