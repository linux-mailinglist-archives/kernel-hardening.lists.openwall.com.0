Return-Path: <kernel-hardening-return-16031-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id D0F98320F1
	for <lists+kernel-hardening@lfdr.de>; Sun,  2 Jun 2019 00:28:16 +0200 (CEST)
Received: (qmail 7368 invoked by uid 550); 1 Jun 2019 22:28:02 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 7258 invoked from network); 1 Jun 2019 22:28:01 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xNWJR7+avVxp+XBc8qsFVmrbJq3BMouQd4JZAqdSMow=;
        b=aVaF2GlW0FbGYqbnk+GkXXLXef8ob7VZcUv1mDRtpZokHqSbR/AfW0i5FF1EyuLrcV
         fSC3v83WjuKWB89npwonNL0dTnqzhxBECvUTF7JchE/W1TyukM3SvtT487WrCa5Rm53A
         tRE961dlDJAiauiC7XdxF81iiMXqC3ahSZSgk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xNWJR7+avVxp+XBc8qsFVmrbJq3BMouQd4JZAqdSMow=;
        b=Asx608si14Rf8vKPy2qSgS+GB5qzBw9Qczj6xQci+jtjDKJvgJjygj4GXb237huFgJ
         7MAOwF72wDr+pAkbF1MxEsn04gvHpxG09/tR98T3usCH8n83oNkqv/0n5l1ocWmeQtDX
         FaMUvo+828kLM6jtamPgAcgwjlOAuOIR/dmc4l0fOSvb9meG9UaTkFvn4M+cLra6HJXE
         2x+4q4IyG+LxeUGlfoNImzNCHgKEqZObHeLGYl1WLZt//tiN2S3OMp2ssFFTgDncYneQ
         Gw9g9yGOVAPMXgE/206d/3GBof1ovYci2M+6v1OjM8cCHlQv8rf+2iPPXjHdev7OnGW1
         em5w==
X-Gm-Message-State: APjAAAVJdo3eE4CeFJbK9HEsJJxq6Pivs9vV7LBWzjg3IUrgzU+K0IJt
	eZPqWo96Y8vI+tnx93KVh4VJDA==
X-Google-Smtp-Source: APXvYqz9O+K+W6jtVg6G5tx9Z1mr8Mbm6dSmWqpCUZgyNKqrd7q7+MLczqhNtk36EjwSD2D8Bei5lA==
X-Received: by 2002:a17:902:aa93:: with SMTP id d19mr18498979plr.341.1559428069350;
        Sat, 01 Jun 2019 15:27:49 -0700 (PDT)
From: "Joel Fernandes (Google)" <joel@joelfernandes.org>
To: linux-kernel@vger.kernel.org
Cc: "Joel Fernandes (Google)" <joel@joelfernandes.org>,
	Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Borislav Petkov <bp@alien8.de>,
	"David S. Miller" <davem@davemloft.net>,
	edumazet@google.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Josh Triplett <josh@joshtriplett.org>,
	keescook@chromium.org,
	kernel-hardening@lists.openwall.com,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Len Brown <lenb@kernel.org>,
	linux-acpi@vger.kernel.org,
	linux-pci@vger.kernel.org,
	linux-pm@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	neilb@suse.com,
	netdev@vger.kernel.org,
	oleg@redhat.com,
	"Paul E. McKenney" <paulmck@linux.ibm.com>,
	Pavel Machek <pavel@ucw.cz>,
	peterz@infradead.org,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	rcu@vger.kernel.org,
	Steven Rostedt <rostedt@goodmis.org>,
	Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT))
Subject: [RFC 1/6] rcu: Add support for consolidated-RCU reader checking
Date: Sat,  1 Jun 2019 18:27:33 -0400
Message-Id: <20190601222738.6856-2-joel@joelfernandes.org>
X-Mailer: git-send-email 2.22.0.rc1.311.g5d7573a151-goog
In-Reply-To: <20190601222738.6856-1-joel@joelfernandes.org>
References: <20190601222738.6856-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch adds support for checking RCU reader sections in list
traversal macros. Optionally, if the list macro is called under SRCU or
other lock/mutex protection, then appropriate lockdep expressions can be
passed to make the checks pass.

Existing list_for_each_entry_rcu() invocations don't need to pass the
optional fourth argument (cond) unless they are under some non-RCU
protection and needs to make lockdep check pass.

Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 include/linux/rculist.h  | 40 ++++++++++++++++++++++++++++++++++++----
 include/linux/rcupdate.h |  7 +++++++
 kernel/rcu/update.c      | 26 ++++++++++++++++++++++++++
 3 files changed, 69 insertions(+), 4 deletions(-)

diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index e91ec9ddcd30..b641fdd9f1a2 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -40,6 +40,25 @@ static inline void INIT_LIST_HEAD_RCU(struct list_head *list)
  */
 #define list_next_rcu(list)	(*((struct list_head __rcu **)(&(list)->next)))
 
