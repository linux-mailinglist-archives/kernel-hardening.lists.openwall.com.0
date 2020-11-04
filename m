Return-Path: <kernel-hardening-return-20350-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id CE9C72A607D
	for <lists+kernel-hardening@lfdr.de>; Wed,  4 Nov 2020 10:29:59 +0100 (CET)
Received: (qmail 24019 invoked by uid 550); 4 Nov 2020 09:29:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 23999 invoked from network); 4 Nov 2020 09:29:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1604482181;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sNIUH/NWHkFHY64VfaawTYBDidvMrnoULy11KAx4HxE=;
	b=an1SgSrrSE43sHU1VifY4W31wYnwL6XaDGw6h5OWzJxcCkdP5xSyaSu/Ohc6FMkTMt+Xkb
	GTVetkf9N8kVcn3f03zlalkY+oelhBoFokJkhCIU17oya5fIgs7Djs84wUXIzNB/Lvkbs7
	eoVHA++Y6Rn+YQ4rinfsndqALTT3Hwk=
X-MC-Unique: SFfYKSFfNCypDyaQQ8tYwQ-1
From: Florian Weimer <fweimer@redhat.com>
To: Will Deacon <will@kernel.org>
Cc: Mark Brown <broonie@kernel.org>,  Szabolcs Nagy <szabolcs.nagy@arm.com>,
  libc-alpha@sourceware.org,  Jeremy Linton <jeremy.linton@arm.com>,
  Catalin Marinas <catalin.marinas@arm.com>,  Mark Rutland
 <mark.rutland@arm.com>,  Kees Cook <keescook@chromium.org>,  Salvatore
 Mesoraca <s.mesoraca16@gmail.com>,  Lennart Poettering
 <mzxreary@0pointer.de>,  Topi Miettinen <toiwoton@gmail.com>,
  linux-kernel@vger.kernel.org,  linux-arm-kernel@lists.infradead.org,
  kernel-hardening@lists.openwall.com,  linux-hardening@vger.kernel.org
Subject: Re: [PATCH 0/4] aarch64: avoid mprotect(PROT_BTI|PROT_EXEC) [BZ
 #26831]
References: <cover.1604393169.git.szabolcs.nagy@arm.com>
	<20201103173438.GD5545@sirena.org.uk>
	<20201104092012.GA6439@willie-the-truck>
Date: Wed, 04 Nov 2020 10:29:29 +0100
In-Reply-To: <20201104092012.GA6439@willie-the-truck> (Will Deacon's message
	of "Wed, 4 Nov 2020 09:20:12 +0000")
Message-ID: <87h7q54ghy.fsf@oldenburg2.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14

* Will Deacon:

> Is there real value in this seccomp filter if it only looks at mprotect(),
> or was it just implemented because it's easy to do and sounds like a good
> idea?

It seems bogus to me.  Everyone will just create alias mappings instead,
just like they did for the similar SELinux feature.  See =E2=80=9CExample c=
ode
to avoid execmem violations=E2=80=9D in:

  <https://www.akkadia.org/drepper/selinux-mem.html>

As you can see, this reference implementation creates a PROT_WRITE
mapping aliased to a PROT_EXEC mapping, so it actually reduces security
compared to something that generates the code in an anonymous mapping
and calls mprotect to make it executable.

Furthermore, it requires unusual cache flushing code on some AArch64
implementations (a requirement that is not shared by any Linux other
architecture to which libffi has been ported), resulting in
hard-to-track-down real-world bugs.

Thanks,
Florian
--=20
Red Hat GmbH, https://de.redhat.com/ , Registered seat: Grasbrunn,
Commercial register: Amtsgericht Muenchen, HRB 153243,
Managing Directors: Charles Cachera, Brian Klemm, Laurie Krebs, Michael O'N=
eill

