Return-Path: <kernel-hardening-return-18804-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id AB3AF1D3A07
	for <lists+kernel-hardening@lfdr.de>; Thu, 14 May 2020 20:54:34 +0200 (CEST)
Received: (qmail 25857 invoked by uid 550); 14 May 2020 18:54:29 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 25825 invoked from network); 14 May 2020 18:54:28 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1589482457;
	bh=vrzhGL7SuHBe2px6S5O4M+HMKDdLb8UmSBWBYruGUag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P72OhY2gIQ/qajSpIoShhel8GPCUl+1X4beML//vmJISkiK+wtVPW6/EBWT3UhGOa
	 JOhi2+X5H/5Mub57+mYp8mcO5UEOBchzSaObsPpb4hon20BAnJIZ3JM9kxVYZumZwI
	 Z2Q3Jhhb/HGRono+aU6eCm/zqvw01RlTFQIVhR58=
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Pierret=20=28fepitre=29?= <frederic.pierret@qubes-os.org>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>,
	kernel-hardening@lists.openwall.com
Subject: [PATCH AUTOSEL 4.19 02/31] gcc-common.h: Update for GCC 10
Date: Thu, 14 May 2020 14:53:44 -0400
Message-Id: <20200514185413.20755-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185413.20755-1-sashal@kernel.org>
References: <20200514185413.20755-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Frédéric Pierret (fepitre) <frederic.pierret@qubes-os.org>

[ Upstream commit c7527373fe28f97d8a196ab562db5589be0d34b9 ]

Remove "params.h" include, which has been dropped in GCC 10.

Remove is_a_helper() macro, which is now defined in gimple.h, as seen
when running './scripts/gcc-plugin.sh g++ g++ gcc':

In file included from <stdin>:1:
./gcc-plugins/gcc-common.h:852:13: error: redefinition of ‘static bool is_a_helper<T>::test(U*) [with U = const gimple; T = const ggoto*]’
  852 | inline bool is_a_helper<const ggoto *>::test(const_gimple gs)
      |             ^~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from ./gcc-plugins/gcc-common.h:125,
                 from <stdin>:1:
/usr/lib/gcc/x86_64-redhat-linux/10/plugin/include/gimple.h:1037:1: note: ‘static bool is_a_helper<T>::test(U*) [with U = const gimple; T = const ggoto*]’ previously declared here
 1037 | is_a_helper <const ggoto *>::test (const gimple *gs)
      | ^~~~~~~~~~~~~~~~~~~~~~~~~~~

Add -Wno-format-diag to scripts/gcc-plugins/Makefile to avoid
meaningless warnings from error() formats used by plugins:

scripts/gcc-plugins/structleak_plugin.c: In function ‘int plugin_init(plugin_name_args*, plugin_gcc_version*)’:
scripts/gcc-plugins/structleak_plugin.c:253:12: warning: unquoted sequence of 2 consecutive punctuation characters ‘'-’ in format [-Wformat-diag]
  253 |   error(G_("unknown option '-fplugin-arg-%s-%s'"), plugin_name, argv[i].key);
      |            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Frédéric Pierret (fepitre) <frederic.pierret@qubes-os.org>
Link: https://lore.kernel.org/r/20200407113259.270172-1-frederic.pierret@qubes-os.org
[kees: include -Wno-format-diag for plugin builds]
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/gcc-plugins/Makefile     | 1 +
 scripts/gcc-plugins/gcc-common.h | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/scripts/gcc-plugins/Makefile b/scripts/gcc-plugins/Makefile
index aa0d0ec6936d7..9e95862f27882 100644
--- a/scripts/gcc-plugins/Makefile
+++ b/scripts/gcc-plugins/Makefile
@@ -11,6 +11,7 @@ else
   HOST_EXTRACXXFLAGS += -I$(GCC_PLUGINS_DIR)/include -I$(src) -std=gnu++98 -fno-rtti
   HOST_EXTRACXXFLAGS += -fno-exceptions -fasynchronous-unwind-tables -ggdb
   HOST_EXTRACXXFLAGS += -Wno-narrowing -Wno-unused-variable
+  HOST_EXTRACXXFLAGS += -Wno-format-diag
   export HOST_EXTRACXXFLAGS
 endif
 
diff --git a/scripts/gcc-plugins/gcc-common.h b/scripts/gcc-plugins/gcc-common.h
index 17f06079a7123..9ad76b7f3f10e 100644
--- a/scripts/gcc-plugins/gcc-common.h
+++ b/scripts/gcc-plugins/gcc-common.h
@@ -35,7 +35,9 @@
 #include "ggc.h"
 #include "timevar.h"
 
+#if BUILDING_GCC_VERSION < 10000
 #include "params.h"
+#endif
 
 #if BUILDING_GCC_VERSION <= 4009
 #include "pointer-set.h"
@@ -847,6 +849,7 @@ static inline gimple gimple_build_assign_with_ops(enum tree_code subcode, tree l
 	return gimple_build_assign(lhs, subcode, op1, op2 PASS_MEM_STAT);
 }
 
+#if BUILDING_GCC_VERSION < 10000
 template <>
 template <>
 inline bool is_a_helper<const ggoto *>::test(const_gimple gs)
@@ -860,6 +863,7 @@ inline bool is_a_helper<const greturn *>::test(const_gimple gs)
 {
 	return gs->code == GIMPLE_RETURN;
 }
+#endif
 
 static inline gasm *as_a_gasm(gimple stmt)
 {
-- 
2.20.1

