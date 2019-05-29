Return-Path: <kernel-hardening-return-16000-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id C74F72DF7D
	for <lists+kernel-hardening@lfdr.de>; Wed, 29 May 2019 16:18:09 +0200 (CEST)
Received: (qmail 5780 invoked by uid 550); 29 May 2019 14:17:56 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 18119 invoked from network); 29 May 2019 12:38:48 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Av06FkFyTGfvOvGo6A9zKZw+CBXEF6FDDT5YdORZtrs=;
        b=sw4Ift6QkIQDVlTsm4rKEpyHSZaLhULHZE/12qIXwDyvy6galnSCmqE3hV+WQAVYPP
         Vm0Ka4mGYbpQysCXTVy7n6xEe8LVpmH2r8qwqIH4j1fUfvef2bDy4YM8fw5Xz3z92yry
         5eOyYqRoYuBn690KcRqre2j3sTffG3tnN856BwTpTU1wIvqc1AceNvcU045en+jHKJ4D
         P/rybP6B1tMo/CUP1tLGXd0S+l44oaXzVAA/eAQPZ50sL5mmBcekFBPC/mZfQcpnPorO
         Q83tK9eM1adlpl2ld1NqJGk4cium0VTiio51DR3nbpCciC3l3CrwGkL1YQjiYSoOb8h9
         2xRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Av06FkFyTGfvOvGo6A9zKZw+CBXEF6FDDT5YdORZtrs=;
        b=Rm7YuzqTJI7sazIc7t4QrBF2pdkvgOf45CQ8LMWIv+O1cX2Lzs3Q8GI+8T75c/Or8C
         YfsFtZ5Y/foP9eMcL5yVtOddb+2Cr/5Bu2na1VORDgUMLe62qm78opkt3EHxOsfo+vrV
         qYNIPVKtBS0IP9PT4rFBiAP21YZWP69dvQWKbc3digKn1BjuWeiyH550WxSrIC7Atgp+
         Ivn2tmL15ihrGe8rlbwoisEbgy+FYEGfH8ALoCT8xa+wXYWWMWPF3n84iWOZ2fRtWnpg
         j4KprgVYUQ5asynU0VLDspLWOAUjHvurw++Jk85WvEz7rIRfFd2JWTbHKkQhBoTXCcjf
         38BA==
X-Gm-Message-State: APjAAAXx0KnfgnIgGID3DFlF1NgVHJJAQtvZKNT+g/8bd4BvMKGJ3oH1
	gNpnXEBK42d/uARQY+xegxdBOhVqgc0=
X-Google-Smtp-Source: APXvYqwSC38bt7d+wyDQ/RiPd1KAVrVX9T7m1Y/u/pZl9RfAookLsQSNAuw0CuKISwNXubwsUZEAEoIDXig=
X-Received: by 2002:aca:5ad7:: with SMTP id o206mr583301oib.65.1559133516337;
 Wed, 29 May 2019 05:38:36 -0700 (PDT)
Date: Wed, 29 May 2019 14:38:12 +0200
In-Reply-To: <20190529123812.43089-1-glider@google.com>
Message-Id: <20190529123812.43089-4-glider@google.com>
Mime-Version: 1.0
References: <20190529123812.43089-1-glider@google.com>
X-Mailer: git-send-email 2.22.0.rc1.257.g3120a18244-goog
Subject: [PATCH v5 3/3] lib: introduce test_meminit module
From: Alexander Potapenko <glider@google.com>
To: Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@linux.com>
Cc: Alexander Potapenko <glider@google.com>, Nick Desaulniers <ndesaulniers@google.com>, 
	Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, 
	Laura Abbott <labbott@redhat.com>, Jann Horn <jannh@google.com>, Marco Elver <elver@google.com>, 
	linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
	kernel-hardening@lists.openwall.com
Content-Type: text/plain; charset="UTF-8"

Add tests for heap and pagealloc initialization.
These can be used to check init_on_alloc and init_on_free implementations
as well as other approaches to initialization.

Expected test output in the case the kernel provides heap initialization
(e.g. when running with either init_on_alloc=1 or init_on_free=1):

  test_meminit: all 10 tests in test_pages passed
  test_meminit: all 40 tests in test_kvmalloc passed
  test_meminit: all 60 tests in test_kmemcache passed
  test_meminit: all 10 tests in test_rcu_persistent passed
  test_meminit: all 120 tests passed!

