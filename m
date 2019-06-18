Return-Path: <kernel-hardening-return-16185-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 2C0F84A8E6
	for <lists+kernel-hardening@lfdr.de>; Tue, 18 Jun 2019 19:57:14 +0200 (CEST)
Received: (qmail 21780 invoked by uid 550); 18 Jun 2019 17:57:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 21718 invoked from network); 18 Jun 2019 17:57:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=VtT8APV2KyinKjXmdmjBlC/NJpJFopiRizthJmfOxug=;
        b=s02oRLTgRkZWjCGMR8Bxr8SbBn0Ybt0drWf/ogydfGbX2iPZ4OMqZfyw0d3ic8QixW
         mmAIsXG3QZFfEkHxLI67DX1vZ3YFOJY+YoM30II1/xuArWE9cNbaAwf/HRn6AIntkMqz
         xpPLKmy3iYkdNT2G43CCqN9rPzck1tNyDa3MX6FefHcaUIEsv/IQxQgVObOXwDl1ybi7
         +PCfMVCTD1FrzcmAX4DAGA2ogrOsdX56B8YWB8112W0ruDocGJs6Z0OD1B8G3ZPkaue+
         zbHudGKu2lJMzOeptNZ2oG2kz5pjZ2QOyWMlOlu3eWv99JDEiVM28sdAGsjiMhxwnYMK
         EvZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=VtT8APV2KyinKjXmdmjBlC/NJpJFopiRizthJmfOxug=;
        b=QDqqRBw2Wz1e1VthwXT7SQAk1iqkX18fyCE4thb9kHBrJRWC8E355pefjqnrW4R+x6
         HDVDwsrvt7D7XxRJc+gNV1nSOXda2aLzNDfkPqGZd3sG/2zspgHyncZGvXJaJwkTm+br
         qbQQoa79/k+QllOKMUr+3OkdCFB9VRlQjVnUYcUJgc3e/xkLWb3eT7TDmCGuorLd0k2u
         jylGakFBesNIKZY/ImfUvAFKiW53G7pDUmzO2Q2QRA3qC6GqWvMWbu4ay5n5fjaPkKxO
         9Gl2Mad3USO3z2QZI28AAj1IpNkUueY07fieKwpgdw2xMqVNa2GXaxZsCq/m9BRJfPHv
         0r1A==
X-Gm-Message-State: APjAAAXPW4UZ9mN+3QkfP+nfh7C7JrWnYpsKOW18hUWVL8okh0FgntMC
	eCQpkO6MlD8ycpH6KW4y352lJLS4YyADkkgDYtIjRy5f
X-Google-Smtp-Source: APXvYqw7xxCFo6wwGFSyLVH6cLGRrpTFO/Ja2EdTOmL82GekUsN07pRO9/hIABT0ptKVzQJF9Y85oMPdxgs/lmoOiMc=
X-Received: by 2002:a17:90a:20a2:: with SMTP id f31mr6430766pjg.90.1560880614047;
 Tue, 18 Jun 2019 10:56:54 -0700 (PDT)
MIME-Version: 1.0
From: Romain Perier <romain.perier@gmail.com>
Date: Tue, 18 Jun 2019 19:56:42 +0200
Message-ID: <CABgxDoLSzkVJ7Vh8mLiZySz6uS+VEu+GUxRqX8EWHKQDyz2fSg@mail.gmail.com>
Subject: Audit and fix all misuse of NLA_STRING: STATUS
To: Kernel Hardening <kernel-hardening@lists.openwall.com>, Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Hi !

Here a first review, you can get the complete list here:

https://salsa.debian.org/rperier-guest/linux-tree/raw/next/STATUS



Regards,
Romain
