Return-Path: <kernel-hardening-return-15854-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id D402EF5A7
	for <lists+kernel-hardening@lfdr.de>; Tue, 30 Apr 2019 13:31:24 +0200 (CEST)
Received: (qmail 21945 invoked by uid 550); 30 Apr 2019 11:30:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 28254 invoked from network); 30 Apr 2019 11:27:05 -0000
DKIM-Filter: OpenDKIM Filter v2.11.0 terminus.zytor.com x3UBPXtZ1349967
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2019041745; t=1556623535;
	bh=82fUuORZvWs0d84hDRV3pi/4iTRIRCf6F0P0TlbtuTI=;
	h=Date:From:Cc:Reply-To:In-Reply-To:References:To:Subject:From;
	b=SqfJCJrgst3Uc1lxFlJ3lxWFQuz/i8kfp2c2Hf9vxzktSiCBHrM8UeFFKYM52FbHi
	 zUwttMBpCjXjhvOz3zTApiPQ9h4TsFldteeH2Skz27qNpHcsB1fHQJVvJhISLBGtEQ
	 9Yn94Kk0UjcALPzjZQ/UwhIKL8hA2yGL89k6hioIf4oFKvRtvfLg+ZTvErYXzU1NRk
	 gz2mC21XSAgpvV3uIA1h2yOgOajh8h9Vg5GOT4rSx/9AyLfIRvI8BK/ygcTaglKlgK
	 smFwtTTb6Icu40IlPoy3gkRDi3LBxhoM2iRVzsnNI9rol0sc8QIJ8fT/4UeEc1IHAh
	 pwxa+E93eAQNQ==
Date: Tue, 30 Apr 2019 04:25:33 -0700
X-Authentication-Warning: terminus.zytor.com: tipbot set sender to tipbot@zytor.com using -f
Sender: tip tree robot <tipbot@zytor.com>
From: tip-bot for Rick Edgecombe <tipbot@zytor.com>
Message-ID: <tip-d63326928611600ad65baff54a70f53b02b3cdfe@git.kernel.org>
Cc: hpa@zytor.com, tglx@linutronix.de, linux_dti@icloud.com,
        peterz@infradead.org, rick.p.edgecombe@intel.com,
        kristen@linux.intel.com, luto@kernel.org, mingo@kernel.org,
        dave.hansen@linux.intel.com, rjw@rjwysocki.net,
        ard.biesheuvel@linaro.org, nadav.amit@gmail.com,
        akpm@linux-foundation.org, kernel-hardening@lists.openwall.com,
        bp@alien8.de, riel@surriel.com, deneen.t.dock@intel.com, pavel@ucw.cz,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        will.deacon@arm.com
In-Reply-To: <20190426001143.4983-16-namit@vmware.com>
References: <20190426001143.4983-16-namit@vmware.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] mm/hibernation: Make hibernation handle unmapped pages
Git-Commit-ID: d63326928611600ad65baff54a70f53b02b3cdfe
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from
 these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,BAYES_00,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	FREEMAIL_FORGED_REPLYTO,T_DATE_IN_FUTURE_96_Q autolearn=no
	autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on terminus.zytor.com

Commit-ID:  d63326928611600ad65baff54a70f53b02b3cdfe
Gitweb:     https://git.kernel.org/tip/d63326928611600ad65baff54a70f53b02b3cdfe
Author:     Rick Edgecombe <rick.p.edgecombe@intel.com>
AuthorDate: Thu, 25 Apr 2019 17:11:35 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 30 Apr 2019 12:37:57 +0200

mm/hibernation: Make hibernation handle unmapped pages

Make hibernate handle unmapped pages on the direct map when
CONFIG_ARCH_HAS_SET_ALIAS=y is set. These functions allow for setting pages
to invalid configurations, so now hibernate should check if the pages have
valid mappings and handle if they are unmapped when doing a hibernate
save operation.

Previously this checking was already done when CONFIG_DEBUG_PAGEALLOC=y
was configured. It does not appear to have a big hibernating performance
impact. The speed of the saving operation before this change was measured
as 819.02 MB/s, and after was measured at 813.32 MB/s.

Before:
[    4.670938] PM: Wrote 171996 kbytes in 0.21 seconds (819.02 MB/s)

After:
[    4.504714] PM: Wrote 178932 kbytes in 0.22 seconds (813.32 MB/s)

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: <akpm@linux-foundation.org>
Cc: <ard.biesheuvel@linaro.org>
Cc: <deneen.t.dock@intel.com>
Cc: <kernel-hardening@lists.openwall.com>
Cc: <kristen@linux.intel.com>
Cc: <linux_dti@icloud.com>
Cc: <will.deacon@arm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Rik van Riel <riel@surriel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20190426001143.4983-16-namit@vmware.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/mm/pageattr.c  |  4 ----
 include/linux/mm.h      | 18 ++++++------------
 kernel/power/snapshot.c |  5 +++--
 mm/page_alloc.c         |  7 +++++--
 4 files changed, 14 insertions(+), 20 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 3574550192c6..daf4d645e537 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -2257,7 +2257,6 @@ int set_direct_map_default_noflush(struct page *page)
 	return __set_pages_p(page, 1);
 }
 
