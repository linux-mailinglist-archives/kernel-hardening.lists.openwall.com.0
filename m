Return-Path: <kernel-hardening-return-17113-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 52B16E4723
	for <lists+kernel-hardening@lfdr.de>; Fri, 25 Oct 2019 11:28:26 +0200 (CEST)
Received: (qmail 5323 invoked by uid 550); 25 Oct 2019 09:27:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 19573 invoked from network); 24 Oct 2019 22:52:18 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Ut7YUpLvWAiZLonPATqZ5OL9tOEZJcNF7+tDsNdHEWU=;
        b=Yue9uHjmOjCVuztIQPd86DzimLWI+fR6hTvdgEK/61gESlizanN/A26bP9cX7dKHQZ
         oLJaaihwQeZ8TJTaC/aUcwdebnAqYL1UA2240obxSIMDp+j8AnFncQVqEMSmDWOZyolB
         ZdO6BTWxOJWZJrdCoEIXzyAMbQCBE/lBQOUYz7LfURQr9FE/nOgK5wI5aA/YpCOOoAKs
         ulfAhIsP7AvmLnNWY84oHIXlg/HfyhUjn7orwuaGMA3KCGHEhcJBj/YnjJpM4c+XXuZ0
         YSvScvKza86L+Kajd8Kd/l8lRkcS8nw1BRebOUAsJOMUPyf3RTIJKK6kMU656U4CuO/+
         09vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Ut7YUpLvWAiZLonPATqZ5OL9tOEZJcNF7+tDsNdHEWU=;
        b=QeMfFfCb0LXqjJLl7pYpYpKg2lgGfARctFFeOPl4mbtl5vCBP+OlAlELiX5jtK1xRx
         lokHfiHb/BdYceEpu3MSHze/VMkXlWqJuUMSbp4mPk8JDTwZsuLHe20W4ol6p1pagJ2B
         WEiDIkpP4lzjLWeX0AjngLNHPHQkftRK0fBp95B23s3uSk5oLt12Kc9BmPcq/mchkixV
         hRW/1S2NcnQhMdmamiCeMzfXu5REj8Kwb/DLY4kLhrNK6OqMR1eP2xI5DGE9FL01T8zn
         1MdMWKPNuEr7gs7q8POUX3jDB7maLy7aiZlIBCVgqotsqoh9/DsR0VPPDh3qdTBtmMOX
         +hSA==
X-Gm-Message-State: APjAAAWnB2vgtxkXMNN4VWMkqmtgo4iYRGhpn7a2xOUUNgvd81QPogOB
	kt91Q2lW30xuJCsZh7OA6eYgxdj/i6LaKfw3BnI=
X-Google-Smtp-Source: APXvYqyIrzZDUZW/ai1FBaSFozXCzV2dy/HKURTLyrbV1w3X+deCMyV91eFC953B77j0GjtVKG+bkdsaiwl8eZ9vJk4=
X-Received: by 2002:a63:495b:: with SMTP id y27mr505887pgk.438.1571957526087;
 Thu, 24 Oct 2019 15:52:06 -0700 (PDT)
Date: Thu, 24 Oct 2019 15:51:23 -0700
In-Reply-To: <20191024225132.13410-1-samitolvanen@google.com>
Message-Id: <20191024225132.13410-9-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20191024225132.13410-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
Subject: [PATCH v2 08/17] kprobes: fix compilation without CONFIG_KRETPROBES
From: samitolvanen@google.com
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, 
	Nick Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, clang-built-linux@googlegroups.com, 
	kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

kprobe_on_func_entry and arch_kprobe_on_func_entry need to be available
even if CONFIG_KRETPROBES is not selected.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
---
 kernel/kprobes.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 53534aa258a6..b5e20a4669b8 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1829,6 +1829,25 @@ unsigned long __weak arch_deref_entry_point(void *entry)
 	return (unsigned long)entry;
 }
 
+bool __weak arch_kprobe_on_func_entry(unsigned long offset)
+{
+	return !offset;
+}
+
+bool kprobe_on_func_entry(kprobe_opcode_t *addr, const char *sym, unsigned long offset)
+{
+	kprobe_opcode_t *kp_addr = _kprobe_addr(addr, sym, offset);
+
+	if (IS_ERR(kp_addr))
+		return false;
+
+	if (!kallsyms_lookup_size_offset((unsigned long)kp_addr, NULL, &offset) ||
+						!arch_kprobe_on_func_entry(offset))
+		return false;
+
+	return true;
+}
+
 #ifdef CONFIG_KRETPROBES
 /*
  * This kprobe pre_handler is registered with every kretprobe. When probe
@@ -1885,25 +1904,6 @@ static int pre_handler_kretprobe(struct kprobe *p, struct pt_regs *regs)
 }
 NOKPROBE_SYMBOL(pre_handler_kretprobe);
 
-bool __weak arch_kprobe_on_func_entry(unsigned long offset)
-{
-	return !offset;
-}
-
-bool kprobe_on_func_entry(kprobe_opcode_t *addr, const char *sym, unsigned long offset)
-{
-	kprobe_opcode_t *kp_addr = _kprobe_addr(addr, sym, offset);
-
-	if (IS_ERR(kp_addr))
-		return false;
-
-	if (!kallsyms_lookup_size_offset((unsigned long)kp_addr, NULL, &offset) ||
-						!arch_kprobe_on_func_entry(offset))
-		return false;
-
-	return true;
-}
-
 int register_kretprobe(struct kretprobe *rp)
 {
 	int ret = 0;
-- 
2.24.0.rc0.303.g954a862665-goog

