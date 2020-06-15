Return-Path: <kernel-hardening-return-18965-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id D60E21F8CD1
	for <lists+kernel-hardening@lfdr.de>; Mon, 15 Jun 2020 06:01:46 +0200 (CEST)
Received: (qmail 11464 invoked by uid 550); 15 Jun 2020 04:01:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 11426 invoked from network); 15 Jun 2020 04:01:39 -0000
From: Jason Yan <yanaijie@huawei.com>
To: <axboe@kernel.dk>, <b.zolnierkie@samsung.com>,
	<linux-ide@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <kernel-hardening@lists.openwall.com>, Jason Yan <yanaijie@huawei.com>,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH] ata: Eliminate usage of uninitialized_var() macro
Date: Mon, 15 Jun 2020 12:02:36 +0800
Message-ID: <20200615040236.3720734-1-yanaijie@huawei.com>
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
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/ata/libata-scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 435781a16875..fcb00f2825fe 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -93,7 +93,7 @@ static ssize_t ata_scsi_park_show(struct device *device,
 	struct ata_link *link;
 	struct ata_device *dev;
 	unsigned long now;
-	unsigned int uninitialized_var(msecs);
+	unsigned int msecs;
 	int rc = 0;
 
 	ap = ata_shost_to_port(sdev->host);
-- 
2.25.4

