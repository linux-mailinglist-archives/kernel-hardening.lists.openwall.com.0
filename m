Return-Path: <kernel-hardening-return-17858-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id A654D165F2F
	for <lists+kernel-hardening@lfdr.de>; Thu, 20 Feb 2020 14:50:54 +0100 (CET)
Received: (qmail 9853 invoked by uid 550); 20 Feb 2020 13:50:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 9816 invoked from network); 20 Feb 2020 13:50:49 -0000
Authentication-Results: localhost; dkim=pass
	reason="1024-bit key; insecure key"
	header.d=c-s.fr header.i=@c-s.fr header.b=CNWrIpY9; dkim-adsp=pass;
	dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
	t=1582206636; bh=BBvK55B0LYyWjBw8+VjTb6XCT0ZX1sFMbmdMfCez4Qc=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
	b=CNWrIpY9gD8poAlxwObDNLUNcxZT+TJtZIHaddLxG1IAZNLiUgfUDUuRP33FCBueN
	 JaBmGKUyfzqOhMRkqEQXbq1nI1HXoGTvbNi1QW1tTtC73d/qd/1PmQuL+bSbyU2BWN
	 j7JLZIO4kMUzwqpwwZcL+6oKCA3sT8Ka7ofn34M4=
X-Virus-Scanned: amavisd-new at c-s.fr
Subject: Re: [PATCH v3 6/6] powerpc/fsl_booke/kaslr: rename kaslr-booke32.rst
 to kaslr-booke.rst and add 64bit part
To: Jason Yan <yanaijie@huawei.com>, mpe@ellerman.id.au,
 linuxppc-dev@lists.ozlabs.org, diana.craciun@nxp.com,
 benh@kernel.crashing.org, paulus@samba.org, npiggin@gmail.com,
 keescook@chromium.org, kernel-hardening@lists.openwall.com, oss@buserror.net
Cc: linux-kernel@vger.kernel.org, zhaohongjiang@huawei.com
References: <20200206025825.22934-1-yanaijie@huawei.com>
 <20200206025825.22934-7-yanaijie@huawei.com>
From: Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <77c4a404-3ce5-5090-bbff-aaca71507146@c-s.fr>
Date: Thu, 20 Feb 2020 14:50:36 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200206025825.22934-7-yanaijie@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit



Le 06/02/2020 à 03:58, Jason Yan a écrit :
> Now we support both 32 and 64 bit KASLR for fsl booke. Add document for
> 64 bit part and rename kaslr-booke32.rst to kaslr-booke.rst.
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> Cc: Scott Wood <oss@buserror.net>
> Cc: Diana Craciun <diana.craciun@nxp.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Christophe Leroy <christophe.leroy@c-s.fr>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Kees Cook <keescook@chromium.org>
> ---
>   .../{kaslr-booke32.rst => kaslr-booke.rst}    | 35 ++++++++++++++++---
>   1 file changed, 31 insertions(+), 4 deletions(-)
>   rename Documentation/powerpc/{kaslr-booke32.rst => kaslr-booke.rst} (59%)

Also update Documentation/powerpc/index.rst ?

Christophe
