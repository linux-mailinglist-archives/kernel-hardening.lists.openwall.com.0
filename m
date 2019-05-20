Return-Path: <kernel-hardening-return-15961-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id D004524428
	for <lists+kernel-hardening@lfdr.de>; Tue, 21 May 2019 01:20:45 +0200 (CEST)
Received: (qmail 1735 invoked by uid 550); 20 May 2019 23:20:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1668 invoked from network); 20 May 2019 23:20:17 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5q4ihNY2J75cnrZIRES8fAo4iQKm5IxBSJcCX4JVods=;
        b=eZYgThMO0MmLC/WHZ2dPHnJOr7+KHkU0fXOOKCdON8FfqOAre3vvVCYRJ1SR6kSUVb
         eqPTxxStSFEusl+CbXJApLq3D5CT5gx9prgZ1/PP6w+2P41VmcOJ6isnA2NR4o8FPhgQ
         D+GK+Jel3SOsPeno6jdKMM6tucPCbgap3qnks=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5q4ihNY2J75cnrZIRES8fAo4iQKm5IxBSJcCX4JVods=;
        b=R/bNYlCh2zjW6iHRBt2hyD7/uPsVAwH3Xs/C31q+vNyhu7pamkz12/e1wnGtG+oEp6
         U17zuJUrThzfh7pZkJJOLgOuZ8g/dJw9OmY4VXVkwmeBrVRkkRHaHtZAMcb4N4atCRIR
         9zTQVNfs30l0XebXrlfjPMLQqAzwhX/3h/xYW0OVf2+FWaKjMnoxzqNU2v0Fk+iCYz9E
         znZ4wsWlB7nrC9NIj1BKMKpDHee5PX4wLLqGW76bVeFdl1uTOlbALOl9ui1ex9LaODqy
         WUw+v6heEpZEhnOCEulzJ1cMK5I0kYqzjc6qOrvZPBGYiaSSPcTv78zt5FgcfR59axVU
         TltA==
X-Gm-Message-State: APjAAAUk6v425Ns9dTKgpwk0DMzkxEW1//QzpeIPhpy4iUTSph3hnzs+
	GLBZs5Uw8iWiKnIgZUYTS5VnGloRwMU=
X-Google-Smtp-Source: APXvYqxkEqFzO8WUdGIhDFbmcz21X6NtsaHwl1E1vofYxC+QtWucxKvAs1tpP0vLEkhOpewal9sMyg==
X-Received: by 2002:a17:902:5066:: with SMTP id f35mr30205827plh.54.1558394405043;
        Mon, 20 May 2019 16:20:05 -0700 (PDT)
From: Thomas Garnier <thgarnie@chromium.org>
To: kernel-hardening@lists.openwall.com
Cc: kristen@linux.intel.com,
	Thomas Garnier <thgarnie@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Nadav Amit <namit@vmware.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v7 02/12] x86: Use symbol name in jump table for PIE support
Date: Mon, 20 May 2019 16:19:27 -0700
Message-Id: <20190520231948.49693-3-thgarnie@chromium.org>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
In-Reply-To: <20190520231948.49693-1-thgarnie@chromium.org>
References: <20190520231948.49693-1-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Thomas Garnier <thgarnie@google.com>

Replace the %c constraint with %P. The %c is incompatible with PIE
because it implies an immediate value whereas %P reference a symbol.
Change the _ASM_PTR reference to .long for expected relocation size and
add a long padding to ensure entry alignment.

Position Independent Executable (PIE) support will allow to extend the
KASLR randomization range below 0xffffffff80000000.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
 arch/x86/include/asm/jump_label.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_label.h
index 65191ce8e1cf..e47fad8ee632 100644
--- a/arch/x86/include/asm/jump_label.h
+++ b/arch/x86/include/asm/jump_label.h
@@ -25,9 +25,9 @@ static __always_inline bool arch_static_branch(struct static_key *key, bool bran
 		".pushsection __jump_table,  \"aw\" \n\t"
 		_ASM_ALIGN "\n\t"
 		".long 1b - ., %l[l_yes] - . \n\t"
-		_ASM_PTR "%c0 + %c1 - .\n\t"
+		_ASM_PTR "%P0 - .\n\t"
 		".popsection \n\t"
-		: :  "i" (key), "i" (branch) : : l_yes);
+		: :  "X" (&((char *)key)[branch]) : : l_yes);
 
 	return false;
 l_yes:
@@ -42,9 +42,9 @@ static __always_inline bool arch_static_branch_jump(struct static_key *key, bool
 		".pushsection __jump_table,  \"aw\" \n\t"
 		_ASM_ALIGN "\n\t"
 		".long 1b - ., %l[l_yes] - . \n\t"
-		_ASM_PTR "%c0 + %c1 - .\n\t"
+		_ASM_PTR "%P0 - .\n\t"
 		".popsection \n\t"
-		: :  "i" (key), "i" (branch) : : l_yes);
+		: : "X" (&((char *)key)[branch]) : : l_yes);
 
 	return false;
 l_yes:
-- 
2.21.0.1020.gf2820cf01a-goog

