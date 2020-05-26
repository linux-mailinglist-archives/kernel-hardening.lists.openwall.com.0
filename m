Return-Path: <kernel-hardening-return-18380-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 446B319C1A1
	for <lists+kernel-hardening@lfdr.de>; Thu,  2 Apr 2020 15:05:19 +0200 (CEST)
Received: (qmail 22430 invoked by uid 550); 2 Apr 2020 13:04:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 22398 invoked from network); 2 Apr 2020 13:04:28 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585826661;
	bh=/T9PKpOsqkG6k9SDIldwzv8zPCYWoDaXHjHgeVFb4nM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=WqKQxAEQJcb0Y8B6c/brLQqu7z26a4AWVIOnBH6hst0XYKrpnqSPctRPLxvBbJx1T
	 K+GrF3WWgA2LuQMVoeNcHHXCYMfcP1kmTfV7M6XLEsG3cdtSkpNc+LYB95a79a/UNZ
	 LLyAwqt9NELgCw3AazG9YJhMgszChb+SK296WGMU=
X-Gm-Message-State: AGi0PuYLkMI+2xc3nJj3XYoE73hfdfH6cHU2msP95kE0yrZ/7Svtcgxu
	OVS4sUMuMXj1Xjvlq7WtOBCUI/0VuJ33a7ied0M=
X-Google-Smtp-Source: APiQypJHMEeM/iwsXUykwckvb2/MexzqNtnc3JITmwdvurwhg/ZxuCdS12G9sOMN03deRyuepi8qA8BHF3yMJqLCXLE=
X-Received: by 2002:a05:6602:2439:: with SMTP id g25mr2369114iob.142.1585826660620;
 Thu, 02 Apr 2020 04:24:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200329141258.31172-1-ardb@kernel.org> <20200402111502.GC21087@mbp>
In-Reply-To: <20200402111502.GC21087@mbp>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 2 Apr 2020 13:24:09 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFTnqZHWZX5yhkG4+pd04JzGriFW6gjBrAnQ-LQQmEi3Q@mail.gmail.com>
Message-ID: <CAMj1kXFTnqZHWZX5yhkG4+pd04JzGriFW6gjBrAnQ-LQQmEi3Q@mail.gmail.com>
Subject: Re: [RFC PATCH] arm64: remove CONFIG_DEBUG_ALIGN_RODATA feature
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	kernel-hardening@lists.openwall.com, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 2 Apr 2020 at 13:15, Catalin Marinas <catalin.marinas@arm.com> wrote:
>
> On Sun, Mar 29, 2020 at 04:12:58PM +0200, Ard Biesheuvel wrote:
> > When CONFIG_DEBUG_ALIGN_RODATA is enabled, kernel segments mapped with
> > different permissions (r-x for .text, r-- for .rodata, rw- for .data,
> > etc) are rounded up to 2 MiB so they can be mapped more efficiently.
> > In particular, it permits the segments to be mapped using level 2
> > block entries when using 4k pages, which is expected to result in less
> > TLB pressure.
> >
> > However, the mappings for the bulk of the kernel will use level 2
> > entries anyway, and the misaligned fringes are organized such that they
> > can take advantage of the contiguous bit, and use far fewer level 3
> > entries than would be needed otherwise.
> >
> > This makes the value of this feature dubious at best, and since it is not
> > enabled in defconfig or in the distro configs, it does not appear to be
> > in wide use either. So let's just remove it.
> >
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>
> Happy to take this patch via the arm64 tree for 5.7 (no new
> functionality), unless you want it to go with your other relocation
> login in the EFI stub patches.
>

If you don't mind taking it for v5.7, please go ahead.
