Return-Path: <kernel-hardening-return-17403-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id D22831030F7
	for <lists+kernel-hardening@lfdr.de>; Wed, 20 Nov 2019 02:07:02 +0100 (CET)
Received: (qmail 25620 invoked by uid 550); 20 Nov 2019 01:06:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 24561 invoked from network); 20 Nov 2019 01:06:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=CUFUdRWnKnM6bQsVtJfdZZf6wE8f8HKbQO0cl/4N/Js=;
        b=QPNZ3TFYMN2cyDfBdvY07DD5Qf553QuOH2y52Uwcvrqipiupi+07SzCncWmB4ompaa
         Sp+KugNpDIe0O6L+0QzSoa4zgNsRPXdvojFu1L2G6OGfQek8k6mLkB+UwWM1uFrTy2gS
         NyC4I93Ch4Jff4rMgtPSiWxg1V0Gf/SF4lmjQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=CUFUdRWnKnM6bQsVtJfdZZf6wE8f8HKbQO0cl/4N/Js=;
        b=W9NefbWQUy8gYBDVx91fUAVux8e23Eqolm01HDtH5lz2tMo+cgOFrKAszYpXQKJAoi
         dakuF50WhFo+yikFKS5DY2+yCtquWTLuJJTOUC+a/YGmu8NvjVSdfztKq7w8sGDIeh99
         2ox6RQ54mYqFOGkTsmkvH4420jh63guomnlSDDxEeWXocaSucthDZDXlXyq/SvWU2AUn
         cy7DMr2a6vkh7WncQkUhjxHlyk9b72IjXoYSUkogTN7pGv87nCsZrkeGgtechz8RB0LJ
         UZo6A4H4EN2p6QZi6Z2zOUBUcS67pEoQ60tpcnQlQ4OEHwn5KkuEaX0xw5ONvyGCNsJY
         bl1g==
X-Gm-Message-State: APjAAAV7C+cO7VySzQEEv3mj9NyrDx3nl+C8YoptOs7DuWWQI1jbOlHa
	VavvU177fA9m4smHsX08o4z9KQ==
X-Google-Smtp-Source: APXvYqwryrV10zt9FpcokSWJA8ITt8y25QMJpvbarPp35S9IPnXIHn2OsUwTFiZFRGn4wDxNWoDbIA==
X-Received: by 2002:a62:ae17:: with SMTP id q23mr705132pff.2.1574212002529;
        Tue, 19 Nov 2019 17:06:42 -0800 (PST)
From: Kees Cook <keescook@chromium.org>
To: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Kees Cook <keescook@chromium.org>,
	Elena Petrova <lenaptr@google.com>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	"Gustavo A. R. Silva" <gustavo@embeddedor.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: [PATCH 0/3] ubsan: Split out bounds checker
Date: Tue, 19 Nov 2019 17:06:33 -0800
Message-Id: <20191120010636.27368-1-keescook@chromium.org>
X-Mailer: git-send-email 2.17.1

This splits out the bounds checker so it can be individually used. This
is expected to be enabled in Android and hopefully for syzbot. Includes
LKDTM tests for behavioral corner-cases.

-Kees

Kees Cook (3):
  ubsan: Add trap instrumentation option
  ubsan: Split "bounds" checker from other options
  lkdtm/bugs: Add arithmetic overflow and array bounds checks

 drivers/misc/lkdtm/bugs.c  | 75 ++++++++++++++++++++++++++++++++++++++
 drivers/misc/lkdtm/core.c  |  3 ++
 drivers/misc/lkdtm/lkdtm.h |  3 ++
 lib/Kconfig.ubsan          | 34 ++++++++++++++++-
 lib/Makefile               |  2 +
 scripts/Makefile.ubsan     | 16 ++++++--
 6 files changed, 128 insertions(+), 5 deletions(-)

-- 
2.17.1

