Return-Path: <kernel-hardening-return-18165-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id B3AD21914C2
	for <lists+kernel-hardening@lfdr.de>; Tue, 24 Mar 2020 16:38:47 +0100 (CET)
Received: (qmail 26481 invoked by uid 550); 24 Mar 2020 15:37:21 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 26351 invoked from network); 24 Mar 2020 15:37:20 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585064228;
	bh=E5Moj5+y/0jzpIXcSSmKlyGx50dCga0UNXCRHKQpICA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K0XCoPBmOAuAnOLhnFxsmrVj3APUzwevP3MHRSPvNOqQpOQk4SlUvqzt5tZ9yQBaw
	 cVUtxXlQLwN2SlAd2f9tuZGU90i0Rf+WYVcKWIwMhwoO+ksYJWGR7UZcms1SXzoTfd
	 ET4KxQiaQRXLzCGEWqkXM5HVoq9uxtwAjemJraF4=
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
Subject: [RFC PATCH 07/21] Revert "list: Use WRITE_ONCE() when adding to lists and hlists"
Date: Tue, 24 Mar 2020 15:36:29 +0000
Message-Id: <20200324153643.15527-8-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200324153643.15527-1-will@kernel.org>
References: <20200324153643.15527-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This reverts commit 1c97be677f72b3c338312aecd36d8fff20322f32.

There is no need to use WRITE_ONCE() for the non-RCU list and hlist
implementations.

Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Will Deacon <will@kernel.org>
---
 include/linux/list.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/list.h b/include/linux/list.h
index ec1f780d1449..c7331c259792 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -70,7 +70,7 @@ static inline void __list_add(struct list_head *new,
 	next->prev = new;
 	new->next = next;
 	new->prev = prev;
-	WRITE_ONCE(prev->next, new);
+	prev->next = new;
 }
 
 /**
@@ -843,7 +843,7 @@ static inline void hlist_add_head(struct hlist_node *n, struct hlist_head *h)
 	n->next = first;
 	if (first)
 		first->pprev = &n->next;
-	WRITE_ONCE(h->first, n);
+	h->first = n;
 	n->pprev = &h->first;
 }
 
@@ -858,7 +858,7 @@ static inline void hlist_add_before(struct hlist_node *n,
 	n->pprev = next->pprev;
 	n->next = next;
 	next->pprev = &n->next;
-	WRITE_ONCE(*(n->pprev), n);
+	*(n->pprev) = n;
 }
 
 /**
-- 
2.20.1

