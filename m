Return-Path: <kernel-hardening-return-18408-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 1D2DF19D31D
	for <lists+kernel-hardening@lfdr.de>; Fri,  3 Apr 2020 11:07:31 +0200 (CEST)
Received: (qmail 5972 invoked by uid 550); 3 Apr 2020 09:07:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 21738 invoked from network); 3 Apr 2020 05:29:51 -0000
From: =?utf-8?q?joao=40overdrivepizza=2Ecom?= <joao@overdrivepizza.com>
Content-Type: text/plain; charset="utf-8"
X-Forward: 127.0.0.1
Date: Fri, 03 Apr 2020 07:29:38 +0200
Cc: keescook@chromium.org, vasileios_kemerlis@brown.edu, sandro@ic.unicamp.br
To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Message-ID: <3446-5e86ca00-7-77f96080@18228891>
Subject: kCFI sources
User-Agent: SOGoMail 4.3.0
Content-Transfer-Encoding: quoted-printable

Hi,

FWIW, In case someone has any interest in looking into it, a month ago =
I uploaded the old sources for a kernel CFI prototype I implemented bac=
k in 2015/2016 (kCFI) here: https://github.com/kcfi/kcfi

As is, the code supports kernel 3.19. It is no longer maintained and, g=
iven that the upstream Linux kernel may have its own CFI scheme somewha=
t soon, I don't believe that there is much sense in trying to forward-p=
ort it or anything. Either way, if it is useful for anyone, there you g=
o.

Cheers,
Joao.

