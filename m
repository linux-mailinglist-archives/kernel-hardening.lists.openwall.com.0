Return-Path: <kernel-hardening-return-15921-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id B52D41CA98
	for <lists+kernel-hardening@lfdr.de>; Tue, 14 May 2019 16:41:48 +0200 (CEST)
Received: (qmail 9505 invoked by uid 550); 14 May 2019 14:41:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 1681 invoked from network); 14 May 2019 14:36:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=1S3UpPMCsUYARGblfLiXJrv1RGJby3aJS40wLMGa3dM=;
        b=N4cVB/TrzGXrU+JIqpEKUOOiqZ++Ae09TQc1nHL54R3ofVCluFA9okBzZNBc6z35c5
         4zKM7jIzF6gOH2Fu+BP5UDDZGSTG0Ux2yPym3mQ/V8dg8QrZatmp2DejdAuMJ94wrNre
         qFL1sH/Ne/4tRn+P7zJs62RSdojAyWMIBHulvrTEeAL10Hau8upfqWNNwucFbZY7URDj
         b9RLiCC2PUXueBlim5ddiD2A/dOUpaCBT0gF3fVXQRmi/X+dfq6UEsdQUUr/qRvzqX0c
         f/oSeT99+8dRX+g2Q1iDrUFuG7MkqdxImg1/GQCxUsqWnVKHEnJqz4PwdGmzA2kisgEQ
         BN9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=1S3UpPMCsUYARGblfLiXJrv1RGJby3aJS40wLMGa3dM=;
        b=TshjfsAJR688JqskD5lCPy68RWLawSzSXRcsCXfwd8zBw774hJr2hw9rGwbUYEUoJJ
         BHx8u8B9XXnLr6Eaw8TdlTuFHw4FJyGfPtfhfr6grveupqAv8jatm+UxgHBsgsdYRxSY
         uNhO5CIAPybTVO4LdJuflhWV9svV5UGApojujCBYHu8gykwNr6fwICMZH78/YeGlxQtk
         f4b2TzmNNu8PoboCHINVC4Qgq76lrOIhArsZ4lcTh70ZsaEV4sOfWMYy82EEf0RZE9uG
         wTerFiFk6GHfXyL01dgbfZlf2co0Gx/oJEsp3u+t4euaEcq3ogvzFcvMmF61ATEWtgZs
         bmmQ==
X-Gm-Message-State: APjAAAVVi3TC0cVAuIm0FHi5Dp2vYPoCE6X2ucSGLJW3QsnEFh3kk6/y
	Sc2iG1gEPNkvmPUhfFBsZ41uA3hhiq8=
X-Google-Smtp-Source: APXvYqxvR9Pybwzmae1KDoNBWjFRLbZl1mkp8+f6yOVGLAGGE9nci9W4s8kMjwQAtNmpreFLljtdqtBMQzE=
X-Received: by 2002:a37:a1c6:: with SMTP id k189mr29832181qke.100.1557844553412;
 Tue, 14 May 2019 07:35:53 -0700 (PDT)
Date: Tue, 14 May 2019 16:35:33 +0200
Message-Id: <20190514143537.10435-1-glider@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
Subject: [PATCH v2 0/4] RFC: add init_on_alloc/init_on_free boot options
From: Alexander Potapenko <glider@google.com>
To: akpm@linux-foundation.org, cl@linux.com, keescook@chromium.org
Cc: kernel-hardening@lists.openwall.com
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
  gfp: mm: introduce __GFP_NO_AUTOINIT
  net: apply __GFP_NO_AUTOINIT to AF_UNIX sk_buff allocations

 .../admin-guide/kernel-parameters.txt         |   8 +
 drivers/infiniband/core/uverbs_ioctl.c        |   2 +-
 include/linux/gfp.h                           |  13 +-
 include/linux/mm.h                            |  22 ++
 include/net/sock.h                            |   5 +
 kernel/kexec_core.c                           |   5 +-
 lib/Kconfig.debug                             |   8 +
 lib/Makefile                                  |   1 +
 lib/test_meminit.c                            | 205 ++++++++++++++++++
 mm/dmapool.c                                  |   2 +-
 mm/page_alloc.c                               |  68 +++++-
 mm/slab.c                                     |  18 +-
 mm/slab.h                                     |  16 ++
 mm/slob.c                                     |  23 +-
 mm/slub.c                                     |  28 ++-
 net/core/sock.c                               |  31 ++-
 net/unix/af_unix.c                            |  13 +-
 security/Kconfig.hardening                    |  14 ++
 18 files changed, 443 insertions(+), 39 deletions(-)
 create mode 100644 lib/test_meminit.c

-- 
2.21.0.1020.gf2820cf01a-goog

