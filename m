Return-Path: <kernel-hardening-return-21837-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by mail.lfdr.de (Postfix) with SMTP id 94BF199AB44
	for <lists+kernel-hardening@lfdr.de>; Fri, 11 Oct 2024 20:46:07 +0200 (CEST)
Received: (qmail 11801 invoked by uid 550); 11 Oct 2024 18:44:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 11757 invoked from network); 11 Oct 2024 18:44:55 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1728672287;
	bh=z8VzaCq/UYqHGlvynkVHXwnIimRiVgUcmF7oZT7reaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CJYkvWVeMuesQV6WOA0R0mE+p0jTFhgYjhTGQiGQkAluRiv0kT0I2/2S1BotwDqwK
	 miGpk2chDBmMCYu2fP77s6T/KTZZhvCTqHQ81RFY1i7LromL5bd0iYeYnhuv8JI52l
	 wbYwO0UogFZHEts+aBodOWslqfyM71TebaiaCwh4=
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To: Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Paul Moore <paul@paul-moore.com>,
	Serge Hallyn <serge@hallyn.com>,
	Theodore Ts'o <tytso@mit.edu>
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
	Alejandro Colomar <alx@kernel.org>,
	Aleksa Sarai <cyphar@cyphar.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Christian Heimes <christian@python.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	Elliott Hughes <enh@google.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Eric Chiang <ericchiang@google.com>,
	Fan Wu <wufan@linux.microsoft.com>,
	Florian Weimer <fweimer@redhat.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	James Morris <jamorris@linux.microsoft.com>,
	Jan Kara <jack@suse.cz>,
	Jann Horn <jannh@google.com>,
	Jeff Xu <jeffxu@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Jordan R Abrahams <ajordanr@google.com>,
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
	Luca Boccassi <bluca@debian.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	"Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
	Matt Bobrowski <mattbobrowski@google.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Matthew Wilcox <willy@infradead.org>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>,
	Scott Shell <scottsh@microsoft.com>,
	Shuah Khan <shuah@kernel.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Steve Dower <steve.dower@python.org>,
	Steve Grubb <sgrubb@redhat.com>,
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
	Xiaoming Ni <nixiaoming@huawei.com>,
	Yin Fengwei <fengwei.yin@intel.com>,
	kernel-hardening@lists.openwall.com,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org
Subject: [PATCH v20 6/6] samples/check-exec: Add an enlighten "inc" interpreter and 28 tests
Date: Fri, 11 Oct 2024 20:44:22 +0200
Message-ID: <20241011184422.977903-7-mic@digikod.net>
In-Reply-To: <20241011184422.977903-1-mic@digikod.net>
References: <20241011184422.977903-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha

Add a very simple script interpreter called "inc" that can evaluate two
different commands (one per line):
- "?" to initialize a counter from user's input;
- "+" to increment the counter (which is set to 0 by default).

It is enlighten to only interpret executable files according to AT_CHECK
and the related securebits:

  # Executing a script with RESTRICT_FILE is only allowed if the script
  # is exectuable:
  ./set-exec -f -- ./inc script-exec.inc # Allowed
  ./set-exec -f -- ./inc script-noexec.inc # Denied

  # Executing stdin with DENY_INTERACTIVE is only allowed if stdin is an
  # executable regular file:
  ./set-exec -i -- ./inc -i < script-exec.inc # Allowed
  ./set-exec -i -- ./inc -i < script-noexec.inc # Denied

  # However, a pipe is not executable and it is then denied:
  cat script-noexec.inc | ./set-exec -i -- ./inc -i # Denied

  # Executing raw data (e.g. command argument) with DENY_INTERACTIVE is
  # always denied.
  ./set-exec -i -- ./inc -c "+" # Denied
  ./inc -c "$(<script-ask.inc)" # Allowed

  # To directly execute a script, we can update $PATH (used by `env`):
  PATH="${PATH}:." ./script-exec.inc

  # To execute several commands passed as argument:

