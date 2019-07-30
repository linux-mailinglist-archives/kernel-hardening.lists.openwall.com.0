Return-Path: <kernel-hardening-return-16641-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 86F9B7B119
	for <lists+kernel-hardening@lfdr.de>; Tue, 30 Jul 2019 20:02:11 +0200 (CEST)
Received: (qmail 11424 invoked by uid 550); 30 Jul 2019 18:02:05 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 11404 invoked from network); 30 Jul 2019 18:02:04 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=e4oBhvl2JGL/g7znlpJb17wcZ4f4c/GlFLmGamjl13c=;
        b=fbKhNQxzz82g4sdnAhZ57A0hb0uBcdzsGtvJIewH6J8HFiWd4v1DbjhZme3+FPpHN+
         CgVrRWW5s0YuozJII/YB+2NZ5r573QGkU38HNUz7maBvW4CAJRPZpo9gRRMOu66NfgT1
         4s1JAmGCs8uLjMqep+2ShT7MpdeLsB0l8QKaU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=e4oBhvl2JGL/g7znlpJb17wcZ4f4c/GlFLmGamjl13c=;
        b=W2GEfB49EJXaqo44y3SR4ZDiOXjn9WWUIBJmmSuLjq9AEU3JkynOEE8IcHVVW/7fXe
         sj/WEbfkSd+VrInjLGcBPqw8V5QGx5kq1jfgZ34e6vZ/fy0O51FKW4ObN3lNh8yqXheU
         hWLfKrdiDz1q56k3XEMmeJ9KrnUYtQ3qITQ6F6pMgn1IfwKsajx0q2YTQInokSs9BIJr
         ow6321MBttBMWe6iDRu2WXT6kQTGEtbzHeDhtBsOj1YEteuKaozZbEt/g50+EjkAB6uM
         ZqftbvWPXrqT9jliVQM/7xEO9k9JzkT9WBDic+btsDpp2auM8oEs60on9OT8vZ03UuBA
         sGCA==
X-Gm-Message-State: APjAAAVVloBtvgrAKBlQlPjMhPae0uOesvWucJfTDekrV3YV+PVcpJX4
	8D7OGiAj9W9Q/TobXYratbwNzA==
X-Google-Smtp-Source: APXvYqxjt+I4v/sdEnywIDMFxpX9dhohJ2h/xcn+2r0A6Nitb41VcNHFgzjYokT3yWbk7qgmF27dvQ==
X-Received: by 2002:a17:90a:cb12:: with SMTP id z18mr112668727pjt.82.1564509712356;
        Tue, 30 Jul 2019 11:01:52 -0700 (PDT)
Date: Tue, 30 Jul 2019 11:01:50 -0700
From: Kees Cook <keescook@chromium.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Thomas Garnier <thgarnie@chromium.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, kernel-hardening@lists.openwall.com,
	kristen@linux.intel.com, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
	Andy Lutomirski <luto@kernel.org>, Juergen Gross <jgross@suse.com>,
	Alok Kataria <akataria@vmware.com>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
	Peter Zijlstra <peterz@infradead.org>,
	Nadav Amit <namit@vmware.com>, Jann Horn <jannh@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Feng Tang <feng.tang@intel.com>,
	Maran Wilson <maran.wilson@oracle.com>,
	Enrico Weigelt <info@metux.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alexios Zavras <alexios.zavras@intel.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	virtualization@lists.linux-foundation.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v8 00/11] x86: PIE support to extend KASLR randomization
Message-ID: <201907301100.90BB865078@keescook>
References: <20190708174913.123308-1-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708174913.123308-1-thgarnie@chromium.org>

On Mon, Jul 08, 2019 at 10:48:53AM -0700, Thomas Garnier wrote:
> Splitting the previous series in two. This part contains assembly code
> changes required for PIE but without any direct dependencies with the
> rest of the patchset.
> 
> Changes:
>  - patch v8 (assembly):
>    - Fix issues in crypto changes (thanks to Eric Biggers).
>    - Remove unnecessary jump table change.
>    - Change author and signoff to chromium email address.

With -rc2 done, is this a good time for this to land in -tip? Are there
more steps needed for review?

Thanks!

-Kees

