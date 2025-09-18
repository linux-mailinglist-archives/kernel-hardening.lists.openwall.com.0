Return-Path: <kernel-hardening-return-21962-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by mail.lfdr.de (Postfix) with SMTP id A157EB32113
	for <lists+kernel-hardening@lfdr.de>; Fri, 22 Aug 2025 19:08:29 +0200 (CEST)
Received: (qmail 23818 invoked by uid 550); 22 Aug 2025 17:08:19 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 23786 invoked from network); 22 Aug 2025 17:08:19 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1755882489;
	bh=NUlPE+heYCOxk91D6n6N1q+wkFLg9BAFfbEyk2M2p7s=;
	h=From:To:Cc:Subject:Date:From;
	b=hG5HIpVSutSZRtsFd06T355DYxH9qGfeUrqxCfDId/uv7nj6uXVjPRBf18tBMYdh4
	 J6MiUTTm1h4vs8d4xuZbZYXJlYRjshhhkRv5DqPl8As0hFQMoU8Fji4LbbavOEzeD6
	 pu8JGqfHl0XehVrNxAaaC0/jXXueFPe5Q8Oj6srA=
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To: Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Paul Moore <paul@paul-moore.com>,
	Serge Hallyn <serge@hallyn.com>
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Andy Lutomirski <luto@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Heimes <christian@python.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	Elliott Hughes <enh@google.com>,
	Fan Wu <wufan@linux.microsoft.com>,
	Florian Weimer <fweimer@redhat.com>,
	Jann Horn <jannh@google.com>,
	Jeff Xu <jeffxu@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Jordan R Abrahams <ajordanr@google.com>,
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
	Luca Boccassi <bluca@debian.org>,
	Matt Bobrowski <mattbobrowski@google.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Nicolas Bouchinet <nicolas.bouchinet@oss.cyber.gouv.fr>,
	Robert Waite <rowait@microsoft.com>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Scott Shell <scottsh@microsoft.com>,
	Steve Dower <steve.dower@python.org>,
	Steve Grubb <sgrubb@redhat.com>,
	kernel-hardening@lists.openwall.com,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org
Subject: [RFC PATCH v1 0/2] Add O_DENY_WRITE (complement AT_EXECVE_CHECK)
Date: Fri, 22 Aug 2025 19:07:58 +0200
Message-ID: <20250822170800.2116980-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha

Hi,

Script interpreters can check if a file would be allowed to be executed
by the kernel using the new AT_EXECVE_CHECK flag. This approach works
well on systems with write-xor-execute policies, where scripts cannot
be modified by malicious processes. However, this protection may not be
available on more generic distributions.

The key difference between `./script.sh` and `sh script.sh` (when using
AT_EXECVE_CHECK) is that execve(2) prevents the script from being opened
for writing while it's being executed. To achieve parity, the kernel
should provide a mechanism for script interpreters to deny write access
during script interpretation. While interpreters can copy script content
into a buffer, a race condition remains possible after AT_EXECVE_CHECK.

This patch series introduces a new O_DENY_WRITE flag for use with
open*(2) and fcntl(2). Both interfaces are necessary since script
interpreters may receive either a file path or file descriptor. For
backward compatibility, open(2) with O_DENY_WRITE will not fail on
unsupported systems, while users requiring explicit support guarantees
can use openat2(2).

The check_exec.rst documentation and related examples do not mention this new
feature yet.

Regards,

Mickaël Salaün (2):
  fs: Add O_DENY_WRITE
  selftests/exec: Add O_DENY_WRITE tests

 fs/fcntl.c                                |  26 ++-
 fs/file_table.c                           |   2 +
 fs/namei.c                                |   6 +
 include/linux/fcntl.h                     |   2 +-
 include/uapi/asm-generic/fcntl.h          |   4 +
 tools/testing/selftests/exec/check-exec.c | 219 ++++++++++++++++++++++
 6 files changed, 256 insertions(+), 3 deletions(-)


base-commit: c17b750b3ad9f45f2b6f7e6f7f4679844244f0b9
-- 
2.50.1

