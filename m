Return-Path: <kernel-hardening-return-18912-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id D733E1EC8AA
	for <lists+kernel-hardening@lfdr.de>; Wed,  3 Jun 2020 07:18:35 +0200 (CEST)
Received: (qmail 30046 invoked by uid 550); 3 Jun 2020 05:17:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 29949 invoked from network); 3 Jun 2020 05:17:54 -0000
From: "Christopher M. Riedl" <cmr@informatik.wtf>
To: linuxppc-dev@lists.ozlabs.org,
	kernel-hardening@lists.openwall.com
Subject: [PATCH 4/5] powerpc/lib: Add LKDTM accessor for patching addr
Date: Wed,  3 Jun 2020 00:19:11 -0500
Message-Id: <20200603051912.23296-5-cmr@informatik.wtf>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200603051912.23296-1-cmr@informatik.wtf>
References: <20200603051912.23296-1-cmr@informatik.wtf>
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
index df0765845204..c23453049116 100644
--- a/arch/powerpc/lib/code-patching.c
+++ b/arch/powerpc/lib/code-patching.c
@@ -52,6 +52,13 @@ int raw_patch_instruction(struct ppc_inst *addr, struct ppc_inst instr)
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
2.26.2

