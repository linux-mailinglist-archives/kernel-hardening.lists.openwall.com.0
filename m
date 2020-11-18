Return-Path: <kernel-hardening-return-20417-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 460272B8789
	for <lists+kernel-hardening@lfdr.de>; Wed, 18 Nov 2020 23:09:40 +0100 (CET)
Received: (qmail 5544 invoked by uid 550); 18 Nov 2020 22:08:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 5489 invoked from network); 18 Nov 2020 22:08:09 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=ybG+vgy2nM0cZESjHkdkrOB9uboR6Bigv/FKTPhrj4k=;
        b=hIIcn4BpUGto4r6NHqbLnzUmUXfubNWPf/6Zv3GZRtWFHTU5uAvFN3tQzxc1WSCFCE
         QInEMAz5D1L8ymumteFJDjH04mB3gIw3xTPG+sIitd8fhUMxyqQPbPxfi9jbz4SdCsY5
         IMaYwzp6CiX4uEC0/+NopWwTLoT+Hs+OIt2rLskAikpv2CYx+NW+NMMv+UZMLb0cf3To
         3Gj3U/0KWBUaSX2TChjkL5H3cDumu19oheeYzVpian9YZ/DVNUcRVSEjbwAUTLGxGpKv
         acQ+xEREurokEV7Kzv9fVI7s3GeTBazq9YMWsdRv9DQFq4TQ25fd7ZWZErFnH/R86xe9
         IAwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ybG+vgy2nM0cZESjHkdkrOB9uboR6Bigv/FKTPhrj4k=;
        b=MzTEvm/Z5whL0om/Dr29MHnyD6XgvdIdMLy5PDkx0JEU9ZnwP+6ll3Ws2bscflE23F
         5V+mTyqEy7A/YjDhHEP5ZD5gkqaueqdG7hbFMEdsdVKmlzrIUrFHfjyGB0fIueI0ww+g
         XKD97TrJwekAtWD3gvpW2GKqw91P3sbm4OjNPa1aKW3A2PnYXePwXpDy/JJmV0JEngWc
         Vx4K/rtsyuNHk8FvGp3LVAfS59tgI8fycY8vfZqcbkdVpQ0JGmF2kQuS/TSLnFMB3vr6
         ZeGQBQ4SDgbwOdRw+dncbrXKfE+aONiCVuZHlXm7a41UsUoLGiGjWxZ7mzTwLcXqwuF3
         2XLw==
X-Gm-Message-State: AOAM532TcecjN+gmVIbgzcRYWx/4ygJ8XB8p5MFjIjYka7jZ2/j+IDfy
	dEb5LvIXQ7b7szEjzowez0ugJ2AdtizNnzkxs/U=
X-Google-Smtp-Source: ABdhPJwB2N/tm5mg6DDYK/Diu4h6yGV1GgLC8syn/S8N63ypD7xd4rXJmZv355L3RjYXmAC1JtFs6niBEXIXoHLUras=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a05:6214:32f:: with SMTP id
 j15mr7580348qvu.35.1605737277806; Wed, 18 Nov 2020 14:07:57 -0800 (PST)
Date: Wed, 18 Nov 2020 14:07:25 -0800
In-Reply-To: <20201118220731.925424-1-samitolvanen@google.com>
Message-Id: <20201118220731.925424-12-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201118220731.925424-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.29.2.454.gaff20da3a2-goog
Subject: [PATCH v7 11/17] scripts/mod: disable LTO for empty.c
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

With CONFIG_LTO_CLANG, clang generates LLVM IR instead of ELF object
files. As empty.o is used for probing target properties, disable LTO
for it to produce an object file instead.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 scripts/mod/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/mod/Makefile b/scripts/mod/Makefile
index 78071681d924..c9e38ad937fd 100644
--- a/scripts/mod/Makefile
+++ b/scripts/mod/Makefile
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 OBJECT_FILES_NON_STANDARD := y
+CFLAGS_REMOVE_empty.o += $(CC_FLAGS_LTO)
 
 hostprogs-always-y	+= modpost mk_elfconfig
 always-y		+= empty.o
-- 
2.29.2.299.gdc1121823c-goog

