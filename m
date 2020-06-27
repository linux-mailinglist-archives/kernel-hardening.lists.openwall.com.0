Return-Path: <kernel-hardening-return-19184-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 4D3E220C2F7
	for <lists+kernel-hardening@lfdr.de>; Sat, 27 Jun 2020 18:11:18 +0200 (CEST)
Received: (qmail 24424 invoked by uid 550); 27 Jun 2020 16:11:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 24392 invoked from network); 27 Jun 2020 16:11:11 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GmqzFZ1buIwT4xrRi2FIHyllUAjbkOAd/H/8HxkAW6U=;
        b=dh4JYSM4NRBR8w2L+qg0N6eb1ocUwJuefZCDJ8ZAsegTTsNUdCHDIcY2KsJTT14RgX
         lmeulxGNpq4ng/Fmwb1zgiNrDYW0uFB4egI29Rc7jTu1T59KcyRuyhT/Zn9yPJpRPuSQ
         E5NYbzcoNWjOrKIiJt1IMVILm4RHgsJF72yjM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GmqzFZ1buIwT4xrRi2FIHyllUAjbkOAd/H/8HxkAW6U=;
        b=RCbRI7ZNfDsdBju3p9jSOemKMpdcnHzc5aXzOXkjhYIwmdDtMRZ+vwJjJChDUig53s
         R+qKtXq4DNOtW6V3XHL0QLFcjS/FStYjGGw0jeEQEkplSPa6bd0BKMYgNnhBwjm5swul
         Ndk+StoqWz2vpRhuCHY5Ku0WFMEEPbiSyeupp27PEywK6VVJ4O79Wq0eRDmDkdsur51j
         XOjvPiidrxbcPeirkYFfbl2Fkas+WFHjL2kW2DcLrEt5jV3ynD52iG02UoCQGgsCRs56
         NjWgW7x4vPl19Rxb/ahIrC4tQ6JprbEFmbNhKDaC4LohMRhTNI8vZl5/rIfp3j9WHad5
         oJKw==
X-Gm-Message-State: AOAM532LU/uPd+Zt9zkRHKcWeStzoEs3FJwQ0X1LDCEaojFD4xznwV5t
	p7o1gHt+akDjhEeU61aC+Jm5Vg==
X-Google-Smtp-Source: ABdhPJxvFEkA27nw2gBUVjy1fli8GztX/RD0yA8MQhKOnpjbbyyo6aVteBGz+IF4Z8iHZdIMOvTrXg==
X-Received: by 2002:a17:90a:35c:: with SMTP id 28mr1653573pjf.63.1593274258994;
        Sat, 27 Jun 2020 09:10:58 -0700 (PDT)
Date: Sat, 27 Jun 2020 09:10:56 -0700
From: Kees Cook <keescook@chromium.org>
To: Oscar Carter <oscar.carter@gmx.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	kernel-hardening@lists.openwall.com, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/s390/char/tty3270: Remove function callback casts
Message-ID: <202006270853.C40CA89806@keescook>
References: <20200627125417.18887-1-oscar.carter@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200627125417.18887-1-oscar.carter@gmx.com>

On Sat, Jun 27, 2020 at 02:54:17PM +0200, Oscar Carter wrote:
> In an effort to enable -Wcast-function-type in the top-level Makefile to
> support Control Flow Integrity builds, remove all the function callback
> casts.
> 
> To do this modify the function prototypes accordingly.
> 
> Signed-off-by: Oscar Carter <oscar.carter@gmx.com>

Oh yes, the tasklets! I'd love to see this fixed correctly. (Which is to
say, modernize the API.) Romain hasn't had time to continue the work:
https://lore.kernel.org/kernel-hardening/20190929163028.9665-1-romain.perier@gmail.com/

Is this something you'd want to tackle?

> ---
>  drivers/s390/char/tty3270.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/s390/char/tty3270.c b/drivers/s390/char/tty3270.c
> index 98d7fc152e32..aec996de44d9 100644
> --- a/drivers/s390/char/tty3270.c
> +++ b/drivers/s390/char/tty3270.c
> @@ -556,8 +556,9 @@ tty3270_scroll_backward(struct kbd_data *kbd)
>   * Pass input line to tty.
>   */
>  static void
> -tty3270_read_tasklet(struct raw3270_request *rrq)
> +tty3270_read_tasklet(unsigned long data)
>  {
> +	struct raw3270_request *rrq = (struct raw3270_request *)data;

Regardless, this is correct as far as fixing the prototype.

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
