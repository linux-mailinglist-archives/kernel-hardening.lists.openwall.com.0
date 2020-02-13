Return-Path: <kernel-hardening-return-17813-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 80EBB15BFA6
	for <lists+kernel-hardening@lfdr.de>; Thu, 13 Feb 2020 14:46:19 +0100 (CET)
Received: (qmail 9636 invoked by uid 550); 13 Feb 2020 13:46:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 1261 invoked from network); 13 Feb 2020 12:25:06 -0000
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-11.nifty.com 01DCOMZL025517
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
	s=dec2015msa; t=1581596663;
	bh=rQmwN5cWJQbpc39YRPGbcHf4QKGfkTR21bK6Myswez8=;
	h=From:To:Cc:Subject:Date:From;
	b=HXJyoP3VfUiao9FilYZL3qHAzts0YcWEhCCsDPGxxwzSPQH98PDUWQO6i0fNiYrbd
	 Z9Co1RiXOl+L/FCDZl/3h4SI2TjNtLR1ZfOMZs5eV6p1PAsOQXS6VjAAxGK+A2HrjR
	 OrUtetibC6LyhIHylAhb9MAa8OAqU++C+5cN43jwNxigYj76gU0FHRLO3XMcndzqNq
	 dw7b4D7m7FMxHdXoKYjy4Rav2jIrtjqizGUoSB8ZnUQHdhkW9+anG8hP1GDQKYH5es
	 So972K1R8HDBwyW5iNdvsFr8Oz9EZlfeA/9JKjALTdqJ+xwaZr627LgehFrrTgXG8s
	 Z+EY4LSWXSqBg==
X-Nifty-SrcIP: [153.142.97.92]
From: Masahiro Yamada <masahiroy@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Emese Revfy <re.emese@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Michal Marek <michal.lkml@markovi.net>,
        kernel-hardening@lists.openwall.com, linux-doc@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] gcc-plugins: fix gcc-plugins directory path in documentation
Date: Thu, 13 Feb 2020 21:24:10 +0900
Message-Id: <20200213122410.1605-1-masahiroy@kernel.org>
X-Mailer: git-send-email 2.17.1

Fix typos "plgins" -> "plugins".

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
---

 Documentation/kbuild/reproducible-builds.rst | 2 +-
 scripts/gcc-plugins/Kconfig                  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/kbuild/reproducible-builds.rst b/Documentation/kbuild/reproducible-builds.rst
index 503393854e2e..3b25655e441b 100644
--- a/Documentation/kbuild/reproducible-builds.rst
+++ b/Documentation/kbuild/reproducible-builds.rst
@@ -101,7 +101,7 @@ Structure randomisation
 
 If you enable ``CONFIG_GCC_PLUGIN_RANDSTRUCT``, you will need to
 pre-generate the random seed in
-``scripts/gcc-plgins/randomize_layout_seed.h`` so the same value
+``scripts/gcc-plugins/randomize_layout_seed.h`` so the same value
 is used in rebuilds.
 
 Debug info conflicts
diff --git a/scripts/gcc-plugins/Kconfig b/scripts/gcc-plugins/Kconfig
index e3569543bdac..7b63c819610c 100644
--- a/scripts/gcc-plugins/Kconfig
+++ b/scripts/gcc-plugins/Kconfig
@@ -86,7 +86,7 @@ config GCC_PLUGIN_RANDSTRUCT
 	  source tree isn't cleaned after kernel installation).
 
 	  The seed used for compilation is located at
-	  scripts/gcc-plgins/randomize_layout_seed.h.  It remains after
+	  scripts/gcc-plugins/randomize_layout_seed.h.  It remains after
 	  a make clean to allow for external modules to be compiled with
 	  the existing seed and will be removed by a make mrproper or
 	  make distclean.
-- 
2.17.1

