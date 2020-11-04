Return-Path: <kernel-hardening-return-20355-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 3F8972A6676
	for <lists+kernel-hardening@lfdr.de>; Wed,  4 Nov 2020 15:35:27 +0100 (CET)
Received: (qmail 26021 invoked by uid 550); 4 Nov 2020 14:35:20 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 26000 invoked from network); 4 Nov 2020 14:35:19 -0000
Date: Wed, 4 Nov 2020 14:35:00 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Topi Miettinen <toiwoton@gmail.com>
Cc: Florian Weimer <fweimer@redhat.com>, Will Deacon <will@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha@sourceware.org,
	Jeremy Linton <jeremy.linton@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Kees Cook <keescook@chromium.org>,
	Salvatore Mesoraca <s.mesoraca16@gmail.com>,
	Lennart Poettering <mzxreary@0pointer.de>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kernel-hardening@lists.openwall.com,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH 0/4] aarch64: avoid mprotect(PROT_BTI|PROT_EXEC) [BZ
 #26831]
Message-ID: <20201104143500.GC28902@gaia>
References: <cover.1604393169.git.szabolcs.nagy@arm.com>
 <20201103173438.GD5545@sirena.org.uk>
 <20201104092012.GA6439@willie-the-truck>
 <87h7q54ghy.fsf@oldenburg2.str.redhat.com>
 <d2f51a90-c5d6-99bd-35b8-f4fded073f95@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d2f51a90-c5d6-99bd-35b8-f4fded073f95@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, Nov 04, 2020 at 11:55:57AM +0200, Topi Miettinen wrote:
> On 4.11.2020 11.29, Florian Weimer wrote:
> > * Will Deacon:
> > 
> > > Is there real value in this seccomp filter if it only looks at mprotect(),
> > > or was it just implemented because it's easy to do and sounds like a good
> > > idea?
> > 
> > It seems bogus to me.  Everyone will just create alias mappings instead,
> > just like they did for the similar SELinux feature.  See “Example code
> > to avoid execmem violations” in:
> > 
> >    <https://www.akkadia.org/drepper/selinux-mem.html>
[...]
> > As you can see, this reference implementation creates a PROT_WRITE
> > mapping aliased to a PROT_EXEC mapping, so it actually reduces security
> > compared to something that generates the code in an anonymous mapping
> > and calls mprotect to make it executable.
[...]
> If a service legitimately needs executable and writable mappings (due to
> JIT, trampolines etc), it's easy to disable the filter whenever really
> needed with "MemoryDenyWriteExecute=no" (which is the default) in case of
> systemd or a TE rule like "allow type_t self:process { execmem };" for
> SELinux. But this shouldn't be the default case, since there are many
> services which don't need W&X.

I think Drepper's point is that separate X and W mappings, with enough
randomisation, would be more secure than allowing W&X at the same
address (but, of course, less secure than not having W at all, though
that's not always possible).

> I'd also question what is the value of BTI if it can be easily circumvented
> by removing PROT_BTI with mprotect()?

Well, BTI is a protection against JOP attacks. The assumption here is
that an attacker cannot invoke mprotect() to disable PROT_BTI. If it
can, it's probably not worth bothering with a subsequent JOP attack, it
can already call functions directly.

I see MDWX not as a way of detecting attacks but rather plugging
inadvertent security holes in certain programs. On arm64, such hardening
currently gets in the way of another hardening feature, BTI.

-- 
Catalin
