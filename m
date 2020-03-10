Return-Path: <kernel-hardening-return-18115-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id D9BFC17ED95
	for <lists+kernel-hardening@lfdr.de>; Tue, 10 Mar 2020 02:04:41 +0100 (CET)
Received: (qmail 25754 invoked by uid 550); 10 Mar 2020 01:04:21 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 25656 invoked from network); 10 Mar 2020 01:04:20 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=fm1; bh=rbKCbCnmR9GXx
	mtJou+K7Pnxzo/ovG3+Yd2kZ0wEDhA=; b=oeizcQzI4Ef8d3DdoggyRSJGO9l1E
	Hj0oNPN1ciaJ2C+itnhDvZl6M4U/ZWQIQszds0jnY1SlHx5cnt1aUjBOcLHfX4gu
	1iBMZECH6QAeWFcc2lQu2Fu5rLeJkABtgpEJAkeetJIstUytDVKh9Xw1DQyBHkOb
	QwJ/i59XBbQuqysVoZe2dUR9ekdWvHiR02mjzNB8UbF6gwQvaoJyO8Fo4NdDYvLJ
	8bB2w1RoP+xXentEJly93gRS3plY9QuPMDC8AhqaybHBIXCavtEUGDBaaJbBZyN6
	9uKx18paIfrD/cjOPn/eUyJOdDvzaFnxDwp+h/LfAFh6aejdd3B7bnfpg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:date:from
	:in-reply-to:message-id:mime-version:references:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; bh=rbKCbCnmR9GXxmtJou+K7Pnxzo/ovG3+Yd2kZ0wEDhA=; b=4EtLZISv
	PWXvRcLZzh6BkE+I3HwyNdNtcrEfmCfnP8wjZ9QgflWgJFO3SA1zbwWXpCL2drVD
	W/KMaqZohrZNWNbtBs18KW2TxNb8RalZleOohjKGL4QQc3p14YVsFIy3vNXa5oEv
	TGvNlnnNt5pfTAZb1xE842gj82GKBADxKhPddmatC1jpi7DslcHTxOylC5UAE+Uc
	SLlRJYQsjfqXXzJ5W/sjdwNr6i1/+igiFyQ573U9SKXPXpG1vUT2HcUdzmk9fjs+
	GFe9jqH9DC8VRvpQNJk32nKU/cXlpTJYcqySilsixSZ5SQVGfPGSZJOg5CqlpYsg
	7xXQ5nwvv3trMw==
X-ME-Sender: <xms:iedmXiqZzkYnqMx5xmRfCnMgJUk8WCtn9qryU0NNtj_5p8Jyqg0v4Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudduledgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdluddtmdenucfjughrpefhvf
    fufffkofgjfhgggfestdekredtredttdenucfhrhhomheptfhushhsvghllhcuvehurhhr
    vgihuceorhhushgtuhhrsehruhhsshgvlhhlrdgttgeqnecukfhppeduvddvrdelledrke
    dvrddutdenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhm
    pehruhhstghurhesrhhushhsvghllhdrtggt
X-ME-Proxy: <xmx:iedmXg-kaOac3--OPyjdZKIrcWtAJ_Ecw7QLeidZgCld-DYwO2NjGQ>
    <xmx:iedmXrIvtC-Ug1t_WYtrJ4LWzGKhqR5scP5s2ROS4c3yimsDX5ddyA>
    <xmx:iedmXlX22Ia92jC7wPNcIlaMNBsxTwrWNaQgw_8uez527A1imHDeTA>
    <xmx:iedmXlUe9nfb4cnJQXmqWIP5f7Ko65VzyEvb2LRPDxn1lvzpCLf2zQ>
From: Russell Currey <ruscur@russell.cc>
To: linuxppc-dev@lists.ozlabs.org
Cc: Russell Currey <ruscur@russell.cc>,
	christophe.leroy@c-s.fr,
	joel@jms.id.au,
	mpe@ellerman.id.au,
	ajd@linux.ibm.com,
	dja@axtens.net,
	npiggin@gmail.com,
	kernel-hardening@lists.openwall.com
Subject: [PATCH v6 2/7] powerpc/kprobes: Mark newly allocated probes as RO
Date: Tue, 10 Mar 2020 12:03:33 +1100
Message-Id: <20200310010338.21205-3-ruscur@russell.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310010338.21205-1-ruscur@russell.cc>
References: <20200310010338.21205-1-ruscur@russell.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With CONFIG_STRICT_KERNEL_RWX=y and CONFIG_KPROBES=y, there will be one
W+X page at boot by default.  This can be tested with
CONFIG_PPC_PTDUMP=y and CONFIG_PPC_DEBUG_WX=y set, and checking the
kernel log during boot.

powerpc doesn't implement its own alloc() for kprobes like other
architectures do, but we couldn't immediately mark RO anyway since we do
a memcpy to the page we allocate later.  After that, nothing should be
allowed to modify the page, and write permissions are removed well
before the kprobe is armed.

The memcpy() would fail if >1 probes were allocated, so use
patch_instruction() instead which is safe for RO.

Reviewed-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: Russell Currey <ruscur@russell.cc>
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 arch/powerpc/kernel/kprobes.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kernel/kprobes.c b/arch/powerpc/kernel/kprobes.c
index 2d27ec4feee4..bfab91ded234 100644
--- a/arch/powerpc/kernel/kprobes.c
+++ b/arch/powerpc/kernel/kprobes.c
@@ -24,6 +24,8 @@
 #include <asm/sstep.h>
 #include <asm/sections.h>
 #include <linux/uaccess.h>
+#include <linux/set_memory.h>
+#include <linux/vmalloc.h>
 
 DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
 DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
@@ -102,6 +104,16 @@ kprobe_opcode_t *kprobe_lookup_name(const char *name, unsigned int offset)
 	return addr;
 }
 
+void *alloc_insn_page(void)
+{
+	void *page = vmalloc_exec(PAGE_SIZE);
+
+	if (page)
+		set_memory_ro((unsigned long)page, 1);
+
+	return page;
+}
+
 int arch_prepare_kprobe(struct kprobe *p)
 {
 	int ret = 0;
@@ -124,11 +136,8 @@ int arch_prepare_kprobe(struct kprobe *p)
 	}
 
 	if (!ret) {
-		memcpy(p->ainsn.insn, p->addr,
-				MAX_INSN_SIZE * sizeof(kprobe_opcode_t));
+		patch_instruction(p->ainsn.insn, *p->addr);
 		p->opcode = *p->addr;
-		flush_icache_range((unsigned long)p->ainsn.insn,
-			(unsigned long)p->ainsn.insn + sizeof(kprobe_opcode_t));
 	}
 
 	p->ainsn.boostable = 0;
-- 
2.25.1

