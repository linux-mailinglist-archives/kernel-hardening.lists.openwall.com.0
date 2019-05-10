Return-Path: <kernel-hardening-return-15918-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 5B4AC1A56B
	for <lists+kernel-hardening@lfdr.de>; Sat, 11 May 2019 00:42:31 +0200 (CEST)
Received: (qmail 21658 invoked by uid 550); 10 May 2019 22:42:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 7419 invoked from network); 10 May 2019 22:24:18 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Dqrg0jqqwTFVZg+HwDR33ruHqkuBxkLtC7FtOcFOyp0=;
        b=d4BTeaUXVFNJJJeqPBsPt3i9JuHD4wKo14zSuYu5RNeYAMlhYDP4ThmnBW/Syuzjk4
         tajrK+f0a31CsFguryP+Jd1WecjSMXsIgac9e3dlFJ+3s7fSTKuiU64+LFTBHi5WjbAp
         OsMXPOon6AW7MtTubCZviZAQ2bNzg1Nvn+hb8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Dqrg0jqqwTFVZg+HwDR33ruHqkuBxkLtC7FtOcFOyp0=;
        b=S0dLyHjiPKpvH/UUg8bqBuy/sV+fB/3rJd/ST70JkvKOWBbTuioxzVdc0v2B7kF9Kg
         xYK9oOfYNxwRy8LRxySq4q3Ubp8wSi1oi5wQfr4tMiHvnMoqCce3sUzREaHu9R4LS5A0
         JlaSkDAOROUuAlJRkym55mZDQ88Np/VqgIl1gwVyqLKzaZ4EUfYgmVN9mEAGBz+UrjaU
         HWzHQAmLawBmTbBnYeKlgDOtmGErBkVxM01gdncgZCJ3kCJS9dR72phPTR3xzKxuP8xD
         RtnYti8SXGWdO6fxVdB8uEysEdeRCq6pQCSlBal9VXYWFZddq9SEzusFYSOA6glXUW/w
         WCew==
X-Gm-Message-State: APjAAAWE8oXU+sDO9Ajb64UiF6Tt6m+XsmNsn6hnm6OiMtpyrjmwt7BT
	uCu+ZnhNJLIJ1JMTjCmjIvjWiM4a8VM=
X-Google-Smtp-Source: APXvYqwj15fCyd52ODEpEybncGp0vE3SAkfixTNirhlx0ZqJjgPck+BDQh3eQhi7KKEdZ2w6RBFXTQ==
X-Received: by 2002:ab0:2a87:: with SMTP id h7mr7013864uar.26.1557527045582;
        Fri, 10 May 2019 15:24:05 -0700 (PDT)
X-Received: by 2002:ab0:4a97:: with SMTP id s23mr3829867uae.19.1557527037549;
 Fri, 10 May 2019 15:23:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190510090025.4680-1-chris.packham@alliedtelesis.co.nz>
In-Reply-To: <20190510090025.4680-1-chris.packham@alliedtelesis.co.nz>
From: Doug Anderson <dianders@chromium.org>
Date: Fri, 10 May 2019 15:23:46 -0700
X-Gmail-Original-Message-ID: <CAD=FV=UN8rm_40eVz4YVVJ57d_BWkzxs1E4nYhX_mKWe2pwX0Q@mail.gmail.com>
Message-ID: <CAD=FV=UN8rm_40eVz4YVVJ57d_BWkzxs1E4nYhX_mKWe2pwX0Q@mail.gmail.com>
Subject: Re: [PATCH] gcc-plugins: arm_ssp_per_task_plugin: Fix for older GCC < 6
To: Chris Packham <chris.packham@alliedtelesis.co.nz>
Cc: Kees Cook <keescook@chromium.org>, re.emese@gmail.com, 
	kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

> Use gen_rtx_set instead of gen_rtx_SET. The former is a wrapper macro
> that handles the difference between GCC versions implementing
> the latter.
>
> This fixes the following error on my system with g++ 5.4.0 as the host
> compiler
>
>    HOSTCXX -fPIC scripts/gcc-plugins/arm_ssp_per_task_plugin.o
>  scripts/gcc-plugins/arm_ssp_per_task_plugin.c:42:14: error: macro "gen_r=
tx_SET" requires 3 arguments, but only 2 given
>           mask)),
>                ^
>  scripts/gcc-plugins/arm_ssp_per_task_plugin.c: In function =E2=80=98unsi=
gned int arm_pertask_ssp_rtl_execute()=E2=80=99:
>  scripts/gcc-plugins/arm_ssp_per_task_plugin.c:39:20: error: =E2=80=98gen=
_rtx_SET=E2=80=99 was not declared in this scope
>     emit_insn_before(gen_rtx_SET
>
> Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
> ---
>  scripts/gcc-plugins/arm_ssp_per_task_plugin.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

I can confirm that I was getting compile errors before this patch and
applying it allowed me to compile and boot.  Thanks!  :-)

Tested-by: Douglas Anderson <dianders@chromium.org>

-Doug
