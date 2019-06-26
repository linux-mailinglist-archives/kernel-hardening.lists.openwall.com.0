Return-Path: <kernel-hardening-return-16272-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id BB73257508
	for <lists+kernel-hardening@lfdr.de>; Thu, 27 Jun 2019 01:51:26 +0200 (CEST)
Received: (qmail 8083 invoked by uid 550); 26 Jun 2019 23:51:21 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 8027 invoked from network); 26 Jun 2019 23:51:20 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aAwS0GTncPUrRoyShu3maS9uw3Abq5TnViZvJ5o9Xlg=;
        b=fEadUKmwnebNmaVPpVltj8Bu3Xn+XffpgKPUz4X/5bwLlEmQx7wQbjSfCqG9Rm1nWC
         2FEzzjWI/Eg6gGm7YQPUfDM73eLXJiD7eRgsxC9xDckui3cbiV/kwgWrHySz+AS/Noul
         zeBeGK6DPbytg6NGP8feZPiGLo3kL1M49+sT4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aAwS0GTncPUrRoyShu3maS9uw3Abq5TnViZvJ5o9Xlg=;
        b=o7hm0aTgXhIZt/wwhUWuwMts8nEnI0ceEaLZBLNkYpm3weS11Ak3NY7dc/GVn5QVgK
         P7dwzrkPlaLVOKf4I9kC4mTLzCSa3NuUITEzHx6Zm5DUUTUvmnVK79vUEC1hZw7Pvz46
         XgE0BYEgyArvPfobuKbVKp8SzAFTvicHySgY5T9DapjTsDC/x2P7q7hl+HREiX6h08oG
         01HBzQbld/KXsVWZCPxoj9EcStYSF3NQfa8wOx4PiMPZh3AqhmvHi/UHa0BnYc0/yYTh
         2mVqic4ZRbmZHPIqAepQw2+VEfQ+5wazUBet5ks3hNsdjahemMLFHbEetY3lkRJsyb3B
         Mgtg==
X-Gm-Message-State: APjAAAXa+ouvnvmm1a9j4ZMJwznXd4R7xj2GGDxw8tbqsRcsrdr/as4H
	DI4l95DXpddhzSi6Yg4mNnUflw==
X-Google-Smtp-Source: APXvYqxhWsYg62JXkW4dZeiJNDMh46jecCsr79TG7tTCz6Cw+O6PJHTf0KZOUqsmpzsF3TzhlnPJSQ==
X-Received: by 2002:a63:2cd1:: with SMTP id s200mr590801pgs.439.1561593068325;
        Wed, 26 Jun 2019 16:51:08 -0700 (PDT)
Date: Wed, 26 Jun 2019 16:51:06 -0700
From: Kees Cook <keescook@chromium.org>
To: Romain Perier <romain.perier@gmail.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: Audit and fix all misuse of NLA_STRING: STATUS
Message-ID: <201906261649.F2AFDCDBE@keescook>
References: <CABgxDoLSzkVJ7Vh8mLiZySz6uS+VEu+GUxRqX8EWHKQDyz2fSg@mail.gmail.com>
 <201906200913.D2698BD0@keescook>
 <CABgxDoKQ4cnSS3p0sz8BgP65-R15U2Sr1AHVpU77ZGJu-Gvvvg@mail.gmail.com>
 <CABgxDoKTC1=5P=rnLmGzAgFs704+occs4Gw+6WyU99r4HwFBHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABgxDoKTC1=5P=rnLmGzAgFs704+occs4Gw+6WyU99r4HwFBHA@mail.gmail.com>

On Tue, Jun 25, 2019 at 06:42:48PM +0200, Romain Perier wrote:
> I have double checked.
> 
> See, https://salsa.debian.org/rperier-guest/linux-tree/raw/next/STATUS
> 
> Nothing worrying, it seems.

Excellent; thanks! Do you want to remove this from the TODO list?

-- 
Kees Cook
