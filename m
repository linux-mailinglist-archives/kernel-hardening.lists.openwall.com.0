Return-Path: <kernel-hardening-return-16841-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id DF21BABC58
	for <lists+kernel-hardening@lfdr.de>; Fri,  6 Sep 2019 17:26:45 +0200 (CEST)
Received: (qmail 20473 invoked by uid 550); 6 Sep 2019 15:26:20 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 20222 invoked from network); 6 Sep 2019 15:26:17 -0000
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
        Aleksa Sarai <cyphar@cyphar.com>, Alexei Starovoitov <ast@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>,
        Christian Heimes <christian@python.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Chiang <ericchiang@google.com>,
        Florian Weimer <fweimer@redhat.com>, James Morris <jmorris@namei.org>,
        Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>,
        Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>,
        Matthew Garrett <mjg59@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mickael.salaun@ssi.gouv.fr>,
        Mimi Zohar <zohar@linux.ibm.com>,
        =?UTF-8?q?Philippe=20Tr=C3=A9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
        Scott Shell <scottsh@microsoft.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Shuah Khan <shuah@kernel.org>, Song Liu <songliubraving@fb.com>,
        Steve Dower <steve.dower@python.org>, Steve Grubb <sgrubb@redhat.com>,
        Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
        Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
        Yves-Alexis Perez <yves-alexis.perez@ssi.gouv.fr>,
        kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 0/5] Add support for O_MAYEXEC
Date: Fri,  6 Sep 2019 17:24:50 +0200
Message-Id: <20190906152455.22757-1-mic@digikod.net>
X-Mailer: git-send-email 2.23.0.rc1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Antivirus: Dr.Web (R) for Unix mail servers drweb plugin ver.6.0.2.8
X-Antivirus-Code: 0x100000

Hi,

The goal of this patch series is to control script interpretation.  A
new O_MAYEXEC flag used by sys_open() is added to enable userspace
script interpreter to delegate to the kernel (and thus the system
security policy) the permission to interpret/execute scripts or other
files containing what can be seen as commands.

This second series mainly differ from the previous one [1] by moving the
basic security policy from Yama to the filesystem subsystem.  This
policy can be enforced by the system administrator through a sysctl
configuration consistent with the mount points.

Furthermore, the security policy can also be delegated to an LSM, either
a MAC system or an integrity system.  For instance, the new kernel
MAY_OPENEXEC flag closes a major IMA measurement/appraisal interpreter
integrity gap by bringing the ability to check the use of scripts [2].
Other uses are expected, such as for openat2(2) [3], SGX integration
[4], and bpffs [5].

Userspace need to adapt to take advantage of this new feature.  For
example, the PEP 578 [6] (Runtime Audit Hooks) enables Python 3.8 to be
extended with policy enforcement points related to code interpretation,
which can be used to align with the PowerShell audit features.
Additional Python security improvements (e.g. a limited interpreter
withou -c, stdin piping of code) are on their way.

The initial idea come from CLIP OS and the original implementation has
been used for more than 10 years:
https://github.com/clipos-archive/clipos4_doc

An introduction to O_MAYEXEC was given at the Linux Security Summit
Europe 2018 - Linux Kernel Security Contributions by ANSSI:
https://www.youtube.com/watch?v=chNjCRtPKQY&t=17m15s
The "write xor execute" principle was explained at Kernel Recipes 2018 -
CLIP OS: a defense-in-depth OS:
https://www.youtube.com/watch?v=PjRE0uBtkHU&t=11m14s

This patch series can be applied on top of v5.3-rc7.  This can be tested
with CONFIG_SYSCTL.  I would really appreciate constructive comments on
this patch series.


# Changes since v1

* move code from Yama to the FS subsystem
* set __FMODE_EXEC when using O_MAYEXEC to make this information
  available through the new fanotify/FAN_OPEN_EXEC event
* only match regular files (not directories nor other types), which
  follows the same semantic as commit 73601ea5b7b1 ("fs/open.c: allow
  opening only regular files during execve()")
* improve tests

[1] https://lore.kernel.org/lkml/20181212081712.32347-1-mic@digikod.net/
[2] https://lore.kernel.org/lkml/1544647356.4028.105.camel@linux.ibm.com/
[3] https://lore.kernel.org/lkml/20190904201933.10736-6-cyphar@cyphar.com/
[4] https://lore.kernel.org/lkml/CALCETrVovr8XNZSroey7pHF46O=kj_c5D9K8h=z2T_cNrpvMig@mail.gmail.com/
[5] https://lore.kernel.org/lkml/CALCETrVeZ0eufFXwfhtaG_j+AdvbzEWE0M3wjXMWVEO7pj+xkw@mail.gmail.com/
[6] https://www.python.org/dev/peps/pep-0578/

Regards,

Mickaël Salaün (5):
  fs: Add support for an O_MAYEXEC flag on sys_open()
  fs: Add a MAY_EXECMOUNT flag to infer the noexec mount propertie
  fs: Enable to enforce noexec mounts or file exec through O_MAYEXEC
  selftest/exec: Add tests for O_MAYEXEC enforcing
  doc: Add documentation for the fs.open_mayexec_enforce sysctl

 Documentation/admin-guide/sysctl/fs.rst     |  43 +++
 fs/fcntl.c                                  |   2 +-
 fs/namei.c                                  |  70 +++++
 fs/open.c                                   |   6 +
 include/linux/fcntl.h                       |   2 +-
 include/linux/fs.h                          |   7 +
 include/uapi/asm-generic/fcntl.h            |   3 +
 kernel/sysctl.c                             |   7 +
 tools/testing/selftests/exec/.gitignore     |   1 +
 tools/testing/selftests/exec/Makefile       |   4 +-
 tools/testing/selftests/exec/omayexec.c     | 317 ++++++++++++++++++++
 tools/testing/selftests/kselftest_harness.h |   3 +
 12 files changed, 462 insertions(+), 3 deletions(-)
 create mode 100644 tools/testing/selftests/exec/omayexec.c

-- 
2.23.0

