Return-Path: <kernel-hardening-return-17414-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id B59D710594D
	for <lists+kernel-hardening@lfdr.de>; Thu, 21 Nov 2019 19:15:48 +0100 (CET)
Received: (qmail 30028 invoked by uid 550); 21 Nov 2019 18:15:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 29989 invoked from network); 21 Nov 2019 18:15:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=kx15nKFaa57ikxrtvnW6LLNF2Gic9naPHUcFWTG+liE=;
        b=XNFMoCf8caSloMiiaa3BQ/ZV8ZEBK+ZOhENo9k1BFP7v6quOgxxTr8whsADIHvCl8D
         cmUrVFP0xX24EIIH24q0gHu7kjpr6B0HgYd4vzppozIj7jlmxpQdl5dVlpj5mcxyLzDa
         Ug4UbzyQbWAv7s6t+60ZgMgTOkgfQeIeauWZc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=kx15nKFaa57ikxrtvnW6LLNF2Gic9naPHUcFWTG+liE=;
        b=uJAdZ+ObVias4WAFz2AnRTSRQ1qXU0RTk09nJRb0ENVxokVWOMEBn/E/r0s9OwkudC
         KkrgyildkY5CeIdKVpaaUr0iJ1J88p4ORsqlN9qyFT94TDgUVUWUEY3PGrJkhZEy0pOD
         TB8wsQ2DEzKUJvQ7d4i2mfsQ95q0NUVVCSxhMDqzyXmceG66YlOZ7RtZ0Cl+7rbDK+p5
         LSqFLnkUx4DKTiuIQtHxyYE3h94Oeuec0IzQ/AiXKyVIaOncXl3wh7I8SiSCB7brClzR
         S0rYgEMZ7APjG1Jj8HiETaDKMlqik5UDP91exq+deNoW5bQEB255mmgZJn5qq+XLV4qh
         vJmQ==
X-Gm-Message-State: APjAAAXnz/zn0Y+HAo6ScVfGXAw/M9MVhO//l1ycBZq5d2/b3bP1RAKy
	Hqlm80v9yUgc0fbRVm2MxUYDAg==
X-Google-Smtp-Source: APXvYqy83nVTZOGjht16O1ra3uJKFrh9BgqquW4E25Tl7E1W4RGlNYIlQIfT7/HaPmqgf5SNpIzhMA==
X-Received: by 2002:a63:8f46:: with SMTP id r6mr11009780pgn.51.1574360129345;
        Thu, 21 Nov 2019 10:15:29 -0800 (PST)
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>,
	Andrey Ryabinin <aryabinin@virtuozzo.com>,
	Elena Petrova <lenaptr@google.com>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	"Gustavo A. R. Silva" <gustavo@embeddedor.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: [PATCH v2 0/3] ubsan: Split out bounds checker
Date: Thu, 21 Nov 2019 10:15:16 -0800
Message-Id: <20191121181519.28637-1-keescook@chromium.org>
X-Mailer: git-send-email 2.17.1

v2:
    - clarify Kconfig help text (aryabinin)
    - add reviewed-by
    - aim series at akpm, which seems to be where ubsan goes through?
v1: https://lore.kernel.org/lkml/20191120010636.27368-1-keescook@chromium.org

This splits out the bounds checker so it can be individually used. This
is expected to be enabled in Android and hopefully for syzbot. Includes
LKDTM tests for behavioral corner-cases (beyond just the bounds checker).

-Kees

Kees Cook (3):
  ubsan: Add trap instrumentation option
  ubsan: Split "bounds" checker from other options
  lkdtm/bugs: Add arithmetic overflow and array bounds checks

 drivers/misc/lkdtm/bugs.c  | 75 ++++++++++++++++++++++++++++++++++++++
 drivers/misc/lkdtm/core.c  |  3 ++
 drivers/misc/lkdtm/lkdtm.h |  3 ++
 lib/Kconfig.ubsan          | 42 +++++++++++++++++++--
 lib/Makefile               |  2 +
 scripts/Makefile.ubsan     | 16 ++++++--
 6 files changed, 134 insertions(+), 7 deletions(-)

-- 
2.17.1

