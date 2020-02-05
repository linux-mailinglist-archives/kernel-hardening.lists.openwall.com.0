Return-Path: <kernel-hardening-return-17671-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 92BAD153B13
	for <lists+kernel-hardening@lfdr.de>; Wed,  5 Feb 2020 23:40:09 +0100 (CET)
Received: (qmail 9436 invoked by uid 550); 5 Feb 2020 22:39:49 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 9276 invoked from network); 5 Feb 2020 22:39:48 -0000
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,407,1574150400"; 
   d="scan'208";a="225092435"
From: Kristen Carlson Accardi <kristen@linux.intel.com>
To: tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	hpa@zytor.com,
	arjan@linux.intel.com,
	keescook@chromium.org
Cc: rick.p.edgecombe@intel.com,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com,
	Kristen Carlson Accardi <kristen@linux.intel.com>
Subject: [RFC PATCH 01/11] modpost: Support >64K sections
Date: Wed,  5 Feb 2020 14:39:40 -0800
Message-Id: <20200205223950.1212394-2-kristen@linux.intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200205223950.1212394-1-kristen@linux.intel.com>
References: <20200205223950.1212394-1-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

According to the ELF specification, if the value of st_shndx
contains SH_XINDEX, the actual section header index is too
large to fit in the st_shndx field and you should use the
value out of the SHT_SYMTAB_SHNDX section instead. This table
was already being parsed and saved into symtab_shndx_start, however
it was not being used, causing segfaults when the number of
sections is greater than 64K. Check the st_shndx field for
SHN_XINDEX prior to using.

Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
---
 scripts/mod/modpost.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 6e892c93d104..5ce7e9dc2f04 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -305,9 +305,23 @@ static const char *sec_name(struct elf_info *elf, int secindex)
 	return sech_name(elf, &elf->sechdrs[secindex]);
 }
 
+static int sym_index(const Elf_Sym *sym, const struct elf_info *info)
+{
+	unsigned long offset;
+	int index;
+
+	if (sym->st_shndx != SHN_XINDEX)
+		return sym->st_shndx;
+
+	offset = (unsigned long)sym - (unsigned long)info->symtab_start;
+	index = offset/(sizeof(*sym));
+
+	return TO_NATIVE(info->symtab_shndx_start[index]);
+}
+
 static void *sym_get_data(const struct elf_info *info, const Elf_Sym *sym)
 {
-	Elf_Shdr *sechdr = &info->sechdrs[sym->st_shndx];
+	Elf_Shdr *sechdr = &info->sechdrs[sym_index(sym, info)];
 	unsigned long offset;
 
 	offset = sym->st_value;
-- 
2.24.1

