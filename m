Return-Path: <kernel-hardening-return-18866-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 09B9D1DFEBD
	for <lists+kernel-hardening@lfdr.de>; Sun, 24 May 2020 13:46:57 +0200 (CEST)
Received: (qmail 18128 invoked by uid 550); 24 May 2020 11:46:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 18084 invoked from network); 24 May 2020 11:46:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1590320797;
	bh=t6FPAdbmqROUcprpTUToZ+d/YaWfRUyQrPNoUSm1fAw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=cqN2XUbILAoV9pd917Y0YLJE2EmAh1kSZaKzNlmUo2iDeQEhrEZh5RrBbzcZ79TOp
	 6VkATfU0PrHNKD2uf/XSWvnFhWpWpNI1qyOabp3zd1F7bziXsZK5Ojb85tFeb6CiL+
	 p9RJ69/W0dJKyj2scd7LS2AO2NSS0VVdguLH3lf4=
Date: Sun, 24 May 2020 12:46:34 +0100
From: Marc Zyngier <maz@kernel.org>
To: Oscar Carter <oscar.carter@gmx.com>
Cc: Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>,
 Jason Cooper <jason@lakedaemon.net>, kernel-hardening@lists.openwall.com,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/irqchip: Remove function callback casts
Message-ID: <20200524124634.113203f6@why>
In-Reply-To: <20200524080910.13087-1-oscar.carter@gmx.com>
References: <20200524080910.13087-1-oscar.carter@gmx.com>
Organization: Approximate
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: oscar.carter@gmx.com, keescook@chromium.org, tglx@linutronix.de, jason@lakedaemon.net, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Sun, 24 May 2020 10:09:10 +0200
Oscar Carter <oscar.carter@gmx.com> wrote:

Hi Oscar,

Thanks for this. Comments below.

> In an effort to enable -Wcast-function-type in the top-level Makefile to
> support Control Flow Integrity builds, remove all the function callback
> casts.
> 
> To do this, modify the IRQCHIP_ACPI_DECLARE macro initializing the
> acpi_probe_entry struct directly instead of use the existent macro
> ACPI_DECLARE_PROBE_ENTRY.
> 
> In this new initialization use the probe_subtbl field instead of the
> probe_table field use in the ACPI_DECLARE_PROBE_ENTRY macro.

Please add *why* this is a valid transformation (probe_table and
probe_subtbl are part of a union).

> 
> Signed-off-by: Oscar Carter <oscar.carter@gmx.com>
> ---
>  include/linux/irqchip.h | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/irqchip.h b/include/linux/irqchip.h
> index 950e4b2458f0..1f464fd10df0 100644
> --- a/include/linux/irqchip.h
> +++ b/include/linux/irqchip.h
> @@ -39,8 +39,14 @@
>   * @fn: initialization function
>   */
>  #define IRQCHIP_ACPI_DECLARE(name, subtable, validate, data, fn)	\
> -	ACPI_DECLARE_PROBE_ENTRY(irqchip, name, ACPI_SIG_MADT, 		\
> -				 subtable, validate, data, fn)
> +	static const struct acpi_probe_entry __acpi_probe_##name	\
> +		__used __section(__irqchip_acpi_probe_table) = {	\
> +			.id = ACPI_SIG_MADT,				\
> +			.type = subtable,				\
> +			.subtable_valid = validate,			\
> +			.probe_subtbl = (acpi_tbl_entry_handler)fn,	\
> +			.driver_data = data,				\
> +		}
> 

I'd rather you add an ACPI_DECLARE_SUBTABLE_PROBE_ENTRY to acpi.h, and
use that here so that we can keep the ACPI gunk in a single place.

>  #ifdef CONFIG_IRQCHIP
>  void irqchip_init(void);
> --
> 2.20.1
> 
> 

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
