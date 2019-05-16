Return-Path: <kernel-hardening-return-15928-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id B51E020186
	for <lists+kernel-hardening@lfdr.de>; Thu, 16 May 2019 10:47:40 +0200 (CEST)
Received: (qmail 16338 invoked by uid 550); 16 May 2019 08:47:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 16307 invoked from network); 16 May 2019 08:47:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=T67sSBYpxyMnMx5QAXMMq1F3JuIWuxSCHLtvQoMOPC8=;
        b=hQ5iBqKw8w+CnbtvBQNCHowRf/7eqLIDLeSjRYUgZYVdCs2VYDfzQO0NredRP/+iaH
         bmxXDx1ZZpxja1lFZ+aCKXXm97qhsynO6b9QLoSYyzVNHePnrXaM+euM7iqPRN3JnCu6
         +JdUXHk6GQZAPqdrg/c/n9AF+WPWl6PK31LhJRhOwJY12J9yL7XXpwwmy8URwaATKMCS
         ChSHszr09O/y8aJKwsccl4yQzWSDbhdXXRz8JNu+9Qjhup6JWnAGVmGo0J8dOJqjHO66
         9pR+YuKZTZzI9tGG8jg45Fe2qhDVXzO9RoLbfNKCLB20kt8xuNKVsI1johJCKqKZj/2G
         YqIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=T67sSBYpxyMnMx5QAXMMq1F3JuIWuxSCHLtvQoMOPC8=;
        b=RXyM9YP1GL9TsqvgeH4oG3Nyvtv+n6vVIsG9Zkypn/6AAxvO933Pci6HBxG8rqzs7M
         KhNUSS+cp4WO6OjiipIYVRnp5btmp8rnWnl/QOlXH40W677yG2oryQrIRucJmO7lvlEG
         42wVWCBczaSYm5ds3Wo2Ytvad2aDySBC+eobW0IO5H2RUPWDoi7jsCTpCIHICgIrorkZ
         g2E1z7SR4o0OxmRkNRyEppB9xCqPXKxUboVpfVYiDVAerajLJSnsqxNHtNUcGBq0T+fG
         O1uhBxluyLKm6bCIzz6VJa197QWy8ia9/XSCwJluoZPx9BfhAEoS9uhDidk94fkwH8N8
         s5YQ==
X-Gm-Message-State: APjAAAX3/UehhV3kA8zh+KgD4fzfk5sRDqerAetMqZQCi8W49aYc5d6r
	IVcP0rPIq20RIf4Foe7yo0uuo8puZ+rfvG5K/KKvZA==
X-Google-Smtp-Source: APXvYqzRWW5Vw8J/39xYKpC2Df9BAh9uNAvhSdajD9qOYt+HUvst57L/1O1ngpkWEYP6UmG2ye5WhE1hcP1xsks5uNY=
X-Received: by 2002:a5d:93da:: with SMTP id j26mr26609941ioo.170.1557996441199;
 Thu, 16 May 2019 01:47:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190510090025.4680-1-chris.packham@alliedtelesis.co.nz> <CAD=FV=UN8rm_40eVz4YVVJ57d_BWkzxs1E4nYhX_mKWe2pwX0Q@mail.gmail.com>
In-Reply-To: <CAD=FV=UN8rm_40eVz4YVVJ57d_BWkzxs1E4nYhX_mKWe2pwX0Q@mail.gmail.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Thu, 16 May 2019 10:47:08 +0200
Message-ID: <CAKv+Gu98jQA7XARghVNXq8qEBm4DG77q3K0j-zw-WX_w-4_Q-Q@mail.gmail.com>
Subject: Re: [PATCH] gcc-plugins: arm_ssp_per_task_plugin: Fix for older GCC < 6
To: Doug Anderson <dianders@chromium.org>
Cc: Chris Packham <chris.packham@alliedtelesis.co.nz>, Kees Cook <keescook@chromium.org>, 
	Emese Revfy <re.emese@gmail.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 11 May 2019 at 00:42, Doug Anderson <dianders@chromium.org> wrote:
>
> Hi,
>
> > Use gen_rtx_set instead of gen_rtx_SET. The former is a wrapper macro
> > that handles the difference between GCC versions implementing
> > the latter.
> >
> > This fixes the following error on my system with g++ 5.4.0 as the host
> > compiler
> >
> >    HOSTCXX -fPIC scripts/gcc-plugins/arm_ssp_per_task_plugin.o
> >  scripts/gcc-plugins/arm_ssp_per_task_plugin.c:42:14: error: macro "gen=
_rtx_SET" requires 3 arguments, but only 2 given
> >           mask)),
> >                ^
> >  scripts/gcc-plugins/arm_ssp_per_task_plugin.c: In function =E2=80=98un=
signed int arm_pertask_ssp_rtl_execute()=E2=80=99:
> >  scripts/gcc-plugins/arm_ssp_per_task_plugin.c:39:20: error: =E2=80=98g=
en_rtx_SET=E2=80=99 was not declared in this scope
> >     emit_insn_before(gen_rtx_SET
> >
> > Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
> > ---
> >  scripts/gcc-plugins/arm_ssp_per_task_plugin.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
>
> I can confirm that I was getting compile errors before this patch and
> applying it allowed me to compile and boot.  Thanks!  :-)
>
> Tested-by: Douglas Anderson <dianders@chromium.org>
>

Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
