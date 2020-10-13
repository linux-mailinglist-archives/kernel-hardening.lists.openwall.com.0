Return-Path: <kernel-hardening-return-20185-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id C449528C625
	for <lists+kernel-hardening@lfdr.de>; Tue, 13 Oct 2020 02:34:13 +0200 (CEST)
Received: (qmail 15534 invoked by uid 550); 13 Oct 2020 00:32:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 15387 invoked from network); 13 Oct 2020 00:32:42 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=VMCZDfrBZTgAeIay1rQ29+uk2lw3Iqw8lHEoyZvJXcw=;
        b=nfKwI9L0AIFN/q2chPmhJejzrBkYs0AxSEEy5fMqd20mS1osQThhU+ktBGNYJaYON2
         MjqIs9Rl7hlo6AIxtQ8N9k1pcoq5ps0nN8zY2Xo536Oyj1gVgj/lQEyGB8wz3lEphQRn
         2a1yV5HhbU2nGBMNwGgkGuol3VvcnDW+IkWtbFHZhCYQRfBcbMJubOSbajBBqU+1O5Lc
         vfXB9fY0pxR64gHEC1sLB+1X7ygPM6rsC8GT4gpvySGeXGx9VtbnLfGxKbpXvIJwD6/H
         97AQwdvtwYTTmK+V2mtwsV3UBIBJzwfFWuK8t1tvV6xVdxIgGCV2JLCT63S6ODvptoz5
         tFPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=VMCZDfrBZTgAeIay1rQ29+uk2lw3Iqw8lHEoyZvJXcw=;
        b=EJJvLhvt55OGUTsJxt3ZQN87GWceT5YSDR6dPKAeF9J2qFVzd/rks93CngcsO0HDCh
         A8sCXTNXofDUGr21wNkfSMhl2p0H/tLwYBqGem7ff4S3u2wK6nO3t3Q4XIkAyNt2N0do
         XRHudPcycMyGT6cEZTJIMX7M++h/m5XQS45q3Vhaxk+7SlZ35TXpz8DqLIAImZQDCKuo
         rz//MvF2hea49mprG27DL6uVwi3K27mf1S93rtViQAaMgdqA7fo22MDzKTBNDWQj0Jt+
         Z3gdrjY1b1dUGZFdDCYC5D1UFzm3c9tC6MTOS6B5k5+OBe0EOZbfkcD8GiupSGwJul6o
         eQeA==
X-Gm-Message-State: AOAM533zMIiCl3GdMSEBd13NBgI5aZd2SDIMigxnZzAqghJcA91aYKmh
	YSlQwiTABcVcxQiIgs8Wom0yiQUAWFb+4SuUd4A=
X-Google-Smtp-Source: ABdhPJxSmGaKr8jvnZZWeZs3NgnMtwPC1onr9g3CEDlPD9ytqEe1Dbwb5OtBLL/kqlcnIZWLZSXhLwgEYzEWhabcOlM=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:ad4:4b2a:: with SMTP id
 s10mr1226538qvw.54.1602549150461; Mon, 12 Oct 2020 17:32:30 -0700 (PDT)
Date: Mon, 12 Oct 2020 17:31:50 -0700
In-Reply-To: <20201013003203.4168817-1-samitolvanen@google.com>
Message-Id: <20201013003203.4168817-13-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201013003203.4168817-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
Subject: [PATCH v6 12/25] kbuild: lto: limit inlining
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

This change limits function inlining across translation unit boundaries
in order to reduce the binary size with LTO. The -import-instr-limit
flag defines a size limit, as the number of LLVM IR instructions, for
importing functions from other TUs, defaulting to 100.

Based on testing with arm64 defconfig, we found that a limit of 5 is a
reasonable compromise between performance and binary size, reducing the
size of a stripped vmlinux by 11%.

Suggested-by: George Burgess IV <gbiv@google.com>
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Makefile b/Makefile
index 91cd6caefa6e..41b01248d400 100644
--- a/Makefile
+++ b/Makefile
@@ -894,6 +894,9 @@ else
 CC_FLAGS_LTO	+= -flto
 endif
 CC_FLAGS_LTO	+= -fvisibility=default
+
+# Limit inlining across translation units to reduce binary size
+KBUILD_LDFLAGS += -mllvm -import-instr-limit=5
 endif
 
 ifdef CONFIG_LTO
-- 
2.28.0.1011.ga647a8990f-goog

