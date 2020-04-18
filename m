Return-Path: <kernel-hardening-return-18548-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 3CB591AEA31
	for <lists+kernel-hardening@lfdr.de>; Sat, 18 Apr 2020 08:39:10 +0200 (CEST)
Received: (qmail 17993 invoked by uid 550); 18 Apr 2020 06:39:02 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 17955 invoked from network); 18 Apr 2020 06:39:01 -0000
From: Jason Yan <yanaijie@huawei.com>
To: <keescook@chromium.org>, <re.emese@gmail.com>,
	<kernel-hardening@lists.openwall.com>, <linux-kernel@vger.kernel.org>
CC: Jason Yan <yanaijie@huawei.com>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH] gcc-plugins: structleak: remove unneeded variable 'ret'
Date: Sat, 18 Apr 2020 15:05:05 +0800
Message-ID: <20200418070505.10715-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected

Fix the following coccicheck warning:

scripts/gcc-plugins/structleak_plugin.c:177:14-17: Unneeded variable:
"ret". Return "0" on line 207

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 scripts/gcc-plugins/structleak_plugin.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/scripts/gcc-plugins/structleak_plugin.c b/scripts/gcc-plugins/structleak_plugin.c
index e89be8f5c859..fdff6278eda0 100644
--- a/scripts/gcc-plugins/structleak_plugin.c
+++ b/scripts/gcc-plugins/structleak_plugin.c
@@ -174,7 +174,6 @@ static void initialize(tree var)
 static unsigned int structleak_execute(void)
 {
 	basic_block bb;
-	unsigned int ret = 0;
 	tree var;
 	unsigned int i;
 
@@ -204,7 +203,7 @@ static unsigned int structleak_execute(void)
 			initialize(var);
 	}
 
-	return ret;
+	return 0;
 }
 
 #define PASS_NAME structleak
-- 
2.21.1

