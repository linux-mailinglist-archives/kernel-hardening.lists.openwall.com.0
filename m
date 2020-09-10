Return-Path: <kernel-hardening-return-19855-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 1589B264F24
	for <lists+kernel-hardening@lfdr.de>; Thu, 10 Sep 2020 21:36:06 +0200 (CEST)
Received: (qmail 28312 invoked by uid 550); 10 Sep 2020 19:36:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 28280 invoked from network); 10 Sep 2020 19:35:59 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n5g2VKT0NX2V9vUtFME4ZGEhrr3w5KhEAQNj+WuBjkQ=;
        b=eRaklC5d1OINOyJjswenVydz4ubWff2ZOHUDzyUYBYlhwIvLhATs7LPbmS8S82Z4lp
         dBBLs23oLG1A+i+tpvyMGegBDoBUu7NJEunvws8RCEl+p7/XPm3dFQhGLP+zwto9hZ69
         aTuANMTAwk4X7SoipEiYWxdEojWxpdVCrajzFV5zC/15j7GkeIt4P6Jdj5IAwzERgxWN
         ZzLU6B3a+nGAnbO9O6LclWovDfKhopwc3XhQQFjROWvXdnV2bLinzSsSbbGj/O/R6ge8
         /TDkuxc9tcNX0yee/XK3UWd/vTfdgi+Ld7e39taLQmlJQPaajw1F4ds4WpnQlTzke6W7
         lE1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n5g2VKT0NX2V9vUtFME4ZGEhrr3w5KhEAQNj+WuBjkQ=;
        b=JXpIgIXgDwO5vySCslnnsmrDRc4dGKifb2cpKQAQKykW0yR+apAA4gZNjUUJ6i6OEe
         90mB06R49pO5KT91058/9qZCd60AkXz6CJTnpBWgGMi/Pbqw30WNTv+dJHrjLPv+OtNJ
         lPg1DNW2E4CdKmeQqabIDtMk1YLqGlSBXYOPPbCp3LqycXj3s9bCqCx9Jq9iU8FQeO4B
         LOyK6Kirn4iu8ZmszLTio/IdUCFRyFztNM2vRtOikuxFVIpQyp+WEsPzOeiBt897pWfj
         /zsUXQS1958hG6q6sz3VRkzgWGC0LmPhc+eX5HgrUahWDDABgUbmb7d/CUUJYHBfwri6
         Qb0A==
X-Gm-Message-State: AOAM532jE/3Vz2n6u6mPox7VYjflAadlwhLd7fyUSlDBQDnuD1OypE+j
	Mt3cMcNSjpFGWcl7DRu1MPp5o5StbJzQK3601Foqcw==
X-Google-Smtp-Source: ABdhPJy8lW8ACRd6m8wxRF741QmPd/9at5g6mpJsh4fXdHopAzzHzh6/Rlsqaq8CbAwrVltCpTGsysH1d6lOYQ8FkEY=
X-Received: by 2002:aa7:c554:: with SMTP id s20mr11006793edr.230.1599766548307;
 Thu, 10 Sep 2020 12:35:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200910134802.3160311-1-lenaptr@google.com>
In-Reply-To: <20200910134802.3160311-1-lenaptr@google.com>
From: Jann Horn <jannh@google.com>
Date: Thu, 10 Sep 2020 21:35:22 +0200
Message-ID: <CAG48ez3x51kkDt19ONXbi8Se+2swMgwfmaj7AFbBqmss=D38Ug@mail.gmail.com>
Subject: Re: [PATCH] sched.h: drop in_ubsan field when UBSAN is in trap mode
To: Elena Petrova <lenaptr@google.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	kernel list <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, Sep 10, 2020 at 3:48 PM Elena Petrova <lenaptr@google.com> wrote:
> in_ubsan field of task_struct is only used in lib/ubsan.c, which in its
> turn is used only `ifneq ($(CONFIG_UBSAN_TRAP),y)`.
>
> Removing unnecessary field from a task_struct will help preserve the
> ABI between vanilla and CONFIG_UBSAN_TRAP'ed kernels. In particular,
> this will help enabling bounds sanitizer transparently for Android's
> GKI.

The diff looks reasonable to me, but I'm curious about the
justification in the commit message:

Is the intent here that you want to be able to build a module without
CONFIG_UBSAN and load it into a kernel that is built with
CONFIG_UBSAN? Or the inverse?

Does this mean that in the future, gating new exported functions, or
new struct fields, on CONFIG_UBSAN (independent of whether
CONFIG_UBSAN_TRAP is set) will break Android?

If you really want to do this, and using alternatives to patch out the
ubsan instructions is not an option, I wonder whether it would be more
reasonable to at least add a configuration where CONFIG_UBSAN is
enabled but the compiler flag is not actually set. Then you could
unconditionally build that android kernel and its modules with that
config option, and wouldn't have to worry about structure size issues,
dependencies on undefined symbols and so on.
