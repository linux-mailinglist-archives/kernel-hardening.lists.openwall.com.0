Return-Path: <kernel-hardening-return-18708-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id E5B6E1C21D2
	for <lists+kernel-hardening@lfdr.de>; Sat,  2 May 2020 02:15:33 +0200 (CEST)
Received: (qmail 32449 invoked by uid 550); 2 May 2020 00:15:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 32429 invoked from network); 2 May 2020 00:15:28 -0000
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
	:references:in-reply-to:from:date:message-id:subject:to:cc
	:content-type; s=mail; bh=xArW0Tt0LPV9u+5H1DjkH6M+yA4=; b=ugLP3y
	TqoDYEtXYKUfSZykUGyZPDZni8F8xcfo/ltMimFjuWPnINahHpd6Emtwu9FF7yE0
	m38GpZi7jeOuwp+C8MHoBVpFqawEIoAxL63813LaEju3BXJNZvHrvS5xoRtCdzyL
	sVgmsRlAL4Ivm8dlmHQCoYjoGPsJ/RDEDs4qCE51x9a4Kbj3hM5mQDSgBGSmK3ID
	dkhFbJp3fg3Y/uto2BhObWF2t5N45Lf2dC2ET72CH/gNifW3oDvmTsuGqPzoVm7K
	eS3J0P4OxV7Lw95IXGIZVBh4JWHUfNT/m4evdbxqTguFVQq8KMZyf1DuywOmmmX4
	XjYQitoz5jfiB+Dw==
X-Gm-Message-State: AGi0Pua57IM0VGzy3Z4mSsgY3uFuiFRAbpMTpi+Qe8DgD5UaYne+oCUu
	6zMjj1wUIP5npFAl1ysIKCdC2QzF9786+Xe8X/4=
X-Google-Smtp-Source: APiQypJ4EmnKEDwD/gQQdw2h/xxynhdgE+9RC5Boyi9nSp9XQMhDaFiKWqTBhHBIswIG/TLcmRrOhlj5NrDeuWQrsWQ=
X-Received: by 2002:a92:d4c4:: with SMTP id o4mr6428914ilm.38.1588378515633;
 Fri, 01 May 2020 17:15:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200501222357.543312-1-Jason@zx2c4.com> <20200501230913.GB915@sol.localdomain>
 <CAHmME9rpZGiwrK93=+6z8qBdDVs273MaR_boDd1xjjZRwbqpKQ@mail.gmail.com> <20200502001409.GD915@sol.localdomain>
In-Reply-To: <20200502001409.GD915@sol.localdomain>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Fri, 1 May 2020 18:15:04 -0600
X-Gmail-Original-Message-ID: <CAHmME9rvp4JrER0RPp=VgYwYL87jntwW8vWNANzubH3Ah_8Oow@mail.gmail.com>
Message-ID: <CAHmME9rvp4JrER0RPp=VgYwYL87jntwW8vWNANzubH3Ah_8Oow@mail.gmail.com>
Subject: Re: [PATCH] security/keys: rewrite big_key crypto to use Zinc
To: Eric Biggers <ebiggers@kernel.org>
Cc: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org, 
	Andy Lutomirski <luto@kernel.org>, Greg KH <gregkh@linuxfoundation.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, kernel-hardening@lists.openwall.com
Content-Type: text/plain; charset="UTF-8"

On Fri, May 1, 2020 at 6:14 PM Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Fri, May 01, 2020 at 06:06:17PM -0600, Jason A. Donenfeld wrote:
> > Hey Eric,
> >
> > Thanks for the review.
> >
> > I'll add `select CONFIG` as you suggested. I agree about trying to
> > move as much as possible out of crypto and into lib/crypto. Breaking
> > those dependency cycles won't be easy but perhaps it'll be possible to
> > chip away at that gradually. (I'd also lib a
> > lib/crypto/arch/{arch}/..., but I guess that's a separate discussion.)
> >
> > I'll also change -EINVAL to -EBADMSG. Nice catch.
> >
> > Regarding the buffer zeroing... are you sure? These buffers are
> > already being copied into filesystem caches and all sorts of places
> > over which we have zero control. At that point, does it matter? Or do
> > you argue that because it's still technically key material, we should
> > zero out both the plaintext and ciphertext everywhere we can, and
> > hopefully at some point the places where we can't will go away? IOW,
> > I'm fine doing that, but would like to learn your explicit reasoning
> > before.
>
> It's true that the buffer zeroing doesn't matter in big_key_preparse() because
> the buffer only holds the encrypted key (which is what the shmem file will
> contain).  But in big_key_read(), the buffer holds the decrypted key.  So it's
> at least needed there.  Having it in both places for consistency might be a good
> idea.

Alright. v2 coming your way shortly.


Jason