Add a complete test suite to check the script interpreter against all
possible execution cases:

  make TARGETS=exec kselftest-install
  ./tools/testing/selftests/kselftest_install/run_kselftest.sh

Fix ktap_helpers.sh to gracefully ignore optional argument.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Serge Hallyn <serge@hallyn.com>
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Link: https://lore.kernel.org/r/20241011184422.977903-7-mic@digikod.net
---

Changes since v19:
* New patch.
---
 samples/Kconfig                               |   3 +-
 samples/check-exec/.gitignore                 |   1 +
 samples/check-exec/Makefile                   |   1 +
 samples/check-exec/inc.c                      | 204 +++++++++++++++++
 samples/check-exec/run-script-ask.inc         |   8 +
 samples/check-exec/script-ask.inc             |   4 +
 samples/check-exec/script-exec.inc            |   3 +
 samples/check-exec/script-noexec.inc          |   3 +
 tools/testing/selftests/exec/.gitignore       |   2 +
 tools/testing/selftests/exec/Makefile         |  14 +-
 .../selftests/exec/check-exec-tests.sh        | 205 ++++++++++++++++++
 .../selftests/kselftest/ktap_helpers.sh       |   2 +-
 12 files changed, 446 insertions(+), 4 deletions(-)
 create mode 100644 samples/check-exec/inc.c
 create mode 100755 samples/check-exec/run-script-ask.inc
 create mode 100755 samples/check-exec/script-ask.inc
 create mode 100755 samples/check-exec/script-exec.inc
 create mode 100644 samples/check-exec/script-noexec.inc
 create mode 100755 tools/testing/selftests/exec/check-exec-tests.sh

diff --git a/samples/Kconfig b/samples/Kconfig
index efa28ceadc42..0128cc68deed 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -296,7 +296,8 @@ config SAMPLE_CHECK_EXEC
 	depends on CC_CAN_LINK && HEADERS_INSTALL
 	help
 	  Build a tool to easily configure SECBIT_EXEC_RESTRICT_FILE and
-	  SECBIT_EXEC_DENY_INTERACTIVE.
+	  SECBIT_EXEC_DENY_INTERACTIVE, and a simple script interpreter to
+	  demonstrate how they should be used with execveat(2) + AT_CHECK.
 
 source "samples/rust/Kconfig"
 
diff --git a/samples/check-exec/.gitignore b/samples/check-exec/.gitignore
index 3f8119112ccf..cd759a19dacd 100644
--- a/samples/check-exec/.gitignore
+++ b/samples/check-exec/.gitignore
@@ -1 +1,2 @@
+/inc
 /set-exec
diff --git a/samples/check-exec/Makefile b/samples/check-exec/Makefile
index d9f976e3ff98..c4f08ad0f8e3 100644
--- a/samples/check-exec/Makefile
+++ b/samples/check-exec/Makefile
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: BSD-3-Clause
 
 userprogs-always-y := \
+	inc \
 	set-exec
 
 userccflags += -I usr/include
