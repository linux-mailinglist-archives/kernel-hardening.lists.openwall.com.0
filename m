Return-Path: <kernel-hardening-return-20312-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 7D62D2A3055
	for <lists+kernel-hardening@lfdr.de>; Mon,  2 Nov 2020 17:52:52 +0100 (CET)
Received: (qmail 16306 invoked by uid 550); 2 Nov 2020 16:52:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 16282 invoked from network); 2 Nov 2020 16:52:41 -0000
From: Alexey Gladkov <gladkov.alexey@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
	Linux Containers <containers@lists.linux-foundation.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Cc: Alexey Gladkov <legion@kernel.org>,
	"Eric W . Biederman" <ebiederm@xmission.com>,
	Kees Cook <keescook@chromium.org>,
	Christian Brauner <christian@brauner.io>
Subject: [RFC PATCH v1 0/4] Per user namespace rlimits
Date: Mon,  2 Nov 2020 17:50:29 +0100
Message-Id: <cover.1604335819.git.gladkov.alexey@gmail.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.1 (raptor.unsafe.ru [5.9.43.93]); Mon, 02 Nov 2020 16:52:29 +0000 (UTC)

Preface
-------
These patches are for binding the rlimits to a user in the user namespace.
This patch set can be applied on top of:

git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git v5.8-2-g43e210d68200

Problem
-------
Some rlimits are set per user: RLIMIT_NPROC, RLIMIT_MEMLOCK, RLIMIT_SIGPENDING,
RLIMIT_MSGQUEUE. When several containers are created from one user then
the processes inside the containers influence each other.

Eric W. Biederman mentioned this issue [1][2][3].

Introduced changes
------------------
To fix this problem, you can bind the counter of the specified rlimits to the
user within the user namespace. By default, to preserve backward compatibility,
only the initial user namespace is used. This patch adds one more prctl
parameter to change the binding to the user namespace.

This will not cause the user to take more resources than allowed in the parent
user namespace because it only virtualizes the rlimit counter. Limits in all
parent user namespaces are taken into account.

For example, this allows us to run multiple containers by the same user and
set the RLIMIT_NPROC to 1 inside.

ToDo
----
* RLIMIT_MEMLOCK, RLIMIT_SIGPENDING and RLIMIT_MSGQUEUE are not implemented.
* No documentation.
* No tests.

[1] https://lore.kernel.org/containers/87imd2incs.fsf@x220.int.ebiederm.org/
[2] https://lists.linuxfoundation.org/pipermail/containers/2020-August/042096.html
[3] https://lists.linuxfoundation.org/pipermail/containers/2020-October/042524.html

Changelog
---------
v1:
* After discussion with Eric W. Biederman, I increased the size of ucounts to
  atomic_long_t.
* Added ucount_max to avoid the fork bomb.

--

Alexey Gladkov (4):
  Increase size of ucounts to atomic_long_t
  Move the user's process counter to ucounts
  Do not allow fork if RLIMIT_NPROC is exceeded in the user namespace
    tree
  Allow to change the user namespace in which user rlimits are counted

 fs/exec.c                      | 13 ++++++---
 fs/io-wq.c                     | 25 +++++++++++++-----
 fs/io-wq.h                     |  1 +
 fs/io_uring.c                  |  1 +
 include/linux/cred.h           |  8 ++++++
 include/linux/sched.h          |  3 +++
 include/linux/sched/user.h     |  1 -
 include/linux/user_namespace.h | 12 +++++++--
 include/uapi/linux/prctl.h     |  5 ++++
 kernel/cred.c                  | 44 ++++++++++++++++++++++++-------
 kernel/exit.c                  |  2 +-
 kernel/fork.c                  | 13 ++++++---
 kernel/sys.c                   | 26 ++++++++++++++++--
 kernel/ucount.c                | 48 +++++++++++++++++++++++++++++-----
 kernel/user.c                  |  3 ++-
 kernel/user_namespace.c        |  3 +++
 16 files changed, 171 insertions(+), 37 deletions(-)

-- 
2.25.4

