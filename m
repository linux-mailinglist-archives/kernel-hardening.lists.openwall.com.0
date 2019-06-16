Return-Path: <kernel-hardening-return-16153-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 5FFEE4771E
	for <lists+kernel-hardening@lfdr.de>; Mon, 17 Jun 2019 00:28:49 +0200 (CEST)
Received: (qmail 13431 invoked by uid 550); 16 Jun 2019 22:28:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 13399 invoked from network); 16 Jun 2019 22:28:43 -0000
Date: Mon, 17 Jun 2019 00:28:27 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andy Lutomirski <luto@kernel.org>
cc: Dave Hansen <dave.hansen@intel.com>, 
    Marius Hillenbrand <mhillenb@amazon.de>, kvm list <kvm@vger.kernel.org>, 
    LKML <linux-kernel@vger.kernel.org>, 
    Kernel Hardening <kernel-hardening@lists.openwall.com>, 
    Linux-MM <linux-mm@kvack.org>, Alexander Graf <graf@amazon.de>, 
    David Woodhouse <dwmw@amazon.co.uk>, 
    the arch/x86 maintainers <x86@kernel.org>, 
    Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC 00/10] Process-local memory allocations for hiding KVM
 secrets
In-Reply-To: <CALCETrWZ4qUW+A+YqE36ZJHqJAzxwDgq77bL99BEKQx-=JYAtA@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.1906170026370.1760@nanos.tec.linutronix.de>
References: <20190612170834.14855-1-mhillenb@amazon.de> <eecc856f-7f3f-ed11-3457-ea832351e963@intel.com> <A542C98B-486C-4849-9DAC-2355F0F89A20@amacapital.net> <alpine.DEB.2.21.1906141618000.1722@nanos.tec.linutronix.de>
 <CALCETrWZ4qUW+A+YqE36ZJHqJAzxwDgq77bL99BEKQx-=JYAtA@mail.gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-1576819727-1560724108=:1760"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1576819727-1560724108=:1760
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Sun, 16 Jun 2019, Andy Lutomirski wrote:
> On Fri, Jun 14, 2019 at 7:21 AM Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Wed, 12 Jun 2019, Andy Lutomirski wrote:
> > >
> > > Fair warning: Linus is on record as absolutely hating this idea. He might
> > > change his mind, but it’s an uphill battle.
> >
> > Yes I know, but as a benefit we could get rid of all the GSBASE horrors in
> > the entry code as we could just put the percpu space into the local PGD.
> >
> 
> I have personally suggested this to Linus on a couple of occasions,
> and he seemed quite skeptical.

The only way to find out is the good old: numbers talk ....

So someone has to bite the bullet, implement it and figure out whether it's
bollocks or not. :)

Thanks,

	tglx

--8323329-1576819727-1560724108=:1760--
