Return-Path: <kernel-hardening-return-21480-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id C0A2E4510E9
	for <lists+kernel-hardening@lfdr.de>; Mon, 15 Nov 2021 19:53:43 +0100 (CET)
Received: (qmail 29769 invoked by uid 550); 15 Nov 2021 18:53:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 28629 invoked from network); 15 Nov 2021 18:53:24 -0000
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To: Al Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Alejandro Colomar <alx.manpages@gmail.com>,
	Aleksa Sarai <cyphar@cyphar.com>,
	Andy Lutomirski <luto@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	Christian Heimes <christian@python.org>,
	Deven Bowers <deven.desai@linux.microsoft.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Eric Chiang <ericchiang@google.com>,
	Florian Weimer <fweimer@redhat.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	James Morris <jmorris@namei.org>,
	Jan Kara <jack@suse.cz>,
	Jann Horn <jannh@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Kees Cook <keescook@chromium.org>,
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
	"Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
	Matthew Garrett <mjg59@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Paul Moore <paul@paul-moore.com>,
	=?UTF-8?q?Philippe=20Tr=C3=A9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
	Scott Shell <scottsh@microsoft.com>,
	Shuah Khan <shuah@kernel.org>,
	Steve Dower <steve.dower@python.org>,
	Steve Grubb <sgrubb@redhat.com>,
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
	Yin Fengwei <fengwei.yin@intel.com>,
	kernel-hardening@lists.openwall.com,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@linux.microsoft.com>
Subject: [PATCH v17 2/3] arch: Wire up trusted_for(2)
Date: Mon, 15 Nov 2021 19:53:03 +0100
Message-Id: <20211115185304.198460-3-mic@digikod.net>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115185304.198460-1-mic@digikod.net>
References: <20211115185304.198460-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mickaël Salaün <mic@linux.microsoft.com>

Wire up trusted_for(2) for all architectures.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Mickaël Salaün <mic@linux.microsoft.com>
Reviewed-by: Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20211115185304.198460-3-mic@digikod.net
---

Changes since v15:
* Update syscall IDs to align with the new futex_waitv.

Changes since v13:
* Add Reviewed-by Kees Cook.

Changes since v12:
* Update syscall IDs to align with the new ones.

Changes since v11:
* Add Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
* Rebase and leave space for watch_mount(2) and epoll_pwait2(2) from
  -next.

Changes since v9:
* Rename introspect_access(2) to trusted_for(2).
* Increase syscall number to leave space for memfd_secret(2) in -next.

Changes since v7:
* New patch for the new syscall.
* Increase syscall numbers by 2 to leave space for new ones (in
  linux-next): watch_mount(2) and process_madvise(2).
---
 arch/alpha/kernel/syscalls/syscall.tbl      | 2 ++
 arch/arm/tools/syscall.tbl                  | 1 +
 arch/arm64/include/asm/unistd.h             | 2 +-
 arch/arm64/include/asm/unistd32.h           | 2 ++
 arch/ia64/kernel/syscalls/syscall.tbl       | 2 ++
 arch/m68k/kernel/syscalls/syscall.tbl       | 2 ++
 arch/microblaze/kernel/syscalls/syscall.tbl | 2 ++
 arch/mips/kernel/syscalls/syscall_n32.tbl   | 2 ++
 arch/mips/kernel/syscalls/syscall_n64.tbl   | 2 ++
 arch/mips/kernel/syscalls/syscall_o32.tbl   | 2 ++
 arch/parisc/kernel/syscalls/syscall.tbl     | 2 ++
 arch/powerpc/kernel/syscalls/syscall.tbl    | 2 ++
 arch/s390/kernel/syscalls/syscall.tbl       | 2 ++
 arch/sh/kernel/syscalls/syscall.tbl         | 2 ++
 arch/sparc/kernel/syscalls/syscall.tbl      | 2 ++
 arch/x86/entry/syscalls/syscall_32.tbl      | 1 +
 arch/x86/entry/syscalls/syscall_64.tbl      | 1 +
 arch/xtensa/kernel/syscalls/syscall.tbl     | 2 ++
 include/uapi/asm-generic/unistd.h           | 4 +++-
 19 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/arch/alpha/kernel/syscalls/syscall.tbl b/arch/alpha/kernel/syscalls/syscall.tbl
