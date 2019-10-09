Return-Path: <kernel-hardening-return-16999-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id DAC03D17CF
	for <lists+kernel-hardening@lfdr.de>; Wed,  9 Oct 2019 20:53:42 +0200 (CEST)
Received: (qmail 12184 invoked by uid 550); 9 Oct 2019 18:53:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 12152 invoked from network); 9 Oct 2019 18:53:36 -0000
Message-ID: <34ef1980887c8a6d635c20bdaf748bb0548e51b5.camel@buserror.net>
From: Scott Wood <oss@buserror.net>
To: Jason Yan <yanaijie@huawei.com>, mpe@ellerman.id.au, 
 linuxppc-dev@lists.ozlabs.org, diana.craciun@nxp.com,
 christophe.leroy@c-s.fr,  benh@kernel.crashing.org, paulus@samba.org,
 npiggin@gmail.com,  keescook@chromium.org,
 kernel-hardening@lists.openwall.com
Cc: wangkefeng.wang@huawei.com, linux-kernel@vger.kernel.org, 
 jingxiangfeng@huawei.com, zhaohongjiang@huawei.com,
 thunder.leizhen@huawei.com,  yebin10@huawei.com
Date: Wed, 09 Oct 2019 13:46:38 -0500
In-Reply-To: <90bb659a-bde4-3b8e-8f01-bf22d7534f44@huawei.com>
References: <20190920094546.44948-1-yanaijie@huawei.com>
	 <9c2dd2a8-83f2-983c-383e-956e19a7803a@huawei.com>
	 <c4769b34-95f6-81b9-4856-50459630aa0d@huawei.com>
	 <38141b946f3376ce471e46eaf065e357ac540354.camel@buserror.net>
	 <90bb659a-bde4-3b8e-8f01-bf22d7534f44@huawei.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2601:449:8480:af0:12bf:48ff:fe84:c9a0
X-SA-Exim-Rcpt-To: yanaijie@huawei.com, mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org, diana.craciun@nxp.com, christophe.leroy@c-s.fr, benh@kernel.crashing.org, paulus@samba.org, npiggin@gmail.com, keescook@chromium.org, kernel-hardening@lists.openwall.com, wangkefeng.wang@huawei.com, linux-kernel@vger.kernel.org, jingxiangfeng@huawei.com, zhaohongjiang@huawei.com, thunder.leizhen@huawei.com, yebin10@huawei.com
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
Subject: Re: [PATCH v7 00/12] implement KASLR for powerpc/fsl_booke/32
X-SA-Exim-Version: 4.2.1 (built Tue, 02 Aug 2016 21:08:31 +0000)
X-SA-Exim-Scanned: Yes (on baldur.buserror.net)

On Wed, 2019-10-09 at 16:41 +0800, Jason Yan wrote:
> Hi Scott,
> 
> On 2019/10/9 15:13, Scott Wood wrote:
> > On Wed, 2019-10-09 at 14:10 +0800, Jason Yan wrote:
> > > Hi Scott,
> > > 
> > > Would you please take sometime to test this?
> > > 
> > > Thank you so much.
> > > 
> > > On 2019/9/24 13:52, Jason Yan wrote:
> > > > Hi Scott,
> > > > 
> > > > Can you test v7 to see if it works to load a kernel at a non-zero
> > > > address?
> > > > 
> > > > Thanks,
> > 
> > Sorry for the delay.  Here's the output:
> > 
> 
> Thanks for the test.
> 
> > ## Booting kernel from Legacy Image at 10000000 ...
> >     Image Name:   Linux-5.4.0-rc2-00050-g8ac2cf5b4
> >     Image Type:   PowerPC Linux Kernel Image (gzip compressed)
> >     Data Size:    7521134 Bytes = 7.2 MiB
> >     Load Address: 04000000
> >     Entry Point:  04000000
> >     Verifying Checksum ... OK
> > ## Flattened Device Tree blob at 1fc00000
> >     Booting using the fdt blob at 0x1fc00000
> >     Uncompressing Kernel Image ... OK
> >     Loading Device Tree to 07fe0000, end 07fff65c ... OK
> > KASLR: No safe seed for randomizing the kernel base.
> > OF: reserved mem: initialized node qman-fqd, compatible id fsl,qman-fqd
> > OF: reserved mem: initialized node qman-pfdr, compatible id fsl,qman-pfdr
> > OF: reserved mem: initialized node bman-fbpr, compatible id fsl,bman-fbpr
> > Memory CAM mapping: 64/64/64 Mb, residual: 12032Mb
> 
> When boot from 04000000, the max CAM value is 64M. And
> you have a board with 12G memory, CONFIG_LOWMEM_CAM_NUM=3 means only
> 192M memory is mapped and when kernel is randomized at the middle of 
> this 192M memory, we will not have enough continuous memory for node map.
> 
> Can you set CONFIG_LOWMEM_CAM_NUM=8 and see if it works?

OK, that worked.

-Scott


