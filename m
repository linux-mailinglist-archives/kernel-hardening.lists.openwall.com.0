Return-Path: <kernel-hardening-return-18063-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 93960179AD9
	for <lists+kernel-hardening@lfdr.de>; Wed,  4 Mar 2020 22:26:13 +0100 (CET)
Received: (qmail 9363 invoked by uid 550); 4 Mar 2020 21:26:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 9331 invoked from network); 4 Mar 2020 21:26:06 -0000
Message-ID: <d673649d6f371e82d4a94ba62bfd0d44efeca7b4.camel@buserror.net>
From: Scott Wood <oss@buserror.net>
To: Daniel Axtens <dja@axtens.net>, Jason Yan <yanaijie@huawei.com>, 
 mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org, diana.craciun@nxp.com, 
 christophe.leroy@c-s.fr, benh@kernel.crashing.org, paulus@samba.org, 
 npiggin@gmail.com, keescook@chromium.org,
 kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org, zhaohongjiang@huawei.com
Date: Wed, 04 Mar 2020 15:21:21 -0600
In-Reply-To: <87tv3drf79.fsf@dja-thinkpad.axtens.net>
References: <20200206025825.22934-1-yanaijie@huawei.com>
	 <87tv3drf79.fsf@dja-thinkpad.axtens.net>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2601:449:8480:af0:12bf:48ff:fe84:c9a0
X-SA-Exim-Rcpt-To: dja@axtens.net, yanaijie@huawei.com, mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org, diana.craciun@nxp.com, christophe.leroy@c-s.fr, benh@kernel.crashing.org, paulus@samba.org, npiggin@gmail.com, keescook@chromium.org, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, zhaohongjiang@huawei.com
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
Subject: Re: [PATCH v3 0/6] implement KASLR for powerpc/fsl_booke/64
X-SA-Exim-Version: 4.2.1 (built Tue, 02 Aug 2016 21:08:31 +0000)
X-SA-Exim-Scanned: Yes (on baldur.buserror.net)

On Wed, 2020-02-26 at 18:16 +1100, Daniel Axtens wrote:
> Hi Jason,
> 
> > This is a try to implement KASLR for Freescale BookE64 which is based on
> > my earlier implementation for Freescale BookE32:
> > https://patchwork.ozlabs.org/project/linuxppc-dev/list/?series=131718
> > 
> > The implementation for Freescale BookE64 is similar as BookE32. One
> > difference is that Freescale BookE64 set up a TLB mapping of 1G during
> > booting. Another difference is that ppc64 needs the kernel to be
> > 64K-aligned. So we can randomize the kernel in this 1G mapping and make
> > it 64K-aligned. This can save some code to creat another TLB map at
> > early boot. The disadvantage is that we only have about 1G/64K = 16384
> > slots to put the kernel in.
> > 
> >     KERNELBASE
> > 
> >           64K                     |--> kernel <--|
> >            |                      |              |
> >         +--+--+--+    +--+--+--+--+--+--+--+--+--+    +--+--+
> >         |  |  |  |....|  |  |  |  |  |  |  |  |  |....|  |  |
> >         +--+--+--+    +--+--+--+--+--+--+--+--+--+    +--+--+
> >         |                         |                        1G
> >         |----->   offset    <-----|
> > 
> >                               kernstart_virt_addr
> > 
> > I'm not sure if the slot numbers is enough or the design has any
> > defects. If you have some better ideas, I would be happy to hear that.
> > 
> > Thank you all.
> > 
> 
> Are you making any attempt to hide kernel address leaks in this series?
> I've just been looking at the stackdump code just now, and it directly
> prints link registers and stack pointers, which is probably enough to
> determine the kernel base address:
> 
>                   SPs:               LRs:             %pS pointer
> [    0.424506] [c0000000de403970] [c000000001fc0458] dump_stack+0xfc/0x154
> (unreliable)
> [    0.424593] [c0000000de4039c0] [c000000000267eec] panic+0x258/0x5ac
> [    0.424659] [c0000000de403a60] [c0000000024d7a00]
> mount_block_root+0x634/0x7c0
> [    0.424734] [c0000000de403be0] [c0000000024d8100]
> prepare_namespace+0x1ec/0x23c
> [    0.424811] [c0000000de403c60] [c0000000024d7010]
> kernel_init_freeable+0x804/0x880
> 
> git grep \\\"REG\\\" arch/powerpc shows a few other uses like this, all
> in process.c or in xmon.
> 
> Maybe replacing the REG format string in KASLR mode would be sufficient?

Whatever we decide to do here, it's not book3e-specific so it should be
considered separately from these patches.

-Scott


