Return-Path: <kernel-hardening-return-19311-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id ACD2721F902
	for <lists+kernel-hardening@lfdr.de>; Tue, 14 Jul 2020 20:17:15 +0200 (CEST)
Received: (qmail 2016 invoked by uid 550); 14 Jul 2020 18:17:02 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1961 invoked from network); 14 Jul 2020 18:17:01 -0000
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Aleksa Sarai <cyphar@cyphar.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	Christian Heimes <christian@python.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Deven Bowers <deven.desai@linux.microsoft.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Eric Chiang <ericchiang@google.com>,
	Florian Weimer <fweimer@redhat.com>,
	James Morris <jmorris@namei.org>,
	Jan Kara <jack@suse.cz>,
	Jann Horn <jannh@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Kees Cook <keescook@chromium.org>,
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
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
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
	kernel-hardening@lists.openwall.com,
	linux-api@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v6 1/7] exec: Change uselib(2) IS_SREG() failure to EACCES
Date: Tue, 14 Jul 2020 20:16:32 +0200
Message-Id: <20200714181638.45751-2-mic@digikod.net>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714181638.45751-1-mic@digikod.net>
References: <20200714181638.45751-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Antivirus: Dr.Web (R) for Unix mail servers drweb plugin ver.6.0.2.8
X-Antivirus-Code: 0x100000

From: Kees Cook <keescook@chromium.org>

Change uselib(2)' S_ISREG() error return to EACCES instead of EINVAL so
the behavior matches execve(2), and the seemingly documented value.
The "not a regular file" failure mode of execve(2) is explicitly
documented[1], but it is not mentioned in uselib(2)[2] which does,
however, say that open(2) and mmap(2) errors may apply. The documentation
for open(2) does not include a "not a regular file" error[3], but mmap(2)
does[4], and it is EACCES.

[1] http://man7.org/linux/man-pages/man2/execve.2.html#ERRORS
[2] http://man7.org/linux/man-pages/man2/uselib.2.html#ERRORS
[3] http://man7.org/linux/man-pages/man2/open.2.html#ERRORS
[4] http://man7.org/linux/man-pages/man2/mmap.2.html#ERRORS

Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Acked-by: Mickaël Salaün <mic@digikod.net>
Link: https://lore.kernel.org/r/20200605160013.3954297-2-keescook@chromium.org
---
 fs/exec.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index e6e8a9a70327..d7c937044d10 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -141,11 +141,10 @@ SYSCALL_DEFINE1(uselib, const char __user *, library)
 	if (IS_ERR(file))
 		goto out;
 
-	error = -EINVAL;
+	error = -EACCES;
 	if (!S_ISREG(file_inode(file)->i_mode))
 		goto exit;
 
-	error = -EACCES;
 	if (path_noexec(&file->f_path))
 		goto exit;
 
-- 
2.27.0

