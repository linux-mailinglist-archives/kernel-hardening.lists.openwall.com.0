Return-Path: <kernel-hardening-return-21322-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 55DDB3B4725
	for <lists+kernel-hardening@lfdr.de>; Fri, 25 Jun 2021 18:04:53 +0200 (CEST)
Received: (qmail 7869 invoked by uid 550); 25 Jun 2021 16:04:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 7834 invoked from network); 25 Jun 2021 16:04:45 -0000
From: Yun Zhou <yun.zhou@windriver.com>
To: <rostedt@goodmis.org>
CC: <linux-kernel@vger.kernel.org>, <kernel-hardening@lists.openwall.com>,
        <ying.xue@windriver.com>, <zhiquan.li@windriver.com>
Subject: [PATCH 2/2] seq_buf: Make trace_seq_putmem_hex() support data longer than 8
Date: Fri, 25 Jun 2021 23:53:48 +0800
Message-ID: <20210625155348.58266-2-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20210625155348.58266-1-yun.zhou@windriver.com>
References: <20210625155348.58266-1-yun.zhou@windriver.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

At present, trace_seq_putmem_hex() can only support data with length
of 8 or less, which greatly limits its application scope. If we want to
dump longer data blocks, we need to repeatedly call macro SEQ_PUT_HEX_FIELD.
I think it is a bit redundant, and multiple function calls also affect
the performance.

This patch is to perfect the commit 6d2289f3faa7 ("tracing: Make
trace_seq_putmem_hex() more robust").

Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
---
 lib/seq_buf.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/lib/seq_buf.c b/lib/seq_buf.c
index aa2f666e584e..98580a5c32c0 100644
--- a/lib/seq_buf.c
+++ b/lib/seq_buf.c
@@ -210,8 +210,7 @@ int seq_buf_putmem(struct seq_buf *s, const void *mem, unsigned int len)
  * seq_buf_putmem_hex - write raw memory into the buffer in ASCII hex
  * @s: seq_buf descriptor
  * @mem: The raw memory to write its hex ASCII representation of
- * @len: The length of the raw memory to copy (in bytes).
- *       It can be not larger than 8.
+ * @len: The length of the raw memory to copy (in bytes)
  *
  * This is similar to seq_buf_putmem() except instead of just copying the
  * raw memory into the buffer it writes its ASCII representation of it
@@ -229,19 +228,27 @@ int seq_buf_putmem_hex(struct seq_buf *s, const void *mem,
 
 	WARN_ON(s->size == 0);
 
-	start_len = min(len, MAX_MEMHEX_BYTES);
+	while (len) {
+		start_len = min(len, MAX_MEMHEX_BYTES);
 #ifdef __BIG_ENDIAN
-	for (i = 0, j = 0; i < start_len; i++) {
+		for (i = 0, j = 0; i < start_len; i++) {
 #else
-	for (i = start_len-1, j = 0; i >= 0; i--) {
+		for (i = start_len-1, j = 0; i >= 0; i--) {
 #endif
-		hex[j++] = hex_asc_hi(data[i]);
-		hex[j++] = hex_asc_lo(data[i]);
-	}
+			hex[j++] = hex_asc_hi(data[i]);
+			hex[j++] = hex_asc_lo(data[i]);
+		}
 
-	seq_buf_putmem(s, hex, j);
-	if (seq_buf_has_overflowed(s))
-		return -1;
+		/* j increments twice per loop */
+		len -= j / 2;
+		hex[j++] = ' ';
+
+		seq_buf_putmem(s, hex, j);
+		if (seq_buf_has_overflowed(s))
+			return -1;
+
+		data += start_len;
+	}
 	return 0;
 }
 
-- 
2.26.1

