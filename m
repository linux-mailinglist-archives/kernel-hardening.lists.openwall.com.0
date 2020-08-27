Return-Path: <kernel-hardening-return-19690-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 0C47325461F
	for <lists+kernel-hardening@lfdr.de>; Thu, 27 Aug 2020 15:41:19 +0200 (CEST)
Received: (qmail 22193 invoked by uid 550); 27 Aug 2020 13:41:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 22172 invoked from network); 27 Aug 2020 13:41:12 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1598535660;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=3kTaC7Koe/EnnFofVOMX9+NxqY3+OHKyUa+e0ym9rLY=;
	b=NFiZq1ZF5AzVXmc8LpBXRbMZqdy/rhnk1L+/ew98zvoc1SrquoF8qhGRz/YREBLBr56xUh
	vC3U+odwtKmMrjH2SGGC1DPOUt0wTrH8F2yEwBkE/WBgaHYvtmuCwspRKmNW+FUGkOmUwx
	CAVD0Nh9w5scN8NeaJGF/N9TFuFfnrQ=
X-MC-Unique: 1b2BLQODPwSPJVSK4YyNIg-1
From: Stefano Garzarella <sgarzare@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Aleksa Sarai <asarai@suse.de>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Jann Horn <jannh@google.com>,
	io-uring@vger.kernel.org,
	Christian Brauner <christian.brauner@ubuntu.com>,
	linux-fsdevel@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	linux-kernel@vger.kernel.org,
	Sargun Dhillon <sargun@sargun.me>,
	Kees Cook <keescook@chromium.org>,
	Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH v5 0/3] io_uring: add restrictions to support untrusted
 applications and guests
Date: Thu, 27 Aug 2020 15:40:41 +0200
Message-Id: <20200827134044.82821-1-sgarzare@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11

v5:
 - explicitly assigned enum values [Kees]
 - replaced kmalloc/copy_from_user with memdup_user [kernel test robot]
 - added Kees' R-b tags

v4: https://lore.kernel.org/io-uring/20200813153254.93731-1-sgarzare@redhat.com/
v3: https://lore.kernel.org/io-uring/20200728160101.48554-1-sgarzare@redhat.com/
RFC v2: https://lore.kernel.org/io-uring/20200716124833.93667-1-sgarzare@redhat.com
RFC v1: https://lore.kernel.org/io-uring/20200710141945.129329-1-sgarzare@redhat.com

Following the proposal that I send about restrictions [1], I wrote this series
to add restrictions in io_uring.

I also wrote helpers in liburing and a test case (test/register-restrictions.c)
available in this repository:
https://github.com/stefano-garzarella/liburing (branch: io_uring_restrictions)

Just to recap the proposal, the idea is to add some restrictions to the
operations (sqe opcode and flags, register opcode) to safely allow untrusted
applications or guests to use io_uring queues.

The first patch changes io_uring_register(2) opcodes into an enumeration to
keep track of the last opcode available.

The second patch adds IOURING_REGISTER_RESTRICTIONS opcode and the code to
handle restrictions.

The third patch adds IORING_SETUP_R_DISABLED flag to start the rings disabled,
allowing the user to register restrictions, buffers, files, before to start
processing SQEs.

Comments and suggestions are very welcome.

Thank you in advance,
Stefano

[1] https://lore.kernel.org/io-uring/20200609142406.upuwpfmgqjeji4lc@steredhat/

Stefano Garzarella (3):
  io_uring: use an enumeration for io_uring_register(2) opcodes
  io_uring: add IOURING_REGISTER_RESTRICTIONS opcode
  io_uring: allow disabling rings during the creation

 fs/io_uring.c                 | 155 ++++++++++++++++++++++++++++++++--
 include/uapi/linux/io_uring.h |  60 ++++++++++---
 2 files changed, 198 insertions(+), 17 deletions(-)

-- 
2.26.2

