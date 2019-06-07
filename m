Return-Path: <kernel-hardening-return-16071-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id BEAA0393B0
	for <lists+kernel-hardening@lfdr.de>; Fri,  7 Jun 2019 19:55:25 +0200 (CEST)
Received: (qmail 32346 invoked by uid 550); 7 Jun 2019 17:55:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 32287 invoked from network); 7 Jun 2019 17:55:12 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=CK08vskQ1JYOqQ1BfGuLl6pOWQXw81CutA1AILeMhx0=;
        b=T4boDwsi9y4p95gm1dpJdzXvOJ6x/zJVdS5uI2eNYe8Ce/nE0eA/la6hpZkGhV0LSX
         pWRaD5j8rXqWv819h6GmUWOITb2U2Edu/Jxu8ibxtPcJsLYpVvC06iZ6B+9+k850Dsl8
         xZ2w5qwzTZk0Tv5eMHG62crDp1YiT//j8MNpmECZpARbEJlxsWgxm+xO05nNQrcr+VzU
         Z8pqbFF6JVyKdMCZSD5VNVnM8+FLVBNDiJumKCZDtbCggjpOkayWR6Fj8hmbxUBRFcD7
         Wjj/Kulru1brLHzqdaWZV3MaV4u53RgVxT5B/7djXW3eluNhLdPHg56iqLD2pQR0kTGF
         IbtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=CK08vskQ1JYOqQ1BfGuLl6pOWQXw81CutA1AILeMhx0=;
        b=ZXENz0PM6fR9shG6mPsku3wMmXhyoNGZVDnN29iQ194XpgRUhOOEJyXN/XvNn7WmHc
         jQWYINDLBiz9gxU7L9r0R7msNOB6h5rq1dOVBW6jY5gsFhZpp5l+JvLA1Uk4sR7MF0Hd
         wcLhfaarAUNmn/tS/c11/RL/+JgnIwSWOe0hk9JsqGOKB5vG2FEzkCDYOJsOKKNin3Vs
         KCaEVntSGlp2w7R/WteoyVjcbFHVPQeUvnD3nAMmBZVlm1YHu66U18uR4sOhsTVI6geV
         0QMPE1+Df9hRpzrzOsgcTWnBzjfKAmwDxSy4GKqeEFFR5DPY1JpptHAvBcesAPvH5FW+
         MV3Q==
X-Gm-Message-State: APjAAAVyEy3uWsI6ULs1eIlET3yTZ4gWM7VrwLbew50wcoi0/oInHOeJ
	Yo2A73UUnYaVKEvgAi0kCHur/5DHcQNuw9iQ71ReWV8b
X-Google-Smtp-Source: APXvYqzYVC1JuofJonjaoQq5STJcFKZLXfSI/euXuhuaNzN/6TkYIP2KCG70JMojjtfXlsnu7H2CqrXKaHHlLFUA0Ys=
X-Received: by 2002:a17:90a:2190:: with SMTP id q16mr6863430pjc.23.1559930100164;
 Fri, 07 Jun 2019 10:55:00 -0700 (PDT)
MIME-Version: 1.0
References: <CABgxDo+x3r=8HFxyM89HAc_FdY6+kBpJR5RpAgpOYsu0xZtshQ@mail.gmail.com>
In-Reply-To: <CABgxDo+x3r=8HFxyM89HAc_FdY6+kBpJR5RpAgpOYsu0xZtshQ@mail.gmail.com>
From: Romain Perier <romain.perier@gmail.com>
Date: Fri, 7 Jun 2019 19:54:48 +0200
Message-ID: <CABgxDoJ-ue6HKyBR_q8cmbOp8DFnZDVf7zbxv8_wmHh7uis_vw@mail.gmail.com>
Subject: Re: Get involved
To: kernel-hardening@lists.openwall.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

I will probably take the task "WARN on kfree() of ERR_PTR range" , and
then help to port to refcount_t   (I plan to use linux-next).
I have asked for an account to jmorris, so I can mark the task as "WIP".

Regards,
Romain

Le mar. 4 juin 2019 =C3=A0 19:08, Romain Perier <romain.perier@gmail.com> a=
 =C3=A9crit :
>
> Hi,
>
> I have discussed briefly with Kees on IRC, who has suggested to me to
> say hello here :) .
> As part of the debian kernel team (still a padawan), I would like to
> be more involved on upstream on security related topics.
>
> Kees confirmed that the todolist at
> http://kernsec.org/wiki/index.php/Kernel_Self_Protection_Project/Work
> is up-to-date.
>
> Which task would you recommend (I was mostly involved on SoC related
> tasks on upstream in the mainline kernel) ?
>
> I am on ##linux-hardened on IRC (nick: rperier)
>
> Thanks,
> Regards,
> Romain
