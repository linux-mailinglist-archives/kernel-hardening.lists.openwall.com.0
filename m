Return-Path: <kernel-hardening-return-21564-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by mail.lfdr.de (Postfix) with SMTP id 6832C55F425
	for <lists+kernel-hardening@lfdr.de>; Wed, 29 Jun 2022 05:29:39 +0200 (CEST)
Received: (qmail 24417 invoked by uid 550); 29 Jun 2022 03:29:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 24382 invoked from network); 29 Jun 2022 03:29:27 -0000
From: "GONG, Ruiqi" <gongruiqi1@huawei.com>
To: Kees Cook <keescook@chromium.org>, Marco Elver <elver@google.com>
CC: Christophe Leroy <christophe.leroy@csgroup.eu>, Xiu Jianfeng
	<xiujianfeng@huawei.com>, <kernel-hardening@lists.openwall.com>,
	<linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>, Gong Ruiqi
	<gongruiqi1@huawei.com>
Subject: [PATCH] stack: Declare {randomize_,}kstack_offset to fix Sparse warnings
Date: Wed, 29 Jun 2022 11:29:39 +0800
Message-ID: <20220629032939.2506773-1-gongruiqi1@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.174.33]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500016.china.huawei.com (7.185.36.25)
X-CFilter-Loop: Reflected

Fix the following Sparse warnings that got noticed when the PPC-dev
patchwork was checking another patch (see the link below):

init/main.c:862:1: warning: symbol 'randomize_kstack_offset' was not declared. Should it be static?
init/main.c:864:1: warning: symbol 'kstack_offset' was not declared. Should it be static?

Which in fact are triggered on all architectures that have
HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET support (for instances x86, arm64
etc).

Link: https://lore.kernel.org/lkml/e7b0d68b-914d-7283-827c-101988923929@huawei.com/T/#m49b2d4490121445ce4bf7653500aba59eefcb67f
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Xiu Jianfeng <xiujianfeng@huawei.com>
Signed-off-by: GONG, Ruiqi <gongruiqi1@huawei.com>
---
 init/main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/init/main.c b/init/main.c
index e2490387db2b..6aa0fb2340cc 100644
--- a/init/main.c
+++ b/init/main.c
@@ -101,6 +101,10 @@
 #include <linux/stackdepot.h>
 #include <net/net_namespace.h>
 
+#ifdef CONFIG_RANDOMIZE_KSTACK_OFFSET
+#include <linux/randomize_kstack.h>
+#endif
+
 #include <asm/io.h>
 #include <asm/bugs.h>
 #include <asm/setup.h>
-- 
2.25.1

