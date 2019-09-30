Return-Path: <kernel-hardening-return-16974-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id C2D6AC29FF
	for <lists+kernel-hardening@lfdr.de>; Tue,  1 Oct 2019 00:51:02 +0200 (CEST)
Received: (qmail 26220 invoked by uid 550); 30 Sep 2019 22:50:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 26187 invoked from network); 30 Sep 2019 22:50:57 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6MjsCez01MJez4TDbsfLSE93xWuS4Gvd16w1GMXEeO8=;
        b=NjEdv72s435uy6CscMtY4rpTP9iU8DZ13HB+2R7hUPYqOycO1mhFPmqMwrRLgG8BM/
         5/igMILKP5k+yzoh4OzTGwZFWnFLB+EpCvYdpqnI3fTEv10gQlcBttW76qz8tPSYn8Cx
         K0mxbBSPCn2u0VkMry6aCvsNiSW71KS/Bt9RU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6MjsCez01MJez4TDbsfLSE93xWuS4Gvd16w1GMXEeO8=;
        b=MGmhsG58oIyegIGJB6DK+BGYO5q8KAgeC+c0i4LklVFswk/lpLQufymw/LHnNT+EtN
         wUios0iioOp+J+3MCEK9S+8ApQAzex9X9r7gUGMBFhgS0cPjftO5jugGE+rubyzdBQUf
         vizZ1kVD8zjkqiOOQHI28UPBH1JP3XY+a/qwUO06jiaK9TrD8jIdbOwV7b0TGQI1JmSF
         16peEj9MoSiIwkebJN++lFP+QNnZh/+W1y0jEQUOWZ9bjW9Bs1r8qrcKD3D5Q1MFAEzT
         V5VBxMlsgy0eOxDnpk59R7OZRJzB0gnKTd9CPV25df75saXBEy6aO8nCzh3iTr+jOGEh
         YsNw==
X-Gm-Message-State: APjAAAU5eSTAe/IbKFTY48V9E5LL+8kyRmCSmIjFPOm+xdpSwXJ+Hboa
	t5I6PJXskCwqHho0CWxo+PsuBgYDD0I=
X-Google-Smtp-Source: APXvYqwkPwey6QLlFY/Lkr+mVVrYDdmoNC4uEBySQoZaN8mnKTPg4c/D+om8QY0gTDPLUXJkJCS6Bg==
X-Received: by 2002:a62:170b:: with SMTP id 11mr23332986pfx.243.1569883845083;
        Mon, 30 Sep 2019 15:50:45 -0700 (PDT)
Date: Mon, 30 Sep 2019 15:50:43 -0700
From: Kees Cook <keescook@chromium.org>
To: Romain Perier <romain.perier@gmail.com>
Cc: kernel-hardening@lists.openwall.com
Subject: Re: [PRE-REVIEW PATCH 14/16] tasklet: Remove the data argument from
 DECLARE_TASKLET() macros
Message-ID: <201909301550.AC2B21665A@keescook>
References: <20190929163028.9665-1-romain.perier@gmail.com>
 <20190929163028.9665-15-romain.perier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190929163028.9665-15-romain.perier@gmail.com>

On Sun, Sep 29, 2019 at 06:30:26PM +0200, Romain Perier wrote:
> Now that the .data field is removed from the tasklet_struct data
> structure and the DECLARE_TASKLET() macros body, we can change its API
> and remove the data argument. This commit updates the API of these
> macros by removing the data argument, it also update all the calls to
> these macros in a single shot.
> 
> Signed-off-by: Romain Perier <romain.perier@gmail.com>
> ---
>  drivers/net/wan/farsync.c              | 4 ++--
>  drivers/staging/most/dim2/dim2.c       | 2 +-
>  drivers/staging/octeon/ethernet-tx.c   | 2 +-
>  drivers/tty/vt/keyboard.c              | 2 +-
>  drivers/usb/gadget/udc/snps_udc_core.c | 2 +-
>  include/linux/interrupt.h              | 4 ++--
>  kernel/backtracetest.c                 | 2 +-
>  kernel/debug/debug_core.c              | 2 +-
>  kernel/irq/resend.c                    | 2 +-
>  net/atm/pppoatm.c                      | 2 +-
>  sound/drivers/pcsp/pcsp_lib.c          | 2 +-
>  11 files changed, 13 insertions(+), 13 deletions(-)

I'm glad there are so few users of the DECLARE_TASKLET() macros. :)

-- 
Kees Cook
