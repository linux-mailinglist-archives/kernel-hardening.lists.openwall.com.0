Return-Path: <kernel-hardening-return-15836-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 92D90B2F2
	for <lists+kernel-hardening@lfdr.de>; Sat, 27 Apr 2019 08:47:15 +0200 (CEST)
Received: (qmail 5691 invoked by uid 550); 27 Apr 2019 06:43:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 5552 invoked from network); 27 Apr 2019 06:43:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=71dbHy9m/CIhCtlniLjnIfT11ydtbrFJWfPgh/aDBts=;
        b=qvNLDfV5t6OCXjpXqE2h8qCP9bZ/sJ406eIEMibouYzKfppgqnMlAuCIygJ2OFcd9+
         MMTkVSXzO0aOctNe/CiP8Zw9kIpjzutOKkzuNHcJG3fCAdytpDd18QMDAb6Knim/ohRs
         tBDO6V0x85WHUL2w71XgQxWYSTrcZtRKjF0HFFS4Dzn7r6bnhd8gs0bFJ2ayDhn0qXIt
         XGqaYfEBSbyjlozxlv7tlJsqu8eyvkVV9qOY42YDUV4gMlVY70x2mouNblsQZ7uqnSpE
         5UOlPM0wci38r9uZAhlJb4I1NObgCcrLUdbvFFf4CBRT8+QPP08ffFZ0CF9w8nTK5/X2
         J8hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=71dbHy9m/CIhCtlniLjnIfT11ydtbrFJWfPgh/aDBts=;
        b=NJ+832X/7Rf6oI3yQWwUjfvNDqZF2jsDAsX89LKWKLUO9BS5vsXHhRNFopzNDvF6zL
         d0KGUjvc9XVZ4cbFm6wyjhfgCBp7O4JlzYD2GIqQyRGAasPT9QKaiSj1Yb/oKOfG8ey/
         Kgae+NICG186hSEYNUl15G4o7phSKOOdtdHAy9W3b7CuXrjWK9z0TJpFT7Pt8aOsctrz
         iMT3XZQbbn1gB9vE/5ncx4iXwZb0UTjssnVTBTk2vI8snKgd8+2ZC5lTX/Hvz681hr+W
         W25rD8mvSASLwDPeOW90GX4EAoLkpLA3+sFkd+fYVS7+WMHJp3ocKGbYYovC+lhXiTQH
         Yd0A==
X-Gm-Message-State: APjAAAXPKJvKqd6GafsKtjUmDHwJjiFdAmqdX1ygiZHTqzLWFPbtBxKk
	ye5WPqHq0CIcrQiTbx07IA8=
X-Google-Smtp-Source: APXvYqyURRPLLrg0ynk67t/jHVJBTNh21u6U/GXsGcvBn1nAU+eeDbHBRYN9HLkqe6vwNFju/6m6NQ==
X-Received: by 2002:a65:500d:: with SMTP id f13mr8345688pgo.250.1556347409072;
        Fri, 26 Apr 2019 23:43:29 -0700 (PDT)
From: nadav.amit@gmail.com
To: Peter Zijlstra <peterz@infradead.org>,
	Borislav Petkov <bp@alien8.de>,
	Andy Lutomirski <luto@kernel.org>,
	Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	hpa@zytor.com,
	Thomas Gleixner <tglx@linutronix.de>,
	Nadav Amit <nadav.amit@gmail.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	linux_dti@icloud.com,
	linux-integrity@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	akpm@linux-foundation.org,
	kernel-hardening@lists.openwall.com,
	linux-mm@kvack.org,
	will.deacon@arm.com,
	ard.biesheuvel@linaro.org,
	kristen@linux.intel.com,
	deneen.t.dock@intel.com,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [PATCH v6 17/24] vmalloc: Add flag for free of special permsissions
Date: Fri, 26 Apr 2019 16:22:56 -0700
Message-Id: <20190426232303.28381-18-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190426232303.28381-1-nadav.amit@gmail.com>
References: <20190426232303.28381-1-nadav.amit@gmail.com>

From: Rick Edgecombe <rick.p.edgecombe@intel.com>

Add a new flag VM_FLUSH_RESET_PERMS, for enabling vfree operations to
immediately clear executable TLB entries before freeing pages, and handle
resetting permissions on the directmap. This flag is useful for any kind
of memory with elevated permissions, or where there can be related
permissions changes on the directmap. Today this is RO+X and RO memory.

Although this enables directly vfreeing non-writeable memory now,
non-writable memory cannot be freed in an interrupt because the allocation
itself is used as a node on deferred free list. So when RO memory needs to
be freed in an interrupt the code doing the vfree needs to have its own
work queue, as was the case before the deferred vfree list was added to
vmalloc.

