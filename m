Return-Path: <kernel-hardening-return-15959-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 6C5D32441D
	for <lists+kernel-hardening@lfdr.de>; Tue, 21 May 2019 01:20:27 +0200 (CEST)
Received: (qmail 1468 invoked by uid 550); 20 May 2019 23:20:14 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1449 invoked from network); 20 May 2019 23:20:13 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ziH51J2YkDxbiEVM2GrMAlpVSd+QVOkC6hl+iSpS1bQ=;
        b=eQRQDPc6uBU2Qk0F/htZOfYUHATfTVBNkYwDN/tGGT85UVF+0kNNU6JxQEi80X2jLd
         nOecMr02fvsUklEjSkgaRZyFW8oTUFJ0vBMXfd8I0clvZdaInAdo9I3e++bv+isAWIAS
         SbVUWwQ2uCxdPrlrZR8tJJBmOkDwJZLP5OV3E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ziH51J2YkDxbiEVM2GrMAlpVSd+QVOkC6hl+iSpS1bQ=;
        b=B6VhBBxVgdNbjZYt+qYB6XCOVVkgqFk7zfEj8aGaCHvMEoTCgIK95COZbEaWDEn9DJ
         X5M7oI4C3wKCRIu2L43r5GVA6d8L/8pu3JiET70k/kEF2J3M3lOB6YxH2g4/mJ79TRXd
         grmx+6YbL4eMf4qxY+7VnCBWvFc2z3V5U8czQnL8vEsRWSDYRDlf4f1CEkRywTPt9m8u
         FvGB6/LUDOsln1B+nNh0hbVjWrSM7poMeSp+hntGlFUEWKGs977Pf5XFA6P/3iyZtKUL
         zILOZv2UfPVqgS3SiK0xpyP1fTGYc6lbQHCmhXviDp7GSicetGwsrM8iPIiOuGNwRxxy
         guLw==
X-Gm-Message-State: APjAAAWC2qmBvO5oI+4VXfr2mS/QgcVZRGl3jpkTtsvRThzhI2n60Q86
	BAPRTYiSM9trovqfMDdAvSEXVSUFFeI=
X-Google-Smtp-Source: APXvYqyF4jfnvmglKBHVKthuceEzZGxOmZsOsky8xSLS2H68VewsiuHrWgBWYJrlDb7GE/qEMLwOnw==
X-Received: by 2002:a63:317:: with SMTP id 23mr78257345pgd.414.1558394401009;
        Mon, 20 May 2019 16:20:01 -0700 (PDT)
From: Thomas Garnier <thgarnie@chromium.org>
To: kernel-hardening@lists.openwall.com
Cc: kristen@linux.intel.com,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org,
	Andy Lutomirski <luto@kernel.org>,
	Juergen Gross <jgross@suse.com>,
	Alok Kataria <akataria@vmware.com>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Len Brown <len.brown@intel.com>,
	Pavel Machek <pavel@ucw.cz>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Garnier <thgarnie@google.com>,
	Nadav Amit <namit@vmware.com>,
	Jann Horn <jannh@google.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	Andi Kleen <ak@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Feng Tang <feng.tang@intel.com>,
	Jan Beulich <JBeulich@suse.com>,
	Maran Wilson <maran.wilson@oracle.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	linux-pm@vger.kernel.org
Subject: [PATCH v7 00/12] x86: PIE support to extend KASLR randomization
Date: Mon, 20 May 2019 16:19:25 -0700
Message-Id: <20190520231948.49693-1-thgarnie@chromium.org>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Splitting the previous serie in two. This part contains assembly code
changes required for PIE but without any direct dependencies with the
rest of the patchset.

