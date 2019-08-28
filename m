Return-Path: <kernel-hardening-return-16817-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 1C7CAA1986
	for <lists+kernel-hardening@lfdr.de>; Thu, 29 Aug 2019 14:05:06 +0200 (CEST)
Received: (qmail 24418 invoked by uid 550); 29 Aug 2019 12:04:58 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 10013 invoked from network); 28 Aug 2019 22:01:04 -0000
Message-ID: <827cc152757906a0ebc04bbe56cdf44683721eb4.camel@buserror.net>
From: Scott Wood <oss@buserror.net>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: linux-kernel@vger.kernel.org, wangkefeng.wang@huawei.com, 
 yebin10@huawei.com, thunder.leizhen@huawei.com, jingxiangfeng@huawei.com, 
 fanchengyang@huawei.com, zhaohongjiang@huawei.com, Jason Yan
 <yanaijie@huawei.com>,  linuxppc-dev@lists.ozlabs.org,
 diana.craciun@nxp.com, christophe.leroy@c-s.fr,  benh@kernel.crashing.org,
 paulus@samba.org, npiggin@gmail.com,  keescook@chromium.org,
 kernel-hardening@lists.openwall.com
Date: Wed, 28 Aug 2019 00:08:33 -0500
In-Reply-To: <878srf4cjk.fsf@concordia.ellerman.id.au>
References: <20190809100800.5426-1-yanaijie@huawei.com>
	 <ed96199d-715c-3f1c-39db-10a569ba6601@huawei.com>
	 <529fd908-42d6-f96f-daa2-9010f3035879@huawei.com>
	 <878srf4cjk.fsf@concordia.ellerman.id.au>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2601:449:8400:7293:12bf:48ff:fe84:c9a0
X-SA-Exim-Rcpt-To: mpe@ellerman.id.au, linux-kernel@vger.kernel.org, wangkefeng.wang@huawei.com, yebin10@huawei.com, thunder.leizhen@huawei.com, jingxiangfeng@huawei.com, fanchengyang@huawei.com, zhaohongjiang@huawei.com, yanaijie@huawei.com, linuxppc-dev@lists.ozlabs.org, diana.craciun@nxp.com, christophe.leroy@c-s.fr, benh@kernel.crashing.org, paulus@samba.org, npiggin@gmail.com, keescook@chromium.org, kernel-hardening@lists.openwall.com
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

On Tue, 2019-08-27 at 11:33 +1000, Michael Ellerman wrote:
> Jason Yan <yanaijie@huawei.com> writes:
> > A polite ping :)
> > 
> > What else should I do now?
> 
> That's a good question.
> 
> Scott, are you still maintaining FSL bits, 

Sort of... now that it's become very low volume, it's easy to forget when
something does show up (or miss it if I'm not CCed).  It'd probably help if I
were to just ack patches instead of thinking "I'll do a pull request for this
later" when it's just one or two patches per cycle.

-Scott


