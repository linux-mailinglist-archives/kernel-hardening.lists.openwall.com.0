Return-Path: <kernel-hardening-return-21323-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 8853A3B4726
	for <lists+kernel-hardening@lfdr.de>; Fri, 25 Jun 2021 18:05:01 +0200 (CEST)
Received: (qmail 7901 invoked by uid 550); 25 Jun 2021 16:04:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 7833 invoked from network); 25 Jun 2021 16:04:45 -0000
From: Yun Zhou <yun.zhou@windriver.com>
To: <rostedt@goodmis.org>
CC: <linux-kernel@vger.kernel.org>, <kernel-hardening@lists.openwall.com>,
        <ying.xue@windriver.com>, <zhiquan.li@windriver.com>
Subject: [PATCH 1/2] seq_buf: fix overflow when length is bigger than 8
Date: Fri, 25 Jun 2021 23:53:47 +0800
Message-ID: <20210625155348.58266-1-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.26.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

There's two variables being increased in that loop (i and j), and i
follows the raw data, and j follows what is being written into the buffer.
We should compare 'i' to MAX_MEMHEX_BYTES or compare 'j' to HEX_CHARS.
Otherwise, if 'j' goes bigger than HEX_CHARS, it will overflow the
destination buffer.

This bug was introduced by commit 6d2289f3faa71dcc ("tracing: Make
trace_seq_putmem_hex() more robust")

Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
---
 lib/seq_buf.c | 29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/lib/seq_buf.c b/lib/seq_buf.c
index 6aabb609dd87..aa2f666e584e 100644
--- a/lib/seq_buf.c
+++ b/lib/seq_buf.c
@@ -210,7 +210,8 @@ int seq_buf_putmem(struct seq_buf *s, const void *mem, unsigned int len)
  * seq_buf_putmem_hex - write raw memory into the buffer in ASCII hex
  * @s: seq_buf descriptor
  * @mem: The raw memory to write its hex ASCII representation of
- * @len: The length of the raw memory to copy (in bytes)
+ * @len: The length of the raw memory to copy (in bytes).
+ *       It can be not larger than 8.
  *
  * This is similar to seq_buf_putmem() except instead of just copying the
  * raw memory into the buffer it writes its ASCII representation of it
@@ -228,27 +229,19 @@ int seq_buf_putmem_hex(struct seq_buf *s, const void *mem,
 
 	WARN_ON(s->size == 0);
 
-	while (len) {
-		start_len = min(len, HEX_CHARS - 1);
+	start_len = min(len, MAX_MEMHEX_BYTES);
 #ifdef __BIG_ENDIAN
-		for (i = 0, j = 0; i < start_len; i++) {
+	for (i = 0, j = 0; i < start_len; i++) {
 #else
-		for (i = start_len-1, j = 0; i >= 0; i--) {
+	for (i = start_len-1, j = 0; i >= 0; i--) {
 #endif
-			hex[j++] = hex_asc_hi(data[i]);
-			hex[j++] = hex_asc_lo(data[i]);
-		}
-		if (WARN_ON_ONCE(j == 0 || j/2 > len))
-			break;
-
-		/* j increments twice per loop */
-		len -= j / 2;
-		hex[j++] = ' ';
-
-		seq_buf_putmem(s, hex, j);
-		if (seq_buf_has_overflowed(s))
-			return -1;
+		hex[j++] = hex_asc_hi(data[i]);
+		hex[j++] = hex_asc_lo(data[i]);
 	}
+
+	seq_buf_putmem(s, hex, j);
+	if (seq_buf_has_overflowed(s))
+		return -1;
 	return 0;
 }
 
-- 
2.26.1

