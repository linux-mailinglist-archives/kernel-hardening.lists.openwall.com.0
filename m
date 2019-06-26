Return-Path: <kernel-hardening-return-16253-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 0B72C56955
	for <lists+kernel-hardening@lfdr.de>; Wed, 26 Jun 2019 14:36:34 +0200 (CEST)
Received: (qmail 15636 invoked by uid 550); 26 Jun 2019 12:36:27 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 30090 invoked from network); 26 Jun 2019 12:20:00 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=2Fq0HjbifmsdupktcfAuEl6sSbOWTKpMU8wUfFApIcI=;
        b=h8oRe74wvAhFNxCVSSLhgtaf8DdDRcvv2LUELZFKlhxIfMWHkB06yNG7SNT3CIncbO
         xrYAcYPkEKjnBbVe2WkkxpRSyACn/8q3L802S7S92zdmpj8B19KqEVJcOM2de/TNEknR
         +94Tt3chS1BA9EQxdCUwN45Wrz3UQ2wxYNt9NaVvGQq71AgKto3OiuqHn7RxyjdL02P3
         kTB2Ww3CiDQVdnviX+kBmfbmKcALIJ+dol51U9jzsfedTnn6SYA/TwGSVoVw9zlhWnSb
         4EeKQMkev9uTpqQzluNSwGkO5ukTgZfcxz/SaVb7HtKHx/CIH57gzcebuKUlYjgHmyus
         M3AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=2Fq0HjbifmsdupktcfAuEl6sSbOWTKpMU8wUfFApIcI=;
        b=hQoIzLbxjXnY9lCavF1+gWqiAidIKH0gwEecQNhM++jT5yo7jsXEHHjAQuLOEgHEwl
         TjVvlheo1dQbzqW50Pxkj5O/fOMn3/ONP3keAiR32mTNxzG0r44suduK1lCrm8c91hCR
         xmZrnZ5vpVpZ0c7/ZWClzzO1olOaxjr+H6WXBU8bkp7YHsCpuMH8TzZYv1DgOwqajRzQ
         mS5+6LRN02lwegyfya/P5iwYIWCo0Sk+ClTMj9b0WZmNuVhSw1F4gfshCAuj3UUHu+O5
         9tPyVDTVmOUNBCfF1VmCtbYwefUYrKImv0LHOn87+YMMeUvFNgju4cQbtOQt/kDO+Z1m
         uwlA==
X-Gm-Message-State: APjAAAVDvjVClROBPIQIroWPFRQ7U6K4Jlk0nx0rehEOle5s0R5xHJTk
	sC6dsvK6+qjPX9y41EbfsQznEUSsqlI=
X-Google-Smtp-Source: APXvYqwCAtzX9p5b1vV/t1GUdeUyS8l0gHd33EslOH8hxFCkdYOBd6HFsLdwDix1xDg/zZ5Qa9VT7wjTypQ=
X-Received: by 2002:a0c:d249:: with SMTP id o9mr3328284qvh.196.1561551587948;
 Wed, 26 Jun 2019 05:19:47 -0700 (PDT)
Date: Wed, 26 Jun 2019 14:19:41 +0200
Message-Id: <20190626121943.131390-1-glider@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH v8 0/3] add init_on_alloc/init_on_free boot options
From: Alexander Potapenko <glider@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, 
	Kees Cook <keescook@chromium.org>
Cc: Alexander Potapenko <glider@google.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, 
	Michal Hocko <mhocko@kernel.org>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Nick Desaulniers <ndesaulniers@google.com>, 
	Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, 
	Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>, 
	Mark Rutland <mark.rutland@arm.com>, Marco Elver <elver@google.com>, Qian Cai <cai@lca.pw>, 
	linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
	kernel-hardening@lists.openwall.com
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
Cc: Qian Cai <cai@lca.pw>
Cc: linux-mm@kvack.org
Cc: linux-security-module@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com

Alexander Potapenko (2):
  mm: security: introduce init_on_alloc=1 and init_on_free=1 boot
    options
  mm: init: report memory auto-initialization features at boot time

 .../admin-guide/kernel-parameters.txt         |  9 +++
 drivers/infiniband/core/uverbs_ioctl.c        |  2 +-
 include/linux/mm.h                            | 22 ++++++
 init/main.c                                   | 24 +++++++
 mm/dmapool.c                                  |  4 +-
 mm/page_alloc.c                               | 71 +++++++++++++++++--
 mm/slab.c                                     | 16 ++++-
 mm/slab.h                                     | 19 +++++
 mm/slub.c                                     | 43 +++++++++--
 net/core/sock.c                               |  2 +-
 security/Kconfig.hardening                    | 29 +++++++++
 12 files changed, 204 insertions(+), 19 deletions(-)
---
 v3: dropped __GFP_NO_AUTOINIT patches
 v5: dropped support for SLOB allocator, handle SLAB_TYPESAFE_BY_RCU
 v6: changed wording in boot-time message
 v7: dropped the test_meminit.c patch (picked by Andrew Morton already),
     minor wording changes
 v8: fixes for interoperability with other heap debugging features
-- 
2.22.0.410.gd8fdbe21b5-goog

