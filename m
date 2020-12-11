Return-Path: <kernel-hardening-return-20587-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id DFBFE2D7E67
	for <lists+kernel-hardening@lfdr.de>; Fri, 11 Dec 2020 19:47:38 +0100 (CET)
Received: (qmail 6139 invoked by uid 550); 11 Dec 2020 18:46:58 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 6060 invoked from network); 11 Dec 2020 18:46:57 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=IWPxRCPjFejanLxpgRG3fapg45p9YOPZWT66lZNPqfI=;
        b=NmW10Ys2Tgg9pvNOzRC87vTxzQN/QNTXAjHd7AFTV8ok00h9tGhhYMLsRuxKeNhXDl
         iMPagwzzegEY0NAWkP8VdeyEnPICgOM5AE4FTcCbPPAinuDjGz68sbCLgXPYhkRq1Pep
         /oDzt2sWciOe12Hb0BMOoaCF9qAfZgz+jdivhEhkTAz3ohV7gcdM13QrPXPixLmDjCSe
         nTPKcCoKQq0gq3xcii2Dkj1W1xDXw/X3VKykyVsM1VgUoEe62p+1hemZShAFUHpH1Tsi
         8OfLqN3hCowWbgVvrwWk8fm6stKJ1NblXBwjNE+NVf/Ofnn3fkAOASnNgDC94IzGVftK
         2nnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=IWPxRCPjFejanLxpgRG3fapg45p9YOPZWT66lZNPqfI=;
        b=n860g/hg8XvFhaseVCYkfPQY+xbyPeTNd8+WskloZcjIekSbXtvMVxZ5ioSUwo0P7u
         wlzHhXxzvZgpcB8R19kYfhTSdqSk8P9Etk0bJ5GCZLeVsM4kczQogmwxS5ezXj/1d8DR
         IuupaAk15BtLoUIIqMVxFKlYMrhRB0tjdFu5onB7bhk7av5gdRGN5mcC+KEfjimcRll+
         j/VR9gWv3LB57y/A38FwFrRI8G+N+Mm+/ymzokoVi5o+zVR73XB9xNV7zPQXPU7fp+KJ
         HW7VT+o7eGNAy/s6wyyufjAgkEAax6soZhhAR5LCwcASJBClwXX3rrpO088YOnt3U/Gg
         BdbQ==
X-Gm-Message-State: AOAM531gWjg1gcDhEdp0droqfvMAeZsO6mnuDXDBYa2W1DXoyxEMNZ0y
	pt+n7RVfWsgSb6oGIDKnWf+/kUyyrKSCXKAYK1U=
X-Google-Smtp-Source: ABdhPJzm7bBo2qDvtUgK6v6rrLGQ/0dJj/ATzhcF3Fgu3P9N3k/LVow1+5c7Y8w8YkEUkh1r4Djckvq7KIZM8TNXHU4=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a17:90a:8b94:: with SMTP id
 z20mr136813pjn.1.1607712405109; Fri, 11 Dec 2020 10:46:45 -0800 (PST)
Date: Fri, 11 Dec 2020 10:46:22 -0800
In-Reply-To: <20201211184633.3213045-1-samitolvanen@google.com>
Message-Id: <20201211184633.3213045-6-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201211184633.3213045-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
Subject: [PATCH v9 05/16] kbuild: lto: merge module sections
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Will Deacon <will@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, 
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-pci@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

LLD always splits sections with LTO, which increases module sizes. This
change adds linker script rules to merge the split sections in the final
module.

Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 scripts/module.lds.S | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/scripts/module.lds.S b/scripts/module.lds.S
index 69b9b71a6a47..18d5b8423635 100644
--- a/scripts/module.lds.S
+++ b/scripts/module.lds.S
@@ -23,6 +23,30 @@ SECTIONS {
 	.init_array		0 : ALIGN(8) { *(SORT(.init_array.*)) *(.init_array) }
 
 	__jump_table		0 : ALIGN(8) { KEEP(*(__jump_table)) }
+
+	__patchable_function_entries : { *(__patchable_function_entries) }
+
+	/*
+	 * With CONFIG_LTO_CLANG, LLD always enables -fdata-sections and
+	 * -ffunction-sections, which increases the size of the final module.
+	 * Merge the split sections in the final binary.
+	 */
+	.bss : {
+		*(.bss .bss.[0-9a-zA-Z_]*)
+		*(.bss..L*)
+	}
+
+	.data : {
+		*(.data .data.[0-9a-zA-Z_]*)
+		*(.data..L*)
+	}
+
+	.rodata : {
+		*(.rodata .rodata.[0-9a-zA-Z_]*)
+		*(.rodata..L*)
+	}
+
+	.text : { *(.text .text.[0-9a-zA-Z_]*) }
 }
 
 /* bring in arch-specific sections */
-- 
2.29.2.576.ga3fc446d84-goog

