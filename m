Return-Path: <kernel-hardening-return-18738-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id C3B0B1C8CC5
	for <lists+kernel-hardening@lfdr.de>; Thu,  7 May 2020 15:43:22 +0200 (CEST)
Received: (qmail 3191 invoked by uid 550); 7 May 2020 13:43:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3157 invoked from network); 7 May 2020 13:43:15 -0000
Date: Thu, 7 May 2020 14:43:00 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	kernel-hardening@lists.openwall.com,
	Mark Rutland <mark.rutland@arm.com>
Subject: Re: [RFC PATCH] arm64: remove CONFIG_DEBUG_ALIGN_RODATA feature
Message-ID: <20200507134259.GA3180@gaia>
References: <20200329141258.31172-1-ardb@kernel.org>
 <20200330135121.GD10633@willie-the-truck>
 <CAMj1kXEZARZ1FYZFt4CZ33b-A64zj1JswR0OAHw-eZdzkxiEOQ@mail.gmail.com>
 <20200330140441.GE10633@willie-the-truck>
 <CAMj1kXHJ5n-EZMgGSYm+ekO-e7XTp7fv-FZ2NJ1EttJ=-kc8fw@mail.gmail.com>
 <20200330142805.GA11312@willie-the-truck>
 <CAMj1kXFcvHcU2kzP=N4bHgSkw_eE7wvbPJ=7w1pNeCWHbcPvTQ@mail.gmail.com>
 <20200402113033.GD21087@mbp>
 <CAMj1kXGLMWqTHbWftoAq=WdVqyf+i=6SvsMogzWHh6SL3b=4sQ@mail.gmail.com>
 <20200505104404.GB19710@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505104404.GB19710@willie-the-truck>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, May 05, 2020 at 11:44:06AM +0100, Will Deacon wrote:
> Catalin -- did you get anything back from the architects about the cache
> hit behaviour?

Any read from a non-cacheable alias would be coherent with writes using
the same non-cacheable attributes, irrespective of other cacheable
aliases (of course, subject to the cache lines having been previously
cleaned/invalidated to avoid dirty lines evictions).

So as long as the hardware works as per the ARM ARM (B2.8), we don't
need to unmap the non-cacheable DMA buffers from the linear map.

-- 
Catalin
