Return-Path: <kernel-hardening-return-19625-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 044E2243C92
	for <lists+kernel-hardening@lfdr.de>; Thu, 13 Aug 2020 17:34:04 +0200 (CEST)
Received: (qmail 13362 invoked by uid 550); 13 Aug 2020 15:33:58 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 13342 invoked from network); 13 Aug 2020 15:33:57 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1597332825;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=U+DZxetMKI4jVQKv/cLX0z4HNCC6l+3oyJGtLYHcX8o=;
	b=XAWewq3B9ffElLPLK8aqXEdtA0lEYNv0TEcNPEvzuPpuKkqxxXovnF9IBkamQqxqnwOH5d
	vbaiYgvvqm0SkxTxkI0w1i/SA50l6SAEi0TPTa0z0WXMiD5c3dNd4H8VCRVQTV4MerO89+
	qCIVor4oyVizlmurC+dje/EROwsSDUU=
X-MC-Unique: rFiyPInxM7CpmkqnLbRD4g-1
From: Stefano Garzarella <sgarzare@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christian Brauner <christian.brauner@ubuntu.com>,
	Jann Horn <jannh@google.com>,
	Jeff Moyer <jmoyer@redhat.com>,
	linux-fsdevel@vger.kernel.org,
	Sargun Dhillon <sargun@sargun.me>,
	Kees Cook <keescook@chromium.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	linux-kernel@vger.kernel.org,
	Aleksa Sarai <asarai@suse.de>,
	io-uring@vger.kernel.org
Subject: [PATCH v4 0/3] io_uring: add restrictions to support untrusted
 applications and guests
Date: Thu, 13 Aug 2020 17:32:51 +0200
Message-Id: <20200813153254.93731-1-sgarzare@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12

v4:
 - rebased on top of io_uring-5.9
 - fixed io_uring_enter() exit path when ring is disabled

v3: https://lore.kernel.org/io-uring/20200728160101.48554-1-sgarzare@redhat.c=
om/
RFC v2: https://lore.kernel.org/io-uring/20200716124833.93667-1-sgarzare@redh=
at.com
RFC v1: https://lore.kernel.org/io-uring/20200710141945.129329-1-sgarzare@red=
hat.com

Following the proposal that I send about restrictions [1], I wrote this series
to add restrictions in io_uring.

I also wrote helpers in liburing and a test case (test/register-restrictions.=
c)
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

[1] https://lore.kernel.org/io-uring/20200609142406.upuwpfmgqjeji4lc@steredha=
t/

Stefano Garzarella (3):
  io_uring: use an enumeration for io_uring_register(2) opcodes
  io_uring: add IOURING_REGISTER_RESTRICTIONS opcode
  io_uring: allow disabling rings during the creation

 fs/io_uring.c                 | 160 ++++++++++++++++++++++++++++++++--
 include/uapi/linux/io_uring.h |  60 ++++++++++---
 2 files changed, 203 insertions(+), 17 deletions(-)

--=20
2.26.2