For architectures with set_direct_map_ implementations this whole operation
can be done with one TLB flush when centralized like this. For others with
directmap permissions, currently only arm64, a backup method using
set_memory functions is used to reset the directmap. When arm64 adds
set_direct_map_ functions, this backup can be removed.

When the TLB is flushed to both remove TLB entries for the vmalloc range
mapping and the direct map permissions, the lazy purge operation could be
done to try to save a TLB flush later. However today vm_unmap_aliases
could flush a TLB range that does not include the directmap. So a helper
is added with extra parameters that can allow both the vmalloc address and
the direct mapping to be flushed during this operation. The behavior of the
normal vm_unmap_aliases function is unchanged.

Cc: Borislav Petkov <bp@alien8.de>
Suggested-by: Dave Hansen <dave.hansen@intel.com>
Suggested-by: Andy Lutomirski <luto@kernel.org>
Suggested-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 include/linux/vmalloc.h |  15 ++++++
 mm/vmalloc.c            | 113 +++++++++++++++++++++++++++++++++-------
 2 files changed, 109 insertions(+), 19 deletions(-)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 398e9c95cd61..c6eebb839552 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -21,6 +21,11 @@ struct notifier_block;		/* in notifier.h */
 #define VM_UNINITIALIZED	0x00000020	/* vm_struct is not fully initialized */
 #define VM_NO_GUARD		0x00000040      /* don't add guard page */
 #define VM_KASAN		0x00000080      /* has allocated kasan shadow memory */
+/*
+ * Memory with VM_FLUSH_RESET_PERMS cannot be freed in an interrupt or with
+ * vfree_atomic().
+ */
+#define VM_FLUSH_RESET_PERMS	0x00000100      /* Reset direct map and flush TLB on unmap */
 /* bits [20..32] reserved for arch specific ioremap internals */
 
 /*
@@ -142,6 +147,13 @@ extern int map_kernel_range_noflush(unsigned long start, unsigned long size,
 				    pgprot_t prot, struct page **pages);
 extern void unmap_kernel_range_noflush(unsigned long addr, unsigned long size);
 extern void unmap_kernel_range(unsigned long addr, unsigned long size);
+static inline void set_vm_flush_reset_perms(void *addr)
+{
+	struct vm_struct *vm = find_vm_area(addr);
+
+	if (vm)
+		vm->flags |= VM_FLUSH_RESET_PERMS;
+}
 #else
 static inline int
 map_kernel_range_noflush(unsigned long start, unsigned long size,
@@ -157,6 +169,9 @@ static inline void
 unmap_kernel_range(unsigned long addr, unsigned long size)
 {
 }
+static inline void set_vm_flush_reset_perms(void *addr)
+{
+}
 #endif
 
 /* Allocate/destroy a 'vmalloc' VM area. */
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index e86ba6e74b50..e5e9e1fcac01 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -18,6 +18,7 @@
 #include <linux/interrupt.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
+#include <linux/set_memory.h>
 #include <linux/debugobjects.h>
 #include <linux/kallsyms.h>
 #include <linux/list.h>
@@ -1059,24 +1060,9 @@ static void vb_free(const void *addr, unsigned long size)
 		spin_unlock(&vb->lock);
 }
 
-/**
- * vm_unmap_aliases - unmap outstanding lazy aliases in the vmap layer
- *
- * The vmap/vmalloc layer lazily flushes kernel virtual mappings primarily
- * to amortize TLB flushing overheads. What this means is that any page you
- * have now, may, in a former life, have been mapped into kernel virtual
- * address by the vmap layer and so there might be some CPUs with TLB entries
- * still referencing that page (additional to the regular 1:1 kernel mapping).
- *
- * vm_unmap_aliases flushes all such lazy mappings. After it returns, we can
- * be sure that none of the pages we have control over will have any aliases
- * from the vmap layer.
- */
-void vm_unmap_aliases(void)
+static void _vm_unmap_aliases(unsigned long start, unsigned long end, int flush)
 {
-	unsigned long start = ULONG_MAX, end = 0;
 	int cpu;
-	int flush = 0;
 
 	if (unlikely(!vmap_initialized))
 		return;
@@ -1113,6 +1099,27 @@ void vm_unmap_aliases(void)
 		flush_tlb_kernel_range(start, end);
 	mutex_unlock(&vmap_purge_lock);
 }
