Return-Path: <kernel-hardening-return-16367-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 728D3611E9
	for <lists+kernel-hardening@lfdr.de>; Sat,  6 Jul 2019 17:32:39 +0200 (CEST)
Received: (qmail 19752 invoked by uid 550); 6 Jul 2019 15:32:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 19717 invoked from network); 6 Jul 2019 15:32:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Q/Uw5dIsHFTudDNvgVGgrJz9lD9sd+Kaa8O2sHnXsmw=; b=cmJgo3I5TzZVReZe18xORp8oxP
	VXY4xNfqtX2mnXvoN/6ZEpFJNjR9dviNSO7LpOBOvXrbcTA9HelIkGn2GEfsOomvE11BQ3jWcK4Ng
	igvVajyszClx57PmbMHN/yeS3vriO30/nDt2jk/M11usjctitA7eVWBJPGE7eglxLDy738JqLqM93
	E0jRy/EdKzzOr0Vie7pv4vCQjYbGTyIVL23duY59LFdKPtiT0J7mmWXCWTUTtsQMGuCsaS2jxcHsC
	W+5Gys7PPNHitASuKSwYx5KvL32myUym+NFbDVrTIne5ykAP5n0trGhDacbe/h+B2QN17BBiPExzb
	5edt6X1w==;
Subject: Re: [PATCH v5 08/12] S.A.R.A.: trampoline emulation
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>, linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, linux-mm@kvack.org,
 linux-security-module@vger.kernel.org,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Brad Spengler <spender@grsecurity.net>,
 Casey Schaufler <casey@schaufler-ca.com>,
 Christoph Hellwig <hch@infradead.org>,
 James Morris <james.l.morris@oracle.com>, Jann Horn <jannh@google.com>,
 Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>,
 "Serge E. Hallyn" <serge@hallyn.com>, Thomas Gleixner <tglx@linutronix.de>
References: <1562410493-8661-1-git-send-email-s.mesoraca16@gmail.com>
 <1562410493-8661-9-git-send-email-s.mesoraca16@gmail.com>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <28431b5d-c34c-a54b-acbf-70d1ae635e0d@infradead.org>
Date: Sat, 6 Jul 2019 08:31:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1562410493-8661-9-git-send-email-s.mesoraca16@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 7/6/19 3:54 AM, Salvatore Mesoraca wrote:
> diff --git a/security/sara/Kconfig b/security/sara/Kconfig
> index 54a96e0..458e0e8 100644
> --- a/security/sara/Kconfig
> +++ b/security/sara/Kconfig
> @@ -117,6 +117,24 @@ choice
>  		  Documentation/admin-guide/LSM/SARA.rst.
>  endchoice
>  
> +config SECURITY_SARA_WXPROT_EMUTRAMP
> +	bool "Enable emulation for some types of trampolines"
> +	depends on SECURITY_SARA_WXPROT
> +	depends on ARCH_HAS_LSM_PAGEFAULT
> +	depends on X86
> +	default y
> +	help
> +	  Some programs and libraries need to execute special small code
> +	  snippets from non-executable memory pages.
> +	  Most notable examples are the GCC and libffi trampolines.
> +	  This features make it possible to execute those trampolines even

	  This feature makes it possible

> +	  if they reside in non-executable memory pages.
> +	  This features need to be enabled on a per-executable basis

	  This feature needs to be

> +	  via user-space utilities.
> +	  See Documentation/admin-guide/LSM/SARA.rst. for further information.
> +
> +	  If unsure, answer y.
> +
>  config SECURITY_SARA_WXPROT_DISABLED
>  	bool "WX protection will be disabled at boot."
>  	depends on SECURITY_SARA_WXPROT


-- 
~Randy
