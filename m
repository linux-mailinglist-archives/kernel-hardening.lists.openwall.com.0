Return-Path: <kernel-hardening-return-18961-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 2D1C41F8CC2
	for <lists+kernel-hardening@lfdr.de>; Mon, 15 Jun 2020 05:58:25 +0200 (CEST)
Received: (qmail 3423 invoked by uid 550); 15 Jun 2020 03:58:17 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3400 invoked from network); 15 Jun 2020 03:58:16 -0000
From: Jason Yan <yanaijie@huawei.com>
To: <axboe@kernel.dk>, <bvanassche@acm.org>, <linux-block@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <kernel-hardening@lists.openwall.com>
CC: Jason Yan <yanaijie@huawei.com>, Kees Cook <keescook@chromium.org>, "Ming
 Lei" <ming.lei@redhat.com>
Subject: [PATCH] block: Eliminate usage of uninitialized_var() macro
Date: Mon, 15 Jun 2020 11:58:43 +0800
Message-ID: <20200615035843.3334350-1-yanaijie@huawei.com>
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
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 block/blk-merge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index f0b0bae075a0..006402edef6b 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -473,7 +473,7 @@ static int __blk_bios_map_sg(struct request_queue *q, struct bio *bio,
 			     struct scatterlist *sglist,
 			     struct scatterlist **sg)
 {
-	struct bio_vec uninitialized_var(bvec), bvprv = { NULL };
+	struct bio_vec bvec, bvprv = { NULL };
 	struct bvec_iter iter;
 	int nsegs = 0;
 	bool new_bio = false;
-- 
2.25.4