Signed-off-by: Alexander Potapenko <glider@google.com>
To: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <cl@linux.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Kostya Serebryany <kcc@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Sandeep Patil <sspatil@android.com>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Marco Elver <elver@google.com>
Cc: linux-mm@kvack.org
Cc: linux-security-module@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com
---
 v3:
  - added example test output to the description
  - fixed a missing include spotted by kbuild test robot <lkp@intel.com>
  - added a missing MODULE_LICENSE
  - call do_kmem_cache_size() with size >= sizeof(void*) to unbreak
  debug builds
 v5:
  - added tests for RCU slabs and __GFP_ZERO
---
 lib/Kconfig.debug  |   8 +
 lib/Makefile       |   1 +
 lib/test_meminit.c | 362 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 371 insertions(+)
 create mode 100644 lib/test_meminit.c

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index cbdfae379896..085711f14abf 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2040,6 +2040,14 @@ config TEST_STACKINIT
 
 	  If unsure, say N.
 
+config TEST_MEMINIT
+	tristate "Test heap/page initialization"
+	help
+	  Test if the kernel is zero-initializing heap and page allocations.
+	  This can be useful to test init_on_alloc and init_on_free features.
+
+	  If unsure, say N.
+
 endif # RUNTIME_TESTING_MENU
 
 config MEMTEST
diff --git a/lib/Makefile b/lib/Makefile
index fb7697031a79..05980c802500 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -91,6 +91,7 @@ obj-$(CONFIG_TEST_DEBUG_VIRTUAL) += test_debug_virtual.o
 obj-$(CONFIG_TEST_MEMCAT_P) += test_memcat_p.o
 obj-$(CONFIG_TEST_OBJAGG) += test_objagg.o
 obj-$(CONFIG_TEST_STACKINIT) += test_stackinit.o
+obj-$(CONFIG_TEST_MEMINIT) += test_meminit.o
 
 obj-$(CONFIG_TEST_LIVEPATCH) += livepatch/
 
