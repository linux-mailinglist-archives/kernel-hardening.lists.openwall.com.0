Return-Path: <kernel-hardening-return-20194-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id C0AD228C62F
	for <lists+kernel-hardening@lfdr.de>; Tue, 13 Oct 2020 02:35:39 +0200 (CEST)
Received: (qmail 20002 invoked by uid 550); 13 Oct 2020 00:33:05 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 19900 invoked from network); 13 Oct 2020 00:33:04 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=BiHYmAAiH626N89XqxkZXfyE7gUyoYuU5gV65m3nGjQ=;
        b=XNjBIDINKT2pRuTcs85XqtGqpKKB5NK63w4IySiOIysYaLEiPBkXTqBpHa9k0rcANP
         Mq8luu8tR+/vZGjuz5FWZqlrWlbhD1dsrCW8kjpnk6Of8lm3Uq7bjBxMFSPhYIwpNkRs
         wzxAjEDJS3JTBUI9Rc9q6CxPrCEE1D+TblGGgUcWZ9InruHmMULIEq8MSFdie4O9SeCJ
         CDrDZvBBKT7r3ExX0KMrO5Td8OLZ31CYqJR7Va6pe/bqAPf2uWlcxTyzqGmJpNzT0KMv
         wQ0Tg2BqZiU27oj8+ptgF/4aA8HHcfJ5uqYDxVmwrvDxTkUyV923+xAgmlUuAFczliXV
         NdAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=BiHYmAAiH626N89XqxkZXfyE7gUyoYuU5gV65m3nGjQ=;
        b=ALmqAGm8KClu0dFISzIJtyT6epH3DlxcOuTMvyPDbLn1SJUXTvUBVFPMVJwDyy8ES9
         N88fxbTLaKLNdP6VP/bFrECUlPt39r3Pv9OntNEicXA9IjqLsZoMEUVxRp8bKDN3W7Sp
         xdrP4TwGeaujq9vuTwZX48IeHT2qeUEmUfPlfhJDJHYQ99dxB+BXDdm4Q0y3g6goMW+N
         vnmEhm7DR8RNiHNmp1rUGtxvTkA9pebhHIQG48vyZ9XfQ9qbjlyER3+IUZsmN1W2VYok
         1PBTf71J0xBaYsCLV4GjeumiWJ3wR5n1QPoSznsXfklvtZXEr0oKIrIS/jRmS0UjX1Ou
         6/hA==
X-Gm-Message-State: AOAM532X7XgJiddhSby0ph24iTrdyL08joEmnmZRYOVudZr7H6fUkZcb
	mBmR27NtzEpQ81zDolNKPufGjx6gk1xLDpV/dkQ=
X-Google-Smtp-Source: ABdhPJw5yrP7SHcc7TWSGYuiAJWigblY6T4KARgQjUPREPTC4jVDZK0jmnjuyAbsgm5fKdwKwlLo7kamaFSoW1+wZMw=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:ad4:5747:: with SMTP id
 q7mr15646088qvx.0.1602549172707; Mon, 12 Oct 2020 17:32:52 -0700 (PDT)
Date: Mon, 12 Oct 2020 17:31:59 -0700
In-Reply-To: <20201013003203.4168817-1-samitolvanen@google.com>
Message-Id: <20201013003203.4168817-22-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201013003203.4168817-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
Subject: [PATCH v6 21/25] drivers/misc/lkdtm: disable LTO for rodata.o
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, 
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-pci@vger.kernel.org, x86@kernel.org, 
	Sami Tolvanen <samitolvanen@google.com>
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
2.28.0.1011.ga647a8990f-goog