Changes:
 - patch v7 (assembly):
   - Split patchset and reorder changes.
 - patch v6:
   - Rebase on latest changes in jump tables and crypto.
   - Fix wording on couple commits.
   - Revisit checkpatch warnings.
   - Moving to @chromium.org.
 - patch v5:
   - Adapt new crypto modules for PIE.
   - Improve per-cpu commit message.
   - Fix xen 32-bit build error with .quad.
   - Remove extra code for ftrace.
 - patch v4:
   - Simplify early boot by removing global variables.
   - Modify the mcount location script for __mcount_loc intead of the address
     read in the ftrace implementation.
   - Edit commit description to explain better where the kernel can be located.
   - Streamlined the testing done on each patch proposal. Always testing
     hibernation, suspend, ftrace and kprobe to ensure no regressions.
 - patch v3:
   - Update on message to describe longer term PIE goal.
   - Minor change on ftrace if condition.
   - Changed code using xchgq.
 - patch v2:
   - Adapt patch to work post KPTI and compiler changes
   - Redo all performance testing with latest configs and compilers
   - Simplify mov macro on PIE (MOVABS now)
   - Reduce GOT footprint
 - patch v1:
   - Simplify ftrace implementation.
   - Use gcc mstack-protector-guard-reg=%gs with PIE when possible.
 - rfc v3:
   - Use --emit-relocs instead of -pie to reduce dynamic relocation space on
     mapped memory. It also simplifies the relocation process.
   - Move the start the module section next to the kernel. Remove the need for
     -mcmodel=large on modules. Extends module space from 1 to 2G maximum.
   - Support for XEN PVH as 32-bit relocations can be ignored with
     --emit-relocs.
   - Support for GOT relocations previously done automatically with -pie.
   - Remove need for dynamic PLT in modules.
   - Support dymamic GOT for modules.
 - rfc v2:
   - Add support for global stack cookie while compiler default to fs without
     mcmodel=kernel
   - Change patch 7 to correctly jump out of the identity mapping on kexec load
     preserve.

These patches make some of the changes necessary to build the kernel as
Position Independent Executable (PIE) on x86_64. Another patchset will
add the PIE option and larger architecture changes.

The patches:
 - 1-2, 4-12: Change in assembly code to be PIE compliant.
 - 3: Add a new _ASM_MOVABS macro to fetch a symbol address generically.

diffstat:
 crypto/aegis128-aesni-asm.S         |    6 +-
 crypto/aegis128l-aesni-asm.S        |    8 +--
 crypto/aegis256-aesni-asm.S         |    6 +-
 crypto/aes-x86_64-asm_64.S          |   45 ++++++++++------
 crypto/aesni-intel_asm.S            |    8 +--
 crypto/camellia-aesni-avx-asm_64.S  |   42 +++++++--------
 crypto/camellia-aesni-avx2-asm_64.S |   44 ++++++++--------
 crypto/camellia-x86_64-asm_64.S     |    8 +--
 crypto/cast5-avx-x86_64-asm_64.S    |   50 ++++++++++--------
 crypto/cast6-avx-x86_64-asm_64.S    |   44 +++++++++-------
 crypto/des3_ede-asm_64.S            |   96 ++++++++++++++++++++++++------------
 crypto/ghash-clmulni-intel_asm.S    |    4 -
 crypto/glue_helper-asm-avx.S        |    4 -
 crypto/glue_helper-asm-avx2.S       |    6 +-
 crypto/morus1280-avx2-asm.S         |    4 -
 crypto/morus1280-sse2-asm.S         |    8 +--
 crypto/morus640-sse2-asm.S          |    6 +-
 crypto/sha256-avx2-asm.S            |   23 +++++---
 entry/entry_64.S                    |   16 ++++--
 include/asm/alternative.h           |    6 +-
 include/asm/asm.h                   |    1 
 include/asm/jump_label.h            |    8 +--
 include/asm/paravirt_types.h        |   12 +++-
 include/asm/pm-trace.h              |    2 
 include/asm/processor.h             |    6 +-
 kernel/acpi/wakeup_64.S             |   31 ++++++-----
 kernel/head_64.S                    |   16 +++---
 kernel/relocate_kernel_64.S         |    2 
 power/hibernate_asm_64.S            |    4 -
 29 files changed, 299 insertions(+), 217 deletions(-)

Patchset is based on next-20190515.


