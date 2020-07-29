Return-Path: <kernel-hardening-return-19488-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 472F4231F5C
	for <lists+kernel-hardening@lfdr.de>; Wed, 29 Jul 2020 15:29:57 +0200 (CEST)
Received: (qmail 32764 invoked by uid 550); 29 Jul 2020 13:29:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 32738 invoked from network); 29 Jul 2020 13:29:50 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1596029379;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pHdy6Zb9Xi6Br1uklysJIGNGzShuC9IUN8gmmUSKfJ8=;
	b=a87pl4HMfaXWliXa31GsL2U7GN8t5X2anfNGpSltIBSWXwRuKWabRl6LlrM2zJmZFgXdcx
	8ax0gjqpTcPEG9IR0wTgUoXfA6uUmv1Ca6fGk5D3rKKVTfy/2hgUGPOWTrG/e+tAexFkSu
	Q3PTQOyFJ5Hi1ACh837maJaoVcJnsew=
X-MC-Unique: oUnvNmSeOLyVa6xnjYceCQ-1
From: Florian Weimer <fweimer@redhat.com>
To: Andy Lutomirski <luto@kernel.org>
Cc: madvenka@linux.microsoft.com,  Kernel Hardening <kernel-hardening@lists.openwall.com>,  Linux API <linux-api@vger.kernel.org>,  linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,  Linux FS Devel <linux-fsdevel@vger.kernel.org>,  linux-integrity <linux-integrity@vger.kernel.org>,  LKML <linux-kernel@vger.kernel.org>,  LSM List <linux-security-module@vger.kernel.org>,  Oleg Nesterov <oleg@redhat.com>,  X86 ML <x86@kernel.org>
Subject: Re: [PATCH v1 0/4] [RFC] Implement Trampoline File Descriptor
References: <20200728131050.24443-1-madvenka@linux.microsoft.com>
	<CALCETrVy5OMuUx04-wWk9FJbSxkrT2vMfN_kANinudrDwC4Cig@mail.gmail.com>
Date: Wed, 29 Jul 2020 15:29:31 +0200
In-Reply-To: <CALCETrVy5OMuUx04-wWk9FJbSxkrT2vMfN_kANinudrDwC4Cig@mail.gmail.com>
	(Andy Lutomirski's message of "Tue, 28 Jul 2020 10:31:59 -0700")
Message-ID: <87pn8eo3es.fsf@oldenburg2.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16

* Andy Lutomirski:

> This is quite clever, but now I=E2=80=99m wondering just how much kernel =
help
> is really needed. In your series, the trampoline is an non-executable
> page.  I can think of at least two alternative approaches, and I'd
> like to know the pros and cons.
>
> 1. Entirely userspace: a return trampoline would be something like:
>
> 1:
> pushq %rax
> pushq %rbc
> pushq %rcx
> ...
> pushq %r15
> movq %rsp, %rdi # pointer to saved regs
> leaq 1b(%rip), %rsi # pointer to the trampoline itself
> callq trampoline_handler # see below
>
> You would fill a page with a bunch of these, possibly compacted to get
> more per page, and then you would remap as many copies as needed.

libffi does something like this for iOS, I believe.

The only thing you really need is a PC-relative indirect call, with the
target address loaded from a different page.  The trampoline handler can
do all the rest because it can identify the trampoline from the stack.
Having a closure parameter loaded into a register will speed things up,
of course.

I still hope to transition libffi to this model for most Linux targets.
It really simplifies things because you don't have to deal with cache
flushes (on both the data and code aliases for SELinux support).

But the key observation is that efficient trampolines do not need
run-time code generation at all because their code is so regular.

Thanks,
Florian

