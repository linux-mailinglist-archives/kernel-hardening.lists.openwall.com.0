Return-Path: <kernel-hardening-return-18209-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id A706B191BB9
	for <lists+kernel-hardening@lfdr.de>; Tue, 24 Mar 2020 22:08:33 +0100 (CET)
Received: (qmail 19910 invoked by uid 550); 24 Mar 2020 21:08:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 19875 invoked from network); 24 Mar 2020 21:08:27 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585084095;
	bh=Ts2q4lc5rS0zE3p9NKfuZ3OCIDyXTdzeBDRNZoAYpTg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Dcbn27CTP2jdEE8Ft12vQNu+KMxtzPKAyV+xeoInVKlIwjJB9hsf+U831sbsfiY9s
	 79yCeVkuICil1S4IFAkNrKNbTMyHP2iMAWtYIjJJIG5KnsML5NtKNjADY/lmxvnjTc
	 vpdD56t4J55t5JoPQSl+f0JSXuFSCmOpP/2m/gK8=
Date: Tue, 24 Mar 2020 21:08:09 +0000
From: Will Deacon <will@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
	Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>,
	Maddie Stone <maddiestone@google.com>,
	Marco Elver <elver@google.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>, kernel-team@android.com,
	kernel-hardening@lists.openwall.com
Subject: Re: [RFC PATCH 17/21] linux/bit_spinlock.h: Include linux/processor.h
Message-ID: <20200324210808.GA19527@willie-the-truck>
References: <20200324153643.15527-1-will@kernel.org>
 <20200324153643.15527-18-will@kernel.org>
 <20200324162820.GD2518046@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324162820.GD2518046@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Mar 24, 2020 at 05:28:20PM +0100, Greg KH wrote:
> On Tue, Mar 24, 2020 at 03:36:39PM +0000, Will Deacon wrote:
> > Needed for cpu_relax().
> 
> Is this needed now, or for the next patch?  And if for next patch, why
> not just add it then?

If the next patch correctly included linux/list_bl.h like it was supposed
to, then yes, it's needed there. I'll sort that out and fold this in for
v2.

Cheers,

Will
