Return-Path: <kernel-hardening-return-19324-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id EB8E022064E
	for <lists+kernel-hardening@lfdr.de>; Wed, 15 Jul 2020 09:34:56 +0200 (CEST)
Received: (qmail 26316 invoked by uid 550); 15 Jul 2020 07:34:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 26281 invoked from network); 15 Jul 2020 07:34:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JI693Y+vhzBcfAftmAVXUoPh4KER+T+S6nXidIR+H3M=;
        b=Nrhx0plTcOZAk+iDGf0KH9v4mJoj7Y2AjdZaZgomK+hf8rmvd3MWoX3C8W7D4gq1kL
         Du7TphTIOzDR0qN5Uao8G1n7l0BBL29+6WQCoUUW/ZmGpNAVKGIiy3mUHmhhEXT7yatF
         vY2B/GmApfW1KPE3aCQtAtZkQcs1fAHF/Nwid0UpsnzVohPbMLlLknA5oVfMMBUWJcLB
         LKH/3TnkUAclTS4QoBCtNkZhR5OMuQ5xScJRX6RlaWMC77ldDOHU4Yz6SYaiqYeClfSm
         /kF5BVIdh824OLdbr7WPDb22L6+OC/0dWFHX5W+BZMoyK8IxuMXpRQRKZziM1372Q0F+
         6bqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JI693Y+vhzBcfAftmAVXUoPh4KER+T+S6nXidIR+H3M=;
        b=anAzJJeGNfEwzDCNR8PcSzd5pi/5AaWypffhZC6XR1hJqMqvjaFm4g3TmaoKspSj6Z
         tRLGWT5SuYKlFgNUDM8Mzfl8VJJnebwfk2GSHd++hh5AiF0rBRArLGoj3pZ6pijEVkCb
         RTYEKGnxRaFsZ7TwcYZFEpaa4FLvjJ7FQ4ldUR9QnRPyM6i0TVvLvpIjm9atqf6GZmet
         Gh/x5U6y0S38q73Ls4WRo+JIPL4bYFgMzmYHTSlkzn+mHjfwGQvnSNtvoCBNvzCHz7mO
         /GppiXNwPRIvnSE1aKzLd1VGM9yheDwTx0zQpAwnJcpONOvONloHpmWZRlAiJ5KEMHeD
         cTWA==
X-Gm-Message-State: AOAM53249qN5byfBy+wfZ3YEKHQdlfFmgeJJ+wwzPmDRI+VgmY1f5X/9
	jIr4lfIGwn5J7E79P8kCSoPUiGPW5FpEUzgw9g0=
X-Google-Smtp-Source: ABdhPJyGIQSl26ay3gSOUMn76hz/YutqeSUDKNKVf9X4wA4CKz5WkPiItGHjtOfgGiMvayqHfL4CrP03kGcKi7su1Io=
X-Received: by 2002:a9d:65c2:: with SMTP id z2mr7568065oth.264.1594798477794;
 Wed, 15 Jul 2020 00:34:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200711174239.GA3199@ubuntu> <CAOMdWSLFSci1DCMsQLBoX-ADP0cHbhudfvRKokdM+pEQEfpnAQ@mail.gmail.com>
 <CAOMdWSJSXj4uC_=WRkqDoare-s1rcOtp=xJ7idCDAxhnTHacVw@mail.gmail.com>
 <202007131658.69C96B7D3@keescook> <CAOMdWSJW4xuqMz59zp3Jq2deqBD+8qGTVUJh4SUMVUPs8f1C3w@mail.gmail.com>
 <CAOMdWSLFXhS=KY9fG4SH5Oe9oEgj4sGmrRN8MOe9NZzJtdJOww@mail.gmail.com> <202007141617.DB13889164@keescook>
In-Reply-To: <202007141617.DB13889164@keescook>
From: Allen <allen.lkml@gmail.com>
Date: Wed, 15 Jul 2020 13:04:26 +0530
Message-ID: <CAOMdWSKURaD=09LCmv1vSk8Js-uK1r5vVWYtPB_bEhDZJmFACw@mail.gmail.com>
Subject: Re: Clarification about the series to modernize the tasklet api
To: Kees Cook <keescook@chromium.org>
Cc: Oscar Carter <oscar.carter@gmx.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Jul 15, 2020 at 4:50 AM Kees Cook <keescook@chromium.org> wrote:
>
>
> I did this to fix it:
>
> rm 0*.patch
> git format-patch 7f51b77d527325bfa1dd5da21810765066bd60ff
> git reset --hard 7f51b77d527325bfa1dd5da21810765066bd60ff
> perl -pi.old -e \
>         's/Subject: \[PATCH([^\]]+)\] ([^:]+):([^ ])/Subject: [PATCH\1] \2: \3/' 0*patch
> git am 0*.patch

Thanks, I shall have it fixed.

-- 
       - Allen
