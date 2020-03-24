Return-Path: <kernel-hardening-return-18162-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id BCF6319148F
	for <lists+kernel-hardening@lfdr.de>; Tue, 24 Mar 2020 16:38:03 +0100 (CET)
Received: (qmail 26081 invoked by uid 550); 24 Mar 2020 15:37:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 25978 invoked from network); 24 Mar 2020 15:37:15 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585064223;
	bh=tpwxeWGxCRW2edSpkeAxy800Wtnff4M8NvYgHsczp9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GyC+w6VY0uSmE3ApXjwUpwX5/upSsRk4J8nsl07WC3p5tqV2i8jPvEAuKAlK6VLOA
	 6h8GgVtcwHzQNW0BOcMkN5/RquTjZm8tEQE+LAKF/f/euL8+wROPI3BYs1MoQnllOt
	 1IdzcQkQe3HLHySmnXBvNborGuNtuj9/B5bZ0U5g=
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
Subject: [RFC PATCH 05/21] list: Comment missing WRITE_ONCE() in __list_del()
Date: Tue, 24 Mar 2020 15:36:27 +0000
Message-Id: <20200324153643.15527-6-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200324153643.15527-1-will@kernel.org>
References: <20200324153643.15527-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Although __list_del() is called from the RCU list implementation, it
omits WRITE_ONCE() when updating the 'prev' pointer for the 'next' node.
This is reasonable because concurrent RCU readers only access the 'next'
pointers.

Although it's obvious after reading the code, add a comment.

Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Will Deacon <will@kernel.org>
---
 include/linux/list.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/list.h b/include/linux/list.h
index 4d9f5f9ed1a8..ec1f780d1449 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -109,6 +109,7 @@ static inline void list_add_tail(struct list_head *new, struct list_head *head)
  */
 static inline void __list_del(struct list_head * prev, struct list_head * next)
 {
+	/* RCU readers don't read the 'prev' pointer */
 	next->prev = prev;
 	WRITE_ONCE(prev->next, next);
 }
-- 
2.20.1

