Return-Path: <kernel-hardening-return-21520-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id A055D48029E
	for <lists+kernel-hardening@lfdr.de>; Mon, 27 Dec 2021 18:12:24 +0100 (CET)
Received: (qmail 3523 invoked by uid 550); 27 Dec 2021 17:12:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 20258 invoked from network); 27 Dec 2021 16:50:01 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UJvw3kqO9RHMu+IzeG917wcb7IDDdBROQHd6PdvJoHk=;
        b=nBEYqr7HSlw1lIl+5TxmVYNW7mxah8cpvnuOKZDV+kGPRL9VVY/AFiWcYVxVJuMRds
         WsirjfSQwT8p0BX0zVR8JEPUN4IBxFihfWAaMgzO7ghsOY9qt/BUj5ddqKl9d3ytT6dY
         ReC/rBS/XZ4rgxj1BI3fejOdRb/RYG5NekVjA0huu1b6kba4FDJK4RqzkgMOfSn+jLWF
         gAQf/hJStSjUBxEFAx33mcLEPOZS4V9+MgqvXYj+QGrZC3u3pSUGqDJjBmeb1htQNUbi
         b3DCal7z9pk/xsup+Mu7WjEY6ecQJdc9fdeozcOpnc42IHhNg3Eh0P2eDxX7EJOgZydp
         lmzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UJvw3kqO9RHMu+IzeG917wcb7IDDdBROQHd6PdvJoHk=;
        b=UfkE/TVmNc23VFrZfXrxCj6v8RQwXIpenaWt5xXst4V0F/8+UMRZKxnJrJ1kw+hnaO
         5rXDX3Xh944k4NnM1j7Rns4XZQki1L+cPrqrC2MS+23MopLyw4CgMY/E3rbHRX3sPDZJ
         zmt7crHgslbXpw36IEADtU2jlTUxJi0r62dR+h7aQf1k2eggI1of1DA21R899BMug2ut
         Fibb7tTTQqQ4h5ePvoU//9AgBZcP9GM758QyoVgIrb32FnVZTGBmCWqmj6mcje2Be9K6
         WyRboUEP2b+oZW1OjQtIgu53pVb3xlZqS3pzb6A++UJ0MswodiSd0/Rcj5EelxkVy+iR
         U1WQ==
X-Gm-Message-State: AOAM5310HJRDGdYkQwUr5fPMjC80SfFYYWONAW63GuEsTPBNhuywa4+m
	SL/xRzhw0/5U/dUHHe8wTEm1sIunUv38eSMVdFI=
X-Google-Smtp-Source: ABdhPJxW28PKTl0opGRyheMuzOj/4x0DDq5/Vg8+Lo3uUJEc0kNW2uU7E1ZuvmOVeJOFrkydWwHAC08meGvgYaoqAqQ=
X-Received: by 2002:a17:90a:e7cc:: with SMTP id kb12mr21805028pjb.189.1640623789476;
 Mon, 27 Dec 2021 08:49:49 -0800 (PST)
MIME-Version: 1.0
References: <878rwkidtf.fsf@oldenburg.str.redhat.com>
In-Reply-To: <878rwkidtf.fsf@oldenburg.str.redhat.com>
From: Andrei Vagin <avagin@gmail.com>
Date: Mon, 27 Dec 2021 08:49:38 -0800
Message-ID: <CANaxB-xpQr1mUUvWK5a53q49VK_HvR4Pws_NGKGa8-jihxkc_A@mail.gmail.com>
Subject: Re: [PATCH v2] x86: Implement arch_prctl(ARCH_VSYSCALL_CONTROL) to
 disable vsyscall
To: Florian Weimer <fweimer@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>, linux-arch@vger.kernel.org, 
	Linux API <linux-api@vger.kernel.org>, linux-x86_64@vger.kernel.org, 
	kernel-hardening@lists.openwall.com, linux-mm@kvack.org, 
	"the arch/x86 maintainers" <x86@kernel.org>, musl@lists.openwall.com, libc-alpha@sourceware.org, 
	LKML <linux-kernel@vger.kernel.org>, Dave Hansen <dave.hansen@intel.com>, 
	Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, Dec 16, 2021 at 4:00 PM Florian Weimer <fweimer@redhat.com> wrote:
