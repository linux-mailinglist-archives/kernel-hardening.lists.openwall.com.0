Return-Path: <kernel-hardening-return-17943-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 1EAD316F7F6
	for <lists+kernel-hardening@lfdr.de>; Wed, 26 Feb 2020 07:27:21 +0100 (CET)
Received: (qmail 7182 invoked by uid 550); 26 Feb 2020 06:27:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 6120 invoked from network); 26 Feb 2020 06:27:15 -0000
Subject: Re: [RFC PATCH] Use IS_ENABLED() instead of #ifdefs
To: Christophe Leroy <christophe.leroy@c-s.fr>, <mpe@ellerman.id.au>,
	<linuxppc-dev@lists.ozlabs.org>, <diana.craciun@nxp.com>,
	<benh@kernel.crashing.org>, <paulus@samba.org>, <npiggin@gmail.com>,
	<keescook@chromium.org>, <kernel-hardening@lists.openwall.com>,
	<oss@buserror.net>
CC: <linux-kernel@vger.kernel.org>, <zhaohongjiang@huawei.com>
References: <92d936b83e47f6a65866ca2d39a0d5bfefba6279.1582693094.git.christophe.leroy@c-s.fr>
From: Jason Yan <yanaijie@huawei.com>
Message-ID: <071e97e0-2772-76bf-2434-03769fc71c5a@huawei.com>
Date: Wed, 26 Feb 2020 14:26:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <92d936b83e47f6a65866ca2d39a0d5bfefba6279.1582693094.git.christophe.leroy@c-s.fr>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.221.195]
X-CFilter-Loop: Reflected



ÔÚ 2020/2/26 13:04, Christophe Leroy Ð´µÀ:
> ---
> This works for me. Only had to leave the #ifdef around the map_mem_in_cams()
> Also had to set linear_sz and ram for the alternative case, otherwise I get


Great. Thank you for the illustration.

Jason

