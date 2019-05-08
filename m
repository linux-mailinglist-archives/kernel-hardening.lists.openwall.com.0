Return-Path: <kernel-hardening-return-15897-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 5E43717DEB
	for <lists+kernel-hardening@lfdr.de>; Wed,  8 May 2019 18:16:59 +0200 (CEST)
Received: (qmail 24183 invoked by uid 550); 8 May 2019 16:16:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 9961 invoked from network); 8 May 2019 15:38:20 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=jQTDk5zUQiu0jSAANSS6F2tKehHuyoJNILpoLlCvpOE=;
        b=GFN6F1CFAn8rem5iUDqLjf1tfi+RrhFiRNeh/0F2po0axneRlVapHhrppUL/61zKqa
         fqziisUOusgcNBy3YbprB/0BuVtDJreqKdohUPF1WERb9r4bJ3xZCcu4ADVbVfVB6f31
         F84NdwY+v3XeVNLpl7AvM3G0VguBxS7GRXu8APDPhsMHavQ2PJ8+w+3zWDJS+PLRRpI7
         MxxjitSgkHRhSyhrDMur3ihTXAk0Ftgs1r521FXCwSoQzNtSD2nAihFYWbdWXr7fx4yF
         Imhr3H9U682NR/6wHUZ2sy0nXTUp9qrTit0Sb4OCZM0m8HJEcpSQjyQYjKYB1xsIZJFE
         IfCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=jQTDk5zUQiu0jSAANSS6F2tKehHuyoJNILpoLlCvpOE=;
        b=RroR3qC8Wl60hT0tDVfxGFa4oYn3MdgdYzqx805bJLuTFItOcdDOQ/rjFApRsJUa3v
         7X1T7iILyzZwuoUr9pszTZk/apJbYfQLXdovHUcHLw7ZJ8o+C54msLYZW9tHohgbjGZU
         JiFtPdzp6u2uE6tIn6GOfBWrUNM7NSOq4LLZHkxbQXYjYdCb9zc582UscoKFo5fhiG4D
         DGt9Nm4fKAwZJCfARo9C59oCOtVfXNaHdZlMN6iPSh2XgfGqsuAmasdu0Ao+yFLW0jmT
         zBnK/UyHtOYDvDNWkQcAP3PNh/tTwOrstp6yEpbDDtwR96cIEyARNENAKv4Px/Fc+d2g
         x5Zw==
X-Gm-Message-State: APjAAAVLKi3WPtacFe9rSTwlfytxnZkTSJT5CYCrMlIsz8jlBToM4viv
	5GBCwFXNxdnx3E9I+RxjTh1TZ3fnS20=
X-Google-Smtp-Source: APXvYqwB6BG1aUc84ClZ+1GOpENtD9vu+DWDbF6HSE0y1Oiy+N+VdKRxD9HjOVUJUdCXtfed6Q5q6eop53c=
X-Received: by 2002:ac8:3fe3:: with SMTP id v32mr31243311qtk.307.1557329888814;
 Wed, 08 May 2019 08:38:08 -0700 (PDT)
Date: Wed,  8 May 2019 17:37:32 +0200
Message-Id: <20190508153736.256401-1-glider@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
Subject: [PATCH 0/4] RFC: add init_on_alloc/init_on_free boot options
From: Alexander Potapenko <glider@google.com>
To: akpm@linux-foundation.org, cl@linux.com, keescook@chromium.org, 
	labbott@redhat.com
Cc: linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
	kernel-hardening@lists.openwall.com, yamada.masahiro@socionext.com, 
	jmorris@namei.org, serge@hallyn.com, ndesaulniers@google.com, kcc@google.com, 
	dvyukov@google.com, sspatil@android.com, rdunlap@infradead.org, 
	jannh@google.com, mark.rutland@arm.com
Content-Type: text/plain; charset="UTF-8"

Provide init_on_alloc and init_on_free boot options.

These are aimed at preventing possible information leaks and making the
control-flow bugs that depend on uninitialized values more deterministic.

Enabling either of the options guarantees that the memory returned by the
page allocator and SL[AOU]B is initialized with zeroes.

Enabling init_on_free also guarantees that pages and heap objects are
initialized right after they're freed, so it won't be possible to access
stale data by using a dangling pointer.

Alexander Potapenko (4):
  mm: security: introduce init_on_alloc=1 and init_on_free=1 boot
    options
  lib: introduce test_meminit module
  gfp: mm: introduce __GFP_NOINIT
  net: apply __GFP_NOINIT to AF_UNIX sk_buff allocations

 .../admin-guide/kernel-parameters.txt         |   8 +
 drivers/infiniband/core/uverbs_ioctl.c        |   2 +-
 include/linux/gfp.h                           |   6 +-
 include/linux/mm.h                            |  22 ++
 include/net/sock.h                            |   5 +
 kernel/kexec_core.c                           |   4 +-
 lib/Kconfig.debug                             |   8 +
 lib/Makefile                                  |   1 +
 lib/test_meminit.c                            | 205 ++++++++++++++++++
 mm/dmapool.c                                  |   2 +-
 mm/page_alloc.c                               |  62 +++++-
 mm/slab.c                                     |  18 +-
 mm/slab.h                                     |  16 ++
 mm/slob.c                                     |  23 +-
 mm/slub.c                                     |  28 ++-
 net/core/sock.c                               |  31 ++-
 net/unix/af_unix.c                            |  13 +-
 security/Kconfig.hardening                    |  16 ++
 18 files changed, 439 insertions(+), 31 deletions(-)
 create mode 100644 lib/test_meminit.c

-- 
2.21.0.1020.gf2820cf01a-goog

