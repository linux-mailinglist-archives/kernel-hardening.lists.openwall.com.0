Return-Path: <kernel-hardening-return-18089-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id E13A617B004
	for <lists+kernel-hardening@lfdr.de>; Thu,  5 Mar 2020 21:51:35 +0100 (CET)
Received: (qmail 27675 invoked by uid 550); 5 Mar 2020 20:51:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 26618 invoked from network); 5 Mar 2020 20:51:30 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tycho-ws.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=H+HudSkASYAYqykfNzjJYhs/ehkqHxljholOtfs/JM8=;
        b=PQo1pucPPu8nYc2aWJc1L1kIe2vKrAY8lZuHgv6o1c/y0YWscOobJ7UA92CTHlP9OM
         KgpOdGO18c5gBe+QhFeYyl0UMc7ZaW94sL+uL5QyXQI3btX5oAEWmUz1pF6px1ojl/TB
         oKRwZJiaQwxemfvnpFIdEPchCniZUzOuEgk7Lv05Fxnt92SXYYquMY4lHTEr5ZPbbRy0
         H2LS/izwoAIU1agkmAG+rMo0cTv49NcrqZ3KB/8EbKcHTlso92hwQKBNYao5KY59jmbf
         KS+1TWrts6u6iY4GhjiZS8ueyIsyv+yyRdc5wvbHsB8V8Vq1HJnfcQBvFxiFTvCB2KTn
         NWEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=H+HudSkASYAYqykfNzjJYhs/ehkqHxljholOtfs/JM8=;
        b=pPtL4tHlZzUVjPHYNI0IZoZGg02dFa3pU1CXY61k82pJu7vcw4uaRvLrdyt82rT837
         QBMjCWvnNjPbpwlV3uY7ntwn5X68ASbVV32/dGKuQLC4k08FvvRxTLBm86sYjYf6TEiZ
         2y9eM/Apb+DLRyMgv4cD3YkBW/CnhGk/kw4aVpfvLdrDVP2EIHrA4PBFGEK4ui+2jAj/
         KEJu+d33CpP4Ifh13Gs2eDJYGmL3f9ASegzN4eclz2c4WU4j/wgpj/NlfeUCuILhdRpu
         iWqmXFGED/dTf2n8eJJQCfALZc250w2A2zWwxiX6XZ7o9k6qs38UAutWsDaDcgSCG+Vw
         ZsWw==
X-Gm-Message-State: ANhLgQ3H/Gyh9dAKkRFHqalCS6twsBuoTNF98mi9HOTGo/pg7xcEleKg
	83nKrhGJB4C62+UOvHI/MZppVw==
X-Google-Smtp-Source: ADFU+vtRxts30zPpiSD+50Cgz5G/jqp5VoSl5xCPzpgpgmakOUz9Lt/dTNP9IOFwAkDCMh+6/OSMCw==
X-Received: by 2002:a25:6b44:: with SMTP id o4mr95466ybm.345.1583441478112;
        Thu, 05 Mar 2020 12:51:18 -0800 (PST)
Date: Thu, 5 Mar 2020 13:51:11 -0700
From: Tycho Andersen <tycho@tycho.ws>
To: Arvind Sankar <nivedita@alum.mit.edu>
Cc: Kees Cook <keescook@chromium.org>, "Tobin C . Harding" <me@tobin.cc>,
	kernel-hardening@lists.openwall.com,
	Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
	linux-xtensa@linux-xtensa.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xtensa/mm: Stop printing the virtual memory layout
Message-ID: <20200305205111.GE6506@cisco>
References: <202003021038.8F0369D907@keescook>
 <20200305151144.836824-1-nivedita@alum.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200305151144.836824-1-nivedita@alum.mit.edu>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Thu, Mar 05, 2020 at 10:11:44AM -0500, Arvind Sankar wrote:
> For security, don't display the kernel's virtual memory layout.
> 
> Kees Cook points out:
> "These have been entirely removed on other architectures, so let's
> just do the same for ia32 and remove it unconditionally."
> 
> 071929dbdd86 ("arm64: Stop printing the virtual memory layout")
> 1c31d4e96b8c ("ARM: 8820/1: mm: Stop printing the virtual memory layout")
> 31833332f798 ("m68k/mm: Stop printing the virtual memory layout")
> fd8d0ca25631 ("parisc: Hide virtual kernel memory layout")
> adb1fe9ae2ee ("mm/page_alloc: Remove kernel address exposure in free_reserved_area()")
> 
> Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>

Acked-by: Tycho Andersen <tycho@tycho.ws>
