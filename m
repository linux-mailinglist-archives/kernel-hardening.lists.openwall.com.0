Return-Path: <kernel-hardening-return-19382-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 966AA224167
	for <lists+kernel-hardening@lfdr.de>; Fri, 17 Jul 2020 19:02:13 +0200 (CEST)
Received: (qmail 11438 invoked by uid 550); 17 Jul 2020 17:01:14 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 11356 invoked from network); 17 Jul 2020 17:01:13 -0000
IronPort-SDR: P35dT/61aT4Qd9fD4GtsDxUaOGeFX/FcDYyYE1PHUDM+IRv6fGll9gLxCK0pyWkAntGO3HwtET
 LiJGXfyG4kMg==
X-IronPort-AV: E=McAfee;i="6000,8403,9685"; a="234486423"
X-IronPort-AV: E=Sophos;i="5.75,362,1589266800"; 
   d="scan'208";a="234486423"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
IronPort-SDR: YlJ98+kE/rZOgfAyKy2KRuoB3VOum1TV+Wc6cob0H1N42bJ+0/52jZSaxvvWVP9aWfpeFZ30J8
 0UjwzN8oXoSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,362,1589266800"; 
   d="scan'208";a="270862167"
From: Kristen Carlson Accardi <kristen@linux.intel.com>
To: keescook@chromium.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>
Cc: arjan@linux.intel.com,
	linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com,
	rick.p.edgecombe@intel.com,
	Kristen Carlson Accardi <kristen@linux.intel.com>
Subject: [PATCH v4 07/10] x86/boot/compressed: Avoid duplicate malloc() implementations
Date: Fri, 17 Jul 2020 10:00:04 -0700
Message-Id: <20200717170008.5949-8-kristen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200717170008.5949-1-kristen@linux.intel.com>
References: <20200717170008.5949-1-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kees Cook <keescook@chromium.org>

The preboot malloc() (and free()) implementation in
include/linux/decompress/mm.h (which is also included by the
static decompressors) is static. This is fine when the only thing
interested in using malloc() is the decompression code, but the
x86 preboot environment uses malloc() in a couple places, leading to a
potential collision when the static copies of the available memory
region ("malloc_ptr") gets reset to the global "free_mem_ptr" value.
As it happens, the existing usage pattern happened to be safe because each
user did 1 malloc() and 1 free() before returning and were not nested:

extract_kernel() (misc.c)
	choose_random_location() (kaslr.c)
		mem_avoid_init()
			handle_mem_options()
				malloc()
				...
				free()
	...
	parse_elf() (misc.c)
		malloc()
		...
		free()

Adding FGKASLR, however, will insert additional malloc() calls local to
fgkaslr.c in the middle of parse_elf()'s malloc()/free() pair:

	parse_elf() (misc.c)
		malloc()
		if (...) {
			layout_randomized_image(output, &ehdr, phdrs);
				malloc() <- boom
				...
		else
			layout_image(output, &ehdr, phdrs);
		free()

To avoid collisions, there must be a single implementation of malloc().
Adjust include/linux/decompress/mm.h so that visibility can be
controlled, provide prototypes in misc.h, and implement the functions in
misc.c. This also results in a small size savings:

$ size vmlinux.before vmlinux.after
   text    data     bss     dec     hex filename
8842314     468  178320 9021102  89a6ae vmlinux.before
8842240     468  178320 9021028  89a664 vmlinux.after

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
---
 arch/x86/boot/compressed/kaslr.c |  4 ----
 arch/x86/boot/compressed/misc.c  |  3 +++
 arch/x86/boot/compressed/misc.h  |  2 ++
 include/linux/decompress/mm.h    | 12 ++++++++++--
 4 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/arch/x86/boot/compressed/kaslr.c b/arch/x86/boot/compressed/kaslr.c
index d7408af55738..6f596bd5b6e5 100644
--- a/arch/x86/boot/compressed/kaslr.c
+++ b/arch/x86/boot/compressed/kaslr.c
@@ -39,10 +39,6 @@
 #include <generated/utsrelease.h>
 #include <asm/efi.h>
 
-/* Macros used by the included decompressor code below. */
-#define STATIC
-#include <linux/decompress/mm.h>
-
 #ifdef CONFIG_X86_5LEVEL
 unsigned int __pgtable_l5_enabled;
 unsigned int pgdir_shift __ro_after_init = 39;
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 9652d5c2afda..90a4b64b3037 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -28,6 +28,9 @@
 
 /* Macros used by the included decompressor code below. */
 #define STATIC		static
+/* Define an externally visible malloc()/free(). */
+#define MALLOC_VISIBLE
+#include <linux/decompress/mm.h>
 
 /*
  * Use normal definitions of mem*() from string.c. There are already
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index 726e264410ff..81fbc8d686fa 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -39,6 +39,8 @@
 /* misc.c */
 extern memptr free_mem_ptr;
 extern memptr free_mem_end_ptr;
+extern void *malloc(int size);
+extern void free(void *where);
 extern struct boot_params *boot_params;
 void __putstr(const char *s);
 void __puthex(unsigned long value);
diff --git a/include/linux/decompress/mm.h b/include/linux/decompress/mm.h
index 868e9eacd69e..9192986b1a73 100644
--- a/include/linux/decompress/mm.h
+++ b/include/linux/decompress/mm.h
@@ -25,13 +25,21 @@
 #define STATIC_RW_DATA static
 #endif
 
+/*
+ * When an architecture needs to share the malloc()/free() implementation
+ * between compilation units, it needs to have non-local visibility.
+ */
+#ifndef MALLOC_VISIBLE
+#define MALLOC_VISIBLE static
+#endif
+
 /* A trivial malloc implementation, adapted from
  *  malloc by Hannu Savolainen 1993 and Matthias Urlichs 1994
  */
 STATIC_RW_DATA unsigned long malloc_ptr;
 STATIC_RW_DATA int malloc_count;
 
-static void *malloc(int size)
+MALLOC_VISIBLE void *malloc(int size)
 {
 	void *p;
 
@@ -52,7 +60,7 @@ static void *malloc(int size)
 	return p;
 }
 
-static void free(void *where)
+MALLOC_VISIBLE void free(void *where)
 {
 	malloc_count--;
 	if (!malloc_count)
-- 
2.20.1

