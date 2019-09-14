Return-Path: <kernel-hardening-return-16891-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 95F0FB2BB2
	for <lists+kernel-hardening@lfdr.de>; Sat, 14 Sep 2019 16:46:21 +0200 (CEST)
Received: (qmail 30292 invoked by uid 550); 14 Sep 2019 14:46:14 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 27658 invoked from network); 14 Sep 2019 14:35:51 -0000
Message-ID: <65f56bfd05152d744b032e7df9c34b5d9ef2bfb5.camel@buserror.net>
From: Scott Wood <oss@buserror.net>
To: Jason Yan <yanaijie@huawei.com>, mpe@ellerman.id.au, 
 linuxppc-dev@lists.ozlabs.org, diana.craciun@nxp.com,
 christophe.leroy@c-s.fr,  benh@kernel.crashing.org, paulus@samba.org,
 npiggin@gmail.com,  keescook@chromium.org,
 kernel-hardening@lists.openwall.com
Cc: wangkefeng.wang@huawei.com, linux-kernel@vger.kernel.org, 
 jingxiangfeng@huawei.com, zhaohongjiang@huawei.com,
 thunder.leizhen@huawei.com,  fanchengyang@huawei.com, yebin10@huawei.com
Date: Sat, 14 Sep 2019 09:28:55 -0500
In-Reply-To: <e02c727a-5505-80d3-9ba2-9fbb9c8253fe@huawei.com>
References: <20190809100800.5426-1-yanaijie@huawei.com>
	 <a39b81562bcdeda7ffe0c2c29a60ff08c77047a6.camel@buserror.net>
	 <e02c727a-5505-80d3-9ba2-9fbb9c8253fe@huawei.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2601:449:8480:af0:12bf:48ff:fe84:c9a0
X-SA-Exim-Rcpt-To: yanaijie@huawei.com, mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org, diana.craciun@nxp.com, christophe.leroy@c-s.fr, benh@kernel.crashing.org, paulus@samba.org, npiggin@gmail.com, keescook@chromium.org, kernel-hardening@lists.openwall.com, wangkefeng.wang@huawei.com, linux-kernel@vger.kernel.org, jingxiangfeng@huawei.com, zhaohongjiang@huawei.com, thunder.leizhen@huawei.com, fanchengyang@huawei.com, yebin10@huawei.com
X-SA-Exim-Mail-From: oss@buserror.net
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on baldur.localdomain
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=5.0 tests=ALL_TRUSTED,BAYES_00
	autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Report: 
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  -15 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
Subject: Re: [PATCH v6 00/12] implement KASLR for powerpc/fsl_booke/32
X-SA-Exim-Version: 4.2.1 (built Tue, 02 Aug 2016 21:08:31 +0000)
X-SA-Exim-Scanned: Yes (on baldur.buserror.net)

On Tue, 2019-09-10 at 13:34 +0800, Jason Yan wrote:
> Hi Scott,
> 
> On 2019/8/28 12:05, Scott Wood wrote:
> > On Fri, 2019-08-09 at 18:07 +0800, Jason Yan wrote:
> > > This series implements KASLR for powerpc/fsl_booke/32, as a security
> > > feature that deters exploit attempts relying on knowledge of the
> > > location
> > > of kernel internals.
> > > 
> > > Since CONFIG_RELOCATABLE has already supported, what we need to do is
> > > map or copy kernel to a proper place and relocate.
> > 
> > Have you tested this with a kernel that was loaded at a non-zero
> > address?  I
> > tried loading a kernel at 0x04000000 (by changing the address in the
> > uImage,
> > and setting bootm_low to 04000000 in U-Boot), and it works without
> > CONFIG_RANDOMIZE and fails with.
> > 
> 
> How did you change the load address of the uImage, by changing the
> kernel config CONFIG_PHYSICAL_START or the "-a/-e" parameter of mkimage?
> I tried both, but it did not work with or without CONFIG_RANDOMIZE.

With mkimage.  Did you set bootm_low in U-Boot as described above?  Was
CONFIG_RELOCATABLE set in the non-CONFIG_RANDOMIZE kernel?

-Scott