+
+/**
+ * vm_unmap_aliases - unmap outstanding lazy aliases in the vmap layer
+ *
+ * The vmap/vmalloc layer lazily flushes kernel virtual mappings primarily
+ * to amortize TLB flushing overheads. What this means is that any page you
+ * have now, may, in a former life, have been mapped into kernel virtual
+ * address by the vmap layer and so there might be some CPUs with TLB entries
+ * still referencing that page (additional to the regular 1:1 kernel mapping).
+ *
+ * vm_unmap_aliases flushes all such lazy mappings. After it returns, we can
+ * be sure that none of the pages we have control over will have any aliases
+ * from the vmap layer.
+ */
+void vm_unmap_aliases(void)
+{
+	unsigned long start = ULONG_MAX, end = 0;
+	int flush = 0;
+
+	_vm_unmap_aliases(start, end, flush);
+}
 EXPORT_SYMBOL_GPL(vm_unmap_aliases);
 
 /**
@@ -1505,6 +1512,72 @@ struct vm_struct *remove_vm_area(const void *addr)
 	return NULL;
 }
 
+static inline void set_area_direct_map(const struct vm_struct *area,
+				       int (*set_direct_map)(struct page *page))
+{
+	int i;
+
+	for (i = 0; i < area->nr_pages; i++)
+		if (page_address(area->pages[i]))
+			set_direct_map(area->pages[i]);
+}
+
+/* Handle removing and resetting vm mappings related to the vm_struct. */
+static void vm_remove_mappings(struct vm_struct *area, int deallocate_pages)
+{
+	unsigned long addr = (unsigned long)area->addr;
+	unsigned long start = ULONG_MAX, end = 0;
+	int flush_reset = area->flags & VM_FLUSH_RESET_PERMS;
+	int i;
+
+	/*
+	 * The below block can be removed when all architectures that have
+	 * direct map permissions also have set_direct_map_() implementations.
+	 * This is concerned with resetting the direct map any an vm alias with
+	 * execute permissions, without leaving a RW+X window.
+	 */
+	if (flush_reset && !IS_ENABLED(CONFIG_ARCH_HAS_SET_DIRECT_MAP)) {
+		set_memory_nx(addr, area->nr_pages);
+		set_memory_rw(addr, area->nr_pages);
+	}
+
+	remove_vm_area(area->addr);
+
+	/* If this is not VM_FLUSH_RESET_PERMS memory, no need for the below. */
+	if (!flush_reset)
+		return;
+
+	/*
+	 * If not deallocating pages, just do the flush of the VM area and
+	 * return.
+	 */
+	if (!deallocate_pages) {
+		vm_unmap_aliases();
+		return;
+	}
+
+	/*
+	 * If execution gets here, flush the vm mapping and reset the direct
+	 * map. Find the start and end range of the direct mappings to make sure
+	 * the vm_unmap_aliases() flush includes the direct map.
+	 */
+	for (i = 0; i < area->nr_pages; i++) {
+		if (page_address(area->pages[i])) {
+			start = min(addr, start);
+			end = max(addr, end);
+		}
+	}
+
+	/*
+	 * Set direct map to something invalid so that it won't be cached if
+	 * there are any accesses after the TLB flush, then flush the TLB and
+	 * reset the direct map permissions to the default.
+	 */
+	set_area_direct_map(area, set_direct_map_invalid_noflush);
+	_vm_unmap_aliases(start, end, 1);
+	set_area_direct_map(area, set_direct_map_default_noflush);
+}
+
 static void __vunmap(const void *addr, int deallocate_pages)
 {
 	struct vm_struct *area;
@@ -1526,7 +1599,8 @@ static void __vunmap(const void *addr, int deallocate_pages)
 	debug_check_no_locks_freed(area->addr, get_vm_area_size(area));
 	debug_check_no_obj_freed(area->addr, get_vm_area_size(area));
 
-	remove_vm_area(addr);
+	vm_remove_mappings(area, deallocate_pages);
+
 	if (deallocate_pages) {
 		int i;
 
@@ -1961,8 +2035,9 @@ EXPORT_SYMBOL(vzalloc_node);
  */
 void *vmalloc_exec(unsigned long size)
 {
-	return __vmalloc_node(size, 1, GFP_KERNEL, PAGE_KERNEL_EXEC,
-			      NUMA_NO_NODE, __builtin_return_address(0));
+	return __vmalloc_node_range(size, 1, VMALLOC_START, VMALLOC_END,
+			GFP_KERNEL, PAGE_KERNEL_EXEC, VM_FLUSH_RESET_PERMS,
+			NUMA_NO_NODE, __builtin_return_address(0));
 }
 
 #if defined(CONFIG_64BIT) && defined(CONFIG_ZONE_DMA32)
-- 
2.17.1

