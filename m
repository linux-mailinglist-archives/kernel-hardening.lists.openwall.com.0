Return-Path: <kernel-hardening-return-21228-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 06E01373333
	for <lists+kernel-hardening@lfdr.de>; Wed,  5 May 2021 02:33:16 +0200 (CEST)
Received: (qmail 13748 invoked by uid 550); 5 May 2021 00:32:47 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 13649 invoked from network); 5 May 2021 00:32:45 -0000
IronPort-SDR: 6Tz0DvAJs1kl/Q6Z4ruTsBWgEdvNM2SrOKQ7R9FQ1VgcyhVXHg8i6+M3QDTi+6Dp6cAY0JJgeG
 Pi/XlFm+4Lqw==
X-IronPort-AV: E=McAfee;i="6200,9189,9974"; a="262052478"
X-IronPort-AV: E=Sophos;i="5.82,273,1613462400"; 
   d="scan'208";a="262052478"
IronPort-SDR: ystkmVaLd3ynX9ydNCnx/U8bOYtmoL7EVqOaerYbN9eiXBwAlyVZHDuTDCv0OgBOAZiPRXxDBx
 AVuB95agEXmA==
X-IronPort-AV: E=Sophos;i="5.82,273,1613462400"; 
   d="scan'208";a="429490807"
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: dave.hansen@intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	linux-mm@kvack.org,
	x86@kernel.org,
	akpm@linux-foundation.org,
	linux-hardening@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Cc: ira.weiny@intel.com,
	rppt@kernel.org,
	dan.j.williams@intel.com,
	linux-kernel@vger.kernel.org,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [PATCH RFC 6/9] x86/mm/cpa: Add set_memory_pks()
Date: Tue,  4 May 2021 17:30:29 -0700
Message-Id: <20210505003032.489164-7-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505003032.489164-1-rick.p.edgecombe@intel.com>
References: <20210505003032.489164-1-rick.p.edgecombe@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add function for setting PKS key on kernel memory.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/include/asm/set_memory.h | 1 +
 arch/x86/mm/pat/set_memory.c      | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/arch/x86/include/asm/set_memory.h b/arch/x86/include/asm/set_memory.h
index b63f09cc282a..a2bab1626fdd 100644
--- a/arch/x86/include/asm/set_memory.h
+++ b/arch/x86/include/asm/set_memory.h
@@ -52,6 +52,7 @@ int set_memory_decrypted(unsigned long addr, int numpages);
 int set_memory_np_noalias(unsigned long addr, int numpages);
 int set_memory_nonglobal(unsigned long addr, int numpages);
 int set_memory_global(unsigned long addr, int numpages);
+int set_memory_pks(unsigned long addr, int numpages, int key);
 
 int set_pages_array_uc(struct page **pages, int addrinarray);
 int set_pages_array_wc(struct page **pages, int addrinarray);
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 6877ef66793b..29e61afb4a94 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -1914,6 +1914,13 @@ int set_memory_wb(unsigned long addr, int numpages)
 }
 EXPORT_SYMBOL(set_memory_wb);
 
+int set_memory_pks(unsigned long addr, int numpages, int key)
+{
+	return change_page_attr_set_clr(&addr, numpages, __pgprot(_PAGE_PKEY(key)),
+					__pgprot(_PAGE_PKEY(0xF & ~(unsigned int)key)),
+					0, 0, NULL);
+}
+
 int set_memory_x(unsigned long addr, int numpages)
 {
 	if (!(__supported_pte_mask & _PAGE_NX))
-- 
2.30.2

