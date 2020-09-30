Return-Path: <kernel-hardening-return-20070-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 13FDE27F086
	for <lists+kernel-hardening@lfdr.de>; Wed, 30 Sep 2020 19:29:54 +0200 (CEST)
Received: (qmail 24251 invoked by uid 550); 30 Sep 2020 17:28:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 19728 invoked from network); 30 Sep 2020 17:19:25 -0000
Date: Wed, 30 Sep 2020 18:19:08 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Ard Biesheuvel <ardb@kernel.org>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>,
	Linuxarm <linuxarm@huawei.com>
Subject: Re: [PATCH v3 1/2] arm64/acpi: disallow AML memory opregions to
 access kernel memory
Message-ID: <20200930171908.GA1732@gaia>
References: <20200626155832.2323789-1-ardb@kernel.org>
 <20200626155832.2323789-2-ardb@kernel.org>
 <20200928170216.00006ff2@huawei.com>
 <CAMj1kXH1LZ15gzfW+7X5A4dMCD33DqNLnVrnLRo1zpw1Ekg+Lw@mail.gmail.com>
 <20200928181755.000019bf@huawei.com>
 <CAMj1kXGLVgAc0u9pSy0cKkmQXntdqjkkoM5wpdwLiwZfKOXKPA@mail.gmail.com>
 <20200930102722.00000bff@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200930102722.00000bff@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Hi Jonathan,

On Wed, Sep 30, 2020 at 10:27:22AM +0100, Jonathan Cameron wrote:
> On Tue, 29 Sep 2020 11:29:48 +0200 Ard Biesheuvel <ardb@kernel.org> wrote:
> > Could you try the patch below? Since the memory holding the tables is
> > already memblock_reserve()d, we can just mark it NOMAP, and permit r/o
> > remapping of NOMAP regions.
> 
> Looks good.  Thanks.
> 
> Tested-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

Could you please try the updated patch that Ard posted. There are a few
minor differences:

https://lore.kernel.org/linux-acpi/20200929132522.18067-1-ardb@kernel.org/

Thanks.

-- 
Catalin
