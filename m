Return-Path: <kernel-hardening-return-16414-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 8DEA266276
	for <lists+kernel-hardening@lfdr.de>; Fri, 12 Jul 2019 01:45:25 +0200 (CEST)
Received: (qmail 13773 invoked by uid 550); 11 Jul 2019 23:44:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 13669 invoked from network); 11 Jul 2019 23:44:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9hScIZHsJmciYgxW3aaEACdipTjQ9ZhOMfEnTUSyg1Q=;
        b=kUZQBreXwSQ3LNMpnqWvxcf4z6FWwsyIribYH6vlDIlwsM/srzaOqB8hIC628Mxbpi
         sTEAQ/xS3ImmQx1BNXkDBgZwF5VYl6hRzaTcO42erW/MK6aBa4x3s17KPW5cbQUHnjAY
         AwCUMvXSnmIzqwu3/UeH7anXY4KB+DD3eYa0o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9hScIZHsJmciYgxW3aaEACdipTjQ9ZhOMfEnTUSyg1Q=;
        b=W3myeVBnJ9FU+E1CpZO/S29CdXImkbBpurFRK5cpSJV06tkSXu65DVjq0NqoiNsbis
         wKzaQ1d/mw2VZlSGLNRsrNbmsDwsLPzZDHdhl5PZiT7RntMEFmexYhgDZ32Nl8IHyP2E
         Yh3O2vRDjn2k7a2r6kbfMoyvUgswPL1hRD97sFIJazQ5ih+Xi/m/oRxJKi6kTZIpAjYZ
         QTlJocebM1BGu/yiqIGOP37eb3J3pEKRDFxSeMqHrlwgw3spJeaP3IeKDKuKXA9I8DJ7
         BIrNakvg8UBINYR8UpDFBVXwFbz/w4jZAyJYWcX0RpdK8XKUnlVi9YfmjI8dP6alnSeN
         2q7Q==
X-Gm-Message-State: APjAAAX7I+fZ/VXzOEb1l2c+oFsMPLK4kv1NjwOTD6lWDIuc7DNJ+FyD
	MjAyyaagqCeIVYpDz22/SzI=
X-Google-Smtp-Source: APXvYqxSDqyaeYYrrky8TWDPKqAGIx032RS1Jxow1lqnbITQYU3SZG4CMrefnUWSiviXF9o7KBA/IQ==
X-Received: by 2002:a17:90a:8a15:: with SMTP id w21mr7864165pjn.134.1562888677430;
        Thu, 11 Jul 2019 16:44:37 -0700 (PDT)
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
	Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
	rcu@vger.kernel.org,
	Steven Rostedt <rostedt@goodmis.org>,
	Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	will@kernel.org,
	x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT))
Subject: [PATCH v1 6/6] acpi: Use built-in RCU list checking for acpi_ioremaps list
Date: Thu, 11 Jul 2019 19:44:01 -0400
Message-Id: <20190711234401.220336-7-joel@joelfernandes.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
In-Reply-To: <20190711234401.220336-1-joel@joelfernandes.org>
References: <20190711234401.220336-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

list_for_each_entry_rcu has built-in RCU and lock checking. Make use of
it for acpi_ioremaps list traversal.

Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 drivers/acpi/osl.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index f29e427d0d1d..c8b5d712c7ae 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -28,6 +28,7 @@
 #include <linux/slab.h>
 #include <linux/mm.h>
 #include <linux/highmem.h>
+#include <linux/lockdep.h>
 #include <linux/pci.h>
 #include <linux/interrupt.h>
 #include <linux/kmod.h>
@@ -94,6 +95,7 @@ struct acpi_ioremap {
 
 static LIST_HEAD(acpi_ioremaps);
 static DEFINE_MUTEX(acpi_ioremap_lock);
+#define acpi_ioremap_lock_held() lock_is_held(&acpi_ioremap_lock.dep_map)
 
 static void __init acpi_request_region (struct acpi_generic_address *gas,
 	unsigned int length, char *desc)
@@ -220,7 +222,7 @@ acpi_map_lookup(acpi_physical_address phys, acpi_size size)
 {
 	struct acpi_ioremap *map;
 
-	list_for_each_entry_rcu(map, &acpi_ioremaps, list)
+	list_for_each_entry_rcu(map, &acpi_ioremaps, list, acpi_ioremap_lock_held())
 		if (map->phys <= phys &&
 		    phys + size <= map->phys + map->size)
 			return map;
@@ -263,7 +265,7 @@ acpi_map_lookup_virt(void __iomem *virt, acpi_size size)
 {
 	struct acpi_ioremap *map;
 
-	list_for_each_entry_rcu(map, &acpi_ioremaps, list)
+	list_for_each_entry_rcu(map, &acpi_ioremaps, list, acpi_ioremap_lock_held())
 		if (map->virt <= virt &&
 		    virt + size <= map->virt + map->size)
 			return map;
-- 
2.22.0.410.gd8fdbe21b5-goog

