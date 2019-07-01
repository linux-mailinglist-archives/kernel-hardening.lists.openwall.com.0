Return-Path: <kernel-hardening-return-15819-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 1D0F7B2E1
	for <lists+kernel-hardening@lfdr.de>; Sat, 27 Apr 2019 08:43:29 +0200 (CEST)
Received: (qmail 1388 invoked by uid 550); 27 Apr 2019 06:43:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1340 invoked from network); 27 Apr 2019 06:43:15 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=eB6k5meLI0PLOK3mYE/JAtGJf13kBE3594LdTnKJT/c=;
        b=P8lkxgGjxqraib3dGi6LmdBMJFStrMGH5f7zRkLtPm0LyLdsCOatl1WplqSO6Vox5O
         QgceEyMkcGUHaPWov9uf5imUGYag+m6YfoDuve+tQrWc9Lnzck+ild+pJLBgqvAg+s4t
         tc2ZnLBudjA7+23D9apTsU8/5POeUm+9GGrBRc4Ff/HdRlJm0u0gfx3vlhknVKnRGfnO
         EiWhEn2/3fkfvOg0UEWNN2QVFDU+EZVBysGn0ITmKf0LFOg1DzCFALBMm4mesHSuLeC+
         J6TfDcCHfeBFtjn2od2kGVTzYa6WawY6jvV0lo/aa6bLxoGhvPKYoxlpD6UDLrUUf+Hb
         t5Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=eB6k5meLI0PLOK3mYE/JAtGJf13kBE3594LdTnKJT/c=;
        b=roWowVpgHUKN8mstURSkCz8rnOGcxv/VsMpIfsOgvuNVp4HtT1Uk3wZlLskmIqftiQ
         o4IiqBpNRdYByu6q3EVO+kEGaA2kVcDGwtnpYasRLFo49kCIE28GzJkI28HpHdZ5Xyj3
         AcVkYBRRgytOpuOWCCCI2mvyzcaW4FfZ8bgtEEXfjt9w6MG7p6ySgW6PLq9cLyAUvtQQ
         P0kw3nKv7DCb3CdiS+CsSllTgueF/by8B3ZDrK0Z+oggu+TEi18Zl3w9nyUvt9lerJ1D
         HKr+ecEMMQ65KmqqM3tTUDT8E7Wh7TcgSaG2YQzkxGuYqc4ErR8mvRlxyUKlyU3/2Y28
         5NCA==
X-Gm-Message-State: APjAAAVgx5ttZaDtrDbOSRsUtylvcS1jATpLpMw6hFu9meSdTc/56aJb
	ovF2C27q/lx0ES1ojQALI0w=
X-Google-Smtp-Source: APXvYqyb+o0qcII6hqlSl8V9sdm+gHB13Znu6WUBjFKn+pUN45+xAXNqkdkIsB0zzQNru3DiagNjEA==
X-Received: by 2002:a65:430a:: with SMTP id j10mr48510698pgq.143.1556347382897;
        Fri, 26 Apr 2019 23:43:02 -0700 (PDT)
From: nadav.amit@gmail.com
To: Peter Zijlstra <peterz@infradead.org>,
	Borislav Petkov <bp@alien8.de>,
	Andy Lutomirski <luto@kernel.org>,
	Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	hpa@zytor.com,
	Thomas Gleixner <tglx@linutronix.de>,
	Nadav Amit <nadav.amit@gmail.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	linux_dti@icloud.com,
	linux-integrity@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	akpm@linux-foundation.org,
	kernel-hardening@lists.openwall.com,
	linux-mm@kvack.org,
	will.deacon@arm.com,
	ard.biesheuvel@linaro.org,
	kristen@linux.intel.com,
	deneen.t.dock@intel.com,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Nadav Amit <namit@vmware.com>
Subject: [PATCH v6 00/24] x86: text_poke() fixes and executable lockdowns
Date: Fri, 26 Apr 2019 16:22:39 -0700
Message-Id: <20190426232303.28381-1-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1

From: Nadav Amit <namit@vmware.com>

*
* This version fixes failed boots on 32-bit that were reported by 0day.
* Patch 5 is added to initialize uprobes during fork initialization.
* Patch 7 (which was 6 in the previous version) is updated - the code is
* moved to common mm-init code with no further changes.
*

This patchset improves several overlapping issues around stale TLB
entries and W^X violations. It is combined from "x86/alternative:
text_poke() enhancements v7" [1] and "Don't leave executable TLB entries
to freed pages v2" [2] patchsets that were conflicting.

The related issues that this fixes:
1. Fixmap PTEs that are used for patching are available for access from
  other cores and might be exploited. They are not even flushed from
  the TLB in remote cores, so the risk is even higher. Address this
  issue by introducing a temporary mm that is only used during
  patching. Unfortunately, due to init ordering, fixmap is still used
  during boot-time patching. Future patches can eliminate the need for
  it.
2. Missing lockdep assertion to ensure text_mutex is taken. It is
  actually not always taken, so fix the instances that were found not
  to take the lock (although they should be safe even without taking
  the lock).
3. Module_alloc returning memory that is RWX until a module is finished
  loading.
4. Sometimes when memory is freed via the module subsystem, an
  executable permissioned TLB entry can remain to a freed page. If the
  page is re-used to back an address that will receive data from
  userspace, it can result in user data being mapped as executable in
  the kernel. The root of this behavior is vfree lazily flushing the
  TLB, but not lazily freeing the underlying pages.