index e4a041cd5715..7943ed6455a2 100644
--- a/arch/alpha/kernel/syscalls/syscall.tbl
+++ b/arch/alpha/kernel/syscalls/syscall.tbl
@@ -488,3 +488,5 @@
 556	common	landlock_restrict_self		sys_landlock_restrict_self
 # 557 reserved for memfd_secret
 558	common	process_mrelease		sys_process_mrelease
+# 559 reserved for futex_waitv
+560	common	trusted_for			sys_trusted_for
diff --git a/arch/arm/tools/syscall.tbl b/arch/arm/tools/syscall.tbl
index 543100151f2b..ccfd831bcb96 100644
--- a/arch/arm/tools/syscall.tbl
+++ b/arch/arm/tools/syscall.tbl
@@ -463,3 +463,4 @@
 # 447 reserved for memfd_secret
 448	common	process_mrelease		sys_process_mrelease
 449	common	futex_waitv			sys_futex_waitv
+450	common	trusted_for			sys_trusted_for
diff --git a/arch/arm64/include/asm/unistd.h b/arch/arm64/include/asm/unistd.h
index 6bdb5f5db438..4e65da3445c7 100644
--- a/arch/arm64/include/asm/unistd.h
+++ b/arch/arm64/include/asm/unistd.h
@@ -38,7 +38,7 @@
 #define __ARM_NR_compat_set_tls		(__ARM_NR_COMPAT_BASE + 5)
 #define __ARM_NR_COMPAT_END		(__ARM_NR_COMPAT_BASE + 0x800)
 
-#define __NR_compat_syscalls		450
+#define __NR_compat_syscalls		451
 #endif
 
 #define __ARCH_WANT_SYS_CLONE
diff --git a/arch/arm64/include/asm/unistd32.h b/arch/arm64/include/asm/unistd32.h
index 41ea1195e44b..0e69743609ff 100644
--- a/arch/arm64/include/asm/unistd32.h
+++ b/arch/arm64/include/asm/unistd32.h
@@ -905,6 +905,8 @@ __SYSCALL(__NR_landlock_restrict_self, sys_landlock_restrict_self)
 __SYSCALL(__NR_process_mrelease, sys_process_mrelease)
 #define __NR_futex_waitv 449
 __SYSCALL(__NR_futex_waitv, sys_futex_waitv)
