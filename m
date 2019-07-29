Return-Path: <kernel-hardening-return-16618-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id B33DA78E2E
	for <lists+kernel-hardening@lfdr.de>; Mon, 29 Jul 2019 16:38:42 +0200 (CEST)
Received: (qmail 6068 invoked by uid 550); 29 Jul 2019 14:38:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 32563 invoked from network); 29 Jul 2019 14:33:02 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	 bh=1Qg4ugmQtTe6Jeu2janlNWnIvWzDuxv0JhGbvOZJApQ=; b=kvEqu8lIKNg3YVqWqPEw2/3Ef
	y1fnYT8Taww0z//ZgQ7QYqmocWNLDKRrGSQ8/M/wanZx7bA/Hle3i04bGRo2t+gfVHKpuhd8Tm4fq
	LzhbJ/fD04hxID9rhr/4uKUB9Z7nVIqnX4tWA7NbSDh0oNsJyGUg67I61bW7824DqgrXPj+SvzjSh
	2oYczPWXn7b03CdKoQFOWxRU83ICc2vboQZvCdK4PXZp2k5s59QoldBUXuEPwFJAgY1Vk9tdyeh/r
	B00n0Q5SY8OAMeA4TOMOCjPPaRWDF+kzzigGj6E+nS89LDXnpteW+2DDu0exatN7HxC4LdcD4CnYx
	fBn5Jtv7A==;
Date: Mon, 29 Jul 2019 07:32:36 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jason Yan <yanaijie@huawei.com>
Cc: mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org,
	diana.craciun@nxp.com, christophe.leroy@c-s.fr,
	benh@kernel.crashing.org, paulus@samba.org, npiggin@gmail.com,
	keescook@chromium.org, kernel-hardening@lists.openwall.com,
	wangkefeng.wang@huawei.com, linux-kernel@vger.kernel.org,
	jingxiangfeng@huawei.com, thunder.leizhen@huawei.com,
	fanchengyang@huawei.com, yebin10@huawei.com
Subject: Re: [RFC PATCH 03/10] powerpc: introduce kimage_vaddr to store the
 kernel base
Message-ID: <20190729143236.GB11737@infradead.org>
References: <20190717080621.40424-1-yanaijie@huawei.com>
 <20190717080621.40424-4-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190717080621.40424-4-yanaijie@huawei.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jul 17, 2019 at 04:06:14PM +0800, Jason Yan wrote:
> Now the kernel base is a fixed value - KERNELBASE. To support KASLR, we
> need a variable to store the kernel base.

This should probably merged into the patch actually using it.
