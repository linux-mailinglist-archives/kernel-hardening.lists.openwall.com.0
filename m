Return-Path: <kernel-hardening-return-17946-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id B447016F80A
	for <lists+kernel-hardening@lfdr.de>; Wed, 26 Feb 2020 07:36:45 +0100 (CET)
Received: (qmail 14307 invoked by uid 550); 26 Feb 2020 06:36:31 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 14211 invoked from network); 26 Feb 2020 06:36:30 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=fm1; bh=MN4A9pGwx4Xvy
	IA4PshSsOurx0y3KhuXjclcGJOa81k=; b=qKVARIbw0x5eCtrFuPUmoTHDzqDSp
	OJ5CJFklLKBigUnz/imTW09g/D6q2fWBJuMRuc1miBVr8eKhgzldeyS/7Be78HJ8
	4qog7c3SyUW79p03ALOvGxSWJuSviPWjrtxBD3N7OsTNlaUCQ9JxlB9uc6w505Ph
	3tgr/2eO2Thd10y3I9igdLZn68PkXZQgvh5NvbJjASmvS3z5OTwt/giKlWT92r5s
	+aRgkCIRNtGmD4ddHe7RtOUbvYazG/8MvDB7xTzkHS698Bbl9zvgdNyp8zuzlGs/
	YAupSLZ1DAyFy4KWLlfu+W+2RFCoxxokG/yL8F4jZvMgMR6hortGf2EgA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:date:from
	:in-reply-to:message-id:mime-version:references:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; bh=MN4A9pGwx4XvyIA4PshSsOurx0y3KhuXjclcGJOa81k=; b=Iu1I3Rd3
	LmpHdXYQgtkHsifnH0JPCkR5ClZqM3K9WyO8wATLuhwemGQMm4F66fmIdvIx76DW
	2Qj1qOdkwLfWKtNO859Ub0zdytm2OThaNFMYAdHpmQrj9MMRO+ufnMRFv8sR9/5R
	TdglbX7PLJOOQy+A3pezziOKjeLw1/bq+FOxrZw+ayUuqJjaRKb33X8BF/T1Rj2S
	d+Hk8uNXqj+9PspCFtgz5VenEImJS0rj5c2TA7Uo47Ly3Y6o3E8E0XiTPxf0ITbL
	+QKmBkfAXaCZXuwcZWjpSxUJ8Ga/W0PaaH0ZKO8vIMMTkePUygC1yXONps8qvx0y
	/SRbdR6y+W5DTw==
X-ME-Sender: <xms:4RFWXmYup2zcI3yatIANKt8DciA1UtlDG3arGg1G5EJE5-CodKbDcQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrleefgdelkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenfg
    hrlhcuvffnffculddutddmnecujfgurhephffvufffkffojghfggfgsedtkeertdertddt
    necuhfhrohhmpeftuhhsshgvlhhlucevuhhrrhgvhicuoehruhhstghurhesrhhushhsvg
    hllhdrtggtqeenucfkphepuddvvddrleelrdekvddruddtnecuvehluhhsthgvrhfuihii
    vgeptdenucfrrghrrghmpehmrghilhhfrhhomheprhhushgtuhhrsehruhhsshgvlhhlrd
    gttg
X-ME-Proxy: <xmx:4RFWXs2JDd4tCVhkBjOucjkf7Cf0V4JFYLK3Y_svmE2pCq4Y3dtw-Q>
    <xmx:4RFWXn-eoBO9NZZfSThJxdqXUYMgJiw1NabUmU1pNCbwnOYK7IrOoA>
    <xmx:4RFWXl7DmuVaOCOWUhs95RiEG_t3SJP6US9YgnII1s3gb6ZxdxvL4Q>
    <xmx:4RFWXmmH2qFut3eB0SXaJ82N_nVu-MpVewOCCOg8UtuLOJIbTp1Bcw>
From: Russell Currey <ruscur@russell.cc>
To: linuxppc-dev@lists.ozlabs.org
Cc: jniethe5@gmail.com,
	Christophe Leroy <christophe.leroy@c-s.fr>,
	joel@jms.id.au,
	mpe@ellerman.id.au,
	ajd@linux.ibm.com,
	dja@axtens.net,
	npiggin@gmail.com,
	kernel-hardening@lists.openwall.com,
	Russell Currey <ruscur@russell.cc>
Subject: [PATCH v5 2/8] powerpc/kprobes: Mark newly allocated probes as RO
Date: Wed, 26 Feb 2020 17:35:45 +1100
Message-Id: <20200226063551.65363-3-ruscur@russell.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200226063551.65363-1-ruscur@russell.cc>
References: <20200226063551.65363-1-ruscur@russell.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christophe Leroy <christophe.leroy@c-s.fr>

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

