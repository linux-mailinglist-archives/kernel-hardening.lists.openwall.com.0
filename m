Return-Path: <kernel-hardening-return-19854-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 60ED3264E82
	for <lists+kernel-hardening@lfdr.de>; Thu, 10 Sep 2020 21:17:16 +0200 (CEST)
Received: (qmail 19567 invoked by uid 550); 10 Sep 2020 19:17:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 19533 invoked from network); 10 Sep 2020 19:17:09 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WTUCcqNRIoS33fWn/0Jo09nwI98p4mA4fR3hKii5V3g=;
        b=GP5wEXl8UxhK+wcw6bvQ8Am/4d+n1zlegGhFVlx19po9y+fxYln7mlXhhNrTC3K8aT
         1Kpc4olKCW9bvLkkS8hjjHSD9uwEbHfJkuYPnUbjnGPZbnVQ6u58EWyooJkMwgGX8n7h
         EsOtvSQQsa/3CRyuEbiS3dBB8W0i4oB9WOQOA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WTUCcqNRIoS33fWn/0Jo09nwI98p4mA4fR3hKii5V3g=;
        b=dQsWtudu+r0CMcrXSldioezEddcO5DDGJ035tEw3Cfz95ht/aNVr5xXBHuwdthYkxy
         /axLb1JXXTbBj+AANLFatlhK9tvwYhdtuMVuvUudonfTd2LJDAgMofsVAgYuM0msw/ih
         GkYceGVv4wirzuanx2FPtwVLm1Iu70ouszN6slKeDjAlWKnkZ0XQz+DvKxL4TJ7kygeE
         0cEUpUHdcI2qeyeCfIjsIliwelu7k2o5pN1VIkp7UCiGK1WOAWRQmKipPO7PcwlOr4Hm
         9dFPRDtp9A3Olef9++b+IMw2wAYs2tvXqBYMSHab7I4atBpOe9PfHgFSwznOVUeD8Oqu
         SyHg==
X-Gm-Message-State: AOAM533AiZBUx4/Qero8E/s2VYDk65kiC7LqNNmmUxgBCr/+o/wzXzMw
	NmCgIfj1tWsuXVAbc4h4Mim6yQ==
X-Google-Smtp-Source: ABdhPJxB4PeK4jJudm2ddbNQtmc+Mb5hPIfiGDzHr6/1df0l5PgqUj2b0a/gbvPaj2mmUYK8b9fLJQ==
X-Received: by 2002:a17:902:8f88:b029:d0:cbe1:e719 with SMTP id z8-20020a1709028f88b02900d0cbe1e719mr7176681plo.39.1599765417304;
        Thu, 10 Sep 2020 12:16:57 -0700 (PDT)
Date: Thu, 10 Sep 2020 12:16:55 -0700
From: Kees Cook <keescook@chromium.org>
To: Elena Petrova <lenaptr@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched.h: drop in_ubsan field when UBSAN is in trap mode
Message-ID: <202009101216.1F173BD87D@keescook>
References: <20200910134802.3160311-1-lenaptr@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200910134802.3160311-1-lenaptr@google.com>

On Thu, Sep 10, 2020 at 02:48:02PM +0100, Elena Petrova wrote:
> in_ubsan field of task_struct is only used in lib/ubsan.c, which in its
> turn is used only `ifneq ($(CONFIG_UBSAN_TRAP),y)`.
> 
> Removing unnecessary field from a task_struct will help preserve the
> ABI between vanilla and CONFIG_UBSAN_TRAP'ed kernels. In particular,
> this will help enabling bounds sanitizer transparently for Android's
> GKI.
> 
> Signed-off-by: Elena Petrova <lenaptr@google.com>

Acked-by: Kees Cook <keescook@chromium.org>

(This should be CCed to akpm who has been taking most of the ubsan
patches lately.)

-- 
Kees Cook
