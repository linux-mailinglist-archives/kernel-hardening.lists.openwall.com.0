Return-Path: <kernel-hardening-return-18706-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 155831C21CC
	for <lists+kernel-hardening@lfdr.de>; Sat,  2 May 2020 02:06:50 +0200 (CEST)
Received: (qmail 26480 invoked by uid 550); 2 May 2020 00:06:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 26457 invoked from network); 2 May 2020 00:06:42 -0000
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
	:references:in-reply-to:from:date:message-id:subject:to:cc
	:content-type; s=mail; bh=v8CEPhtYy//8RVs7R9SE4WuHeYE=; b=oXv897
	Q657xkDx/uTHMf9tPN9nwUAQKO4+uNSl0I4BzWTpQD+fXRjW9/RBEepdFdig2xm1
	nllfFwoutRERVt9h2VPXOQwngBptHZ+g88UyXsiiAGWrA5Jsd5x5W1f6V2dk7SQM
	Um+odStnhnbqZSTFEmeognyKhSBX8xxc2zJ9t4oFL4Shp2WkdMPHs4tx+/pj7rlM
	7tCn3j8chGy9TGVWXTkWehTQHBGXeL3dAMAGw0vmeuDcl3BCMkYlu8iHIoXZWCOt
	DooFfXksUk36UMDPV0X5xIgFwvmST/l1mtxbWVFxP33k9xqVFB6MbFa3gPPcUg91
	bdPq7HrSovZP7A+Q==
X-Gm-Message-State: AGi0PuZUPKDiEjZJiQxnwf5mEnRqJp1YuH0nBEHWP7gyu+nsaG5knsbZ
	OxGwpjioemngrMIC6Hp56YXHAGqL6Lwo4b6mdxc=
X-Google-Smtp-Source: APiQypJoG+c/aoKfXrAe0iv4v3ahcNqsCH+3jY9kSos4Xyt4xRI+UMJRcq73LeyQxG8swvg4SEpyofOIyMbfD9cBDZI=
X-Received: by 2002:a92:d4c4:: with SMTP id o4mr6399787ilm.38.1588377988977;
 Fri, 01 May 2020 17:06:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200501222357.543312-1-Jason@zx2c4.com> <20200501230913.GB915@sol.localdomain>
In-Reply-To: <20200501230913.GB915@sol.localdomain>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Fri, 1 May 2020 18:06:17 -0600
X-Gmail-Original-Message-ID: <CAHmME9rpZGiwrK93=+6z8qBdDVs273MaR_boDd1xjjZRwbqpKQ@mail.gmail.com>
Message-ID: <CAHmME9rpZGiwrK93=+6z8qBdDVs273MaR_boDd1xjjZRwbqpKQ@mail.gmail.com>
Subject: Re: [PATCH] security/keys: rewrite big_key crypto to use Zinc
To: Eric Biggers <ebiggers@kernel.org>
Cc: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org, 
	Andy Lutomirski <luto@kernel.org>, Greg KH <gregkh@linuxfoundation.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, kernel-hardening@lists.openwall.com
Content-Type: text/plain; charset="UTF-8"

Hey Eric,

Thanks for the review.

I'll add `select CONFIG` as you suggested. I agree about trying to
move as much as possible out of crypto and into lib/crypto. Breaking
those dependency cycles won't be easy but perhaps it'll be possible to
chip away at that gradually. (I'd also lib a
lib/crypto/arch/{arch}/..., but I guess that's a separate discussion.)

I'll also change -EINVAL to -EBADMSG. Nice catch.

Regarding the buffer zeroing... are you sure? These buffers are
already being copied into filesystem caches and all sorts of places
over which we have zero control. At that point, does it matter? Or do
you argue that because it's still technically key material, we should
zero out both the plaintext and ciphertext everywhere we can, and
hopefully at some point the places where we can't will go away? IOW,
I'm fine doing that, but would like to learn your explicit reasoning
before.

Jason