diff --git a/samples/check-exec/inc.c b/samples/check-exec/inc.c
new file mode 100644
index 000000000000..0710a860f360
--- /dev/null
+++ b/samples/check-exec/inc.c
@@ -0,0 +1,204 @@
+// SPDX-License-Identifier: BSD-3-Clause
+/*
+ * Very simple script interpreter that can evaluate two different commands (one
+ * per line):
+ * - "?" to initialize a counter from user's input;
+ * - "+" to increment the counter (which is set to 0 by default).
+ *
+ * See tools/testing/selftests/exec/check-exec-tests.sh
+ *
+ * Copyright © 2024 Microsoft Corporation
+ */
+
+#define _GNU_SOURCE
+#include <errno.h>
+#include <linux/fcntl.h>
+#include <linux/prctl.h>
+#include <linux/securebits.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/prctl.h>
+#include <unistd.h>
+
+/* Returns 1 on error, 0 otherwise. */
+static int interpret_buffer(char *buffer, size_t buffer_size)
+{
+	char *line, *saveptr = NULL;
+	long long number = 0;
+
+	/* Each command is the first character of a line. */
+	saveptr = NULL;
+	line = strtok_r(buffer, "\n", &saveptr);
+	while (line) {
+		if (*line != '#' && strlen(line) != 1) {
+			fprintf(stderr, "# ERROR: Unknown string\n");
+			return 1;
+		}
+		switch (*line) {
+		case '#':
+			/* Skips shebang and comments. */
+			break;
+		case '+':
+			/* Increments and prints the number. */
+			number++;
+			printf("%lld\n", number);
+			break;
+		case '?':
+			/* Reads integer from stdin. */
+			fprintf(stderr, "> Enter new number: \n");
+			if (scanf("%lld", &number) != 1) {
+				fprintf(stderr,
+					"# WARNING: Failed to read number from stdin\n");
+			}
+			break;
+		default:
+			fprintf(stderr, "# ERROR: Unknown character '%c'\n",
+				*line);
+			return 1;
+		}
+		line = strtok_r(NULL, "\n", &saveptr);
+	}
+	return 0;
+}
+
+/* Returns 1 on error, 0 otherwise. */
+static int interpret_stream(FILE *script, char *const script_name,
+			    char *const *const envp, const bool restrict_stream)
+{
+	int err;
+	char *const script_argv[] = { script_name, NULL };
+	char buf[128] = {};
+	size_t buf_size = sizeof(buf);
+
+	/*
+	 * We pass a valid argv and envp to the kernel to emulate a native
+	 * script execution.  We must use the script file descriptor instead of
+	 * the script path name to avoid race conditions.
+	 */
+	err = execveat(fileno(script), "", script_argv, envp,
+		       AT_EMPTY_PATH | AT_CHECK);
+	if (err && restrict_stream) {
+		perror("ERROR: Script execution check");
+		return 1;
+	}
+
+	/* Reads script. */
+	buf_size = fread(buf, 1, buf_size - 1, script);
+	return interpret_buffer(buf, buf_size);
+}
+
+static void print_usage(const char *argv0)
+{
+	fprintf(stderr, "usage: %s <script.inc> | -i | -c <command>\n\n",
+		argv0);
+	fprintf(stderr, "Example:\n");
+	fprintf(stderr, "  ./set-exec -fi -- ./inc -i < script-exec.inc\n");
+}
+
+int main(const int argc, char *const argv[], char *const *const envp)
+{
+	int opt;
+	char *cmd = NULL;
+	char *script_name = NULL;
+	bool interpret_stdin = false;
+	FILE *script_file = NULL;
+	int secbits;
+	bool deny_interactive, restrict_file;
+	size_t arg_nb;
+
+	secbits = prctl(PR_GET_SECUREBITS);
+	if (secbits == -1) {
+		/*
+		 * This should never happen, except with a buggy seccomp
+		 * filter.
+		 */
+		perror("ERROR: Failed to get securebits");
+		return 1;
+	}
+
+	deny_interactive = !!(secbits & SECBIT_EXEC_DENY_INTERACTIVE);
+	restrict_file = !!(secbits & SECBIT_EXEC_RESTRICT_FILE);
+
+	while ((opt = getopt(argc, argv, "c:i")) != -1) {
+		switch (opt) {
+		case 'c':
+			if (cmd) {
+				fprintf(stderr, "ERROR: Command already set");
+				return 1;
+			}
+			cmd = optarg;
+			break;
+		case 'i':
+			interpret_stdin = true;
+			break;
+		default:
+			print_usage(argv[0]);
+			return 1;
+		}
+	}
+
+	/* Checks that only one argument is used, or read stdin. */
+	arg_nb = !!cmd + !!interpret_stdin;
+	if (arg_nb == 0 && argc == 2) {
+		script_name = argv[1];
+	} else if (arg_nb != 1) {
+		print_usage(argv[0]);
+		return 1;
+	}
+
+	if (cmd) {
+		/*
+		 * Other kind of interactive interpretations should be denied
+		 * as well (e.g. CLI arguments passing script snippets,
+		 * environment variables interpreted as script).  However, any
+		 * way to pass script files should only be restricted according
+		 * to restrict_file.
+		 */
+		if (deny_interactive) {
+			fprintf(stderr,
+				"ERROR: Interactive interpretation denied.\n");
+			return 1;
+		}
+
+		return interpret_buffer(cmd, strlen(cmd));
+	}
+
+	if (interpret_stdin && !script_name) {
+		script_file = stdin;
+		/*
+		 * As for any execve(2) call, this path may be logged by the
+		 * kernel.
+		 */
+		script_name = "/proc/self/fd/0";
+		/*
+		 * When stdin is used, it can point to a regular file or a
+		 * pipe.  Restrict stdin execution according to
+		 * SECBIT_EXEC_DENY_INTERACTIVE but always allow executable
+		 * files (which are not considered as interactive inputs).
+		 */
+		return interpret_stream(script_file, script_name, envp,
+					deny_interactive);
+	} else if (script_name && !interpret_stdin) {
+		/*
+		 * In this sample, we don't pass any argument to scripts, but
+		 * otherwise we would have to forge an argv with such
+		 * arguments.
+		 */
+		script_file = fopen(script_name, "r");
+		if (!script_file) {
+			perror("ERROR: Failed to open script");
+			return 1;
+		}
+		/*
+		 * Restricts file execution according to
+		 * SECBIT_EXEC_RESTRICT_FILE.
+		 */
+		return interpret_stream(script_file, script_name, envp,
+					restrict_file);
+	}
+
+	print_usage(argv[0]);
+	return 1;
+}
diff --git a/samples/check-exec/run-script-ask.inc b/samples/check-exec/run-script-ask.inc
new file mode 100755
index 000000000000..3ea3e15fbd5a
--- /dev/null
+++ b/samples/check-exec/run-script-ask.inc
@@ -0,0 +1,8 @@
+#!/usr/bin/env sh
+
+DIR="$(dirname -- "$0")"
+
+PATH="${PATH}:${DIR}"
+
+set -x
+"${DIR}/script-ask.inc"
diff --git a/samples/check-exec/script-ask.inc b/samples/check-exec/script-ask.inc
new file mode 100755
index 000000000000..f48252ab07c1
--- /dev/null
+++ b/samples/check-exec/script-ask.inc
@@ -0,0 +1,4 @@
+#!/usr/bin/env inc
+
+?
++
diff --git a/samples/check-exec/script-exec.inc b/samples/check-exec/script-exec.inc
new file mode 100755
index 000000000000..525e958e1c20
--- /dev/null
+++ b/samples/check-exec/script-exec.inc
@@ -0,0 +1,3 @@
+#!/usr/bin/env inc
+
++
diff --git a/samples/check-exec/script-noexec.inc b/samples/check-exec/script-noexec.inc
new file mode 100644
index 000000000000..525e958e1c20
--- /dev/null
+++ b/samples/check-exec/script-noexec.inc
@@ -0,0 +1,3 @@
+#!/usr/bin/env inc
+
++
diff --git a/tools/testing/selftests/exec/.gitignore b/tools/testing/selftests/exec/.gitignore
index a32c63bb4df1..7f3d1ae762ec 100644
--- a/tools/testing/selftests/exec/.gitignore
+++ b/tools/testing/selftests/exec/.gitignore
@@ -11,9 +11,11 @@ non-regular
 null-argv
 /check-exec
 /false
