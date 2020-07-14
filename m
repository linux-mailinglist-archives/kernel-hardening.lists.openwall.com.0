Return-Path: <kernel-hardening-return-19307-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 4F0B421F40D
	for <lists+kernel-hardening@lfdr.de>; Tue, 14 Jul 2020 16:27:37 +0200 (CEST)
Received: (qmail 28616 invoked by uid 550); 14 Jul 2020 14:27:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 28577 invoked from network); 14 Jul 2020 14:27:29 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=//VaEzNi8yQg23BfvvrIG2s50zF6jLdteUv6Qyaj3wY=;
        b=LYpj0Muo4oheB2kBoL9+3y4kgkvMYXfGuUW364ILspqjHURycsOiAUiFWp5K229ie0
         fHzw65jXBO8w9B9XlBS/I08ifUycDjZBoRMzRfHxpYLJlKsO+oy7MGE7gr6oUBGIXZ0x
         gMrcSrjBHDRJOoHUJ5QuXMwKih6G/yNIps+PT0mvVTy5X6xbmP2ahRCWOqHn+J5j53M7
         Ka5xXwb0PBAo6Y63H8WNqGbQmXgLKLGi0FO5TmDX3cymqvSQ9XMAploI/4ZKod1sdSRL
         AWiq03N2Mc0sWplnDbNv1t3iNoXRZ+FRY2N0YITBDjQT91WtcfpYT9+saCg/PelBqBMY
         Hoew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=//VaEzNi8yQg23BfvvrIG2s50zF6jLdteUv6Qyaj3wY=;
        b=h22RQdiCLaEjcIc9m+u05kVr7IUw7/UO88nSqTQZKKzwvaDpgde9VMSUxtM5tYzsyz
         5xgsNw0FyJDG2z9qr9YvWGVJ9jj18fhXjGp9/w0ePbHbtKvtbCEsv8ZG4zd7uGWgGzgQ
         QqFSEvbZ+aDsc8emAdc48XvSmsDYUEY6DCzP7xWUdVqCRDjmJwDoBS3ebzYHD1zYeWiH
         nlJhD+zSWRI64eXM9Xkc99NjYGp7pjJ6MA9uBt6ZAWNZYb4sanCWBj5jBi/D8e634+/L
         XF23kjDfa0GGNu1YX41GIfp1TbIbt5AUqYaDz+IoHwskGRblDzb3ZTLFg/lrQ4GXVyji
         buZw==
X-Gm-Message-State: AOAM5329DKUjtSioaZ0pR8s6rsCcr4j9He3vH3XtLUX31ZihWbyhdpjt
	ad7TEyMF4GsAF4PTlzLJs3unQ58zOMET2bhrO4Y=
X-Google-Smtp-Source: ABdhPJyNpcWZ8a8RrIxLiLsnPVkA2CKtaZY+WtjUGpBPjPn7GJc4vW1WCMpuaiduq8W6kCYGtRVy+1XOTn2WS0nEvR4=
X-Received: by 2002:a9d:65c2:: with SMTP id z2mr4294422oth.264.1594736838010;
 Tue, 14 Jul 2020 07:27:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200711174239.GA3199@ubuntu> <CAOMdWSLFSci1DCMsQLBoX-ADP0cHbhudfvRKokdM+pEQEfpnAQ@mail.gmail.com>
 <CAOMdWSJSXj4uC_=WRkqDoare-s1rcOtp=xJ7idCDAxhnTHacVw@mail.gmail.com>
 <202007131658.69C96B7D3@keescook> <CAOMdWSJW4xuqMz59zp3Jq2deqBD+8qGTVUJh4SUMVUPs8f1C3w@mail.gmail.com>
In-Reply-To: <CAOMdWSJW4xuqMz59zp3Jq2deqBD+8qGTVUJh4SUMVUPs8f1C3w@mail.gmail.com>
From: Allen <allen.lkml@gmail.com>
Date: Tue, 14 Jul 2020 19:57:06 +0530
Message-ID: <CAOMdWSLFXhS=KY9fG4SH5Oe9oEgj4sGmrRN8MOe9NZzJtdJOww@mail.gmail.com>
Subject: Re: Clarification about the series to modernize the tasklet api
To: Kees Cook <keescook@chromium.org>
Cc: Oscar Carter <oscar.carter@gmx.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"

>
> My bad, I should have told you that github was just a placeholder for
> WIP patches. I have been testing a set of patches regularly, no issues.
> I shall push the updated branch.
>

 Made some progress today. I have a few more things to complete
before the series can go out for review. I have pushed out the changes to:

https://github.com/allenpais/tasklets/commits/tasklets_V1

Thanks,
 - Allen
