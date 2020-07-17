Return-Path: <kernel-hardening-return-19376-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id C2E8E22414B
	for <lists+kernel-hardening@lfdr.de>; Fri, 17 Jul 2020 19:00:55 +0200 (CEST)
Received: (qmail 5443 invoked by uid 550); 17 Jul 2020 17:00:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 5399 invoked from network); 17 Jul 2020 17:00:37 -0000
IronPort-SDR: gmNa77vgTK98uDsEwPIxLeEFwXQPfcseZepNJxJ0su6eGZfz7qsqx9nYT6OKNjveu92uiBldOI
 edpn9LLkuJlg==
X-IronPort-AV: E=McAfee;i="6000,8403,9685"; a="167773777"
X-IronPort-AV: E=Sophos;i="5.75,362,1589266800"; 
   d="scan'208";a="167773777"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
IronPort-SDR: YD8LS8cLsoXNAWwVei30GXmcCE2h7XpytjuYYlCGZNftLJ3LEHvqt3ks4PtvSBIw+y6vWNjsRH
 TSCZNWQa1wAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,362,1589266800"; 
   d="scan'208";a="270861825"
From: Kristen Carlson Accardi <kristen@linux.intel.com>
To: keescook@chromium.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>
Cc: arjan@linux.intel.com,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com,
	rick.p.edgecombe@intel.com,
	Kristen Carlson Accardi <kristen@linux.intel.com>
Subject: [PATCH v4 01/10] objtool: Do not assume order of parent/child functions
Date: Fri, 17 Jul 2020 09:59:58 -0700
Message-Id: <20200717170008.5949-2-kristen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200717170008.5949-1-kristen@linux.intel.com>
References: <20200717170008.5949-1-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If a .cold function is examined prior to it's parent, the link
to the parent/child function can be overwritten when the parent
is examined. Only update pfunc and cfunc if they were previously
nil to prevent this from happening.

Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 tools/objtool/elf.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 26d11d821941..c18f0f216740 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -434,7 +434,13 @@ static int read_symbols(struct elf *elf)
 			size_t pnamelen;
 			if (sym->type != STT_FUNC)
 				continue;
-			sym->pfunc = sym->cfunc = sym;
+
+			if (sym->pfunc == NULL)
+				sym->pfunc = sym;
+
+			if (sym->cfunc == NULL)
+				sym->cfunc = sym;
+
 			coldstr = strstr(sym->name, ".cold");
 			if (!coldstr)
 				continue;
-- 
2.20.1

