Return-Path: <kernel-hardening-return-19128-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id B4878207D61
	for <lists+kernel-hardening@lfdr.de>; Wed, 24 Jun 2020 22:36:16 +0200 (CEST)
Received: (qmail 3590 invoked by uid 550); 24 Jun 2020 20:33:47 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3500 invoked from network); 24 Jun 2020 20:33:46 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=39oSk63TLcybcU14SgKvCDK3H6XzHtEtduXPCr/44ss=;
        b=ZOpDZdrGdHh1ZJonf0E/5dDbHERSe6TbCFmdB2U6jPIiwcNANMbLkyJvmpov2k2xOy
         UVWsqBFfeytL+Hgc/oR6FsAd9G11hUgAXJsCWawlND5MVBWd0mWD5Dc0EmC9ABVsRrwk
         SuNrnMuN7GhuqelKUl2otkPK4jEY0L0Bm6whau77q3fZbpcyNGO1mB7+EOqkQJEsefdW
         zLLLl7cpOUj8LxrFN5V51O7w7SPh0uXELCQRumvXzfHQsZ4xwEEn1hGOm5BLrbAhkADT
         mOeNJdhYt+ZgbwtN0PEW0MGrw4iretwo3Lq6tyaoaAFryjr8t8wGNBEOp88gmFSQ4dk6
         T0OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=39oSk63TLcybcU14SgKvCDK3H6XzHtEtduXPCr/44ss=;
        b=e0pATD3OFAklGXFdU/t7srdITbdahoMluk8PTXEwUmAVk7HuTB1hhOE7GTey/LNL0u
         eDhkARNvFSXt9rFwSgKbneu0lDKDdcExSjhlUT9RNB6LBm0LtEJSc4oywemhJ+HEGTid
         fCgGHaqJbvMBbBaGZQIbS/pjABLNmdNqPjm0BtCGUxaZlRBcefK2Cci0L8yX+/rrzurW
         7LLvF0sxEjsxr6WI/Uk83cSvFYcDJzL2ohrunV23u9InTjM3zz1+JGZZ6SAKRrAgNWUk
         sBbNOYR21U2GQR744XxRbc82dwTfK4OHKX6wXz9A9Xfp+2yIWKLlf4AL08QcraRMVEeE
         5LCA==
X-Gm-Message-State: AOAM530U6GNpILAqtKZC/W9CPhbUxXFDH+5FCtbHfJnE+T4sRS8cOLK8
	PGaFkAJVKOP9OH5U7USGadSBT0HlMC28w7STl7c=
X-Google-Smtp-Source: ABdhPJzI2BesdcUkxRPNmsNayE+wa07nV1TDxi5hKxZeEiEV2jo0nWBCJ/1Nmj0kWHXA23yigO5wL2sAexNblZcBJws=
X-Received: by 2002:ad4:52e2:: with SMTP id p2mr33679309qvu.100.1593030814530;
 Wed, 24 Jun 2020 13:33:34 -0700 (PDT)
Date: Wed, 24 Jun 2020 13:31:58 -0700
In-Reply-To: <20200624203200.78870-1-samitolvanen@google.com>
Message-Id: <20200624203200.78870-21-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
Subject: [PATCH 20/22] x86, ftrace: disable recordmcount for ftrace_make_nop
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, 
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-pci@vger.kernel.org, x86@kernel.org, 
	Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

Ignore mcount relocations in ftrace_make_nop.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 arch/x86/kernel/ftrace.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 51504566b3a6..c3b28b81277b 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -121,6 +121,7 @@ ftrace_modify_code_direct(unsigned long ip, const char *old_code,
 	return 0;
 }
 
+__nomcount
 int ftrace_make_nop(struct module *mod, struct dyn_ftrace *rec, unsigned long addr)
 {
 	unsigned long ip = rec->ip;
-- 
2.27.0.212.ge8ba1cc988-goog

