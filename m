Return-Path: <kernel-hardening-return-19626-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 24CF7243C98
	for <lists+kernel-hardening@lfdr.de>; Thu, 13 Aug 2020 17:34:17 +0200 (CEST)
Received: (qmail 14077 invoked by uid 550); 13 Aug 2020 15:34:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 14054 invoked from network); 13 Aug 2020 15:34:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1597332835;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zz3etVbVEOjvsPy3a1rmULc9GOmqKniLRh7neDKkaXw=;
	b=MkI5t4BTb5auEeLyfUa/WVmdtrwmE5zY5LCdEhLyUILI0SKnRH5Ait22CuQyEZkls/UFCp
	2Koq4t9/kGb5MigeN3nlA7yFCw5G1hTlcpXa+JaKEmepu3Y8V5syluWQKtdr2+wxMj8BMg
	B8D0P5YWP5Zr9TGcHAx706e0npRc/0E=
X-MC-Unique: NF_LSg7jPDCoEHuwC5VjVA-1
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
Subject: [PATCH v4 2/3] io_uring: add IOURING_REGISTER_RESTRICTIONS opcode
Date: Thu, 13 Aug 2020 17:32:53 +0200
Message-Id: <20200813153254.93731-3-sgarzare@redhat.com>
In-Reply-To: <20200813153254.93731-1-sgarzare@redhat.com>
References: <20200813153254.93731-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12

The new io_uring_register(2) IOURING_REGISTER_RESTRICTIONS opcode
permanently installs a feature allowlist on an io_ring_ctx.
The io_ring_ctx can then be passed to untrusted code with the
knowledge that only operations present in the allowlist can be
executed.

The allowlist approach ensures that new features added to io_uring
do not accidentally become available when an existing application
is launched on a newer kernel version.

Currently is it possible to restrict sqe opcodes, sqe flags, and
register opcodes.

IOURING_REGISTER_RESTRICTIONS can only be made once. Afterwards
it is not possible to change restrictions anymore.
This prevents untrusted code from removing restrictions.

Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
v3:
 - added IORING_RESTRICTION_SQE_FLAGS_ALLOWED and
   IORING_RESTRICTION_SQE_FLAGS_REQUIRED
 - removed IORING_RESTRICTION_FIXED_FILES_ONLY

RFC v2:
 - added 'restricted' flag in the ctx [Jens]
 - added IORING_MAX_RESTRICTIONS define
 - returned EBUSY instead of EINVAL when restrictions are already
   registered
 - reset restrictions if an error happened during the registration
---
 fs/io_uring.c                 | 112 +++++++++++++++++++++++++++++++++-
 include/uapi/linux/io_uring.h |  31 ++++++++++
 2 files changed, 142 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1ec25ee71372..cb365e6e0af7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -98,6 +98,8 @@
 #define IORING_MAX_FILES_TABLE	(1U << IORING_FILE_TABLE_SHIFT)
 #define IORING_FILE_TABLE_MASK	(IORING_MAX_FILES_TABLE - 1)
 #define IORING_MAX_FIXED_FILES	(64 * IORING_MAX_FILES_TABLE)
