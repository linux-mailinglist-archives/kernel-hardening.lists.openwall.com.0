Return-Path: <kernel-hardening-return-15987-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 94B70281D2
	for <lists+kernel-hardening@lfdr.de>; Thu, 23 May 2019 17:53:47 +0200 (CEST)
Received: (qmail 14174 invoked by uid 550); 23 May 2019 15:53:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 27866 invoked from network); 23 May 2019 12:42:36 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=JQ1oCxUU1IPVRVLwTDKqVi9a5cWuQ5HVxcskTOhO4aM=;
        b=ertiE0SB+mfT4MEk0SFpNz/YKadHtLe1893I517U4tFeM8uM4swKr9G/SikceY0rCZ
         UDv4kifx0Bx26JjS24LlGhSYfY5dn5hLUvIS+argIdWCUpj1zPlvl2vgcVT7VlYsMIBc
         TbZHChjMXWT1nZTF2UxhG3QQeuTGjHcBqomUaPOhXB56N+mygLlEEWcHWhxicHOP9S1B
         5KxHPYzkoVGX7YeFgoThDuFVkgEJqn+ZZYDjNKrKzE9PsO+fkj2QIaVmmjg9RyHD6UE+
         GLNEbVFhskq2fbM3GBHi68kjqbHgC7bL3loysl7MiurRFJlygTNNkqpkXQbKQ7K1eIxr
         EB9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=JQ1oCxUU1IPVRVLwTDKqVi9a5cWuQ5HVxcskTOhO4aM=;
        b=S5rwdMCa4grG9mUnqtlQnOdpyLujzwysvEIY7E2jU2BYA6dKdbzThkhZFL1a2EhlsQ
         TMvNq41h8Li2Z3YdSmCLnTvkY2E5ocBU8Da9auLy3Trb4KkUOk/2CmONW8xTL6CDR66r
         el09mZWSySkSgGweSfhVwJadC2V58/t05kEhDafaKRQVVCHMV/TbuyvceFcIaUEQwnoN
         BBT9DzNBdRtbXGG5XfM71ZT/wT2HyTATYFHsClBAPZ2alOzysD+ruTrHdZfChy+0DyvK
         QsfKzM6iC1OzgF16ddoFURBE4ovkqD+V4h8MaqxPNMf4+N/zTjzQPaFtBt5QKxhCUaP6
         WLWQ==
X-Gm-Message-State: APjAAAWY29INvvw9vdfEdkIePSEdFk4lziC36xHpv455XhiXo1AUUn5R
	vM1kjL+dhlYNZ+8qj99EpV65WGjY9Yg=
X-Google-Smtp-Source: APXvYqybh08sHeGZRRlBZ+rEKGpK9UKViuwmqgzYonb7VhrGAa6y78I0qkN7CYW3hhy3qjCkZr902YQaq1s=
X-Received: by 2002:a81:5987:: with SMTP id n129mr46582349ywb.193.1558615344476;
 Thu, 23 May 2019 05:42:24 -0700 (PDT)
Date: Thu, 23 May 2019 14:42:13 +0200
Message-Id: <20190523124216.40208-1-glider@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
Subject: [PATCH v3 0/3] RFC: add init_on_alloc/init_on_free boot options
From: Alexander Potapenko <glider@google.com>
To: akpm@linux-foundation.org, cl@linux.com, keescook@chromium.org
Cc: kernel-hardening@lists.openwall.com, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Provide init_on_alloc and init_on_free boot options.

These are aimed at preventing possible information leaks and making the
control-flow bugs that depend on uninitialized values more deterministic.

Enabling either of the options guarantees that the memory returned by the
page allocator and SL[AOU]B is initialized with zeroes.

Enabling init_on_free also guarantees that pages and heap objects are
initialized right after they're freed, so it won't be possible to access
stale data by using a dangling pointer.

As suggested by Michal Hocko, right now we don't let the heap users to
disable initialization for certain allocations. There's not enough
evidence that doing so can speed up real-life cases, and introducing
ways to opt-out may result in things going out of control.

Alexander Potapenko (3):
  mm: security: introduce init_on_alloc=1 and init_on_free=1 boot
    options
  mm: init: report memory auto-initialization features at boot time
  lib: introduce test_meminit module

 .../admin-guide/kernel-parameters.txt         |   8 +
 drivers/infiniband/core/uverbs_ioctl.c        |   2 +-
 include/linux/mm.h                            |  22 ++
 init/main.c                                   |  24 ++
 kernel/kexec_core.c                           |   2 +-
 lib/Kconfig.debug                             |   8 +
 lib/Makefile                                  |   1 +
 lib/test_meminit.c                            | 208 ++++++++++++++++++
 mm/dmapool.c                                  |   2 +-
 mm/page_alloc.c                               |  63 +++++-
 mm/slab.c                                     |  16 +-
 mm/slab.h                                     |  16 ++
 mm/slob.c                                     |  22 +-
 mm/slub.c                                     |  27 ++-
 net/core/sock.c                               |   2 +-
 security/Kconfig.hardening                    |  14 ++
 16 files changed, 416 insertions(+), 21 deletions(-)
 create mode 100644 lib/test_meminit.c
---
 v3: dropped __GFP_NO_AUTOINIT patches

-- 
2.21.0.1020.gf2820cf01a-goog

