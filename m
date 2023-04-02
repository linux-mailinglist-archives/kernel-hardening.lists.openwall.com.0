Return-Path: <kernel-hardening-return-21649-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by mail.lfdr.de (Postfix) with SMTP id E706B6D3965
	for <lists+kernel-hardening@lfdr.de>; Sun,  2 Apr 2023 19:17:15 +0200 (CEST)
Received: (qmail 21835 invoked by uid 550); 2 Apr 2023 17:17:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 21803 invoked from network); 2 Apr 2023 17:17:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hboeck.de; s=key1;
	t=1680455814; bh=iJsPBQ8YZFK46TsneiHnsum+yHuuLipe4meKHRAtaOg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	b=alo8/iP0YZGJh6Ccig4g7tEoQJZs7WzqjEk4WfEVZROsKUbrCD9dfRKlAKHGwmmBJ
	 W+jd6gbQekDJZu9J/cQKI5UjMPd9HE2FTukdfjj1AdZR48kW2YWwrMK5Wv5zCLEp2/
	 vZzp7CunWrZ0uwU3ZfjqifhTq+fBnY2r1vZrGpuQHXl2fapfp2Qr/S7woAa7Y41j/i
	 wbO6HBo9bEdN6eF6P+AkWQ8lDLuVkNLWs+FfndnYeMps+1kWGPXJDseWfI7Cl3Eq3h
	 dZ4LEPfMIKzgiSg1cBJm3EGfm4yKtYG9fl5R++9SslyLsU5jdAG5Cne08yiQ0LLVDS
	 lj4zAZqKuBYzg==
Original-Subject: Re: [PATCH] Restrict access to TIOCLINUX
Author: Hanno =?iso-8859-1?q?B=F6ck?= <hanno@hboeck.de>
Date: Sun, 2 Apr 2023 19:16:52 +0200
From: Hanno =?iso-8859-1?q?B=F6ck?= <hanno@hboeck.de>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: kernel-hardening@lists.openwall.com
Subject: Re: [PATCH] Restrict access to TIOCLINUX
Message-ID: <20230402191652.747b6acc.hanno@hboeck.de>
In-Reply-To: <2023040232-untainted-duration-daf6@gregkh>
References: <20230402160815.74760f87.hanno@hboeck.de>
	<2023040232-untainted-duration-daf6@gregkh>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.37; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 2 Apr 2023 16:55:01 +0200
Greg KH <gregkh@linuxfoundation.org> wrote:

> You just now broke any normal user programs that required this (or the
> other ioctls), and so you are going to have to force them to be run
> with CAP_SYS_ADMIN permissions?=20

Are you aware of such normal user programs?
It was my impression that this is a relatively obscure feature and gpm
is pretty much the only tool using it.

> And you didn't change anything for programs like gpm that already had
> root permission (and shouldn't that permission be dropped anyway?)

Well, you could restrict all that to a specific capability. However, it
is my understanding that the existing capability system is limited in
the number of capabilities and new ones should only be introduced in
rare cases. It does not seem a feature probably few people use anyway
deserves a new capability.

Do you have other proposals how to fix this issue? One could introduce
an option like for TIOCSTI that allows disabling selection features by
default.


--=20
Hanno B=C3=B6ck
https://hboeck.de/
