Return-Path: <kernel-hardening-return-16472-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id BFFB66A11E
	for <lists+kernel-hardening@lfdr.de>; Tue, 16 Jul 2019 06:03:26 +0200 (CEST)
Received: (qmail 19857 invoked by uid 550); 16 Jul 2019 04:03:19 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 19838 invoked from network); 16 Jul 2019 04:03:18 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=emWs4O8hlB2TIuNtkX4TCZFbfAkCg1SZuUU8yDd2sEA=;
        b=EUayzWAAPKzWkqzvEU0EkCIPVbFaXgTPLnhPDPXNEGqZowkwVyB0fuRja+ukvx2jRx
         /JsAJvv2ngG4+HyMb/ksTKGTTuCNw6tiK8jigG3DyiGHLTshKdgdlpd3cg/yvXQ34IXh
         LxYQ1MLKK8X//mQ7Xm/s6D4lgquYO/nzn6BMw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=emWs4O8hlB2TIuNtkX4TCZFbfAkCg1SZuUU8yDd2sEA=;
        b=UwGL+1uHfREF1sIuH1bQV+z/azUi84wv/beSdNo9wLfp1Sj3hWCXTFL9QR9HB8kGu+
         Mcpf/Oa31IEJImCkCFnfhktM9TCTKKF2IMfKRA/y0wQpyXstbV3slrN2S2oQYNHbYbEG
         6Ga7oGewsLXIuaSWtDlc/grWUGMjMABBWieoSyaomIBE/QLtctFK0L6kupFeStHsVHX5
         EYA5NV1v+q/pCXDm26auIc79kgrMW2ohFM8bH8RI9QnDI8ZASHA6tLpWuA9Skd7lsdxF
         onjBkFceEaWc/vHKYd+f/GXCSmPz9kVzeReXNHbRclLIrZgertdLr/sEdJWuQr2COKvT
         hAsw==
X-Gm-Message-State: APjAAAXwrGtlnboPu+pLRj4peEmXZ0To7hF+Og2i62GdNTa7brqqlTWF
	nb2aKgX8y1ptnYeuFW6odMA=
X-Google-Smtp-Source: APXvYqxyHJD5IpHHcJaM1ojDiiimToJpqwPzyUOe3rbN2WwHYdOcsvYOosL3yD4qnxS7tzykZLERPg==
X-Received: by 2002:a17:90a:374a:: with SMTP id u68mr33288835pjb.4.1563249786384;
        Mon, 15 Jul 2019 21:03:06 -0700 (PDT)
Date: Tue, 16 Jul 2019 00:03:03 -0400
From: Joel Fernandes <joel@joelfernandes.org>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: linux-kernel@vger.kernel.org, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
	Borislav Petkov <bp@alien8.de>, c0d1n61at3@gmail.com,
	"David S. Miller" <davem@davemloft.net>, edumazet@google.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org,
	kernel-hardening@lists.openwall.com, kernel-team@android.com,
	Lai Jiangshan <jiangshanlai@gmail.com>, Len Brown <lenb@kernel.org>,
	linux-acpi@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, neilb@suse.com,
	netdev@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
	"Paul E. McKenney" <paulmck@linux.ibm.com>,
	Pavel Machek <pavel@ucw.cz>, peterz@infradead.org,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Rasmus Villemoes <rasmus.villemoes@prevas.dk>, rcu@vger.kernel.org,
	Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, will@kernel.org,
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [PATCH 7/9] x86/pci: Pass lockdep condition to pcm_mmcfg_list
 iterator (v1)
Message-ID: <20190716040303.GA73383@google.com>
References: <20190715143705.117908-1-joel@joelfernandes.org>
 <20190715143705.117908-8-joel@joelfernandes.org>
 <20190715200235.GG46935@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190715200235.GG46935@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Jul 15, 2019 at 03:02:35PM -0500, Bjorn Helgaas wrote:
> On Mon, Jul 15, 2019 at 10:37:03AM -0400, Joel Fernandes (Google) wrote:
> > The pcm_mmcfg_list is traversed with list_for_each_entry_rcu without a
> > reader-lock held, because the pci_mmcfg_lock is already held. Make this
> > known to the list macro so that it fixes new lockdep warnings that
> > trigger due to lockdep checks added to list_for_each_entry_rcu().
> > 
> > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> 
> Ingo takes care of most patches to this file, but FWIW,
> 
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>

Thanks.

> I would personally prefer if you capitalized the subject to match the
> "x86/PCI:" convention that's used fairly consistently in
> arch/x86/pci/.
> 
> Also, I didn't apply this to be sure, but it looks like this might
> make a line or two wider than 80 columns, which I would rewrap if I
> were applying this.

Updated below is the patch with the nits corrected:

---8<-----------------------

From 73fab09d7e33ca2110c24215f8ed428c12625dbe Mon Sep 17 00:00:00 2001
From: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Date: Sat, 1 Jun 2019 15:05:49 -0400
Subject: [PATCH] x86/PCI: Pass lockdep condition to pcm_mmcfg_list iterator
 (v1)

The pcm_mmcfg_list is traversed with list_for_each_entry_rcu without a
reader-lock held, because the pci_mmcfg_lock is already held. Make this
known to the list macro so that it fixes new lockdep warnings that
trigger due to lockdep checks added to list_for_each_entry_rcu().

Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 arch/x86/pci/mmconfig-shared.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
index 7389db538c30..9e3250ec5a37 100644
--- a/arch/x86/pci/mmconfig-shared.c
+++ b/arch/x86/pci/mmconfig-shared.c
@@ -29,6 +29,7 @@
 static bool pci_mmcfg_running_state;
 static bool pci_mmcfg_arch_init_failed;
 static DEFINE_MUTEX(pci_mmcfg_lock);
+#define pci_mmcfg_lock_held() lock_is_held(&(pci_mmcfg_lock).dep_map)
 
 LIST_HEAD(pci_mmcfg_list);
 
@@ -54,7 +55,8 @@ static void list_add_sorted(struct pci_mmcfg_region *new)
 	struct pci_mmcfg_region *cfg;
 
 	/* keep list sorted by segment and starting bus number */
-	list_for_each_entry_rcu(cfg, &pci_mmcfg_list, list) {
+	list_for_each_entry_rcu(cfg, &pci_mmcfg_list, list,
+				pci_mmcfg_lock_held()) {
 		if (cfg->segment > new->segment ||
 		    (cfg->segment == new->segment &&
 		     cfg->start_bus >= new->start_bus)) {
@@ -118,7 +120,8 @@ struct pci_mmcfg_region *pci_mmconfig_lookup(int segment, int bus)
 {
 	struct pci_mmcfg_region *cfg;
 
-	list_for_each_entry_rcu(cfg, &pci_mmcfg_list, list)
+	list_for_each_entry_rcu(cfg, &pci_mmcfg_list, list
+				pci_mmcfg_lock_held())
 		if (cfg->segment == segment &&
 		    cfg->start_bus <= bus && bus <= cfg->end_bus)
 			return cfg;
-- 
2.22.0.510.g264f2c817a-goog

