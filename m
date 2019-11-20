Return-Path: <kernel-hardening-return-17409-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 7798E1043AE
	for <lists+kernel-hardening@lfdr.de>; Wed, 20 Nov 2019 19:51:31 +0100 (CET)
Received: (qmail 15477 invoked by uid 550); 20 Nov 2019 18:51:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 15440 invoked from network); 20 Nov 2019 18:51:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mn+nCBQ8MjgT+fYEd4BfZVfrpR1Vy2KWBRbsCtWJECg=;
        b=BCDJYM3fK8xymWgfzI2Qds6ZpSjZqAQlDES//MqsDNY8WXRgBmOUZpFTAH9Md4r542
         LsmIYpY+/sDVEbSoqoninE1aCmWqcg5LO40xEtapuYot+yixhXxJzhEFSwSWKrzCynOI
         AVqG7XDEBLzLHS+GJOLPKetMcG0ympwwaM/Z4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mn+nCBQ8MjgT+fYEd4BfZVfrpR1Vy2KWBRbsCtWJECg=;
        b=HGKtiQ6/DH4ULGpTJvGHqEkvZOkM1006xCAzYX4cgsTo1VEfrjzIPFxh7AafSFUPRY
         N6Ncdrh0qYYOGatZUha0xUcHglBypkziExpEBW8GHxCXrxQSDbyw0yDhIQ4B0La9FqJh
         OJnPdMPEFhEwEKuPG5gnindiJtC94AuiEG7I9ohEvwGT7Xdl3pHrr+1pikm+plKNh5+L
         uCZru2Nc1ROCkrce61+UjmlqBVk3PNy3Ke3eFdq6bqX5POSdWNpla9bdrQj4atjgpPiK
         UGMHeDyIEO5QHTYaw8F5+gkVzKQqjRD+u0awvZoF5GEfg71ENhXsRQHuXnNpRMUP8K7X
         MgNg==
X-Gm-Message-State: APjAAAVnntYf58v+t31a2gziGXXszvx86GyGUt0A9gloKxzJHP+kkc23
	Z52QknzGwbPMB2EbohEKIZrN0Q==
X-Google-Smtp-Source: APXvYqzFi23pyUkvMFe0Ie/Eu60vm+BM13HMViW37nMsXp1BESp6LP52/K0Kga/co6nHh+jfQ8PYqQ==
X-Received: by 2002:a17:902:7c04:: with SMTP id x4mr4547952pll.0.1574275872166;
        Wed, 20 Nov 2019 10:51:12 -0800 (PST)
Date: Wed, 20 Nov 2019 10:51:10 -0800
From: Kees Cook <keescook@chromium.org>
To: Jason Yan <yanaijie@huawei.com>
Cc: mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org,
	diana.craciun@nxp.com, christophe.leroy@c-s.fr,
	benh@kernel.crashing.org, paulus@samba.org, npiggin@gmail.com,
	kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
	oss@buserror.net
Subject: Re: [PATCH 0/6] implement KASLR for powerpc/fsl_booke/64
Message-ID: <201911201050.9182A9DC@keescook>
References: <20191115093209.26434-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191115093209.26434-1-yanaijie@huawei.com>

On Fri, Nov 15, 2019 at 05:32:03PM +0800, Jason Yan wrote:
> This is a try to implement KASLR for Freescale BookE64 which is based on
> my earlier implementation for Freescale BookE32:
> https://patchwork.ozlabs.org/project/linuxppc-dev/list/?series=131718

Whee! :) I've updated https://github.com/KSPP/linux/issues/3 with a link
to this current series.

-- 
Kees Cook
