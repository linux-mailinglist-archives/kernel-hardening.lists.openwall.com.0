Return-Path: <kernel-hardening-return-19703-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 9B20325481C
	for <lists+kernel-hardening@lfdr.de>; Thu, 27 Aug 2020 16:59:09 +0200 (CEST)
Received: (qmail 13592 invoked by uid 550); 27 Aug 2020 14:58:58 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 13506 invoked from network); 27 Aug 2020 14:58:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1598540326;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E6x4893U1XZUaKie9nG5yKGJyij3esKFZmrFVgshH0M=;
	b=BvRGJ/taq4oGktbSmqqJbAemjnwdQDjfDOG7rS4WjMECZVXjfn+UWYc42ge1V8vNlvE+de
	Xs5mha85Cv/q3tj86spOYYUoJLdqaTGjgxt0B3ZUScKAGOPWPT1Tee5QIR4knQYRC7wZNq
	CS16cDxxWM8q6lcYVpNaUYRb3sWicBY=
X-MC-Unique: OzeCjMpkPR2bB2S_EItBpg-1
From: Stefano Garzarella <sgarzare@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Jann Horn <jannh@google.com>,
	Jeff Moyer <jmoyer@redhat.com>,
	Aleksa Sarai <asarai@suse.de>,
	Sargun Dhillon <sargun@sargun.me>,
	linux-kernel@vger.kernel.org,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH v6 1/3] io_uring: use an enumeration for io_uring_register(2) opcodes
Date: Thu, 27 Aug 2020 16:58:29 +0200
Message-Id: <20200827145831.95189-2-sgarzare@redhat.com>
In-Reply-To: <20200827145831.95189-1-sgarzare@redhat.com>
References: <20200827145831.95189-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16

The enumeration allows us to keep track of the last
io_uring_register(2) opcode available.

Behaviour and opcodes names don't change.

Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
v5:
 - explicitly assign enum values since this is UAPI [Kees]
---
 include/uapi/linux/io_uring.h | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index d65fde732518..5f12ae6a415c 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -255,17 +255,22 @@ struct io_uring_params {
 /*
  * io_uring_register(2) opcodes and arguments
  */
-#define IORING_REGISTER_BUFFERS		0
-#define IORING_UNREGISTER_BUFFERS	1
-#define IORING_REGISTER_FILES		2
-#define IORING_UNREGISTER_FILES		3
-#define IORING_REGISTER_EVENTFD		4
-#define IORING_UNREGISTER_EVENTFD	5
-#define IORING_REGISTER_FILES_UPDATE	6
-#define IORING_REGISTER_EVENTFD_ASYNC	7
-#define IORING_REGISTER_PROBE		8
-#define IORING_REGISTER_PERSONALITY	9
-#define IORING_UNREGISTER_PERSONALITY	10
+enum {
+	IORING_REGISTER_BUFFERS			= 0,
+	IORING_UNREGISTER_BUFFERS		= 1,
+	IORING_REGISTER_FILES			= 2,
+	IORING_UNREGISTER_FILES			= 3,
+	IORING_REGISTER_EVENTFD			= 4,
+	IORING_UNREGISTER_EVENTFD		= 5,
+	IORING_REGISTER_FILES_UPDATE		= 6,
+	IORING_REGISTER_EVENTFD_ASYNC		= 7,
+	IORING_REGISTER_PROBE			= 8,
+	IORING_REGISTER_PERSONALITY		= 9,
+	IORING_UNREGISTER_PERSONALITY		= 10,
+
+	/* this goes last */
+	IORING_REGISTER_LAST
+};
 
 struct io_uring_files_update {
 	__u32 offset;
-- 
2.26.2

