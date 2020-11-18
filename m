Return-Path: <kernel-hardening-return-20419-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 179542B878B
	for <lists+kernel-hardening@lfdr.de>; Wed, 18 Nov 2020 23:10:00 +0100 (CET)
Received: (qmail 6000 invoked by uid 550); 18 Nov 2020 22:08:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 5904 invoked from network); 18 Nov 2020 22:08:14 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=mxI/yASg0f6Fr52O8HbJJtAQuezjHMCx8HIdyf0ndaw=;
        b=wXL6d0K4ogSQ2FXaTmMFlblc8ygekSoyqjsrSzzJDjpixZCmnN20/goG3t/ED7/DTH
         OxdlaMC9ge+QbZ8tXanDBoxT3LpWcOf8luW/CBKbpnh2xsq7sGt5KwPvZSVnl9APk3gO
         8N7JkaxorXB7vboromu73acJ/93kZSSKsn9wdnqxhZRK+w7gFkEwM97MObjc/QMVHCur
         LGzCFisEIGmrlzY+iEYp9MAwtUT5BXbioFgGSXGwTvoJdAm+0xS7LKQ79iRezYDrbJkJ
         e3z4mvr4MBID2gFRQexM6A6nq0jYREQkekiigQeetFyTb8zgk9F3ePzJdu41Y2TB8/OO
         uNyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=mxI/yASg0f6Fr52O8HbJJtAQuezjHMCx8HIdyf0ndaw=;
        b=ANHwDfwKG5O1Tncr3r6RT+mLe3vOb7uPPnBqseJuUWVM+fhBroTs/D/PTfgWjdY1yA
         5QFXsI2lJPbdPgBBYMH33aPD2bC2lcvvmZJnZQCaPrTWOw/Sy/8kPS+k4Kp80oHeavyf
         ZgBX+doyIbztXa7NRI2ab5IpLcGnrY23IL31MkaaXrl+oj0jPx4a0GmAq8jzMFColfcf
         xfw6IxS6h52NksY5qQPLipWcWnuGr5CTy/e9D0lfUNhcS1lxYydHDVqMCrBtP82j4/P7
         XLXSupwl3qjaKutmzxsJe6CAlIyfUcu0kcUPGl+uxvFjgaRlKJykjx74HAOuMMbMkGA3
         XuqA==
X-Gm-Message-State: AOAM532wK+IsSkNlzphsYjHBrT0EmyMxN6n6WmYIxvJ2DQVcmpoTdbHX
	JikruxG59RqJYDeUhUa0DXsgF6Bh3wBIYw+bpJU=
X-Google-Smtp-Source: ABdhPJzzh79iYBu53HM7s0ihX08oKft9CFEoRm+vpxgv6uzQ9nNVk7YbdnmB9oztYmiJRe0kvbcEJOxZvLrcJbYG6fo=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a0c:b34a:: with SMTP id
 a10mr7403176qvf.15.1605737282753; Wed, 18 Nov 2020 14:08:02 -0800 (PST)
Date: Wed, 18 Nov 2020 14:07:27 -0800
In-Reply-To: <20201118220731.925424-1-samitolvanen@google.com>
Message-Id: <20201118220731.925424-14-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201118220731.925424-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.29.2.454.gaff20da3a2-goog
Subject: [PATCH v7 13/17] drivers/misc/lkdtm: disable LTO for rodata.o
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
2.29.2.299.gdc1121823c-goog

