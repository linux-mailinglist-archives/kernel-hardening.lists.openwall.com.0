Return-Path: <kernel-hardening-return-18447-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 0ED7D1A0175
	for <lists+kernel-hardening@lfdr.de>; Tue,  7 Apr 2020 01:16:40 +0200 (CEST)
Received: (qmail 24113 invoked by uid 550); 6 Apr 2020 23:16:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 23913 invoked from network); 6 Apr 2020 23:16:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Kj0fYRHBAuDC6xz5T3+IMY573Uf4TkncfKhylRhRKr8=;
        b=Rnk2RVuDB3re41BD3czt9clTzzC/cySvN48by3vzvbYksd47leEn0+g33oR+D6OVLF
         uXnS/s3ykH8Z394kfgC1rK54rvOztdgYEYgrOrRJV5V3tiF0pL7Q/1fZwsVEAzo0r6Bj
         pI05/jTCAIBznKwWxphMyFNjRNChw4MmGQa1A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Kj0fYRHBAuDC6xz5T3+IMY573Uf4TkncfKhylRhRKr8=;
        b=Dw+zDMBWdzw2zvoxYK65cAhzy628gs7aWoHj5nuTGO/2e/I1vMrhnAsEyzHoHW42ht
         y4s10wla2VypshQDSgo9wRlE5HseQLggmcbGOnVMBohWTHoDlap7QplLSXytP8zE1pcR
         jGSteEt9yI1FFmylwQoWcAYpdFnkqjn19Vqq3XfW3jvAelbcWFWa4BQDwGLWG2At6Usx
         L7WezYkL9J1IfoanqZ6WC3+G4nBCUrsQPcuaB5zIz9UM7K8gbLF4roV2fvHFNUFiTWys
         d1G0offRxYhy9uWl+42MVnVGNFxz52Y9cCKl15SXdE/KAdzse9wwZUN6HVGGguekHBma
         x+Og==
X-Gm-Message-State: AGi0Puayec7ko+jOY1yXE2dzojo1wu1q9x8S9XekUPA57jJFItDGoVxc
	QhJKJxWhaBWUxAA459qNBnG7Sg==
X-Google-Smtp-Source: APiQypLe1NK0ouaCbwea2Ar/mlZdKQ8TmXJhYkOr0ndqJkk1T9pLSfqEkeDLbIKHtYCq5a4S/3PzgQ==
X-Received: by 2002:a17:902:22e:: with SMTP id 43mr21611580plc.119.1586214972026;
        Mon, 06 Apr 2020 16:16:12 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Kees Cook <keescook@chromium.org>,
	Elena Reshetova <elena.reshetova@intel.com>,
	x86@kernel.org,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Potapenko <glider@google.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Jann Horn <jannh@google.com>,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/5] Optionally randomize kernel stack offset each syscall
Date: Mon,  6 Apr 2020 16:16:01 -0700
Message-Id: <20200406231606.37619-1-keescook@chromium.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v3:
- added review/ack tags (peterz, glider)
- further clarified commit logs and public attack references
- added -fstack-protector downgrades and details
v2: https://lore.kernel.org/lkml/20200324203231.64324-1-keescook@chromium.org/
rfc: https://lore.kernel.org/kernel-hardening/20190329081358.30497-1-elena.reshetova@intel.com/

Hi,

This is a continuation and refactoring of Elena's earlier effort to add
kernel stack base offset randomization. In the time since the previous
discussions, two attacks[1][2] were made public that depended on stack
determinism, so we're no longer in the position of "this is a good idea
but we have no examples of attacks". :)

Earlier discussions also devolved into debates on entropy sources, which
is mostly a red herring, given the already low entropy available due
to stack size. Regardless, entropy can be changed/improved separately
from this series as needed.

Earlier discussions also got stuck debating how much syscall overhead
was too much, but this is also a red herring since the feature itself
needs to be selectable at boot with no cost for those that don't want it:
this is solved here with static branches.

So, here is an improved version, made as arch-agnostic as possible,
with usage added for x86 and arm64. It also includes some small static
branch clean ups, and addresses some surprise performance issues due to
the stack canary[3].

Thanks!

-Kees

[1] https://a13xp0p0v.github.io/2020/02/15/CVE-2019-18683.html
[2] https://repositorio-aberto.up.pt/bitstream/10216/125357/2/374717.pdf
[3] https://lore.kernel.org/lkml/202003281520.A9BFF461@keescook/

Kees Cook (5):
  jump_label: Provide CONFIG-driven build state defaults
  init_on_alloc: Unpessimize default-on builds
  stack: Optionally randomize kernel stack offset each syscall
  x86/entry: Enable random_kstack_offset support
  arm64: entry: Enable random_kstack_offset support

 Makefile                         |  4 ++++
 arch/Kconfig                     | 23 ++++++++++++++++++
 arch/arm64/Kconfig               |  1 +
 arch/arm64/kernel/Makefile       |  4 ++++
 arch/arm64/kernel/syscall.c      | 10 ++++++++
 arch/x86/Kconfig                 |  1 +
 arch/x86/entry/Makefile          |  9 +++++++
 arch/x86/entry/common.c          | 12 +++++++++-
 include/linux/jump_label.h       | 19 +++++++++++++++
 include/linux/mm.h               | 18 +++++---------
 include/linux/randomize_kstack.h | 40 ++++++++++++++++++++++++++++++++
 init/main.c                      | 23 ++++++++++++++++++
 mm/page_alloc.c                  | 12 ++--------
 13 files changed, 153 insertions(+), 23 deletions(-)
 create mode 100644 include/linux/randomize_kstack.h

-- 
2.20.1

