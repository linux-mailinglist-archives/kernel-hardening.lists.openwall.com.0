Return-Path: <kernel-hardening-return-17786-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id A7D2A15A4BA
	for <lists+kernel-hardening@lfdr.de>; Wed, 12 Feb 2020 10:28:01 +0100 (CET)
Received: (qmail 30425 invoked by uid 550); 12 Feb 2020 09:27:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 30384 invoked from network); 12 Feb 2020 09:27:55 -0000
Date: Wed, 12 Feb 2020 09:27:39 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Kees Cook <keescook@chromium.org>
Cc: Ingo Molnar <mingo@kernel.org>, Hector Marco-Gisbert <hecmargi@upv.es>,
	Will Deacon <will.deacon@arm.com>,
	Jason Gunthorpe <jgg@mellanox.com>, Jann Horn <jannh@google.com>,
	Russell King <linux@armlinux.org.uk>, x86@kernel.org,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 5/7] arm32/64, elf: Split READ_IMPLIES_EXEC from
 executable GNU_STACK
Message-ID: <20200212092739.GC488264@arrakis.emea.arm.com>
References: <20200210193049.64362-1-keescook@chromium.org>
 <20200210193049.64362-6-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200210193049.64362-6-keescook@chromium.org>

On Mon, Feb 10, 2020 at 11:30:47AM -0800, Kees Cook wrote:
> The READ_IMPLIES_EXEC work-around was designed for old toolchains that
> lacked the ELF PT_GNU_STACK marking under the assumption that toolchains
> that couldn't specify executable permission flags for the stack may not
> know how to do it correctly for any memory region.
> 
> This logic is sensible for having ancient binaries coexist in a system
> with possibly NX memory, but was implemented in a way that equated having
> a PT_GNU_STACK marked executable as being as "broken" as lacking the
> PT_GNU_STACK marking entirely. Things like unmarked assembly and stack
> trampolines may cause PT_GNU_STACK to need an executable bit, but they
> do not imply all mappings must be executable.
> 
> This confusion has led to situations where modern programs with explicitly
> marked executable stack are forced into the READ_IMPLIES_EXEC state when
> no such thing is needed. (And leads to unexpected failures when mmap()ing
> regions of device driver memory that wish to disallow VM_EXEC[1].)
> 
> In looking for other reasons for the READ_IMPLIES_EXEC behavior, Jann
> Horn noted that glibc thread stacks have always been marked RWX (until
> 2003 when they started tracking the PT_GNU_STACK flag instead[2]). And
> musl doesn't support executable stacks at all[3]. As such, no breakage
> for multithreaded applications is expected from this change.
> 
> This changes arm32 and arm64 compat together, to keep behavior the same.
> 
> [1] https://lkml.kernel.org/r/20190418055759.GA3155@mellanox.com
> [2] https://sourceware.org/git/?p=glibc.git;a=commitdiff;h=54ee14b3882
> [3] https://lkml.kernel.org/r/20190423192534.GN23599@brightrain.aerifal.cx
> 
> Suggested-by: Hector Marco-Gisbert <hecmargi@upv.es>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
