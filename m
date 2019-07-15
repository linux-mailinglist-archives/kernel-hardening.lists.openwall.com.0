Return-Path: <kernel-hardening-return-16461-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id A83DC6928D
	for <lists+kernel-hardening@lfdr.de>; Mon, 15 Jul 2019 16:37:41 +0200 (CEST)
Received: (qmail 26348 invoked by uid 550); 15 Jul 2019 14:37:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 26287 invoked from network); 15 Jul 2019 14:37:29 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=peLCyvMnb6GAqXrVywa8AT70STEJ77uX6TkkVXJzQ/M=;
        b=QjihkdzO56EyWdL1UBrowr4J0diPIpjeawlNo5eUXRlutEI+PMdDLg/2ovhGCm9dB1
         am3dJfpAJ98Tx9IokTbTDJI/QLnhNHnLoi+VI/95oP5fp/RwwQCZGPG9aCEKUlUpO/1N
         atHPVJ+wXVzYcfg26NNOs6IX7iznL6Gp2AAwA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=peLCyvMnb6GAqXrVywa8AT70STEJ77uX6TkkVXJzQ/M=;
        b=tiXWOdHU0apCsBASXifQSiBL8P9FM6jsl8jU9Q80Z1VOjQzPA0xchG/yCFRiXjVW+2
         gmiARK2Mj0OUIVrbyr+2BIArZjrzbXPVqqhGfg6MCnCvMrHiVfXfQiPmrd/YpAZU1ryN
         gYDK2EOSsnb1NF3XY4YVr57nktE1uK+L2T+PPKgSBlkve9qnyjsbgDld7ayM1z10HAFw
         izdEakX9i9hNvwr0oO1LdN/QGODQYZuY1EmQzyyvTFNsy1pT0WX2hpLNsM4bZSB9K7Bp
         SqA0rSGkZcRBe3lMZcKx7g0mZeNfrIorcgJj0qQQLWooAeXrAFCEeGZ+WNYqSvN6/uSS
         MSzg==
X-Gm-Message-State: APjAAAWodHWd6G5rOD9RgMOlGwuBk3ZfJt4EFyouaeNAhsMNemxrJ0Yy
	5UL/40YUK1pr/qw+mTp0yy4=
X-Google-Smtp-Source: APXvYqzmK9tD8rYXtIru39NtpVyI6dVamC0JOl/Vm3L4KkimM24dL0CBqeO9C1zAEuPYG8wK9FgMFA==
X-Received: by 2002:a65:6281:: with SMTP id f1mr25763664pgv.400.1563201437978;
        Mon, 15 Jul 2019 07:37:17 -0700 (PDT)
From: "Joel Fernandes (Google)" <joel@joelfernandes.org>
To: linux-kernel@vger.kernel.org
Cc: "Joel Fernandes (Google)" <joel@joelfernandes.org>,
	Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Borislav Petkov <bp@alien8.de>,
	c0d1n61at3@gmail.com,
	"David S. Miller" <davem@davemloft.net>,
	edumazet@google.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Josh Triplett <josh@joshtriplett.org>,
	keescook@chromium.org,
	kernel-hardening@lists.openwall.com,
	kernel-team@android.com,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Len Brown <lenb@kernel.org>,
	linux-acpi@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-pci@vger.kernel.org,
	linux-pm@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	neilb@suse.com,
	netdev@vger.kernel.org,
	Oleg Nesterov <oleg@redhat.com>,
	"Paul E. McKenney" <paulmck@linux.ibm.com>,
	Pavel Machek <pavel@ucw.cz>,
	peterz@infradead.org,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
	rcu@vger.kernel.org,
	Steven Rostedt <rostedt@goodmis.org>,
	Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	will@kernel.org,
	x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT))
Subject: [PATCH 1/9] rcu/update: Remove useless check for debug_locks (v1)
Date: Mon, 15 Jul 2019 10:36:57 -0400
Message-Id: <20190715143705.117908-2-joel@joelfernandes.org>
X-Mailer: git-send-email 2.22.0.510.g264f2c817a-goog
In-Reply-To: <20190715143705.117908-1-joel@joelfernandes.org>
References: <20190715143705.117908-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In rcu_read_lock_sched_held(), debug_locks can never be true at the
point we check it because we already check debug_locks in
debug_lockdep_rcu_enabled() in the beginning. Remove the check.

Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 kernel/rcu/update.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index 61df2bf08563..9dd5aeef6e70 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -93,17 +93,13 @@ module_param(rcu_normal_after_boot, int, 0);
  */
 int rcu_read_lock_sched_held(void)
 {
-	int lockdep_opinion = 0;
-
 	if (!debug_lockdep_rcu_enabled())
 		return 1;
 	if (!rcu_is_watching())
 		return 0;
 	if (!rcu_lockdep_current_cpu_online())
 		return 0;
-	if (debug_locks)
-		lockdep_opinion = lock_is_held(&rcu_sched_lock_map);
-	return lockdep_opinion || !preemptible();
+	return lock_is_held(&rcu_sched_lock_map) || !preemptible();
 }
 EXPORT_SYMBOL(rcu_read_lock_sched_held);
 #endif
-- 
2.22.0.510.g264f2c817a-goog