diff --git a/lib/test_meminit.c b/lib/test_meminit.c
new file mode 100644
index 000000000000..ed7efec1387b
--- /dev/null
+++ b/lib/test_meminit.c
@@ -0,0 +1,362 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Test cases for SL[AOU]B/page initialization at alloc/free time.
+ */
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/vmalloc.h>
+
+#define GARBAGE_INT (0x09A7BA9E)
+#define GARBAGE_BYTE (0x9E)
+
+#define REPORT_FAILURES_IN_FN() \
+	do {	\
+		if (failures)	\
+			pr_info("%s failed %d out of %d times\n",	\
+				__func__, failures, num_tests);		\
+		else		\
+			pr_info("all %d tests in %s passed\n",		\
+				num_tests, __func__);			\
+	} while (0)
+
+/* Calculate the number of uninitialized bytes in the buffer. */
+static int __init count_nonzero_bytes(void *ptr, size_t size)
+{
+	int i, ret = 0;
+	unsigned char *p = (unsigned char *)ptr;
+
+	for (i = 0; i < size; i++)
+		if (p[i])
+			ret++;
+	return ret;
+}
+
+/* Fill a buffer with garbage, skipping |skip| first bytes. */
+static void __init fill_with_garbage_skip(void *ptr, size_t size, size_t skip)
+{
+	unsigned int *p = (unsigned int *)ptr;
+	int i = 0;
+
+	if (skip) {
+		WARN_ON(skip > size);
+		p += skip;
+	}
+	while (size >= sizeof(*p)) {
+		p[i] = GARBAGE_INT;
+		i++;
+		size -= sizeof(*p);
+	}
+	if (size)
+		memset(&p[i], GARBAGE_BYTE, size);
+}
+
+static void __init fill_with_garbage(void *ptr, size_t size)
+{
+	fill_with_garbage_skip(ptr, size, 0);
+}
+
+static int __init do_alloc_pages_order(int order, int *total_failures)
+{
+	struct page *page;
+	void *buf;
+	size_t size = PAGE_SIZE << order;
+
+	page = alloc_pages(GFP_KERNEL, order);
+	buf = page_address(page);
+	fill_with_garbage(buf, size);
+	__free_pages(page, order);
+
+	page = alloc_pages(GFP_KERNEL, order);
+	buf = page_address(page);
+	if (count_nonzero_bytes(buf, size))
+		(*total_failures)++;
+	fill_with_garbage(buf, size);
+	__free_pages(page, order);
+	return 1;
+}
+
+/* Test the page allocator by calling alloc_pages with different orders. */
+static int __init test_pages(int *total_failures)
+{
+	int failures = 0, num_tests = 0;
+	int i;
+
+	for (i = 0; i < 10; i++)
+		num_tests += do_alloc_pages_order(i, &failures);
+
+	REPORT_FAILURES_IN_FN();
+	*total_failures += failures;
+	return num_tests;
+}
+
+/* Test kmalloc() with given parameters. */
+static int __init do_kmalloc_size(size_t size, int *total_failures)
+{
+	void *buf;
+
+	buf = kmalloc(size, GFP_KERNEL);
+	fill_with_garbage(buf, size);
+	kfree(buf);
+
+	buf = kmalloc(size, GFP_KERNEL);
+	if (count_nonzero_bytes(buf, size))
+		(*total_failures)++;
+	fill_with_garbage(buf, size);
+	kfree(buf);
+	return 1;
+}
+
+/* Test vmalloc() with given parameters. */
+static int __init do_vmalloc_size(size_t size, int *total_failures)
+{
+	void *buf;
+
+	buf = vmalloc(size);
+	fill_with_garbage(buf, size);
+	vfree(buf);
+
+	buf = vmalloc(size);
+	if (count_nonzero_bytes(buf, size))
+		(*total_failures)++;
+	fill_with_garbage(buf, size);
+	vfree(buf);
+	return 1;
+}
+
+/* Test kmalloc()/vmalloc() by allocating objects of different sizes. */
+static int __init test_kvmalloc(int *total_failures)
+{
+	int failures = 0, num_tests = 0;
+	int i, size;
+
+	for (i = 0; i < 20; i++) {
+		size = 1 << i;
+		num_tests += do_kmalloc_size(size, &failures);
+		num_tests += do_vmalloc_size(size, &failures);
+	}
+
+	REPORT_FAILURES_IN_FN();
+	*total_failures += failures;
+	return num_tests;
+}
+
+#define CTOR_BYTES (sizeof(unsigned int))
+#define CTOR_PATTERN (0x41414141)
+/* Initialize the first 4 bytes of the object. */
+static void test_ctor(void *obj)
+{
+	*(unsigned int *)obj = CTOR_PATTERN;
+}
+
+/*
+ * Check the invariants for the buffer allocated from a slab cache.
+ * If the cache has a test constructor, the first 4 bytes of the object must
+ * always remain equal to CTOR_PATTERN.
+ * If the cache isn't an RCU-typesafe one, or if the allocation is done with
+ * __GFP_ZERO, then the object contents must be zeroed after allocation.
+ * If the cache is an RCU-typesafe one, the object contents must never be
+ * zeroed after the first use. This is checked by memcmp() in
+ * do_kmem_cache_size().
+ */
+static bool __init check_buf(void *buf, int size, bool want_ctor,
+			     bool want_rcu, bool want_zero)
+{
+	int bytes;
+	bool fail = false;
+
+	bytes = count_nonzero_bytes(buf, size);
+	WARN_ON(want_ctor && want_zero);
+	if (want_zero)
+		return bytes;
+	if (want_ctor) {
+		if (*(unsigned int *)buf != CTOR_PATTERN)
+			fail = 1;
+	} else {
+		if (bytes)
+			fail = !want_rcu;
+	}
+	return fail;
+}
+
+/*
+ * Test kmem_cache with given parameters:
+ *  want_ctor - use a constructor;
+ *  want_rcu - use SLAB_TYPESAFE_BY_RCU;
+ *  want_zero - use __GFP_ZERO.
+ */
+static int __init do_kmem_cache_size(size_t size, bool want_ctor,
+				     bool want_rcu, bool want_zero,
+				     int *total_failures)
+{
+	struct kmem_cache *c;
+	int iter;
+	bool fail = false;
+	gfp_t alloc_mask = GFP_KERNEL | (want_zero ? __GFP_ZERO : 0);
+	void *buf, *buf_copy;
+
+	c = kmem_cache_create("test_cache", size, 1,
+			      want_rcu ? SLAB_TYPESAFE_BY_RCU : 0,
+			      want_ctor ? test_ctor : NULL);
+	for (iter = 0; iter < 10; iter++) {
+		buf = kmem_cache_alloc(c, alloc_mask);
+		/* Check that buf is zeroed, if it must be. */
+		fail = check_buf(buf, size, want_ctor, want_rcu, want_zero);
+		fill_with_garbage_skip(buf, size, want_ctor ? CTOR_BYTES : 0);
+		/*
+		 * If this is an RCU cache, use a critical section to ensure we
+		 * can touch objects after they're freed.
+		 */
+		if (want_rcu) {
+			rcu_read_lock();
+			/*
+			 * Copy the buffer to check that it's not wiped on
+			 * free().
+			 */
+			buf_copy = kmalloc(size, GFP_KERNEL);
+			if (buf_copy)
+				memcpy(buf_copy, buf, size);
+		}
+		kmem_cache_free(c, buf);
+		if (want_rcu) {
+			/*
+			 * Check that |buf| is intact after kmem_cache_free().
+			 * |want_zero| is false, because we wrote garbage to
+			 * the buffer already.
+			 */
+			fail |= check_buf(buf, size, want_ctor, want_rcu,
+					  false);
+			if (buf_copy) {
+				fail |= (bool)memcmp(buf, buf_copy, size);
+				kfree(buf_copy);
+			}
+			rcu_read_unlock();
+		}
+	}
+	kmem_cache_destroy(c);
+
+	*total_failures += fail;
+	return 1;
+}
+
+/*
+ * Check that the data written to an RCU-allocated object survives
+ * reallocation.
+ */
+static int __init do_kmem_cache_rcu_persistent(int size, int *total_failures)
+{
+	struct kmem_cache *c;
+	void *buf, *buf_contents, *saved_ptr;
+	void **used_objects;
+	int i, iter, maxiter = 1024;
+	bool fail = false;
+
+	c = kmem_cache_create("test_cache", size, size, SLAB_TYPESAFE_BY_RCU,
+			      NULL);
+	buf = kmem_cache_alloc(c, GFP_KERNEL);
+	saved_ptr = buf;
+	fill_with_garbage(buf, size);
+	buf_contents = kmalloc(size, GFP_KERNEL);
+	if (!buf_contents)
+		goto out;
+	used_objects = kmalloc_array(maxiter, sizeof(void *), GFP_KERNEL);
+	if (!used_objects) {
+		kfree(buf_contents);
+		goto out;
+	}
+	memcpy(buf_contents, buf, size);
+	kmem_cache_free(c, buf);
+	/*
+	 * Run for a fixed number of iterations. If we never hit saved_ptr,
+	 * assume the test passes.
+	 */
+	for (iter = 0; iter < maxiter; iter++) {
+		buf = kmem_cache_alloc(c, GFP_KERNEL);
+		used_objects[iter] = buf;
+		if (buf == saved_ptr) {
+			fail = memcmp(buf_contents, buf, size);
+			for (i = 0; i <= iter; i++)
+				kmem_cache_free(c, used_objects[i]);
+			goto free_out;
+		}
+	}
+
+free_out:
+	kmem_cache_destroy(c);
+	kfree(buf_contents);
+	kfree(used_objects);
+out:
+	*total_failures += fail;
+	return 1;
+}
+
+/*
+ * Test kmem_cache allocation by creating caches of different sizes, with and
+ * without constructors, with and without SLAB_TYPESAFE_BY_RCU.
+ */
+static int __init test_kmemcache(int *total_failures)
+{
+	int failures = 0, num_tests = 0;
+	int i, flags, size;
+	bool ctor, rcu, zero;
+
+	for (i = 0; i < 10; i++) {
+		size = 8 << i;
+		for (flags = 0; flags < 8; flags++) {
+			ctor = flags & 1;
+			rcu = flags & 2;
+			zero = flags & 4;
+			if (ctor & zero)
+				continue;
+			num_tests += do_kmem_cache_size(size, ctor, rcu, zero,
+							&failures);
+		}
+	}
+	REPORT_FAILURES_IN_FN();
+	*total_failures += failures;
+	return num_tests;
+}
+
+/* Test the behavior of SLAB_TYPESAFE_BY_RCU caches of different sizes. */
+static int __init test_rcu_persistent(int *total_failures)
+{
+	int failures = 0, num_tests = 0;
+	int i, size;
+
+	for (i = 0; i < 10; i++) {
+		size = 8 << i;
+		num_tests += do_kmem_cache_rcu_persistent(size, &failures);
+	}
+	REPORT_FAILURES_IN_FN();
+	*total_failures += failures;
+	return num_tests;
+}
+
+/*
+ * Run the tests. Each test function returns the number of executed tests and
+ * updates |failures| with the number of failed tests.
+ */
+static int __init test_meminit_init(void)
+{
+	int failures = 0, num_tests = 0;
+
+	num_tests += test_pages(&failures);
+	num_tests += test_kvmalloc(&failures);
+	num_tests += test_kmemcache(&failures);
+	num_tests += test_rcu_persistent(&failures);
+
+	if (failures == 0)
+		pr_info("all %d tests passed!\n", num_tests);
+	else
+		pr_info("failures: %d out of %d\n", failures, num_tests);
+
+	return failures ? -EINVAL : 0;
+}
+module_init(test_meminit_init);
+
+MODULE_LICENSE("GPL");
-- 
2.22.0.rc1.257.g3120a18244-goog

