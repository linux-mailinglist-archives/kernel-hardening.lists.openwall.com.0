Return-Path: <kernel-hardening-return-20697-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 0610C3003A7
	for <lists+kernel-hardening@lfdr.de>; Fri, 22 Jan 2021 14:02:27 +0100 (CET)
Received: (qmail 11398 invoked by uid 550); 22 Jan 2021 13:01:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 10154 invoked from network); 22 Jan 2021 13:01:14 -0000
From: Alexey Gladkov <gladkov.alexey@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
	io-uring@vger.kernel.org,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Linux Containers <containers@lists.linux-foundation.org>,
	linux-mm@kvack.org
Cc: Alexey Gladkov <legion@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	"Eric W . Biederman" <ebiederm@xmission.com>,
	Jann Horn <jannh@google.com>,
	Jens Axboe <axboe@kernel.dk>,
	Kees Cook <keescook@chromium.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH v4 7/7] kselftests: Add test to check for rlimit changes in different user namespaces
Date: Fri, 22 Jan 2021 14:00:16 +0100
Message-Id: <50be4be55c030a02ac5244a07d6ef3ea8f1cd15a.1611320161.git.gladkov.alexey@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1611320161.git.gladkov.alexey@gmail.com>
References: <cover.1611320161.git.gladkov.alexey@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.1 (raptor.unsafe.ru [5.9.43.93]); Fri, 22 Jan 2021 13:00:55 +0000 (UTC)

The testcase runs few instances of the program with RLIMIT_NPROC=1 from
user uid=60000, in different user namespaces.

Signed-off-by: Alexey Gladkov <gladkov.alexey@gmail.com>
---
 tools/testing/selftests/Makefile              |   1 +
 tools/testing/selftests/rlimits/.gitignore    |   2 +
 tools/testing/selftests/rlimits/Makefile      |   6 +
 tools/testing/selftests/rlimits/config        |   1 +
 .../selftests/rlimits/rlimits-per-userns.c    | 161 ++++++++++++++++++
 5 files changed, 171 insertions(+)
 create mode 100644 tools/testing/selftests/rlimits/.gitignore
 create mode 100644 tools/testing/selftests/rlimits/Makefile
 create mode 100644 tools/testing/selftests/rlimits/config
 create mode 100644 tools/testing/selftests/rlimits/rlimits-per-userns.c

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index afbab4aeef3c..4dbeb5686f7b 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -46,6 +46,7 @@ TARGETS += proc
 TARGETS += pstore
 TARGETS += ptrace
 TARGETS += openat2
+TARGETS += rlimits
 TARGETS += rseq
 TARGETS += rtc
 TARGETS += seccomp
