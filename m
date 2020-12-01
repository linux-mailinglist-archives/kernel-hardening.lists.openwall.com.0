Return-Path: <kernel-hardening-return-20493-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 98E0A2CAE9D
	for <lists+kernel-hardening@lfdr.de>; Tue,  1 Dec 2020 22:38:11 +0100 (CET)
Received: (qmail 15804 invoked by uid 550); 1 Dec 2020 21:37:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 15722 invoked from network); 1 Dec 2020 21:37:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=IWPxRCPjFejanLxpgRG3fapg45p9YOPZWT66lZNPqfI=;
        b=YDu+NEbK+WVQ3hPM5go5aRizvBPWGGUzdvz8JEp/EAM6XiJoc9pJY3o1c2yVOjp89i
         bM5tOhFBbqEU2HQ2OR1Oz9/GYaHkOiYtWb5Q/Up3jv4DGF65KdvTcqz6rms02w5eohLl
         bSgLnGHcyC3YR0xGck//SCcspRfKindzzlyNPE4Y9xXTCXxQ4vUqhJqdcirb9QLh5+ns
         ApAi4cfhdsSK/ZIzIp7xZ4Eh09o6zM62jKDTDmzug7/qSo6JjgobotZDPriqLtM88GHc
         /m6WRULzENBGmq+MzEixv/Y7a6Pjdo782dcWw/2FdAhHAKNAMhOCFWjGtsnxviZBNnlf
         h74g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=IWPxRCPjFejanLxpgRG3fapg45p9YOPZWT66lZNPqfI=;
        b=CT9DcYuWQU6UdD10KQsIlD/FvhrdlWMQWVwhuVsMWiHBbWiBnc8V6On1kTk2AUyXGh
         Snf4XsGkaZaXKqHSvIPRX5VdnY4f/+P+z7uiXQN3UAYJ6DxBFAk5qBon3vOYtIBby6k/
         +fsPYo9IwH+4rEoBn7Wo14Vw0dLt1MCgY1TlM+xlG7o+ptRo/JN8tVwbr3fpbRJBHlCy
         trbtmqAmaByAVD/9LdrtZm3KXiTIqBIzhL6AaYYlCJZJNmbBoOSLCUqByhgE6YGVsjmx
         0xJkwcDsfFJraO5T4gvF+82Gt1Gldx4G9a15ByNEVcHGU1H3gXvugGQo1NZ0zDPhlwVt
         sYXw==
X-Gm-Message-State: AOAM531CKzIu6ePPFODstS2UaUYkaDNEyDD5Y7Ru0TXGqS/MSKHGl+/F
	i/r7SA9vR8uQ6ebTJ25O8EeKWdvNlWdHwdNFlfs=
X-Google-Smtp-Source: ABdhPJzl3kQyAlKR1pr/4OX/xbphbD6nNLxnI7REpTqaNoxBrsxlLak2ddu4/JEFd5wju+8eNvtcAAOR8w+vlfUWVUM=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a0c:b508:: with SMTP id
 d8mr5050639qve.8.1606858642454; Tue, 01 Dec 2020 13:37:22 -0800 (PST)
Date: Tue,  1 Dec 2020 13:36:56 -0800
In-Reply-To: <20201201213707.541432-1-samitolvanen@google.com>
Message-Id: <20201201213707.541432-6-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201201213707.541432-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
Subject: [PATCH v8 05/16] kbuild: lto: merge module sections
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

