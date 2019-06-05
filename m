Return-Path: <kernel-hardening-return-16060-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id E1236356E5
	for <lists+kernel-hardening@lfdr.de>; Wed,  5 Jun 2019 08:21:15 +0200 (CEST)
Received: (qmail 11669 invoked by uid 550); 5 Jun 2019 06:21:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 11634 invoked from network); 5 Jun 2019 06:21:08 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AtqHgH8AzfqBusRXColLPq524pdyprOlKwBMhdGimOs=;
        b=fd/jFlYC3NKCnlc10GNS/xXh9Mu8jhirQNjNqRwQ/3oWrENyNxUUvb7jukL+cJ8nOr
         0PeUOMwn3wjpv/MP5l8IeFEc0KjgSwJV3wmT9pj+2q3d2pK7p9SB/8qyp96wR2qKgU4Q
         lHisNH/bC4oxyGBh7finpaMpQbGtUd6Pj1Ta8jwitm8bDl/sz7aKwT8U1p4pVBLDuIy6
         GtLWeIUC6V+BH2bVSMY2thRJoBHSUgRdwNFSTaoagBpYEVDTR/BNQTG2E4hodA0SCwrA
         xYQJuqb7vjP3YuWW8Xz7JUeWts1b5tamD2b2r8o+XYdXTBEnmgL6TFu04xyJuea0hTPt
         i/vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AtqHgH8AzfqBusRXColLPq524pdyprOlKwBMhdGimOs=;
        b=Lddf89J8rb9D/xEw118a8tHSwx00Jp0912WLxw9CQ+UT9qSQvQM69Yst7pnKc1CCeW
         ksnUInN0nYoK35WF5KWdydLNt2ZkYvh1akJEZThuGPU4BWDWFHi0P1OBWG42V6hQ5oza
         3D2hned3RnsaMhQmTLyXl70gtphxcK+K0ZVd3SQQRKTHaVbVYNgAhVUFsWyk8xfOvxxb
         grQMWs5g3ShKVcPjBlDKWeZrr9r/6mLlt2aXYNYYHVxCltVOF7PtXTZENB1heDU09gK9
         rQhIHzOOLWRzwoHUzeY/zEnzQnJnK2/Clo3RT/HMO3Ya39vtrIDj4LdpFW6o2ciou6/x
         19yQ==
X-Gm-Message-State: APjAAAX3ZqDEaCDu2W5PK7cYCTg7lk4wqdmFSfVc9kqdyPCbm6Ymwn2p
	q7R8jp7zNQclQ6S1LLL35sskFSoKanwFoFDg6tTZdA==
X-Google-Smtp-Source: APXvYqzlkR0mSGTo4qj6zCzfKyaEQVD5KunaL/j2L2/jGoUBjIoSTeh8jGEtvNNxjrzNn8XcY+RumpVbcR/wbdYMgp0=
X-Received: by 2002:a24:6b86:: with SMTP id v128mr18073861itc.104.1559715656168;
 Tue, 04 Jun 2019 23:20:56 -0700 (PDT)
MIME-Version: 1.0
References: <201906042224.42A2CCB2BE@keescook>
In-Reply-To: <201906042224.42A2CCB2BE@keescook>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Wed, 5 Jun 2019 08:20:44 +0200
Message-ID: <CAKv+Gu8m=6BgqfjrvrGEjX1Z3=W-YJhv-jrDXhC5+EoRuOG3qA@mail.gmail.com>
Subject: Re: [PATCH] lib/test_stackinit: Handle Clang auto-initialization pattern
To: Kees Cook <keescook@chromium.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Alexander Potapenko <glider@google.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 5 Jun 2019 at 07:25, Kees Cook <keescook@chromium.org> wrote:
>
> While the gcc plugin for automatic stack variable initialization (i.e.
> CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL) performs initialization with
> 0x00 bytes, the Clang automatic stack variable initialization (i.e.
> CONFIG_INIT_STACK_ALL) uses various type-specific patterns that are
> typically 0xAA. Therefore the stackinit selftest has been fixed to check
> that bytes are no longer the test fill pattern of 0xFF (instead of looking
> for bytes that have become 0x00). This retains the test coverage for the
> 0x00 pattern of the gcc plugin while adding coverage for the mostly 0xAA
> pattern of Clang.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  lib/test_stackinit.c | 21 +++++++++++++++------
>  1 file changed, 15 insertions(+), 6 deletions(-)
>
> diff --git a/lib/test_stackinit.c b/lib/test_stackinit.c
> index e97dc54b4fdf..2d7d257a430e 100644
> --- a/lib/test_stackinit.c
> +++ b/lib/test_stackinit.c
> @@ -12,7 +12,7 @@
>
>  /* Exfiltration buffer. */
>  #define MAX_VAR_SIZE   128
> -static char check_buf[MAX_VAR_SIZE];
> +static u8 check_buf[MAX_VAR_SIZE];
>
>  /* Character array to trigger stack protector in all functions. */
>  #define VAR_BUFFER      32
> @@ -106,9 +106,18 @@ static noinline __init int test_ ## name (void)                    \
>                                                                 \
>         /* Fill clone type with zero for per-field init. */     \
>         memset(&zero, 0x00, sizeof(zero));                      \
> +       /* Clear entire check buffer for 0xFF overlap test. */  \
> +       memset(check_buf, 0x00, sizeof(check_buf));             \
>         /* Fill stack with 0xFF. */                             \
>         ignored = leaf_ ##name((unsigned long)&ignored, 1,      \
>                                 FETCH_ARG_ ## which(zero));     \
> +       /* Verify all bytes overwritten with 0xFF. */           \
> +       for (sum = 0, i = 0; i < target_size; i++)              \
> +               sum += (check_buf[i] != 0xFF);                  \
> +       if (sum) {                                              \
> +               pr_err(#name ": leaf fill was not 0xFF!?\n");   \
> +               return 1;                                       \
> +       }                                                       \
>         /* Clear entire check buffer for later bit tests. */    \
>         memset(check_buf, 0x00, sizeof(check_buf));             \
>         /* Extract stack-defined variable contents. */          \
> @@ -126,9 +135,9 @@ static noinline __init int test_ ## name (void)                     \
>                 return 1;                                       \
>         }                                                       \
>                                                                 \
> -       /* Look for any set bits in the check region. */        \
> -       for (i = 0; i < sizeof(check_buf); i++)                 \
> -               sum += (check_buf[i] != 0);                     \
> +       /* Look for any bytes still 0xFF in check region. */    \
> +       for (sum = 0, i = 0; i < target_size; i++)              \
> +               sum += (check_buf[i] == 0xFF);                  \
>                                                                 \
>         if (sum == 0)                                           \
>                 pr_info(#name " ok\n");                         \
> @@ -162,13 +171,13 @@ static noinline __init int leaf_ ## name(unsigned long sp,        \
>          * Keep this buffer around to make sure we've got a     \
>          * stack frame of SOME kind...                          \
>          */                                                     \
> -       memset(buf, (char)(sp && 0xff), sizeof(buf));           \
> +       memset(buf, (char)(sp & 0xff), sizeof(buf));            \
>         /* Fill variable with 0xFF. */                          \
>         if (fill) {                                             \
>                 fill_start = &var;                              \
>                 fill_size = sizeof(var);                        \
>                 memset(fill_start,                              \
> -                      (char)((sp && 0xff) | forced_mask),      \
> +                      (char)((sp & 0xff) | forced_mask),       \
>                        fill_size);                              \
>         }                                                       \
>                                                                 \
> --
> 2.17.1
>
>
> --
> Kees Cook
