Return-Path: <kernel-hardening-return-18445-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id BEB0C19FDF0
	for <lists+kernel-hardening@lfdr.de>; Mon,  6 Apr 2020 21:16:18 +0200 (CEST)
Received: (qmail 8096 invoked by uid 550); 6 Apr 2020 19:16:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 8062 invoked from network); 6 Apr 2020 19:16:12 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8alLqiTjU8UOc7F2lsFYEc9aYMbiDKRzOGKJAQNbNp8=;
        b=HtAz363J+42i6LrowqmUaBLMRHjE0UqrPwxe3TrxPcwSzjt4bWOjE3oX+G1GXoFwfD
         DuXlRv7NvZpKmZfnDSUxUPveN30QwxuCT9ERPIKvKdtHnHCERsPH7+XeUgJY9/EdRDXw
         najiMRbhEHp+rfNfO0dd568Slq+q8+dd32DrQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8alLqiTjU8UOc7F2lsFYEc9aYMbiDKRzOGKJAQNbNp8=;
        b=VhWFXm7CWJULjMR8c/BcQOF8OtfyzCmHSpYnJ7Nvhbrwm4LbFyaxvUrWZ+P6aG7MHd
         CsaiRpB0bM4cREEeYE2O/jYKhZNrIs6Xk/i+Yg9A390nrX7C/W65gxQUuhjwPKrh1qbd
         3AjdOBW1sCsmSx7bhFMFDHTCwOHugXymmKxKXXUfncydWAq5624FNaBzzNe60bbkG3TA
         SK+53LCIslvqH9YU/KJS4wUTyU0/yeaV60kzxWqe7NQov6BoUu/jXANyWjxuV3MU0IbH
         b392d5fdQYoauektaOlzVuTLhoQlPvzb0bUqIWvvlLQpc1K43ZtdqeCMbzXWU5QbwwR5
         KnZQ==
X-Gm-Message-State: AGi0PubBhCyBTQ4FgEmItECUqLOQjgoUu7n1tcydvpGIRx4Sq6t/kHDp
	qGmEgdRTa2DgwIp1sEjHUZDopQ==
X-Google-Smtp-Source: APiQypK3ki4ah6xMd7z9egiMYxyYeQ4F0636VFVogWdv5Css/C8K0fP3E0E+JxIAm+GnSrHWsx8Hbg==
X-Received: by 2002:a17:902:6acc:: with SMTP id i12mr21512840plt.61.1586200559797;
        Mon, 06 Apr 2020 12:15:59 -0700 (PDT)
Date: Mon, 6 Apr 2020 12:15:57 -0700
From: Kees Cook <keescook@chromium.org>
To: Lev Olshvang <levonshe@gmail.com>
Cc: arnd@arndb.de, kernel-hardening@lists.openwall.com,
	Jann Horn <jannh@google.com>
Subject: Re: [RFC PATCH 1/5] security : hardening : prevent write to proces's
 read-only pages from another process
Message-ID: <202004061201.27B0972@keescook>
References: <20200406142045.32522-1-levonshe@gmail.com>
 <20200406142045.32522-2-levonshe@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200406142045.32522-2-levonshe@gmail.com>

On Mon, Apr 06, 2020 at 05:20:41PM +0300, Lev Olshvang wrote:
> The purpose of this patch is produce hardened kernel for Embedded
> or Production systems.
> 
> Typically debuggers, such as gdb, write to read-only code [text]
> sections of target process.(ptrace)
> This kind of page protectiion violation raises minor page fault, but
> kernel's fault handler allows it by default.
> This is clearly attack surface for adversary.
> 
> The proposed kernel hardening configuration option checks the type of
> protection of the foreign vma and blocks writes to read only vma.
> 
> When enabled, it will stop attacks modifying code or jump tables, etc.
> 
> Code of arch_vma_access_permitted() function was extended to
> check foreign vma flags.
> 
> Tested on x86_64 and ARM(QEMU) with dd command which writes to
> /proc/PID/mem in r--p or r--xp of vma area addresses range
> 
> dd reports IO failure when tries to write to adress taken from
> from /proc/PID/maps (PLT or code section)

So, just to give some background here: the reason for this behavior is
so debuggers can insert software breakpoints in the .text section (0xcc)
etc. This is implemented with the "FOLL_FORCE" flag, and an attempt to
remove it was made here:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=8ee74a91ac30
but it was later reverted (see below).

There have been many prior discussions about this behavior, and a
good thread (which I link from https://github.com/KSPP/linux/issues/37
"Block process from writing to its own /proc/$pid/mem") is this one:
https://lore.kernel.org/lkml/CAGXu5j+PHzDwnJxJwMJ=WuhacDn_vJWe9xZx+Kbsh28vxOGRiA@mail.gmail.com/

For details on the revert see:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=f511c0b17b08

All this said, I think this feature would still be nice to have,
available with some kind of knob to control it. Do you get the
results you were expecting from just re-applying 8ee74a91ac30? If
so, that's a much smaller change, and a single place to apply
a knob. It would likely be best implemented with a sysctl and a
static_branch(). A possible example for this can be seen here:
https://lore.kernel.org/lkml/20200324203231.64324-4-keescook@chromium.org/
Though it doesn't use a sysctl. (And perhaps this feature needs to be a
per-process setting like "dumpable", but let's start simple with a
system-wide control.)

Can you test the FOLL_FORCE removal and refactor things to use a
static_branch() instead?

-Kees

> Signed-off-by: Lev Olshvang <levonshe@gmail.com>
> ---
>  include/asm-generic/mm_hooks.h |  5 +++++
>  security/Kconfig               | 10 ++++++++++
>  2 files changed, 15 insertions(+)
> 
> diff --git a/include/asm-generic/mm_hooks.h b/include/asm-generic/mm_hooks.h
> index 4dbb177d1150..6e1fcce44cc2 100644
> --- a/include/asm-generic/mm_hooks.h
> +++ b/include/asm-generic/mm_hooks.h
> @@ -25,6 +25,11 @@ static inline void arch_unmap(struct mm_struct *mm,
>  static inline bool arch_vma_access_permitted(struct vm_area_struct *vma,
>  		bool write, bool execute, bool foreign)
>  {
> +#ifdef CONFIG_PROTECT_READONLY_USER_MEMORY
> +	/* Forbid write to PROT_READ pages of foreign process */
> +	if (write && foreign && (!(vma->vm_flags & VM_WRITE)))
> +		return false;
> +#endif
>  	/* by default, allow everything */
>  	return true;
>  }
> diff --git a/security/Kconfig b/security/Kconfig
> index cd3cc7da3a55..d92e79c90d67 100644
> --- a/security/Kconfig
> +++ b/security/Kconfig
> @@ -143,6 +143,16 @@ config LSM_MMAP_MIN_ADDR
>  	  this low address space will need the permission specific to the
>  	  systems running LSM.
>  
> +config PROTECT_READONLY_USER_MEMORY
> +	bool "Protect read only process memory"
> +	help
> +	  Protects read only memory of process code and PLT table
> +	  from possible attack through /proc/PID/mem or through /dev/mem.
> +	  Refuses to insert and stop at debuggers breakpoints (prtace,gdb)
> +	  Mostly advised for embedded and production system.
> +	  Stops attempts of the malicious process to modify read only memory of another process
> +
> +
>  config HAVE_HARDENED_USERCOPY_ALLOCATOR
>  	bool
>  	help
> -- 
> 2.17.1
> 

-- 
Kees Cook
