Return-Path: <kernel-hardening-return-16054-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 099D934E78
	for <lists+kernel-hardening@lfdr.de>; Tue,  4 Jun 2019 19:11:34 +0200 (CEST)
Received: (qmail 3380 invoked by uid 550); 4 Jun 2019 17:11:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 1620 invoked from network); 4 Jun 2019 17:09:19 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=epnJHpJ7z1Rar7AQ9HhREK/chc7UF7D4zGQXvzIqiWk=;
        b=Jzgtu9ClndG2bHHg2bpmAcmFy0UJf9YZD/R9fwTWOaNsx70H7+Iuok1MxsEMxPRcd0
         PWO9NGzUK5iv8yIovLwtPGnO+4d8bJyDw15QBbwSvZEPcOHUq4tLxq/XC9JkhkAlBncK
         kH2/GEsyq9CPsIyCTNH/VAesj99P1tlSBhBQ5G6iHv+o0C2s9KPVj4kFNYlRAnAapQq2
         QAhOQGNnhatUY1rAP66yxcdZ2dO+xpJeByEUxnXyX7Fw/NqEbMc6nfE5aOtR5zZSg3TW
         THDy2iHuv7O4RHJyD4uJ6I6a7p1wmOQvZ9BNqV8oC1RbMkD8IQG8wmyMyhqGsJvaGqJU
         w0ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=epnJHpJ7z1Rar7AQ9HhREK/chc7UF7D4zGQXvzIqiWk=;
        b=jp6sjSscQW6jEuNetfM5flu6JIU1++J4WI62zKl1rxOeOjvmENr0x/ZkQ+BhFR+skI
         V9SVCHh+JVtX2YA6xHMtEPNgxEKpR351Qbe6QFP/upgGiTO9RhABM2W5/ythG/Df45yJ
         hRRFfRdz7FChFAU1FC3dJDSqhg5vw752KLjd0q/9OaFNs2A9GifY/cFWPXj9mDzAo/z5
         WOqhDVHPh6ZNhMpN4nNFpnIYnHZOt9Oz3vO9f1Eo37fwgA6BLGrS/bjyOzyvzmjjiz10
         yPud4HdG8QpEV9duLyum0IkuyTVuqmUJWxUms0cnfGqZ8o3ulqotOdAvYCNzDOJwZADV
         Cbiw==
X-Gm-Message-State: APjAAAX5OZnI549aZjixHBOuSnuuEA1so6jBlJKVrgtRJuxBU14BD89t
	cmTaKkvFbBbJEZNYPn68Tzv3wpYfjeraT8v7g9YA/VCJ
X-Google-Smtp-Source: APXvYqxFxAz7f8JnwF35tezVShO6VyWcHCY1JjPQCDr3zB8V98veOuZDINOtLwzvYo9IUgRQPpaRgbNcgePzzwOafbM=
X-Received: by 2002:a63:6c87:: with SMTP id h129mr37527276pgc.427.1559668147553;
 Tue, 04 Jun 2019 10:09:07 -0700 (PDT)
MIME-Version: 1.0
From: Romain Perier <romain.perier@gmail.com>
Date: Tue, 4 Jun 2019 19:08:56 +0200
Message-ID: <CABgxDo+x3r=8HFxyM89HAc_FdY6+kBpJR5RpAgpOYsu0xZtshQ@mail.gmail.com>
Subject: Get involved
To: kernel-hardening@lists.openwall.com
Content-Type: text/plain; charset="UTF-8"

Hi,

I have discussed briefly with Kees on IRC, who has suggested to me to
say hello here :) .
As part of the debian kernel team (still a padawan), I would like to
be more involved on upstream on security related topics.

Kees confirmed that the todolist at
http://kernsec.org/wiki/index.php/Kernel_Self_Protection_Project/Work
is up-to-date.

Which task would you recommend (I was mostly involved on SoC related
tasks on upstream in the mainline kernel) ?

I am on ##linux-hardened on IRC (nick: rperier)

Thanks,
Regards,
Romain
