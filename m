Return-Path: <kernel-hardening-return-21364-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id E482B3FBFB4
	for <lists+kernel-hardening@lfdr.de>; Tue, 31 Aug 2021 02:02:55 +0200 (CEST)
Received: (qmail 7645 invoked by uid 550); 31 Aug 2021 00:00:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 7340 invoked from network); 31 Aug 2021 00:00:31 -0000
X-IronPort-AV: E=McAfee;i="6200,9189,10092"; a="197933727"
X-IronPort-AV: E=Sophos;i="5.84,364,1620716400"; 
   d="scan'208";a="197933727"
X-IronPort-AV: E=Sophos;i="5.84,364,1620716400"; 
   d="scan'208";a="530712949"
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
Subject: [RFC PATCH v2 12/19] x86/mm: Use free_table in unmap path
Date: Mon, 30 Aug 2021 16:59:20 -0700
Message-Id: <20210830235927.6443-13-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210830235927.6443-1-rick.p.edgecombe@intel.com>
References: <20210830235927.6443-1-rick.p.edgecombe@intel.com>

Memory hot unplug and memremap unmap paths will free direct map page
tables. So use free_table() for this.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/mm/init_64.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index de5a785ee89f..c2680a77ca88 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -975,7 +975,7 @@ int arch_add_memory(int nid, u64 start, u64 size,
 	return add_pages(nid, start_pfn, nr_pages, params);
 }
 
-static void __meminit free_pagetable(struct page *page, int order)
+static void __meminit free_pagetable(struct page *page, int order, bool table)
 {
 	unsigned long magic;
 	unsigned int nr_pages = 1 << order;
@@ -991,8 +991,14 @@ static void __meminit free_pagetable(struct page *page, int order)
 		} else
 			while (nr_pages--)
 				free_reserved_page(page++);
-	} else
-		free_pages((unsigned long)page_address(page), order);
+	} else {
+		if (table) {
+			/* The page tables will always be order 0. */
+			free_table(page);
+		} else {
+			free_pages((unsigned long)page_address(page), order);
+		}
+	}
 }
 
 static void __meminit gather_table(struct page *page, struct list_head *tables)
@@ -1008,7 +1014,7 @@ static void __meminit gather_table_finish(struct list_head *tables)
 
 	list_for_each_entry_safe(page, next, tables, lru) {
 		list_del(&page->lru);
-		free_pagetable(page, 0);
+		free_pagetable(page, 0, true);
 	}
 }
 
@@ -1018,7 +1024,7 @@ static void __meminit free_hugepage_table(struct page *page,
 	if (altmap)
 		vmem_altmap_free(altmap, PMD_SIZE / PAGE_SIZE);
 	else
-		free_pagetable(page, get_order(PMD_SIZE));
+		free_pagetable(page, get_order(PMD_SIZE), false);
 }
 
 static void __meminit free_pte_table(pte_t *pte_start, pmd_t *pmd, struct list_head *tables)
@@ -1102,7 +1108,7 @@ remove_pte_table(pte_t *pte_start, unsigned long addr, unsigned long end,
 			return;
 
 		if (!direct)
-			free_pagetable(pte_page(*pte), 0);
+			free_pagetable(pte_page(*pte), 0, false);
 
 		spin_lock(&init_mm.page_table_lock);
 		pte_clear(&init_mm, addr, pte);
-- 
2.17.1

