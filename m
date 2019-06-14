Return-Path: <kernel-hardening-return-16149-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 0D0DF467E5
	for <lists+kernel-hardening@lfdr.de>; Fri, 14 Jun 2019 20:54:34 +0200 (CEST)
Received: (qmail 17565 invoked by uid 550); 14 Jun 2019 18:54:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 17499 invoked from network); 14 Jun 2019 18:54:27 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	 bh=8upm4+29tOlpQvd0AoUl0tlNlWmR9q34xlzKP6CkZm4=; b=WJ33Ov75EUUu6/DmEUFB19pkd
	AApE091e//VzGGWXOnqjguRJk0CA4BAhULBk8rApp7qZJ0tEF7vsi0te7DwN703C0+ZS8k9W7ofW5
	WrA+5w78xp8yBxCmp7GtPP8+L66lQgyWE8JojrcIjhbKld1qI7oe/EAYtw4ZMwE5O0/cfk9jHgEHo
	B+uYGeapZZUHgoh5mFCngwnBYfM2FtU+UrVOWJOkiySHui2BQaWdDitlmyes7nG91jkEl6qDnWMoA
	NOAMjjtHXTIN0WipAs6YI6qqSMhqfLEGfxR9XlBgkFJ2jkv7CkTsuKTZXyCBkPMQdV5snRmuwzdaA
	yr4JHKlrw==;
Date: Fri, 14 Jun 2019 19:54:08 +0100
From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
To: Denis 'GNUtoo' Carikli <GNUtoo@cyberdimension.org>
Cc: Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>,
	Emese Revfy <re.emese@gmail.com>,
	Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] security: do not enable CONFIG_GCC_PLUGINS by default
Message-ID: <20190614185408.dg6iblbsjwkk3kt6@shell.armlinux.org.uk>
References: <20190614145755.10926-1-GNUtoo@cyberdimension.org>
 <CAG48ez30+VOj78rCiWMKtm0tHdVR67CcrHVCV-FFCfK-nRQTOw@mail.gmail.com>
 <20190614162811.o33yeq65ythjumrh@shell.armlinux.org.uk>
 <20190614201434.3fa4bb6d@primarylaptop.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190614201434.3fa4bb6d@primarylaptop.localdomain>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>

On Fri, Jun 14, 2019 at 08:14:34PM +0200, Denis 'GNUtoo' Carikli wrote:
> On Fri, 14 Jun 2019 17:28:11 +0100
> Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:
> > I'm wondering whether this is sloppy wording or whether the author is
> > really implying that they call the kernel decompressor with the MMU
> > enabled, against the express instructions in
> > Documentation/arm/Booting.
> According to [1]
> > If they are going against the express instructions, all bets are off.
> 
> More background on the decompressor patch:
> - The "ANDROID: arm: decompressor: Flush tlb before swiching domain 0 to
>   client mode" patch is needed anyway since 3.4 in any case, and
>   according to the thread about it [1], the MMU is on at boot.
> - There is a downstream u-boot port for the Galaxy SIII and other very
>   similar devices, which doesn't setup the MMU at boot, but I'm not
>   confident enough to test in on the devices I have. To test with
>   u-boot I'd need to find a new device.
> - If I don't manage to find a new device to test on, since there is
>   already some setup code like arch/arm/boot/compressed/head-sa1100.S
>   that deal with MMU that are enabled with the bootloader, are patches
>   to add a new file like that still accepted? The big downside is that
>   using something like that is probably incompatible with
>   ARCH_MULTIPLATFORM.

SA11x0 pre-dates the booting document, which came about because of the
desire to make the kernel less dependent on the host CPU type.  So
"sa11x0 does it so we can do it" is really not an argument I ever want
to see to justify this kind of stuff.

The booting requirements have been known since at least 2002, some
SEVENTEEN years ago, and the problem was identified as buggy back in
2012.  As far as I can see, nothing has changed.

Entering the kernel with the MMU on and optionally caches on is an
inherently unsafe thing to do.  The kernel would have been placed into
RAM via the data cache, and then we're trying to execute code - unless
the caches have been properly cleaned and invalidated, there is no
guarantee that we'd even reach any instructions to do our own cache
cleaning and invalidation.  So, caches on is utter madness.

MMU on presents a problem: the kernel moves itself around during
decompression - if it happens to move itself on top of the in-use
page tables, then that would be really bad.  There's another issue as
well - if the page tables are already setup, and we create a different
mapping for the virtual address range, the _only_ way to safely switch
to that mapping is via a break-make arrangement, which means we need
code to disable the MMU, flush it.  It is not as simple as "a few extra
instructions to flush TLBs" although that may work in the majority of
cases.  Architecturally, it is wrong.

Things can get even worse - what if the page tables are located where
the kernel writes its own page tables - modifying the live tables and
changing the type of the entries.  Architecturally unpredictable
behaviour may result.

What is written in Documentation/arm/Booting is not for our fun, it is
there to spell out what the kernel requires to be able to boot reliably
on hardware.  If it isn't followed, then booting a kernel will be
unreliable.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
