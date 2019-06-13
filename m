Return-Path: <kernel-hardening-return-16126-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id A737A43588
	for <lists+kernel-hardening@lfdr.de>; Thu, 13 Jun 2019 13:32:12 +0200 (CEST)
Received: (qmail 18119 invoked by uid 550); 13 Jun 2019 11:32:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 9271 invoked from network); 13 Jun 2019 11:26:21 -0000
From: Yann Droneaud <ydroneaud@opteya.com>
To: linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Kees Cook <keescook@chromium.org>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Yann Droneaud <ydroneaud@opteya.com>
Date: Thu, 13 Jun 2019 13:26:03 +0200
Message-Id: <cover.1560423331.git.ydroneaud@opteya.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a01:e35:39f2:1220:9dd7:c176:119b:4c9d
X-SA-Exim-Mail-From: ydroneaud@opteya.com
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on ou.quest-ce.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00
	autolearn=ham version=3.3.2
Subject: [PATCH 0/3] ELF interpretor info: align and add random padding
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on ou.quest-ce.net)

Hi,

The following patches are mostly focused on ensuring AT_RANDOM array is
aligned on 16bytes boundary, and while being located at a pseudo-random
offset on stack (at most 256 bytes).

This patchset also insert a random sized (at most 15 bytes) padding between
AT_RANDOM and AT_PLATFORM and/or AT_BASE_PLATFORM.

It also insert a random sized padding (at most 256 bytes) between those
data and the arrays passed to userspace (argv[] + environ[] + auxv[])
as defined by ABI.

Adding random padding around AT_RANDOM, AT_PLATFORM, AT_BASE_PLATEFORM
should be viewed as an exercise of cargo-cult security as I'm not aware
of any attack that can be prevented with this mechanism in place.

Regards.

Yann Droneaud (3):
  binfmt/elf: use functions for stack manipulation
  binfmt/elf: align AT_RANDOM array
  binfmt/elf: randomize padding between ELF interp info

 fs/binfmt_elf.c | 110 +++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 86 insertions(+), 24 deletions(-)

-- 
2.21.0

