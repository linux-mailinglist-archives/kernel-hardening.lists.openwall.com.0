Return-Path: <kernel-hardening-return-16086-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 980F23BDB0
	for <lists+kernel-hardening@lfdr.de>; Mon, 10 Jun 2019 22:44:14 +0200 (CEST)
Received: (qmail 32474 invoked by uid 550); 10 Jun 2019 20:44:09 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 32439 invoked from network); 10 Jun 2019 20:44:09 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gGkvTXexIvtGceUSn9utzUe5r2LZ4KzdTUdP48ifM+M=;
        b=Bb8kTA6m4nCVFqOZtIEow9B13diQQNAYO8m9rlqG++JOoSNrXLWXby9ed3Bni8SyO1
         bq6hT7oA7piaplqbJyrPVSnzDlVIh+ZOAWXVQ2dZ80jC1vxUnBIWgrLFhzzmqzKjchm7
         Is84tMr3rRtCEV29RhB4YU6BwQ8ZLetMaY8RY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gGkvTXexIvtGceUSn9utzUe5r2LZ4KzdTUdP48ifM+M=;
        b=owbI1cVSCgOcmdfLirbtexBizWBWQ6XmUEVYNaHY1r/kPoRpLSzxaJ+j5mccYY/AbW
         mP/K4Hn0CdOZI1zSPxepY3SM0sUO2e6K0Smw9PBLFUS+u8HgudvRefXvU0IEtM2cLaZh
         3BmcOX85ggx25hsbVe+rjRP0YkXypObdDxT259g3RYcQTxhajk0IZK01cGTbeIaqp/L9
         aOaAdQ2vMCPLowZsXIlIxkLpAlo3OQ4lgU12SkXahER5D7AdzyapvscjJo6AGNQCgoyO
         BCoTL+V472AxAkKqtyJQjPxstdnHB85w+WysSoVGwk3E3a6kSJdJaH3HxkaHbeBelcsM
         ELXg==
X-Gm-Message-State: APjAAAXals0SVq9zyexJTiZ0ufHmnSbRr8mbrWQRzD/RZqE5Judyqczy
	kiRT3r9qyo3MkdRFYNuNCOKtHg==
X-Google-Smtp-Source: APXvYqy7M61GS3qaZ6++vW5tfTL75JMbeYx+TwRj+kwl4qiCMPZwUchxHuhnjBXiQZmwgvCv0DGxvg==
X-Received: by 2002:a17:90a:f488:: with SMTP id bx8mr22845554pjb.91.1560199437374;
        Mon, 10 Jun 2019 13:43:57 -0700 (PDT)
Date: Mon, 10 Jun 2019 13:43:55 -0700
From: Kees Cook <keescook@chromium.org>
To: Andy Lutomirski <luto@kernel.org>
Cc: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/5] x86/vsyscall: Add a new vsyscall=xonly mode
Message-ID: <201906101342.B8A938BB@keescook>
References: <cover.1560198181.git.luto@kernel.org>
 <131caabf9d127db1a077525f978e1f1f74f9088f.1560198181.git.luto@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <131caabf9d127db1a077525f978e1f1f74f9088f.1560198181.git.luto@kernel.org>

On Mon, Jun 10, 2019 at 01:25:28PM -0700, Andy Lutomirski wrote:
> With vsyscall emulation on, we still expose a readable vsyscall page
> that contains syscall instructions that validly implement the
> vsyscalls.  We need this because certain dynamic binary
> instrumentation tools attempt to read the call targets of call
> instructions in the instrumented code.  If the instrumented code
> uses vsyscalls, then the vsyscal page needs to contain readable
> code.
> 
> Unfortunately, leaving readable memory at a deterministic address
> can be used to help various ASLR bypasses, so we gain some hardening
> value if we disallow vsyscall reads.
> 
> Given how rarely the vsyscall page needs to be readable, add a
> mechanism to make the vsyscall page be execute only.

Should the commit log mention that the VVAR portion goes away under
xonly? (Since it's not executable.)

Otherwise, yay! Looks good to me and thanks for updating the selftests!

-Kees

> @@ -357,7 +368,7 @@ void __init map_vsyscall(void)
>  	extern char __vsyscall_page;
>  	unsigned long physaddr_vsyscall = __pa_symbol(&__vsyscall_page);
>  
> -	if (vsyscall_mode != NONE) {
> +	if (vsyscall_mode == EMULATE) {
>  		__set_fixmap(VSYSCALL_PAGE, physaddr_vsyscall,
>  			     PAGE_KERNEL_VVAR);
>  		set_vsyscall_pgtable_user_bits(swapper_pg_dir);
> -- 
> 2.21.0
> 

-- 
Kees Cook
