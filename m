Return-Path: <kernel-hardening-return-16130-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 9676C436C5
	for <lists+kernel-hardening@lfdr.de>; Thu, 13 Jun 2019 15:40:07 +0200 (CEST)
Received: (qmail 30090 invoked by uid 550); 13 Jun 2019 13:40:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 30055 invoked from network); 13 Jun 2019 13:40:00 -0000
From: Yann Droneaud <ydroneaud@opteya.com>
To: linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Kees Cook <keescook@chromium.org>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Yann Droneaud <ydroneaud@opteya.com>
Date: Thu, 13 Jun 2019 15:39:46 +0200
Message-Id: <20190613133946.20944-1-ydroneaud@opteya.com>
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
Subject: [PATCH 4/3] binfmt/elf: don't expose prandom_u32() state
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on ou.quest-ce.net)

Using prandom_u32() to get random offsets might expose fraction
of its internal state to userspace;

To prevent leaking prandom_u32() state, get_random_u32() could be
used instead, but with greater cost.

But it would be a big waste to call get_random_u32() to retrieve
only 4bits to 8bits at a time.

Instead this patch makes use of get_random_u64() to seed once a
local PRNG.

The local PRNG can be used safely to produces the random offsets,
exposing its internal state won't harm.

Link: https://lore.kernel.org/lkml/cover.1560423331.git.ydroneaud@opteya.com
Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
---
 fs/binfmt_elf.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index c84ef81f0639..9aaca1f671d1 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -182,7 +182,8 @@ static inline elf_addr_t __user *elf_stack_alloc(unsigned long *pp,
 	return sp;
 }
 
-static inline void elf_stack_randomize(unsigned long *pp, size_t range)
+static inline void elf_stack_randomize(unsigned long *pp,
+				       struct rnd_state *state, size_t range)
 {
 	u32 offset;
 	unsigned long p;
@@ -190,7 +191,7 @@ static inline void elf_stack_randomize(unsigned long *pp, size_t range)
 	if (!(current->flags & PF_RANDOMIZE))
 		return;
 
-	offset = prandom_u32() % range;
+	offset = prandom_u32_state(state) % range;
 	p = *pp;
 
 #ifdef CONFIG_STACK_GROWSUP
@@ -202,6 +203,15 @@ static inline void elf_stack_randomize(unsigned long *pp, size_t range)
 	*pp = p;
 }
 
+static inline void elf_stack_randomize_seed(struct rnd_state *state)
+{
+	if (!(current->flags & PF_RANDOMIZE))
+		return;
+
+	prandom_seed_state(state,
+			   get_random_u64());
+}
+
 #ifndef ELF_BASE_PLATFORM
 /*
  * AT_BASE_PLATFORM indicates the "real" hardware/microarchitecture.
@@ -230,6 +240,9 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 	int ei_index = 0;
 	const struct cred *cred = current_cred();
 	struct vm_area_struct *vma;
+	struct rnd_state state;
+
+	elf_stack_randomize_seed(&state);
 
 	/*
 	 * In some cases (e.g. Hyper-Threading), we want to avoid L1
@@ -239,7 +252,7 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 
 	p = arch_align_stack(p);
 
-	elf_stack_randomize(&p, 256);
+	elf_stack_randomize(&p, &state, 256);
 	elf_stack_align(&p);
 
 	/*
@@ -260,7 +273,7 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 	if (k_platform) {
 		size_t len = strlen(k_platform) + 1;
 
-		elf_stack_randomize(&p, 16);
+		elf_stack_randomize(&p, &state, 16);
 
 		u_platform = elf_stack_alloc(&p, len);
 		if (__copy_to_user(u_platform, k_platform, len))
@@ -275,14 +288,14 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 	if (k_base_platform) {
 		size_t len = strlen(k_base_platform) + 1;
 
-		elf_stack_randomize(&p, 16);
+		elf_stack_randomize(&p, &state, 16);
 
 		u_base_platform = elf_stack_alloc(&p, len);
 		if (__copy_to_user(u_base_platform, k_base_platform, len))
 			return -EFAULT;
 	}
 
-	elf_stack_randomize(&p, 256);
+	elf_stack_randomize(&p, &state, 256);
 	elf_stack_align(&p);
 
 	/* Create the ELF interpreter info */
-- 
2.21.0

