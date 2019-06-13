Return-Path: <kernel-hardening-return-16138-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 47F1344BBE
	for <lists+kernel-hardening@lfdr.de>; Thu, 13 Jun 2019 21:09:09 +0200 (CEST)
Received: (qmail 27884 invoked by uid 550); 13 Jun 2019 19:09:04 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 27849 invoked from network); 13 Jun 2019 19:09:03 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1560452931;
	bh=M5fVHuz7GM200rX+um5CG9lWSJ5LN83V9cleMiqSr0w=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=0mQsma9LhbSOHNzZVajdIzZemifGcr2vm+eoDvWHCFOu5QioUwGz0anWuVUWjWkCm
	 nJ2OatAf+pOKXIw9oXDAR6BG5giv/GHzyV1s4G6AnzAxmMFcbuDj45BtghRwzKjtDj
	 iUxkLEHdfoknLzxjSezsgwAGu+bJbg1lOdbn+e8w=
X-Gm-Message-State: APjAAAWp3LE3QE9+803MJoVL/OUWUpFETcLxs28RQovf3uLOqpah54vw
	dUER/F1camDm/Njr8jduHh8roKQ1lPsPSE91TLQs7Q==
X-Google-Smtp-Source: APXvYqztejRGvq27Iw+y0cfs1NyXH8Lm8jD6LvUHm3icGIgaUgnfnhaK9ERONLPuzbZ61xdPyrlnbiBZJeMMJtqJK0w=
X-Received: by 2002:a1c:6242:: with SMTP id w63mr5199746wmb.161.1560452929712;
 Thu, 13 Jun 2019 12:08:49 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1560198181.git.luto@kernel.org> <131caabf9d127db1a077525f978e1f1f74f9088f.1560198181.git.luto@kernel.org>
 <201906101342.B8A938BB@keescook>
In-Reply-To: <201906101342.B8A938BB@keescook>
From: Andy Lutomirski <luto@kernel.org>
Date: Thu, 13 Jun 2019 12:08:38 -0700
X-Gmail-Original-Message-ID: <CALCETrXJA2ws=M_RBge1+nVGkDR0qX-jdFypYxuE3yDiikt46w@mail.gmail.com>
Message-ID: <CALCETrXJA2ws=M_RBge1+nVGkDR0qX-jdFypYxuE3yDiikt46w@mail.gmail.com>
Subject: Re: [PATCH 2/5] x86/vsyscall: Add a new vsyscall=xonly mode
To: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	Borislav Petkov <bp@alien8.de>, Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"

On Mon, Jun 10, 2019 at 1:43 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Mon, Jun 10, 2019 at 01:25:28PM -0700, Andy Lutomirski wrote:
> > With vsyscall emulation on, we still expose a readable vsyscall page
> > that contains syscall instructions that validly implement the
> > vsyscalls.  We need this because certain dynamic binary
> > instrumentation tools attempt to read the call targets of call
> > instructions in the instrumented code.  If the instrumented code
> > uses vsyscalls, then the vsyscal page needs to contain readable
> > code.
> >
> > Unfortunately, leaving readable memory at a deterministic address
> > can be used to help various ASLR bypasses, so we gain some hardening
> > value if we disallow vsyscall reads.
> >
> > Given how rarely the vsyscall page needs to be readable, add a
> > mechanism to make the vsyscall page be execute only.
>
> Should the commit log mention that the VVAR portion goes away under
> xonly? (Since it's not executable.)

No, because vsyscall VVAR is long gone no matter what.  Even the old
vsyscall=native didn't have it.
