Return-Path: <kernel-hardening-return-20674-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id E6F2D2FF37D
	for <lists+kernel-hardening@lfdr.de>; Thu, 21 Jan 2021 19:47:48 +0100 (CET)
Received: (qmail 19765 invoked by uid 550); 21 Jan 2021 18:47:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 17431 invoked from network); 21 Jan 2021 18:46:14 -0000
Date: Thu, 21 Jan 2021 18:45:55 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
	t=1611254762; bh=1Awk2X9LSHOQQZek4o1ELWbmO0BY+pTltTaN3f2WBw4=;
	h=Date:To:From:Cc:Reply-To:Subject:From;
	b=CrQodZ1xZM2FLIl9dUu8OGQbAxk8pFD5PDH+MeGcVSm7yNrjJgMYceYpJ4DtZ6Sz9
	 G/sT2qYGM4zcgSHo9UI6KRunrCt2lTG0vIvGYhsz9kz4rNQgA4Ezy7jbPUVTNIcVJL
	 f6IRqw8gtdbvMnVWdzcFu1tb0zBq5sC+tjaJTl8RpxB5H9BAOGuxyp8vDr83yRf18S
	 HymS15rUgb8k/enkIRmNlOLFHj/PGIhv7Xf2pJrkpU55bodYBCL52/62XlNDcz9v/P
	 fg25BXyyT2dj95PJUi7CWskvbskXafSVA27y9dZV8ER7go6NBgPOxEdr4deCWYFAdG
	 Tb+Pk1nLNANug==
To: Kees Cook <keescook@chromium.org>
From: Alexander Lobakin <alobakin@pm.me>
Cc: Sami Tolvanen <samitolvanen@google.com>, Masahiro Yamada <masahiroy@kernel.org>, Michal Marek <michal.lkml@markovi.net>, Alexander Lobakin <alobakin@pm.me>, kernel-hardening@lists.openwall.com, linux-hardening@vger.kernel.org, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH kspp-next] kbuild: prevent CC_FLAGS_LTO self-bloating on recursive rebuilds
Message-ID: <20210121184544.659998-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
	autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
	mailout.protonmail.ch

CC_FLAGS_LTO gets initialized only via +=3D, never with :=3D or =3D.
When building with CONFIG_TRIM_UNUSED_KSYMS, Kbuild may perform
several kernel rebuilds to satisfy symbol dependencies. In this
case, value of CC_FLAGS_LTO is concatenated each time, which
triggers a full rebuild.
Initialize it with :=3D to fix this.

Fixes: dc5723b02e52 ("kbuild: add support for Clang LTO")
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 668909e7a460..2233951666f7 100644
--- a/Makefile
+++ b/Makefile
@@ -895,10 +895,10 @@ endif
=20
 ifdef CONFIG_LTO_CLANG
 ifdef CONFIG_LTO_CLANG_THIN
-CC_FLAGS_LTO=09+=3D -flto=3Dthin -fsplit-lto-unit
+CC_FLAGS_LTO=09:=3D -flto=3Dthin -fsplit-lto-unit
 KBUILD_LDFLAGS=09+=3D --thinlto-cache-dir=3D$(extmod-prefix).thinlto-cache
 else
-CC_FLAGS_LTO=09+=3D -flto
+CC_FLAGS_LTO=09:=3D -flto
 endif
 CC_FLAGS_LTO=09+=3D -fvisibility=3Dhidden
=20
--=20
2.30.0


