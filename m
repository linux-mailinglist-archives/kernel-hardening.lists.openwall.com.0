Return-Path: <kernel-hardening-return-18378-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 54F0B19C152
	for <lists+kernel-hardening@lfdr.de>; Thu,  2 Apr 2020 14:43:38 +0200 (CEST)
Received: (qmail 26177 invoked by uid 550); 2 Apr 2020 12:43:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 26139 invoked from network); 2 Apr 2020 12:43:32 -0000
Date: Thu, 2 Apr 2020 13:17:45 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>, Will Deacon <will@kernel.org>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	kernel-hardening@lists.openwall.com
Subject: Re: [RFC PATCH] arm64: remove CONFIG_DEBUG_ALIGN_RODATA feature
Message-ID: <20200402121745.GA29906@C02TD0UTHF1T.local>
References: <20200329141258.31172-1-ardb@kernel.org>
 <20200330135121.GD10633@willie-the-truck>
 <CAMj1kXEZARZ1FYZFt4CZ33b-A64zj1JswR0OAHw-eZdzkxiEOQ@mail.gmail.com>
 <20200330140441.GE10633@willie-the-truck>
 <CAMj1kXHJ5n-EZMgGSYm+ekO-e7XTp7fv-FZ2NJ1EttJ=-kc8fw@mail.gmail.com>
 <20200330142805.GA11312@willie-the-truck>
 <CAMj1kXFcvHcU2kzP=N4bHgSkw_eE7wvbPJ=7w1pNeCWHbcPvTQ@mail.gmail.com>
 <20200402113033.GD21087@mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200402113033.GD21087@mbp>

On Thu, Apr 02, 2020 at 12:30:33PM +0100, Catalin Marinas wrote:
> On Mon, Mar 30, 2020 at 04:32:31PM +0200, Ard Biesheuvel wrote:
> > Could we make this a runtime thing? E.g., remap the entire linear
> > region down to pages under stop_machine() the first time we probe a
> > device that uses non-coherent DMA?
> 
> That could be pretty expensive at run-time. With the ARMv8.4-TTRem
> feature, I wonder whether we could do this lazily when allocating
> non-coherent DMA buffers.

It's worth noting that ARMv8.4-TTRem is optional and the "level 1" and
"level 2" behaviours still allows non-fatal faults to be taken while nT
is set (or until you perform the TLB invalidation). We can only safely
use it where we could use a full BBM sequence today.

Effectively TTRem is an optimized, where the CPU *might* be able to use
entries during the break stage, but is not guaranteed to do so.

Thanksm
Mark.
