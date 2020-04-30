Return-Path: <kernel-hardening-return-18690-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 0BE271BF972
	for <lists+kernel-hardening@lfdr.de>; Thu, 30 Apr 2020 15:24:58 +0200 (CEST)
Received: (qmail 19892 invoked by uid 550); 30 Apr 2020 13:24:04 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 19835 invoked from network); 30 Apr 2020 13:24:04 -0000
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Aleksa Sarai <cyphar@cyphar.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@kernel.org>,
	Christian Heimes <christian@python.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Deven Bowers <deven.desai@linux.microsoft.com>,
	Eric Chiang <ericchiang@google.com>,
	Florian Weimer <fweimer@redhat.com>,
	James Morris <jmorris@namei.org>,
	Jan Kara <jack@suse.cz>,
	Jann Horn <jannh@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Kees Cook <keescook@chromium.org>,
	Matthew Garrett <mjg59@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mickael.salaun@ssi.gouv.fr>,
	Mimi Zohar <zohar@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Tr=C3=A9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
	Scott Shell <scottsh@microsoft.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Shuah Khan <shuah@kernel.org>,
	Steve Dower <steve.dower@python.org>,
	Steve Grubb <sgrubb@redhat.com>,
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
	kernel-hardening@lists.openwall.com,
	linux-api@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v4 5/5] doc: Add documentation for the fs.open_mayexec_enforce sysctl
Date: Thu, 30 Apr 2020 15:23:20 +0200
Message-Id: <20200430132320.699508-6-mic@digikod.net>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200430132320.699508-1-mic@digikod.net>
References: <20200430132320.699508-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Antivirus: Dr.Web (R) for Unix mail servers drweb plugin ver.6.0.2.8
X-Antivirus-Code: 0x100000

This sysctl enables to propagate executable permission to userspace
thanks to the O_MAYEXEC flag.

Signed-off-by: Mickaël Salaün <mic@digikod.net>
Reviewed-by: Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kees Cook <keescook@chromium.org>
---

Changes since v3:
* Switch back to O_MAYEXEC and highlight that it is only taken into
  account by openat2(2).

Changes since v2:
* Update documentation with the new RESOLVE_MAYEXEC.
* Improve explanations, including concerns about LD_PRELOAD.

Changes since v1:
* Move from LSM/Yama to sysctl/fs .
---
 Documentation/admin-guide/sysctl/fs.rst | 44 +++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/Documentation/admin-guide/sysctl/fs.rst b/Documentation/admin-guide/sysctl/fs.rst
index 2a45119e3331..d55615c36772 100644
--- a/Documentation/admin-guide/sysctl/fs.rst
+++ b/Documentation/admin-guide/sysctl/fs.rst
@@ -37,6 +37,7 @@ Currently, these files are in /proc/sys/fs:
 - inode-nr
 - inode-state
 - nr_open
+- open_mayexec_enforce
 - overflowuid
 - overflowgid
 - pipe-user-pages-hard
@@ -165,6 +166,49 @@ system needs to prune the inode list instead of allocating
 more.
 
 
+open_mayexec_enforce
+--------------------
+
+While being ignored by :manpage:`open(2)` and :manpage:`openat(2)`, the
+``O_MAYEXEC`` flag can be passed to :manpage:`openat2(2)` to only open regular
+files that are expected to be executable.  If the file is not identified as
+executable, then the syscall returns -EACCES.  This may allow a script
+interpreter to check executable permission before reading commands from a file,
+or a dynamic linker to only load executable shared objects.  One interesting
+use case is to enforce a "write xor execute" policy through interpreters.
+
+The ability to restrict code execution must be thought as a system-wide policy,
+which first starts by restricting mount points with the ``noexec`` option.
+This option is also automatically applied to special filesystems such as /proc
+.  This prevents files on such mount points to be directly executed by the
+kernel or mapped as executable memory (e.g. libraries).  With script
+interpreters using the ``O_MAYEXEC`` flag, the executable permission can then
+be checked before reading commands from files. This makes it possible to
+enforce the ``noexec`` at the interpreter level, and thus propagates this
+security policy to scripts.  To be fully effective, these interpreters also
+need to handle the other ways to execute code: command line parameters (e.g.,
+option ``-e`` for Perl), module loading (e.g., option ``-m`` for Python),
+stdin, file sourcing, environment variables, configuration files, etc.
+According to the threat model, it may be acceptable to allow some script
+interpreters (e.g. Bash) to interpret commands from stdin, may it be a TTY or a
+pipe, because it may not be enough to (directly) perform syscalls.
+
+There are two complementary security policies: enforce the ``noexec`` mount
+option, and enforce executable file permission.  These policies are handled by
+the ``fs.open_mayexec_enforce`` sysctl (writable only with ``CAP_MAC_ADMIN``)
+as a bitmask:
+
+1 - Mount restriction: checks that the mount options for the underlying VFS
+    mount do not prevent execution.
+
+2 - File permission restriction: checks that the to-be-opened file is marked as
+    executable for the current process (e.g., POSIX permissions).
+
+Code samples can be found in tools/testing/selftests/openat2/omayexec_test.c
+and at
+https://github.com/clipos-archive/clipos4_portage-overlay/search?q=O_MAYEXEC .
+
+
 overflowgid & overflowuid
 -------------------------
 
-- 
2.26.2

