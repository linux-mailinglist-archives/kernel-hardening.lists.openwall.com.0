Return-Path: <kernel-hardening-return-16871-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 02D16AC4DC
	for <lists+kernel-hardening@lfdr.de>; Sat,  7 Sep 2019 08:08:39 +0200 (CEST)
Received: (qmail 12240 invoked by uid 550); 7 Sep 2019 06:08:17 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 12002 invoked from network); 7 Sep 2019 06:08:15 -0000
From: "Christopher M. Riedl" <cmr@informatik.wtf>
To: linuxppc-dev@ozlabs.org,
	kernel-hardening@lists.openwall.com
Cc: ajd@linux.ibm.com,
	dja@axtens.net
Subject: [PATCH v7 1/2] powerpc/xmon: Allow listing and clearing breakpoints in read-only mode
Date: Sat,  7 Sep 2019 01:11:23 -0500
Message-Id: <20190907061124.1947-2-cmr@informatik.wtf>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190907061124.1947-1-cmr@informatik.wtf>
References: <20190907061124.1947-1-cmr@informatik.wtf>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP

Read-only mode should not prevent listing and clearing any active
breakpoints.

Tested-by: Daniel Axtens <dja@axtens.net>
Reviewed-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: Christopher M. Riedl <cmr@informatik.wtf>
---
 arch/powerpc/xmon/xmon.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/xmon/xmon.c b/arch/powerpc/xmon/xmon.c
index d0620d762a5a..ed94de614938 100644
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
@@ -1407,7 +1412,8 @@ bpt_cmds(void)
 			break;
 		}
 		termch = cmd;
-		if (!scanhex(&a)) {
+
+		if (xmon_is_ro || !scanhex(&a)) {
 			/* print all breakpoints */
 			printf("   type            address\n");
 			if (dabr.enabled) {
-- 
2.23.0

