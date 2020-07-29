Return-Path: <kernel-hardening-return-19486-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 33362231906
	for <lists+kernel-hardening@lfdr.de>; Wed, 29 Jul 2020 07:17:18 +0200 (CEST)
Received: (qmail 30130 invoked by uid 550); 29 Jul 2020 05:17:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 30109 invoked from network); 29 Jul 2020 05:17:11 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595999819;
	bh=qItqwNi4q4ELXpJAVlv3H8dC/ihmulIDrwoa1DDcrFY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=k2/ypYf8chH29waA/oS7FzUjhmqJvZsAK5yreLc+JnHHzlqaz9vnEqabE+qyemEMh
	 V59mmT0x99Zz7xAAr4mzDnLpnXyxu10GUK80PkfmZzTfRw0ApQRzkJVmfxPNtOL+Nt
	 orHtR8IzwwnOF1rKVTvLOZzzbUFBmX6T//Qhyjrc=
X-Gm-Message-State: AOAM5307zloSMUCPZQOleka+RdFQgzJ834TMjLIAW3FAV2Q+6NgKqLXA
	x+/eY8fIfSI11hwMwPtgZ3a4L4uqgZdXC9kmObJpFg==
X-Google-Smtp-Source: ABdhPJyc8ExWo5/AVhgh7lVVbcBRbBl+yZD/a1oDf2lJ2rOxAoDZo7htpcvpKEGk9rvSh0Xh0NAF4mmPRBSSCBjw09E=
X-Received: by 2002:a1c:7511:: with SMTP id o17mr7308351wmc.49.1595999817430;
 Tue, 28 Jul 2020 22:16:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200728131050.24443-1-madvenka@linux.microsoft.com>
 <c23de6ec47614f489943e1a89a21dfa3@AcuMS.aculab.com> <f5cfd11b-04fe-9db7-9d67-7ee898636edb@linux.microsoft.com>
 <CALCETrUta5-0TLJ9-jfdehpTAp2Efmukk2npYadFzz9ozOrG2w@mail.gmail.com> <81d744c0-923e-35ad-6063-8b186f6a153c@linux.microsoft.com>
In-Reply-To: <81d744c0-923e-35ad-6063-8b186f6a153c@linux.microsoft.com>
From: Andy Lutomirski <luto@kernel.org>
Date: Tue, 28 Jul 2020 22:16:45 -0700
X-Gmail-Original-Message-ID: <CALCETrUWd4Gogz5EQNbbx7Babct4hGerz7sWiAuu2-Q1KB64yA@mail.gmail.com>
Message-ID: <CALCETrUWd4Gogz5EQNbbx7Babct4hGerz7sWiAuu2-Q1KB64yA@mail.gmail.com>
Subject: Re: [PATCH v1 0/4] [RFC] Implement Trampoline File Descriptor
To: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc: Andy Lutomirski <luto@kernel.org>, David Laight <David.Laight@aculab.com>, 
	"kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, 
	"linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "oleg@redhat.com" <oleg@redhat.com>, 
	"x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, Jul 28, 2020 at 10:40 AM Madhavan T. Venkataraman
<madvenka@linux.microsoft.com> wrote:
>
>
>
> On 7/28/20 12:16 PM, Andy Lutomirski wrote:
>
> On Tue, Jul 28, 2020 at 9:32 AM Madhavan T. Venkataraman
> <madvenka@linux.microsoft.com> wrote:
>
> Thanks. See inline..
>
> On 7/28/20 10:13 AM, David Laight wrote:
>
> From:  madvenka@linux.microsoft.com
>
> Sent: 28 July 2020 14:11
>
> ...
>
> The kernel creates the trampoline mapping without any permissions. When
> the trampoline is executed by user code, a page fault happens and the
> kernel gets control. The kernel recognizes that this is a trampoline
> invocation. It sets up the user registers based on the specified
> register context, and/or pushes values on the user stack based on the
> specified stack context, and sets the user PC to the requested target
> PC. When the kernel returns, execution continues at the target PC.
> So, the kernel does the work of the trampoline on behalf of the
> application.
>
> Isn't the performance of this going to be horrid?
>
> It takes about the same amount of time as getpid(). So, it is
> one quick trip into the kernel. I expect that applications will
> typically not care about this extra overhead as long as
> they are able to run.
>
> What did you test this on?  A page fault on any modern x86_64 system
> is much, much, much, much slower than a syscall.
>
>
> I tested it in on a KVM guest running Ubuntu. So, when you say
> that a page fault is much slower, do you mean a regular page
> fault that is handled through the VM layer? Here is the relevant code
> in do_user_addr_fault():

I mean that x86 CPUs have reasonably SYSCALL and SYSRET instructions
(the former is used for 64-bit system calls on Linux and the latter is
mostly used to return from system calls), but hardware page fault
delivery and IRET (used to return from page faults) are very slow.
