Return-Path: <kernel-hardening-return-16789-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 163D58E455
	for <lists+kernel-hardening@lfdr.de>; Thu, 15 Aug 2019 07:03:17 +0200 (CEST)
Received: (qmail 27892 invoked by uid 550); 15 Aug 2019 05:03:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 27856 invoked from network); 15 Aug 2019 05:03:05 -0000
From: "Christopher M. Riedl" <cmr@informatik.wtf>
To: linuxppc-dev@ozlabs.org,
	kernel-hardening@lists.openwall.com
Subject: [RFC PATCH v4 1/2] powerpc/xmon: Allow listing active breakpoints in read-only mode
Date: Thu, 15 Aug 2019 00:06:15 -0500
Message-Id: <20190815050616.2547-2-cmr@informatik.wtf>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190815050616.2547-1-cmr@informatik.wtf>
References: <20190815050616.2547-1-cmr@informatik.wtf>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP

Xmon can enter read-only mode dynamically due to changes in kernel
lockdown state. This transition does not clear active breakpoints and
any these breakpoints should remain visible to the xmon'er.

Signed-off-by: Christopher M. Riedl <cmr@informatik.wtf>
---
 arch/powerpc/xmon/xmon.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/xmon/xmon.c b/arch/powerpc/xmon/xmon.c
index d0620d762a5a..bb63ecc599fd 100644
--- a/arch/powerpc/xmon/xmon.c
+++ b/arch/powerpc/xmon/xmon.c
@@ -1045,10 +1045,6 @@ cmds(struct pt_regs *excp)
 			set_lpp_cmd();
 			break;
 		case 'b':
-			if (xmon_is_ro) {
-				printf(xmon_ro_msg);
-				break;
-			}
 			bpt_cmds();
 			break;
 		case 'C':
@@ -1317,11 +1313,16 @@ bpt_cmds(void)
 	struct bpt *bp;
 
 	cmd = inchar();
+
 	switch (cmd) {
 #ifndef CONFIG_PPC_8xx
 	static const char badaddr[] = "Only kernel addresses are permitted for breakpoints\n";
 	int mode;
 	case 'd':	/* bd - hardware data breakpoint */
+		if (xmon_is_ro) {
+			printf(xmon_ro_msg);
+			break;
+		}
 		if (!ppc_breakpoint_available()) {
 			printf("Hardware data breakpoint not supported on this cpu\n");
 			break;
@@ -1349,6 +1350,10 @@ bpt_cmds(void)
 		break;
 
 	case 'i':	/* bi - hardware instr breakpoint */
+		if (xmon_is_ro) {
+			printf(xmon_ro_msg);
+			break;
+		}
 		if (!cpu_has_feature(CPU_FTR_ARCH_207S)) {
 			printf("Hardware instruction breakpoint "
 			       "not supported on this cpu\n");
@@ -1372,6 +1377,10 @@ bpt_cmds(void)
 #endif
 
 	case 'c':
+		if (xmon_is_ro) {
+			printf(xmon_ro_msg);
+			break;
+		}
 		if (!scanhex(&a)) {
 			/* clear all breakpoints */
 			for (i = 0; i < NBPTS; ++i)
@@ -1407,7 +1416,7 @@ bpt_cmds(void)
 			break;
 		}
 		termch = cmd;
-		if (!scanhex(&a)) {
+		if (xmon_is_ro || !scanhex(&a)) {
 			/* print all breakpoints */
 			printf("   type            address\n");
 			if (dabr.enabled) {
-- 
2.22.0

