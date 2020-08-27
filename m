Return-Path: <kernel-hardening-return-19691-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 57020254621
	for <lists+kernel-hardening@lfdr.de>; Thu, 27 Aug 2020 15:41:28 +0200 (CEST)
Received: (qmail 23933 invoked by uid 550); 27 Aug 2020 13:41:21 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 23908 invoked from network); 27 Aug 2020 13:41:20 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1598535669;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E6x4893U1XZUaKie9nG5yKGJyij3esKFZmrFVgshH0M=;
	b=M0jjcGbcslBJHKPoQcp5mWyDICUAGqUtsVeHf2QoUuzSz7Cke3D5uvyC9fUacHNBQJ5r8n
	MEQWSeQatRm9dLdf1o5f6vDNebwd3ZABGMpZ9fBqFMSvwpynJUnrX87OmUuT5r655w4hm0
	SuB1LGVVgIpTQMdaqQkHze5byPlJt80=
X-MC-Unique: 1uL7r7AxPuWd6lzDfgbeMg-1
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
Subject: [PATCH v5 1/3] io_uring: use an enumeration for io_uring_register(2) opcodes
Date: Thu, 27 Aug 2020 15:40:42 +0200
Message-Id: <20200827134044.82821-2-sgarzare@redhat.com>
In-Reply-To: <20200827134044.82821-1-sgarzare@redhat.com>
References: <20200827134044.82821-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11

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

