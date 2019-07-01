Return-Path: <kernel-hardening-return-16168-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id A01C148D05
	for <lists+kernel-hardening@lfdr.de>; Mon, 17 Jun 2019 20:53:54 +0200 (CEST)
Received: (qmail 25658 invoked by uid 550); 17 Jun 2019 18:53:49 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 25610 invoked from network); 17 Jun 2019 18:53:48 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1560797616;
	bh=lKC3JNmm/M1af0c1PRbg2Uh820jqPX+NRIxEKPybN6M=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=eXbR6IGlAhoRHsh0X3dKP72UYrrHCysviqVduIvo988BvFsDJiHNmagNTuqCgT0Tz
	 Ehk6WcbvY4nPlIO+gF1eI6ULC/OMuVOV6cx+LReTSeqmIaWk3PzySvWxhGGeBAAkMp
	 4syFIFuC1xSZZCiJ/kFMwEe46IZHRSe0NOBIJQfw=
X-Gm-Message-State: APjAAAWCsJ/Atf3x3kCc8ljAzJqsb9Vpp/oIou1W/PF2lChaTU2y6GS7
	s4CUBlK4zS3qidwFNyJ5qHTI/jVtL6Ap3OuoDEfFGQ==
X-Google-Smtp-Source: APXvYqyNAFrO0PJ/PQ/nZtVT7qVJ0gCZKAFFrDHCa57/0Vwr7NK90EHDsldsfHv0mzTzjWiWbLBIz0Xs4+/j24iLBNA=
X-Received: by 2002:a5d:6207:: with SMTP id y7mr56496191wru.265.1560797615195;
 Mon, 17 Jun 2019 11:53:35 -0700 (PDT)
MIME-Version: 1.0
References: <eecc856f-7f3f-ed11-3457-ea832351e963@intel.com>
 <A542C98B-486C-4849-9DAC-2355F0F89A20@amacapital.net> <alpine.DEB.2.21.1906141618000.1722@nanos.tec.linutronix.de>
 <58788f05-04c3-e71c-12c3-0123be55012c@amazon.com> <63b1b249-6bc7-ffd9-99db-d36dd3f1a962@intel.com>
 <CALCETrXph3Zg907kWTn6gAsZVsPbCB3A2XuNf0hy5Ez2jm2aNQ@mail.gmail.com>
 <698ca264-123d-46ae-c165-ed62ea149896@intel.com> <CALCETrVt=X+FB2cM5hMN9okvbcROFfT4_KMwaKaN2YVvc7UQTw@mail.gmail.com>
 <5AA8BF10-8987-4FCB-870C-667A5228D97B@gmail.com> <f6f352ed-750e-d735-a1c9-7ff133ca8aea@intel.com>
 <20190617184536.GB11017@char.us.oracle.com>
In-Reply-To: <20190617184536.GB11017@char.us.oracle.com>
From: Andy Lutomirski <luto@kernel.org>
Date: Mon, 17 Jun 2019 11:53:22 -0700
X-Gmail-Original-Message-ID: <CALCETrVhg8FquaB6tDssEfbPZFV3w0r-+3LPsNsYw26t+_2MMw@mail.gmail.com>
Message-ID: <CALCETrVhg8FquaB6tDssEfbPZFV3w0r-+3LPsNsYw26t+_2MMw@mail.gmail.com>
Subject: Re: [RFC 00/10] Process-local memory allocations for hiding KVM secrets
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Dave Hansen <dave.hansen@intel.com>, Nadav Amit <nadav.amit@gmail.com>, 
	Andy Lutomirski <luto@kernel.org>, Alexander Graf <graf@amazon.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Marius Hillenbrand <mhillenb@amazon.de>, kvm list <kvm@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux-MM <linux-mm@kvack.org>, 
	Alexander Graf <graf@amazon.de>, David Woodhouse <dwmw@amazon.co.uk>, 
	"the arch/x86 maintainers" <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, Jun 17, 2019 at 11:44 AM Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
>
> On Mon, Jun 17, 2019 at 11:07:45AM -0700, Dave Hansen wrote:
> > On 6/17/19 9:53 AM, Nadav Amit wrote:
> > >>> For anyone following along at home, I'm going to go off into crazy
> > >>> per-cpu-pgds speculation mode now...  Feel free to stop reading now. :)
> > >>>
> > >>> But, I was thinking we could get away with not doing this on _every_
> > >>> context switch at least.  For instance, couldn't 'struct tlb_context'
> > >>> have PGD pointer (or two with PTI) in addition to the TLB info?  That
> > >>> way we only do the copying when we change the context.  Or does that tie
> > >>> the implementation up too much with PCIDs?
> > >> Hmm, that seems entirely reasonable.  I think the nasty bit would be
> > >> figuring out all the interactions with PV TLB flushing.  PV TLB
> > >> flushes already don't play so well with PCID tracking, and this will
> > >> make it worse.  We probably need to rewrite all that code regardless.
> > > How is PCID (as you implemented) related to TLB flushing of kernel (not
> > > user) PTEs? These kernel PTEs would be global, so they would be invalidated
> > > from all the address-spaces using INVLPG, I presume. No?
> >
> > The idea is that you have a per-cpu address space.  Certain kernel
> > virtual addresses would map to different physical address based on where
> > you are running.  Each of the physical addresses would be "owned" by a
> > single CPU and would, by convention, never use a PGD that mapped an
> > address unless that CPU that "owned" it.
> >
> > In that case, you never really invalidate those addresses.
>
> But you would need to invalidate if the process moved to another CPU, correct?
>

There's nothing to invalidate.  It's a different CPU with a different TLB.

The big problem is that you have a choice.  Either you can have one
PGD per (mm, cpu) or you just have one or a few PGDs per CPU and you
change them every time you change processes.  Dave's idea to have one
or two per (cpu, asid) is right, though.  It means we have a decent
chance of context switching without rewriting the whole thing, and it
also means we don't need to write to the one that's currently loaded
when we switch CR3.  The latter could plausibly be important enough
that we'd want to pretend we're using PCID even if we're not.
