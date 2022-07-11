Return-Path: <kernel-hardening-return-21566-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by mail.lfdr.de (Postfix) with SMTP id 3C90955F5FC
	for <lists+kernel-hardening@lfdr.de>; Wed, 29 Jun 2022 08:05:42 +0200 (CEST)
Received: (qmail 22099 invoked by uid 550); 29 Jun 2022 06:05:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 22055 invoked from network); 29 Jun 2022 06:05:32 -0000
From: "GONG, Ruiqi" <gongruiqi1@huawei.com>
To: Kees Cook <keescook@chromium.org>, Marco Elver <elver@google.com>
CC: Christophe Leroy <christophe.leroy@csgroup.eu>, Xiu Jianfeng
	<xiujianfeng@huawei.com>, <kernel-hardening@lists.openwall.com>,
	<linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>, Gong Ruiqi
	<gongruiqi1@huawei.com>
Subject: [PATCH v2] stack: Declare {randomize_,}kstack_offset to fix Sparse warnings
Date: Wed, 29 Jun 2022 14:04:23 +0800
Message-ID: <20220629060423.2515693-1-gongruiqi1@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.174.33]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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

v2: remove unnecessary #ifdef around the header

 init/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/init/main.c b/init/main.c
index e2490387db2b..eb9bf7c5b28b 100644
--- a/init/main.c
+++ b/init/main.c
@@ -99,6 +99,7 @@
 #include <linux/kcsan.h>
 #include <linux/init_syscalls.h>
 #include <linux/stackdepot.h>
+#include <linux/randomize_kstack.h>
 #include <net/net_namespace.h>
 
 #include <asm/io.h>
-- 
2.25.1

