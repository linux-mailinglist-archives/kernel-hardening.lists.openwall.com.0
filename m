Return-Path: <kernel-hardening-return-16077-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 97FFB39C10
	for <lists+kernel-hardening@lfdr.de>; Sat,  8 Jun 2019 11:20:22 +0200 (CEST)
Received: (qmail 30237 invoked by uid 550); 8 Jun 2019 09:20:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 30201 invoked from network); 8 Jun 2019 09:20:15 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wEDRZRkVKco88Q7RzeuAB7rAAn77y9OraxPxsD6CfXQ=;
        b=NYJ6KyL5NFEwWeo7lV5/32ZP8KLnypOSY/cwzxogxx5zM9gglrG27rdPRRrItlsBDP
         9d44u0JAQlABurycvlVdaYeevAy+oeGn01gpMmyxuC7uLi56ZvLzL16AT/jdBy0bw9Ss
         uXyoaSoQA+jpt+3Nqe/ggjD2IluGxoVt5Ru5rj2v989PmyLfQltuXuvbLEi43L8x8fb6
         1wA2VKub2Nj62c3Nv4yEN314/ehMhfAR22+pPBOIyrQ1YCAQpJL1EHjHvPiLjcAXzBPZ
         VTpM7I64SLBf3dBxKzsLeVH9HcUVIm5WtqYl7wwo7J1uin03WGC+HQIVlinU1/55AZKU
         JAeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wEDRZRkVKco88Q7RzeuAB7rAAn77y9OraxPxsD6CfXQ=;
        b=eqMl5sXPqyDKapF5q5EZQY/yCL9LJKantPixTYDWSu0tG0QWvyNrn74EdW+7LRLy0t
         JbpUyCYmsIPVEY8le3KtezWSFzMLyEgmqNpL9DrRAZ1+NbTrwb+VuC9zkqeEgqQkqSoI
         U1DWdNdoeDlc62qglZsmtMzTdtfFnvmK+PFHfPuVLLuIT3alnG8avnrFy04EtcVmwJo/
         un7y4XpJ14P1lUY+c45dtTKXR7l4mRxuKZILhlPVn9e/ePkYuJyaTHuOzM09ZhMrDR6x
         +jberBWqU07zxdfjHvczFwILpUTsu3WUB2/BlNKe1StLhAA0NL1nMZRYZhYOb5+EmdmZ
         eAmg==
X-Gm-Message-State: APjAAAXAzWp1EIjsRxGwv1Dz6A6eFQif9ZH2sUkdrCvaG8JAVzuPwIaN
	pg1oRJ8kqCQJwYz3v9WpZkdmC09c3GGcDIdy9l0=
X-Google-Smtp-Source: APXvYqzFfzF8eZzpPP1K4RmI/QYZnzQHaMBwO5A8YKBtHtXbWRWuyYelnF4j9a34krMWyG/tqz4GI345WLqEtd+Ydyw=
X-Received: by 2002:a9d:7b43:: with SMTP id f3mr5767894oto.337.1559985603613;
 Sat, 08 Jun 2019 02:20:03 -0700 (PDT)
MIME-Version: 1.0
References: <CABgxDo+x3r=8HFxyM89HAc_FdY6+kBpJR5RpAgpOYsu0xZtshQ@mail.gmail.com>
 <CABgxDoJ-ue6HKyBR_q8cmbOp8DFnZDVf7zbxv8_wmHh7uis_vw@mail.gmail.com>
 <CAOfkYf4OxG-vkCOoWvmGxyRg3UVFcGszkdStKSoXf5qqyF_RQA@mail.gmail.com>
 <CABgxDoLe3fXNLob3pnj7Nn2v54Htqr+cg5gRRQPxFK7HPX85=Q@mail.gmail.com>
 <201906072117.A1C045C@keescook> <CAOfkYf40dzGm5qhEqMDJOHEHr0Zbw9KDT93QAPfb_jHEqWNu0g@mail.gmail.com>
 <CABgxDo+=rhCmn2qaGGM06TgDnaBZKi-kUjwg9cSq=+1XQOvBxg@mail.gmail.com>
In-Reply-To: <CABgxDo+=rhCmn2qaGGM06TgDnaBZKi-kUjwg9cSq=+1XQOvBxg@mail.gmail.com>
From: Shyam Saini <mayhs11saini@gmail.com>
Date: Sat, 8 Jun 2019 14:49:51 +0530
Message-ID: <CAOfkYf6Onhk-T-Xy4Q7YRKOVc4oQMg8dM--im09ida=Zfj6tEw@mail.gmail.com>
Subject: Re: Get involved
To: Romain Perier <romain.perier@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"

On Sat, Jun 8, 2019 at 1:47 PM Romain Perier <romain.perier@gmail.com> wrote:
>
> Hi,
>
> Thanks for these details.
>
> Yeah if this is okay for you , I will pick the task for NLA_STRING . I can mark it as WIP on the Wiki.
yes, I'm okay with it

Thanks!!