+#define __NR_trusted_for 450
+__SYSCALL(__NR_trusted_for, sys_trusted_for)
 
 /*
  * Please add new compat syscalls above this comment and update
diff --git a/arch/ia64/kernel/syscalls/syscall.tbl b/arch/ia64/kernel/syscalls/syscall.tbl
index 6fea1844fb95..362c1e837bd6 100644
--- a/arch/ia64/kernel/syscalls/syscall.tbl
+++ b/arch/ia64/kernel/syscalls/syscall.tbl
@@ -369,3 +369,5 @@
 446	common	landlock_restrict_self		sys_landlock_restrict_self
 # 447 reserved for memfd_secret
 448	common	process_mrelease		sys_process_mrelease
+# 449 reserved for futex_waitv
+450	common	trusted_for			sys_trusted_for
diff --git a/arch/m68k/kernel/syscalls/syscall.tbl b/arch/m68k/kernel/syscalls/syscall.tbl
index 7976dff8f879..90306947817d 100644
--- a/arch/m68k/kernel/syscalls/syscall.tbl
+++ b/arch/m68k/kernel/syscalls/syscall.tbl
@@ -448,3 +448,5 @@
 446	common	landlock_restrict_self		sys_landlock_restrict_self
 # 447 reserved for memfd_secret
 448	common	process_mrelease		sys_process_mrelease
+# 449 reserved for futex_waitv
+450	common	trusted_for			sys_trusted_for
diff --git a/arch/microblaze/kernel/syscalls/syscall.tbl b/arch/microblaze/kernel/syscalls/syscall.tbl
index 6b0e11362bd2..8b19bbdaaf70 100644
--- a/arch/microblaze/kernel/syscalls/syscall.tbl
+++ b/arch/microblaze/kernel/syscalls/syscall.tbl
@@ -454,3 +454,5 @@
 446	common	landlock_restrict_self		sys_landlock_restrict_self
 # 447 reserved for memfd_secret
 448	common	process_mrelease		sys_process_mrelease
+# 449 reserved for futex_waitv
+450	common	trusted_for			sys_trusted_for
diff --git a/arch/mips/kernel/syscalls/syscall_n32.tbl b/arch/mips/kernel/syscalls/syscall_n32.tbl
index 70e32de2bcaa..1a84e8d1c776 100644
--- a/arch/mips/kernel/syscalls/syscall_n32.tbl
+++ b/arch/mips/kernel/syscalls/syscall_n32.tbl
@@ -387,3 +387,5 @@
 446	n32	landlock_restrict_self		sys_landlock_restrict_self
 # 447 reserved for memfd_secret
 448	n32	process_mrelease		sys_process_mrelease
+# 449 reserved for futex_waitv
+450	n32	trusted_for			sys_trusted_for
diff --git a/arch/mips/kernel/syscalls/syscall_n64.tbl b/arch/mips/kernel/syscalls/syscall_n64.tbl
index 1ca7bc337932..ced3db574de3 100644
--- a/arch/mips/kernel/syscalls/syscall_n64.tbl
+++ b/arch/mips/kernel/syscalls/syscall_n64.tbl
@@ -363,3 +363,5 @@
 446	n64	landlock_restrict_self		sys_landlock_restrict_self
 # 447 reserved for memfd_secret
 448	n64	process_mrelease		sys_process_mrelease
+# 449 reserved for futex_waitv
+450	n64	trusted_for			sys_trusted_for
diff --git a/arch/mips/kernel/syscalls/syscall_o32.tbl b/arch/mips/kernel/syscalls/syscall_o32.tbl
index a61c35edaa74..94b77adc6165 100644
--- a/arch/mips/kernel/syscalls/syscall_o32.tbl
+++ b/arch/mips/kernel/syscalls/syscall_o32.tbl
@@ -436,3 +436,5 @@
 446	o32	landlock_restrict_self		sys_landlock_restrict_self
 # 447 reserved for memfd_secret
 448	o32	process_mrelease		sys_process_mrelease
+# 449 reserved for futex_waitv
+450	o32	trusted_for			sys_trusted_for
diff --git a/arch/parisc/kernel/syscalls/syscall.tbl b/arch/parisc/kernel/syscalls/syscall.tbl
index bf751e0732b7..11de0c191a0e 100644
--- a/arch/parisc/kernel/syscalls/syscall.tbl
+++ b/arch/parisc/kernel/syscalls/syscall.tbl
@@ -446,3 +446,5 @@
 446	common	landlock_restrict_self		sys_landlock_restrict_self
 # 447 reserved for memfd_secret
 448	common	process_mrelease		sys_process_mrelease
+# 449 reserved for futex_waitv
+450	common	trusted_for			sys_trusted_for
diff --git a/arch/powerpc/kernel/syscalls/syscall.tbl b/arch/powerpc/kernel/syscalls/syscall.tbl
index 7bef917cc84e..b7337d3843a7 100644
--- a/arch/powerpc/kernel/syscalls/syscall.tbl
+++ b/arch/powerpc/kernel/syscalls/syscall.tbl
@@ -528,3 +528,5 @@
 446	common	landlock_restrict_self		sys_landlock_restrict_self
 # 447 reserved for memfd_secret
 448	common	process_mrelease		sys_process_mrelease
+# 449 reserved for futex_waitv
+450	common	trusted_for			sys_trusted_for
diff --git a/arch/s390/kernel/syscalls/syscall.tbl b/arch/s390/kernel/syscalls/syscall.tbl
index df5261e5cfe1..98bab648cda6 100644
--- a/arch/s390/kernel/syscalls/syscall.tbl
+++ b/arch/s390/kernel/syscalls/syscall.tbl
@@ -451,3 +451,5 @@
 446  common	landlock_restrict_self	sys_landlock_restrict_self	sys_landlock_restrict_self
 # 447 reserved for memfd_secret
 448  common	process_mrelease	sys_process_mrelease		sys_process_mrelease
+# 449 reserved for futex_waitv
+450  common	trusted_for		sys_trusted_for			sys_trusted_for
diff --git a/arch/sh/kernel/syscalls/syscall.tbl b/arch/sh/kernel/syscalls/syscall.tbl
index 208f131659c5..88c6cb3de23b 100644
--- a/arch/sh/kernel/syscalls/syscall.tbl
+++ b/arch/sh/kernel/syscalls/syscall.tbl
@@ -451,3 +451,5 @@
 446	common	landlock_restrict_self		sys_landlock_restrict_self
 # 447 reserved for memfd_secret
 448	common	process_mrelease		sys_process_mrelease
+# 449 reserved for futex_waitv
+450	common	trusted_for			sys_trusted_for
diff --git a/arch/sparc/kernel/syscalls/syscall.tbl b/arch/sparc/kernel/syscalls/syscall.tbl
index c37764dc764d..b0db960c5897 100644
--- a/arch/sparc/kernel/syscalls/syscall.tbl
+++ b/arch/sparc/kernel/syscalls/syscall.tbl
@@ -494,3 +494,5 @@
 446	common	landlock_restrict_self		sys_landlock_restrict_self
 # 447 reserved for memfd_secret
 448	common	process_mrelease		sys_process_mrelease
+# 449 reserved for futex_waitv
+450	common	trusted_for			sys_trusted_for
diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index 7e25543693de..2f230c04f8a7 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -454,3 +454,4 @@
 447	i386	memfd_secret		sys_memfd_secret
 448	i386	process_mrelease	sys_process_mrelease
 449	i386	futex_waitv		sys_futex_waitv
+450	i386	trusted_for		sys_trusted_for
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index fe8f8dd157b4..678ab13ee1c1 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -371,6 +371,7 @@
 447	common	memfd_secret		sys_memfd_secret
 448	common	process_mrelease	sys_process_mrelease
 449	common	futex_waitv		sys_futex_waitv
+450	common	trusted_for		sys_trusted_for
 
 #
 # Due to a historical design error, certain syscalls are numbered differently
diff --git a/arch/xtensa/kernel/syscalls/syscall.tbl b/arch/xtensa/kernel/syscalls/syscall.tbl
index 104b327f8ac9..9dab1dfffc95 100644
--- a/arch/xtensa/kernel/syscalls/syscall.tbl
+++ b/arch/xtensa/kernel/syscalls/syscall.tbl
@@ -419,3 +419,5 @@
 446	common	landlock_restrict_self		sys_landlock_restrict_self
 # 447 reserved for memfd_secret
 448	common	process_mrelease		sys_process_mrelease
+# 449 reserved for futex_waitv
+450	common	trusted_for			sys_trusted_for
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index 4557a8b6086f..ded7a49616f2 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -882,9 +882,11 @@ __SYSCALL(__NR_process_mrelease, sys_process_mrelease)
 
 #define __NR_futex_waitv 449
 __SYSCALL(__NR_futex_waitv, sys_futex_waitv)
+#define __NR_trusted_for 450
+__SYSCALL(__NR_trusted_for, sys_trusted_for)
 
 #undef __NR_syscalls
-#define __NR_syscalls 450
+#define __NR_syscalls 451
 
 /*
  * 32 bit systems traditionally used different
-- 
2.33.1

