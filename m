Return-Path: <kernel-hardening-return-21326-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id D4CBF3B4C31
	for <lists+kernel-hardening@lfdr.de>; Sat, 26 Jun 2021 05:33:05 +0200 (CEST)
Received: (qmail 20426 invoked by uid 550); 26 Jun 2021 03:32:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 20265 invoked from network); 26 Jun 2021 03:32:52 -0000
From: Yun Zhou <yun.zhou@windriver.com>
To: <rostedt@goodmis.org>
CC: <linux-kernel@vger.kernel.org>, <kernel-hardening@lists.openwall.com>,
        <ying.xue@windriver.com>, <zhiquan.li@windriver.com>
Subject: [PATCH 2/2] seq_buf: Make trace_seq_putmem_hex() support data longer than 8
Date: Sat, 26 Jun 2021 11:21:56 +0800
Message-ID: <20210626032156.47889-2-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20210626032156.47889-1-yun.zhou@windriver.com>
References: <20210626032156.47889-1-yun.zhou@windriver.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

Since the raw memory 'data' does not go forward, it will dump repeated
data if the data length is more than 8. If we want to dump longer data
blocks, we need to repeatedly call macro SEQ_PUT_HEX_FIELD. I think it
is a bit redundant, and multiple function calls also affect the performance.

This patch is to improve the commit 6d2289f3faa7 ("tracing: Make
trace_seq_putmem_hex() more robust").

Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
---
 lib/seq_buf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/seq_buf.c b/lib/seq_buf.c
index 223fbc3bb958..562e53c93b7b 100644
--- a/lib/seq_buf.c
+++ b/lib/seq_buf.c
@@ -244,12 +244,14 @@ int seq_buf_putmem_hex(struct seq_buf *s, const void *mem,
 			break;
 
 		/* j increments twice per loop */
-		len -= j / 2;
 		hex[j++] = ' ';
 
 		seq_buf_putmem(s, hex, j);
 		if (seq_buf_has_overflowed(s))
 			return -1;
+
+		len -= start_len;
+		data += start_len;
 	}
 	return 0;
 }
-- 
2.26.1

