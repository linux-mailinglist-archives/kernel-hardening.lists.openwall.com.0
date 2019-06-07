Return-Path: <kernel-hardening-return-16072-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 529FC393E7
	for <lists+kernel-hardening@lfdr.de>; Fri,  7 Jun 2019 20:04:57 +0200 (CEST)
Received: (qmail 15884 invoked by uid 550); 7 Jun 2019 18:04:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 15837 invoked from network); 7 Jun 2019 18:04:50 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5xPD9+QmMO4p3qi1vv0OvFG+Y5LJ7/jalpgyENmw4Pw=;
        b=pzSVVnmcnzfvexdn9LdnnwZUkQQtIG9zVH+NytrFeanJkSOBqwQFjPo05iflCtGoTM
         nPaGenhja4asf5UOyBzerlkPS3rPzzNLmUjcRZR3xl2nF3axbpovkMFqgGdpcPvpHUAo
         vY6Rq4HDALxQvSDUBClOyWRTn+d0R6ux29R38/r2ess84V1idi7Y1kHqG3Huq7aMGIh2
         uR8kFcxlUXtTOSDNwRPzbcU4O/GgS3mQ+2B4k3KFJ4hYJxEZ5CRucXZmJkyAsDr8v3uj
         arQ83c0JmAumRyGxULweuTEWhEFp9tj9Mn+fctM7k8mfTI1nnmoPtZJqWPNUMd218u7w
         JGdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5xPD9+QmMO4p3qi1vv0OvFG+Y5LJ7/jalpgyENmw4Pw=;
        b=spf6TUZUamfQd4XJMUnssF51oD8gFigl4JCun1kgvQOfxvYTX5v5cbo09e8kE2ACSe
         8zcuwj3d8Vm94z5YBVdEKDfFlimPca0K+vC3QFEsvh/iIe3EU6kkeOUQumVTXSKPWS4J
         y8MQUpl6PDl4nMdVYqcDdjUFIiGHBX+w1pfCVwGJgd1T1c50aEOEgmKPhcTRzf7V/bRb
         MHsvoHtZ9AWTvdsM2YSMgoRSgDPoa1AK1osixHKP9J6DApmkZq6YNb8r8avrN4ATIlTl
         KfLG5J49LT9dQOSbBhBref5RgCg/+Vj/AE1BpTwumlblleIoBJ2WdlKu3USqwUn36Qfj
         o3og==
X-Gm-Message-State: APjAAAUv3BqEs/KQrB9g2N/owpNvRGdQBU575SpeNnjouQlzXYNSdhtp
	1C+r9subvDoQuEzvaD6Cr4UeKMV26TS5ht8Zqv0=
X-Google-Smtp-Source: APXvYqzQQjQh/lUcxDJbU5hSQOgY8ww/SZCG1tzuShdQZmQg/UzVLZ5wv1t2Hx5uhaKbsaZ/pU5Zx2DfIyoHQIgaO6I=
X-Received: by 2002:aca:b6d5:: with SMTP id g204mr4619539oif.138.1559930678960;
 Fri, 07 Jun 2019 11:04:38 -0700 (PDT)
MIME-Version: 1.0
References: <CABgxDo+x3r=8HFxyM89HAc_FdY6+kBpJR5RpAgpOYsu0xZtshQ@mail.gmail.com>
 <CABgxDoJ-ue6HKyBR_q8cmbOp8DFnZDVf7zbxv8_wmHh7uis_vw@mail.gmail.com>
In-Reply-To: <CABgxDoJ-ue6HKyBR_q8cmbOp8DFnZDVf7zbxv8_wmHh7uis_vw@mail.gmail.com>
From: Shyam Saini <mayhs11saini@gmail.com>
Date: Fri, 7 Jun 2019 23:34:27 +0530
Message-ID: <CAOfkYf4OxG-vkCOoWvmGxyRg3UVFcGszkdStKSoXf5qqyF_RQA@mail.gmail.com>
Subject: Re: Get involved
To: Romain Perier <romain.perier@gmail.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"

Hi Roman,

> I will probably take the task "WARN on kfree() of ERR_PTR range" , and
> then help to port to refcount_t   (I plan to use linux-next).
> I have asked for an account to jmorris, so I can mark the task as "WIP".


I'm already on that task, would you mind to proceed with some other task.
Kees suggested me this task sometime ago.
I'll be sending patches this weekend.

Thanks a lot,
Shyam
