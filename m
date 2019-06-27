Return-Path: <kernel-hardening-return-16306-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 6EFE05885E
	for <lists+kernel-hardening@lfdr.de>; Thu, 27 Jun 2019 19:30:34 +0200 (CEST)
Received: (qmail 1235 invoked by uid 550); 27 Jun 2019 17:30:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1190 invoked from network); 27 Jun 2019 17:30:27 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=32ILLvfn9IklGj2iVrOoB65eWBa8/V+GUb3UmuBUZsA=;
        b=K6jcBLWG1PUhzqSS3gXcuJxACOyXxSDQMCT0XZN8LuhrKm7ke/8lCWFT3TJG0dd6gG
         O3yGe+vnV25OBXXgmTNowCZwthRAm6m00sh1Hz7ca0NbI/1lKg1Cp71oaNRWWn8yyt7V
         orGQZqCWs6YR3Qos6+QwPOHsh6ZCIF2lZ1B6A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=32ILLvfn9IklGj2iVrOoB65eWBa8/V+GUb3UmuBUZsA=;
        b=t226CC20Jrb4fQB3rLGFVnRK181IVGn56D6ALpl4eneHCsoh08/BoaVvzC2TG1miL0
         qjckhibjOuzq+oV+1gE3ErQd61n67RPoyH96ZPpt9ss050CvixobL6dyuYEBHEZvzHQt
         PloL7GCx7Hy2VNoSEuvk3VPvcvJIV0wLnUGbmKnugWI6O/ih3w8DOQnGVnKgkM3whZvB
         0t3wMA09DH2x6PiOV/NbttsVtB1gN1s6WzZadYPbKA5W3mOKo2VckEj21QF93NP7/+4H
         fClVxEPPDCpAdfcJEV9tqXwZ2a1XLRLGSJPVKgjMSR1ROs39yWU1KFAtDMrXbSKOtret
         IyJQ==
X-Gm-Message-State: APjAAAWQbdONLSiqS/yK3IewV9GH8oU8EqH3EZyK9peN1SPHBmEPdNfM
	AsBNOteaqm4+xwHThnxOHsTHcQ==
X-Google-Smtp-Source: APXvYqw1+Ez9GlBN2zSdaHnaMFOkEGvFA7MS5ndE0eMDT+bi5WLehm+duqxlqw2K/XKlRkTKlp7HkQ==
X-Received: by 2002:a65:5303:: with SMTP id m3mr4673738pgq.393.1561656615934;
        Thu, 27 Jun 2019 10:30:15 -0700 (PDT)
Date: Thu, 27 Jun 2019 10:30:14 -0700
From: Kees Cook <keescook@chromium.org>
To: Andy Lutomirski <luto@kernel.org>
Cc: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Florian Weimer <fweimer@redhat.com>, Jann Horn <jannh@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 7/8] x86/vsyscall: Add __ro_after_init to global
 variables
Message-ID: <201906271030.A5C7F4A202@keescook>
References: <cover.1561610354.git.luto@kernel.org>
 <a386925835e49d319e70c4d7404b1f6c3c2e3702.1561610354.git.luto@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a386925835e49d319e70c4d7404b1f6c3c2e3702.1561610354.git.luto@kernel.org>

On Wed, Jun 26, 2019 at 09:45:08PM -0700, Andy Lutomirski wrote:
> The vDSO is only configurable by command-line options, so make its
> global variables __ro_after_init.  This seems highly unlikely to
> ever stop an exploit, but I think it's nice anyway.
> 
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Andy Lutomirski <luto@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  arch/x86/entry/vsyscall/vsyscall_64.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/entry/vsyscall/vsyscall_64.c b/arch/x86/entry/vsyscall/vsyscall_64.c
> index 9c58ab807aeb..07003f3f1bfc 100644
> --- a/arch/x86/entry/vsyscall/vsyscall_64.c
> +++ b/arch/x86/entry/vsyscall/vsyscall_64.c
> @@ -42,7 +42,7 @@
>  #define CREATE_TRACE_POINTS
>  #include "vsyscall_trace.h"
>  
> -static enum { EMULATE, XONLY, NONE } vsyscall_mode =
> +static enum { EMULATE, XONLY, NONE } vsyscall_mode __ro_after_init =
>  #ifdef CONFIG_LEGACY_VSYSCALL_NONE
>  	NONE;
>  #elif defined(CONFIG_LEGACY_VSYSCALL_XONLY)
> @@ -305,7 +305,7 @@ static const char *gate_vma_name(struct vm_area_struct *vma)
>  static const struct vm_operations_struct gate_vma_ops = {
>  	.name = gate_vma_name,
>  };
> -static struct vm_area_struct gate_vma = {
> +static struct vm_area_struct gate_vma __ro_after_init = {
>  	.vm_start	= VSYSCALL_ADDR,
>  	.vm_end		= VSYSCALL_ADDR + PAGE_SIZE,
>  	.vm_page_prot	= PAGE_READONLY_EXEC,
> -- 
> 2.21.0
> 

-- 
Kees Cook
