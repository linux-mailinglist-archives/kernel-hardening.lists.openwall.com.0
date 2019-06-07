Return-Path: <kernel-hardening-return-16073-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 4003C39418
	for <lists+kernel-hardening@lfdr.de>; Fri,  7 Jun 2019 20:17:12 +0200 (CEST)
Received: (qmail 6072 invoked by uid 550); 7 Jun 2019 18:17:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 6037 invoked from network); 7 Jun 2019 18:17:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=cz7wB840rhvGfTaJuW2ip1j1KZYOFHK49UBpev/BcHM=;
        b=ikZc/8nFpixEX2ZbuEMnqcygaNyQXVa6Gh8BgbmKC9Ze8D6XBeOARiiZthZmdJ9AfN
         2p/2koZwg6qB4kc0py56OzD1MFBqgeiCgfulsYSyv1Mhzk6cXQNsgiM105aJQlCy2pIs
         YakY3HpPrG63ZFVr1tzV6V3hCahHfzGR0f6QmSQpPH18cU1RnqOpXIVWpVXr8Xr4nBVC
         YmBUcxr5O41F2wUYj+A2XIIMQeV1QgFtDTXxWELOy1jrrP+9+6QeieRf9yRHY7Mz2HLX
         eA879aObAKveYRCka5ESHBUb6bmgHCwXJMyALI9S3mwMeX4884L6HOL5nxCJHMfHfA3j
         PpRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cz7wB840rhvGfTaJuW2ip1j1KZYOFHK49UBpev/BcHM=;
        b=j4VcW5F8aAsnuhlw8JhIryXc+tyUhcztncb2Uwq3JM+Gh9njd1Au+m9oRRlAFPeqRm
         2M1BSiHDlRxMQjDuRCbqrQo/P6BPW0h/xlyB/CAL4BKdpeV3iSekwFMsgkjdi88hxML2
         tu2Vovu9gi+dSINInbUZzgzX+F08GpypC7BsrlXc6y1WkiNmqKl4rNav1Hkafqqc7qll
         X2cQ8wzAGahil1jm03OYKgHVor/3d7c7+tRzumk7eFf6exFHlCgqgQ/L5i8a3JwNApdT
         HNmRRnPW8iGanrBsC6xK70mJRiUhBAsBJ4un4CkB0Az4JgxpUzOKo5I2VhiSV6pyj7as
         +u9A==
X-Gm-Message-State: APjAAAWDvPaquDuEcZIeIp1Cyn2gnApyyCrhd8jkXkRQaemweDRu2Nno
	RX8HQzAGT4LrQVzGkb/f0Au4x/Ug8OMjPQk7GbqPbg==
X-Google-Smtp-Source: APXvYqzmtMW+GsiveHeIMJQTCFzGWYSCgxsAa92pkxR0AeVuvMELFXuazhBaklmu4ti1y1xkb3X4wyUcMoy0yfWoFuY=
X-Received: by 2002:a65:4349:: with SMTP id k9mr4155348pgq.243.1559931414403;
 Fri, 07 Jun 2019 11:16:54 -0700 (PDT)
MIME-Version: 1.0
References: <CABgxDo+x3r=8HFxyM89HAc_FdY6+kBpJR5RpAgpOYsu0xZtshQ@mail.gmail.com>
 <CABgxDoJ-ue6HKyBR_q8cmbOp8DFnZDVf7zbxv8_wmHh7uis_vw@mail.gmail.com> <CAOfkYf4OxG-vkCOoWvmGxyRg3UVFcGszkdStKSoXf5qqyF_RQA@mail.gmail.com>
In-Reply-To: <CAOfkYf4OxG-vkCOoWvmGxyRg3UVFcGszkdStKSoXf5qqyF_RQA@mail.gmail.com>
From: Romain Perier <romain.perier@gmail.com>
Date: Fri, 7 Jun 2019 20:16:42 +0200
Message-ID: <CABgxDoLe3fXNLob3pnj7Nn2v54Htqr+cg5gRRQPxFK7HPX85=Q@mail.gmail.com>
Subject: Re: Get involved
To: Shyam Saini <mayhs11saini@gmail.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Okay, np. I will select another one then :) (hehe that's the game ;) )

@Kees: do you have something in mind (as a new task) ?

Thanks,
Regards,
Romain


Le ven. 7 juin 2019 =C3=A0 20:04, Shyam Saini <mayhs11saini@gmail.com> a =
=C3=A9crit :
>
> Hi Roman,
>
> > I will probably take the task "WARN on kfree() of ERR_PTR range" , and
> > then help to port to refcount_t   (I plan to use linux-next).
> > I have asked for an account to jmorris, so I can mark the task as "WIP"=
.
>
>
> I'm already on that task, would you mind to proceed with some other task.
> Kees suggested me this task sometime ago.
> I'll be sending patches this weekend.
>
> Thanks a lot,
> Shyam
