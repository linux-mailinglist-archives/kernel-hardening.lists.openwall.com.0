Return-Path: <kernel-hardening-return-16821-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id CA31EA198C
	for <lists+kernel-hardening@lfdr.de>; Thu, 29 Aug 2019 14:05:46 +0200 (CEST)
Received: (qmail 29753 invoked by uid 550); 29 Aug 2019 12:05:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 10123 invoked from network); 28 Aug 2019 22:01:07 -0000
Message-ID: <a39b81562bcdeda7ffe0c2c29a60ff08c77047a6.camel@buserror.net>
From: Scott Wood <oss@buserror.net>
To: Jason Yan <yanaijie@huawei.com>, mpe@ellerman.id.au, 
 linuxppc-dev@lists.ozlabs.org, diana.craciun@nxp.com,
 christophe.leroy@c-s.fr,  benh@kernel.crashing.org, paulus@samba.org,
 npiggin@gmail.com,  keescook@chromium.org,
 kernel-hardening@lists.openwall.com
Cc: wangkefeng.wang@huawei.com, linux-kernel@vger.kernel.org, 
 jingxiangfeng@huawei.com, zhaohongjiang@huawei.com,
 thunder.leizhen@huawei.com,  fanchengyang@huawei.com, yebin10@huawei.com
Date: Tue, 27 Aug 2019 23:05:30 -0500
In-Reply-To: <20190809100800.5426-1-yanaijie@huawei.com>
References: <20190809100800.5426-1-yanaijie@huawei.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2601:449:8400:7293:12bf:48ff:fe84:c9a0
X-SA-Exim-Rcpt-To: yanaijie@huawei.com, mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org, diana.craciun@nxp.com, christophe.leroy@c-s.fr, benh@kernel.crashing.org, paulus@samba.org, npiggin@gmail.com, keescook@chromium.org, kernel-hardening@lists.openwall.com, wangkefeng.wang@huawei.com, linux-kernel@vger.kernel.org, jingxiangfeng@huawei.com, zhaohongjiang@huawei.com, thunder.leizhen@huawei.com, fanchengyang@huawei.com, yebin10@huawei.com
X-SA-Exim-Mail-From: oss@buserror.net
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on baldur.localdomain
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=5.0 tests=ALL_TRUSTED,BAYES_00,
	GREYLIST_ISWHITE autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Report: 
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  -15 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -1.5 GREYLIST_ISWHITE The incoming server has been whitelisted for
	*      this recipient and sender
Subject: Re: [PATCH v6 00/12] implement KASLR for powerpc/fsl_booke/32
X-SA-Exim-Version: 4.2.1 (built Tue, 02 Aug 2016 21:08:31 +0000)
X-SA-Exim-Scanned: Yes (on baldur.buserror.net)

On Fri, 2019-08-09 at 18:07 +0800, Jason Yan wrote:
> This series implements KASLR for powerpc/fsl_booke/32, as a security
> feature that deters exploit attempts relying on knowledge of the location
> of kernel internals.
> 
> Since CONFIG_RELOCATABLE has already supported, what we need to do is
> map or copy kernel to a proper place and relocate.

Have you tested this with a kernel that was loaded at a non-zero address?  I
tried loading a kernel at 0x04000000 (by changing the address in the uImage,
and setting bootm_low to 04000000 in U-Boot), and it works without
CONFIG_RANDOMIZE and fails with.

>  Freescale Book-E
> parts expect lowmem to be mapped by fixed TLB entries(TLB1). The TLB1
> entries are not suitable to map the kernel directly in a randomized
> region, so we chose to copy the kernel to a proper place and restart to
> relocate.
> 
> Entropy is derived from the banner and timer base, which will change every
> build and boot. This not so much safe so additionally the bootloader may
> pass entropy via the /chosen/kaslr-seed node in device tree.

How complicated would it be to directly access the HW RNG (if present) that
early in the boot?  It'd be nice if a U-Boot update weren't required (and
particularly concerning that KASLR would appear to work without a U-Boot
update, but without decent entropy).

-Scott


