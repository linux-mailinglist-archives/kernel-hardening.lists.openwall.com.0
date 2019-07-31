Return-Path: <kernel-hardening-return-16671-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 246177C247
	for <lists+kernel-hardening@lfdr.de>; Wed, 31 Jul 2019 14:53:36 +0200 (CEST)
Received: (qmail 22519 invoked by uid 550); 31 Jul 2019 12:53:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 22498 invoked from network); 31 Jul 2019 12:53:29 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	 bh=aeUs+tisL054K/og1W1ep85O/gPdmrMrcRsVDP6dWHA=; b=oaTRIpZMm2SA2ctz/ryJdx5ia
	/LKWmt439ZZvb35/VbYw9o8t12tJoXD6aI6hksP1Xc+hICCc3+lbHuj2nrT2bZGD1twR9eAYcBLn/
	E4fayvpXE78Jw5t1qTC2DQir3SQ56cuhq76gfVZUwqhIWVMHnJr4SucdiMqH6GzfyHVgrvLzspEr6
	JvFKdCyBT4g80kxsamgYcCog1sbUPhjzsmhDI3r3QnLSV/wR0XpPExqeFZbaEJuIgqkq8O0zqND35
	Ko51GPcra8ktSo4PMvM4DARlpmoUDUTy+UxkL/JmshGg8qarRhlaIOSNQ+vtaaJyNIRbpM938EXsL
	5GTiOT9LQ==;
Date: Wed, 31 Jul 2019 14:53:06 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Garnier <thgarnie@chromium.org>
Cc: kernel-hardening@lists.openwall.com, kristen@linux.intel.com,
	keescook@chromium.org, Juergen Gross <jgross@suse.com>,
	Thomas Hellstrom <thellstrom@vmware.com>,
	"VMware, Inc." <pv-drivers@vmware.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
	virtualization@lists.linux-foundation.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 10/11] x86/paravirt: Adapt assembly for PIE support
Message-ID: <20190731125306.GU31381@hirez.programming.kicks-ass.net>
References: <20190730191303.206365-1-thgarnie@chromium.org>
 <20190730191303.206365-11-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190730191303.206365-11-thgarnie@chromium.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Jul 30, 2019 at 12:12:54PM -0700, Thomas Garnier wrote:
> if PIE is enabled, switch the paravirt assembly constraints to be
> compatible. The %c/i constrains generate smaller code so is kept by
> default.
> 
> Position Independent Executable (PIE) support will allow to extend the
> KASLR randomization range below 0xffffffff80000000.
> 
> Signed-off-by: Thomas Garnier <thgarnie@chromium.org>
> Acked-by: Juergen Gross <jgross@suse.com>
> ---
>  arch/x86/include/asm/paravirt_types.h | 25 +++++++++++++++++++++----
>  1 file changed, 21 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
> index 70b654f3ffe5..fd7dc37d0010 100644
> --- a/arch/x86/include/asm/paravirt_types.h
> +++ b/arch/x86/include/asm/paravirt_types.h
> @@ -338,9 +338,25 @@ extern struct paravirt_patch_template pv_ops;
>  #define PARAVIRT_PATCH(x)					\
>  	(offsetof(struct paravirt_patch_template, x) / sizeof(void *))
>  
> +#ifdef CONFIG_X86_PIE
> +#define paravirt_opptr_call "a"
> +#define paravirt_opptr_type "p"
> +
> +/*
> + * Alternative patching requires a maximum of 7 bytes but the relative call is
> + * only 6 bytes. If PIE is enabled, add an additional nop to the call
> + * instruction to ensure patching is possible.
> + */
> +#define PARAVIRT_CALL_POST  "nop;"

I'm confused; where does the 7 come from? The relative call is 6 bytes,
a normal call is 5 bytes (which is what we normally replace them with),
and the longest 'native' sequence we seem to have is also 6 bytes
(.cpu_usergs_sysret64).

> +#else
> +#define paravirt_opptr_call "c"
> +#define paravirt_opptr_type "i"
> +#define PARAVIRT_CALL_POST  ""
> +#endif
> +
>  #define paravirt_type(op)				\
>  	[paravirt_typenum] "i" (PARAVIRT_PATCH(op)),	\
> -	[paravirt_opptr] "i" (&(pv_ops.op))
> +	[paravirt_opptr] paravirt_opptr_type (&(pv_ops.op))
>  #define paravirt_clobber(clobber)		\
>  	[paravirt_clobber] "i" (clobber)
>  
> @@ -379,9 +395,10 @@ int paravirt_disable_iospace(void);
>   * offset into the paravirt_patch_template structure, and can therefore be
>   * freely converted back into a structure offset.
>   */
> -#define PARAVIRT_CALL					\
> -	ANNOTATE_RETPOLINE_SAFE				\
> -	"call *%c[paravirt_opptr];"
> +#define PARAVIRT_CALL						\
> +	ANNOTATE_RETPOLINE_SAFE					\
> +	"call *%" paravirt_opptr_call "[paravirt_opptr];"	\
> +	PARAVIRT_CALL_POST
