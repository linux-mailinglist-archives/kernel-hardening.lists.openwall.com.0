Return-Path: <kernel-hardening-return-19107-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 2FA4E2077E6
	for <lists+kernel-hardening@lfdr.de>; Wed, 24 Jun 2020 17:50:19 +0200 (CEST)
Received: (qmail 32031 invoked by uid 550); 24 Jun 2020 15:50:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 31999 invoked from network); 24 Jun 2020 15:50:13 -0000
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Jason Yan <yanaijie@huawei.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] ACPI: Eliminate usage of uninitialized_var() macro
Date: Wed, 24 Jun 2020 17:49:59 +0200
Message-ID: <2128012.4yIOnhsQJz@kreacher>
In-Reply-To: <20200615040047.3535543-1-yanaijie@huawei.com>
References: <20200615040047.3535543-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Monday, June 15, 2020 6:00:47 AM CEST Jason Yan wrote:
> This is an effort to eliminate the uninitialized_var() macro[1].
> 
> The use of this macro is the wrong solution because it forces off ANY
> analysis by the compiler for a given variable. It even masks "unused
> variable" warnings.
> 
> Quoted from Linus[2]:
> 
> "It's a horrible thing to use, in that it adds extra cruft to the
> source code, and then shuts up a compiler warning (even the _reliable_
> warnings from gcc)."
> 
> The gcc option "-Wmaybe-uninitialized" has been disabled and this change
> will not produce any warnnings even with "make W=1".
> 
> [1] https://github.com/KSPP/linux/issues/81
> [2] https://lore.kernel.org/lkml/CA+55aFz2500WfbKXAx8s67wrm9=yVJu65TpLgN_ybYNv0VEOKA@mail.gmail.com/
> 
> Cc: Kees Cook <keescook@chromium.org>
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> ---
>  drivers/acpi/acpi_pad.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/acpi_pad.c b/drivers/acpi/acpi_pad.c
> index e7dc0133f817..6cc4c92d9ff9 100644
> --- a/drivers/acpi/acpi_pad.c
> +++ b/drivers/acpi/acpi_pad.c
> @@ -88,7 +88,7 @@ static void round_robin_cpu(unsigned int tsk_index)
>  	cpumask_var_t tmp;
>  	int cpu;
>  	unsigned long min_weight = -1;
> -	unsigned long uninitialized_var(preferred_cpu);
> +	unsigned long preferred_cpu;
>  
>  	if (!alloc_cpumask_var(&tmp, GFP_KERNEL))
>  		return;
> 

Applied as 5.9 material, thanks!




