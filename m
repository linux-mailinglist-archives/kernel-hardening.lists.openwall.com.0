Return-Path: <kernel-hardening-return-17434-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id E6C5310689F
	for <lists+kernel-hardening@lfdr.de>; Fri, 22 Nov 2019 10:08:00 +0100 (CET)
Received: (qmail 27683 invoked by uid 550); 22 Nov 2019 09:07:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 27649 invoked from network); 22 Nov 2019 09:07:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ljr/rHZhX2cKSZOMtdFMLeDFfDK4qscTIQX92Z+51jk=;
        b=t13lqmTwW8+/JGno5Gk07nvJjaKYrR5f5FQtDf/FQuBJNqezdlfd+R1Lqo6u2sCE9o
         4CJ6U0irpU617kY74B7xZ6MfT4NFdXzJ5Aw0EUiuSfdsL3YYJiaqDkPZQkqFln3hAr+6
         lCgiZ22CmSJ/IT4/cyPr5v1VE9JpkXewlPyu9Z4PtyeC27Bg7NP5nCRuFrXFM+4vDjN+
         lYMhfaePSyn/RK2K5o9jQh5HNsh/GLlmWGIHSm+zRNzhE/Tp5DvutMQPpakvtVzRP8/y
         tiF5wJv8sZCez+gaEocICDbNCXycofg3bfXYVDBPpEZ2vY+nhsQQCvPB3ztg0MX3tLjk
         808A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ljr/rHZhX2cKSZOMtdFMLeDFfDK4qscTIQX92Z+51jk=;
        b=FhYgbtHdHby8osK+GgAJ2PBrUkmuCap7AK6t75HQbPMmLx9EKMcl2z/wBs1fV90DgI
         5XkFTg/VdQgBpa9xO3MkSA2QTN/54B2hK9eGdFLtxLwfhKA+0lYK9l98iZOVAjQUj1Xq
         Nx9QFrOzksKn9e3SvuaNxCDmjU29vnlfQT15GtxhGO3zMA2tqmgLsx9cHSReU+xNQnq+
         ie96nMBA3G8C6Pl+gBMEQkBQmeRkeAalHRTy+VSVyAJakBEj1YpLrcd/LR1jZ0a3AHI4
         La2pfu8L3Z8AxZlqmbPw7+qPJrIVoP0W4hu3FtXfexnHHrw0BW8Z+folUQoz3KNSrntF
         QujQ==
X-Gm-Message-State: APjAAAX3S2xF1qhhP0gCXs+QPakuE7f47Ry+xBtP2EHHeM46bvZV+zmd
	czkT6Jf+xXU/4EhENffgszIaYOS1WuBtosaH5wr9pQ==
X-Google-Smtp-Source: APXvYqyuNa94PLnoPGiyrEBNkcWkeo4IQevYwXNAy+9m/OTWblAYAJgbB28j4btr7t9cSrDA+LBcxyqV3jdSyfW0U6o=
X-Received: by 2002:a0c:b446:: with SMTP id e6mr12863287qvf.159.1574413661601;
 Fri, 22 Nov 2019 01:07:41 -0800 (PST)
MIME-Version: 1.0
References: <20191121181519.28637-1-keescook@chromium.org>
In-Reply-To: <20191121181519.28637-1-keescook@chromium.org>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Fri, 22 Nov 2019 10:07:29 +0100
Message-ID: <CACT4Y+b3JZM=TSvUPZRMiJEPNH69otidRCqq9gmKX53UHxYqLg@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] ubsan: Split out bounds checker
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>, 
	Elena Petrova <lenaptr@google.com>, Alexander Potapenko <glider@google.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Dan Carpenter <dan.carpenter@oracle.com>, 
	"Gustavo A. R. Silva" <gustavo@embeddedor.com>, Arnd Bergmann <arnd@arndb.de>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, kasan-dev <kasan-dev@googlegroups.com>, 
	LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, 
	syzkaller <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Nov 21, 2019 at 7:15 PM Kees Cook <keescook@chromium.org> wrote:
>
> v2:
>     - clarify Kconfig help text (aryabinin)
>     - add reviewed-by
>     - aim series at akpm, which seems to be where ubsan goes through?
> v1: https://lore.kernel.org/lkml/20191120010636.27368-1-keescook@chromium.org
>
> This splits out the bounds checker so it can be individually used. This
> is expected to be enabled in Android and hopefully for syzbot. Includes
> LKDTM tests for behavioral corner-cases (beyond just the bounds checker).
>
> -Kees

+syzkaller mailing list

This is great!

I wanted to enable UBSAN on syzbot for a long time. And it's
_probably_ not lots of work. But it was stuck on somebody actually
dedicating some time specifically for it.
Kees, or anybody else interested, could you provide relevant configs
that (1) useful for kernel, (2) we want 100% cleanliness, (3) don't
fire all the time even without fuzzing? Anything else required to
enable UBSAN? I don't see anything. syzbot uses gcc 8.something, which
I assume should be enough (but we can upgrade if necessary).



> Kees Cook (3):
>   ubsan: Add trap instrumentation option
>   ubsan: Split "bounds" checker from other options
>   lkdtm/bugs: Add arithmetic overflow and array bounds checks
>
>  drivers/misc/lkdtm/bugs.c  | 75 ++++++++++++++++++++++++++++++++++++++
>  drivers/misc/lkdtm/core.c  |  3 ++
>  drivers/misc/lkdtm/lkdtm.h |  3 ++
>  lib/Kconfig.ubsan          | 42 +++++++++++++++++++--
>  lib/Makefile               |  2 +
>  scripts/Makefile.ubsan     | 16 ++++++--
>  6 files changed, 134 insertions(+), 7 deletions(-)
>
> --
> 2.17.1