-#ifdef CONFIG_DEBUG_PAGEALLOC
 void __kernel_map_pages(struct page *page, int numpages, int enable)
 {
 	if (PageHighMem(page))
@@ -2302,11 +2301,8 @@ bool kernel_page_present(struct page *page)
 	pte = lookup_address((unsigned long)page_address(page), &level);
 	return (pte_val(*pte) & _PAGE_PRESENT);
 }
-
 #endif /* CONFIG_HIBERNATION */
 
-#endif /* CONFIG_DEBUG_PAGEALLOC */
-
 int __init kernel_map_pages_in_pgd(pgd_t *pgd, u64 pfn, unsigned long address,
 				   unsigned numpages, unsigned long page_flags)
 {
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 6b10c21630f5..083d7b4863ed 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2610,37 +2610,31 @@ static inline void kernel_poison_pages(struct page *page, int numpages,
 					int enable) { }
 #endif
 
-#ifdef CONFIG_DEBUG_PAGEALLOC
 extern bool _debug_pagealloc_enabled;
-extern void __kernel_map_pages(struct page *page, int numpages, int enable);
 
 static inline bool debug_pagealloc_enabled(void)
 {
-	return _debug_pagealloc_enabled;
+	return IS_ENABLED(CONFIG_DEBUG_PAGEALLOC) && _debug_pagealloc_enabled;
 }
 
+#if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_ARCH_HAS_SET_DIRECT_MAP)
+extern void __kernel_map_pages(struct page *page, int numpages, int enable);
+
 static inline void
 kernel_map_pages(struct page *page, int numpages, int enable)
 {
-	if (!debug_pagealloc_enabled())
-		return;
-
 	__kernel_map_pages(page, numpages, enable);
 }
 #ifdef CONFIG_HIBERNATION
 extern bool kernel_page_present(struct page *page);
 #endif	/* CONFIG_HIBERNATION */
-#else	/* CONFIG_DEBUG_PAGEALLOC */
+#else	/* CONFIG_DEBUG_PAGEALLOC || CONFIG_ARCH_HAS_SET_DIRECT_MAP */
 static inline void
 kernel_map_pages(struct page *page, int numpages, int enable) {}
 #ifdef CONFIG_HIBERNATION
 static inline bool kernel_page_present(struct page *page) { return true; }
 #endif	/* CONFIG_HIBERNATION */
-static inline bool debug_pagealloc_enabled(void)
-{
-	return false;
-}
-#endif	/* CONFIG_DEBUG_PAGEALLOC */
+#endif	/* CONFIG_DEBUG_PAGEALLOC || CONFIG_ARCH_HAS_SET_DIRECT_MAP */
 
 #ifdef __HAVE_ARCH_GATE_AREA
 extern struct vm_area_struct *get_gate_vma(struct mm_struct *mm);
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index f08a1e4ee1d4..bc9558ab1e5b 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -1342,8 +1342,9 @@ static inline void do_copy_page(long *dst, long *src)
  * safe_copy_page - Copy a page in a safe way.
  *
  * Check if the page we are going to copy is marked as present in the kernel
- * page tables (this always is the case if CONFIG_DEBUG_PAGEALLOC is not set
- * and in that case kernel_page_present() always returns 'true').
+ * page tables. This always is the case if CONFIG_DEBUG_PAGEALLOC or
+ * CONFIG_ARCH_HAS_SET_DIRECT_MAP is not set. In that case kernel_page_present()
+ * always returns 'true'.
  */
 static void safe_copy_page(void *dst, struct page *s_page)
 {
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c02cff1ed56e..59661106da16 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1144,7 +1144,9 @@ static __always_inline bool free_pages_prepare(struct page *page,
 	}
 	arch_free_page(page, order);
 	kernel_poison_pages(page, 1 << order, 0);
-	kernel_map_pages(page, 1 << order, 0);
+	if (debug_pagealloc_enabled())
+		kernel_map_pages(page, 1 << order, 0);
+
 	kasan_free_nondeferred_pages(page, order);
 
 	return true;
@@ -2014,7 +2016,8 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
 	set_page_refcounted(page);
 
 	arch_alloc_page(page, order);
-	kernel_map_pages(page, 1 << order, 1);
+	if (debug_pagealloc_enabled())
+		kernel_map_pages(page, 1 << order, 1);
 	kasan_alloc_pages(page, order);
 	kernel_poison_pages(page, 1 << order, 1);
 	set_page_owner(page, order, gfp_flags);
