Return-Path: <kernel-hardening-return-16284-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 94872581D4
	for <lists+kernel-hardening@lfdr.de>; Thu, 27 Jun 2019 13:46:59 +0200 (CEST)
Received: (qmail 16052 invoked by uid 550); 27 Jun 2019 11:46:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 16018 invoked from network); 27 Jun 2019 11:46:52 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=W3k485e+gL3mkPzTEUqBAPrpOpaR71xEYkK4V/9dbyA=;
        b=ZE0XqJhnG9wYWp2M5vVNQ0kBo8qWIRhAPLW2MU80HiljJs1u/M/iji8yRtUkCs1SWB
         g0zxS2cLV44JUe8Y16JngocemcdbFGKNCztp+J0XLTXrIQhv6UzBDiG+QXsrvTYaK64p
         wvi/JE4KXdRP47ZKr1ZzLJ9LycWF59SaxJFICabWUgHeIx5sPVDNpIOA53IEchM6gxSs
         tXrnc/SznwlJmeM54o96JSNgQyALgd6ECg1VYQaLhiA/+TTf6QFDLxYKp566/5jQDiaE
         Dt/jzh6QI5VU0hXlEivOeYtJ2GnMtpTj0RwpnRmoZ/W4+X3I15TDQbXetti8Zcj5vSmg
         0B7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=W3k485e+gL3mkPzTEUqBAPrpOpaR71xEYkK4V/9dbyA=;
        b=mHkJBJEEvDfesd//BPY7jsF69xNIpvY9zgfItu0EywJ6P+rCh/2IW28wJxVi8JYUc3
         Fte46dgrewasvRVnGoLI+obxqWIOV48NwiCJu9pPUztrl5Nz+vxI/z6lKlBowu/CQ8NA
         SM3j3/btF6LG51oNF0LEIPyzYeos83K26foRn/+GTNVGXxi5/yVfIKJoSQClrBiRJ03H
         cRKgYTvZ1S1+xts90VLS3gwT6f4HqUDksitpcrs3KJCnxPPIc1UvX0OMQsUkjkoqo9zN
         0JUjdBD5ycSJrAbF49EzpK6/JmVQbVgiFJokzJ/D8AQPWZPV+hkjU2aXYl5YhNlkJx5c
         872g==
X-Gm-Message-State: APjAAAVoh9bITNYx+w12aAPbSCUTFYTp5hklnbM43nasEEtKv9UvQbkY
	KJaWd4dGzY1vXX4F1fb66uXm9wuEbRHfzMqXlzE=
X-Google-Smtp-Source: APXvYqynsnhGnVzgz8AoV+HHK0yNymSqH6kzFYLD2ZnnB/rlm86yLZyZT350MHrivQGqOYGyO5AppV53zutEcFn7sRE=
X-Received: by 2002:a6b:e615:: with SMTP id g21mr498255ioh.178.1561636000822;
 Thu, 27 Jun 2019 04:46:40 -0700 (PDT)
MIME-Version: 1.0
References: <12356C813DFF6F479B608F81178A561586BDFE@BGSMSX101.gar.corp.intel.com>
In-Reply-To: <12356C813DFF6F479B608F81178A561586BDFE@BGSMSX101.gar.corp.intel.com>
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Thu, 27 Jun 2019 13:45:06 +0200
Message-ID: <CAOMGZ=FfWUf=2wMKXJVOsfr5b394ERUbhQehEFOtMx8zh26M4w@mail.gmail.com>
Subject: Re: Regarding have kfree() (and related) set the pointer to NULL too
To: "Gote, Nitin R" <nitin.r.gote@intel.com>
Cc: Kees Cook <keescook@chromium.org>, 
	"kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 27 Jun 2019 at 12:23, Gote, Nitin R <nitin.r.gote@intel.com> wrote:
> Hi,
>
> I=E2=80=99m looking  into =E2=80=9Chave kfree() (and related) set the poi=
nter to NULL too=E2=80=9D task.
>
> As per my understanding, I did below changes :
>
> Could you please provide some points on below ways ?
> @@ -3754,6 +3754,7 @@ void kfree(const void *objp)
>         debug_check_no_obj_freed(objp, c->object_size);
>         __cache_free(c, (void *)objp, _RET_IP_);
>         local_irq_restore(flags);
> +       objp =3D NULL;
>
> }

This will not do anything, since the assignment happens to the local
variable inside kfree() rather than to the original expression that
was passed to it as an argument.

Consider that the code in the caller looks like this:

void *x =3D kmalloc(...);
kfree(x);
pr_info("x =3D %p\n", x);

this will still print "x =3D (some non-NULL address)" because the
variable 'x' in the caller still retains its original value.

You could try wrapping kfree() in a C macro, something like

#define kfree(x) real_kfree(x); (x) =3D NULL;

but using proper C macro best practices (like putting do {} while (0)
around it, etc.).

It's probably easier to play with this in a simple userspace program first.


Vegard