>
> Distributions struggle with changing the default for vsyscall
> emulation because it is a clear break of userspace ABI, something
> that should not happen.
>
> The legacy vsyscall interface is supposed to be used by libcs only,
> not by applications.  This commit adds a new arch_prctl request,
> ARCH_VSYSCALL_CONTROL, with one argument.  If the argument is 0,
> executing vsyscalls will cause the process to terminate.  Argument 1
> turns vsyscall back on (this is mostly for a largely theoretical
> CRIU use case).
>
> Newer libcs can use a zero ARCH_VSYSCALL_CONTROL at startup to disable
> vsyscall for the process.  Legacy libcs do not perform this call, so
> vsyscall remains enabled for them.  This approach should achieves
> backwards compatibility (perfect compatibility if the assumption that
> only libcs use vsyscall is accurate), and it provides full hardening
> for new binaries.
>
> The chosen value of ARCH_VSYSCALL_CONTROL should avoid conflicts
> with other x86-64 arch_prctl requests.  The fact that with
> vsyscall=emulate, reading the vsyscall region is still possible
> even after a zero ARCH_VSYSCALL_CONTROL is considered limitation
> in the current implementation and may change in a future kernel
> version.
>
> Future arch_prctls requests commonly used at process startup can imply
> ARCH_VSYSCALL_CONTROL with a zero argument, so that a separate system
> call for disabling vsyscall is avoided.
>
> Signed-off-by: Florian Weimer <fweimer@redhat.com>

Acked-by: Andrei Vagin <avagin@gmail.com>

pls read inline comments.

