Return-Path: <kernel-hardening-return-18917-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id B56B01ECDB7
	for <lists+kernel-hardening@lfdr.de>; Wed,  3 Jun 2020 12:39:03 +0200 (CEST)
Received: (qmail 22471 invoked by uid 550); 3 Jun 2020 10:38:58 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 5374 invoked from network); 3 Jun 2020 07:15:09 -0000
X-Virus-Scanned: Debian amavisd-new at c-s.fr
X-Virus-Scanned: amavisd-new at c-s.fr
Subject: Re: [PATCH 4/5] powerpc/lib: Add LKDTM accessor for patching addr
To: "Christopher M. Riedl" <cmr@informatik.wtf>,
 linuxppc-dev@lists.ozlabs.org, kernel-hardening@lists.openwall.com
References: <20200603051912.23296-1-cmr@informatik.wtf>
 <20200603051912.23296-5-cmr@informatik.wtf>
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <a458667c-fb8d-a01f-130b-0fef733dd001@csgroup.eu>
Date: Wed, 3 Jun 2020 09:14:49 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200603051912.23296-5-cmr@informatik.wtf>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit



Le 03/06/2020 à 07:19, Christopher M. Riedl a écrit :
> When live patching a STRICT_RWX kernel, a mapping is installed at a
> "patching address" with temporary write permissions. Provide a
> LKDTM-only accessor function for this address in preparation for a LKDTM
> test which attempts to "hijack" this mapping by writing to it from
> another CPU.
> 
> Signed-off-by: Christopher M. Riedl <cmr@informatik.wtf>
> ---
>   arch/powerpc/lib/code-patching.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/arch/powerpc/lib/code-patching.c b/arch/powerpc/lib/code-patching.c
> index df0765845204..c23453049116 100644
> --- a/arch/powerpc/lib/code-patching.c
> +++ b/arch/powerpc/lib/code-patching.c
> @@ -52,6 +52,13 @@ int raw_patch_instruction(struct ppc_inst *addr, struct ppc_inst instr)
>   static struct mm_struct *patching_mm __ro_after_init;
>   static unsigned long patching_addr __ro_after_init;
>   
> +#ifdef CONFIG_LKDTM
> +unsigned long read_cpu_patching_addr(unsigned int cpu)

If this fonction is not static, it means it is intended to be used from 
some other C file, so it should be declared in a .h too.

Christophe

> +{
> +	return patching_addr;
> +}
> +#endif
> +
>   void __init poking_init(void)
>   {
>   	spinlock_t *ptl; /* for protecting pte table */
> 
