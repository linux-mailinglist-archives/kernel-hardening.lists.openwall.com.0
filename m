Return-Path: <kernel-hardening-return-16566-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id DF7AF72213
	for <lists+kernel-hardening@lfdr.de>; Wed, 24 Jul 2019 00:15:46 +0200 (CEST)
Received: (qmail 17907 invoked by uid 550); 23 Jul 2019 22:15:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 17865 invoked from network); 23 Jul 2019 22:15:40 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Icfg5DcCCEWimw0gGN65g6qUR7rCNKmXBTgcheDTHT0=;
        b=AAitTFh2B1QRrWnzVv1syYfrHTyY0naNYdK1DbZWAxXpVZ82DU0Irl3dPPzLxjGCt7
         luuUN83r3FbCK99c2hnssohgwYEk2pxj1VRGiN1xIRzQT8xC4hSWm2QIcASeTD1gbsUX
         E0aHWa9Xodhg1vNuqeTUbyoDE69Y4OaK1BCU8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Icfg5DcCCEWimw0gGN65g6qUR7rCNKmXBTgcheDTHT0=;
        b=aESHLA0uLlTU6ZZB3O8+WwUYiKiHin6roFXKLMefWPtd0Dvc21eOh6Wtcdwj6t/08g
         ps2m/CbiH1CzWEkle0ezLPkNTh6cODrRd0uSZJiQsTU7M4sEA5o9QnlEpMSvBd2F3Jut
         01mhV743HhBQmPdDL0ltZLjIabqF+Unyxbsdh8Sgrf0QPxwEH1QRwNEMZQ/JlsIJFdv8
         uy5FqleTMkGGiCA9z4AEOoPKMcA6LpTBE5txgydb0DPyJZmrwZxW9F86oMaar1qtKuQV
         yxwQWOHDGvh24xs/yOyCjUR/BlE1Joxnfn1CpfX6tntafsvFpKpYcIaOvIyjploQA/16
         3XDQ==
X-Gm-Message-State: APjAAAXAVzguPmrFKpSXusF9xGpEXBSClG/Vmo8KxH/TitTSYR9++tTB
	plvRh9KWfajh/gdjU2ESQncgisoqTfk=
X-Google-Smtp-Source: APXvYqxoNU4NH/h4TE8rzkylhvVL55TyYXlrleqGKlj7SubNJWr2FLU6Gr22QEQzgWsjYYr7scRn5g==
X-Received: by 2002:a17:902:1129:: with SMTP id d38mr83569879pla.220.1563920129029;
        Tue, 23 Jul 2019 15:15:29 -0700 (PDT)
Date: Tue, 23 Jul 2019 15:15:27 -0700
From: Kees Cook <keescook@chromium.org>
To: Ondrej Mosnacek <omosnace@redhat.com>
Cc: selinux@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
	NitinGote <nitin.r.gote@intel.com>,
	kernel-hardening@lists.openwall.com,
	William Roberts <bill.c.roberts@gmail.com>
Subject: Re: [PATCH v2] selinux: check sidtab limit before adding a new entry
Message-ID: <201907231515.DCFF5B6582@keescook>
References: <20190723065059.30101-1-omosnace@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190723065059.30101-1-omosnace@redhat.com>

On Tue, Jul 23, 2019 at 08:50:59AM +0200, Ondrej Mosnacek wrote:
> We need to error out when trying to add an entry above SIDTAB_MAX in
> sidtab_reverse_lookup() to avoid overflow on the odd chance that this
> happens.
> 
> Fixes: ee1a84fdfeed ("selinux: overhaul sidtab to fix bug and improve performance")
> Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  security/selinux/ss/sidtab.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/security/selinux/ss/sidtab.c b/security/selinux/ss/sidtab.c
> index e63a90ff2728..1f0a6eaa2d6a 100644
> --- a/security/selinux/ss/sidtab.c
> +++ b/security/selinux/ss/sidtab.c
> @@ -286,6 +286,11 @@ static int sidtab_reverse_lookup(struct sidtab *s, struct context *context,
>  		++count;
>  	}
>  
> +	/* bail out if we already reached max entries */
> +	rc = -EOVERFLOW;
> +	if (count >= SIDTAB_MAX)
> +		goto out_unlock;
> +
>  	/* insert context into new entry */
>  	rc = -ENOMEM;
>  	dst = sidtab_do_lookup(s, count, 1);
> -- 
> 2.21.0
> 

-- 
Kees Cook
