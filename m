Return-Path: <kernel-hardening-return-19512-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id F2A5A235748
	for <lists+kernel-hardening@lfdr.de>; Sun,  2 Aug 2020 15:58:00 +0200 (CEST)
Received: (qmail 22077 invoked by uid 550); 2 Aug 2020 13:57:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 22057 invoked from network); 2 Aug 2020 13:57:54 -0000
From: Florian Weimer <fw@deneb.enyo.de>
To: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc: Andy Lutomirski <luto@kernel.org>,  Kernel Hardening <kernel-hardening@lists.openwall.com>,  Linux API <linux-api@vger.kernel.org>,  linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,  Linux FS Devel <linux-fsdevel@vger.kernel.org>,  linux-integrity <linux-integrity@vger.kernel.org>,  LKML <linux-kernel@vger.kernel.org>,  LSM List <linux-security-module@vger.kernel.org>,  Oleg Nesterov <oleg@redhat.com>,  X86 ML <x86@kernel.org>
Subject: Re: [PATCH v1 0/4] [RFC] Implement Trampoline File Descriptor
References: <20200728131050.24443-1-madvenka@linux.microsoft.com>
	<CALCETrVy5OMuUx04-wWk9FJbSxkrT2vMfN_kANinudrDwC4Cig@mail.gmail.com>
	<6540b4b7-3f70-adbf-c922-43886599713a@linux.microsoft.com>
	<CALCETrWnNR5v3ZCLfBVQGYK8M0jAvQMaAc9uuO05kfZuh-4d6w@mail.gmail.com>
	<46a1adef-65f0-bd5e-0b17-54856fb7e7ee@linux.microsoft.com>
Date: Sun, 02 Aug 2020 15:57:35 +0200
In-Reply-To: <46a1adef-65f0-bd5e-0b17-54856fb7e7ee@linux.microsoft.com>
	(Madhavan T. Venkataraman's message of "Fri, 31 Jul 2020 12:13:49
	-0500")
Message-ID: <87o8nttak0.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain

* Madhavan T. Venkataraman:

> Standardization
> ---------------------
>
> Trampfd is a framework that can be used to implement multiple
> things. May be, a few of those things can also be implemented in
> user land itself. But I think having just one mechanism to execute
> dynamic code objects is preferable to having multiple mechanisms not
> standardized across all applications.
>
> As an example, let us say that I am able to implement support for
> JIT code. Let us say that an interpreter uses libffi to execute a
> generated function. The interpreter would use trampfd for the JIT
> code object and get an address. Then, it would pass that to libffi
> which would then use trampfd for the trampoline. So, trampfd based
> code objects can be chained.

There is certainly value in coordination.  For example, it would be
nice if unwinders could recognize the trampolines during all phases
and unwind correctly through them (including when interrupted by an
asynchronous symbol).  That requires some level of coordination with
the unwinder and dynamic linker.

A kernel solution could hide the intermediate state in a kernel-side
trap handler, but I think it wouldn't reduce the overall complexity.
