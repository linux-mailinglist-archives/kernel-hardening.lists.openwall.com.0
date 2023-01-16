Return-Path: <kernel-hardening-return-21598-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by mail.lfdr.de (Postfix) with SMTP id 20D3A66CF6A
	for <lists+kernel-hardening@lfdr.de>; Mon, 16 Jan 2023 20:15:00 +0100 (CET)
Received: (qmail 13727 invoked by uid 550); 16 Jan 2023 19:14:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 13690 invoked from network); 16 Jan 2023 19:14:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3I9TKz0QCRwStrORKwRYbo4zYDMGw/8qyv/2PPzcTIw=;
        b=JhpTDkNcmd/K/PpIamox+UvMbgveXuheag7i9hm8ma5NnX7ZfIOvhDb1HEwnrhqXgV
         DMPZY4t81B1oRlC1xwXXjkqUDt3e/oxumkm8f58ziGzt6ueDgTdxVpSbxmWLa5Y/LqIP
         b3h5/Wepronyk03vMqkjLgLzU2Nh6Zcq+b8Ard3BfdYwkBmsxc9039CJba7v7FTcQ6ef
         3swlGUN78iSzOIxCdqSboYpAB4+ZEFVbKXJU/A2J4I1H+gpE/GmWLAd7i2MSNVcGX1Jj
         Dp+HqtxFWRKw2OFt6pSgbCTWBBfOfZmdFLGKnK7jqQS3hYgr3ggvMSbka3FiLg4x9//h
         b8zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3I9TKz0QCRwStrORKwRYbo4zYDMGw/8qyv/2PPzcTIw=;
        b=6gVbdoX++8p4fpiTVyZ8pLhAK/XPiZTOGj72+FJ9mQcWE2TrEGaY8d9TKs68R7qFVw
         w/06nwBFnGbAvi/KJ9bg9dvsa2hiMk1ypznGOjNIz8FjPnjhuer0YJvpjttQWcou/zb9
         nuKdVlwlbGjgpR7ulqUZcmpGpjS+bCzeTDdbaAKBPxwlfC1mf+aGyo1nhV4DfcrRFD8S
         MkECS02yrwrAfNLZORlPGrz7nC2PSP3FoA5FzZBNdZjzdcbcke/oU+SqRhO1kzjOgmMM
         +bNgjWmttutiYrZq86WQnfLJSxNWpDqt8Zkzqn2EplpN2YRSbLfRi+qmRbihrsQYwBX4
         waSA==
X-Gm-Message-State: AFqh2kq/ax4Pr5Af+aqJpFN/4A70aJCZd9Ft2j3vRMWdpdjMdbfzJxis
	j0ltPE+dmBUgQ8SWyeWT1dFKZg==
X-Google-Smtp-Source: AMrXdXtWSSV63Ld25GuO0BsX3I2Wu43PREgvm5mdCHutcYHBaybO5RRT8NbVv9KhGzTM4D2Fl8Waig==
X-Received: by 2002:a05:6000:1d87:b0:2a1:602d:ff3 with SMTP id bk7-20020a0560001d8700b002a1602d0ff3mr1103593wrb.3.1673896478372;
        Mon, 16 Jan 2023 11:14:38 -0800 (PST)
From: Jann Horn <jannh@google.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: [PATCH] fs: Use CHECK_DATA_CORRUPTION() when kernel bugs are detected
Date: Mon, 16 Jan 2023 20:14:25 +0100
Message-Id: <20230116191425.458864-1-jannh@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, filp_close() and generic_shutdown_super() use printk() to log
messages when bugs are detected. This is problematic because infrastructure
like syzkaller has no idea that this message indicates a bug.
In addition, some people explicitly want their kernels to BUG() when kernel
data corruption has been detected (CONFIG_BUG_ON_DATA_CORRUPTION).
And finally, when generic_shutdown_super() detects remaining inodes on a
system without CONFIG_BUG_ON_DATA_CORRUPTION, it would be nice if later
accesses to a busy inode would at least crash somewhat cleanly rather than
walking through freed memory.

To address all three, use CHECK_DATA_CORRUPTION() when kernel bugs are
detected.

Signed-off-by: Jann Horn <jannh@google.com>
---
 fs/open.c              |  5 +++--
 fs/super.c             | 21 +++++++++++++++++----
 include/linux/poison.h |  3 +++
 3 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 82c1a28b3308..ceb88ac0ca3b 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -1411,8 +1411,9 @@ int filp_close(struct file *filp, fl_owner_t id)
 {
 	int retval = 0;
 
-	if (!file_count(filp)) {
-		printk(KERN_ERR "VFS: Close: file count is 0\n");
+	if (CHECK_DATA_CORRUPTION(file_count(filp) == 0,
+			"VFS: Close: file count is 0 (f_op=%ps)",
+			filp->f_op)) {
 		return 0;
 	}
 
diff --git a/fs/super.c b/fs/super.c
index 12c08cb20405..cf737ec2bd05 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -491,10 +491,23 @@ void generic_shutdown_super(struct super_block *sb)
 		if (sop->put_super)
 			sop->put_super(sb);
 
-		if (!list_empty(&sb->s_inodes)) {
-			printk("VFS: Busy inodes after unmount of %s. "
-			   "Self-destruct in 5 seconds.  Have a nice day...\n",
-			   sb->s_id);
+		if (CHECK_DATA_CORRUPTION(!list_empty(&sb->s_inodes),
+				"VFS: Busy inodes after unmount of %s (%s)",
+				sb->s_id, sb->s_type->name)) {
+			/*
+			 * Adding a proper bailout path here would be hard, but
+			 * we can at least make it more likely that a later
+			 * iput_final() or such crashes cleanly.
+			 */
+			struct inode *inode;
+
+			spin_lock(&sb->s_inode_list_lock);
+			list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
+				inode->i_op = VFS_PTR_POISON;
+				inode->i_sb = VFS_PTR_POISON;
+				inode->i_mapping = VFS_PTR_POISON;
+			}
+			spin_unlock(&sb->s_inode_list_lock);
 		}
 	}
 	spin_lock(&sb_lock);
diff --git a/include/linux/poison.h b/include/linux/poison.h
index 2d3249eb0e62..0e8a1f2ceb2f 100644
--- a/include/linux/poison.h
+++ b/include/linux/poison.h
@@ -84,4 +84,7 @@
 /********** kernel/bpf/ **********/
 #define BPF_PTR_POISON ((void *)(0xeB9FUL + POISON_POINTER_DELTA))
 
+/********** VFS **********/
+#define VFS_PTR_POISON ((void *)(0xF5 + POISON_POINTER_DELTA))
+
 #endif

base-commit: 5dc4c995db9eb45f6373a956eb1f69460e69e6d4
-- 
2.39.0.314.g84b9a713c41-goog

