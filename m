Return-Path: <kernel-hardening-return-15885-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id F196616780
	for <lists+kernel-hardening@lfdr.de>; Tue,  7 May 2019 18:13:58 +0200 (CEST)
Received: (qmail 14314 invoked by uid 550); 7 May 2019 16:13:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 14290 invoked from network); 7 May 2019 16:13:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=G8Fv5OtINQpv7rQM6n3u/8e+E08Vz7aR23eSUbSIdaA=;
        b=m9QH7Pj+jWZ00plFaD34XJ4bXZX37XD/8YZSihND49nAlrV6HtJ88LaoUwJhJjW69T
         GQ9JRw4jaMO5skBMR6BvxHWfV9SMdXzx+BcrjzOy1LAodcaBMtpxqEiUZJbZ3HjUeErm
         l2nBytWD4PRqBDQj8o/EUasTGI5gnin1CorLw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=G8Fv5OtINQpv7rQM6n3u/8e+E08Vz7aR23eSUbSIdaA=;
        b=Tojvq5rYTRJe7LszmFKlxU1Co5e8mvZGshHDulnxsV5s3OjECDm7tiaT/keYJ9ud1V
         6GvM2xHDWDCODE/i44oGBVvRa03mXFqot910IrZ2go7L3PtH5Oe1lckMUvMYQO1xZ8Ec
         AXHeZNAmMSRH9Mu1mSv7hESWoKB3I3dRoYb1nbePzN8vTWITztxDVIbrvF3ZH6hDrmC3
         GBZqr//G56bE4Q30mWd1hxxynF3plVl8/8NSbroyYDaSrSEGoW72/f6aCcvvc+38haE1
         RVqX+eyhXWkF7fFz1nALergoq8gjdkB5zbprSFudG1KxyH4jFOVfGydpTRbecSkwN1Bf
         FLAA==
X-Gm-Message-State: APjAAAVei1bmg1PcesxGu+mE2/yrSAF5+4C3leR8+HPlmwJLeifhkP+0
	wsE+YmCNFylcJrkL7Qyiu1UBrg==
X-Google-Smtp-Source: APXvYqx5bxQhuDKx6yG8AtxVsxUDq4d1U+bTyokMD+jyXXBS5DOFMePdxHMknm1qdR/wfQsbWkW94w==
X-Received: by 2002:a63:d343:: with SMTP id u3mr40966454pgi.285.1557245611889;
        Tue, 07 May 2019 09:13:31 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Kees Cook <keescook@chromium.org>,
	Joao Moreira <jmoreira@suse.de>,
	Eric Biggers <ebiggers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	x86@kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: [PATCH v3 0/7] crypto: x86: Fix indirect function call casts
Date: Tue,  7 May 2019 09:13:14 -0700
Message-Id: <20190507161321.34611-1-keescook@chromium.org>
X-Mailer: git-send-email 2.17.1

It is possible to indirectly invoke functions with prototypes that do
not match those of the respectively used function pointers by using void
types or casts. This feature is frequently used as a way of relaxing
function invocation, making it possible that different data structures
are passed to different functions through the same pointer.

Despite the benefits, this can lead to a situation where functions with a
given prototype are invoked by pointers with a different prototype. This
is undesirable as it may prevent the use of heuristics such as prototype
matching-based Control-Flow Integrity, which can be used to prevent
ROP-based attacks.

One way of fixing this situation is through the use of inline helper
functions with prototypes that match the one in the respective invoking
pointer.

Given the above, the current efforts to improve the Linux security,
and the upcoming kernel support to compilers with CFI features, this
creates macros to be used to build the needed function definitions,
to be used in camellia, cast6, serpent, twofish, and aesni.

-Kees (and Joao)

v3:
- no longer RFC
- consolidate macros into glue_helper.h
- include aesni which was using casts as well
- remove XTS_TWEAK_CAST while we're at it

v2:
- update cast macros for clarity

v1:
- initial prototype

Joao Moreira (4):
  crypto: x86/crypto: Use new glue function macros
  crypto: x86/camellia: Use new glue function macros
  crypto: x86/twofish: Use new glue function macros
  crypto: x86/cast6: Use new glue function macros

Kees Cook (3):
  crypto: x86/glue_helper: Add static inline function glue macros
  crypto: x86/aesni: Use new glue function macros
  crypto: x86/glue_helper: Remove function prototype cast helpers

 arch/x86/crypto/aesni-intel_glue.c         | 31 ++++-----
 arch/x86/crypto/camellia_aesni_avx2_glue.c | 73 +++++++++-------------
 arch/x86/crypto/camellia_aesni_avx_glue.c  | 63 +++++++------------
 arch/x86/crypto/camellia_glue.c            | 21 +++----
 arch/x86/crypto/cast6_avx_glue.c           | 65 +++++++++----------
 arch/x86/crypto/serpent_avx2_glue.c        | 65 +++++++++----------
 arch/x86/crypto/serpent_avx_glue.c         | 58 ++++++-----------
 arch/x86/crypto/serpent_sse2_glue.c        | 27 +++++---
 arch/x86/crypto/twofish_avx_glue.c         | 71 ++++++++-------------
 arch/x86/crypto/twofish_glue_3way.c        | 28 ++++-----
 arch/x86/include/asm/crypto/camellia.h     | 64 ++++++-------------
 arch/x86/include/asm/crypto/glue_helper.h  | 34 ++++++++--
 arch/x86/include/asm/crypto/serpent-avx.h  | 28 ++++-----
 arch/x86/include/asm/crypto/twofish.h      | 22 ++++---
 include/crypto/xts.h                       |  2 -
 15 files changed, 283 insertions(+), 369 deletions(-)

-- 
2.17.1

