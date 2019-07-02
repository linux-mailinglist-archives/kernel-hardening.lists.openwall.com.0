Return-Path: <kernel-hardening-return-16336-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id E50885D7B9
	for <lists+kernel-hardening@lfdr.de>; Tue,  2 Jul 2019 23:04:37 +0200 (CEST)
Received: (qmail 21870 invoked by uid 550); 2 Jul 2019 21:04:23 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 21688 invoked from network); 2 Jul 2019 21:04:22 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=J16txpvD6crWhAckWE6BboqMLkAT12cPF5gNz9ExJwA=;
        b=E3gLQw9mKHY/Fcw0ZxM8vXmbDXhZJn9D1Wn7+WmSj97gCToebQuUuWFN+FHHCE+8Q3
         Dvx0vKSeoS4V4DDR2BpjdtGf/X9CSitRIehO3SxIa7b8YYc2rqNgRLci7CYNRof6Hrnr
         g9vrKlnEanUfrIOAhht8Az5U4MuO5KNYn2TPw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=J16txpvD6crWhAckWE6BboqMLkAT12cPF5gNz9ExJwA=;
        b=N5yvDk8O6fw7GRO9kgL3dR372en02u/HougvijyjhlYzYCIuoQ9eQixdUzAD/UPPJS
         1rRNO+mx+Kn6cegAMxY8ZbeEx7d2rktvC9fm/RZEXn2gZjRRb6aWA380So8k9T+gwl91
         9xRmhS/iMHi83EYRq/+zzWnnb3o0o3j8usMDoMmuWd5rdlYABtUfhwLQyWs+qaimbOyd
         8nwEpyiY3ApJRB6L42lAzpQlkgHS87QGf5bPj/biaVIFs/z1iF92UranMyVlICBRSmi2
         +HQJBqt5NwwJTo8NhL7ZpFVDJyjSvKXKp09qlfCR48rGNnI8Mg0CPYfIZzex6h6XMO5z
         uJlQ==
X-Gm-Message-State: APjAAAVlhyZiPrx20lRhnYCLhvEcdNiSs5Rn27ET4PK/EsEIFCsPD/iE
	iGu7DgP3uEmmAVapav3xEInybw==
X-Google-Smtp-Source: APXvYqy4GQRKf3WV2n+0pL2XmtLT3UM4VQi1dyoowFZBM/oD3KnU42bTm5qa8paTOnHTq2/k16CCJQ==
X-Received: by 2002:a17:902:a40c:: with SMTP id p12mr37604090plq.146.1562101450427;
        Tue, 02 Jul 2019 14:04:10 -0700 (PDT)
Date: Tue, 2 Jul 2019 08:51:23 -0700
From: Kees Cook <keescook@chromium.org>
To: Romain Perier <romain.perier@gmail.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Shyam Saini <mayhs11saini@gmail.com>
Subject: Re: refactor tasklets to avoid unsigned long argument
Message-ID: <201907020849.FB210CA@keescook>
References: <CABgxDoJzu-Pfq78AYJmf61KqJ2A3YXNJ7jMSS6p3kCzhFox0=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABgxDoJzu-Pfq78AYJmf61KqJ2A3YXNJ7jMSS6p3kCzhFox0=w@mail.gmail.com>

On Tue, Jul 02, 2019 at 09:35:17AM +0200, Romain Perier wrote:
> I would be interested by this task (so I will mark it as "WIP" on the
> wiki). I just need context :)

Sounds good!

This task is similar to the struct timer_list refactoring. Instead of
passing an arbitrary "unsigned long" argument, it's better that the
"parent" structure that holds the tasklet should be found using
container_of(), and the argument should be the tasklet itself.

Let me know if you need more detail on what that should look like! (And
as always, double-check the sanity of this work: perhaps the refactoring
creates more problems than it solves? Part of this work item is
evaluating the work itself.)

Thanks!

-- 
Kees Cook
