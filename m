Return-Path: <kernel-hardening-return-18423-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id B5AE919E498
	for <lists+kernel-hardening@lfdr.de>; Sat,  4 Apr 2020 12:40:40 +0200 (CEST)
Received: (qmail 9229 invoked by uid 550); 4 Apr 2020 10:40:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 30157 invoked from network); 4 Apr 2020 01:28:28 -0000
From: =?utf-8?q?joao=40overdrivepizza=2Ecom?= <joao@overdrivepizza.com>
In-Reply-To: <202004031626.B2FDF354@keescook>
Content-Type: text/plain; charset="utf-8"
X-Forward: 127.0.0.1
Date: Sat, 04 Apr 2020 03:28:15 +0200
Cc: kernel-hardening@lists.openwall.com, vasileios_kemerlis@brown.edu, sandro@ic.unicamp.br
To: "Kees Cook" <keescook@chromium.org>
MIME-Version: 1.0
Message-ID: <df8-5e87e280-b3-1e9bdee0@78115022>
Subject: =?utf-8?q?Re=3A?= kCFI sources
User-Agent: SOGoMail 4.3.0
Content-Transfer-Encoding: quoted-printable

> Weren't there updates make to LLVM to provide a more fine-grained
> bucketization of the function prototypes? (i.e. instead of all "void
> func(void)" being in one bucket, they got chopped into more buckets?)=


The optimization we put in place (Call Graph Detaching) in the shared s=
ources has a slightly different goal. It uses both source-level and bin=
ary-level information  (not only changes in llvm) to identify which fun=
ctions belonging to a prototype group are callable both directly and in=
directly (they have a matching function pointer and a direct call); the=
n it clones these functions and replace the direct call to them with a =
direct call to the clone. By doing so, it allows the function to have a=
 different tag to be checked on return in each of its versions, detachi=
ng the instances of the function invocation from the prototype group. T=
his reduces the the number of allowed return targets of the cloned func=
tions to the actual number of direct calls to it, instead of the number=
 of indirect and direct calls to the whole prototype group. This is act=
ually a backward-edge granularity optimization.

For examples, see slides 28-33: https://www.blackhat.com/docs/asia-17/m=
aterials/asia-17-Moreira-Drop-The-Rop-Fine-Grained-Control-Flow-Integri=
ty-For-The-Linux-Kernel.pdf