Changes v5 to v6:
- Move poking_mm initialization to common x86 mm init [0day]
- Initialize uprobes during fork initialization [0day]

Changes v4 to v5:
- Change temporary state variable name [Borislav]
- Commit log and comment fixes [Borislav]

Changes v3 to v4:
- Remove the size parameter from tramp_free() [Steven]
- Remove caching of hw_breakpoint_active() [Sean]
- Prevent the use of bpf_probe_write_user() while using temporary mm [Jann]
- Fix build issues on other archs

Changes v2 to v3:
- Fix commit messages and comments [Boris]
- Rename VM_HAS_SPECIAL_PERMS [Boris]
- Remove unnecessary local variables [Boris]
- Rename set_alias_*() functions [Boris, Andy]
- Save/restore DR registers when using temporary mm
- Move line deletion from patch 10 to patch 17

Changes v1 to v2:
- Adding "Reviewed-by tag" [Masami]
- Comment instead of code to warn against module removal while
  patching [Masami]
- Avoiding open-coded TLB flush [Andy]
- Remove "This patch" [Borislav Petkov]
- Not set global bit during text poking [Andy, hpa]
- Add Ack from [Pavel Machek]
- Split patch 16 "Plug in new special vfree flag" into 4 patches (16-19)
  to make it easier to review. There were no code changes.

The changes from "Don't leave executable TLB entries to freed pages
v2" to v1:
- Add support for case of hibernate trying to save an unmapped page
  on the directmap. (Ard Biesheuvel)
- No week arch breakout for vfree-ing special memory (Andy Lutomirski)
- Avoid changing deferred free code by moving modules init free to work
  queue (Andy Lutomirski)
- Plug in new flag for kprobes and ftrace
- More arch generic names for set_pages functions (Ard Biesheuvel)
- Fix for TLB not always flushing the directmap (Nadav Amit)

Changes from "x86/alternative: text_poke() enhancements v7" to v1
- Fix build failure on CONFIG_RANDOMIZE_BASE=n (Rick)
- Remove text_poke usage from ftrace (Nadav)

[1] https://lkml.org/lkml/2018/12/5/200
[2] https://lkml.org/lkml/2018/12/11/1571

Andy Lutomirski (1):
  x86/mm: Introduce temporary mm structs

Nadav Amit (16):
  Fix "x86/alternatives: Lockdep-enforce text_mutex in text_poke*()"
  x86/jump_label: Use text_poke_early() during early init
  x86/mm: Save debug registers when loading a temporary mm
  uprobes: Initialize uprobes earlier
  fork: Provide a function for copying init_mm
  x86/alternative: Initialize temporary mm for patching
  x86/alternative: Use temporary mm for text poking
  x86/kgdb: Avoid redundant comparison of patched code
  x86/ftrace: Set trampoline pages as executable
  x86/kprobes: Set instruction page as executable
  x86/module: Avoid breaking W^X while loading modules
  x86/jump-label: Remove support for custom poker
  x86/alternative: Remove the return value of text_poke_*()
  x86/alternative: Comment about module removal races
  mm/tlb: Provide default nmi_uaccess_okay()
  bpf: Fail bpf_probe_write_user() while mm is switched

Rick Edgecombe (7):
  x86/mm/cpa: Add set_direct_map_ functions
  mm: Make hibernate handle unmapped pages
  vmalloc: Add flag for free of special permsissions
  modules: Use vmalloc special flag
  bpf: Use vmalloc special flag
  x86/ftrace: Use vmalloc special flag
  x86/kprobes: Use vmalloc special flag

 arch/Kconfig                         |   4 +
 arch/x86/Kconfig                     |   1 +
 arch/x86/include/asm/fixmap.h        |   2 -
 arch/x86/include/asm/mmu_context.h   |  56 ++++++++
 arch/x86/include/asm/pgtable.h       |   3 +
 arch/x86/include/asm/set_memory.h    |   3 +
 arch/x86/include/asm/text-patching.h |   7 +-
 arch/x86/include/asm/tlbflush.h      |   2 +
 arch/x86/kernel/alternative.c        | 201 ++++++++++++++++++++-------
 arch/x86/kernel/ftrace.c             |  22 +--
 arch/x86/kernel/jump_label.c         |  21 ++-
 arch/x86/kernel/kgdb.c               |  25 +---
 arch/x86/kernel/kprobes/core.c       |  19 ++-
 arch/x86/kernel/module.c             |   2 +-
 arch/x86/mm/init.c                   |  37 +++++
 arch/x86/mm/pageattr.c               |  16 ++-
 arch/x86/xen/mmu_pv.c                |   2 -
 include/asm-generic/tlb.h            |   9 ++
 include/linux/filter.h               |  18 +--
 include/linux/mm.h                   |  18 +--
 include/linux/sched/task.h           |   1 +
 include/linux/set_memory.h           |  11 ++
 include/linux/uprobes.h              |   5 +
 include/linux/vmalloc.h              |  15 ++
 init/main.c                          |   3 +
 kernel/bpf/core.c                    |   1 -
 kernel/events/uprobes.c              |   8 +-
 kernel/fork.c                        |  25 +++-
 kernel/module.c                      |  82 ++++++-----
 kernel/power/snapshot.c              |   5 +-
 kernel/trace/bpf_trace.c             |   8 ++
 mm/page_alloc.c                      |   7 +-
 mm/vmalloc.c                         | 113 ++++++++++++---
 33 files changed, 552 insertions(+), 200 deletions(-)

-- 
2.17.1

