Return-Path: <kernel-hardening-return-16172-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 64E2A49877
	for <lists+kernel-hardening@lfdr.de>; Tue, 18 Jun 2019 06:55:39 +0200 (CEST)
Received: (qmail 19750 invoked by uid 550); 18 Jun 2019 04:55:21 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 19629 invoked from network); 18 Jun 2019 04:55:19 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=fASSq0Wc774NJxzj3o2gVuE5L9Puh7p/qKeMYZ6n7cI=;
        b=kfXDN39x37u2gUdXh+31TVmw16KUbhKiGXOUmJK5IjvAQyqqoQGsF+yxC7w6YsYspo
         YdKYEmiFvEROnpcEaCue7cQjW/ReQiiP8z3EhSEYK8o8dzSJrngcUUMOH5G1jQibPf+U
         at0UlIUZFTfO7GkFUTJI6I7V89g/bXLxrdJ7A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=fASSq0Wc774NJxzj3o2gVuE5L9Puh7p/qKeMYZ6n7cI=;
        b=VOyioYDajk5kAtoj4Y4pVj7+ThoY3OXfdDJhvJ6XgaPc6l4umJqw2ik6MFdGKkwa4u
         6l7WOz4maBI7yo338YoVJX4YHYVLlhrvfilw4/khmkLvJXJzAaKy3whnrQN/CBlpur8N
         MAyc2vPr4p0X/lbAGyVdsVDnvJl0915J+RmjLLara2GntNo8P2IC7e7dJ6EI0g+DGHfI
         s8268MuZwfvfRCyWE82JPu+W8M4k//g5/MxIbxCP0VgYPc4JX1xePN8NGeRUfpP1Fxes
         uNh71t+x6yAL7t3JRWO9vtp/Kq4xSCKro81N5O0zgt693JmEDV+51uOiQa0BfO3Rwy3o
         s3Aw==
X-Gm-Message-State: APjAAAXyp5/J0z2cJNAo4uLiFK02iMCIWqGpoD8LTz+mgOhMyrJzK9nn
	6UFwjWKyifv/pzJ8EcDnSXf/EQ==
X-Google-Smtp-Source: APXvYqzQ6ivjg+w9Tcb/dlwC09AhFIwKHfALRY+f+pu5Z7NUCBWf3NtYl2A0C3qWH168n0z7jQNATw==
X-Received: by 2002:a63:905:: with SMTP id 5mr863624pgj.173.1560833707635;
        Mon, 17 Jun 2019 21:55:07 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Kees Cook <keescook@chromium.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	x86@kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Dave Hansen <dave.hansen@intel.com>,
	linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: [PATCH v3 0/3] x86/asm: Pin sensitive CR4 and CR0 bits
Date: Mon, 17 Jun 2019 21:55:00 -0700
Message-Id: <20190618045503.39105-1-keescook@chromium.org>
X-Mailer: git-send-email 2.17.1

Hi,

This updates the cr pinning series to allow for no silent papering-over
of pinning bugs (thanks to tglx to pointing out where I needed to poke
cr4 harder). I've tested with under normal boot and hibernation.

-Kees

Kees Cook (3):
  lkdtm: Check for SMEP clearing protections
  x86/asm: Pin sensitive CR4 bits
  x86/asm: Pin sensitive CR0 bits

 arch/x86/include/asm/special_insns.h | 37 +++++++++++++++-
 arch/x86/kernel/cpu/common.c         | 20 +++++++++
 arch/x86/kernel/smpboot.c            |  8 +++-
 drivers/misc/lkdtm/bugs.c            | 66 ++++++++++++++++++++++++++++
 drivers/misc/lkdtm/core.c            |  1 +
 drivers/misc/lkdtm/lkdtm.h           |  1 +
 6 files changed, 130 insertions(+), 3 deletions(-)

--
2.17.1

