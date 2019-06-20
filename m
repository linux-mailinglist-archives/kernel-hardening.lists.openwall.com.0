Return-Path: <kernel-hardening-return-16202-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 486BC4D370
	for <lists+kernel-hardening@lfdr.de>; Thu, 20 Jun 2019 18:16:08 +0200 (CEST)
Received: (qmail 5271 invoked by uid 550); 20 Jun 2019 16:16:01 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 5237 invoked from network); 20 Jun 2019 16:16:00 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nsq9m+RydRP+UlZvf2IzXrK4/1lZHyenXYJPwSxJ9W4=;
        b=DxOiO2xD59iUl0COzdH4utRYVIqNakxud+Cq6eQ0lcRjmL6scrPZQD1+qNIw5fFhwB
         hfpjmQ5wC3TxaeAX+hWv5LNP06/POTlCzsrMAeNFmrbwQfjbxgV1udIX9xYuzwo0BYGB
         fqpXBv0PHIPd7lKVpy4HBUWYjuQ4l8YjJlX2c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nsq9m+RydRP+UlZvf2IzXrK4/1lZHyenXYJPwSxJ9W4=;
        b=TFtyb7t7g+QtLPEkWXnour4+6lL7hGse1NSqZYHKAMB7UEOMWJ5ik/3rissfgI1lN0
         rUOQ+YC234menYk1sHsuF9Q+bucoxPQpYG04wD+QzkIr6W1of5hkqRCEPekEuhfoVONI
         9crovvflVISuZwhbaDAjbDw0y93fA8wLZTovL4zc3X1wXf1nqB9g9XstLdHHSVODaSzU
         7MEqD0MFGD7oRHixCHAaxlk6L7wGMcgOYkd29gG8sbqkGKfdKJm+HlCj704rZnQ30Boz
         AtcyBtgLFP1daACZR9b24syqi4TQIXXcGR241g5+VyVgTvrYfnv1MP16hSab69IhDsp6
         hlnQ==
X-Gm-Message-State: APjAAAWblGiM7DLLNhk/kdqgFRVjOqzqqX3PD/KRNJf5NDyEfJI7nJeq
	utn6WWo5q9RB8aa9nXAfbgAIhA==
X-Google-Smtp-Source: APXvYqzLMra1QrKzoafWgGcgrSTCVYNxP99z6mFNUnM95tGX8hEid+fJXa4859vjK4FfnlKuZTRpLw==
X-Received: by 2002:a17:902:e082:: with SMTP id cb2mr7673096plb.274.1561047348118;
        Thu, 20 Jun 2019 09:15:48 -0700 (PDT)
Date: Thu, 20 Jun 2019 09:15:46 -0700
From: Kees Cook <keescook@chromium.org>
To: Romain Perier <romain.perier@gmail.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: Audit and fix all misuse of NLA_STRING: STATUS
Message-ID: <201906200913.D2698BD0@keescook>
References: <CABgxDoLSzkVJ7Vh8mLiZySz6uS+VEu+GUxRqX8EWHKQDyz2fSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABgxDoLSzkVJ7Vh8mLiZySz6uS+VEu+GUxRqX8EWHKQDyz2fSg@mail.gmail.com>

On Tue, Jun 18, 2019 at 07:56:42PM +0200, Romain Perier wrote:
> Hi !
> 
> Here a first review, you can get the complete list here:
> 
> https://salsa.debian.org/rperier-guest/linux-tree/raw/next/STATUS

Cool! You identified three issues:

net/netfilter/nfnetlink_cthelper.c:
	NF_CT_HELPER_NAME_LEN is used instead of NF_CT_EXP_POLICY_NAME_LEN

net/netfilter/ipset/ip_set_list_set.c:
	IPSET_ATTR_NAME and IPSET_ATTR_NAMEREF both have a len of
	IPSET_MAXNAMELEN for a string of size IPSET_MAXNAMELEN

net/openvswitch/conntrack.c:
	maxlen of NF_CT_HELPER_NAME_LEN with a string of size
	NF_CT_HELPER_NAME_LEN. maxlen of CTNL_TIMEOUT_NAME_MAX with a
	string of size CTNL_TIMEOUT_NAME_MAX

I haven't looked closely at this myself yet, but I think the next step
would be to write patches for each of these. And while doing that, have
an eye toward thinking about how each case could be made more robust in
the future to avoid these kinds of flaws returning.

Nice!

-- 
Kees Cook
