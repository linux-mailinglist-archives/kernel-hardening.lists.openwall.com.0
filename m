Return-Path: <kernel-hardening-return-18177-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id DEF521914D7
	for <lists+kernel-hardening@lfdr.de>; Tue, 24 Mar 2020 16:41:54 +0100 (CET)
Received: (qmail 32108 invoked by uid 550); 24 Mar 2020 15:37:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 32036 invoked from network); 24 Mar 2020 15:37:51 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585064260;
	bh=XWqetTA32I53c5P8S/oKOfl+VkXjOX16eJWZLMzOkxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X2t5R6HqMQbGBFIPAA+m6IOSLwhb7FStDZ8NFam625QSOCw14mFlTiBsnuvoca/Wy
	 F9ymQwGi3yTJSwaDwLbIRHrePiqOWHxe3LDUbMKaJuAIGjTipAHROumUZNcee+9+XJ
	 1kvxdazNh14ZQQAwicQRBhJkCu/JdSz+UnWDb78U=
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
Subject: [RFC PATCH 20/21] list: Format CHECK_DATA_CORRUPTION error messages consistently
Date: Tue, 24 Mar 2020 15:36:42 +0000
Message-Id: <20200324153643.15527-21-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200324153643.15527-1-will@kernel.org>
References: <20200324153643.15527-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The error strings printed when list data corruption is detected are
formatted inconsistently.

Satisfy my inner-pedant by consistently using ':' to limit the message
from its prefix and drop the terminating full stops where they exist.

Signed-off-by: Will Deacon <will@kernel.org>
---
 lib/list_debug.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/lib/list_debug.c b/lib/list_debug.c
index 3be50b5c8014..00e414508f93 100644
--- a/lib/list_debug.c
+++ b/lib/list_debug.c
@@ -23,10 +23,10 @@ bool __list_add_valid(struct list_head *new, struct list_head *prev,
 		      struct list_head *next)
 {
 	if (CHECK_DATA_CORRUPTION(next->prev != prev,
-			"list_add corruption. next->prev should be prev (%px), but was %px. (next=%px).\n",
+			"list_add corruption: next->prev should be prev (%px), but was %px (next=%px)\n",
 			prev, next->prev, next) ||
 	    CHECK_DATA_CORRUPTION(prev->next != next,
-			"list_add corruption. prev->next should be next (%px), but was %px. (prev=%px).\n",
+			"list_add corruption: prev->next should be next (%px), but was %px (prev=%px)\n",
 			next, prev->next, prev) ||
 	    CHECK_DATA_CORRUPTION(new == prev || new == next,
 			"list_add double add: new=%px, prev=%px, next=%px.\n",
@@ -45,16 +45,16 @@ bool __list_del_entry_valid(struct list_head *entry)
 	next = entry->next;
 
 	if (CHECK_DATA_CORRUPTION(next == LIST_POISON1,
-			"list_del corruption, %px->next is LIST_POISON1 (%px)\n",
+			"list_del corruption: %px->next is LIST_POISON1 (%px)\n",
 			entry, LIST_POISON1) ||
 	    CHECK_DATA_CORRUPTION(prev == LIST_POISON2,
-			"list_del corruption, %px->prev is LIST_POISON2 (%px)\n",
+			"list_del corruption: %px->prev is LIST_POISON2 (%px)\n",
 			entry, LIST_POISON2) ||
 	    CHECK_DATA_CORRUPTION(prev->next != entry,
-			"list_del corruption. prev->next should be %px, but was %px\n",
+			"list_del corruption: prev->next should be %px, but was %px\n",
 			entry, prev->next) ||
 	    CHECK_DATA_CORRUPTION(next->prev != entry,
-			"list_del corruption. next->prev should be %px, but was %px\n",
+			"list_del corruption: next->prev should be %px, but was %px\n",
 			entry, next->prev))
 		return false;
 
@@ -196,7 +196,7 @@ bool __hlist_bl_add_head_valid(struct hlist_bl_node *new,
 	unsigned long nlock = (unsigned long)new & LIST_BL_LOCKMASK;
 
 	if (CHECK_DATA_CORRUPTION(nlock,
-			"hlist_bl_add_head: node is locked\n") ||
+			"hlist_bl_add_head corruption: node is locked\n") ||
 	    CHECK_DATA_CORRUPTION(hlock != LIST_BL_LOCKMASK,
 			"hlist_bl_add_head: head is unlocked\n"))
 		return false;
@@ -222,10 +222,10 @@ bool __hlist_bl_del_valid(struct hlist_bl_node *node)
 	if (CHECK_DATA_CORRUPTION(nlock,
 			"hlist_bl_del corruption: node is locked") ||
 	    CHECK_DATA_CORRUPTION(next == LIST_POISON1,
-			"hlist_bl_del corruption, %px->next is LIST_POISON1 (%px)\n",
+			"hlist_bl_del corruption: %px->next is LIST_POISON1 (%px)\n",
 			node, LIST_POISON1) ||
 	    CHECK_DATA_CORRUPTION(node->pprev == LIST_POISON2,
-			"hlist_bl_del corruption, %px->pprev is LIST_POISON2 (%px)\n",
+			"hlist_bl_del corruption: %px->pprev is LIST_POISON2 (%px)\n",
 			node, LIST_POISON2))
 		return false;
 
-- 
2.20.1

