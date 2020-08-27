Return-Path: <kernel-hardening-return-19705-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id DF77F254825
	for <lists+kernel-hardening@lfdr.de>; Thu, 27 Aug 2020 16:59:30 +0200 (CEST)
Received: (qmail 16365 invoked by uid 550); 27 Aug 2020 14:59:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 16342 invoked from network); 27 Aug 2020 14:59:21 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1598540350;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z4Vz/JxMJ98n2+tJ+MNwT1uOCyLxzwuXuw0qARqAyiM=;
	b=KFwosy8JrSCDFWHHsYoH1TMrXOgpaiNP2vDm4NRuRE8RBenb3OYtVR9bGUZT04QyxPYcPA
	YfGDGKX2aty2N9zTDxL2ceftVQWt2xh5EToE+vqTM+UaJkR7A4lxgDwJvMMBVYN740s999
	sUnXCFoTEjpO2s4+kSjuU/xOt4c5CVI=
X-MC-Unique: bDDXn54yP324K-pMmJdIQw-1
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
Subject: [PATCH v6 3/3] io_uring: allow disabling rings during the creation
Date: Thu, 27 Aug 2020 16:58:31 +0200
Message-Id: <20200827145831.95189-4-sgarzare@redhat.com>
In-Reply-To: <20200827145831.95189-1-sgarzare@redhat.com>
References: <20200827145831.95189-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16

This patch adds a new IORING_SETUP_R_DISABLED flag to start the
rings disabled, allowing the user to register restrictions,
buffers, files, before to start processing SQEs.

When IORING_SETUP_R_DISABLED is set, SQE are not processed and
SQPOLL kthread is not started.

The restrictions registration are allowed only when the rings
are disable to prevent concurrency issue while processing SQEs.

The rings can be enabled using IORING_REGISTER_ENABLE_RINGS
opcode with io_uring_register(2).

Suggested-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
v4:
 - fixed io_uring_enter() exit path when ring is disabled

v3:
 - enabled restrictions only when the rings start

RFC v2:
 - removed return value of io_sq_offload_start()
