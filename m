Return-Path: <kernel-hardening-return-16720-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id BAB6782D45
	for <lists+kernel-hardening@lfdr.de>; Tue,  6 Aug 2019 09:59:44 +0200 (CEST)
Received: (qmail 21775 invoked by uid 550); 6 Aug 2019 07:59:39 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 21738 invoked from network); 6 Aug 2019 07:59:39 -0000
Authentication-Results: localhost; dkim=pass
	reason="1024-bit key; insecure key"
	header.d=c-s.fr header.i=@c-s.fr header.b=KFxQJm9j; dkim-adsp=pass;
	dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
	t=1565078366; bh=5YDv6dgHqzqllJC8kOdquh3d9tD4kkNE+Dq/5rv/yKs=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
	b=KFxQJm9jm+lxXqyhh6dliy3lQUqobK1qGDV7RjvFSl3PoKQSYuhWGF/pKMVIMfMdW
	 /pqEOIY6pXA1umTwCLQafvpwujltnxD7WzRA3bC5bWspTt4n4pzeq//6UBzXjt4prz
	 2MiJS42SMHOtAlHV37pdB+evxeLnlJIC3jFcBrIU=
X-Virus-Scanned: amavisd-new at c-s.fr
Subject: Re: [PATCH v4 09/10] powerpc/fsl_booke/kaslr: support nokaslr cmdline
 parameter
To: Jason Yan <yanaijie@huawei.com>, mpe@ellerman.id.au,
 linuxppc-dev@lists.ozlabs.org, diana.craciun@nxp.com,
 benh@kernel.crashing.org, paulus@samba.org, npiggin@gmail.com,
 keescook@chromium.org, kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org, wangkefeng.wang@huawei.com,
 yebin10@huawei.com, thunder.leizhen@huawei.com, jingxiangfeng@huawei.com,
 fanchengyang@huawei.com, zhaohongjiang@huawei.com
References: <20190805064335.19156-1-yanaijie@huawei.com>
 <20190805064335.19156-10-yanaijie@huawei.com>
From: Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <e7703798-c2e2-c75f-1001-46c01db88238@c-s.fr>
Date: Tue, 6 Aug 2019 09:59:26 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190805064335.19156-10-yanaijie@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit



Le 05/08/2019 à 08:43, Jason Yan a écrit :
> One may want to disable kaslr when boot, so provide a cmdline parameter
> 'nokaslr' to support this.
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> Cc: Diana Craciun <diana.craciun@nxp.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Christophe Leroy <christophe.leroy@c-s.fr>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Kees Cook <keescook@chromium.org>
> Reviewed-by: Diana Craciun <diana.craciun@nxp.com>
> Tested-by: Diana Craciun <diana.craciun@nxp.com>

Reviewed-by: Christophe Leroy <christophe.leroy@c-s.fr>

Tiny comment below.

> ---
>   arch/powerpc/kernel/kaslr_booke.c | 14 ++++++++++++++
>   1 file changed, 14 insertions(+)
> 
> diff --git a/arch/powerpc/kernel/kaslr_booke.c b/arch/powerpc/kernel/kaslr_booke.c
> index 4b3f19a663fc..7c3cb41e7122 100644
> --- a/arch/powerpc/kernel/kaslr_booke.c
> +++ b/arch/powerpc/kernel/kaslr_booke.c
> @@ -361,6 +361,18 @@ static unsigned long __init kaslr_choose_location(void *dt_ptr, phys_addr_t size
>   	return kaslr_offset;
>   }
>   
> +static inline __init bool kaslr_disabled(void)
> +{
> +	char *str;
> +
> +	str = strstr(boot_command_line, "nokaslr");
> +	if ((str == boot_command_line) ||
> +	    (str > boot_command_line && *(str - 1) == ' '))
> +		return true;

I don't think additional () are needed for the left part 'str == 
boot_command_line'

> +
> +	return false;
> +}
> +
>   /*
>    * To see if we need to relocate the kernel to a random offset
>    * void *dt_ptr - address of the device tree
> @@ -376,6 +388,8 @@ notrace void __init kaslr_early_init(void *dt_ptr, phys_addr_t size)
>   	kernel_sz = (unsigned long)_end - KERNELBASE;
>   
>   	kaslr_get_cmdline(dt_ptr);
> +	if (kaslr_disabled())
> +		return;
>   
>   	offset = kaslr_choose_location(dt_ptr, size, kernel_sz);
>   
> 