+/*
+ * Check during list traversal that we are within an RCU reader
+ */
+#define __list_check_rcu()						\
+	RCU_LOCKDEP_WARN(!rcu_read_lock_any_held(),			\
+			 "RCU-list traversed in non-reader section!")
+
+static inline void __list_check_rcu_cond(int dummy, ...)
+{
+	va_list ap;
+	int cond;
+
+	va_start(ap, dummy);
+	cond = va_arg(ap, int);
+	va_end(ap);
+
+	RCU_LOCKDEP_WARN(!cond && !rcu_read_lock_any_held(),
+			 "RCU-list traversed in non-reader section!");
+}
 /*
  * Insert a new entry between two known consecutive entries.
  *
@@ -338,6 +357,9 @@ static inline void list_splice_tail_init_rcu(struct list_head *list,
 						  member) : NULL; \
 })
 
+#define SIXTH_ARG(a1, a2, a3, a4, a5, a6, ...) a6
+#define COUNT_VARGS(...) SIXTH_ARG(dummy, ## __VA_ARGS__, 4, 3, 2, 1, 0)
+
 /**
  * list_for_each_entry_rcu	-	iterate over rcu list of given type
  * @pos:	the type * to use as a loop cursor.
@@ -348,9 +370,14 @@ static inline void list_splice_tail_init_rcu(struct list_head *list,
  * the _rcu list-mutation primitives such as list_add_rcu()
  * as long as the traversal is guarded by rcu_read_lock().
  */
-#define list_for_each_entry_rcu(pos, head, member) \
-	for (pos = list_entry_rcu((head)->next, typeof(*pos), member); \
-		&pos->member != (head); \
+#define list_for_each_entry_rcu(pos, head, member, cond...)		\
+	if (COUNT_VARGS(cond) != 0) {					\
+		__list_check_rcu_cond(0, ## cond);			\
+	} else {							\
+		__list_check_rcu();					\
+	}								\
+	for (pos = list_entry_rcu((head)->next, typeof(*pos), member);	\
+		&pos->member != (head);					\
 		pos = list_entry_rcu(pos->member.next, typeof(*pos), member))
 
 /**
@@ -621,7 +648,12 @@ static inline void hlist_add_behind_rcu(struct hlist_node *n,
  * the _rcu list-mutation primitives such as hlist_add_head_rcu()
  * as long as the traversal is guarded by rcu_read_lock().
  */
-#define hlist_for_each_entry_rcu(pos, head, member)			\
+#define hlist_for_each_entry_rcu(pos, head, member, cond...)		\
+	if (COUNT_VARGS(cond) != 0) {					\
+		__list_check_rcu_cond(0, ## cond);			\
+	} else {							\
+		__list_check_rcu();					\
+	}								\
 	for (pos = hlist_entry_safe (rcu_dereference_raw(hlist_first_rcu(head)),\
 			typeof(*(pos)), member);			\
 		pos;							\
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 922bb6848813..712b464ab960 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -223,6 +223,7 @@ int debug_lockdep_rcu_enabled(void);
 int rcu_read_lock_held(void);
 int rcu_read_lock_bh_held(void);
 int rcu_read_lock_sched_held(void);
+int rcu_read_lock_any_held(void);
 
 #else /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
@@ -243,6 +244,12 @@ static inline int rcu_read_lock_sched_held(void)
 {
 	return !preemptible();
 }
+
+static inline int rcu_read_lock_any_held(void)
+{
+	return !preemptible();
+}
+
 #endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
 #ifdef CONFIG_PROVE_RCU
diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index c3bf44ba42e5..9cb30006a5e1 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -298,6 +298,32 @@ int rcu_read_lock_bh_held(void)
 }
 EXPORT_SYMBOL_GPL(rcu_read_lock_bh_held);
 
+int rcu_read_lock_any_held(void)
+{
+	int lockdep_opinion = 0;
+
+	if (!debug_lockdep_rcu_enabled())
+		return 1;
+	if (!rcu_is_watching())
+		return 0;
+	if (!rcu_lockdep_current_cpu_online())
+		return 0;
+
+	/* Preemptible RCU flavor */
+	if (lock_is_held(&rcu_lock_map))
+		return 1;
+
+	/* BH flavor */
+	if (in_softirq() || irqs_disabled())
+		return 1;
+
+	/* Sched flavor */
+	if (debug_locks)
+		lockdep_opinion = lock_is_held(&rcu_sched_lock_map);
+	return lockdep_opinion || !preemptible();
+}
+EXPORT_SYMBOL_GPL(rcu_read_lock_any_held);
+
 #endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
 /**
-- 
2.22.0.rc1.311.g5d7573a151-goog

