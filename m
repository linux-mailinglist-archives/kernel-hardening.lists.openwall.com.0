Return-Path: <kernel-hardening-return-17160-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id C91F1E972D
	for <lists+kernel-hardening@lfdr.de>; Wed, 30 Oct 2019 08:32:11 +0100 (CET)
Received: (qmail 31802 invoked by uid 550); 30 Oct 2019 07:31:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 30677 invoked from network); 30 Oct 2019 07:31:52 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=fm3; bh=PStFRxzl4Zn7i
	9v7bh9ypxBUch/1PPtigM566gooksQ=; b=fUbva0VUoW4csLSpYm3mhaiivuyMW
	8sRt1lYCXXnTTZXLkB5LnsRQpohIp+jOLZ7G8E/khms2c6mDCQciP53vZ5ECyykB
	XAXuhSKE/wGmk6vovf5uWpg+w0YvGFPQUhAuTkhJaGZULmeIqvOUtlhw2nzsSfi1
	mZ4IctumSoCBczPZPGmFWV8MtVHfkrK8cTInKsJiv0HjX5tiywY4WPaHJFevt6le
	ew40J9cOoLOJ0z2e49gUlW6lzmk3xY36cgNEQAvTscu5GUeGNkTNOpwCo76vzF52
	ZlA+hgxRPIh7xYHAZQOp7OLJJI0iUN7od84406T22WCgBzcno/xt35Q8w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:date:from
	:in-reply-to:message-id:mime-version:references:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; bh=PStFRxzl4Zn7i9v7bh9ypxBUch/1PPtigM566gooksQ=; b=ddwjSpVs
	LKw6xFqSdtKm03wzi8XylLn+hmh8zexrnB/8UyWyn/dQjOQyYdjkYws6VEHaUf7Q
	/lOYNCoYzSArMuDq90/AkPIbDlN08ULCmT1U2Qjflpg4B8PZcnjbJfa5JxI83vRm
	NJM0VrWB/pzCv3iXAimWOJogfwF2A2liXElzTADN3M29W9eg9+O2RvpkBC3An205
	Y5evhL9SfXgKclnlVkMbauOfB5R5p5z/biylFgN0I0rbsxW4x1qHBKO5jtYk7tor
	JEROSdBWvMk7dsoaIKQU6To+cnPNMqsA4DhWnXIUY8uGd5EmT0poPvyrsXdCXTbv
	oCr9hGuKhQlx8A==
X-ME-Sender: <xms:Wzy5XUtUpGh_J3tFRNuk685KcAFHDfUnJ2ZbpS1SbbCQMhmBMigntw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddtvddguddtlecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdeftddmnecujfgurhephf
    fvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeftuhhsshgvlhhlucevuhhr
    rhgvhicuoehruhhstghurhesrhhushhsvghllhdrtggtqeenucfkphepuddvvddrleelrd
    ekvddruddtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehruhhstghurhesrhhushhsvghl
    lhdrtggtnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:Wzy5XbQKNx2Z1lMoi3eTW7w0IVPhbQmyOcPRLI6uhECqGej3G-gQdw>
    <xmx:Wzy5XcXOXuazJwufNpq4mmsDkUf06qNhC6DEf3d6AIJB4he6art3kQ>
    <xmx:Wzy5XUmCB9BiYtsUUUFi71_lo-zcDGkim07Dn4aJ9UjHkkiUZpZN3A>
    <xmx:Wzy5XZer6bJTupmDmacat4XrGphrb760Doh0XT65wVBBbtYljXoz9w>
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
Subject: [PATCH v5 2/5] powerpc/kprobes: Mark newly allocated probes as RO
Date: Wed, 30 Oct 2019 18:31:08 +1100
Message-Id: <20191030073111.140493-3-ruscur@russell.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191030073111.140493-1-ruscur@russell.cc>
References: <20191030073111.140493-1-ruscur@russell.cc>
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

Thus mark newly allocated probes as read-only once it's safe to do so.

Signed-off-by: Russell Currey <ruscur@russell.cc>
---
 arch/powerpc/kernel/kprobes.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/powerpc/kernel/kprobes.c b/arch/powerpc/kernel/kprobes.c
index 2d27ec4feee4..2610496de7c7 100644
--- a/arch/powerpc/kernel/kprobes.c
+++ b/arch/powerpc/kernel/kprobes.c
@@ -24,6 +24,7 @@
 #include <asm/sstep.h>
 #include <asm/sections.h>
 #include <linux/uaccess.h>
+#include <linux/set_memory.h>
 
 DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
 DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
@@ -131,6 +132,8 @@ int arch_prepare_kprobe(struct kprobe *p)
 			(unsigned long)p->ainsn.insn + sizeof(kprobe_opcode_t));
 	}
 
+	set_memory_ro((unsigned long)p->ainsn.insn, 1);
+
 	p->ainsn.boostable = 0;
 	return ret;
 }
-- 
2.23.0

