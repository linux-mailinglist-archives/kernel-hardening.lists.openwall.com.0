Return-Path: <kernel-hardening-return-19042-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 8969B20427A
	for <lists+kernel-hardening@lfdr.de>; Mon, 22 Jun 2020 23:15:47 +0200 (CEST)
Received: (qmail 24443 invoked by uid 550); 22 Jun 2020 21:15:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 24406 invoked from network); 22 Jun 2020 21:15:42 -0000
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
	:references:in-reply-to:from:date:message-id:subject:to:cc
	:content-type; s=mail; bh=qJEjU6sSA8TwPUhGDGMTJ91dblc=; b=wqjJcp
	HXZ+y1UgqElZcA7MQRjMcFkjd7T/ZqohO46BzCF3H9udmaUy/h32uQXV2zCqP/NV
	CKtJw3a7SqaNMqlK19btgS9BS76JrcILlBjV9b7LrL8s4gdhShTsaWiRtal2fOcI
	TAyY4C/CqNjlHkWeFm8e2BMC4cbySgWKwNBnjfRk9wGd+3OcT+YWb227sRscwqY5
	H2+yBTKAlIW4QgUYWJKOL76HKzAs7/bkGcgjA/a0GeiKoajkSFYp5Cw8qsoc+opE
	xJ2ZCqMepiBLrZ+FnMAJ5tPSs6+ue0H8Tb6V6fYVmaNBW7jg7IC27ntMwb7X9ont
	KQXAKVH0Bw4czi4Q==
X-Gm-Message-State: AOAM531gVU/WSeOixr7amGc2lpybY18+5cSInsyCDgo+RqLeBk61ZyjX
	TrQqldXJFU6f9LCV+HDh7T09yyb1sIStKeFmJF0=
X-Google-Smtp-Source: ABdhPJw9l4k7FiN3KlgAVAg9pwp3ioQxt5pSftSo2y6SOouQKY3EDhaqEjWZqHhSRlX+x5j18axy9ie87hbyDWXfTPY=
X-Received: by 2002:a05:6602:2fc5:: with SMTP id v5mr19371449iow.79.1592860529463;
 Mon, 22 Jun 2020 14:15:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200622092719.1380968-1-ardb@kernel.org> <CAHmME9oNwDra2Vi+jsy4YZ81HVygyyRXTJeni58CaJqOmfmepA@mail.gmail.com>
In-Reply-To: <CAHmME9oNwDra2Vi+jsy4YZ81HVygyyRXTJeni58CaJqOmfmepA@mail.gmail.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Mon, 22 Jun 2020 15:15:18 -0600
X-Gmail-Original-Message-ID: <CAHmME9q=dYdf1sn_Kvo5Fu0cUUOGQAMDerb+8g2_-AKhvMukew@mail.gmail.com>
Message-ID: <CAHmME9q=dYdf1sn_Kvo5Fu0cUUOGQAMDerb+8g2_-AKhvMukew@mail.gmail.com>
Subject: Re: [RFC PATCH] arm64/acpi: disallow AML memory opregions to access
 kernel memory
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, 
	ACPI Devel Maling List <linux-acpi@vger.kernel.org>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, lorenzo.pieralisi@arm.com, sudeep.holla@arm.com, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"

Hmm, actually...

> >         if (memblock_is_map_memory(phys))
> > -               return (void __iomem *)__phys_to_virt(phys);
> > +               return NULL;

It might be prudent to have this check take into account the size of
the region being mapped. I realize ACPI considers it to be undefined
if you cross borders, but I could imagine actual system behavior being
somewhat complicated, and a clever bypass being possible.
Hypothetically: KASLR starts kernel at phys_base+offset, [phys_base,
rounddownpage(offset)) doesn't get mapped, malicious acpi then maps
phys_base+rounddownpage(offset)-1, and then this check doesn't get
hit.
