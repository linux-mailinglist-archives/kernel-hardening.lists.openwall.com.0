Return-Path: <kernel-hardening-return-20501-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 610982CAEAB
	for <lists+kernel-hardening@lfdr.de>; Tue,  1 Dec 2020 22:39:25 +0100 (CET)
Received: (qmail 19838 invoked by uid 550); 1 Dec 2020 21:37:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 19728 invoked from network); 1 Dec 2020 21:37:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=aPTc8wYkBIIZS9XLhaJqPHrVGew/rHRzWtLqs6SwnEk=;
        b=vXHUajvUgn40LQCYOvZPKvqCWjM82atINdDHUGd5EhIZaxvZWNECR6Puf1wV/Xm1fz
         RZFUluVJoen54/2OkeSIKDLooJAqo6nO6jmid/KnIY+pQsB0jUK1FLQCjzUfvDCGjqfW
         5DsweDMH7mPM+webX4KoPPbT06j0wd8ib/BAqCtFcLiXN9fRxFfzVzezsrV61oCpnhyb
         7uduG6UItD7EnvVpEffELx2wbLPqlD3Oqd6UlZIDNGhgDg+wEFbzFvokQCivtnRsGs7N
         92Et/EOjPux1Tii1bL3i8/gTtmbaMJpflMTGhVRAPssOG6ib3nwdVtng5zkY0hoNy4H7
         BGdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=aPTc8wYkBIIZS9XLhaJqPHrVGew/rHRzWtLqs6SwnEk=;
        b=BR8vrqbQsinDP2PSskcjURsTqlfucL9geHDHaIE2dP3nidRpcsER4wen0YMNauBGBd
         BVd7kUa77ra2nFAhm1CJVSvlxvqPx05vZXmdDfYs+B/hX/dEJKAMgQk+5EkyA2LfiaPo
         mfBEhqiF2Fa4odLc1Ea+w6XOYIzKCR8ppPNMTfPdG84+ERsMfpCS9V2p1UZZdTccKDZT
         IpIFVUtVaGgwXHw1kkL4C2ciVRi+Bqg56WKcvQucaGavNM7o1xcKNBrLCTtmLH+go5YL
         QBiiXRYSE3FSNFn3kaD3zG+tklMQABLy07kkKHfeZxPnwFyIqwbKf/3szXCfxKN+7Z6R
         Nd7g==
X-Gm-Message-State: AOAM531IaCYUHSw/hpAfNFgtn1KV26v+fKM0CJiXka9xvUfbg3m7S9BY
	8EW/ea4n/jTun9XQBIgGwbET61ex4IIicNRM194=
X-Google-Smtp-Source: ABdhPJx2UMQKvzPc9YbjuAcaOdZsXhK7RlcIM2M9pkfdRpnDBi+U9k28DqELenlSlo2tvxUYIND8c9jWK0Acmjv4ppQ=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:ad4:5685:: with SMTP id
 bc5mr5091015qvb.48.1606858662372; Tue, 01 Dec 2020 13:37:42 -0800 (PST)
Date: Tue,  1 Dec 2020 13:37:04 -0800
In-Reply-To: <20201201213707.541432-1-samitolvanen@google.com>
Message-Id: <20201201213707.541432-14-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201201213707.541432-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
Subject: [PATCH v8 13/16] drivers/misc/lkdtm: disable LTO for rodata.o
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

Disable LTO for rodata.o to allow objcopy to be used to
manipulate sections.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Acked-by: Kees Cook <keescook@chromium.org>
---
 drivers/misc/lkdtm/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/misc/lkdtm/Makefile b/drivers/misc/lkdtm/Makefile
index c70b3822013f..dd4c936d4d73 100644
--- a/drivers/misc/lkdtm/Makefile
+++ b/drivers/misc/lkdtm/Makefile
@@ -13,6 +13,7 @@ lkdtm-$(CONFIG_LKDTM)		+= cfi.o
 
 KASAN_SANITIZE_stackleak.o	:= n
 KCOV_INSTRUMENT_rodata.o	:= n
+CFLAGS_REMOVE_rodata.o		+= $(CC_FLAGS_LTO)
 
 OBJCOPYFLAGS :=
 OBJCOPYFLAGS_rodata_objcopy.o	:= \
-- 
2.29.2.576.ga3fc446d84-goog

