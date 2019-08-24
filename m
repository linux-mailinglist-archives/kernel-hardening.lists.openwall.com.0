Return-Path: <kernel-hardening-return-16803-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id D9E009BEA6
	for <lists+kernel-hardening@lfdr.de>; Sat, 24 Aug 2019 17:43:45 +0200 (CEST)
Received: (qmail 15497 invoked by uid 550); 24 Aug 2019 15:43:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 5888 invoked from network); 24 Aug 2019 15:31:16 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1566660664;
	bh=w3QHDnO4t6DArQfKiVUGUZ2ReXOLSwfgei12ZqKuUtc=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
	b=JphlNMXP032vbZsSw+MBeNxK8wuMVj5Ze0m4Au4vnOgwq52R+BzKAJIv4U8ZQ9M88
	 JsaFbdvrPryKO2U7C2SVniQ2zewj+/DVvimtFaiguP84M93JJGAi6ofSEq16d1/Drc
	 m9i4nTFNJhOqFX/VzPAx/izvPqdjDiGy1q3FfsOM=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
From: Alex Dewar <alex.dewar@gmx.co.uk>
To: keescook@chromium.org,
	re.emese@gmail.com
Cc: kernel-hardening@lists.openwall.com,
	linux-kernel@vger.kernel.org,
	Alex Dewar <alex.dewar@gmx.co.uk>
Subject: [PATCH RESEND v3] scripts/gcc-plugins: Add SPDX header for files without
Date: Sat, 24 Aug 2019 16:30:37 +0100
Message-Id: <20190824153036.21394-1-alex.dewar@gmx.co.uk>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
X-Provags-ID: V03:K1:+OeUbvhP6ghkuw/Cz1TmzatsnmeDKLWUJEHR5WtzX3qB17nmbZu
 e5J7vHxXlZFrpBpUxLDzqHix10YbaNTs0R3KLXZLd5D9U3uxSF8feScWTy7dSWFaRTH1nc1
 921Ye4wfm2mG3bRR5yEBfyJ+Py2/QkoxNlz7dshKs6ZLWJVKGxNgcgTgs1ZyCx6brxwtqop
 6K2se7DJ1n+5lYjwUioeA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:g5OQ1OMXWI8=:+GU8VXMIyalyZjpyHJc5fG
 4TNfuTUm3ewwR6/tJoNCW6GrW+Wk3wSuuWBwOFVj60GNWsygiXj4Xx8GVawWJPkY7r7WLeFTN
 6aymTdGGytAKpEB6aQDpHOU1muslj3BzYFcSnLK2cAPJnRKNXr+G44S9BRSmk34R8bDEWcaXE
 exD7+ZRJ5K7SpkLAULNfP3l1gR0e0BRlOXSxbuWLz6soboaeJVNW5Ts89gSzPZ5LB6dDouj11
 Sugml3cZG2TjqB2p6Vxk904uZlCxp/aXyZfVpdDXIFpdi9rU8jwhC2dFVmeyiQLdUecRErOyf
 eixyBCkmnt/IBRCzfXkKOdEdBjOYeaiCqs5CWQ4+DdgDeN7Tt4NbQY5+ikXFYgmVBfSiTxcif
 NYHcpcBubMuvwTFaLh6yME/yo4QtGfBmddjQ3NyIR5ka4KZrkawKfirhMOEJk7ObxrRJ1xzM+
 O0brxOqIkJGPZmRBoxwmUE/yin59RGs1krkvg5x0Tn1xdYVgOTiCMqXRkScbB7RrqHcBMEGtp
 iaoWmqKlrwI7v/IaOXYT9l0Z8/M4m+p0UmtiFpcImdkxZdWCnf4FJvNztf3uJmjE1gUKtPTnH
 2z03q2WKP2Xe1WG7FwWGgIrxoYFXoqAmZ7cHd4lHtnDxJgao0kddxfFyFTrdoHO7S5Bv1fVQO
 rnoCko+EXQtTA3pJfbEzKGMhhLdMWwCRmN6k3JSkaoLdmd0lKvyNF/6wb0z/BX5b1s9f/otVt
 +HCH1GTH+i61scY2m4eopmTjWlTul2dJTYtHpwfGdrVzoX3kaen/N/QntEbhLYNpoW7CPOK3r
 iMv2vnloB+nL2w8XSsFbTh7AH6KssvDcR/sX2D3Bnqtz88nXk6B8P0tigxbQ5Qm9ZZT9IaZzz
 mJRPyzreHYpjpxZZTJCgub0PFRlRnLxE+OhLQKvkuZioFlxGysKzpHUnYI+8vfI0tQ97Eovou
 WhwdqnvstXSYthSWD01Lc39zwJoA+qNu8DPjgr764XfwBrLHRoo/GoK58dt989oJH9RtAmVcX
 N+MtoemTt2F5VyzFSNHSBdhajOy+QRYLaOoKUptRlv2HjeqwM9jMiBEk1l0p7bE5Z94/6aOOf
 CXATsF+NXodWKupoN9MLjAoRdex9leEBmfaE7oeA22nC14i9t6eu3G+Kg==

