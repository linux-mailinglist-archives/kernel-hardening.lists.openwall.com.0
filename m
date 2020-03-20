Return-Path: <kernel-hardening-return-18153-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 9862118C6B9
	for <lists+kernel-hardening@lfdr.de>; Fri, 20 Mar 2020 06:15:54 +0100 (CET)
Received: (qmail 12077 invoked by uid 550); 20 Mar 2020 05:15:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 12042 invoked from network); 20 Mar 2020 05:15:47 -0000
Message-ID: <db764910fe2de8ae2d63c6adbb0b71d32c0e3886.camel@buserror.net>
From: Scott Wood <oss@buserror.net>
To: Jason Yan <yanaijie@huawei.com>, mpe@ellerman.id.au, 
 linuxppc-dev@lists.ozlabs.org, diana.craciun@nxp.com,
 christophe.leroy@c-s.fr,  benh@kernel.crashing.org, paulus@samba.org,
 npiggin@gmail.com,  keescook@chromium.org,
 kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org, zhaohongjiang@huawei.com, dja@axtens.net
Date: Fri, 20 Mar 2020 00:08:53 -0500
In-Reply-To: <20200306064033.3398-7-yanaijie@huawei.com>
References: <20200306064033.3398-1-yanaijie@huawei.com>
	 <20200306064033.3398-7-yanaijie@huawei.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2601:449:8480:af0:12bf:48ff:fe84:c9a0
X-SA-Exim-Rcpt-To: yanaijie@huawei.com, mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org, diana.craciun@nxp.com, christophe.leroy@c-s.fr, benh@kernel.crashing.org, paulus@samba.org, npiggin@gmail.com, keescook@chromium.org, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, zhaohongjiang@huawei.com, dja@axtens.net
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
Subject: Re: [PATCH v4 6/6] powerpc/fsl_booke/kaslr: rename
 kaslr-booke32.rst to kaslr-booke.rst and add 64bit part
X-SA-Exim-Version: 4.2.1 (built Tue, 02 Aug 2016 21:08:31 +0000)
X-SA-Exim-Scanned: Yes (on baldur.buserror.net)

On Fri, 2020-03-06 at 14:40 +0800, Jason Yan wrote:
> @@ -38,5 +41,29 @@ bit of the entropy to decide the index of the 64M zone.
> Then we chose a
>  
>                                kernstart_virt_addr
>  
> +
> +KASLR for Freescale BookE64
> +---------------------------
> +
> +The implementation for Freescale BookE64 is similar as BookE32. One

similar to

> +difference is that Freescale BookE64 set up a TLB mapping of 1G during
> +booting. Another difference is that ppc64 needs the kernel to be
> +64K-aligned. So we can randomize the kernel in this 1G mapping and make
> +it 64K-aligned. This can save some code to creat another TLB map at early

create

-Scott


