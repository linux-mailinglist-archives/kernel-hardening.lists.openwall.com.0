Return-Path: <kernel-hardening-return-19176-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 9A27720B223
	for <lists+kernel-hardening@lfdr.de>; Fri, 26 Jun 2020 15:07:41 +0200 (CEST)
Received: (qmail 30023 invoked by uid 550); 26 Jun 2020 13:07:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 29991 invoked from network); 26 Jun 2020 13:07:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593176842;
	bh=16hSAoBgkzFDqdIECQ7sxZWZ9kzrW7zU6H3vwJLq6tc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=m1uqulmq0ck9PhOoNMR80zbtNsBuc3vZMydFHgVM30eTcDTQO3CKLyb/jUwyfJJZM
	 2exOrslcDYFlIGzMLEfeX9UpbMqiw1CrmHw13q9X7FXlbUqbuKyPcf1jM0VAYrDny4
	 oKfGjmf2Vzxb2fapvoQGZTBOm0R0qqWcjevv7yOY=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Fri, 26 Jun 2020 14:07:20 +0100
From: Marc Zyngier <maz@kernel.org>
To: Oscar Carter <oscar.carter@gmx.com>, "Rafael J. Wysocki"
 <rjw@rjwysocki.net>
Cc: Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>,
 Jason Cooper <jason@lakedaemon.net>, Len Brown <lenb@kernel.org>,
 kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
 linux-acpi@vger.kernel.org
Subject: Re: [PATCH v5 0/3] drivers/acpi: Remove function callback casts
In-Reply-To: <20200530143430.5203-1-oscar.carter@gmx.com>
References: <20200530143430.5203-1-oscar.carter@gmx.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <07911cc62ef21900c43aeefbcbfc8d9f@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: oscar.carter@gmx.com, rjw@rjwysocki.net, keescook@chromium.org, tglx@linutronix.de, jason@lakedaemon.net, lenb@kernel.org, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Hi Rafael,

On 2020-05-30 15:34, Oscar Carter wrote:
> In an effort to enable -Wcast-function-type in the top-level Makefile 
> to
> support Control Flow Integrity builds, there are the need to remove all
> the function callback casts in the acpi driver.
> 
> The first patch creates a macro called 
> ACPI_DECLARE_SUBTABLE_PROBE_ENTRY
> to initialize the acpi_probe_entry struct using the probe_subtbl field
> instead of the probe_table field to avoid function cast mismatches.
> 
> The second patch modifies the IRQCHIP_ACPI_DECLARE macro to use the new
> defined macro ACPI_DECLARE_SUBTABLE_PROBE_ENTRY instead of the macro
> ACPI_DECLARE_PROBE_ENTRY. Also, modifies the prototype of the functions
> used by the invocation of the IRQCHIP_ACPI_DECLARE macro to match all 
> the
> parameters.
> 
> The third patch removes the function cast in the 
> ACPI_DECLARE_PROBE_ENTRY
> macro to ensure that the functions passed as a last parameter to this 
> macro
> have the right prototype. This macro is used only in another macro
> called "TIMER_ACPI_DECLARE". An this is used only in the file:
> 
> drivers/clocksource/arm_arch_timer.c
> 
> In this file, the function used in the last parameter of the
> TIMER_ACPI_DECLARE macro already has the right prototype. So there is 
> no
> need to modify its prototype.

I'd like to see this into 5.9. Can you please let me know if
you are OK with the acpi.h changes? I can queue it via the irqchip
tree.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
