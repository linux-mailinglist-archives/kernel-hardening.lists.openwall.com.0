Return-Path: <kernel-hardening-return-18963-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id B28CF1F8CC9
	for <lists+kernel-hardening@lfdr.de>; Mon, 15 Jun 2020 06:01:00 +0200 (CEST)
Received: (qmail 7721 invoked by uid 550); 15 Jun 2020 04:00:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 7671 invoked from network); 15 Jun 2020 04:00:51 -0000
From: Jason Yan <yanaijie@huawei.com>
To: <xiang@kernel.org>, <chao@kernel.org>, <gregkh@linuxfoundation.org>,
	<linux-erofs@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
CC: <kernel-hardening@lists.openwall.com>, Jason Yan <yanaijie@huawei.com>,
	Kees Cook <keescook@chromium.org>, Chao Yu <yuchao0@huawei.com>
Subject: [PATCH] erofs: Eliminate usage of uninitialized_var() macro
Date: Mon, 15 Jun 2020 12:01:41 +0800
Message-ID: <20200615040141.3627746-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected

This is an effort to eliminate the uninitialized_var() macro[1].

The use of this macro is the wrong solution because it forces off ANY
analysis by the compiler for a given variable. It even masks "unused
variable" warnings.

Quoted from Linus[2]:

"It's a horrible thing to use, in that it adds extra cruft to the
source code, and then shuts up a compiler warning (even the _reliable_
warnings from gcc)."

The gcc option "-Wmaybe-uninitialized" has been disabled and this change
will not produce any warnnings even with "make W=1".

[1] https://github.com/KSPP/linux/issues/81
[2] https://lore.kernel.org/lkml/CA+55aFz2500WfbKXAx8s67wrm9=yVJu65TpLgN_ybYNv0VEOKA@mail.gmail.com/

Cc: Kees Cook <keescook@chromium.org>
Cc: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 fs/erofs/data.c  | 4 ++--
 fs/erofs/zdata.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index 64b56c7df023..d0542151e8c4 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -265,7 +265,7 @@ static inline struct bio *erofs_read_raw_page(struct bio *bio,
  */
 static int erofs_raw_access_readpage(struct file *file, struct page *page)
 {
-	erofs_off_t uninitialized_var(last_block);
+	erofs_off_t last_block;
 	struct bio *bio;
 
 	trace_erofs_readpage(page, true);
@@ -282,7 +282,7 @@ static int erofs_raw_access_readpage(struct file *file, struct page *page)
 
 static void erofs_raw_access_readahead(struct readahead_control *rac)
 {
-	erofs_off_t uninitialized_var(last_block);
+	erofs_off_t last_block;
 	struct bio *bio = NULL;
 	struct page *page;
 
diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index be50a4d9d273..24a26aaf847f 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1161,7 +1161,7 @@ static void z_erofs_submit_queue(struct super_block *sb,
 	struct z_erofs_decompressqueue *q[NR_JOBQUEUES];
 	void *bi_private;
 	/* since bio will be NULL, no need to initialize last_index */
-	pgoff_t uninitialized_var(last_index);
+	pgoff_t last_index;
 	unsigned int nr_bios = 0;
 	struct bio *bio = NULL;
 
-- 
2.25.4

