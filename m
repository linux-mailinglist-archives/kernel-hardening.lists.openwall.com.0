Return-Path: <kernel-hardening-return-18021-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id F26841744E3
	for <lists+kernel-hardening@lfdr.de>; Sat, 29 Feb 2020 05:35:41 +0100 (CET)
Received: (qmail 28374 invoked by uid 550); 29 Feb 2020 04:35:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 28342 invoked from network); 29 Feb 2020 04:35:35 -0000
Message-ID: <4c0e7fec63dbc7b91fa6c24692c73c256c131f51.camel@buserror.net>
From: Scott Wood <oss@buserror.net>
To: Jason Yan <yanaijie@huawei.com>, Daniel Axtens <dja@axtens.net>, 
 mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org, diana.craciun@nxp.com, 
 christophe.leroy@c-s.fr, benh@kernel.crashing.org, paulus@samba.org, 
 npiggin@gmail.com, keescook@chromium.org,
 kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org, zhaohongjiang@huawei.com
Date: Fri, 28 Feb 2020 22:28:39 -0600
In-Reply-To: <dd8db870-b607-3f74-d3bc-a8d9f33f9852@huawei.com>
References: <20200206025825.22934-1-yanaijie@huawei.com>
	 <87tv3drf79.fsf@dja-thinkpad.axtens.net>
	 <8171d326-5138-4f5c-cff6-ad3ee606f0c2@huawei.com>
	 <e8cd8f287934954cfa07dcf76ac73492e2d49a5b.camel@buserror.net>
	 <dd8db870-b607-3f74-d3bc-a8d9f33f9852@huawei.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2601:449:8480:af0:12bf:48ff:fe84:c9a0
X-SA-Exim-Rcpt-To: yanaijie@huawei.com, dja@axtens.net, mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org, diana.craciun@nxp.com, christophe.leroy@c-s.fr, benh@kernel.crashing.org, paulus@samba.org, npiggin@gmail.com, keescook@chromium.org, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, zhaohongjiang@huawei.com
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

On Fri, 2020-02-28 at 14:47 +0800, Jason Yan wrote:
> 
> 在 2020/2/28 13:53, Scott Wood 写道:
> > On Wed, 2020-02-26 at 16:18 +0800, Jason Yan wrote:
> > > Hi Daniel,
> > > 
> > > 在 2020/2/26 15:16, Daniel Axtens 写道:
> > > > Maybe replacing the REG format string in KASLR mode would be
> > > > sufficient?
> > > > 
> > > 
> > > Most archs have removed the address printing when dumping stack. Do we
> > > really have to print this?
> > > 
> > > If we have to do this, maybe we can use "%pK" so that they will be
> > > hidden from unprivileged users.
> > 
> > I've found the addresses to be useful, especially if I had a way to dump
> > the
> > stack data itself.  Wouldn't the register dump also be likely to give away
> > the
> > addresses?
> 
> If we have to print the address, then kptr_restrict and dmesg_restrict
> must be set properly so that unprivileged users cannot see them.

And how does that work with crash dumps that could be from any context?

dmesg_restrict is irrelevant as it just controls who can see the dmesg, not
what goes into it.  kptr_restrict=1 will only get the value if you're not in
any sort of IRQ, *and* if the crashing context happened to have CAP_SYSLOG. 
No other value of kptr_restrict will ever get you the raw value.

> > 
> > I don't see any debug setting for %pK (or %p) to always print the actual
> > address (closest is kptr_restrict=1 but that only works in certain
> > contexts)... from looking at the code it seems it hashes even if kaslr is
> > entirely disabled?  Or am I missing something?
> > 
> 
> Yes, %pK (or %p) always hashes whether kaslr is disabled or not. So if
> we want the real value of the address, we cannot use it. But if you only
> want to distinguish if two pointers are the same, it's ok.

Am I the only one that finds this a bit crazy?  If you want to lock a system
down then fine, but why wage war on debugging even when there's no
randomization going on?  Comparing two pointers for equality is not always
adequate.

-Scott


