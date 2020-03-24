Return-Path: <kernel-hardening-return-18159-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id E8435191486
	for <lists+kernel-hardening@lfdr.de>; Tue, 24 Mar 2020 16:37:29 +0100 (CET)
Received: (qmail 24232 invoked by uid 550); 24 Mar 2020 15:37:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 24128 invoked from network); 24 Mar 2020 15:37:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585064216;
	bh=neEUpG858SvJc0NfbvvctYu868B2urEcRa1OZnEdi/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g5YPnlnldLX5FxEmCV5nU6OMxrr4aQRvL63Qf/IymntooM+N8SKCiS315iO4HYjLS
	 OSzRmaE590qXuylBXKE8gVCA5Jq25Oq6QiB5CSl7fB4nqiXo+JVZM5bCw8OL+TYUfr
	 xw+cubwn5lk1k1QcAZQqIPrJzxXq/tib0vsm0DRQ=
From: Will Deacon <will@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Will Deacon <will@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jann Horn <jannh@google.com>,
	Kees Cook <keescook@chromium.org>,
	Maddie Stone <maddiestone@google.com>,
	Marco Elver <elver@google.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	kernel-team@android.com,
	kernel-hardening@lists.openwall.com
Subject: [RFC PATCH 02/21] list: Remove hlist_nulls_unhashed_lockless()
Date: Tue, 24 Mar 2020 15:36:24 +0000
Message-Id: <20200324153643.15527-3-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200324153643.15527-1-will@kernel.org>
References: <20200324153643.15527-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 02b99b38f3d9 ("rcu: Add a hlist_nulls_unhashed_lockless() function")
introduced the (as yet unused) hlist_nulls_unhashed_lockless() function
to avoid KCSAN reports when an RCU reader checks the 'hashed' status
of an 'hlist_nulls' concurrently undergoing modification.

Remove the unused function and add a READ_ONCE() to hlist_nulls_unhashed(),
just like we do already for hlist_nulls_empty().

Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Will Deacon <will@kernel.org>
---
 include/linux/list_nulls.h | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/include/linux/list_nulls.h b/include/linux/list_nulls.h
index fa6e8471bd22..3a9ff01e9a11 100644
--- a/include/linux/list_nulls.h
+++ b/include/linux/list_nulls.h
@@ -65,20 +65,6 @@ static inline unsigned long get_nulls_value(const struct hlist_nulls_node *ptr)
  * but hlist_nulls_del() does not.
  */
 static inline int hlist_nulls_unhashed(const struct hlist_nulls_node *h)
-{
-	return !h->pprev;
-}
-
-/**
- * hlist_nulls_unhashed_lockless - Has node been removed and reinitialized?
- * @h: Node to be checked
- *
- * Not that not all removal functions will leave a node in unhashed state.
- * For example, hlist_del_init_rcu() leaves the node in unhashed state,
- * but hlist_nulls_del() does not.  Unlike hlist_nulls_unhashed(), this
- * function may be used locklessly.
- */
-static inline int hlist_nulls_unhashed_lockless(const struct hlist_nulls_node *h)
 {
 	return !READ_ONCE(h->pprev);
 }
-- 
2.20.1

