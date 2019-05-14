Return-Path: <kernel-hardening-return-15925-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 6388D1CA9F
	for <lists+kernel-hardening@lfdr.de>; Tue, 14 May 2019 16:42:50 +0200 (CEST)
Received: (qmail 13937 invoked by uid 550); 14 May 2019 14:42:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 1924 invoked from network); 14 May 2019 14:36:22 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Go4t+yeK4FmEV47RVV/K/R0RvYRio180dlBaNN/E/uc=;
        b=pikeD1jlvnTEk+uey8TbYun2V8C/qn4NetuazfEjFSiIKXfvKb/Y0U2HoOWYrcxEIV
         RE5qYPWIkYK3IPMiDScQeSxK/srM5ptI7dU2jw4oxcInPVP6DLkKA9s1SNWvB2og986s
         NIFLfXn07Iz5SdRS75NF4d20AWJ5nnn1P7j3lT5arszZfOIm7sh/AGz7F0MmvLClYAZn
         cIlQ/W4XGYhtJCeuCcbxJGVNh5q+guM3Rv3w1yAkzVnieYfruF0+p9N4wanKkn7/p/SW
         BszdBhtZ3MtpABxG0+mAR5ZuJsszQrRt2f6CbWb34BCMWiBptbrnvbZ6TunbLM8L5NWs
         jCsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Go4t+yeK4FmEV47RVV/K/R0RvYRio180dlBaNN/E/uc=;
        b=bKgFPl46FsAaA6dmiEyTbXsTr5Rk/d/Kumsz80POVp7dxOG/Yxkvx9YewaYw5rYTu2
         j08Rl91YZ1SsoLfKCN8KOcqrR65DYxN5qxXNG/d/iM4GKQMkdSu+xbpKt1aitwhh5hD3
         bwYUvhb3tUzzdveDqxQlHBApvneYhcNs8ZhfBbPUi/KDqYUifdNVPcoFKiz+iTNOV3r/
         7Hk0bZMqBnxRgvCh1yC74vPS0rjKAbgLODN9grNUBD4fHwq/I3LUVVTAEq078oUCpzmu
         erxNuTNI7CabgWITv5wUQbb/G+0n00dKpDNHv84avkUdtmBRcknBzGRSL5Sw3drvMpf7
         DakQ==
X-Gm-Message-State: APjAAAWsd39qSrJk/rAGshkjKmG9vsaIgTEqLLD41s/8VXHqAJoRdbm1
	JwV7qLkfFugTFoMHn8nJESe/r1tX1Ok=
X-Google-Smtp-Source: APXvYqzAvmFIr0uQeT7SswT+cvcHP8YHOoi7bCs4Uurq0vvk2jm2KoyvFDp206pk1BoSOeKx0QNC4J5Rkl8=
X-Received: by 2002:a67:ed11:: with SMTP id l17mr17817001vsp.154.1557844570196;
 Tue, 14 May 2019 07:36:10 -0700 (PDT)
Date: Tue, 14 May 2019 16:35:37 +0200
In-Reply-To: <20190514143537.10435-1-glider@google.com>
Message-Id: <20190514143537.10435-5-glider@google.com>
Mime-Version: 1.0
References: <20190514143537.10435-1-glider@google.com>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
Subject: [PATCH v2 4/4] net: apply __GFP_NO_AUTOINIT to AF_UNIX sk_buff allocations
From: Alexander Potapenko <glider@google.com>
To: akpm@linux-foundation.org, cl@linux.com, keescook@chromium.org
Cc: kernel-hardening@lists.openwall.com, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Nick Desaulniers <ndesaulniers@google.com>, 
	Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, 
	Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>, 
	Mark Rutland <mark.rutland@arm.com>, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Add sock_alloc_send_pskb_noinit(), which is similar to
sock_alloc_send_pskb(), but allocates with __GFP_NO_AUTOINIT.
This helps reduce the slowdown on hackbench in the init_on_alloc mode
from 6.84% to 3.45%.

Slowdown for the initialization features compared to init_on_free=0,
init_on_alloc=0:

hackbench, init_on_free=1:  +7.71% sys time (st.err 0.45%)
hackbench, init_on_alloc=1: +3.45% sys time (st.err 0.86%)

Linux build with -j12, init_on_free=1:  +8.34% wall time (st.err 0.39%)
Linux build with -j12, init_on_free=1:  +24.13% sys time (st.err 0.47%)
Linux build with -j12, init_on_alloc=1: -0.04% wall time (st.err 0.46%)
Linux build with -j12, init_on_alloc=1: +0.50% sys time (st.err 0.45%)

The slowdown for init_on_free=0, init_on_alloc=0 compared to the
baseline is within the standard error.

Signed-off-by: Alexander Potapenko <glider@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <cl@linux.com>
To: Kees Cook <keescook@chromium.org>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: James Morris <jmorris@namei.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Kostya Serebryany <kcc@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Sandeep Patil <sspatil@android.com>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Jann Horn <jannh@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: linux-mm@kvack.org
Cc: linux-security-module@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com
---
 v2:
  - changed __GFP_NOINIT to __GFP_NO_AUTOINIT
