Return-Path: <kernel-hardening-return-15965-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 9A95824435
	for <lists+kernel-hardening@lfdr.de>; Tue, 21 May 2019 01:21:29 +0200 (CEST)
Received: (qmail 3165 invoked by uid 550); 20 May 2019 23:20:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 2029 invoked from network); 20 May 2019 23:20:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W7734R4i6yiyrpZ2h/0MZYkaSGjqvy874mw6G7v61To=;
        b=JrVW7C+LuAQDFNUSIHyGFsz0qBRTL2ZXfCcQco+/ovqwakUWfE/dZjhQKvz317S01W
         wQCGYHVGlpLmUrYgoTdSKOC2hUfqswQYjSLwQhd86heBQlNgOK5fzGaizR8ag3rfBwUw
         lcSrm1YKnCFi+86LywiA0MP5pGK/4PWx3RWMI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W7734R4i6yiyrpZ2h/0MZYkaSGjqvy874mw6G7v61To=;
        b=kO04JQ6PaYG5aBU1Z2zRV2iEiwYEhcADdTGGIU7I5QgQuwdAnY5Q1Y46XoQU+UVLHp
         4QJftbe4kbUWoBLrI9ndUUTFNY1IyaZyxsh7z5WMNisVq6N4VpMYnhxdhsjadFMud5xO
         KBXKu5FQLvTQk9ekBtWt0bkbLkVR1rqi2OqsQfkD2fHGr41ON1iPcVFhNi7Ij1vinn6p
         QHQmmgneQxz44WyeHWJvrZqZDF3aXD7ZiK9blx3Bc24aYFtUVJ7Ny9O4bVs3vCkZxDKd
         d0mEM71M9GqUVM9c6UnTN24eqj+o4odZtIUGtOISbPfhgXqr0u3GmV1smeltUdEqL4Yx
         rjtQ==
X-Gm-Message-State: APjAAAXpKrLiBQzn5Gl5wqoDcIWHMIYPhd5TjDbzOTKCVqA5r54XoEX+
	61Dxxe6T6lLKTrWuRrzOTRmpYFBQIfc=
X-Google-Smtp-Source: APXvYqx11/wdMqn8zECWhWwJqm22F59FOLIqoVe2U28n9IpVe7w901Gx6+y2O7doblMLNbHs30IaWA==
X-Received: by 2002:aa7:87d7:: with SMTP id i23mr82812885pfo.211.1558394412346;
        Mon, 20 May 2019 16:20:12 -0700 (PDT)
From: Thomas Garnier <thgarnie@chromium.org>
To: kernel-hardening@lists.openwall.com
Cc: kristen@linux.intel.com,
	Thomas Garnier <thgarnie@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v7 06/12] x86: pm-trace - Adapt assembly for PIE support
Date: Mon, 20 May 2019 16:19:31 -0700
Message-Id: <20190520231948.49693-7-thgarnie@chromium.org>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
In-Reply-To: <20190520231948.49693-1-thgarnie@chromium.org>
References: <20190520231948.49693-1-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Thomas Garnier <thgarnie@google.com>

Change assembly to use the new _ASM_MOVABS macro instead of _ASM_MOV for
the assembly to be PIE compatible.

Position Independent Executable (PIE) support will allow to extend the
KASLR randomization range below 0xffffffff80000000.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
 arch/x86/include/asm/pm-trace.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/pm-trace.h b/arch/x86/include/asm/pm-trace.h
index bfa32aa428e5..972070806ce9 100644
--- a/arch/x86/include/asm/pm-trace.h
+++ b/arch/x86/include/asm/pm-trace.h
@@ -8,7 +8,7 @@
 do {								\
 	if (pm_trace_enabled) {					\
 		const void *tracedata;				\
-		asm volatile(_ASM_MOV " $1f,%0\n"		\
+		asm volatile(_ASM_MOVABS " $1f,%0\n"		\
 			     ".section .tracedata,\"a\"\n"	\
 			     "1:\t.word %c1\n\t"		\
 			     _ASM_PTR " %c2\n"			\
-- 
2.21.0.1020.gf2820cf01a-goog

