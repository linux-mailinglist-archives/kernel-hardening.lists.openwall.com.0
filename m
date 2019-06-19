Return-Path: <kernel-hardening-return-16200-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 60E994B9EF
	for <lists+kernel-hardening@lfdr.de>; Wed, 19 Jun 2019 15:28:45 +0200 (CEST)
Received: (qmail 29911 invoked by uid 550); 19 Jun 2019 13:28:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 26017 invoked from network); 19 Jun 2019 13:24:45 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:
	From:Date:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	 bh=j6sN5C7IkKo0VmSoLyo6XUUyg4sEdn0nWOLBsgbnD9g=; b=fSaRlxSyDTuWkHDSOOoTBT+jS
	PcTn1gLcxn64vZptjHzraFyq1sQyOcqC4s2QN0IHTfM6+i095iwqXzVgXlJZbb+m7k0QScsegsCRt
	dRS7r5ZD5wFqRUzmqrrjN+yLYUJ8JM9uLkUW8tKI7K/PSPBOITFZmKJaf4ShkVTpd5rc8ExMuK4Vc
	n0AzXrlSNN22cOcjJYrtwegVpNK2RsNg5HigELYMtPIILEAekEvipF/Lam6jHWP8agf+4j4YgHVq5
	Fk30FqHmCjKFtROUxO/9kpqynZ2QKgH5r4Na/Wf4qp34ke9Gnd433ZEBYXZtHvIlFPLq5tHK0goGq
	OTKlMypXA==;
Date: Wed, 19 Jun 2019 10:24:30 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Solar Designer <solar@openwall.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
 kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v1 12/22] docs: driver-api: add .rst files from the main
 dir
Message-ID: <20190619102430.558a775e@coco.lan>
In-Reply-To: <20190619121308.GA6284@openwall.com>
References: <cover.1560890771.git.mchehab+samsung@kernel.org>
	<b0d24e805d5368719cc64e8104d64ee9b5b89dd0.1560890772.git.mchehab+samsung@kernel.org>
	<20190619114356.GP3419@hirez.programming.kicks-ass.net>
	<20190619114551.GQ3463@hirez.programming.kicks-ass.net>
	<20190619115007.GR3463@hirez.programming.kicks-ass.net>
	<20190619121308.GA6284@openwall.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Em Wed, 19 Jun 2019 14:13:08 +0200
Solar Designer <solar@openwall.com> escreveu:

> On Wed, Jun 19, 2019 at 01:50:07PM +0200, Peter Zijlstra wrote:
> > Also, cross-posting to moderated lists is rude.  
> 
> It's even worse with partially-pre-moderated lists, because then list
> moderators are forced to either accept all the mostly off-topic messages
> (as some follow-ups from other lists would get through anyway, and would
> be out of context if a message in a thread were rejected) or switch the
> list to fully pre-moderated with no exceptions for anyone (and then it's
> more work and greater delays on desirable messages).
> 
> I already brought this up with Mauro off-list, and I hope we'll see no
> more of these threads on kernel-hardening, but we'll have to let the
> rest of already started threads through.

I'll take care on a next review to explicitly remove kernel-hardening.

As I pointed in priv, as gcc-plugins file is listed at MAINTAINERS,
except if someone actively remove kernel-hardening ML from 
get_maintainers.pl results, you'll likely keep receiving e-mails with
patches that will be touching it.

> I think this has significant negative effect on the kernel-hardening
> project, shifting it further towards and beyond security circus (to
> non-security circus now) and thereby discouraging desirable
> contributions, whereas the (one relevant) file rename is unimportant
> (and buried in lots of other renames).

Sorry for that.

Thanks,
Mauro
