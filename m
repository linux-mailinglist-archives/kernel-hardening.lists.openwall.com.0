Return-Path: <kernel-hardening-return-16230-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 7AE8D555BE
	for <lists+kernel-hardening@lfdr.de>; Tue, 25 Jun 2019 19:18:53 +0200 (CEST)
Received: (qmail 3979 invoked by uid 550); 25 Jun 2019 17:18:47 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3944 invoked from network); 25 Jun 2019 17:18:46 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=e9aHcXOS3djuX2+rj9brnQ5rO1FWrHd9VPMB1qYiIng=;
        b=LCjiUnngqp9q2yeBlDEksPSSztZCGq2aLoWu9hvrH3pTebpaLEwL8mnPJz/SagDOxM
         GKmCZAMm3yqYj74wKHqv1IfMtZZQDvfVJcup+566HQZ7HKqtfcqWEdCZfuS7kLgW/sCm
         RBV2dLgy9vDV7JPJL+16Lx9nRk3BxK5QqKPtI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=e9aHcXOS3djuX2+rj9brnQ5rO1FWrHd9VPMB1qYiIng=;
        b=lQttQiovDwD/3gilg3H0wVx1DQ8Yr8nu4R/lvWIZzb3A6xnxxW3E3e5sngHw6QMx+f
         99Wrxgq1askgIdBVtaQ5lj/PrAyMuzZ0GSDvwWnUeC75tBszPjT0M70SGzi6hwWeME8z
         dXmEgLkSM7t63YJkA8EvctNHpO37NrILaU5K6XrcErnnlK6oU92VsTKcCVHGgzXo/d6e
         WkqUTvfmQEQcUuyPqiNHoYPB1HQnjCb0PqtEppIsdBxNEXc7SI/xXB7tV6FF3ezUTEgy
         VfFkzQ2K6IC0p10CQtALmVm9547Cb/y26qDlxAFC4DoZBEIuqkyw2vcHW/xC89xcdToJ
         TR8g==
X-Gm-Message-State: APjAAAV71KnvEzesPHsjcRBIplpN4912fhVdiDBhprsJzOtKJ6B858NO
	MItWNFxUpM5JkWpytZdR2jZvJ7rGuUI=
X-Google-Smtp-Source: APXvYqxN+J6ICyTDQZ72V1otPRpYfIOiFqhdDdczVvBTWfZ2ZcbzNDjZ/LJLO05WS83ee2NbVt8o8g==
X-Received: by 2002:a63:6b46:: with SMTP id g67mr32330542pgc.45.1561483114212;
        Tue, 25 Jun 2019 10:18:34 -0700 (PDT)
Date: Tue, 25 Jun 2019 10:18:32 -0700
From: Kees Cook <keescook@chromium.org>
To: Yann Droneaud <ydroneaud@opteya.com>
Cc: kernel-hardening@lists.openwall.com
Subject: Re: Archive kernel-hardening@lists.openwall.com  on lore.kernel.org
 too
Message-ID: <201906251017.8012A503@keescook>
References: <dab4681adb58c769b8b8f580e3d2057b0f4f2607.camel@opteya.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dab4681adb58c769b8b8f580e3d2057b0f4f2607.camel@opteya.com>

On Tue, Jun 25, 2019 at 01:21:03AM +0200, Yann Droneaud wrote:
> I think it might make sense to have kernel-hardening@lists.openwall.com
>  archived on https://lore.kernel.org/lists.html to benefit from cross
> reference between various kernel related mailing list.
> 
> The process to add the list is described at 
> https://korg.wiki.kernel.org/userdoc/lore
> 
> Is having the list archived at https://lore.kernel.org/ something
> acceptable ?
> 
> Is there someone already working on it ?
> 
> If not, can I do it ?

As Solar has said, yes please. :)

Feel free to mention myself and Solar in the helpdesk@ email. There is
already a patchwork instance tracking kernel-hardening, so this
shouldn't be a surprise to the kernel.org admins. :)

-- 
Kees Cook
