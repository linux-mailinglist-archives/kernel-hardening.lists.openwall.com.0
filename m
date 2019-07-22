Return-Path: <kernel-hardening-return-16521-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id A93C9705B2
	for <lists+kernel-hardening@lfdr.de>; Mon, 22 Jul 2019 18:50:46 +0200 (CEST)
Received: (qmail 24426 invoked by uid 550); 22 Jul 2019 16:50:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 24404 invoked from network); 22 Jul 2019 16:50:39 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=k/rr/IC+b+AYCwJkVS7iG5L4dyRMGQKjuA/sVJR994Q=;
        b=D2/khJ/uccM0e7ifGngji8tllhujFab/EMpZoqNEEWfBonhrU/b7gbtAWayI5FF4i8
         srA5U8gP2GWO48phfpjjBZNSDHzDByMRLm1UnySrJc7RFc4SKcNZCs51udT+PZu0VJg2
         cVnf8kvipv+4sr5no0ViJug5gBzRFZ1onFPw4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=k/rr/IC+b+AYCwJkVS7iG5L4dyRMGQKjuA/sVJR994Q=;
        b=l8sytP3xKO0ZXNcxTXB4imKiuNsT/wnJzts/lvor7EoQTxkHzMEW2fGpoL4/2LWLpK
         EO/5p7wOvjnn8zUpr1K/rcnsfFiw3W4yP2vuMElPiMo+XL9iygILw3R4tHTW4vq1ONLm
         KyRGkgPZaCshepCF4yJpwyBCa8iPp7gkgUPQ3Xhf55lXe7ISClOIPLENE+LZ+hd7d1mH
         C5J2LYDOZmxfFHTonjsa+If+1Sn8nXISIj/EFF6RoH+TdMFn8J2ll5AzH9hY5DCKtYtd
         2XADaAFozGJV0/j1xPqjE6tGY6s4inNwH/c/tRJ3oG/2vqIlNj2mNAIIJVa53rR7lLXC
         sYpg==
X-Gm-Message-State: APjAAAWDcJpjtq0gFFqVdkASLxQiRMXf5GUIrApBP+lptlhwfDQ3dvz9
	FD+W7ql986oMzYX0G613xBdNBQ==
X-Google-Smtp-Source: APXvYqxwNoQslvK+01tS+iio6up2ZIza4GT6x75SDtylvByFPBUJY96xDK06HHEF02ZC3ljYUTIILg==
X-Received: by 2002:a65:42c6:: with SMTP id l6mr75952221pgp.442.1563814227861;
        Mon, 22 Jul 2019 09:50:27 -0700 (PDT)
Date: Mon, 22 Jul 2019 09:50:26 -0700
From: Kees Cook <keescook@chromium.org>
To: Ondrej Mosnacek <omosnace@redhat.com>
Cc: selinux@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
	NitinGote <nitin.r.gote@intel.com>,
	kernel-hardening@lists.openwall.com,
	linux-security-module@vger.kernel.org
Subject: Re: [PATCH] selinux: check sidtab limit before adding a new entry
Message-ID: <201907220949.AFB5B68@keescook>
References: <20190722132111.25743-1-omosnace@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190722132111.25743-1-omosnace@redhat.com>

On Mon, Jul 22, 2019 at 03:21:11PM +0200, Ondrej Mosnacek wrote:
> We need to error out when trying to add an entry above SIDTAB_MAX in
> sidtab_reverse_lookup() to avoid overflow on the odd chance that this
> happens.
> 
> Fixes: ee1a84fdfeed ("selinux: overhaul sidtab to fix bug and improve performance")
> Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>

Is this reachable from unprivileged userspace?

> ---
>  security/selinux/ss/sidtab.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/security/selinux/ss/sidtab.c b/security/selinux/ss/sidtab.c
> index e63a90ff2728..54c1ba1e79ab 100644
> --- a/security/selinux/ss/sidtab.c
> +++ b/security/selinux/ss/sidtab.c
> @@ -286,6 +286,11 @@ static int sidtab_reverse_lookup(struct sidtab *s, struct context *context,
>  		++count;
>  	}
>  
> +	/* bail out if we already reached max entries */
> +	rc = -ENOMEM;
> +	if (count == SIDTAB_MAX)

Do you want to use >= here instead?

-Kees

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
