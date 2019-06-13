Return-Path: <kernel-hardening-return-16127-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id D510543589
	for <lists+kernel-hardening@lfdr.de>; Thu, 13 Jun 2019 13:32:19 +0200 (CEST)
Received: (qmail 19657 invoked by uid 550); 13 Jun 2019 11:32:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 9370 invoked from network); 13 Jun 2019 11:26:25 -0000
From: Yann Droneaud <ydroneaud@opteya.com>
To: linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Kees Cook <keescook@chromium.org>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Yann Droneaud <ydroneaud@opteya.com>
Date: Thu, 13 Jun 2019 13:26:04 +0200
Message-Id: <ac5502a779f4e1c4ad4329a95ed41173f91bf360.1560423331.git.ydroneaud@opteya.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1560423331.git.ydroneaud@opteya.com>
References: <cover.1560423331.git.ydroneaud@opteya.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a01:e35:39f2:1220:9dd7:c176:119b:4c9d
X-SA-Exim-Mail-From: ydroneaud@opteya.com
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on ou.quest-ce.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00,
	URIBL_BLOCKED autolearn=ham version=3.3.2
Subject: [PATCH 1/3] binfmt/elf: use functions for stack manipulation
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on ou.quest-ce.net)

As a preliminary step to AT_RANDOM alignment and randomization,
replaces STACK_ macros by elf_stack_ inline functions to make them
easier to reuse.

STACK_ROUND() needed a pointer to elf_addr_t, while STACK_ADD() and
STACK_ALLOC() don't. In the new functions, the current stack pointer
is an obvious input/output parameter of unsigned long type.

STACK_ADD() returned an unsigned long, while STACK_ROUND() returned
a pointer to elf_addr_t. elf_stack_add_items() and elf_stack_align()
return both void.

STACK_ROUND() was used to reserve space on stack (like STACK_ADD())
and to align the resulting stack pointer on 16 bytes boundary. The
macro is replaced by elf_stack_add_items() followed by elf_stack_align().

Link: https://lore.kernel.org/lkml/cover.1560423331.git.ydroneaud@opteya.com
Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
---
 fs/binfmt_elf.c | 68 ++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 50 insertions(+), 18 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 8264b468f283..87f0c8a21350 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -136,21 +136,52 @@ static int padzero(unsigned long elf_bss)
 	return 0;
 }
 
-/* Let's use some macros to make this stack manipulation a little clearer */
+/* Let's use some functions to make this stack manipulation clearer */
+static inline void elf_stack_add_items(unsigned long *pp, size_t items)
+{
+	elf_addr_t *sp = (elf_addr_t *)*pp;
+
+#ifdef CONFIG_STACK_GROWSUP
+	sp += items;
+#else
+	sp -= items;
+#endif
+
+	*pp = (unsigned long)sp;
+}
+
+static inline void elf_stack_align(unsigned long *pp)
+{
+	unsigned long p = *pp;
+
+#ifdef CONFIG_STACK_GROWSUP
+	p += 15;
+#endif
+
+	p &= ~15UL;
+
+	*pp = p;
+}
+
+static inline elf_addr_t __user *elf_stack_alloc(unsigned long *pp,
+						 size_t len)
+{
+	unsigned long p = *pp;
+	elf_addr_t __user *sp;
+
 #ifdef CONFIG_STACK_GROWSUP
-#define STACK_ADD(sp, items) ((elf_addr_t __user *)(sp) + (items))
-#define STACK_ROUND(sp, items) \
-	((15 + (unsigned long) ((sp) + (items))) &~ 15UL)
-#define STACK_ALLOC(sp, len) ({ \
-	elf_addr_t __user *old_sp = (elf_addr_t __user *)sp; sp += len; \
-	old_sp; })
+	sp = (elf_addr_t __user *)p;
+	p += len;
 #else
-#define STACK_ADD(sp, items) ((elf_addr_t __user *)(sp) - (items))
-#define STACK_ROUND(sp, items) \
-	(((unsigned long) (sp - items)) &~ 15UL)
-#define STACK_ALLOC(sp, len) ({ sp -= len ; sp; })
+	p -= len;
+	sp = (elf_addr_t __user *)p;
 #endif
 
+	*pp = p;
+
+	return sp;
+}
+
 #ifndef ELF_BASE_PLATFORM
 /*
  * AT_BASE_PLATFORM indicates the "real" hardware/microarchitecture.
@@ -198,7 +229,7 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 	if (k_platform) {
 		size_t len = strlen(k_platform) + 1;
 
-		u_platform = (elf_addr_t __user *)STACK_ALLOC(p, len);
+		u_platform = elf_stack_alloc(&p, len);
 		if (__copy_to_user(u_platform, k_platform, len))
 			return -EFAULT;
 	}
@@ -211,7 +242,7 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 	if (k_base_platform) {
 		size_t len = strlen(k_base_platform) + 1;
 
-		u_base_platform = (elf_addr_t __user *)STACK_ALLOC(p, len);
+		u_base_platform = elf_stack_alloc(&p, len);
 		if (__copy_to_user(u_base_platform, k_base_platform, len))
 			return -EFAULT;
 	}
@@ -220,8 +251,7 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 	 * Generate 16 random bytes for userspace PRNG seeding.
 	 */
 	get_random_bytes(k_rand_bytes, sizeof(k_rand_bytes));
-	u_rand_bytes = (elf_addr_t __user *)
-		       STACK_ALLOC(p, sizeof(k_rand_bytes));
+	u_rand_bytes = elf_stack_alloc(&p, sizeof(k_rand_bytes));
 	if (__copy_to_user(u_rand_bytes, k_rand_bytes, sizeof(k_rand_bytes)))
 		return -EFAULT;
 
@@ -280,11 +310,13 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 
 	/* And advance past the AT_NULL entry.  */
 	ei_index += 2;
-
-	sp = STACK_ADD(p, ei_index);
+	elf_stack_add_items(&p, ei_index);
 
 	items = (argc + 1) + (envc + 1) + 1;
-	bprm->p = STACK_ROUND(sp, items);
+	elf_stack_add_items(&p, items);
+	elf_stack_align(&p);
+
+	bprm->p = p;
 
 	/* Point sp at the lowest address on the stack */
 #ifdef CONFIG_STACK_GROWSUP
-- 
2.21.0

