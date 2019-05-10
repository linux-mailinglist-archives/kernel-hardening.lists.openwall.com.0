Return-Path: <kernel-hardening-return-15917-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 4D5751A3F7
	for <lists+kernel-hardening@lfdr.de>; Fri, 10 May 2019 22:23:46 +0200 (CEST)
Received: (qmail 3161 invoked by uid 550); 10 May 2019 20:23:39 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3130 invoked from network); 10 May 2019 20:23:38 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=hnsEOtZUe8FJnEfNKVhXMIrHa1KhnNCENToE54mzqug=;
        b=cK2XokVUUCVhQ/FGj4M8aPYamNv86OpFxB0vCqs0ukb3SVTaguNp1hXqTrFpYNQKtc
         hxfiLc69rv4r3XmE7zzoezLbsAZTxDaVJ6bJR+X0c9LD1VTqA14Zv0+8gMIxSQ8Y1/Lv
         4rXhIKHcDQkrJFwhpJdcJ7FE+EnggGJQa/hzg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=hnsEOtZUe8FJnEfNKVhXMIrHa1KhnNCENToE54mzqug=;
        b=d9C3FJYvUg2JS+5lkULRQjNrzNTG99uj7I5hTUpBK9G/61WYKU76z2IuISF5VTi0V6
         Zg4iOKVM7+LtVpf6fmR9/FXwprliwBPvq5fDDZJfRdpcxEDwr4CrGCJAtIN1Z/wem8cQ
         OsD0y80LcjjthY6Yw59QAiPjoSC++Ojw8NYqNzixJ5fiwtFk9nQaP2XtOiOivHpyXz2v
         3ODD8kMVlLdZPeYueEJI40cCB5xfuIIp90yzAxu9oaPUAXyDUw9RSpHR+9Jy8P4tX4+G
         Te9UfVW3uEvflg0AUcdwvs1O4OJYj0plNzNgAcdNycqQOVJZZgJTsw9MilhhgMAPhboZ
         +Hlw==
X-Gm-Message-State: APjAAAV1qcaHI0dnB0OQe13t5HHfSPQIabWT4wOZIkDfbswKiHeJqw3q
	vXtZ76QDqXqF0gbWJhxydcvK0g==
X-Google-Smtp-Source: APXvYqxpr4wd/Z7iIJFFCvjs9GVV2R6oPWspwBFAShKC9zjxr7Xu19JweCrS/THwVUDeh+cEDCAPYQ==
X-Received: by 2002:a63:804a:: with SMTP id j71mr16475539pgd.68.1557519806949;
        Fri, 10 May 2019 13:23:26 -0700 (PDT)
Date: Fri, 10 May 2019 13:23:24 -0700
From: Kees Cook <keescook@chromium.org>
To: Chris Packham <chris.packham@alliedtelesis.co.nz>
Cc: re.emese@gmail.com, kernel-hardening@lists.openwall.com,
	linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] gcc-plugins: arm_ssp_per_task_plugin: Fix for older GCC
 < 6
Message-ID: <201905101322.BEDE5CC@keescook>
References: <20190510090025.4680-1-chris.packham@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190510090025.4680-1-chris.packham@alliedtelesis.co.nz>

On Fri, May 10, 2019 at 09:00:25PM +1200, Chris Packham wrote:
> Use gen_rtx_set instead of gen_rtx_SET. The former is a wrapper macro
> that handles the difference between GCC versions implementing
> the latter.
> 
> This fixes the following error on my system with g++ 5.4.0 as the host
> compiler
> 
>    HOSTCXX -fPIC scripts/gcc-plugins/arm_ssp_per_task_plugin.o
>  scripts/gcc-plugins/arm_ssp_per_task_plugin.c:42:14: error: macro "gen_rtx_SET" requires 3 arguments, but only 2 given
>           mask)),
>                ^
>  scripts/gcc-plugins/arm_ssp_per_task_plugin.c: In function ‘unsigned int arm_pertask_ssp_rtl_execute()’:
>  scripts/gcc-plugins/arm_ssp_per_task_plugin.c:39:20: error: ‘gen_rtx_SET’ was not declared in this scope
>     emit_insn_before(gen_rtx_SET
> 
> Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>

Thanks for this! It seems correct to me. Ard, any thoughts? I can send
it to Linus next week...

Fixes: 189af4657186 ("ARM: smp: add support for per-task stack canaries")
Cc: stable@vger.kernel.org

-Kees

> ---
>  scripts/gcc-plugins/arm_ssp_per_task_plugin.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/scripts/gcc-plugins/arm_ssp_per_task_plugin.c b/scripts/gcc-plugins/arm_ssp_per_task_plugin.c
> index 89c47f57d1ce..8c1af9bdcb1b 100644
> --- a/scripts/gcc-plugins/arm_ssp_per_task_plugin.c
> +++ b/scripts/gcc-plugins/arm_ssp_per_task_plugin.c
> @@ -36,7 +36,7 @@ static unsigned int arm_pertask_ssp_rtl_execute(void)
>  		mask = GEN_INT(sext_hwi(sp_mask, GET_MODE_PRECISION(Pmode)));
>  		masked_sp = gen_reg_rtx(Pmode);
>  
> -		emit_insn_before(gen_rtx_SET(masked_sp,
> +		emit_insn_before(gen_rtx_set(masked_sp,
>  					     gen_rtx_AND(Pmode,
>  							 stack_pointer_rtx,
>  							 mask)),
> -- 
> 2.21.0
> 

-- 
Kees Cook
