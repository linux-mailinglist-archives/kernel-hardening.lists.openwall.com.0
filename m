Return-Path: <kernel-hardening-return-18119-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 0D3CD17ED9A
	for <lists+kernel-hardening@lfdr.de>; Tue, 10 Mar 2020 02:05:20 +0100 (CET)
Received: (qmail 27973 invoked by uid 550); 10 Mar 2020 01:04:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 27887 invoked from network); 10 Mar 2020 01:04:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=fm1; bh=PJ4GD5sq6sfgG
	Ir8/J3SozJ2hDdFuOLXDRL5tWTpJn8=; b=B0i6gA3eneT+TW4RWr+aSYDEBt63g
	wgSD+pvFCViekCCd1pTSgozVlF7Hd62C/dlkSPDtTwqjkZItV/EjaUvDze4lcFFP
	+0FgodaAa3ngPTdyty1pO0XlDJNBXW2FDwGJ/pAUdIS0qYYoRf1BiQXog8pfr5lV
	CRDikYK73WxUUdUxzSKD+KvzQJo2lYdQODX1yDWyHo4Gh5QycyEhV0exOhMQ050o
	dLppM6C2L9gv61Wx0AlPc9tCDN5PGpND8zyPrQftIgZfmzUy4bN8DSzyPHAMAD0f
	4BixeSSbWNYTKufhQmTQ5DsSWMYVj5bbh0uy5wuj3OIKLeIiCqWvhC1zw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:date:from
	:in-reply-to:message-id:mime-version:references:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; bh=PJ4GD5sq6sfgGIr8/J3SozJ2hDdFuOLXDRL5tWTpJn8=; b=bMS9HYmT
	O+/3EHpnzRLb2DNIhxA7w5OiSjG5LD12mb2Ca5oduRYWUBIcMDg3C6vS42F2jDuA
	w2yLxk8XQ3/bbRKcKkXBrBO0qJTxEkzsiHzgVndxo3JqK4j8WPGH48JAGgXbBxRp
	QnPr3qVSDp4PGyIgPie/uTCQCP3gfiw+oykJkMbiM5t24wP11O3KwBSr3hHW6bay
	vzMEsVZrzLDJm60+YhHIPmGsM7QtvO3wqi8IZHjfmBAm22gMM/dg9ibucXBg551E
	M8IxGM+cm2vU7lXzPK/QGsKUWguziB7uMqqMdBZeR6ZBh5gfWXzxeJU+RE8k8vUK
	dAtel2b9CTmVvQ==
X-ME-Sender: <xms:ludmXodvRl869zspg9OMTKqL2D5tv-4HQ7ME10SamdtIVBc0YmdDkg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudduledgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    gfrhhlucfvnfffucdluddtmdenucfjughrpefhvffufffkofgjfhgggfestdekredtredt
    tdenucfhrhhomheptfhushhsvghllhcuvehurhhrvgihuceorhhushgtuhhrsehruhhssh
    gvlhhlrdgttgeqnecukfhppeduvddvrdelledrkedvrddutdenucevlhhushhtvghrufhi
    iigvpeehnecurfgrrhgrmhepmhgrihhlfhhrohhmpehruhhstghurhesrhhushhsvghllh
    drtggt
X-ME-Proxy: <xmx:ludmXqZ9elj2ezda431dHqsfmfLtPa_-QBwc7v7QWn0Bq6Y4GIsItg>
    <xmx:ludmXvRRHguqIZjy64ku6fkHlW4rzMwU8OIOzfWYHSTJx_Qckn4Kog>
    <xmx:ludmXhyTMvgQ9AAL82hDHn10GP_kUkI-gqHAuUXEs-cnirkV9XPiXA>
    <xmx:ludmXksUW3g3Ysq_DASKJkTFjYGPKcYZXjWThAsdmBoQxgcb4p4VRQ>
From: Russell Currey <ruscur@russell.cc>
To: linuxppc-dev@lists.ozlabs.org
Cc: Christophe Leroy <christophe.leroy@c-s.fr>,
	joel@jms.id.au,
	mpe@ellerman.id.au,
	ajd@linux.ibm.com,
	dja@axtens.net,
	npiggin@gmail.com,
	kernel-hardening@lists.openwall.com,
	kbuild test robot <lkp@intel.com>,
	Russell Currey <ruscur@russell.cc>
Subject: [PATCH v6 6/7] powerpc/mm: implement set_memory_attr()
Date: Tue, 10 Mar 2020 12:03:37 +1100
Message-Id: <20200310010338.21205-7-ruscur@russell.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310010338.21205-1-ruscur@russell.cc>
References: <20200310010338.21205-1-ruscur@russell.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christophe Leroy <christophe.leroy@c-s.fr>

In addition to the set_memory_xx() functions which allows to change
the memory attributes of not (yet) used memory regions, implement a
set_memory_attr() function to:
- set the final memory protection after init on currently used
kernel regions.
- enable/disable kernel memory regions in the scope of DEBUG_PAGEALLOC.

Unlike the set_memory_xx() which can act in three step as the regions
are unused, this function must modify 'on the fly' as the kernel is
executing from them. At the moment only PPC32 will use it and changing
page attributes on the fly is not an issue.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Reported-by: kbuild test robot <lkp@intel.com>
[ruscur: cast "data" to unsigned long instead of int]
Signed-off-by: Russell Currey <ruscur@russell.cc>
---
 arch/powerpc/include/asm/set_memory.h |  2 ++
 arch/powerpc/mm/pageattr.c            | 33 +++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/arch/powerpc/include/asm/set_memory.h b/arch/powerpc/include/asm/set_memory.h
index 64011ea444b4..b040094f7920 100644
--- a/arch/powerpc/include/asm/set_memory.h
+++ b/arch/powerpc/include/asm/set_memory.h
@@ -29,4 +29,6 @@ static inline int set_memory_x(unsigned long addr, int numpages)
 	return change_memory_attr(addr, numpages, SET_MEMORY_X);
 }
 
+int set_memory_attr(unsigned long addr, int numpages, pgprot_t prot);
+
 #endif
diff --git a/arch/powerpc/mm/pageattr.c b/arch/powerpc/mm/pageattr.c
index 748fa56d9db0..60139fedc6cc 100644
--- a/arch/powerpc/mm/pageattr.c
+++ b/arch/powerpc/mm/pageattr.c
@@ -77,3 +77,36 @@ int change_memory_attr(unsigned long addr, int numpages, long action)
 
 	return apply_to_page_range(&init_mm, start, sz, change_page_attr, (void *)action);
 }
+
+/*
+ * Set the attributes of a page:
+ *
+ * This function is used by PPC32 at the end of init to set final kernel memory
+ * protection. It includes changing the maping of the page it is executing from
+ * and data pages it is using.
+ */
+static int set_page_attr(pte_t *ptep, unsigned long addr, void *data)
+{
+	pgprot_t prot = __pgprot((unsigned long)data);
+
+	spin_lock(&init_mm.page_table_lock);
+
+	set_pte_at(&init_mm, addr, ptep, pte_modify(*ptep, prot));
+	flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
+
+	spin_unlock(&init_mm.page_table_lock);
+
+	return 0;
+}
+
+int set_memory_attr(unsigned long addr, int numpages, pgprot_t prot)
+{
+	unsigned long start = ALIGN_DOWN(addr, PAGE_SIZE);
+	unsigned long sz = numpages * PAGE_SIZE;
+
+	if (!numpages)
+		return 0;
+
+	return apply_to_page_range(&init_mm, start, sz, set_page_attr,
+				   (void *)pgprot_val(prot));
+}
-- 
2.25.1

