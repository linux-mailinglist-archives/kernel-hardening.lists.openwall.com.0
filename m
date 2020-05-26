Return-Path: <kernel-hardening-return-18424-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 35B0719F857
	for <lists+kernel-hardening@lfdr.de>; Mon,  6 Apr 2020 16:57:07 +0200 (CEST)
Received: (qmail 7410 invoked by uid 550); 6 Apr 2020 14:57:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 30091 invoked from network); 6 Apr 2020 14:21:22 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=P1BSd5TdQrUJotdDVT+GKXMtS7urvBtUcYEMVMLIy+c=;
        b=OAQ9ux4XQikSxFQ4ROxE3Uq6j18TF+bKq0o8DJXeAlVbkrJbi/0JuR+r9J5iMO2NCb
         +G5jV1UxBkYL5GEveXHNs34NeFDdpRfd+gauLEgk3DnMWMQJiyNM3s6mGUKGr8EYqMkE
         Yb5eWGTM7vRP8kebgfknqKHS54hO1Ot69//uiPukV3aJT0qt+OIaFPOPM3zpOjqaLOL+
         u14Ky/ykxiW1YQTO5a9lCnPAkgLDezhdxRRcM7+KGNUiPRxi4IHshONAOOAvVfXXAfDy
         we8a+JLh0NyRIBJwO2hZiOMt0IvGrZw+L7YGktMp/6PFb4Ze19d+wUK6oNBRH15624Q/
         HO7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=P1BSd5TdQrUJotdDVT+GKXMtS7urvBtUcYEMVMLIy+c=;
        b=EOApplm8dFdX8w+xJ+wFIXQzXa+OgEuopNU1TxkNumL8n4RpCP3fIJAJp+l4k5t2zh
         iv8HIg4nq8lDquwOExqMVYSUfD6lFMoNW3C+nJA6ww00fQrxKcgGUy6rz8vaZLZdAuKM
         E7JXhB4ztYcYRQhR1na5L69oCiwr4WgJ7E3do2zq8MFwwedtVL6kUCpoFHejK8i7FKjK
         SeZrg4n7t0OxfEqZ3UMhfSXafDGDFd2NWetFbpHsIYpGJJfO+O/VpqGB0MQGbmojBTXA
         SCsP1jDsEWJdlohoLAn4nhyrqmGxdzAZjW+JOQGoqFw/AH/4UaoeEr+tOoAFGpnDcoR0
         hbig==
X-Gm-Message-State: AGi0Pub3TJ0kz35xJCwTVqo3ctr6Mcd7LKuebw1wDf5ypqtrbOK0JmC1
	uUTYcMPjsPyg86zUtVQfMjQ=
X-Google-Smtp-Source: APiQypI6nJpdo8Y/8uCtNT05FcePteGd7b3B9lCZclo/1kTwxeCsO9M7iUMEcU58PtgLqODPiYXfuA==
X-Received: by 2002:a05:600c:2f81:: with SMTP id t1mr1795192wmn.77.1586182870479;
        Mon, 06 Apr 2020 07:21:10 -0700 (PDT)
From: Lev Olshvang <levonshe@gmail.com>
To: arnd@arndb.de
Cc: kernel-hardening@lists.openwall.com,
	Lev Olshvang <levonshe@gmail.com>
Subject: [RFC PATCH 0/5] Prevent write to read-only pages (text, PLT/GOT
Date: Mon,  6 Apr 2020 17:20:40 +0300
Message-Id: <20200406142045.32522-1-levonshe@gmail.com>
X-Mailer: git-send-email 2.17.1

The purpose of this patch is produce hardened kernel for Embedded
or Production systems.

Typically debuggers, such as gdb, write to read-only code [text]
sections of target process.(ptrace)
This kind of page protectiion violation raises minor page fault, but
kernel's fault handler allows it by default.
This is clearly attack surface for adversary.

The proposed kernel hardening configuration option checks the type of
protection of the foreign vma and blocks writes to read only vma.

When enabled, it will stop attacks modifying code or jump tables, etc.

Lev Olshvang (5):
  security : hardening : prevent write to proces's read-only pages from
    another process
  Prevent write to read-only pages (text, PLT/GOT tables from another
    process
  Prevent write to read-only pages (text, PLT/GOT tables from another
    process
  X86:Prevent write to read-only pages (text, PLT/GOT tables from
    another process
  UM:Prevent write to read-only pages (text, PLT/GOT tables from another
    process

 arch/powerpc/include/asm/mmu_context.h   |  7 ++++++-
 arch/powerpc/mm/book3s64/pkeys.c         |  5 +++++
 arch/um/include/asm/mmu_context.h        | 11 ++++++++---
 arch/unicore32/include/asm/mmu_context.h |  7 ++++++-
 arch/x86/include/asm/mmu_context.h       |  9 ++++++++-
 include/asm-generic/mm_hooks.h           |  5 +++++
 security/Kconfig                         | 10 ++++++++++
 7 files changed, 48 insertions(+), 6 deletions(-)

--
2.17.1

