Return-Path: <kernel-hardening-return-19298-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 65C9521DC68
	for <lists+kernel-hardening@lfdr.de>; Mon, 13 Jul 2020 18:32:44 +0200 (CEST)
Received: (qmail 15388 invoked by uid 550); 13 Jul 2020 16:32:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 14332 invoked from network); 13 Jul 2020 16:32:38 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OvYqhPR3ywLRItiGcXvwvSYep0JkZDTcTilUbAMAoyw=;
        b=RfxcZguEYvmQmkGRpx7lJye5zT9WILLnEhbhmSKl1AqrLRhxM8y9gtTfzfRDlX66x1
         ib5WqIcmnPIZcGPNEo2WD3z8yPHy9dHfH3HyHZ/5ax78GIwr5RwdTEvI3cmy+XiBUw56
         uSd9Sl8s4j5CIupRbPAlr9UzPnfN3LEKSlTzY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OvYqhPR3ywLRItiGcXvwvSYep0JkZDTcTilUbAMAoyw=;
        b=B984zw7KFxumZ7CfNMknKN39dmW88dKZB8fb33FJptLT6j6vYsDn5YKEMnKoSPTh4b
         HVyo5xxIfC+Xssx3Oe7EjJoeVLGncRu2l1k7Zb107niineuyD+AOpp0bcmcJY0sDGaH0
         5oNRGq8ZBUxvxaP/GOxtqmdZOArhU3ySl7OGM8Lel7fiJVgWwR0Wug1tdKPjwXodWV/5
         8HUVtdp0UAVLbO+7dJ3oVnUf2EbARNe0WDwyBteCr+PhezGQiTd6BdvmGxzdNq1xdMtR
         ElyJa0kBwXWT0oQJ4GqKqqqPGMZ19mxGoHUapfWZbzR99WBF7DmBgi9UIUQB5rk0/1Uz
         l9vA==
X-Gm-Message-State: AOAM533NE5+zvAhxnJeVPp9/sS9X5IkXwd1J98OCrGBtQ60MFjhQVJxP
	LawCv39EiJcC0tSkI6dA/TXYYPM0uRE=
X-Google-Smtp-Source: ABdhPJwVyn+Pk9SC7AVkhPqLpBMV6Wm13ViN5M4jai2zNLPp/RZKRS4va2Y7SvvCx145FW9/DOuFCg==
X-Received: by 2002:a05:6a00:14c1:: with SMTP id w1mr649973pfu.92.1594657946329;
        Mon, 13 Jul 2020 09:32:26 -0700 (PDT)
Date: Mon, 13 Jul 2020 09:32:24 -0700
From: Kees Cook <keescook@chromium.org>
To: "Alexander A. Klimov" <grandmaster@al2klimov.de>
Cc: re.emese@gmail.com, kernel-hardening@lists.openwall.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gcc-plugins: Replace HTTP links with HTTPS ones
Message-ID: <202007130932.65FA9A6@keescook>
References: <20200713135018.34708-1-grandmaster@al2klimov.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200713135018.34708-1-grandmaster@al2klimov.de>

On Mon, Jul 13, 2020 at 03:50:18PM +0200, Alexander A. Klimov wrote:
> Rationale:
> Reduces attack surface on kernel devs opening the links for MITM
> as HTTPS traffic is much harder to manipulate.
> 
> Deterministic algorithm:
> For each file:
>   If not .svg:
>     For each line:
>       If doesn't contain `\bxmlns\b`:
>         For each link, `\bhttp://[^# \t\r\n]*(?:\w|/)`:
> 	  If neither `\bgnu\.org/license`, nor `\bmozilla\.org/MPL\b`:
>             If both the HTTP and HTTPS versions
>             return 200 OK and serve the same content:
>               Replace HTTP with HTTPS.
> 
> Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>

Thanks! Applied to for-next/gcc-plugins

-- 
Kees Cook
