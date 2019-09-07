Return-Path: <kernel-hardening-return-16869-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 28DC7AC4DA
	for <lists+kernel-hardening@lfdr.de>; Sat,  7 Sep 2019 08:08:24 +0200 (CEST)
Received: (qmail 12038 invoked by uid 550); 7 Sep 2019 06:08:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 12001 invoked from network); 7 Sep 2019 06:08:15 -0000
From: "Christopher M. Riedl" <cmr@informatik.wtf>
To: linuxppc-dev@ozlabs.org,
	kernel-hardening@lists.openwall.com
Cc: ajd@linux.ibm.com,
	dja@axtens.net
Subject: [PATCH v7 0/2] Restrict xmon when kernel is locked down
Date: Sat,  7 Sep 2019 01:11:22 -0500
Message-Id: <20190907061124.1947-1-cmr@informatik.wtf>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP

Xmon should be either fully or partially disabled depending on the
kernel lockdown state.

Put xmon into read-only mode for lockdown=integrity and completely
disable xmon when lockdown=confidentiality. Since this can occur
dynamically, there may be pre-existing, active breakpoints in xmon when
transitioning into read-only mode. These breakpoints will still trigger,
so allow them to be listed and cleared using xmon.

Changes since v6:
 - Add lockdown check in sysrq-trigger to prevent entry into xmon_core
 - Add lockdown check during init xmon setup for the case when booting
   with compile-time or cmdline lockdown=confidentialiaty

Changes since v5:
 - Do not spam print messages when attempting to enter xmon when
   lockdown=confidentiality

Changes since v4:
 - Move lockdown state checks into xmon_core
 - Allow clearing of breakpoints in xmon read-only mode
 - Test simple scenarios (combinations of xmon and lockdown cmdline
   options, setting breakpoints and changing lockdown state, etc) in
   QEMU and on an actual POWER8 VM
 - Rebase onto security/next-lockdown
   b602614a81078bf29c82b2671bb96a63488f68d6

Changes since v3:
 - Allow active breakpoints to be shown/listed in read-only mode

Changes since v2:
 - Rebased onto v36 of https://patchwork.kernel.org/cover/11049461/
   (based on: f632a8170a6b667ee4e3f552087588f0fe13c4bb)
 - Do not clear existing breakpoints when transitioning from
   lockdown=none to lockdown=integrity
 - Remove line continuation and dangling quote (confuses checkpatch.pl)
   from the xmon command help/usage string

Christopher M. Riedl (2):
  powerpc/xmon: Allow listing and clearing breakpoints in read-only mode
  powerpc/xmon: Restrict when kernel is locked down

 arch/powerpc/xmon/xmon.c     | 119 +++++++++++++++++++++++++++--------
 include/linux/security.h     |   2 +
 security/lockdown/lockdown.c |   2 +
 3 files changed, 97 insertions(+), 26 deletions(-)

-- 
2.23.0