---
 fs/io_uring.c                 | 52 ++++++++++++++++++++++++++++++-----
 include/uapi/linux/io_uring.h |  2 ++
 2 files changed, 47 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5f62997c147b..b036f3373fbe 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -226,6 +226,7 @@ struct io_restriction {
 	DECLARE_BITMAP(sqe_op, IORING_OP_LAST);
 	u8 sqe_flags_allowed;
 	u8 sqe_flags_required;
+	bool registered;
 };
 
 struct io_ring_ctx {
@@ -7497,8 +7498,8 @@ static int io_init_wq_offload(struct io_ring_ctx *ctx,
 	return ret;
 }
 
-static int io_sq_offload_start(struct io_ring_ctx *ctx,
-			       struct io_uring_params *p)
+static int io_sq_offload_create(struct io_ring_ctx *ctx,
+				struct io_uring_params *p)
 {
 	int ret;
 
@@ -7532,7 +7533,6 @@ static int io_sq_offload_start(struct io_ring_ctx *ctx,
 			ctx->sqo_thread = NULL;
 			goto err;
 		}
-		wake_up_process(ctx->sqo_thread);
 	} else if (p->flags & IORING_SETUP_SQ_AFF) {
 		/* Can't have SQ_AFF without SQPOLL */
 		ret = -EINVAL;
@@ -7549,6 +7549,12 @@ static int io_sq_offload_start(struct io_ring_ctx *ctx,
 	return ret;
 }
 
+static void io_sq_offload_start(struct io_ring_ctx *ctx)
+{
+	if ((ctx->flags & IORING_SETUP_SQPOLL) && ctx->sqo_thread)
+		wake_up_process(ctx->sqo_thread);
+}
+
 static inline void __io_unaccount_mem(struct user_struct *user,
 				      unsigned long nr_pages)
 {
@@ -8295,6 +8301,9 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	if (!percpu_ref_tryget(&ctx->refs))
 		goto out_fput;
 
+	if (ctx->flags & IORING_SETUP_R_DISABLED)
+		goto out_fput;
+
 	/*
 	 * For SQ polling, the thread will do all submissions and completions.
 	 * Just return the requested submit count, and wake the thread if
@@ -8612,10 +8621,13 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 	if (ret)
 		goto err;
 
-	ret = io_sq_offload_start(ctx, p);
+	ret = io_sq_offload_create(ctx, p);
 	if (ret)
 		goto err;
 
+	if (!(p->flags & IORING_SETUP_R_DISABLED))
+		io_sq_offload_start(ctx);
+
 	memset(&p->sq_off, 0, sizeof(p->sq_off));
 	p->sq_off.head = offsetof(struct io_rings, sq.head);
 	p->sq_off.tail = offsetof(struct io_rings, sq.tail);
@@ -8678,7 +8690,8 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 
 	if (p.flags & ~(IORING_SETUP_IOPOLL | IORING_SETUP_SQPOLL |
 			IORING_SETUP_SQ_AFF | IORING_SETUP_CQSIZE |
-			IORING_SETUP_CLAMP | IORING_SETUP_ATTACH_WQ))
+			IORING_SETUP_CLAMP | IORING_SETUP_ATTACH_WQ |
+			IORING_SETUP_R_DISABLED))
 		return -EINVAL;
 
 	return  io_uring_create(entries, &p, params);
@@ -8761,8 +8774,12 @@ static int io_register_restrictions(struct io_ring_ctx *ctx, void __user *arg,
 	size_t size;
 	int i, ret;
 
+	/* Restrictions allowed only if rings started disabled */
+	if (!(ctx->flags & IORING_SETUP_R_DISABLED))
+		return -EINVAL;
+
 	/* We allow only a single restrictions registration */
-	if (ctx->restricted)
+	if (ctx->restrictions.registered)
 		return -EBUSY;
 
 	if (!arg || nr_args > IORING_MAX_RESTRICTIONS)
@@ -8814,12 +8831,27 @@ static int io_register_restrictions(struct io_ring_ctx *ctx, void __user *arg,
 	if (ret != 0)
 		memset(&ctx->restrictions, 0, sizeof(ctx->restrictions));
 	else
-		ctx->restricted = 1;
+		ctx->restrictions.registered = true;
 
 	kfree(res);
 	return ret;
 }
 
+static int io_register_enable_rings(struct io_ring_ctx *ctx)
+{
+	if (!(ctx->flags & IORING_SETUP_R_DISABLED))
+		return -EINVAL;
+
+	if (ctx->restrictions.registered)
+		ctx->restricted = 1;
+
+	ctx->flags &= ~IORING_SETUP_R_DISABLED;
+
+	io_sq_offload_start(ctx);
+
+	return 0;
+}
+
 static bool io_register_op_must_quiesce(int op)
 {
 	switch (op) {
@@ -8941,6 +8973,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			break;
 		ret = io_unregister_personality(ctx, nr_args);
 		break;
+	case IORING_REGISTER_ENABLE_RINGS:
+		ret = -EINVAL;
+		if (arg || nr_args)
+			break;
+		ret = io_register_enable_rings(ctx);
+		break;
 	case IORING_REGISTER_RESTRICTIONS:
 		ret = io_register_restrictions(ctx, arg, nr_args);
 		break;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 6e7f2e5e917b..a0c85e0e9016 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -95,6 +95,7 @@ enum {
 #define IORING_SETUP_CQSIZE	(1U << 3)	/* app defines CQ size */
 #define IORING_SETUP_CLAMP	(1U << 4)	/* clamp SQ/CQ ring sizes */
 #define IORING_SETUP_ATTACH_WQ	(1U << 5)	/* attach to existing wq */
+#define IORING_SETUP_R_DISABLED	(1U << 6)	/* start with ring disabled */
 
 enum {
 	IORING_OP_NOP,
@@ -268,6 +269,7 @@ enum {
 	IORING_REGISTER_PERSONALITY		= 9,
 	IORING_UNREGISTER_PERSONALITY		= 10,
 	IORING_REGISTER_RESTRICTIONS		= 11,
+	IORING_REGISTER_ENABLE_RINGS		= 12,
 
 	/* this goes last */
 	IORING_REGISTER_LAST
-- 
2.26.2

