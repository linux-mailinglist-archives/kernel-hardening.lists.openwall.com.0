Return-Path: <kernel-hardening-return-16178-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 55AE8499EE
	for <lists+kernel-hardening@lfdr.de>; Tue, 18 Jun 2019 09:10:34 +0200 (CEST)
Received: (qmail 11773 invoked by uid 550); 18 Jun 2019 07:10:27 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 11736 invoked from network); 18 Jun 2019 07:10:27 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BTHcQlnyDBrk/vVKoZFXaiXG2jLN3xgAFU0JZm+aOTY=;
        b=enFM3kbmp1oC0J1f6YVid+ZHzKwUdS3x2SVbP2CvT6VpLQ9fXL+v+nPWfQSoZmay5M
         lIOkbR/EXN1IID9938V6Qwo2Ji2zL4T5v8Ye5iGraaJyc2qSzLAE5dbuUmFd/2hHhrzO
         OBys/8aTUL8b0sN912nC7nI13tJJcX8EFuWYg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BTHcQlnyDBrk/vVKoZFXaiXG2jLN3xgAFU0JZm+aOTY=;
        b=M1YjFhmY5HS6Arkfups6puRn/gpOLvehF7jjnPGJBIBZ/Pt/pYLmtDZfn/00aUVu8u
         JN8zTzHSQQB3m9cHEzZRYssCbUsvdYXipCCSmd9i1c3DilG1j4R30ggLzhH2e0N/sK2+
         H0Rdtxe+d1V1vJLQkc2PSnYp8cHytFbgg0L0mETlxBhLFpkvNrmXsSA9pbcsCzZXB8Xu
         2iRHQudhqrNdUKDd/Tc1dM+AbkCBg8OnSyTGkAXyrfCKAXm9pzrHaf3zbEDTumKvQ5Ja
         KzMa94Gr9MNJPwmps56bqLAOLPqXq9zcmJzOFNJ23sJJxsXKs0vYIFC2yH3NMyrvOfBi
         HRog==
X-Gm-Message-State: APjAAAVMUuJxIjVewCtUNWVesPmhTKiNtAJophT+oQ8Ew7PCHCcjNRlB
	oVwQYDFYdFlrhtVGISmpASeo7yUinpBiUprM
X-Google-Smtp-Source: APXvYqxTuNWS0lSbNyN4XFV77XPgYGYxMNIQOVrttk/90SBJAHeqhfEiimkkJqs5HcCJp16RNDfWhA==
X-Received: by 2002:a2e:8892:: with SMTP id k18mr15855620lji.239.1560841815348;
        Tue, 18 Jun 2019 00:10:15 -0700 (PDT)
Subject: Re: [PATCH v3 1/3] lkdtm: Check for SMEP clearing protections
To: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Peter Zijlstra <peterz@infradead.org>, Dave Hansen <dave.hansen@intel.com>,
 linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
References: <20190618045503.39105-1-keescook@chromium.org>
 <20190618045503.39105-2-keescook@chromium.org>
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Message-ID: <580611da-fd97-e82e-b604-581f105416ee@rasmusvillemoes.dk>
Date: Tue, 18 Jun 2019 09:10:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190618045503.39105-2-keescook@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 18/06/2019 06.55, Kees Cook wrote:

> +#else
> +	pr_err("FAIL: this test is x86_64-only\n");
> +#endif
> +}

Why expose it at all on all other architectures? If you wrap the
CRASHTYPE() in an #ifdef, you can also guard the whole lkdtm_UNSET_SMEP
definition (the declaration in lkdtm.h can stay, possibly with a comment
saying /* x86-64 only */).

> diff --git a/drivers/misc/lkdtm/core.c b/drivers/misc/lkdtm/core.c
> index b51cf182b031..58cfd713f8dc 100644
> --- a/drivers/misc/lkdtm/core.c
> +++ b/drivers/misc/lkdtm/core.c
> @@ -123,6 +123,7 @@ static const struct crashtype crashtypes[] = {
>  	CRASHTYPE(CORRUPT_LIST_ADD),
>  	CRASHTYPE(CORRUPT_LIST_DEL),
>  	CRASHTYPE(CORRUPT_USER_DS),
> +	CRASHTYPE(UNSET_SMEP),
>  	CRASHTYPE(CORRUPT_STACK),
>  	CRASHTYPE(CORRUPT_STACK_STRONG),
>  	CRASHTYPE(STACK_GUARD_PAGE_LEADING),
> diff --git a/drivers/misc/lkdtm/lkdtm.h b/drivers/misc/lkdtm/lkdtm.h
> index b69ee004a3f7..d7eb5a8f1da4 100644
> --- a/drivers/misc/lkdtm/lkdtm.h
> +++ b/drivers/misc/lkdtm/lkdtm.h
> @@ -26,6 +26,7 @@ void lkdtm_CORRUPT_LIST_DEL(void);
>  void lkdtm_CORRUPT_USER_DS(void);
>  void lkdtm_STACK_GUARD_PAGE_LEADING(void);
>  void lkdtm_STACK_GUARD_PAGE_TRAILING(void);
> +void lkdtm_UNSET_SMEP(void);
>  
>  /* lkdtm_heap.c */
>  void lkdtm_OVERWRITE_ALLOCATION(void);
Rasmus
