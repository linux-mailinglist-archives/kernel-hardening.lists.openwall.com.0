Return-Path: <kernel-hardening-return-16137-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 8DCD944BBA
	for <lists+kernel-hardening@lfdr.de>; Thu, 13 Jun 2019 21:08:13 +0200 (CEST)
Received: (qmail 25688 invoked by uid 550); 13 Jun 2019 19:08:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 25633 invoked from network); 13 Jun 2019 19:08:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1560452874;
	bh=QLdqDQmRPxVrCZYy0W6he9k6Fiy66AEvu4ykWlMqvl8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=x60ZbHpp223igiSLc5q5Jj7ywt5bmr2i+DpWOt3w2VDiy6oOaYuDQuGUd3pt2pzSI
	 HFExm7CghqlSXWJV1cLBsxD9UuIATWdZdRLFwqbpIpj2gJW67/yItx+gqkVZLccQKb
	 52VZHWhallDLgiKJwP1WcfbYzlnm3VXZB/v8hOFw=
X-Gm-Message-State: APjAAAXW0+A3nfDbNEJaYBW5DtTJv8xhipJxhpeyWyMlE3ID5mrxJWG+
	9qLcK93CBXHldQVpkYqgiHcxELo2cZkdCn7CI8CtOw==
X-Google-Smtp-Source: APXvYqyB56oi15p6KqGsR+j3YdT44dOp7+9anVhd6nyuR9Jr9zxwY+DcMwh0aHg4dnVuT/1cPNjKuq28mw8Me6ERQRw=
X-Received: by 2002:a1c:a942:: with SMTP id s63mr4888086wme.76.1560452872970;
 Thu, 13 Jun 2019 12:07:52 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1560198181.git.luto@kernel.org> <d28856fff74a385f88c493dafb9d96d2c38d91a2.1560198181.git.luto@kernel.org>
 <201906101340.AE18F49@keescook>
In-Reply-To: <201906101340.AE18F49@keescook>
From: Andy Lutomirski <luto@kernel.org>
Date: Thu, 13 Jun 2019 12:07:40 -0700
X-Gmail-Original-Message-ID: <CALCETrVOzGCN+pjgsdd+x3APsrSGJzngfGeSWvqWy=XTQj3EiA@mail.gmail.com>
Message-ID: <CALCETrVOzGCN+pjgsdd+x3APsrSGJzngfGeSWvqWy=XTQj3EiA@mail.gmail.com>
Subject: Re: [PATCH 3/5] x86/vsyscall: Document odd #PF's error code for vsyscalls
To: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	Borislav Petkov <bp@alien8.de>, Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"

On Mon, Jun 10, 2019 at 1:40 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Mon, Jun 10, 2019 at 01:25:29PM -0700, Andy Lutomirski wrote:
> >  tools/testing/selftests/x86/test_vsyscall.c | 9 ++++++++-
>
> Did this hunk end up in the wrong patch? (It's not mentioned in the
> commit log and the next patch has other selftest changes...)
>

It was intentional -- you can run the improved selftest and observe
the oddity for yourself :)  I'll improve the changelog.
