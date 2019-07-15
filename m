Return-Path: <kernel-hardening-return-16460-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 3070369286
	for <lists+kernel-hardening@lfdr.de>; Mon, 15 Jul 2019 16:37:34 +0200 (CEST)
Received: (qmail 25959 invoked by uid 550); 15 Jul 2019 14:37:27 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 25939 invoked from network); 15 Jul 2019 14:37:26 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E7QZZq5pfHTgMJ3vH2UDhoOJrQnPKGkzOZ3GHEEUhcU=;
        b=LBDEVHZwxQfvLHpYfqXUjHIC7+eaXCEg0P4lmbNzqfUZVyptAL1NxCuL5fnTBDOT3t
         fSgDaEOqCi+Lof2MfQoZFSAG0K7rTeXzv99iBcCCWlK1BmnRADMoZ+hYjTSdSHxXGbhJ
         pa4NywCtevulj0BPrbxEkfRYgFesbgb1OL/Ig=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E7QZZq5pfHTgMJ3vH2UDhoOJrQnPKGkzOZ3GHEEUhcU=;
        b=jeZSktmly6JXjWT2qndDM8eHeW3d33DLL5YZXBKfCGdMxh4o0QrrdAFzigjpFZIy7T
         zIaeKBxF+42fzGytTqGDFU+nA8ZbZ6/JUkTtW9TUwobdi2m4GQXAWUquZxHioCBTiYqI
         gvk5layW0wurjPTnXnjo8q1/RyPRM+9zZJh66JUxtcLvaxWPJOooWivu165L+0kag+cs
         tKa6AEKrw9PfKgHtauvBLzqx5YpeZL6yGpCdrYRcHCA9TtycUy0JfuvZtkGQt1cfFAaQ
         b9LewEFGoagfZTOLsiHlBpdjClH03zvKFJAj1nsWv8S8s2tjSSfV4TUdxxu1CCOmYEW1
         tr7g==
X-Gm-Message-State: APjAAAX2zIV0FqjmgPDa2PBhAqliU1X+Zv5SYQxQ77YF1X/Eo/nXHV8D
	gTg/XWOwAzrTCkc5JEQegN4=
X-Google-Smtp-Source: APXvYqwAlvkHRb1Bt1ZxYce12JrE+evqy+VNsHjMa37inD7oSkAilDXywijCgWzsSyfjuIz+vnfRGg==
X-Received: by 2002:a17:90a:a116:: with SMTP id s22mr29432734pjp.47.1563201433872;
        Mon, 15 Jul 2019 07:37:13 -0700 (PDT)
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
Subject: [PATCH 0/9] Harden list_for_each_entry_rcu() and family
Date: Mon, 15 Jul 2019 10:36:56 -0400
Message-Id: <20190715143705.117908-1-joel@joelfernandes.org>
X-Mailer: git-send-email 2.22.0.510.g264f2c817a-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,
This series aims to provide lockdep checking to RCU list macros for additional
kernel hardening.

RCU has a number of primitives for "consumption" of an RCU protected pointer.
Most of the time, these consumers make sure that such accesses are under a RCU
reader-section (such as rcu_dereference{,sched,bh} or under a lock, such as
with rcu_dereference_protected()).

However, there are other ways to consume RCU pointers, such as by
list_for_each_entry_rcu or hlist_for_each_enry_rcu. Unlike the rcu_dereference
family, these consumers do no lockdep checking at all. And with the growing
number of RCU list uses (1000+), it is possible for bugs to creep in and go
unnoticed which lockdep checks can catch.

Since RCU consolidation efforts last year, the different traditional RCU
flavors (preempt, bh, sched) are all consolidated. In other words, any of these
flavors can cause a reader section to occur and all of them must cease before
the reader section is considered to be unlocked. Thanks to this, we can
generically check if we are in an RCU reader. This is what patch 1 does. Note
that the list_for_each_entry_rcu and family are different from the
rcu_dereference family in that, there is no _bh or _sched version of this
macro. They are used under many different RCU reader flavors, and also SRCU.
Patch 1 adds a new internal function rcu_read_lock_any_held() which checks
if any reader section is active at all, when these macros are called. If no
reader section exists, then the optional fourth argument to
list_for_each_entry_rcu() can be a lockdep expression which is evaluated
(similar to how rcu_dereference_check() works). If no lockdep expression is
passed, and we are not in a reader, then a splat occurs. Just take off the
lockdep expression after applying the patches, by using the following diff and
see what happens:

