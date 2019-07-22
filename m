Return-Path: <kernel-hardening-return-16520-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id D6D0D7021D
	for <lists+kernel-hardening@lfdr.de>; Mon, 22 Jul 2019 16:20:35 +0200 (CEST)
Received: (qmail 5692 invoked by uid 550); 22 Jul 2019 14:20:29 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 3494 invoked from network); 22 Jul 2019 14:18:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8BgcIiKgU3cVL5c3uWuI7qgsPo43Ofan69gI+GtB8pA=;
        b=gW9vyQD8wpUE67AmtdmO61lNcDOm8C5bBDjVDcn6BwyHFIH8yaSi732bkz4H2nu2+K
         0EQKB1Eqsi2bMtqtxkY6Uqvm9FbC3KHdjMr8YWU2Q0dO14s4YHbTce11onLwHo4AkMfY
         yl+IIgyxsY6GRdnWrYZCAWCuTn9eqfkm+fD2CxNNGY7VToOg0UAD+IT95RBQ3H+H4PRq
         AYlaAXHtxknXs98faJuayVZB7UpcKc1FZ6sfp2Vz7vFXDf72PzX1oucRO0/NM4yrPteD
         mACizNGtGqbpG8m6dvzm4d6MjETaOL0ZyGQyV8xUaDMtMLLMbru0xbYgT4Eyb7xT32DO
         AWqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8BgcIiKgU3cVL5c3uWuI7qgsPo43Ofan69gI+GtB8pA=;
        b=T5pO59CCXLRSyfyfrun48FSpsME0Ep0u8Bwsa5UjfAhCs4Mm1AIrz+9V7cwQvmZhct
         Hh5P7EoqImotK+YjIRYky1vuyM6Jqa5nNNxlrrk4hUa0dWolQI4Ky7UABQRInYVWDYs8
         uSbmi3l0QjZ85SqvIfRTo2C16aM0MTV7wPgJKWPt2qlkKfSTgywIz/m5WyXxDWqhwuVJ
         lwrJAs4TBhQTP82tUN3mFtAHnUoqkLkbqtxa917y/vgv8z86HHPzZ2OT7kHuCG5In9I0
         u44oo82YRutIpORJBxdBPDMhcArt+5JX/RImwe/2CE+l5N3AELs702oAcUH+edG1q85k
         gtvA==
X-Gm-Message-State: APjAAAU1m/VtXvaP+6qAXHwtQRnYtuJN9BAA5szU0KTbvsymEfuRepbz
	QmrDz33CkA5CDvqyoNGdJ+B1x2ZBjUGHCq9OASo=
X-Google-Smtp-Source: APXvYqxSU8r5SW12WAZvYzgqmo77sEVY1AxWrM0uLeeeouxYv0Rw9/ilnZOqdOmpbDCS0VjqHL/70dpc95EAtETUm4U=
X-Received: by 2002:a6b:d008:: with SMTP id x8mr62293510ioa.129.1563805074311;
 Mon, 22 Jul 2019 07:17:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190722132111.25743-1-omosnace@redhat.com>
In-Reply-To: <20190722132111.25743-1-omosnace@redhat.com>
From: William Roberts <bill.c.roberts@gmail.com>
Date: Mon, 22 Jul 2019 09:17:42 -0500
Message-ID: <CAFftDdqROGAUDD3wXRC-PSjnrm29B6bfsBDn8AMPKkzJ8yJ=Hg@mail.gmail.com>
Subject: Re: [PATCH] selinux: check sidtab limit before adding a new entry
To: Ondrej Mosnacek <omosnace@redhat.com>
Cc: selinux@vger.kernel.org, Paul Moore <paul@paul-moore.com>, 
	NitinGote <nitin.r.gote@intel.com>, kernel-hardening@lists.openwall.com, 
	Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, Jul 22, 2019 at 8:34 AM Ondrej Mosnacek <omosnace@redhat.com> wrote:
>
> We need to error out when trying to add an entry above SIDTAB_MAX in
> sidtab_reverse_lookup() to avoid overflow on the odd chance that this
> happens.
>
> Fixes: ee1a84fdfeed ("selinux: overhaul sidtab to fix bug and improve performance")
> Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
> ---
>  security/selinux/ss/sidtab.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/security/selinux/ss/sidtab.c b/security/selinux/ss/sidtab.c
> index e63a90ff2728..54c1ba1e79ab 100644
> --- a/security/selinux/ss/sidtab.c
> +++ b/security/selinux/ss/sidtab.c
> @@ -286,6 +286,11 @@ static int sidtab_reverse_lookup(struct sidtab *s, struct context *context,
>                 ++count;
>         }
>
> +       /* bail out if we already reached max entries */
> +       rc = -ENOMEM;

Wouldn't -EOVERFLOW be better?

> +       if (count == SIDTAB_MAX)
> +               goto out_unlock;
> +
>         /* insert context into new entry */
>         rc = -ENOMEM;
>         dst = sidtab_do_lookup(s, count, 1);
> --
> 2.21.0
>
