Return-Path: <kernel-hardening-return-20908-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 47CBA33428A
	for <lists+kernel-hardening@lfdr.de>; Wed, 10 Mar 2021 17:10:38 +0100 (CET)
Received: (qmail 10173 invoked by uid 550); 10 Mar 2021 16:10:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 10135 invoked from network); 10 Mar 2021 16:10:30 -0000
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To: Al Viro <viro@zeniv.linux.org.uk>,
	James Morris <jmorris@namei.org>,
	Serge Hallyn <serge@hallyn.com>
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Andy Lutomirski <luto@amacapital.net>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	Christoph Hellwig <hch@lst.de>,
	David Howells <dhowells@redhat.com>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Eric Biederman <ebiederm@xmission.com>,
	John Johansen <john.johansen@canonical.com>,
	Kees Cook <keescook@chromium.org>,
	Kentaro Takeda <takedakn@nttdata.co.jp>,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	kernel-hardening@lists.openwall.com,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org
Subject: [PATCH v1 0/1] Unprivileged chroot
Date: Wed, 10 Mar 2021 17:09:59 +0100
Message-Id: <20210310161000.382796-1-mic@digikod.net>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

The chroot system call is currently limited to be used by processes with
the CAP_SYS_CHROOT capability.  This protects against malicious
procesess willing to trick SUID-like binaries.  The following patch
allows unprivileged users to safely use chroot(2).

This patch is a follow-up of a previous one sent by Andy Lutomirski some
time ago:
https://lore.kernel.org/lkml/0e2f0f54e19bff53a3739ecfddb4ffa9a6dbde4d.1327858005.git.luto@amacapital.net/

This patch can be applied on top of v5.12-rc2 .  I would really
appreciate constructive reviews.

Regards,

Mickaël Salaün (1):
  fs: Allow no_new_privs tasks to call chroot(2)

 fs/open.c | 64 ++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 61 insertions(+), 3 deletions(-)


base-commit: a38fd8748464831584a19438cbb3082b5a2dab15
-- 
2.30.2