+++ b/arch/x86/pci/mmconfig-shared.c
@@ -55,7 +55,7 @@ static void list_add_sorted(struct pci_mmcfg_region *new)
        struct pci_mmcfg_region *cfg;

        /* keep list sorted by segment and starting bus number */
-       list_for_each_entry_rcu(cfg, &pci_mmcfg_list, list, pci_mmcfg_lock_held()) {
+       list_for_each_entry_rcu(cfg, &pci_mmcfg_list, list) {


The optional argument trick to list_for_each_entry_rcu() can also be used in
the future to possibly remove rcu_dereference_{,bh,sched}_protected() API and
we can pass an optional lockdep expression to rcu_dereference() itself. Thus
eliminating 3 more RCU APIs.

Note that some list macro wrappers already do their own lockdep checking in the
caller side. These can be eliminated in favor of the built-in lockdep checking
in the list macro that this series adds. For example, workqueue code has a
assert_rcu_or_wq_mutex() function which is called in for_each_wq().  This
series replaces that in favor of the built-in check.

Also in the future, we can extend these checks to list_entry_rcu() and other
list macros as well, if needed.

Please note that I have kept this option default-disabled under a new config:
CONFIG_PROVE_RCU_LIST. This is so that until all users are converted to pass
the optional argument, we should keep the check disabled. There are about a
1000 or so users and it is not possible to pass in the optional lockdep
expression in a single series since it is done on a case-by-case basis. I did
convert a few users in this series itself.

v2->v3: Simplified rcu-sync logic after rebase (Paul)
	Added check for bh_map (Paul)
	Refactored out more of the common code (Joel)
	Added Oleg ack to rcu-sync patch.

v1->v2: Have assert_rcu_or_wq_mutex deleted (Daniel Jordan)
	Simplify rcu_read_lock_any_held()   (Peter Zijlstra)
	Simplified rcu-sync logic	    (Oleg Nesterov)
	Updated documentation and rculist comments.
	Added GregKH ack.

RFC->v1: 
	Simplify list checking macro (Rasmus Villemoes)

Joel Fernandes (Google) (9):
rcu/update: Remove useless check for debug_locks (v1)
rcu: Add support for consolidated-RCU reader checking (v3)
rcu/sync: Remove custom check for reader-section (v2)
ipv4: add lockdep condition to fix for_each_entry (v1)
driver/core: Convert to use built-in RCU list checking (v1)
workqueue: Convert for_each_wq to use built-in list check (v2)
x86/pci: Pass lockdep condition to pcm_mmcfg_list iterator (v1)
acpi: Use built-in RCU list checking for acpi_ioremaps list (v1)
doc: Update documentation about list_for_each_entry_rcu (v1)

Documentation/RCU/lockdep.txt   | 15 ++++++++---
Documentation/RCU/whatisRCU.txt |  9 ++++++-
arch/x86/pci/mmconfig-shared.c  |  5 ++--
drivers/acpi/osl.c              |  6 +++--
drivers/base/base.h             |  1 +
drivers/base/core.c             | 10 +++++++
drivers/base/power/runtime.c    | 15 +++++++----
include/linux/rcu_sync.h        |  4 +--
include/linux/rculist.h         | 28 +++++++++++++++----
include/linux/rcupdate.h        |  7 +++++
kernel/rcu/Kconfig.debug        | 11 ++++++++
kernel/rcu/update.c             | 48 ++++++++++++++++++---------------
kernel/workqueue.c              | 10 ++-----
net/ipv4/fib_frontend.c         |  3 ++-
14 files changed, 119 insertions(+), 53 deletions(-)

--
2.22.0.510.g264f2c817a-goog

