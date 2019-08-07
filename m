Return-Path: <kernel-hardening-return-16747-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 91C9A84C50
	for <lists+kernel-hardening@lfdr.de>; Wed,  7 Aug 2019 15:04:21 +0200 (CEST)
Received: (qmail 30405 invoked by uid 550); 7 Aug 2019 13:04:14 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 30339 invoked from network); 7 Aug 2019 13:04:12 -0000
From: Michael Ellerman <mpe@ellerman.id.au>
To: Jason Yan <yanaijie@huawei.com>, linuxppc-dev@lists.ozlabs.org, diana.craciun@nxp.com, christophe.leroy@c-s.fr, benh@kernel.crashing.org, paulus@samba.org, npiggin@gmail.com, keescook@chromium.org, kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org, wangkefeng.wang@huawei.com, yebin10@huawei.com, thunder.leizhen@huawei.com, jingxiangfeng@huawei.com, fanchengyang@huawei.com, zhaohongjiang@huawei.com, Jason Yan <yanaijie@huawei.com>
Subject: Re: [PATCH v5 09/10] powerpc/fsl_booke/kaslr: support nokaslr cmdline parameter
In-Reply-To: <20190807065706.11411-10-yanaijie@huawei.com>
References: <20190807065706.11411-1-yanaijie@huawei.com> <20190807065706.11411-10-yanaijie@huawei.com>
Date: Wed, 07 Aug 2019 23:03:56 +1000
Message-ID: <87y305t9dv.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain

Jason Yan <yanaijie@huawei.com> writes:
> diff --git a/arch/powerpc/kernel/kaslr_booke.c b/arch/powerpc/kernel/kaslr_booke.c
> index c6b326424b54..436f9a03f385 100644
> --- a/arch/powerpc/kernel/kaslr_booke.c
> +++ b/arch/powerpc/kernel/kaslr_booke.c
> @@ -361,6 +361,18 @@ static unsigned long __init kaslr_choose_location(void *dt_ptr, phys_addr_t size
>  	return kaslr_offset;
>  }
>  
> +static inline __init bool kaslr_disabled(void)
> +{
> +	char *str;
> +
> +	str = strstr(boot_command_line, "nokaslr");
> +	if (str == boot_command_line ||
> +	    (str > boot_command_line && *(str - 1) == ' '))
> +		return true;

This extra logic doesn't work for "nokaslrfoo". Is it worth it?

cheers
