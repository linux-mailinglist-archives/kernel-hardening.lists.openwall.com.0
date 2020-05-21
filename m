Return-Path: <kernel-hardening-return-18836-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 67CCC1DD387
	for <lists+kernel-hardening@lfdr.de>; Thu, 21 May 2020 18:57:41 +0200 (CEST)
Received: (qmail 30626 invoked by uid 550); 21 May 2020 16:57:20 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 30594 invoked from network); 21 May 2020 16:57:19 -0000
IronPort-SDR: drmsxYWQKShNNGIBjoocFceIkCTm/Xgzo5vsbDXQOoYRP1rlZvGyhmykNdkopwBE0JHlc9m5Xj
 D0d6F3579zIg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
IronPort-SDR: aV3JFVvbrYZYbuv7t7Jyrk0/2sjsLErzP4zOHapmIGIX67EvDCFdYOJl51/67vJttU5gLr7E1I
 /Ec0D7WIPZhw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,418,1583222400"; 
   d="scan'208";a="309094669"
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
Subject: [PATCH v2 1/9] objtool: Do not assume order of parent/child functions
Date: Thu, 21 May 2020 09:56:32 -0700
Message-Id: <20200521165641.15940-2-kristen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200521165641.15940-1-kristen@linux.intel.com>
References: <20200521165641.15940-1-kristen@linux.intel.com>
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
index c4857fa3f1d1..b998c853a1f0 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -408,7 +408,13 @@ static int read_symbols(struct elf *elf)
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