+/inc
 /load_address.*
 !load_address.c
 /recursion-depth
+/set-exec
 xxxxxxxx*
 pipe
 S_I*.test
diff --git a/tools/testing/selftests/exec/Makefile b/tools/testing/selftests/exec/Makefile
index 8713d1c862ae..45a3cfc435cf 100644
--- a/tools/testing/selftests/exec/Makefile
+++ b/tools/testing/selftests/exec/Makefile
@@ -10,9 +10,9 @@ ALIGN_PIES        := $(patsubst %,load_address.%,$(ALIGNS))
 ALIGN_STATIC_PIES := $(patsubst %,load_address.static.%,$(ALIGNS))
 ALIGNMENT_TESTS   := $(ALIGN_PIES) $(ALIGN_STATIC_PIES)
 
-TEST_PROGS := binfmt_script.py
+TEST_PROGS := binfmt_script.py check-exec-tests.sh
 TEST_GEN_PROGS := execveat non-regular $(ALIGNMENT_TESTS)
-TEST_GEN_PROGS_EXTENDED := false
+TEST_GEN_PROGS_EXTENDED := false inc set-exec script-exec.inc script-noexec.inc
 TEST_GEN_FILES := execveat.symlink execveat.denatured script subdir
 # Makefile is a run-time dependency, since it's accessed by the execveat test
 TEST_FILES := Makefile
