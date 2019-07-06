Return-Path: <kernel-hardening-return-16365-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 86CAD611C7
	for <lists+kernel-hardening@lfdr.de>; Sat,  6 Jul 2019 17:03:16 +0200 (CEST)
Received: (qmail 13962 invoked by uid 550); 6 Jul 2019 15:03:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 13927 invoked from network); 6 Jul 2019 15:03:10 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=boVbp9ZUpDsf//+FdnJqiUZCUcTK245wDcHd7jIjrpY=;
        b=rh/FqlVekhxhsGpxulSZ7913KgIi6gqoFF4i/RNbOKBumEHd/qP8oFyX+UMcwSBJ/K
         eJbwXN4Ov/ueoIt4Oyi19u68UVz6gWVl32e1YjWfUsFB+HhwINCxXsiVdhbRDT3gbdiG
         5ibSk2q5E+W34FIfKzIclMIaC9eqyeGf8flkt1UTZCjuuU8xyABLpmZVy9kQW38Wcd47
         gAN4OKTn4B+qQpI+Fdb0r7ze2FAi8FFmV7f4mtLyNxY5j9rWNMTHzsbte1amZOAaiclM
         2DjSHrq+GVNYO2PJo+dpnRZ5GGJt2TrAWtORL250xGp3SE0C7nVC/Ze8vY2ybOEgpvg+
         BqLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=boVbp9ZUpDsf//+FdnJqiUZCUcTK245wDcHd7jIjrpY=;
        b=SkAJ5XRBTjUjUCwemAckbOxXo8QS1CuYbwA8K6ApYTH/3jeWiAKWHZH/Qzp96mkwZ2
         KJTQ/2XQhc5iU+Ou5mqBaw3+7D5Z4UZTNRO+q3DFgOrbMzcyjvGEQRdXi/OwmrMMlJp5
         HW77g+fXhqb8weG6wYyWxAdJzS7esCmhdNVLF3E/Mlezkgn0YouN1kz8Zi+VSzwYR0Ob
         yIQNSRQ3F7E2ITwz39aUHFccNAVhAJThk55fVYN+7cDLYsxoXIRacbJT/+W8SnqrxF/a
         udpghOukIVES8jtTL0wcdphVhd0E5A7zS1Vg2+BYbOY9u42etIkl9M84s/oEu919r1vt
         6iEg==
X-Gm-Message-State: APjAAAWQO7b3c0jae3NRSCd9+AVlSHfy9KLvJLpnZ30cPbGtkQWFnxg6
	6G1KbVWknq84eoA9hNcYKwM/qiwtlcOOBis9mXw=
X-Google-Smtp-Source: APXvYqy2UcPtMHw6LxYEegmwXcbc6qsKnlfXOceq6+ohw3DYNqy1gXgyu+nij430oPjMdmSFDPXMk206/IR43gK04QA=
X-Received: by 2002:a02:b710:: with SMTP id g16mr10876342jam.88.1562425378023;
 Sat, 06 Jul 2019 08:02:58 -0700 (PDT)
MIME-Version: 1.0
References: <1562410493-8661-1-git-send-email-s.mesoraca16@gmail.com> <HJktY5gtjje4zNNpxEQx_tBd_TRDsjz0-7kL29cMNXFvB_t6KSgOHHXFQef04GQFqCi1Ie3oZFh9DS9_m-70pJtnunZ2XS0UlGxXwK9UcYo=@protonmail.ch>
In-Reply-To: <HJktY5gtjje4zNNpxEQx_tBd_TRDsjz0-7kL29cMNXFvB_t6KSgOHHXFQef04GQFqCi1Ie3oZFh9DS9_m-70pJtnunZ2XS0UlGxXwK9UcYo=@protonmail.ch>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Sat, 6 Jul 2019 17:02:46 +0200
Message-ID: <CAJHCu1LVk-3XwZCF=iQzZfbJR0eDn-0VOaipOthYeqknT6VzKQ@mail.gmail.com>
Subject: Re: [PATCH v5 00/12] S.A.R.A. a new stacked LSM
To: Jordan Glover <Golden_Miller83@protonmail.ch>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, 
	Brad Spengler <spender@grsecurity.net>, Casey Schaufler <casey@schaufler-ca.com>, 
	Christoph Hellwig <hch@infradead.org>, James Morris <james.l.morris@oracle.com>, 
	Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>, 
	PaX Team <pageexec@freemail.hu>, "Serge E. Hallyn" <serge@hallyn.com>, 
	Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"

You are right. I just forgot to remove that paragraph from the cover letter.
My bad.
Thank you for noticing that :)

Il giorno sab 6 lug 2019 alle ore 16:33 Jordan Glover
<Golden_Miller83@protonmail.ch> ha scritto:
>
> On Saturday, July 6, 2019 10:54 AM, Salvatore Mesoraca <s.mesoraca16@gmail.com> wrote:
>
> > S.A.R.A. is meant to be stacked but it needs cred blobs and the procattr
> > interface, so I temporarily implemented those parts in a way that won't
> > be acceptable for upstream, but it works for now. I know that there
> > is some ongoing work to make cred blobs and procattr stackable, as soon
> > as the new interfaces will be available I'll reimplement the involved
> > parts.
>
> I thought all stacking pieces for minor LSM were merged in Linux 5.1.
> Is there still something missing or is this comment out-fo-date?
>
> Jordan