Replace boilerplate with approproate SPDX header. Vim also auto-trimmed
whitespace from one line.

Ignore the previous emails. I'm still trying to get the hang of the
tools. Really sorry!

Signed-off-by: Alex Dewar <alex.dewar@gmx.co.uk>
---
 scripts/gcc-plugins/cyc_complexity_plugin.c   | 2 +-
 scripts/gcc-plugins/latent_entropy_plugin.c   | 2 +-
 scripts/gcc-plugins/randomize_layout_plugin.c | 4 ++--
 scripts/gcc-plugins/sancov_plugin.c           | 2 +-
 scripts/gcc-plugins/stackleak_plugin.c        | 2 +-
 scripts/gcc-plugins/structleak_plugin.c       | 2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/scripts/gcc-plugins/cyc_complexity_plugin.c b/scripts/gcc-plugins/cyc_complexity_plugin.c
index 1909ec617431..870266f36b5c 100644
--- a/scripts/gcc-plugins/cyc_complexity_plugin.c
+++ b/scripts/gcc-plugins/cyc_complexity_plugin.c
@@ -1,6 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright 2011-2016 by Emese Revfy <re.emese@gmail.com>
- * Licensed under the GPL v2, or (at your option) v3
  *
  * Homepage:
  * https://github.com/ephox-gcc-plugins/cyclomatic_complexity
diff --git a/scripts/gcc-plugins/latent_entropy_plugin.c b/scripts/gcc-plugins/latent_entropy_plugin.c
index cbe1d6c4b1a5..c693ac27ddf1 100644
--- a/scripts/gcc-plugins/latent_entropy_plugin.c
+++ b/scripts/gcc-plugins/latent_entropy_plugin.c
@@ -1,7 +1,7 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright 2012-2016 by the PaX Team <pageexec@freemail.hu>
  * Copyright 2016 by Emese Revfy <re.emese@gmail.com>
- * Licensed under the GPL v2
  *
  * Note: the choice of the license means that the compilation process is
  *       NOT 'eligible' as defined by gcc's library exception to the GPL v3,
diff --git a/scripts/gcc-plugins/randomize_layout_plugin.c b/scripts/gcc-plugins/randomize_layout_plugin.c
index bd29e4e7a524..f46d049da26c 100644
--- a/scripts/gcc-plugins/randomize_layout_plugin.c
+++ b/scripts/gcc-plugins/randomize_layout_plugin.c
@@ -1,7 +1,7 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright 2014-2016 by Open Source Security, Inc., Brad Spengler <spender@grsecurity.net>
  *                   and PaX Team <pageexec@freemail.hu>
- * Licensed under the GPL v2
  *
  * Note: the choice of the license means that the compilation process is
  *       NOT 'eligible' as defined by gcc's library exception to the GPL v3,
@@ -909,7 +909,7 @@ static unsigned int find_bad_casts_execute(void)
 			} else {
 				const_tree ssa_name_var = SSA_NAME_VAR(rhs1);
 				/* skip bogus type casts introduced by container_of */
-				if (ssa_name_var != NULL_TREE && DECL_NAME(ssa_name_var) &&
+				if (ssa_name_var != NULL_TREE && DECL_NAME(ssa_name_var) &&
 				    !strcmp((const char *)DECL_NAME_POINTER(ssa_name_var), "__mptr"))
 					continue;
 #ifndef __DEBUG_PLUGIN
diff --git a/scripts/gcc-plugins/sancov_plugin.c b/scripts/gcc-plugins/sancov_plugin.c
index 0f98634c20a0..9845ad67a7d8 100644
--- a/scripts/gcc-plugins/sancov_plugin.c
+++ b/scripts/gcc-plugins/sancov_plugin.c
@@ -1,6 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright 2011-2016 by Emese Revfy <re.emese@gmail.com>
- * Licensed under the GPL v2, or (at your option) v3
  *
  * Homepage:
  * https://github.com/ephox-gcc-plugins/sancov
diff --git a/scripts/gcc-plugins/stackleak_plugin.c b/scripts/gcc-plugins/stackleak_plugin.c
index dbd37460c573..3abaea274651 100644
--- a/scripts/gcc-plugins/stackleak_plugin.c
+++ b/scripts/gcc-plugins/stackleak_plugin.c
@@ -1,7 +1,7 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright 2011-2017 by the PaX Team <pageexec@freemail.hu>
  * Modified by Alexander Popov <alex.popov@linux.com>
- * Licensed under the GPL v2
  *
  * Note: the choice of the license means that the compilation process is
  * NOT 'eligible' as defined by gcc's library exception to the GPL v3,
diff --git a/scripts/gcc-plugins/structleak_plugin.c b/scripts/gcc-plugins/structleak_plugin.c
index e89be8f5c859..708d21f5392b 100644
--- a/scripts/gcc-plugins/structleak_plugin.c
+++ b/scripts/gcc-plugins/structleak_plugin.c
@@ -1,6 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright 2013-2017 by PaX Team <pageexec@freemail.hu>
- * Licensed under the GPL v2
  *
  * Note: the choice of the license means that the compilation process is
  *       NOT 'eligible' as defined by gcc's library exception to the GPL v3,
--
2.23.0

