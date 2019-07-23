Return-Path: <kernel-hardening-return-16552-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id BE80D71848
	for <lists+kernel-hardening@lfdr.de>; Tue, 23 Jul 2019 14:30:47 +0200 (CEST)
Received: (qmail 1746 invoked by uid 550); 23 Jul 2019 12:30:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 16268 invoked from network); 23 Jul 2019 06:49:08 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S8rFK+AmzSO6vqLaQ/7uOy+cqgQKBpkWkT02u2erFgg=;
        b=drls8++j8WiIUBszZciGsgJyjRs7RIjaroezVV5U4hhoQVJNDBd42/uLtT11dOYmgk
         o6gOooLeD8/8CMkOWReLYf8ulQR5fa1/SIVFlN61gOJoU9X9jgwsTidiGCoMqTrmMajx
         PeoMCs942IopI+MGsMG3rYyXZRB+0HMAkWqyvs6FmBvflZALK0QNWkCdlLOidz+5vM1O
         jSVNBhUukh5v1hg39ipoOPUdN5sYtLb40WV7jhnq/sFm7XsauI+gBPpMz4LGAfkPBubZ
         FWj0cCIcPWyYFfpWxL8LZsgO1iQ3IsXNFpS4D7XJaBxFEhf0VJhDamVsZPtbAnAC3eSs
         QHag==
X-Gm-Message-State: APjAAAWUIFX3GSbYxfpQ6qZm01If736q+uvJexjXTtkFjqQns5GWF41w
	JZc2yxP53kKFUoCdsoqpdMTRneAPJ3ygm8UWqDvZxg==
X-Google-Smtp-Source: APXvYqyiqKYY0HE59VWbxE4FrpnxvD4NxAFiDhK5ANqxW/V63mYbnrK3mDoxN/AJVxU9xTHF4Q5EToDReX9NcyoLjKc=
X-Received: by 2002:a9d:4c17:: with SMTP id l23mr10332937otf.367.1563864536429;
 Mon, 22 Jul 2019 23:48:56 -0700 (PDT)
MIME-Version: 1.0
References: <20190722132111.25743-1-omosnace@redhat.com> <201907220949.AFB5B68@keescook>
In-Reply-To: <201907220949.AFB5B68@keescook>
From: Ondrej Mosnacek <omosnace@redhat.com>
Date: Tue, 23 Jul 2019 08:48:45 +0200
Message-ID: <CAFqZXNu2RiTtTDvnCCwG5PnJ28LqGXPDhdAQkn4Xypx=+oWHOg@mail.gmail.com>
Subject: Re: [PATCH] selinux: check sidtab limit before adding a new entry
To: Kees Cook <keescook@chromium.org>
Cc: SElinux list <selinux@vger.kernel.org>, Paul Moore <paul@paul-moore.com>, 
	NitinGote <nitin.r.gote@intel.com>, kernel-hardening@lists.openwall.com, 
	Linux Security Module list <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, Jul 22, 2019 at 6:50 PM Kees Cook <keescook@chromium.org> wrote:
> On Mon, Jul 22, 2019 at 03:21:11PM +0200, Ondrej Mosnacek wrote:
> > We need to error out when trying to add an entry above SIDTAB_MAX in
> > sidtab_reverse_lookup() to avoid overflow on the odd chance that this
> > happens.
> >
> > Fixes: ee1a84fdfeed ("selinux: overhaul sidtab to fix bug and improve performance")
> > Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
>
> Is this reachable from unprivileged userspace?
>
> > ---
> >  security/selinux/ss/sidtab.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/security/selinux/ss/sidtab.c b/security/selinux/ss/sidtab.c
> > index e63a90ff2728..54c1ba1e79ab 100644
> > --- a/security/selinux/ss/sidtab.c
> > +++ b/security/selinux/ss/sidtab.c
> > @@ -286,6 +286,11 @@ static int sidtab_reverse_lookup(struct sidtab *s, struct context *context,
> >               ++count;
> >       }
> >
> > +     /* bail out if we already reached max entries */
> > +     rc = -ENOMEM;
> > +     if (count == SIDTAB_MAX)
>
> Do you want to use >= here instead?

Makes sense. Also staged for v2.

>
> -Kees
>
> > +             goto out_unlock;
> > +
> >       /* insert context into new entry */
> >       rc = -ENOMEM;
> >       dst = sidtab_do_lookup(s, count, 1);
> > --
> > 2.21.0
> >
>
> --
> Kees Cook

Thanks,
-- 
Ondrej Mosnacek <omosnace at redhat dot com>
Software Engineer, Security Technologies
Red Hat, Inc.
