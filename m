Return-Path: <kernel-hardening-return-19982-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 72EDF275F45
	for <lists+kernel-hardening@lfdr.de>; Wed, 23 Sep 2020 20:00:50 +0200 (CEST)
Received: (qmail 20016 invoked by uid 550); 23 Sep 2020 18:00:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 18029 invoked from network); 23 Sep 2020 18:00:12 -0000
Date: Wed, 23 Sep 2020 20:00:07 +0200
From: Solar Designer <solar@openwall.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: madvenka@linux.microsoft.com, kernel-hardening@lists.openwall.com,
	linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
	oleg@redhat.com, x86@kernel.org, luto@kernel.org,
	David.Laight@ACULAB.COM, fweimer@redhat.com, mark.rutland@arm.com,
	mic@digikod.net, Rich Felker <dalias@libc.org>
Subject: Re: [PATCH v2 0/4] [RFC] Implement Trampoline File Descriptor
Message-ID: <20200923180007.GA8646@openwall.com>
References: <20200922215326.4603-1-madvenka@linux.microsoft.com> <20200923081426.GA30279@amd> <20200923091456.GA6177@openwall.com> <20200923141102.GA7142@openwall.com> <20200923151835.GA32555@duo.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200923151835.GA32555@duo.ucw.cz>
User-Agent: Mutt/1.4.2.3i

On Wed, Sep 23, 2020 at 05:18:35PM +0200, Pavel Machek wrote:
> > It sure does make sense to combine ret2libc/ROP to mprotect() with one's
> > own injected shellcode.  Compared to doing everything from ROP, this is
> > easier and more reliable across versions/builds if the desired
> > payload
> 
> Ok, so this starts to be a bit confusing.
> 
> I thought W^X is to protect from attackers that have overflowed buffer
> somewhere, but can not to do arbitrary syscalls, yet.
> 
> You are saying that there's important class of attackers that can do
> some syscalls but not arbitrary ones.

They might be able to do many, most, or all arbitrary syscalls via
ret2libc or such.  The crucial detail is that each time they do that,
they risk incompatibility with the given target system (version, build,
maybe ASLR if gadgets from multiple libraries are involved).  By using
mprotect(), they only take this risk once (need to get the address of an
mprotect() gadget and of what to change protections on right), and then
they can invoke multiple syscalls from their shellcode more reliably.
So for doing a lot of work, mprotect() combined with injected code can
be easier and more reliable.  It is also an extra option an attacker can
use, in addition to doing everything via borrowed code.  More
flexibility for the attacker means the attacker may choose whichever
approach works better in a given case (or try several).

I am embarrassed for not thinking/recalling this when I first posted
earlier today.  It's actually obvious.  I'm just getting old and rusty.

> I'd like to see definition of that attacker (and perhaps description
> of the system the protection is expected to be useful on -- if it is
> not close to common Linux distros).

There's nothing unusual about that attacker and the system.

A couple of other things Brad kindly pointed out:

SELinux already has similar protections (execmem, execmod):

http://lkml.iu.edu/hypermail/linux/kernel/0508.2/0194.html
https://danwalsh.livejournal.com/6117.html

PaX MPROTECT is implemented in a way or at a layer that covers ptrace()
abuse that I mentioned.  (At least that's how I understood Brad.)

Alexander

P.S. Meanwhile, Twitter locked my account "for security purposes".  Fun.
I'll just let it be for now.
