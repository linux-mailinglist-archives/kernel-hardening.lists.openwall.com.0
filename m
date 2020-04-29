Return-Path: <kernel-hardening-return-18672-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id B2B4E1BD209
	for <lists+kernel-hardening@lfdr.de>; Wed, 29 Apr 2020 04:05:04 +0200 (CEST)
Received: (qmail 17898 invoked by uid 550); 29 Apr 2020 02:04:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 17766 invoked from network); 29 Apr 2020 02:04:27 -0000
From: "Christopher M. Riedl" <cmr@informatik.wtf>
To: linuxppc-dev@lists.ozlabs.org,
	kernel-hardening@lists.openwall.com
Subject: [RFC PATCH v2 4/5] powerpc/lib: Add LKDTM accessor for patching addr
Date: Tue, 28 Apr 2020 21:05:30 -0500
Message-Id: <20200429020531.20684-5-cmr@informatik.wtf>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200429020531.20684-1-cmr@informatik.wtf>
References: <20200429020531.20684-1-cmr@informatik.wtf>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP

When live patching a STRICT_RWX kernel, a mapping is installed at a
"patching address" with temporary write permissions. Provide a
LKDTM-only accessor function for this address in preparation for a LKDTM
test which attempts to "hijack" this mapping by writing to it from
another CPU.

Signed-off-by: Christopher M. Riedl <cmr@informatik.wtf>
---
 arch/powerpc/lib/code-patching.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/powerpc/lib/code-patching.c b/arch/powerpc/lib/code-patching.c
index 26f06cdb5d7e..cfbdef90384e 100644
--- a/arch/powerpc/lib/code-patching.c
+++ b/arch/powerpc/lib/code-patching.c
@@ -46,6 +46,13 @@ int raw_patch_instruction(unsigned int *addr, unsigned int instr)
 static struct mm_struct *patching_mm __ro_after_init;
 static unsigned long patching_addr __ro_after_init;
 
+#ifdef CONFIG_LKDTM
+unsigned long read_cpu_patching_addr(unsigned int cpu)
+{
+	return patching_addr;
+}
+#endif
+
 void __init poking_init(void)
 {
 	spinlock_t *ptl; /* for protecting pte table */
-- 
2.26.1

