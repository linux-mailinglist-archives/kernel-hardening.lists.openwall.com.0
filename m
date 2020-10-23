Return-Path: <kernel-hardening-return-20255-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id D3BA6296E29
	for <lists+kernel-hardening@lfdr.de>; Fri, 23 Oct 2020 14:04:51 +0200 (CEST)
Received: (qmail 18381 invoked by uid 550); 23 Oct 2020 12:03:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 15953 invoked from network); 23 Oct 2020 09:02:50 -0000
Date: Fri, 23 Oct 2020 10:02:32 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Kees Cook <keescook@chromium.org>
Cc: Topi Miettinen <toiwoton@gmail.com>,
	Szabolcs Nagy <szabolcs.nagy@arm.com>,
	Jeremy Linton <jeremy.linton@arm.com>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	libc-alpha@sourceware.org, systemd-devel@lists.freedesktop.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>, Dave Martin <dave.martin@arm.com>,
	Will Deacon <will.deacon@arm.com>,
	Salvatore Mesoraca <s.mesoraca16@gmail.com>,
	kernel-hardening@lists.openwall.com,
	linux-hardening@vger.kernel.org
Subject: Re: BTI interaction between seccomp filters in systemd and glibc
 mprotect calls, causing service failures
Message-ID: <20201023090232.GA25736@gaia>
References: <8584c14f-5c28-9d70-c054-7c78127d84ea@arm.com>
 <20201022075447.GO3819@arm.com>
 <78464155-f459-773f-d0ee-c5bdbeb39e5d@gmail.com>
 <202010221256.A4F95FD11@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202010221256.A4F95FD11@keescook>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Thu, Oct 22, 2020 at 01:02:18PM -0700, Kees Cook wrote:
> Regardless, it makes sense to me to have the kernel load the executable
> itself with BTI enabled by default. I prefer gaining Catalin's suggested
> patch[2]. :)
[...]
> [2] https://lore.kernel.org/linux-arm-kernel/20201022093104.GB1229@gaia/

I think I first heard the idea at Mark R ;).

It still needs glibc changes to avoid the mprotect(), or at least ignore
the error. Since this is an ABI change and we don't know which kernels
would have it backported, maybe better to still issue the mprotect() but
ignore the failure.

-- 
Catalin