diff --git a/tools/testing/selftests/rlimits/.gitignore b/tools/testing/selftests/rlimits/.gitignore
new file mode 100644
index 000000000000..091021f255b3
--- /dev/null
+++ b/tools/testing/selftests/rlimits/.gitignore
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0-only
+rlimits-per-userns
diff --git a/tools/testing/selftests/rlimits/Makefile b/tools/testing/selftests/rlimits/Makefile
new file mode 100644
index 000000000000..03aadb406212
--- /dev/null
+++ b/tools/testing/selftests/rlimits/Makefile
@@ -0,0 +1,6 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+
+CFLAGS += -Wall -O2 -g
+TEST_GEN_PROGS := rlimits-per-userns
+
+include ../lib.mk
diff --git a/tools/testing/selftests/rlimits/config b/tools/testing/selftests/rlimits/config
new file mode 100644
index 000000000000..416bd53ce982
--- /dev/null
+++ b/tools/testing/selftests/rlimits/config
@@ -0,0 +1 @@
+CONFIG_USER_NS=y
diff --git a/tools/testing/selftests/rlimits/rlimits-per-userns.c b/tools/testing/selftests/rlimits/rlimits-per-userns.c
new file mode 100644
index 000000000000..26dc949e93ea
--- /dev/null
+++ b/tools/testing/selftests/rlimits/rlimits-per-userns.c
@@ -0,0 +1,161 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Author: Alexey Gladkov <gladkov.alexey@gmail.com>
+ */
+#define _GNU_SOURCE
+#include <sys/types.h>
+#include <sys/wait.h>
+#include <sys/time.h>
+#include <sys/resource.h>
+#include <sys/prctl.h>
+#include <sys/stat.h>
+
+#include <unistd.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <string.h>
+#include <sched.h>
+#include <signal.h>
+#include <limits.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <err.h>
+
+#define NR_CHILDS 2
+
+static char *service_prog;
+static uid_t user   = 60000;
+static uid_t group  = 60000;
+
+static void setrlimit_nproc(rlim_t n)
+{
+	pid_t pid = getpid();
+	struct rlimit limit = {
+		.rlim_cur = n,
+		.rlim_max = n
+	};
+
+	warnx("(pid=%d): Setting RLIMIT_NPROC=%ld", pid, n);
+
+	if (setrlimit(RLIMIT_NPROC, &limit) < 0)
+		err(EXIT_FAILURE, "(pid=%d): setrlimit(RLIMIT_NPROC)", pid);
+}
+
+static pid_t fork_child(void)
+{
+	pid_t pid = fork();
+
+	if (pid < 0)
+		err(EXIT_FAILURE, "fork");
+
+	if (pid > 0)
+		return pid;
+
+	pid = getpid();
+
+	warnx("(pid=%d): New process starting ...", pid);
+
+	if (prctl(PR_SET_PDEATHSIG, SIGKILL) < 0)
+		err(EXIT_FAILURE, "(pid=%d): prctl(PR_SET_PDEATHSIG)", pid);
+
+	signal(SIGUSR1, SIG_DFL);
+
+	warnx("(pid=%d): Changing to uid=%d, gid=%d", pid, user, group);
+
+	if (setgid(group) < 0)
+		err(EXIT_FAILURE, "(pid=%d): setgid(%d)", pid, group);
+	if (setuid(user) < 0)
+		err(EXIT_FAILURE, "(pid=%d): setuid(%d)", pid, user);
+
+	warnx("(pid=%d): Service running ...", pid);
+
+	warnx("(pid=%d): Unshare user namespace", pid);
+	if (unshare(CLONE_NEWUSER) < 0)
+		err(EXIT_FAILURE, "unshare(CLONE_NEWUSER)");
+
+	char *const argv[] = { "service", NULL };
+	char *const envp[] = { "I_AM_SERVICE=1", NULL };
+
+	warnx("(pid=%d): Executing real service ...", pid);
+
+	execve(service_prog, argv, envp);
+	err(EXIT_FAILURE, "(pid=%d): execve", pid);
+}
+
+int main(int argc, char **argv)
+{
+	size_t i;
+	pid_t child[NR_CHILDS];
+	int wstatus[NR_CHILDS];
+	int childs = NR_CHILDS;
+	pid_t pid;
+
+	if (getenv("I_AM_SERVICE")) {
+		pause();
+		exit(EXIT_SUCCESS);
+	}
+
+	service_prog = argv[0];
+	pid = getpid();
+
+	warnx("(pid=%d) Starting testcase", pid);
+
+	/*
+	 * This rlimit is not a problem for root because it can be exceeded.
+	 */
+	setrlimit_nproc(1);
+
+	for (i = 0; i < NR_CHILDS; i++) {
+		child[i] = fork_child();
+		wstatus[i] = 0;
+		usleep(250000);
+	}
+
+	while (1) {
+		for (i = 0; i < NR_CHILDS; i++) {
+			if (child[i] <= 0)
+				continue;
+
+			errno = 0;
+			pid_t ret = waitpid(child[i], &wstatus[i], WNOHANG);
+
+			if (!ret || (!WIFEXITED(wstatus[i]) && !WIFSIGNALED(wstatus[i])))
+				continue;
+
+			if (ret < 0 && errno != ECHILD)
+				warn("(pid=%d): waitpid(%d)", pid, child[i]);
+
+			child[i] *= -1;
+			childs -= 1;
+		}
+
+		if (!childs)
+			break;
+
+		usleep(250000);
+
+		for (i = 0; i < NR_CHILDS; i++) {
+			if (child[i] <= 0)
+				continue;
+			kill(child[i], SIGUSR1);
+		}
+	}
+
+	for (i = 0; i < NR_CHILDS; i++) {
+		if (WIFEXITED(wstatus[i]))
+			warnx("(pid=%d): pid %d exited, status=%d",
+				pid, -child[i], WEXITSTATUS(wstatus[i]));
+		else if (WIFSIGNALED(wstatus[i]))
+			warnx("(pid=%d): pid %d killed by signal %d",
+				pid, -child[i], WTERMSIG(wstatus[i]));
+
+		if (WIFSIGNALED(wstatus[i]) && WTERMSIG(wstatus[i]) == SIGUSR1)
+			continue;
+
+		warnx("(pid=%d): Test failed", pid);
+		exit(EXIT_FAILURE);
+	}
+
+	warnx("(pid=%d): Test passed", pid);
+	exit(EXIT_SUCCESS);
+}
-- 
2.29.2

