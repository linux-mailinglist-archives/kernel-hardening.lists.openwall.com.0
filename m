Return-Path: <kernel-hardening-return-18163-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 3C7E01914AD
	for <lists+kernel-hardening@lfdr.de>; Tue, 24 Mar 2020 16:38:17 +0100 (CET)
Received: (qmail 26226 invoked by uid 550); 24 Mar 2020 15:37:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 26148 invoked from network); 24 Mar 2020 15:37:17 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585064225;
	bh=HtIRk6SgACDcRR+T26oZFJ9RbFoiC+0T7/ZIAIszoac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PFTF6dbidKK8bNsgiuQ0YzqiFJ+943Y1octiEX2ks522jykL3FeaoEC3/EpDpuGxK
	 iSRCdwylEHOAzHH1M8Ru71ywTMdX5d3vcvYKSCwuwDdqH30UHL4KfqwkSoefwChV6R
	 R1D6o74rD1071XZ6dlZnno/5DtUel35g3aexpV9w=
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
Subject: [RFC PATCH 06/21] list: Remove superfluous WRITE_ONCE() from hlist_nulls implementation
Date: Tue, 24 Mar 2020 15:36:28 +0000
Message-Id: <20200324153643.15527-7-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200324153643.15527-1-will@kernel.org>
References: <20200324153643.15527-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 860c8802ace1 ("rcu: Use WRITE_ONCE() for assignments to ->pprev
for hlist_nulls") added WRITE_ONCE() invocations to hlist_nulls_add_head()
and hlist_nulls_del().

Since these functions should not ordinarily run concurrently with other
list accessors, restore the plain C assignments so that KCSAN can yell
if a data race occurs.

Cc: Eric Dumazet <edumazet@google.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Will Deacon <will@kernel.org>
---
 include/linux/list_nulls.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/list_nulls.h b/include/linux/list_nulls.h
index fa51a801bf32..fd154ceb5b0d 100644
--- a/include/linux/list_nulls.h
+++ b/include/linux/list_nulls.h
@@ -80,10 +80,10 @@ static inline void hlist_nulls_add_head(struct hlist_nulls_node *n,
 	struct hlist_nulls_node *first = h->first;
 
 	n->next = first;
-	WRITE_ONCE(n->pprev, &h->first);
+	n->pprev = &h->first;
 	h->first = n;
 	if (!is_a_nulls(first))
-		WRITE_ONCE(first->pprev, &n->next);
+		first->pprev = &n->next;
 }
 
 static inline void __hlist_nulls_del(struct hlist_nulls_node *n)
@@ -99,7 +99,7 @@ static inline void __hlist_nulls_del(struct hlist_nulls_node *n)
 static inline void hlist_nulls_del(struct hlist_nulls_node *n)
 {
 	__hlist_nulls_del(n);
-	WRITE_ONCE(n->pprev, LIST_POISON2);
+	n->pprev = LIST_POISON2;
 }
 
 /**
-- 
2.20.1

