Return-Path: <kernel-hardening-return-17390-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 1DB7DFE339
	for <lists+kernel-hardening@lfdr.de>; Fri, 15 Nov 2019 17:50:06 +0100 (CET)
Received: (qmail 7685 invoked by uid 550); 15 Nov 2019 16:50:01 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 7651 invoked from network); 15 Nov 2019 16:50:00 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ptqDM2bmHnot4adtaFSv3VaRZd83rjxzM9yPEL0ZiVQ=;
        b=QYMnEMQdAAVP1ErDUxIsFQ6DlszLOn9whrvq/Y2SkMm3zbUFH+xz7ZikY3RfYWSyFL
         CgLAPq64BHMWfuyf6WB4hq42WvHXD1+xlybGrdxKdVwbyB7Goxz+ZSO9LU3F6eWD2L5g
         ONFqp4+EO1xyjzoG/IdQWW4dq6e9+ckLUvZjQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ptqDM2bmHnot4adtaFSv3VaRZd83rjxzM9yPEL0ZiVQ=;
        b=PuYvPtfKTyflufNVT9WH0yFXOKAMkJW5kon1YkT/tXahSwfM4NhOgH9zlGjwGVJfUj
         fXlsspP8ofynWSrIBqFzxZBpNHEWgGYS9ZfZKYWe4OuNv4Xg9tfJ8GNlriw3zDNB+aG/
         UYvH0U0CZDIUAqJo+1nYVkqxKB2Sn0m5v5G+0n1beL2foBclTCPBNHiVG1odkRezq27S
         2yKapQObXdOrFoQzTmykW+iobt66kYyBPYORWyDxBqX7PxbfUdXYc3yo0S5bkrBcey8n
         d1KrxLcRPc+ahvvANeQpq0jpzqmf4LqnO4aeTgj3LXIaM4fei8TXG28+TfikVnXk5Dhy
         m8Xg==
X-Gm-Message-State: APjAAAUM39OXPqzigqc/0GdBTAeescricrkFGcyWxiC/s8AfgljUz5kI
	iJh3n90SkGDq7xrycaVaTDw40Q==
X-Google-Smtp-Source: APXvYqx05o7Lzkd/xkkJdoxu2DTq4WyYxecLtO0mGNyWyc+EB6il/XJ0N+kSYVGwAcNEssnj4S4clA==
X-Received: by 2002:a17:902:6903:: with SMTP id j3mr7357486plk.231.1573836588247;
        Fri, 15 Nov 2019 08:49:48 -0800 (PST)
Date: Fri, 15 Nov 2019 08:49:24 -0800
From: Kees Cook <keescook@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com,
	Romain Perier <romain.perier@gmail.com>
Subject: Re: [PATCH] staging: rtl*: Remove tasklet callback casts
Message-ID: <201911150848.4518DFCA1@keescook>
References: <201911142135.5656E23@keescook>
 <20191115061610.GA1034830@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191115061610.GA1034830@kroah.com>

On Fri, Nov 15, 2019 at 02:16:10PM +0800, Greg Kroah-Hartman wrote:
> On Thu, Nov 14, 2019 at 09:39:00PM -0800, Kees Cook wrote:
> > In order to make the entire kernel usable under Clang's Control Flow
> > Integrity protections, function prototype casts need to be avoided
> > because this will trip CFI checks at runtime (i.e. a mismatch between
> > the caller's expected function prototype and the destination function's
> > prototype). Many of these cases can be found with -Wcast-function-type,
> > which found that the rtl wifi drivers had a bunch of needless function
> > casts. Remove function casts for tasklet callbacks in the various drivers.
> > 
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > ---
> >  drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c        |  3 +--
> >  drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c        |  3 +--
> >  drivers/staging/rtl8188eu/include/rtl8188e_recv.h     |  2 +-
> >  drivers/staging/rtl8188eu/include/rtl8188e_xmit.h     |  2 +-
> >  drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c      |  4 ++--
> >  drivers/staging/rtl8192e/rtllib_softmac.c             |  7 +++----
> >  .../staging/rtl8192u/ieee80211/ieee80211_softmac.c    |  7 +++----
> >  drivers/staging/rtl8192u/r8192U_core.c                |  8 ++++----
> >  drivers/staging/rtl8712/rtl8712_recv.c                | 11 +++++------
> >  drivers/staging/rtl8712/rtl871x_xmit.c                |  5 ++---
> >  drivers/staging/rtl8712/rtl871x_xmit.h                |  2 +-
> >  drivers/staging/rtl8712/usb_ops_linux.c               |  4 ++--
> >  drivers/staging/rtl8723bs/hal/rtl8723bs_recv.c        | 11 ++++-------
> >  13 files changed, 30 insertions(+), 39 deletions(-)
> 
> This fails to apply to my staging-next branch of staging.git.  Can you
> rebase and resend?

Ah, hrm, sorry. I think I was based on Linus's master. I will adjust!

-- 
Kees Cook
