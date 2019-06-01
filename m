Return-Path: <kernel-hardening-return-16035-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 702BA32104
	for <lists+kernel-hardening@lfdr.de>; Sun,  2 Jun 2019 00:28:49 +0200 (CEST)
Received: (qmail 9587 invoked by uid 550); 1 Jun 2019 22:28:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 9516 invoked from network); 1 Jun 2019 22:28:16 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rPaZRgyzQF7DCy2Q79gveolqcRd2gZR4xnQeESxSxI8=;
        b=cAGodZzSRsQMt/+agP3IVTRjmy7GJn9PFgRKDBVOfndMOmU790nOh6r8RDl2NSEttn
         ozggt0Vl0AEPviZREUImDWgpoB8D77NfGsskgK/Bj9R0lxq+Xa1zB1Rz3dBJYKQUD7bL
         uSS2mFmHddK5rTGvh+vSHZuyEX0sX9MRSOJjg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rPaZRgyzQF7DCy2Q79gveolqcRd2gZR4xnQeESxSxI8=;
        b=LNHEuMIKzsICyf879q5TJXHZVEaj7oloAuzwfgQueuAc3GTr7IiDZ2H1c3jrsZ+WW9
         yLVrY0y8Ryr2jnvS9Yd/75Ue8Vt9O18pPlTEfd3Ot4af2HQJVjcOFJl3SldLQRawl/Nu
         +veUJMruTMQ7Oqkl7Hp0p3f+I2RdIVKSu6nj1x12cd2N4P1vqKSlejbnbcOrTIQ9AkIW
         INN4zumt4slKges4DUiE0bwHkKfvHKE9/29cDgUWAQfCu2R93kR0CAoxlFBvXjpg143H
         P/QjrldPhF9AdTRcbO2pmrO3tRALJgfhM5yfnyQ/yqQFlPxuY1RBXG/+1OVVuE+Akb+F
         nU1Q==
X-Gm-Message-State: APjAAAWbcEFdBr8sIWI6JatMp4R66hTsjKJNQHtK8vWotW+XwMHsnYUI
	lFi1FuytFhynk6zJeaf49FDGCA==
X-Google-Smtp-Source: APXvYqx/DSML7hGGCdUoQbZcef6z1i2E+ZJBXAJvbUYli+Bo+0PJ9dMusQpxsqpBr79TPzH4e5AIzA==
X-Received: by 2002:a65:5206:: with SMTP id o6mr18823746pgp.248.1559428084316;
        Sat, 01 Jun 2019 15:28:04 -0700 (PDT)
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
Subject: [RFC 5/6] x86/pci: Pass lockdep condition to pcm_mmcfg_list iterator
Date: Sat,  1 Jun 2019 18:27:37 -0400
Message-Id: <20190601222738.6856-6-joel@joelfernandes.org>
X-Mailer: git-send-email 2.22.0.rc1.311.g5d7573a151-goog
In-Reply-To: <20190601222738.6856-1-joel@joelfernandes.org>
References: <20190601222738.6856-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The pcm_mmcfg_list is traversed with list_for_each_entry_rcu without a
reader-lock held, because the pci_mmcfg_lock is already held. Make this
known to the list macro so that it fixes new lockdep warnings that
trigger due to lockdep checks added to list_for_each_entry_rcu().

Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 arch/x86/pci/mmconfig-shared.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
index 7389db538c30..6fa42e9c4e6f 100644
--- a/arch/x86/pci/mmconfig-shared.c
+++ b/arch/x86/pci/mmconfig-shared.c
@@ -29,6 +29,7 @@
 static bool pci_mmcfg_running_state;
 static bool pci_mmcfg_arch_init_failed;
 static DEFINE_MUTEX(pci_mmcfg_lock);
+#define pci_mmcfg_lock_held() lock_is_held(&(pci_mmcfg_lock).dep_map)
 
 LIST_HEAD(pci_mmcfg_list);
 
@@ -54,7 +55,7 @@ static void list_add_sorted(struct pci_mmcfg_region *new)
 	struct pci_mmcfg_region *cfg;
 
 	/* keep list sorted by segment and starting bus number */
-	list_for_each_entry_rcu(cfg, &pci_mmcfg_list, list) {
+	list_for_each_entry_rcu(cfg, &pci_mmcfg_list, list, pci_mmcfg_lock_held()) {
 		if (cfg->segment > new->segment ||
 		    (cfg->segment == new->segment &&
 		     cfg->start_bus >= new->start_bus)) {
@@ -118,7 +119,7 @@ struct pci_mmcfg_region *pci_mmconfig_lookup(int segment, int bus)
 {
 	struct pci_mmcfg_region *cfg;
 
-	list_for_each_entry_rcu(cfg, &pci_mmcfg_list, list)
+	list_for_each_entry_rcu(cfg, &pci_mmcfg_list, list, pci_mmcfg_lock_held())
 		if (cfg->segment == segment &&
 		    cfg->start_bus <= bus && bus <= cfg->end_bus)
 			return cfg;
-- 
2.22.0.rc1.311.g5d7573a151-goog

