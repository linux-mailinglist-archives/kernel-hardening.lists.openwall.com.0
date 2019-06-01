Return-Path: <kernel-hardening-return-16036-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 7EDA632105
	for <lists+kernel-hardening@lfdr.de>; Sun,  2 Jun 2019 00:28:58 +0200 (CEST)
Received: (qmail 9979 invoked by uid 550); 1 Jun 2019 22:28:20 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 9884 invoked from network); 1 Jun 2019 22:28:19 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Z4Z5Q8yj6p64Y2o7Spib8gfVriUeNJkKQsEzc/+Hzz0=;
        b=tn0zxaPZcEF0gzwva8HqnPjJia9DDhSQmHjOrC5LIgyWnnOofGPjmYj/hXfVZ8L0em
         XP3bB8/bqiw1eHWRAsDs+Eo+KMd0muYlR7W1IGD9w2kQhutp6W3nJjVkUHo/gqw0gscT
         hSNuQPr6j2Tn6vwct85U2AwqZoqgLSmSxBAAc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z4Z5Q8yj6p64Y2o7Spib8gfVriUeNJkKQsEzc/+Hzz0=;
        b=SaFw7T0NtSILrv3Gj/P/GBoFKjZVPkvVknLw6gKIBg1kNHqg5jYtu5DwrgNvV4sWNN
         InNm/vu+6St5XTeRoB65shFvvRStWpOw+v4QIw3mdx1d26AaVVi7MN/eKc259lJ2WFWL
         3QIWkVWp86iCnRvR0tD3fWUR/y3L3tdMiUvO+whrcRRY967nYWMgIe53BtsxL7HtgYBD
         XxnLmsnOqJxZBlslSYVhKSWeytw7uDNH5wlO6xqhSMyzNF63IR5gB7iDApf65D82bXyn
         n4TGuZl9hOVEHDxC/4KcvCXc9aofNC//f7BITuh1giDVh3szFJc0Bi+a/S/v5YFSRnDq
         59xw==
X-Gm-Message-State: APjAAAXALVZaP5DAQl3ysv9gPffyEZNy1xfpyEe4x4O0yuVFEpTaKhw8
	K1VsNR6RPWe075l97YnBQzRENA==
X-Google-Smtp-Source: APXvYqyQL17LnHVw1B3g7pCMzLSsO7wfuWCIia7ACIsUpOs3uzhXYItiAbtRvGIh4rUXLEb0jWXqzQ==
X-Received: by 2002:a63:a34c:: with SMTP id v12mr17850914pgn.198.1559428087981;
        Sat, 01 Jun 2019 15:28:07 -0700 (PDT)
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
Subject: [RFC 6/6] acpi: Use built-in RCU list checking for acpi_ioremaps list
Date: Sat,  1 Jun 2019 18:27:38 -0400
Message-Id: <20190601222738.6856-7-joel@joelfernandes.org>
X-Mailer: git-send-email 2.22.0.rc1.311.g5d7573a151-goog
In-Reply-To: <20190601222738.6856-1-joel@joelfernandes.org>
References: <20190601222738.6856-1-joel@joelfernandes.org>
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
2.22.0.rc1.311.g5d7573a151-goog