---
 include/net/sock.h |  5 +++++
 net/core/sock.c    | 29 +++++++++++++++++++++++++----
 net/unix/af_unix.c | 13 +++++++------
 3 files changed, 37 insertions(+), 10 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 4d208c0f9c14..0dcb90a0c14d 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1626,6 +1626,11 @@ struct sk_buff *sock_alloc_send_skb(struct sock *sk, unsigned long size,
 struct sk_buff *sock_alloc_send_pskb(struct sock *sk, unsigned long header_len,
 				     unsigned long data_len, int noblock,
 				     int *errcode, int max_page_order);
+struct sk_buff *sock_alloc_send_pskb_noinit(struct sock *sk,
+					    unsigned long header_len,
+					    unsigned long data_len,
+					    int noblock, int *errcode,
+					    int max_page_order);
 void *sock_kmalloc(struct sock *sk, int size, gfp_t priority);
 void sock_kfree_s(struct sock *sk, void *mem, int size);
 void sock_kzfree_s(struct sock *sk, void *mem, int size);
diff --git a/net/core/sock.c b/net/core/sock.c
index 9ceb90c875bc..7c24b70b7069 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2192,9 +2192,11 @@ static long sock_wait_for_wmem(struct sock *sk, long timeo)
  *	Generic send/receive buffer handlers
  */
 
-struct sk_buff *sock_alloc_send_pskb(struct sock *sk, unsigned long header_len,
-				     unsigned long data_len, int noblock,
-				     int *errcode, int max_page_order)
+struct sk_buff *sock_alloc_send_pskb_internal(struct sock *sk,
+					      unsigned long header_len,
+					      unsigned long data_len,
+					      int noblock, int *errcode,
+					      int max_page_order, gfp_t gfp)
 {
 	struct sk_buff *skb;
 	long timeo;
@@ -2223,7 +2225,7 @@ struct sk_buff *sock_alloc_send_pskb(struct sock *sk, unsigned long header_len,
 		timeo = sock_wait_for_wmem(sk, timeo);
 	}
 	skb = alloc_skb_with_frags(header_len, data_len, max_page_order,
-				   errcode, sk->sk_allocation);
+				   errcode, sk->sk_allocation | gfp);
 	if (skb)
 		skb_set_owner_w(skb, sk);
 	return skb;
@@ -2234,8 +2236,27 @@ struct sk_buff *sock_alloc_send_pskb(struct sock *sk, unsigned long header_len,
 	*errcode = err;
 	return NULL;
 }
+
+struct sk_buff *sock_alloc_send_pskb(struct sock *sk, unsigned long header_len,
+				     unsigned long data_len, int noblock,
+				     int *errcode, int max_page_order)
+{
+	return sock_alloc_send_pskb_internal(sk, header_len, data_len,
+		noblock, errcode, max_page_order, /*gfp*/0);
+}
 EXPORT_SYMBOL(sock_alloc_send_pskb);
 
+struct sk_buff *sock_alloc_send_pskb_noinit(struct sock *sk,
+					    unsigned long header_len,
+					    unsigned long data_len,
+					    int noblock, int *errcode,
+					    int max_page_order)
+{
+	return sock_alloc_send_pskb_internal(sk, header_len, data_len,
+		noblock, errcode, max_page_order, /*gfp*/__GFP_NO_AUTOINIT);
+}
+EXPORT_SYMBOL(sock_alloc_send_pskb_noinit);
+
 struct sk_buff *sock_alloc_send_skb(struct sock *sk, unsigned long size,
 				    int noblock, int *errcode)
 {
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index e68d7454f2e3..a4c15620b66d 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1627,9 +1627,9 @@ static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 		BUILD_BUG_ON(SKB_MAX_ALLOC < PAGE_SIZE);
 	}
 
-	skb = sock_alloc_send_pskb(sk, len - data_len, data_len,
-				   msg->msg_flags & MSG_DONTWAIT, &err,
-				   PAGE_ALLOC_COSTLY_ORDER);
+	skb = sock_alloc_send_pskb_noinit(sk, len - data_len, data_len,
+					  msg->msg_flags & MSG_DONTWAIT, &err,
+					  PAGE_ALLOC_COSTLY_ORDER);
 	if (skb == NULL)
 		goto out;
 
@@ -1824,9 +1824,10 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
 
 		data_len = min_t(size_t, size, PAGE_ALIGN(data_len));
 
-		skb = sock_alloc_send_pskb(sk, size - data_len, data_len,
-					   msg->msg_flags & MSG_DONTWAIT, &err,
-					   get_order(UNIX_SKB_FRAGS_SZ));
+		skb = sock_alloc_send_pskb_noinit(sk, size - data_len, data_len,
+						  msg->msg_flags & MSG_DONTWAIT,
+						  &err,
+						  get_order(UNIX_SKB_FRAGS_SZ));
 		if (!skb)
 			goto out_err;
 
-- 
2.21.0.1020.gf2820cf01a-goog

