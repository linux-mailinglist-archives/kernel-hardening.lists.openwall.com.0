Return-Path: <kernel-hardening-return-18045-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id DABC3176E37
	for <lists+kernel-hardening@lfdr.de>; Tue,  3 Mar 2020 05:58:23 +0100 (CET)
Received: (qmail 14049 invoked by uid 550); 3 Mar 2020 04:58:14 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 14005 invoked from network); 3 Mar 2020 04:58:13 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hSEdVVVDgZdy6He5V0A4/AbbMgeYMefEzhdDiEiHlHk=;
        b=RnIhoBcaB7jH8YQOwFFgO92FuxnDQmHa9imv8vTTArH8ajkDJWyLLyaKulhmHp7Lj5
         GO2zjQoyqFOy9oXOfdkNNmrWBHrG0SjZo4J79mpYevRQemiYanOy6cYBBpyZkb2wJQ3s
         vo3cTr109M5rsMFMAVQznkfEL42U3sCNv8Q80=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hSEdVVVDgZdy6He5V0A4/AbbMgeYMefEzhdDiEiHlHk=;
        b=tVUQG74isS4T8klWO8dQDN1NmqNKoD2cIrZ7lubjddvXS9lRigzZ56/utPXapSpzVr
         H0/gaEHrbUhoosZMqZ2TJmc/y/caNj9fPOpneriC2L3zIT/VWuELoGMPT0BRvdaa9Kit
         aql+qAq1OZxdYCNfIKIA4c3Teq02Rscuz7ySQb4e33oU6W02gqErh4Ww8+Ly0WauRy6I
         YqGb6TdducIA/KxIUr00HK8lTRvBungBNAQNRPAj81pFsGlDbJ91wnpb/4YpvAGoGec8
         CV05CvQz2tpdc9JoaSCXowYXxddOmRHa4a84awVWTnif0tbdJnF24zRKOTuQZVtrFW/A
         FmXg==
X-Gm-Message-State: ANhLgQ1Wf5jkGarOBi9kIexWO/x1adaET6uNNQIprvwK3lRnkDYLwsLA
	fqzDE43FpFzMCYIWRSokK6Gyyw==
X-Google-Smtp-Source: ADFU+vvvTc8b/TBz9AayPpivbmrvSUk1WS3OUl1FwD7+cwBqVmBrUoTOPnfNlb/H3D562V7xX1GFLw==
X-Received: by 2002:a17:90a:1951:: with SMTP id 17mr2136103pjh.101.1583211481829;
        Mon, 02 Mar 2020 20:58:01 -0800 (PST)
Date: Mon, 2 Mar 2020 20:58:00 -0800
From: Kees Cook <keescook@chromium.org>
To: Thomas Garnier <thgarnie@chromium.org>
Cc: kernel-hardening@lists.openwall.com, kristen@linux.intel.com,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
	Andy Lutomirski <luto@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 06/11] x86/CPU: Adapt assembly for PIE support
Message-ID: <202003022057.D84B66E042@keescook>
References: <20200228000105.165012-1-thgarnie@chromium.org>
 <20200228000105.165012-7-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200228000105.165012-7-thgarnie@chromium.org>

On Thu, Feb 27, 2020 at 04:00:51PM -0800, Thomas Garnier wrote:
> Change the assembly code to use only relative references of symbols for the
> kernel to be PIE compatible.
> 
> Signed-off-by: Thomas Garnier <thgarnie@chromium.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  arch/x86/include/asm/processor.h | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
> index 09705ccc393c..fdf6366c482d 100644
> --- a/arch/x86/include/asm/processor.h
> +++ b/arch/x86/include/asm/processor.h
> @@ -746,11 +746,13 @@ static inline void sync_core(void)
>  		"pushfq\n\t"
>  		"mov %%cs, %0\n\t"
>  		"pushq %q0\n\t"
> -		"pushq $1f\n\t"
> +		"leaq 1f(%%rip), %q0\n\t"
> +		"pushq %q0\n\t"
>  		"iretq\n\t"
>  		UNWIND_HINT_RESTORE
>  		"1:"
> -		: "=&r" (tmp), ASM_CALL_CONSTRAINT : : "cc", "memory");
> +		: "=&r" (tmp), ASM_CALL_CONSTRAINT
> +		: : "cc", "memory");
>  #endif
>  }
>  
> -- 
> 2.25.1.481.gfbce0eb801-goog
> 

-- 
Kees Cook
