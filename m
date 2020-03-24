Return-Path: <kernel-hardening-return-18171-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id F3D841914CC
	for <lists+kernel-hardening@lfdr.de>; Tue, 24 Mar 2020 16:40:19 +0100 (CET)
Received: (qmail 28492 invoked by uid 550); 24 Mar 2020 15:37:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 28376 invoked from network); 24 Mar 2020 15:37:30 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585064250;
	bh=ri9KQLLR3eoXLGocQosIf3Ei29WyRhQ2wVoDTxEb0QY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=okUik8tknQQ138Vj56YnBrEna4Dkp2mzticYyUdqn/jqnjmdfi8iA1WSYHvaE+ElE
	 l0BMIexjkb1rt+rQl32RdJoYUc6XzslCr4Wct3AMllOZiubhJCtT52wo9hMR1A5OD6
	 XSZYQ4u2Ra6hhjPYtbysNwwxxh7mpvHPJE4nYEL0=
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
Subject: [RFC PATCH 16/21] list_bl: Extend integrity checking in deletion routines
Date: Tue, 24 Mar 2020 15:36:38 +0000
Message-Id: <20200324153643.15527-17-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200324153643.15527-1-will@kernel.org>
References: <20200324153643.15527-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Although deleting an entry from an 'hlist_bl' optionally checks that the
node being removed is unlocked before subsequently removing it and
poisoning its pointers, we don't actually check for the poison values
like we do for other list implementations.

Add poison checks to __hlist_bl_del_valid() so that we can catch list
corruption without relying on a later fault.

Cc: Kees Cook <keescook@chromium.org>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Will Deacon <will@kernel.org>
---
 include/linux/list_bl.h | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/linux/list_bl.h b/include/linux/list_bl.h
index f48d8acb15b4..0839c4f43e6d 100644
--- a/include/linux/list_bl.h
+++ b/include/linux/list_bl.h
@@ -48,7 +48,15 @@ static inline bool __hlist_bl_add_head_valid(struct hlist_bl_head *h,
 static inline bool __hlist_bl_del_valid(struct hlist_bl_node *n)
 {
 	unsigned long nlock = (unsigned long)n & LIST_BL_LOCKMASK;
-	return !CHECK_DATA_CORRUPTION(nlock, "hlist_bl_del_valid: node locked");
+
+	return !(CHECK_DATA_CORRUPTION(nlock,
+			"hlist_bl_del_valid: node locked") ||
+		 CHECK_DATA_CORRUPTION(n->next == LIST_POISON1,
+			"hlist_bl_del corruption, %px->next is LIST_POISON1 (%px)\n",
+			n, LIST_POISON1) ||
+		 CHECK_DATA_CORRUPTION(n->pprev == LIST_POISON2,
+			"hlist_bl_del corruption, %px->pprev is LIST_POISON2 (%px)\n",
+			n, LIST_POISON2));
 }
 #else
 static inline bool __hlist_bl_add_head_valid(struct hlist_bl_head *h,
-- 
2.20.1

