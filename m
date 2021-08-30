Return-Path: <kernel-hardening-return-21353-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 2CB513FBFA9
	for <lists+kernel-hardening@lfdr.de>; Tue, 31 Aug 2021 02:01:03 +0200 (CEST)
Received: (qmail 5966 invoked by uid 550); 31 Aug 2021 00:00:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 5856 invoked from network); 31 Aug 2021 00:00:18 -0000
X-IronPort-AV: E=McAfee;i="6200,9189,10092"; a="197933723"
X-IronPort-AV: E=Sophos;i="5.84,364,1620716400"; 
   d="scan'208";a="197933723"
X-IronPort-AV: E=Sophos;i="5.84,364,1620716400"; 
   d="scan'208";a="530712916"
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
Subject: [RFC PATCH v2 10/19] x86/mm: Use alloc_table() for fill_pte(), etc
Date: Mon, 30 Aug 2021 16:59:18 -0700
Message-Id: <20210830235927.6443-11-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210830235927.6443-1-rick.p.edgecombe@intel.com>
References: <20210830235927.6443-1-rick.p.edgecombe@intel.com>

fill_pte(), set_pte_vaddr(), etc allocate page tables with
spp_getpage(). Use alloc_table() for these allocations in order to get
tables from the cache of protected pages when needed.

Opportunistically, fix a stale comment.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/mm/init_64.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 3c0323ad99da..de5a785ee89f 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -220,16 +220,19 @@ static void sync_global_pgds(unsigned long start, unsigned long end)
 
 /*
  * NOTE: This function is marked __ref because it calls __init function
- * (alloc_bootmem_pages). It's safe to do it ONLY when after_bootmem == 0.
+ * (memblock_alloc). It's safe to do it ONLY when after_bootmem == 0.
  */
 static __ref void *spp_getpage(void)
 {
 	void *ptr;
 
-	if (after_bootmem)
-		ptr = (void *) get_zeroed_page(GFP_ATOMIC);
-	else
+	if (after_bootmem) {
+		struct page *page = alloc_table(GFP_ATOMIC | __GFP_ZERO);
+
+		ptr = page ? page_address(page) : NULL;
+	} else {
 		ptr = memblock_alloc(PAGE_SIZE, PAGE_SIZE);
+	}
 
 	if (!ptr || ((unsigned long)ptr & ~PAGE_MASK)) {
 		panic("set_pte_phys: cannot allocate page data %s\n",
-- 
2.17.1

