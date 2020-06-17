Return-Path: <kernel-hardening-return-19009-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 8FACE1FD941
	for <lists+kernel-hardening@lfdr.de>; Thu, 18 Jun 2020 00:53:19 +0200 (CEST)
Received: (qmail 27739 invoked by uid 550); 17 Jun 2020 22:53:14 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 27719 invoked from network); 17 Jun 2020 22:53:13 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=jDsiGpHlHt3A6TlGq6foih1kuiL4GlYeWIrZSOkZpxY=;
        b=gzQGj00ueXc2W/kOiGPOcTIAbJbr/M/MLdgqTtuhg5grPOrTu3BaxWlh8qOcwEYPtj
         qe03kbeetPJMdpKWXdSYw0Ln/fx9cMl6bRF4zZ6alGlnV6HRhnHB+trO2CH/K2qV/gpS
         3NB8IJAhQw/Nvs7O7OFXgO56j6elETkFG+H0kzbZRn0JJ8Ojl3tyJLYdU8fjrsBMwGug
         PKlkZtp0fFdkyBfsIHsCui78044VbKGgQrlzz8hC3KW/Rjw7DeF/XFuLkcpIzzy610eT
         mGfCtn90i5IVz76mMYs+ZX9N8SbKCwhS6p1zBzFzWMY12QRrZ21+X78Sjh6+b6G40Onk
         6D/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=jDsiGpHlHt3A6TlGq6foih1kuiL4GlYeWIrZSOkZpxY=;
        b=KFJ+0xJ5+asarjk89sGFfrOvrxWkvTgTFNol3fO+jBtHFxWem1RDro/2Zol2JsCWw6
         bkvSFtBaP54/RaGwV2hvYZSt8TFMdavbE00xtOJlnx6deiR1L+sdIsL4TJkr6Aljs49k
         Lgz/RgQtAPcu478NkYzOVS2CczPooxovQeYH6xCIu6/WOw5YFpRompMGAGys0gefyWEm
         Jq5WirPmyDtbZK/wvTjqkiaHIIL0Ev6iXSODRbdz4aH45/cWK8M4yBY/JOf35tV9TNeV
         lAMZYWaVJrwyDUJcdTg7ynMPqYt7/stKiZxmdh1n4MbOiyywqwzI/UUHU2wOzyzN13Yq
         Sr3w==
X-Gm-Message-State: AOAM531c5BoBfZV4KqpG5M1oJxqMBbCzQZzX2eExXIMLQrCiZ5u60J/r
	cKCY8JMXxBOhiqcaVqXJ1RA=
X-Google-Smtp-Source: ABdhPJx8Qbf49zWcMX8/NXw0QB3RvDxyw4NaaPU5k5Ty2ssb3CbYBVNbXy4fzd/ZWZlzMfKdx8wrmQ==
X-Received: by 2002:a63:1718:: with SMTP id x24mr916736pgl.72.1592434381286;
        Wed, 17 Jun 2020 15:53:01 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [kvm-unit-tests PATCH] x86: Add control register pinning tests
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20200617224606.27954-1-john.s.andersen@intel.com>
Date: Wed, 17 Jun 2020 15:52:59 -0700
Cc: corbet@lwn.net,
 Paolo Bonzini <pbonzini@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>,
 mingo <mingo@redhat.com>,
 bp <bp@alien8.de>,
 hpa@zytor.com,
 shuah@kernel.org,
 sean.j.christopherson@intel.com,
 rick.p.edgecombe@intel.com,
 kvm@vger.kernel.org,
 kernel-hardening@lists.openwall.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <ACCCF382-0077-4B08-8CF1-73C561F930CD@gmail.com>
References: <20200617224606.27954-1-john.s.andersen@intel.com>
To: John Andersen <john.s.andersen@intel.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)

> On Jun 17, 2020, at 3:46 PM, John Andersen <john.s.andersen@intel.com> =
wrote:
>=20
> Paravirutalized control register pinning adds MSRs guests can use to
> discover which bits in CR0/4 they may pin, and MSRs for activating
> pinning for any of those bits.
>=20

[ sni[

> +static void vmx_cr_pin_test_guest(void)
> +{
> +	unsigned long i, cr0, cr4;
> +
> +	/* Step 1. Skip feature detection to skip handling VMX_CPUID */
> +	/* nop */

I do not quite get this comment. Why do you skip checking whether the
feature is enabled? What happens if KVM/bare-metal/other-hypervisor that
runs this test does not support this feature?