+#define IORING_MAX_RESTRICTIONS	(IORING_RESTRICTION_LAST + \
+				 IORING_REGISTER_LAST + IORING_OP_LAST)
 
 struct io_uring {
 	u32 head ____cacheline_aligned_in_smp;
@@ -219,6 +221,13 @@ struct io_buffer {
 	__u16 bid;
 };
 
+struct io_restriction {
+	DECLARE_BITMAP(register_op, IORING_REGISTER_LAST);
+	DECLARE_BITMAP(sqe_op, IORING_OP_LAST);
+	u8 sqe_flags_allowed;
+	u8 sqe_flags_required;
+};
+
 struct io_ring_ctx {
 	struct {
 		struct percpu_ref	refs;
@@ -231,6 +240,7 @@ struct io_ring_ctx {
 		unsigned int		cq_overflow_flushed: 1;
 		unsigned int		drain_next: 1;
 		unsigned int		eventfd_async: 1;
+		unsigned int		restricted: 1;
 
 		/*
 		 * Ring buffer of indices into array of io_uring_sqe, which is
@@ -338,6 +348,7 @@ struct io_ring_ctx {
 	struct llist_head		file_put_llist;
 
 	struct work_struct		exit_work;
+	struct io_restriction		restrictions;
 };
 
 /*
@@ -6353,6 +6364,19 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	if (unlikely(sqe_flags & ~SQE_VALID_FLAGS))
 		return -EINVAL;
 
+	if (unlikely(ctx->restricted)) {
+		if (!test_bit(req->opcode, ctx->restrictions.sqe_op))
+			return -EACCES;
+
+		if ((sqe_flags & ctx->restrictions.sqe_flags_required) !=
+		    ctx->restrictions.sqe_flags_required)
+			return -EACCES;
+
+		if (sqe_flags & ~(ctx->restrictions.sqe_flags_allowed |
+				  ctx->restrictions.sqe_flags_required))
+			return -EACCES;
+	}
+
 	if ((sqe_flags & IOSQE_BUFFER_SELECT) &&
 	    !io_op_defs[req->opcode].buffer_select)
 		return -EOPNOTSUPP;
@@ -8650,6 +8674,76 @@ static int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id)
 	return -EINVAL;
 }
 
+static int io_register_restrictions(struct io_ring_ctx *ctx, void __user *arg,
+				    unsigned int nr_args)
+{
+	struct io_uring_restriction *res;
+	size_t size;
+	int i, ret;
+
+	/* We allow only a single restrictions registration */
+	if (ctx->restricted)
+		return -EBUSY;
+
+	if (!arg || nr_args > IORING_MAX_RESTRICTIONS)
+		return -EINVAL;
+
+	size = array_size(nr_args, sizeof(*res));
+	if (size == SIZE_MAX)
+		return -EOVERFLOW;
+
+	res = kmalloc(size, GFP_KERNEL);
+	if (!res)
+		return -ENOMEM;
+
+	if (copy_from_user(res, arg, size)) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	for (i = 0; i < nr_args; i++) {
+		switch (res[i].opcode) {
+		case IORING_RESTRICTION_REGISTER_OP:
+			if (res[i].register_op >= IORING_REGISTER_LAST) {
+				ret = -EINVAL;
+				goto out;
+			}
+
+			__set_bit(res[i].register_op,
+				  ctx->restrictions.register_op);
+			break;
+		case IORING_RESTRICTION_SQE_OP:
+			if (res[i].sqe_op >= IORING_OP_LAST) {
+				ret = -EINVAL;
+				goto out;
+			}
+
+			__set_bit(res[i].sqe_op, ctx->restrictions.sqe_op);
+			break;
+		case IORING_RESTRICTION_SQE_FLAGS_ALLOWED:
+			ctx->restrictions.sqe_flags_allowed = res[i].sqe_flags;
+			break;
+		case IORING_RESTRICTION_SQE_FLAGS_REQUIRED:
+			ctx->restrictions.sqe_flags_required = res[i].sqe_flags;
+			break;
+		default:
+			ret = -EINVAL;
+			goto out;
+		}
+	}
+
+	ctx->restricted = 1;
+
+	ret = 0;
+out:
+	/* Reset all restrictions if an error happened */
+	if (ret != 0)
+		memset(&ctx->restrictions, 0, sizeof(ctx->restrictions));
+
+	kfree(res);
+	return ret;
+}
+
 static bool io_register_op_must_quiesce(int op)
 {
 	switch (op) {
@@ -8696,6 +8790,18 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 		if (ret) {
 			percpu_ref_resurrect(&ctx->refs);
 			ret = -EINTR;
+			goto out_quiesce;
+		}
+	}
+
+	if (ctx->restricted) {
+		if (opcode >= IORING_REGISTER_LAST) {
+			ret = -EINVAL;
+			goto out;
+		}
+
+		if (!test_bit(opcode, ctx->restrictions.register_op)) {
+			ret = -EACCES;
 			goto out;
 		}
 	}
@@ -8759,15 +8865,19 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			break;
 		ret = io_unregister_personality(ctx, nr_args);
 		break;
+	case IORING_REGISTER_RESTRICTIONS:
+		ret = io_register_restrictions(ctx, arg, nr_args);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
 	}
 
+out:
 	if (io_register_op_must_quiesce(opcode)) {
 		/* bring the ctx back to life */
 		percpu_ref_reinit(&ctx->refs);
-out:
+out_quiesce:
 		reinit_completion(&ctx->ref_comp);
 	}
 	return ret;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index cdc98afbacc3..be54bc3cf173 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -267,6 +267,7 @@ enum {
 	IORING_REGISTER_PROBE,
 	IORING_REGISTER_PERSONALITY,
 	IORING_UNREGISTER_PERSONALITY,
+	IORING_REGISTER_RESTRICTIONS,
 
 	/* this goes last */
 	IORING_REGISTER_LAST
@@ -295,4 +296,34 @@ struct io_uring_probe {
 	struct io_uring_probe_op ops[0];
 };
 
+struct io_uring_restriction {
+	__u16 opcode;
+	union {
+		__u8 register_op; /* IORING_RESTRICTION_REGISTER_OP */
+		__u8 sqe_op;      /* IORING_RESTRICTION_SQE_OP */
+		__u8 sqe_flags;   /* IORING_RESTRICTION_SQE_FLAGS_* */
+	};
+	__u8 resv;
+	__u32 resv2[3];
+};
+
+/*
+ * io_uring_restriction->opcode values
+ */
+enum {
+	/* Allow an io_uring_register(2) opcode */
+	IORING_RESTRICTION_REGISTER_OP,
+
+	/* Allow an sqe opcode */
+	IORING_RESTRICTION_SQE_OP,
+
+	/* Allow sqe flags */
+	IORING_RESTRICTION_SQE_FLAGS_ALLOWED,
+
+	/* Require sqe flags (these flags must be set on each submission) */
+	IORING_RESTRICTION_SQE_FLAGS_REQUIRED,
+
+	IORING_RESTRICTION_LAST
+};
+
 #endif
-- 
2.26.2

