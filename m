Return-Path: <kernel-hardening-return-15875-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id E9906150F8
	for <lists+kernel-hardening@lfdr.de>; Mon,  6 May 2019 18:12:04 +0200 (CEST)
Received: (qmail 22413 invoked by uid 550); 6 May 2019 16:11:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 22382 invoked from network); 6 May 2019 16:11:57 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VRLKxxZ6FvYNzup+p909sc/5M3c0/QHqqC7ELR0k26g=;
        b=E3AVHE0wyNUli8mWyHnOuYA1FvAhRtnpPlDofZjEEEXZ+fzD8MT4rBQ1N5Jq2DM3he
         soNc0eOJquzOCUgdI/Sz2WuGHDBczt60gFIgd/vB/fXg04abQzaP/CxxwyukG/wx7qu5
         bRCZyTJGqxRc+Exw+QEOszcQNS4/pwRUUGdx8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VRLKxxZ6FvYNzup+p909sc/5M3c0/QHqqC7ELR0k26g=;
        b=j+VtrkxUpCfCgIhUuhsZa+b7ah5XQQTLpElCxxotXtcJ2P7ajLUeXaS6IQidqBRIPb
         SwG6iYnsIv3zzNTTEBFIGrng7g/p2A+Uz/Tq7LPDQLbQnTRphKcXAroZxOO8BrTbzLHr
         A1KMEtSCRj61mdntpN2PsmhtOaXZIR0SS0MlJG6lxAT0R7oC8Uus30Dy/lDEkmNA+jjL
         pHzk+o3iH/X0Bm8LG1Ux4bbdxOmtq5D1nqsvHpEBq6LSJQj7SwNnDGeCZJ9QuuGpShvQ
         T4+e8Ksg8XXiyW3RN5rd8FtDkzV0S4Wan2qR3d+E3//TUMarHeteP8xGlJ4Z+5b2kJJO
         V17w==
X-Gm-Message-State: APjAAAU929DGErXiLSj3Jb66lT7pdS4HgBn1RdfQAQreDhCpIcjBHuo9
	qj4reWemNrP2RCuxQRX04eFqUoYKeyg=
X-Google-Smtp-Source: APXvYqxpG5jABkvzQAJhr9xcCy1EHcAyTn59+aGzLF83jN6LU9LKH20+Vdw+vrZVpjc91SWT2wA1qg==
X-Received: by 2002:a1f:1604:: with SMTP id 4mr14332233vkw.3.1557159104428;
        Mon, 06 May 2019 09:11:44 -0700 (PDT)
X-Received: by 2002:a1f:3a14:: with SMTP id h20mr2052024vka.52.1557159102657;
 Mon, 06 May 2019 09:11:42 -0700 (PDT)
MIME-Version: 1.0
References: <CAOMdWSLNUEMux1hXfWP+oxZ3YG=uycDmAomGA1iTxjfyOYA0WQ@mail.gmail.com>
In-Reply-To: <CAOMdWSLNUEMux1hXfWP+oxZ3YG=uycDmAomGA1iTxjfyOYA0WQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 6 May 2019 09:11:30 -0700
X-Gmail-Original-Message-ID: <CAGXu5j+Eo-ewWL2_RtBaVN9msAdA3Pgu8H7uBxVcc=b5DMBy5g@mail.gmail.com>
Message-ID: <CAGXu5j+Eo-ewWL2_RtBaVN9msAdA3Pgu8H7uBxVcc=b5DMBy5g@mail.gmail.com>
Subject: Re: [RFC] refactor tasklets to avoid unsigned long argument
To: Allen <allen.lkml@gmail.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, tglx@linuxtronix.de
Content-Type: text/plain; charset="UTF-8"

On Mon, May 6, 2019 at 2:32 AM Allen <allen.lkml@gmail.com> wrote:
>   I have been toying with the idea of "refactor tasklets to avoid
> unsigned long argument" since Kees listed on KSPP wiki. I wanted to
> and have kept the implementation very simple. Let me know what you
> guys think.
>
> Note: I haven't really done much of testing besides boot testing with small
> set of files moved to the new api.
>
>   My only concern with the implementation is, in the kernel the combination
> of tasklet_init/DECLARE_TAKSLET is seen in over ~400 plus files.
> With the change(dropping unsigned long argument) there will be huge list
> of patches migrating to the new api.

Yeah, this is the main part of the work for making this change. When
the timer API got changed, I had to do a two-stage change so we could
convert the users incrementally, and then finalize the API change to
drop the old style.

Beyond that, yeah, everything you sent looks good. It's just the
matter of building a series of patches to do it without breaking the
world. (Though if it's small enough, maybe it could be a single patch?
But I doubt that would be doable...)

-- 
Kees Cook
