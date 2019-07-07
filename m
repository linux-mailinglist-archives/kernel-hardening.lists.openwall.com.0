Return-Path: <kernel-hardening-return-16377-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 4B6CE6156F
	for <lists+kernel-hardening@lfdr.de>; Sun,  7 Jul 2019 17:41:15 +0200 (CEST)
Received: (qmail 20234 invoked by uid 550); 7 Jul 2019 15:41:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 20162 invoked from network); 7 Jul 2019 15:41:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qwHbQTuFE2kUikky3tbT6iwWg4yYSI3KMwntAKoTe4o=;
        b=er0xymwpwDu18o30aSZDPXm6ih4bYYK56Lsn0PBrEBsI2+GkfvJ0DLnQK2RVcNhiay
         +D/JD05yJ/wS8a98UDAA7JmIXiaidvPOMnU2vGyMoKdb1jtHeCtBC3kmXqU8R3Q228vG
         68XGAd7WFcd9HF8yqcBoPhLbNT6Ry5i5f0EVkcB7o8FeikeNs/fXuQT4mDrR8/glCN+Y
         olzFtTyNcreomoJ0mN7e/JWRCYVoCfOG9fLdGpi1ajzyeGmzLMEJxRge1NuGQzdqnECA
         z47rAAdunWBGIzPrvt8O+hq21Hog6XykpUYRgPx2NN9dX9m4ijMVEhbxacAQadi+J3vO
         uUqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qwHbQTuFE2kUikky3tbT6iwWg4yYSI3KMwntAKoTe4o=;
        b=jrhSs19QJlsXtzOVkC0hwZ/5xUmgnJiVUUKsbSxSv1nXVwph37tNldolMs4yoZENUt
         XurAzPn5qNYz8YI0h6JU+5r6YLNyAHA3W8gAaUdZduCl4F+byePZGifvR0iozRcpuW+5
         DSOLgYMbr0cmkUVBJpetjKDlHQLPR2TzfOOihAoOaPyu/z9e0hWOOgJUTFabP/RTUVb+
         iHqXU8YdEBSQKuinzLKqTznNKC142yZrAqLFdBotJoNfAi8YZTUnRDyJFOiPqf7uvqB1
         cmgOWR4awZqXnmcp+cgB4Co4L0RUa66O7V6UDqDrSJPkQbEtRP7HG3pM7yCUndZIND0x
         mNgg==
X-Gm-Message-State: APjAAAVn+2X7eXzQBddM9eSMTeVpIFSMqVo8By670kFQbaET5xk8ucTu
	D/f02rhFlCh40625z8Og89HxpcVek5QhhnQSGsM=
X-Google-Smtp-Source: APXvYqzuxGF7GLEefBfbdxPUSlLxOABw/jdkNTyIlCf5RzRx9gAPfKtK85ODjRIpvEtMUdMrKQuPQCx7Np6eky+RxpY=
X-Received: by 2002:a5d:8347:: with SMTP id q7mr13181248ior.277.1562514054357;
 Sun, 07 Jul 2019 08:40:54 -0700 (PDT)
MIME-Version: 1.0
References: <1562410493-8661-1-git-send-email-s.mesoraca16@gmail.com> <alpine.LRH.2.21.1907061814390.24897@namei.org>
In-Reply-To: <alpine.LRH.2.21.1907061814390.24897@namei.org>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Sun, 7 Jul 2019 17:40:43 +0200
Message-ID: <CAJHCu1KPkzREqq0pGJ6Wp4CKHkA0Eeaj2vcGViE+B0192tFWFw@mail.gmail.com>
Subject: Re: [PATCH v5 00/12] S.A.R.A. a new stacked LSM
To: James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Brad Spengler <spender@grsecurity.net>, 
	Casey Schaufler <casey@schaufler-ca.com>, Christoph Hellwig <hch@infradead.org>, Jann Horn <jannh@google.com>, 
	Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"

James Morris <jmorris@namei.org> wrote:
>
> On Sat, 6 Jul 2019, Salvatore Mesoraca wrote:
>
> > S.A.R.A. (S.A.R.A. is Another Recursive Acronym) is a stacked Linux
>
> Please make this just SARA. Nobody wants to read or type S.A.R.A.

Agreed.
Thank you for your suggestion.
