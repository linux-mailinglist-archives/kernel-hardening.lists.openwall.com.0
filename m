Return-Path: <kernel-hardening-return-16159-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 326AD487FD
	for <lists+kernel-hardening@lfdr.de>; Mon, 17 Jun 2019 17:55:08 +0200 (CEST)
Received: (qmail 24527 invoked by uid 550); 17 Jun 2019 15:55:02 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 24495 invoked from network); 17 Jun 2019 15:55:02 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1560786890;
	bh=aQEphLJjoGNsTWF7PUdVBXP9/NtJHbD77gDyFsJX9OY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=qhOUahTGEyUHegfv4CFWy7tkV4dfGHY5ttlEqkwBP2tiXzGEfMzJPElZH2oeSSJA0
	 rsnYLYI8jLtjfOKiK5Ee2GKss2TnarwRGAOSUPGb+qZpd65W4APU5Itf6Ar+aac5xH
	 gguaXWWoFgjuokF/kcsWPV63ALSIUKuQ4QvaRPnU=
X-Gm-Message-State: APjAAAV2bk6VlXQ+JWhyViCJli/btroeCGh25DEkQdLcN7zrMUUAjgtA
	Zh0SiMUWrFmbb2C1mR20wQKiMyrDxadB5LMeFxuqFg==
X-Google-Smtp-Source: APXvYqykHUxihfkEY2tiikg8dXKgA4M9BplCJytE01KiNZl2hAMC6m+RW666K7HHMIykrPzo3dGyP3UaxzXnfm7HuLw=
X-Received: by 2002:a5d:6207:: with SMTP id y7mr55951191wru.265.1560786888514;
 Mon, 17 Jun 2019 08:54:48 -0700 (PDT)
MIME-Version: 1.0
References: <20190612170834.14855-1-mhillenb@amazon.de> <eecc856f-7f3f-ed11-3457-ea832351e963@intel.com>
 <A542C98B-486C-4849-9DAC-2355F0F89A20@amacapital.net> <alpine.DEB.2.21.1906141618000.1722@nanos.tec.linutronix.de>
 <58788f05-04c3-e71c-12c3-0123be55012c@amazon.com> <63b1b249-6bc7-ffd9-99db-d36dd3f1a962@intel.com>
In-Reply-To: <63b1b249-6bc7-ffd9-99db-d36dd3f1a962@intel.com>
From: Andy Lutomirski <luto@kernel.org>
Date: Mon, 17 Jun 2019 08:54:36 -0700
X-Gmail-Original-Message-ID: <CALCETrXph3Zg907kWTn6gAsZVsPbCB3A2XuNf0hy5Ez2jm2aNQ@mail.gmail.com>
Message-ID: <CALCETrXph3Zg907kWTn6gAsZVsPbCB3A2XuNf0hy5Ez2jm2aNQ@mail.gmail.com>
Subject: Re: [RFC 00/10] Process-local memory allocations for hiding KVM secrets
To: Dave Hansen <dave.hansen@intel.com>
Cc: Alexander Graf <graf@amazon.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Marius Hillenbrand <mhillenb@amazon.de>, kvm list <kvm@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux-MM <linux-mm@kvack.org>, 
	Alexander Graf <graf@amazon.de>, David Woodhouse <dwmw@amazon.co.uk>, 
	"the arch/x86 maintainers" <x86@kernel.org>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, Jun 17, 2019 at 8:50 AM Dave Hansen <dave.hansen@intel.com> wrote:
>
> On 6/17/19 12:38 AM, Alexander Graf wrote:
> >> Yes I know, but as a benefit we could get rid of all the GSBASE
> >> horrors in
> >> the entry code as we could just put the percpu space into the local PGD.
> >
> > Would that mean that with Meltdown affected CPUs we open speculation
> > attacks against the mmlocal memory from KVM user space?
>
> Not necessarily.  There would likely be a _set_ of local PGDs.  We could
> still have pair of PTI PGDs just like we do know, they'd just be a local
> PGD pair.
>

Unfortunately, this would mean that we need to sync twice as many
top-level entries when we context switch.
