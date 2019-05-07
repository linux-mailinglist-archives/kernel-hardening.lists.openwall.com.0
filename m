Return-Path: <kernel-hardening-return-15884-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id BA51515B8F
	for <lists+kernel-hardening@lfdr.de>; Tue,  7 May 2019 07:55:51 +0200 (CEST)
Received: (qmail 30098 invoked by uid 550); 7 May 2019 05:55:45 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 30065 invoked from network); 7 May 2019 05:55:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zQM4i+oacF+f0v7Hycn/G+Ro67+VUNL48/C/8L2Zavc=;
        b=V6GrlI67jZYyn9Ppf+RJ+HPiKeJWksTZ9VEwqnKaFdtxDl8TQxa98nAcnBUV0kiVij
         K0YkY2DtD9QEysCGj2i6Lj76fATFM0/prJJHiA5/4k4cPQSQivtef9fZ5Q8IDB7kUguN
         iQbdoerO2UqllSxAsY+9YgzaR2HQtaEqsQ8FJhvC64O7T6OcW+L5hMN8NTIgTJ3pEe1v
         Pvo8DN3IgH8WvBn1QXD994FqvuggJOTsc9Xla/NpxOIsR+F2dHSmWeElmHarIsRTvZi4
         sv74rjY7JjViPTUc2mPXWHn1kd+Omy6k0CnZC0NYtUIR6FnomAvOB/5hNJVHMVr7Ga+5
         K/Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zQM4i+oacF+f0v7Hycn/G+Ro67+VUNL48/C/8L2Zavc=;
        b=iHsPnpNb7jDG1bIDXVMbLME5kSVf33jr/APYNGKGaB8V5k9gBjAWVC3pOVlwsoMhtz
         GpHj2Not533lkb/NxCYE/PjWaeJy0xfPPlD2NU4RkoaMHajZ6fLXsgruDzAje+cy4rt1
         jLa9hM1ZVon/dFSpiQUH8CYzufumliubpwKDdc+P3rQxp0Lyzpp0YdbEzHml1d8TRDMJ
         cFgnq/jS9NoBt1tTb5CRYizMj966Gb7y/8nDlFXm1RWW8Dt6paYiazt7YMauym8/S7iT
         hScpAsdy/OTkM+D8Z+nZv/t31r34Gc582tjo0MkF/YWYf0okmao3DPrcgnL2zoNazN26
         wvJw==
X-Gm-Message-State: APjAAAXqmR1lOJeLy1UCsfrQi0RDUR/2VHiMmxYcle9y5+/zQXUz6VX5
	VeMDz92TOQh9zDxTFK8oMr3dz8t6exi3qvEwmfU=
X-Google-Smtp-Source: APXvYqxYwrFbclWhrrLtGecS5TKxW1CmDmqHK1oZ7JobNgYihGaZuH6HyQWSy5bdWyfVG9iwhYJNxjDHT9CfI/oitF8=
X-Received: by 2002:a9d:7e95:: with SMTP id m21mr2058917otp.256.1557208532674;
 Mon, 06 May 2019 22:55:32 -0700 (PDT)
MIME-Version: 1.0
References: <CAOMdWSLNUEMux1hXfWP+oxZ3YG=uycDmAomGA1iTxjfyOYA0WQ@mail.gmail.com>
 <CAGXu5j+Eo-ewWL2_RtBaVN9msAdA3Pgu8H7uBxVcc=b5DMBy5g@mail.gmail.com>
In-Reply-To: <CAGXu5j+Eo-ewWL2_RtBaVN9msAdA3Pgu8H7uBxVcc=b5DMBy5g@mail.gmail.com>
From: Allen <allen.lkml@gmail.com>
Date: Tue, 7 May 2019 11:25:21 +0530
Message-ID: <CAOMdWSJPHks4GkzDFk1_M5HLZUoT9G_P=MiEAwGSp2zJ6-NM=A@mail.gmail.com>
Subject: Re: [RFC] refactor tasklets to avoid unsigned long argument
To: Kees Cook <keescook@chromium.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, tglx@linuxtronix.de
Content-Type: text/plain; charset="UTF-8"

> >   My only concern with the implementation is, in the kernel the combination
> > of tasklet_init/DECLARE_TAKSLET is seen in over ~400 plus files.
> > With the change(dropping unsigned long argument) there will be huge list
> > of patches migrating to the new api.
>
> Yeah, this is the main part of the work for making this change. When
> the timer API got changed, I had to do a two-stage change so we could
> convert the users incrementally, and then finalize the API change to
> drop the old style.
>
> Beyond that, yeah, everything you sent looks good. It's just the
> matter of building a series of patches to do it without breaking the
> world. (Though if it's small enough, maybe it could be a single patch?
> But I doubt that would be doable...)

 Thank you.

 I like the idea of two-stage approach. For first stage, I was thinking of all
the architectures with their default configs(Nothing gets broken when
defconf's are tried) and for second stage the rest of drivers etc..

Thoughts?

Either ways, I will convert and get them pushed to github, we could see how
best it could be taken to upstream once it's done.

       - Allen
