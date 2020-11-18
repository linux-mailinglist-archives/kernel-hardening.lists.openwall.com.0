Return-Path: <kernel-hardening-return-20411-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id EFCFB2B8762
	for <lists+kernel-hardening@lfdr.de>; Wed, 18 Nov 2020 23:08:38 +0100 (CET)
Received: (qmail 3087 invoked by uid 550); 18 Nov 2020 22:07:56 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1964 invoked from network); 18 Nov 2020 22:07:55 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=7xcmRRx6qvqOlAhBXvPUxdlcJiFGDszFPn6Uy8LsYGg=;
        b=JUEhAG5/26jx0k7UneLL1f8TdMXEdBCuTZJVLjQZ+iZWRpM2bbt0EXRlMyK8xh/rhj
         JL4aCETLnrd/8DvtoDDkLX34DHCsBE1h9hQQTOHP3TNRNJUaUtVu/5oPiKBq0scCRP6Z
         +kh1Oyf9NPyMM2Lo7bgcXU9P4bjc/YYA21H9WcxDydQqHpZaclET/mWLe+Q6TCvtF3wo
         mKxhKgjFnSmEhpPgl/7XzG7iiLKXi7xIewYjRRnbWXMkQNf1t/hl5/7hnFoxRkDw2MOb
         rVfAfcrlGtLV3PMRjEVyZEJWFeaaAKgzOew1LFSh6KyTd7yH/s0nFEbQGjmL0toalfsR
         lLAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=7xcmRRx6qvqOlAhBXvPUxdlcJiFGDszFPn6Uy8LsYGg=;
        b=tH+tioci4ERmGmUuKesH3zSC7D2QQ0wOumifv8d0Rg38zgurQyUMimSPFVThdf0je5
         xRjW+iZHycMiec5sGtvT9jfl4OwQU6G96AR43QmyjS7pPqMZ6S+jwWYuE4fAtx0aWFF/
         af5vDTpkYSAjN8KOhNpf2AgNNBFMuszBdkkJSObJHNmTH/OI/amlAzpDM4UwYRQSbo61
         n77Rrng+eIDRqUCqVuf1kzF/7djmnmz9ktKFya5sFomJQjXWaM87k5vgheCO+PpntIEd
         T0ScT7LkWMo82S77J8f1prJocrRz2IDmbTJhDv1psHOGM5vEUy7F5KoAlD2ESq6tRyJh
         QlBw==
X-Gm-Message-State: AOAM531T+Nv5ohvBedyCqQgxVXZbjAj4eGuKvnVG6neTQnDeFbkulzDR
	WZv2cZPsLYRZFpqpUx2MQr1kwbpf2VJ+TTOwGcw=
X-Google-Smtp-Source: ABdhPJwZi43l7NEtfrn2Ph6B8PwX83axN27eYs3bBjDKHIbJhot79HMgDc9/Lz03zP5kBQUcskAGDJr3yB94zqzoXoQ=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a0c:8004:: with SMTP id
 4mr7501644qva.5.1605737263123; Wed, 18 Nov 2020 14:07:43 -0800 (PST)
Date: Wed, 18 Nov 2020 14:07:19 -0800
In-Reply-To: <20201118220731.925424-1-samitolvanen@google.com>
Message-Id: <20201118220731.925424-6-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201118220731.925424-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.29.2.454.gaff20da3a2-goog
Subject: [PATCH v7 05/17] kbuild: lto: merge module sections
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
2.29.2.299.gdc1121823c-goog

