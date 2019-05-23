Return-Path: <kernel-hardening-return-15991-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id D2E28281DE
	for <lists+kernel-hardening@lfdr.de>; Thu, 23 May 2019 17:55:20 +0200 (CEST)
Received: (qmail 21841 invoked by uid 550); 23 May 2019 15:55:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 7665 invoked from network); 23 May 2019 14:09:09 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=JQ1oCxUU1IPVRVLwTDKqVi9a5cWuQ5HVxcskTOhO4aM=;
        b=QSVcDQxMHDwf8m/Z00oyTMaxgkEpAavtybAzTn6owaPo+gAmLQ7/HmGrhaVojqa/Z9
         H3RWBQuoUt7y1CPFPUSYmC3KFwZXYCXhsfg3TCzVqJhn8CbhPgjm9rKJWQDX7Lu/2d0W
         Dsq823bTZbsbvOS3FJZxLzlDpc2K/sJx5F3y4OG8DQxWxVuNEHRX3wswKeIrOLGu4JEH
         1P1KizLqCGCvxfpwPbt4JvR7LuXsduw83cDbNhfkxg3jxs4SgNA4G18Cufc/NtkbcRrW
         nuizYWd0dCXGDuYT3EFJtWHxhGMyOtpdRhrfsgswuXoX+qLlyEVvHWcK2HoojRAzEzvn
         4BAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=JQ1oCxUU1IPVRVLwTDKqVi9a5cWuQ5HVxcskTOhO4aM=;
        b=mqhkOBE7oQHW6mg0cZ92BPXnESwIfr+R5j3hdqIY5SLdQ0w7VGmPlyqF9GSz0gt7HW
         slkleSIZxQeiou4PVi2CY7RXrF0b7pvs53Z91Cho1zlQIipQIISpXqTMdhyRhYNZC/aT
         bho7vAX/kqfq7RdVjf148ZUAUoDENE6AXBOwMrGSfghQge1FkIqzMet8M//yqOiRPUsf
         83YeExl+y5pwAAdjB0GKz3wmSIyX/n+pUBNd1bjnixeVfYeXWIBq/S+CBRexYBDClJ6g
         z5LfDbsOyGO34RTILc1aFkZ1DYXrmj16hUibhTvqh/BA+eUH8XTfB+1qg+5MH9RyRzMa
         W3AA==
X-Gm-Message-State: APjAAAUD4Ncy9sEZxTpJxNulpLrjOevAMjDIqqoS1PJX0OkHQug0jmV9
	1lcW6/Yvljw++MVYEk46EGn2lGt7htU=
X-Google-Smtp-Source: APXvYqwSUxwQ8ZuNx1PgcNhs9sqtZK2tJMlDKqjgJyD1uwOWdZQSCxHOVN2MDcLXkAW2ECB0c+wPbMvjU8c=
X-Received: by 2002:a0c:9562:: with SMTP id m31mr59699151qvm.27.1558620538065;
 Thu, 23 May 2019 07:08:58 -0700 (PDT)
Date: Thu, 23 May 2019 16:08:41 +0200
Message-Id: <20190523140844.132150-1-glider@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
Subject: [PATCH v4 0/3] RFC: add init_on_alloc/init_on_free boot options
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

