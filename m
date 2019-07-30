Return-Path: <kernel-hardening-return-16620-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 11E0579D88
	for <lists+kernel-hardening@lfdr.de>; Tue, 30 Jul 2019 02:47:30 +0200 (CEST)
Received: (qmail 23613 invoked by uid 550); 30 Jul 2019 00:47:23 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 23579 invoked from network); 30 Jul 2019 00:47:22 -0000
Subject: Re: [RFC PATCH 02/10] powerpc: move memstart_addr and kernstart_addr
 to init-common.c
To: Christoph Hellwig <hch@infradead.org>
CC: <mpe@ellerman.id.au>, <linuxppc-dev@lists.ozlabs.org>,
	<diana.craciun@nxp.com>, <christophe.leroy@c-s.fr>,
	<benh@kernel.crashing.org>, <paulus@samba.org>, <npiggin@gmail.com>,
	<keescook@chromium.org>, <kernel-hardening@lists.openwall.com>,
	<wangkefeng.wang@huawei.com>, <linux-kernel@vger.kernel.org>,
	<jingxiangfeng@huawei.com>, <thunder.leizhen@huawei.com>,
	<fanchengyang@huawei.com>, <yebin10@huawei.com>
References: <20190717080621.40424-1-yanaijie@huawei.com>
 <20190717080621.40424-3-yanaijie@huawei.com>
 <20190729143155.GA11737@infradead.org>
From: Jason Yan <yanaijie@huawei.com>
Message-ID: <1c9f87ef-cd75-2312-146b-9380c634cf3b@huawei.com>
Date: Tue, 30 Jul 2019 08:47:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190729143155.GA11737@infradead.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.96.203]
X-CFilter-Loop: Reflected



On 2019/7/29 22:31, Christoph Hellwig wrote:
> I think you need to keep the more restrictive EXPORT_SYMBOL_GPL from
> the 64-bit code to keep the intention of all authors intact.
> 

Oh yes, I will fix in v2. Thanks.

> .
> 

