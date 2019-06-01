Return-Path: <kernel-hardening-return-16034-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 6ED88320FD
	for <lists+kernel-hardening@lfdr.de>; Sun,  2 Jun 2019 00:28:40 +0200 (CEST)
Received: (qmail 8155 invoked by uid 550); 1 Jun 2019 22:28:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 8091 invoked from network); 1 Jun 2019 22:28:12 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JYEdUUvy8S93JfyESlA9B4bQMgXK5qa78QvxuKI1iX8=;
        b=JpIZxOLHu3pAr7XqjE6lQyNILkSNtWAhlsGBsqQ9nX8Mkf45RZkSqCsB1ogyuaGHYR
         oID/Qzt9GUMhWhlEy7pzJd90HrYVZDZ4ddj9Se3v7fLclY18Kge6hu4MUcAmLD+wf4b0
         XKyDW7+epwfSMkz4uMyVUA2uPZnDSVHkqAT6k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JYEdUUvy8S93JfyESlA9B4bQMgXK5qa78QvxuKI1iX8=;
        b=l7uPjw0bhD9h1ZMyfZM5/JmjTSNCa35vxQq9ErO4eTk4qP+5Y0PKp9qmWobz8xk0b/
         SEAxkILKIqp8GS8EFlpD8ivlRaPiNAlYUfc0ZddnCZIuBvGtwuzbxduSg6SckpdiMn5c
         j9apiF97VEercJaqDQhbSl2bkExMOfngn5ZBdfajowsGCqy5XWlu1KadA4OaO92+Xixi
         ujJPJFwxhI6Z9Z5sb1WhPAf2Lrk3hBQcWW8j8WukyZOQ1dup3xxLKDEBS2Y4KkpQmAfz
         fhRPVBb8T58yszT2uK+R2UdJAcYEtOC9zFWQrKNx6X0qndqhuV0zOQyL/xbTiUdypTLU
         EJCw==
X-Gm-Message-State: APjAAAWBQFSYCO2a32BGTh55RNlBLsr0EBqL3eo+r/lgmzQWMQrVfMix
	pb1H38v3c1GejCAuddLfEXmREA==
X-Google-Smtp-Source: APXvYqwKk4GW7sHHyPB0GuHYf6OQ+CpmILR8gGtCpOPuYf+Qeg4Mh/EguSHhpRRCqMTs3zQmTpmcmg==
X-Received: by 2002:a17:902:9a9:: with SMTP id 38mr20196036pln.10.1559428080628;
        Sat, 01 Jun 2019 15:28:00 -0700 (PDT)
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
Subject: [RFC 4/6] workqueue: Convert for_each_wq to use built-in list check
Date: Sat,  1 Jun 2019 18:27:36 -0400
Message-Id: <20190601222738.6856-5-joel@joelfernandes.org>
X-Mailer: git-send-email 2.22.0.rc1.311.g5d7573a151-goog
In-Reply-To: <20190601222738.6856-1-joel@joelfernandes.org>
References: <20190601222738.6856-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

list_for_each_entry_rcu now has support to check for RCU reader sections
as well as lock. Just use the support in it, instead of explictly
checking in the caller.

Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 kernel/workqueue.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 9657315405de..91ed7aca16e5 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -424,9 +424,8 @@ static void workqueue_sysfs_unregister(struct workqueue_struct *wq);
  * ignored.
  */
 #define for_each_pwq(pwq, wq)						\
-	list_for_each_entry_rcu((pwq), &(wq)->pwqs, pwqs_node)		\
-		if (({ assert_rcu_or_wq_mutex(wq); false; })) { }	\
-		else
+	list_for_each_entry_rcu((pwq), &(wq)->pwqs, pwqs_node,		\
+				 lock_is_held(&(wq->mutex).dep_map))
 
 #ifdef CONFIG_DEBUG_OBJECTS_WORK
 
-- 
2.22.0.rc1.311.g5d7573a151-goog

