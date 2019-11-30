Return-Path: <kernel-hardening-return-17453-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 7AC2510DE64
	for <lists+kernel-hardening@lfdr.de>; Sat, 30 Nov 2019 18:11:56 +0100 (CET)
Received: (qmail 7556 invoked by uid 550); 30 Nov 2019 17:11:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 7522 invoked from network); 30 Nov 2019 17:11:50 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=c1sELmfhJzgJPo0o8A4c/mzUDYiPnVWG5cnHtzOA1GM=;
        b=FuVFlhhP2zUW1dof6QwI6gu1sfE88RlTr/qOEcE9uyfoQyham5wgtC+XebN50RFx22
         03IRWfwXKTttQZfFaXZ3rMyguLmbgcVjvZPTm7wXPEZUQbZgS5sbIEyY7Z0mWfUZ4ki8
         He3HAWk2FkvEJq+LdA3d6IUmxZMyylaNQyETg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=c1sELmfhJzgJPo0o8A4c/mzUDYiPnVWG5cnHtzOA1GM=;
        b=b2syDQtNWQeS8b6hb5RN/uUVcaU5pPWrVu6SS3zxzF+/nrMRZZqgSM3lLyegzvlB9g
         75hCIDKPpcrlWWEkAk4/EdGqC3UWu0eRWuVD/p+bffqK9gqiezHENrQf2EIwX7OCUUsD
         b9mGLpZ2YGKsA6/RkzqiroiAjc7Cht/C5D2gJTzAjfCLHsqjdNP4bwLuPb5IiyuTdt/V
         xpsoI0MUzw0MSwhB/6G6cn6u8NpgsuvZSg3/1Sz/8SFlL7KZ+ADVdXXFyb7/FQroqOrD
         4TXKiHAl3bJsNnVqKMPyZcdSlRInNgdV7SU77NXBhG9iSMcge023/lyvSRrmonJBbz5U
         az+g==
X-Gm-Message-State: APjAAAU2gFKKy1DGFNWyWIXgCMwvmlyuzjuGdPDXffa+RnZmiZJnUFzp
	rnSj4Vu84LLo1gZSVnNZ52Ukjdo91Oo=
X-Google-Smtp-Source: APXvYqxoxWVoNIoVd29OjTXvp1kaVMUvMByTxBBPJ9hoHv+OqR25LgQq9CKaeHNx796CRIcFcagSIw==
X-Received: by 2002:a17:90a:bd95:: with SMTP id z21mr25363648pjr.10.1575133899057;
        Sat, 30 Nov 2019 09:11:39 -0800 (PST)
Date: Sat, 30 Nov 2019 09:11:36 -0800
From: Kees Cook <keescook@chromium.org>
To: Kassad <aashad940@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
	kernel-hardening@lists.openwall.com
Subject: Re: Contributing to KSPP newbie
Message-ID: <201911300855.BC12761@keescook>
References: <CA+OAcEM94aAcaXB17Z2q9_iMWVEepCR8SycY6WSTcKYd+5rCAg@mail.gmail.com>
 <20191129112825.GA27873@lakrids.cambridge.arm.com>
 <CA+OAcEO8TnqLTBoCUjP=-z4TCrTTHqXx4pY7mBj+FZ0pAvw8XA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+OAcEO8TnqLTBoCUjP=-z4TCrTTHqXx4pY7mBj+FZ0pAvw8XA@mail.gmail.com>

On Fri, Nov 29, 2019 at 12:32:17PM -0500, Kassad wrote:
> On Fri, Nov 29, 2019 at 6:29 AM Mark Rutland <mark.rutland@arm.com> wrote:
> > On Thu, Nov 28, 2019 at 11:39:11PM -0500, Kassad wrote:
> > > Hey Kees,
> > >
> > > I'm 3rd university student interested in learning more about the linux kernel.
> > > I'm came across this subsystem, since it aligns with my interest in security.

Hi! Welcome to the list. :)

> > > Do you think as a newbie this task
> > https://github.com/KSPP/linux/issues/11 will
> > > be a good starting point?
> >
> > I think this specific task (Disable arm32 kuser helpers) has already
> > been done, and the ticket is stale.
>
> This might be a bit to vague but is there any task that is beginner
> friendly? I did have a look at todo list and most of them look quite
> daunting.

I tried marking some bugs with "good first issue", but it looks like
people are already chipping away at things:
https://github.com/KSPP/linux/issues?q=is%3Aopen+is%3Aissue+label%3A%22good+first+issue%22

I haven't checked on this thread of discussion recently:
https://lore.kernel.org/lkml/CANhBUQ3V2A-TBVizVh+eMLSi5Gzw5sMBY7C-0a8=-z15qyQ75w@mail.gmail.com/
There might be some work in there still to replace odd uses of
strncmp()?

-- 
Kees Cook
