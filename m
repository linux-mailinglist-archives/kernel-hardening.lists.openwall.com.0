Return-Path: <kernel-hardening-return-16155-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id D2A31486B4
	for <lists+kernel-hardening@lfdr.de>; Mon, 17 Jun 2019 17:12:29 +0200 (CEST)
Received: (qmail 5471 invoked by uid 550); 17 Jun 2019 15:12:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 3876 invoked from network); 17 Jun 2019 15:11:08 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=AhzC1dqcXRssy7fdMkEhLgspqOslOvHdcVPRsk5zXZU=;
        b=k9NH+beY5eMjDnOaINDvVrgGcEx78KmzHeEJfkQN6Y9SX45KinI1QUz8a2DhSnPwty
         5kjZ5RuuasqO5gIcAhgkZUnJ5GT0kppbEhM9rHxo2vvxQJfsWk6uJ4QrX+Ea29xmQPeD
         8IsCVrYuEabNYcOitK3k+G1bBip5g5n1lG48JTDn/EqwzSUI5z4Uorhrr88udI3d+o6j
         RHT5IKO45+CRt1jDmPgvxO/tI9sYeKgKoAmcXlnkwutt1ZNFR12l5mPkKMTD0nu4F7YS
         SatuKTASkGkk2OrjCE5YEdnhVkD2b7xX5FLEHPbTJVQQpwuOyfkmjlwOpBT95MleK+pU
         LE6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=AhzC1dqcXRssy7fdMkEhLgspqOslOvHdcVPRsk5zXZU=;
        b=A5+05+Dz9E2dD4KWE+HUai8U+g6hHC9twmupofY71ZsCOuwUaXSVq9FvlL9Oz9Mt0l
         Y1+uB8XFMYvmpQ0PdlnoHSx87T0RAfAfsBzB7GKXwQP+2veRaW2h4QKDUmEEumc90DjQ
         BKGuD5Pgq3dUTmtLclOU/hyzR1+c07QYXYlVRfq2XdLlMPHZQ8O0DiuWyXEkr/xIEPsU
         tCWYRQE0HSkI3j82d7MJRAlbXv+ASZKzlgAaDFai9fqZaZAomcs7wT6ZygT1nZr+pXao
         ybNAVxu0arBha4gbnipqaouN6G1UnCsr7qCY1/X+faxYaqA/AJZLRjX8dmGGT729k4FP
         VzEQ==
X-Gm-Message-State: APjAAAWIOmyoM0LfZgx+N/hIo6zapOZGulRvQwltzaU+vvuYzUuS9LeZ
	9yZXuG21uQbVfmwS/Fd4Ta0PAkRMSLA=
X-Google-Smtp-Source: APXvYqzSP5di/cDRVpILC8IiiOlVU005dHmsxZFgo+MqF+Qnmu099tvbtAFfTxug3VjFm5DpzWKfL/u7hSk=
X-Received: by 2002:ac8:2a69:: with SMTP id l38mr27804097qtl.212.1560784256777;
 Mon, 17 Jun 2019 08:10:56 -0700 (PDT)
Date: Mon, 17 Jun 2019 17:10:48 +0200
Message-Id: <20190617151050.92663-1-glider@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH v7 0/3] add init_on_alloc/init_on_free boot options
From: Alexander Potapenko <glider@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, 
	Kees Cook <keescook@chromium.org>
Cc: Alexander Potapenko <glider@google.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, 
	Michal Hocko <mhocko@kernel.org>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Nick Desaulniers <ndesaulniers@google.com>, 
	Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, 
	Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>, 
	Mark Rutland <mark.rutland@arm.com>, Marco Elver <elver@google.com>, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com
Content-Type: text/plain; charset="UTF-8"

Provide init_on_alloc and init_on_free boot options.

These are aimed at preventing possible information leaks and making the
control-flow bugs that depend on uninitialized values more deterministic.

Enabling either of the options guarantees that the memory returned by the
page allocator and SL[AU]B is initialized with zeroes.
SLOB allocator isn't supported at the moment, as its emulation of kmem
caches complicates handling of SLAB_TYPESAFE_BY_RCU caches correctly.

Enabling init_on_free also guarantees that pages and heap objects are
initialized right after they're freed, so it won't be possible to access
stale data by using a dangling pointer.

As suggested by Michal Hocko, right now we don't let the heap users to
disable initialization for certain allocations. There's not enough
evidence that doing so can speed up real-life cases, and introducing
ways to opt-out may result in things going out of control.

To: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <cl@linux.com>
To: Kees Cook <keescook@chromium.org>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: James Morris <jmorris@namei.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Kostya Serebryany <kcc@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Sandeep Patil <sspatil@android.com>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Jann Horn <jannh@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Marco Elver <elver@google.com>
Cc: linux-mm@kvack.org
Cc: linux-security-module@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com

Alexander Potapenko (2):
  mm: security: introduce init_on_alloc=1 and init_on_free=1 boot
    options
  mm: init: report memory auto-initialization features at boot time

 .../admin-guide/kernel-parameters.txt         |  9 +++
 drivers/infiniband/core/uverbs_ioctl.c        |  2 +-
 include/linux/mm.h                            | 22 +++++++
 init/main.c                                   | 24 +++++++
 kernel/kexec_core.c                           |  2 +-
 mm/dmapool.c                                  |  2 +-
 mm/page_alloc.c                               | 63 ++++++++++++++++---
 mm/slab.c                                     | 16 ++++-
 mm/slab.h                                     | 19 ++++++
 mm/slub.c                                     | 33 ++++++++--
 net/core/sock.c                               |  2 +-
 security/Kconfig.hardening                    | 29 +++++++++
 12 files changed, 204 insertions(+), 19 deletions(-)
---
 v3: dropped __GFP_NO_AUTOINIT patches
 v5: dropped support for SLOB allocator, handle SLAB_TYPESAFE_BY_RCU
 v6: changed wording in boot-time message
 v7: dropped the test_meminit.c patch (picked by Andrew Morton already),
     minor wording changes
-- 
2.22.0.410.gd8fdbe21b5-goog