@@ -26,6 +26,8 @@ EXTRA_CLEAN := $(OUTPUT)/subdir.moved $(OUTPUT)/execveat.moved $(OUTPUT)/xxxxx*
 
 include ../lib.mk
 
+CHECK_EXEC_SAMPLES := $(top_srcdir)/samples/check-exec
+
 $(OUTPUT)/subdir:
 	mkdir -p $@
 $(OUTPUT)/script: Makefile
@@ -45,3 +47,11 @@ $(OUTPUT)/load_address.static.0x%: load_address.c
 		-fPIE -static-pie $< -o $@
 $(OUTPUT)/false: false.c
 	$(CC) $(CFLAGS) $(LDFLAGS) -static $< -o $@
+$(OUTPUT)/inc: $(CHECK_EXEC_SAMPLES)/inc.c
+	$(CC) $(CFLAGS) $(LDFLAGS) $< -o $@
+$(OUTPUT)/set-exec: $(CHECK_EXEC_SAMPLES)/set-exec.c
+	$(CC) $(CFLAGS) $(LDFLAGS) $< -o $@
+$(OUTPUT)/script-exec.inc: $(CHECK_EXEC_SAMPLES)/script-exec.inc
+	cp $< $@
+$(OUTPUT)/script-noexec.inc: $(CHECK_EXEC_SAMPLES)/script-noexec.inc
+	cp $< $@
diff --git a/tools/testing/selftests/exec/check-exec-tests.sh b/tools/testing/selftests/exec/check-exec-tests.sh
new file mode 100755
index 000000000000..87102906ae3c
--- /dev/null
+++ b/tools/testing/selftests/exec/check-exec-tests.sh
@@ -0,0 +1,205 @@
+#!/usr/bin/env bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Test the "inc" interpreter.
+#
+# See include/uapi/linux/securebits.h, include/uapi/linux/fcntl.h and
+# samples/check-exec/inc.c
+#
+# Copyright © 2024 Microsoft Corporation
+
+set -u -e -o pipefail
+
+EXPECTED_OUTPUT="1"
+exec 2>/dev/null
+
+DIR="$(dirname $(readlink -f "$0"))"
+source "${DIR}"/../kselftest/ktap_helpers.sh
+
+exec_direct() {
+	local expect="$1"
+	local script="$2"
+	shift 2
+	local ret=0
+	local out
+
+	# Updates PATH for `env` to execute the `inc` interpreter.
+	out="$(PATH="." "$@" "${script}")" || ret=$?
+
+	if [[ ${ret} -ne ${expect} ]]; then
+		echo "ERROR: Wrong expectation for direct file execution: ${ret}"
+		return 1
+	fi
+	if [[ ${ret} -eq 0 && "${out}" != "${EXPECTED_OUTPUT}" ]]; then
+		echo "ERROR: Wrong output for direct file execution: ${out}"
+		return 1
+	fi
+}
+
+exec_indirect() {
+	local expect="$1"
+	local script="$2"
+	shift 2
+	local ret=0
+	local out
+
+	# Script passed as argument.
+	out="$("$@" ./inc "${script}")" || ret=$?
+
+	if [[ ${ret} -ne ${expect} ]]; then
+		echo "ERROR: Wrong expectation for indirect file execution: ${ret}"
+		return 1
+	fi
+	if [[ ${ret} -eq 0 && "${out}" != "${EXPECTED_OUTPUT}" ]]; then
+		echo "ERROR: Wrong output for indirect file execution: ${out}"
+		return 1
+	fi
+}
+
+exec_stdin_reg() {
+	local expect="$1"
+	local script="$2"
+	shift 2
+	local ret=0
+	local out
+
+	# Executing stdin must be allowed if the related file is executable.
+	out="$("$@" ./inc -i < "${script}")" || ret=$?
+
+	if [[ ${ret} -ne ${expect} ]]; then
+		echo "ERROR: Wrong expectation for stdin regular file execution: ${ret}"
+		return 1
+	fi
+	if [[ ${ret} -eq 0 && "${out}" != "${EXPECTED_OUTPUT}" ]]; then
+		echo "ERROR: Wrong output for stdin regular file execution: ${out}"
+		return 1
+	fi
+}
+
+exec_stdin_pipe() {
+	local expect="$1"
+	shift
+	local ret=0
+	local out
+
+	# A pipe is not executable.
+	out="$(cat script-exec.inc | "$@" ./inc -i)" || ret=$?
+
+	if [[ ${ret} -ne ${expect} ]]; then
+		echo "ERROR: Wrong expectation for stdin pipe execution: ${ret}"
+		return 1
+	fi
+}
+
+exec_argument() {
+	local expect="$1"
+	local ret=0
+	shift
+	local out
+
+	# Script not coming from a file must not be executed.
+	out="$("$@" ./inc -c "$(< script-exec.inc)")" || ret=$?
+
+	if [[ ${ret} -ne ${expect} ]]; then
+		echo "ERROR: Wrong expectation for arbitrary argument execution: ${ret}"
+		return 1
+	fi
+	if [[ ${ret} -eq 0 && "${out}" != "${EXPECTED_OUTPUT}" ]]; then
+		echo "ERROR: Wrong output for arbitrary argument execution: ${out}"
+		return 1
+	fi
+}
+
+exec_interactive() {
+	exec_stdin_pipe "$@"
+	exec_argument "$@"
+}
+
+ktap_test() {
+	ktap_test_result "$*" "$@"
+}
+
+ktap_print_header
+ktap_set_plan 28
+
+# Without secbit configuration, nothing is changed.
+
+ktap_print_msg "By default, executable scripts are allowed to be interpreted and executed."
+ktap_test exec_direct 0 script-exec.inc
+ktap_test exec_indirect 0 script-exec.inc
+
+ktap_print_msg "By default, executable stdin is allowed to be interpreted."
+ktap_test exec_stdin_reg 0 script-exec.inc
+
+ktap_print_msg "By default, non-executable scripts are allowed to be interpreted, but not directly executed."
+# We get 126 because of direct execution by Bash.
+ktap_test exec_direct 126 script-noexec.inc
+ktap_test exec_indirect 0 script-noexec.inc
+
+ktap_print_msg "By default, non-executable stdin is allowed to be interpreted."
+ktap_test exec_stdin_reg 0 script-noexec.inc
+
+ktap_print_msg "By default, interactive commands are allowed to be interpreted."
+ktap_test exec_interactive 0
+
+# With only file restriction: protect non-malicious users from inadvertent errors (e.g. python ~/Downloads/*.py).
+
+ktap_print_msg "With -f, executable scripts are allowed to be interpreted and executed."
+ktap_test exec_direct 0 script-exec.inc ./set-exec -f --
+ktap_test exec_indirect 0 script-exec.inc ./set-exec -f --
+
+ktap_print_msg "With -f, executable stdin is allowed to be interpreted."
+ktap_test exec_stdin_reg 0 script-exec.inc ./set-exec -f --
+
+ktap_print_msg "With -f, non-executable scripts are not allowed to be executed nor interpreted."
+# Direct execution of non-executable script is alwayse denied by the kernel.
+ktap_test exec_direct 1 script-noexec.inc ./set-exec -f --
+ktap_test exec_indirect 1 script-noexec.inc ./set-exec -f --
+
+ktap_print_msg "With -f, non-executable stdin is allowed to be interpreted."
+ktap_test exec_stdin_reg 0 script-noexec.inc ./set-exec -f --
+
+ktap_print_msg "With -f, interactive commands are allowed to be interpreted."
+ktap_test exec_interactive 0 ./set-exec -f --
+
+# With only denied interactive commands: check or monitor script content (e.g. with LSM).
+
+ktap_print_msg "With -i, executable scripts are allowed to be interpreted and executed."
+ktap_test exec_direct 0 script-exec.inc ./set-exec -i --
+ktap_test exec_indirect 0 script-exec.inc ./set-exec -i --
+
+ktap_print_msg "With -i, executable stdin is allowed to be interpreted."
+ktap_test exec_stdin_reg 0 script-exec.inc ./set-exec -i --
+
+ktap_print_msg "With -i, non-executable scripts are allowed to be interpreted, but not directly executed."
+# Direct execution of non-executable script is alwayse denied by the kernel.
+ktap_test exec_direct 1 script-noexec.inc ./set-exec -i --
+ktap_test exec_indirect 0 script-noexec.inc ./set-exec -i --
+
+ktap_print_msg "With -i, non-executable stdin is not allowed to be interpreted."
+ktap_test exec_stdin_reg 1 script-noexec.inc ./set-exec -i --
+
+ktap_print_msg "With -i, interactive commands are not allowed to be interpreted."
+ktap_test exec_interactive 1 ./set-exec -i --
+
+# With both file restriction and denied interactive commands: only allow executable scripts.
+
+ktap_print_msg "With -fi, executable scripts are allowed to be interpreted and executed."
+ktap_test exec_direct 0 script-exec.inc ./set-exec -fi --
+ktap_test exec_indirect 0 script-exec.inc ./set-exec -fi --
+
+ktap_print_msg "With -fi, executable stdin is allowed to be interpreted."
+ktap_test exec_stdin_reg 0 script-exec.inc ./set-exec -fi --
+
+ktap_print_msg "With -fi, non-executable scripts are not allowed to be interpreted nor executed."
+# Direct execution of non-executable script is alwayse denied by the kernel.
+ktap_test exec_direct 1 script-noexec.inc ./set-exec -fi --
+ktap_test exec_indirect 1 script-noexec.inc ./set-exec -fi --
+
+ktap_print_msg "With -fi, non-executable stdin is not allowed to be interpreted."
+ktap_test exec_stdin_reg 1 script-noexec.inc ./set-exec -fi --
+
+ktap_print_msg "With -fi, interactive commands are not allowed to be interpreted."
+ktap_test exec_interactive 1 ./set-exec -fi --
+
+ktap_finished
diff --git a/tools/testing/selftests/kselftest/ktap_helpers.sh b/tools/testing/selftests/kselftest/ktap_helpers.sh
index 79a125eb24c2..14e7f3ec3f84 100644
--- a/tools/testing/selftests/kselftest/ktap_helpers.sh
+++ b/tools/testing/selftests/kselftest/ktap_helpers.sh
@@ -40,7 +40,7 @@ ktap_skip_all() {
 __ktap_test() {
 	result="$1"
 	description="$2"
-	directive="$3" # optional
+	directive="${3:-}" # optional
 
 	local directive_str=
 	[ ! -z "$directive" ] && directive_str="# $directive"
-- 
2.46.1