>  - patch v7 (assembly):
>    - Split patchset and reorder changes.
>  - patch v6:
>    - Rebase on latest changes in jump tables and crypto.
>    - Fix wording on couple commits.
>    - Revisit checkpatch warnings.
>    - Moving to @chromium.org.
>  - patch v5:
>    - Adapt new crypto modules for PIE.
>    - Improve per-cpu commit message.
>    - Fix xen 32-bit build error with .quad.
>    - Remove extra code for ftrace.
>  - patch v4:
>    - Simplify early boot by removing global variables.
>    - Modify the mcount location script for __mcount_loc intead of the address
>      read in the ftrace implementation.
>    - Edit commit description to explain better where the kernel can be located.
>    - Streamlined the testing done on each patch proposal. Always testing
>      hibernation, suspend, ftrace and kprobe to ensure no regressions.
>  - patch v3:
>    - Update on message to describe longer term PIE goal.
>    - Minor change on ftrace if condition.
>    - Changed code using xchgq.
>  - patch v2:
>    - Adapt patch to work post KPTI and compiler changes
>    - Redo all performance testing with latest configs and compilers
>    - Simplify mov macro on PIE (MOVABS now)
>    - Reduce GOT footprint
>  - patch v1:
>    - Simplify ftrace implementation.
>    - Use gcc mstack-protector-guard-reg=%gs with PIE when possible.
>  - rfc v3:
>    - Use --emit-relocs instead of -pie to reduce dynamic relocation space on
>      mapped memory. It also simplifies the relocation process.
>    - Move the start the module section next to the kernel. Remove the need for
>      -mcmodel=large on modules. Extends module space from 1 to 2G maximum.
>    - Support for XEN PVH as 32-bit relocations can be ignored with
>      --emit-relocs.
>    - Support for GOT relocations previously done automatically with -pie.
>    - Remove need for dynamic PLT in modules.
>    - Support dymamic GOT for modules.
>  - rfc v2:
>    - Add support for global stack cookie while compiler default to fs without
>      mcmodel=kernel
>    - Change patch 7 to correctly jump out of the identity mapping on kexec load
>      preserve.
> 
> These patches make some of the changes necessary to build the kernel as
> Position Independent Executable (PIE) on x86_64. Another patchset will
> add the PIE option and larger architecture changes.
> 
> The patches:
>  - 1, 3-11: Change in assembly code to be PIE compliant.
>  - 2: Add a new _ASM_MOVABS macro to fetch a symbol address generically.
> 
> diffstat:
>  crypto/aegis128-aesni-asm.S         |    6 +-
>  crypto/aegis128l-aesni-asm.S        |    8 +--
>  crypto/aegis256-aesni-asm.S         |    6 +-
>  crypto/aes-x86_64-asm_64.S          |   45 ++++++++++------
>  crypto/aesni-intel_asm.S            |    8 +--
>  crypto/aesni-intel_avx-x86_64.S     |    3 -
>  crypto/camellia-aesni-avx-asm_64.S  |   42 +++++++--------
>  crypto/camellia-aesni-avx2-asm_64.S |   44 ++++++++--------
>  crypto/camellia-x86_64-asm_64.S     |    8 +--
>  crypto/cast5-avx-x86_64-asm_64.S    |   50 ++++++++++--------
>  crypto/cast6-avx-x86_64-asm_64.S    |   44 +++++++++-------
>  crypto/des3_ede-asm_64.S            |   96 ++++++++++++++++++++++++------------
>  crypto/ghash-clmulni-intel_asm.S    |    4 -
>  crypto/glue_helper-asm-avx.S        |    4 -
>  crypto/glue_helper-asm-avx2.S       |    6 +-
>  crypto/morus1280-avx2-asm.S         |    4 -
>  crypto/morus1280-sse2-asm.S         |    8 +--
>  crypto/morus640-sse2-asm.S          |    6 +-
>  crypto/sha256-avx2-asm.S            |   18 ++++--
>  entry/entry_64.S                    |   16 ++++--
>  include/asm/alternative.h           |    6 +-
>  include/asm/asm.h                   |    1 
>  include/asm/paravirt_types.h        |   25 +++++++--
>  include/asm/pm-trace.h              |    2 
>  include/asm/processor.h             |    6 +-
>  kernel/acpi/wakeup_64.S             |   31 ++++++-----
>  kernel/head_64.S                    |   16 +++---
>  kernel/relocate_kernel_64.S         |    2 
>  power/hibernate_asm_64.S            |    4 -
>  29 files changed, 306 insertions(+), 213 deletions(-)
> 
> Patchset is based on next-20190708.
> 
> 

-- 
Kees Cook