>
> ---
> v2: ARCH_VSYSCALL_CONTROL instead of ARCH_VSYSCALL_LOCKOUT.  New tests
>     for the toggle behavior.  Implement hiding [vsyscall] in
>     /proc/PID/maps and test it.  Various other test fixes cleanups
>     (e.g., fixed missing second argument to gettimeofday).
>
>  arch/x86/entry/vsyscall/vsyscall_64.c          |  10 +-
>  arch/x86/include/asm/mmu.h                     |   6 +
>  arch/x86/include/uapi/asm/prctl.h              |   2 +
>  arch/x86/kernel/process_64.c                   |   7 +
>  tools/arch/x86/include/uapi/asm/prctl.h        |   2 +
>  tools/testing/selftests/x86/Makefile           |  13 +-
>  tools/testing/selftests/x86/vsyscall_control.c | 891 +++++++++++++++++++++++++
>  7 files changed, 927 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/entry/vsyscall/vsyscall_64.c b/arch/x86/entry/vsyscall/vsyscall_64.c
> index fd2ee9408e91..8eb3bcf2cedf 100644
> --- a/arch/x86/entry/vsyscall/vsyscall_64.c
> +++ b/arch/x86/entry/vsyscall/vsyscall_64.c
> @@ -174,6 +174,12 @@ bool emulate_vsyscall(unsigned long error_code,
>
>         tsk = current;
>
> +       if (tsk->mm->context.vsyscall_disabled) {
> +               warn_bad_vsyscall(KERN_WARNING, regs,
> +                                 "vsyscall after lockout (exploit attempt?)");

I don't think that we need this warning message. If we disable
vsyscall, its address range is
not differ from other addresses around and has to be handled the same
way. For example,
gVisor or any other sandbox engines may want to emulate vsyscall, but
the kernel log will
be full of such messages.

> +               goto sigsegv;
> +       }
> +
>         /*
>          * Check for access_ok violations and find the syscall nr.
>          *
> @@ -316,8 +322,10 @@ static struct vm_area_struct gate_vma __ro_after_init = {
>
>  struct vm_area_struct *get_gate_vma(struct mm_struct *mm)
>  {
> +       if (!mm || mm->context.vsyscall_disabled)
> +               return NULL;
>  #ifdef CONFIG_COMPAT
> -       if (!mm || !(mm->context.flags & MM_CONTEXT_HAS_VSYSCALL))
> +       if (!(mm->context.flags & MM_CONTEXT_HAS_VSYSCALL))
>                 return NULL;
>  #endif
>         if (vsyscall_mode == NONE)
> diff --git a/arch/x86/include/asm/mmu.h b/arch/x86/include/asm/mmu.h
> index 5d7494631ea9..3934d6907910 100644
> --- a/arch/x86/include/asm/mmu.h
> +++ b/arch/x86/include/asm/mmu.h
> @@ -41,6 +41,12 @@ typedef struct {
>  #ifdef CONFIG_X86_64
>         unsigned short flags;
>  #endif
> +#ifdef CONFIG_X86_VSYSCALL_EMULATION
> +       /*
> +        * Changed by arch_prctl(ARCH_VSYSCALL_CONTROL).
> +        */
> +       bool vsyscall_disabled;
> +#endif
>
>         struct mutex lock;
>         void __user *vdso;                      /* vdso base address */
> diff --git a/arch/x86/include/uapi/asm/prctl.h b/arch/x86/include/uapi/asm/prctl.h
> index 754a07856817..aad0bcfbf49f 100644
> --- a/arch/x86/include/uapi/asm/prctl.h
> +++ b/arch/x86/include/uapi/asm/prctl.h
> @@ -18,4 +18,6 @@
>  #define ARCH_MAP_VDSO_32       0x2002
>  #define ARCH_MAP_VDSO_64       0x2003
>
> +#define ARCH_VSYSCALL_CONTROL  0x5001
> +
>  #endif /* _ASM_X86_PRCTL_H */
> diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
> index 3402edec236c..834bad068211 100644
> --- a/arch/x86/kernel/process_64.c
> +++ b/arch/x86/kernel/process_64.c
> @@ -816,6 +816,13 @@ long do_arch_prctl_64(struct task_struct *task, int option, unsigned long arg2)
>                 ret = put_user(base, (unsigned long __user *)arg2);
>                 break;
>         }
> +#ifdef CONFIG_X86_VSYSCALL_EMULATION
> +       case ARCH_VSYSCALL_CONTROL:
> +               if (unlikely(arg2 > 1))
> +                       return -EINVAL;
> +               current->mm->context.vsyscall_disabled = !arg2;
> +               break;
> +#endif
>
>  #ifdef CONFIG_CHECKPOINT_RESTORE
>  # ifdef CONFIG_X86_X32_ABI
> diff --git a/tools/arch/x86/include/uapi/asm/prctl.h b/tools/arch/x86/include/uapi/asm/prctl.h
> index 754a07856817..aad0bcfbf49f 100644
> --- a/tools/arch/x86/include/uapi/asm/prctl.h
> +++ b/tools/arch/x86/include/uapi/asm/prctl.h
> @@ -18,4 +18,6 @@
>  #define ARCH_MAP_VDSO_32       0x2002
>  #define ARCH_MAP_VDSO_64       0x2003
>
> +#define ARCH_VSYSCALL_CONTROL  0x5001
> +
>  #endif /* _ASM_X86_PRCTL_H */
> diff --git a/tools/testing/selftests/x86/Makefile b/tools/testing/selftests/x86/Makefile
> index 8a1f62ab3c8e..2a7c91ee68e0 100644
> --- a/tools/testing/selftests/x86/Makefile
> +++ b/tools/testing/selftests/x86/Makefile
> @@ -18,7 +18,7 @@ TARGETS_C_32BIT_ONLY := entry_from_vm86 test_syscall_vdso unwind_vdso \
>                         test_FCMOV test_FCOMI test_FISTTP \
>                         vdso_restorer
>  TARGETS_C_64BIT_ONLY := fsgsbase sysret_rip syscall_numbering \
> -                       corrupt_xstate_header amx
> +                       corrupt_xstate_header amx vsyscall_control
>  # Some selftests require 32bit support enabled also on 64bit systems
>  TARGETS_C_32BIT_NEEDED := ldt_gdt ptrace_syscall
>
> @@ -72,10 +72,12 @@ all_64: $(BINARIES_64)
>  EXTRA_CLEAN := $(BINARIES_32) $(BINARIES_64)
>
>  $(BINARIES_32): $(OUTPUT)/%_32: %.c helpers.h
> -       $(CC) -m32 -o $@ $(CFLAGS) $(EXTRA_CFLAGS) $^ -lrt -ldl -lm
> +       $(CC) -m32 -o $@ $(CFLAGS) $(EXTRA_CFLAGS) $^ \
> +               $(or $(LIBS), -lrt -ldl -lm)
>
>  $(BINARIES_64): $(OUTPUT)/%_64: %.c helpers.h
> -       $(CC) -m64 -o $@ $(CFLAGS) $(EXTRA_CFLAGS) $^ -lrt -ldl
> +       $(CC) -m64 -o $@ $(CFLAGS) $(EXTRA_CFLAGS) $^ \
> +               $(or $(LIBS), -lrt -ldl -lm)
>
>  # x86_64 users should be encouraged to install 32-bit libraries
>  ifeq ($(CAN_BUILD_I386)$(CAN_BUILD_X86_64),01)
> @@ -105,3 +107,8 @@ $(OUTPUT)/test_syscall_vdso_32: thunks_32.S
>  # state.
>  $(OUTPUT)/check_initial_reg_state_32: CFLAGS += -Wl,-ereal_start -static
>  $(OUTPUT)/check_initial_reg_state_64: CFLAGS += -Wl,-ereal_start -static
> +
> +# This test does not link against anything (neither libc nor libgcc).
> +$(OUTPUT)/vsyscall_control_64: \
> +       LIBS := -Wl,-no-pie -static -nostdlib -nostartfiles
> +       CFLAGS += -fno-pie -fno-stack-protector -fno-builtin -ffreestanding
> diff --git a/tools/testing/selftests/x86/vsyscall_control.c b/tools/testing/selftests/x86/vsyscall_control.c
> new file mode 100644
> index 000000000000..ee966f936c89
> --- /dev/null
> +++ b/tools/testing/selftests/x86/vsyscall_control.c

I would move the test in a separate patch...

Thanks,
Andrei
