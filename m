Return-Path: <kernel-hardening-return-19329-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id EEE1C22111A
	for <lists+kernel-hardening@lfdr.de>; Wed, 15 Jul 2020 17:33:31 +0200 (CEST)
Received: (qmail 8124 invoked by uid 550); 15 Jul 2020 15:33:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 8092 invoked from network); 15 Jul 2020 15:33:26 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jSn331YLrAzriHzhOYQ1FejPRa1jYvnatrzl/EtOhNU=;
        b=OIwtW+YpHTtuYpuhbA636wxeKFif6edZvP3g6vGPeDd21qHcDJbwDtDE/w1rAWULC1
         KIwTCAOLOwLjGzvACxO48r0eHZGKv44UQs4Ou9piNkIcifgx55ep53clzn9xb0besngt
         7PPrajb2/teHyp/EGblSI3aWxYad8iQOQ4knIIqhLaFcI3IpDIRD8dN5ogiCogV/KI8G
         brXvtAmpzWQ2lfc6e04NkdOHySJosN8Qunw2UOjlOX8r68n9adjDmnONgEHHCZEe72zW
         5YtRCK5GfFfWmezq1PGlGskL38wYWsWRIwmA54XnlHfLbLclysVxS89nKoEHFFRZcjgv
         dREw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jSn331YLrAzriHzhOYQ1FejPRa1jYvnatrzl/EtOhNU=;
        b=T0l5nSdWqZXAji44CqwTCVY+qhSHXVKCgc948iIVTF7F4S+mBWy8Qo7vROq9f8sEoP
         LGY7jCFXzj9hSYh2Nary1PEVSzdVfVSmFJyRpjLpFrueTUod7SFPEGXZ1FpVEo9XyUH7
         Dh/8PY7iG5mXTFcsNmmYDYeY0ChDIQOiEu18WB1A8iE7D4FJWlDmM/LBzHwGMydadedN
         JAmhFDREOdAU295INKUkgJ5qgJr5ox1C1qm5HBSCBSYsv7us4njRjjINKkGbM7j0GmvV
         /ZAGdmAVAjL2UgOv8i91MOdhbLr1ub2RdGQxH6/eKaco61pOIAIVU3eThCrvjgMiyDVQ
         /ukg==
X-Gm-Message-State: AOAM530J9IpidmBTFYm+XCkBxwtjv68wJjnRgUVtZDlbOeFC9mqktv9G
	ITVdreF2q1FhXEqhuG4inp8gzaJ/6NNl2y4RpnM=
X-Google-Smtp-Source: ABdhPJxa7nEycvxhQR/8Soihj5u31YwahVXvevcBPsf/shuE+yXY2tr9pejGEPpoDV4G2iDNy9W/PZf+pY9wThEYMx4=
X-Received: by 2002:a54:408e:: with SMTP id i14mr207896oii.175.1594827194445;
 Wed, 15 Jul 2020 08:33:14 -0700 (PDT)
MIME-Version: 1.0
References: <CAOMdWSLFSci1DCMsQLBoX-ADP0cHbhudfvRKokdM+pEQEfpnAQ@mail.gmail.com>
 <CAOMdWSJSXj4uC_=WRkqDoare-s1rcOtp=xJ7idCDAxhnTHacVw@mail.gmail.com>
 <202007131658.69C96B7D3@keescook> <CAOMdWSJW4xuqMz59zp3Jq2deqBD+8qGTVUJh4SUMVUPs8f1C3w@mail.gmail.com>
 <CAOMdWSLFXhS=KY9fG4SH5Oe9oEgj4sGmrRN8MOe9NZzJtdJOww@mail.gmail.com>
 <202007141617.DB13889164@keescook> <CAOMdWSKURaD=09LCmv1vSk8Js-uK1r5vVWYtPB_bEhDZJmFACw@mail.gmail.com>
 <CAOMdWSLZUpp+1DLr93vwD2P0-DHxSNFKFPDXB2nhq+x86JnLHw@mail.gmail.com>
 <202007150811.5A1E82BB3@keescook> <CAOMdWSL4LwuALVj17mePtk953WxFb+Zd3VMMJDr85PROLBRAAQ@mail.gmail.com>
 <202007150828.BD556EF6@keescook>
In-Reply-To: <202007150828.BD556EF6@keescook>
From: Allen <allen.lkml@gmail.com>
Date: Wed, 15 Jul 2020 21:03:03 +0530
Message-ID: <CAOMdWSJuGNHvbQdO3LyEQz27hsTpw4+Mo55t9Owf1e3xJw1oJg@mail.gmail.com>
Subject: Re: Clarification about the series to modernize the tasklet api
To: Kees Cook <keescook@chromium.org>
Cc: Oscar Carter <oscar.carter@gmx.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"

>
> Oh, maybe we misunderstood each other? Should I send the first three, or
> do you want to do it? I'm fine either way.

 I am fine with either, I'll let you decide on it.

-- 
       - Allen
