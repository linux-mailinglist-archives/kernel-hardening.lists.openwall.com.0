Return-Path: <kernel-hardening-return-17987-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 491AA1728BB
	for <lists+kernel-hardening@lfdr.de>; Thu, 27 Feb 2020 20:36:09 +0100 (CET)
Received: (qmail 1830 invoked by uid 550); 27 Feb 2020 19:35:39 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1709 invoked from network); 27 Feb 2020 19:35:36 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AoE4OLd/IvDA6cmd9pXDgHl19RWwO6y4VAoz5pE6b4E=;
        b=GqYMFX/utzgItiW5PidQ11FE+lHI8vpi1sL09gpDitITyGvoCdgVofeyaea3HY9ipQ
         kI+V9aywVW0+oZ0T24u4PDmPMEExxMztSr66kCLpV0ML6Fdn0mDsyT0Mh3zdLeUDarW0
         cp8p5I5qVxBR8ULIBUY4ZLMoXbzGtmBCuNhWY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AoE4OLd/IvDA6cmd9pXDgHl19RWwO6y4VAoz5pE6b4E=;
        b=pULRWT7cFzbBueBB28FLw6HbqvIAzLPkYKIpg1DAluLQJftILeEarCiaX7x5NMBFAR
         gsE66WECBhSRuns8LYelzT6PEbpRcvjxXBBEXQGP+kFD/BvFeWxlt3VWHx/Q2C2hgRBA
         0qdHV78zcWc1a9uUi7KJDItOVpeoe3z90aHs7kYXnCX7xErIvGRti/vjjo05xcdkOwXM
         I4s3QyHz+bAM8hHr8IJDbtxUEbafS3//g9aNpN9tJL/ZteC132wwgpsI7cexSlrGzlR+
         U3lz/qBdbol1jRArICqTav8EoPV5t9q4XNEfu+Ug0bgpe8C/e9viYAMh6H98YcK9q2C2
         6a3Q==
X-Gm-Message-State: APjAAAWbfodz62HRuO5iQtEVFwOtCMa5RoRtwNel+qDlVizkChGVLMuw
	dgSlDFMmQW9XtdmbRFSnMJpRYA==
X-Google-Smtp-Source: APXvYqyHH1OhEaAU0M9XGqSIh9GqdH9ygv+RYA1KOJ+P5VFzMpUGg9ipEsHxlmsPcfBpV6cJtwqGHg==
X-Received: by 2002:a17:90b:8ce:: with SMTP id ds14mr584791pjb.70.1582832124805;
        Thu, 27 Feb 2020 11:35:24 -0800 (PST)
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>,
	Andrey Ryabinin <aryabinin@virtuozzo.com>,
	Elena Petrova <lenaptr@google.com>,
	Andrey Konovalov <andreyknvl@google.com>,
	Alexander Potapenko <glider@google.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	"Gustavo A. R. Silva" <gustavo@embeddedor.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com,
	syzkaller@googlegroups.com
Subject: [PATCH v5 0/6] ubsan: Split out bounds checker
Date: Thu, 27 Feb 2020 11:35:10 -0800
Message-Id: <20200227193516.32566-1-keescook@chromium.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Argh, v4 missed uncommitted changes. v5 brown paper bag release! :)

This splits out the bounds checker so it can be individually used. This
is enabled in Android and hopefully for syzbot. Includes LKDTM tests for
behavioral corner-cases (beyond just the bounds checker), and adjusts
ubsan and kasan slightly for correct panic handling.

-Kees

v5:
 - _actually_ use hyphenated bug class names (andreyknvl)
v4: https://lore.kernel.org/lkml/20200227184921.30215-1-keescook@chromium.org
v3: https://lore.kernel.org/lkml/20200116012321.26254-1-keescook@chromium.org
v2: https://lore.kernel.org/lkml/20191121181519.28637-1-keescook@chromium.org
v1: https://lore.kernel.org/lkml/20191120010636.27368-1-keescook@chromium.org


Kees Cook (6):
  ubsan: Add trap instrumentation option
  ubsan: Split "bounds" checker from other options
  lkdtm/bugs: Add arithmetic overflow and array bounds checks
  ubsan: Check panic_on_warn
  kasan: Unset panic_on_warn before calling panic()
  ubsan: Include bug type in report header

 drivers/misc/lkdtm/bugs.c  | 75 ++++++++++++++++++++++++++++++++++++++
 drivers/misc/lkdtm/core.c  |  3 ++
 drivers/misc/lkdtm/lkdtm.h |  3 ++
 lib/Kconfig.ubsan          | 49 +++++++++++++++++++++----
 lib/Makefile               |  2 +
 lib/ubsan.c                | 47 +++++++++++++-----------
 mm/kasan/report.c          | 10 ++++-
 scripts/Makefile.ubsan     | 16 ++++++--
 8 files changed, 172 insertions(+), 33 deletions(-)

-- 
2.20.1

