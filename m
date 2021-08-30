Return-Path: <kernel-hardening-return-21362-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 72C203FBFB3
	for <lists+kernel-hardening@lfdr.de>; Tue, 31 Aug 2021 02:02:40 +0200 (CEST)
Received: (qmail 7552 invoked by uid 550); 31 Aug 2021 00:00:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 7345 invoked from network); 31 Aug 2021 00:00:31 -0000
X-IronPort-AV: E=McAfee;i="6200,9189,10092"; a="197933729"
X-IronPort-AV: E=Sophos;i="5.84,364,1620716400"; 
   d="scan'208";a="197933729"
X-IronPort-AV: E=Sophos;i="5.84,364,1620716400"; 
   d="scan'208";a="530712959"
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: dave.hansen@intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	x86@kernel.org,
	akpm@linux-foundation.org,
	keescook@chromium.org,
	shakeelb@google.com,
	vbabka@suse.cz,
	rppt@kernel.org
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>,
	linux-mm@kvack.org,
	linux-hardening@vger.kernel.org,
	kernel-hardening@lists.openwall.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 13/19] mm/debug_vm_page_table: Use setters instead of WRITE_ONCE
Date: Mon, 30 Aug 2021 16:59:21 -0700
Message-Id: <20210830235927.6443-14-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210830235927.6443-1-rick.p.edgecombe@intel.com>
References: <20210830235927.6443-1-rick.p.edgecombe@intel.com>

Currently debug_vm_page_table uses some raw WRITE_ONCE invocations to
write to page tables, which PKS tables is designed to prevent. So use the
set_p**() helpers instead of WRITE_ONCE for x86, so debug_vm_page_table
will work with PKS tables enabled.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 mm/debug_vm_pgtable.c | 36 +++++++++++++++++++++++++++++++++---
 1 file changed, 33 insertions(+), 3 deletions(-)

diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
index 1c922691aa61..a0b8859ecf04 100644
--- a/mm/debug_vm_pgtable.c
+++ b/mm/debug_vm_pgtable.c
@@ -411,11 +411,17 @@ static void __init pmd_huge_tests(pmd_t *pmdp, unsigned long pfn, pgprot_t prot)
 		return;
 
 	pr_debug("Validating PMD huge\n");
+
+#ifdef CONFIG_X86
+	/* Use setter so that protections can be toggled if needed */
+	set_pmd(pmdp, __pmd(0));
+#else
+	WRITE_ONCE(*pmdp, __pmd(0));
+#endif
 	/*
 	 * X86 defined pmd_set_huge() verifies that the given
 	 * PMD is not a populated non-leaf entry.
 	 */
-	WRITE_ONCE(*pmdp, __pmd(0));
 	WARN_ON(!pmd_set_huge(pmdp, __pfn_to_phys(pfn), prot));
 	WARN_ON(!pmd_clear_huge(pmdp));
 	pmd = READ_ONCE(*pmdp);
@@ -430,11 +436,16 @@ static void __init pud_huge_tests(pud_t *pudp, unsigned long pfn, pgprot_t prot)
 		return;
 
 	pr_debug("Validating PUD huge\n");
+#ifdef CONFIG_X86
+	/* Use setter so that protections can be toggled if needed */
+	set_pud(pudp, __pud(0));
+#else
+	WRITE_ONCE(*pudp, __pud(0));
+#endif
 	/*
 	 * X86 defined pud_set_huge() verifies that the given
 	 * PUD is not a populated non-leaf entry.
 	 */
-	WRITE_ONCE(*pudp, __pud(0));
 	WARN_ON(!pud_set_huge(pudp, __pfn_to_phys(pfn), prot));
 	WARN_ON(!pud_clear_huge(pudp));
 	pud = READ_ONCE(*pudp);
@@ -473,7 +484,12 @@ static void __init pud_clear_tests(struct mm_struct *mm, pud_t *pudp)
 
 	pr_debug("Validating PUD clear\n");
 	pud = __pud(pud_val(pud) | RANDOM_ORVALUE);
+#ifdef CONFIG_X86
+	/* Use setter so that protections can be toggled if needed */
+	set_pud(pudp, pud);
+#else
 	WRITE_ONCE(*pudp, pud);
+#endif
 	pud_clear(pudp);
 	pud = READ_ONCE(*pudp);
 	WARN_ON(!pud_none(pud));
@@ -514,7 +530,12 @@ static void __init p4d_clear_tests(struct mm_struct *mm, p4d_t *p4dp)
 
 	pr_debug("Validating P4D clear\n");
 	p4d = __p4d(p4d_val(p4d) | RANDOM_ORVALUE);
+#ifdef CONFIG_X86
+	/* Use setter so that protections can be toggled if needed */
+	set_p4d(p4dp, p4d);
+#else
 	WRITE_ONCE(*p4dp, p4d);
+#endif
 	p4d_clear(p4dp);
 	p4d = READ_ONCE(*p4dp);
 	WARN_ON(!p4d_none(p4d));
@@ -549,7 +570,12 @@ static void __init pgd_clear_tests(struct mm_struct *mm, pgd_t *pgdp)
 
 	pr_debug("Validating PGD clear\n");
 	pgd = __pgd(pgd_val(pgd) | RANDOM_ORVALUE);
+#ifdef CONFIG_X86
+	/* Use setter so that protections can be toggled if needed */
+	set_pgd(pgdp, pgd);
+#else
 	WRITE_ONCE(*pgdp, pgd);
+#endif
 	pgd_clear(pgdp);
 	pgd = READ_ONCE(*pgdp);
 	WARN_ON(!pgd_none(pgd));
@@ -610,8 +636,12 @@ static void __init pmd_clear_tests(struct mm_struct *mm, pmd_t *pmdp)
 
 	pr_debug("Validating PMD clear\n");
 	pmd = __pmd(pmd_val(pmd) | RANDOM_ORVALUE);
-	WRITE_ONCE(*pmdp, pmd);
+#ifdef CONFIG_X86
+	/* Use setter so that protections can be toggled if needed */
 	pmd_clear(pmdp);
+#else
+	WRITE_ONCE(*pmdp, pmd);
+#endif
 	pmd = READ_ONCE(*pmdp);
 	WARN_ON(!pmd_none(pmd));
 }
-- 
2.17.1

