Return-Path: <kernel-hardening-return-20925-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 5554B337083
	for <lists+kernel-hardening@lfdr.de>; Thu, 11 Mar 2021 11:53:11 +0100 (CET)
Received: (qmail 1991 invoked by uid 550); 11 Mar 2021 10:53:05 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1968 invoked from network); 11 Mar 2021 10:53:04 -0000
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To: Al Viro <viro@zeniv.linux.org.uk>,
	James Morris <jmorris@namei.org>,
	Serge Hallyn <serge@hallyn.com>
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Andy Lutomirski <luto@amacapital.net>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	Christoph Hellwig <hch@lst.de>,
	David Howells <dhowells@redhat.com>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	"Eric W . Biederman" <ebiederm@xmission.com>,
	John Johansen <john.johansen@canonical.com>,
	Kees Cook <keescook@chromium.org>,
	Kentaro Takeda <takedakn@nttdata.co.jp>,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	kernel-hardening@lists.openwall.com,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org
Subject: [PATCH v3 0/1] Unprivileged chroot
Date: Thu, 11 Mar 2021 11:52:41 +0100
Message-Id: <20210311105242.874506-1-mic@digikod.net>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

This new patch replaces the path_is_under() check with
current_chrooted() as it is done with user namespaces.  Indeed, it is
much more simple to check the current root instead of limiting access to
a subset of files.

The chroot system call is currently limited to be used by processes with
the CAP_SYS_CHROOT capability.  This protects against malicious
procesess willing to trick SUID-like binaries.  The following patch
allows unprivileged users to safely use chroot(2), which may be
complementary to the use of user namespaces.

This patch is a follow-up of a previous one sent by Andy Lutomirski some
time ago:
https://lore.kernel.org/lkml/0e2f0f54e19bff53a3739ecfddb4ffa9a6dbde4d.1327858005.git.luto@amacapital.net/

This patch can be applied on top of v5.12-rc2 .  I would really
appreciate constructive reviews.

Previous version:
https://lore.kernel.org/r/20210310181857.401675-1-mic@digikod.net

Regards,

Mickaël Salaün (1):
  fs: Allow no_new_privs tasks to call chroot(2)

 fs/open.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)


base-commit: a38fd8748464831584a19438cbb3082b5a2dab15
-- 
2.30.2

