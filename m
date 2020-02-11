Return-Path: <kernel-hardening-return-17776-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 29924159106
	for <lists+kernel-hardening@lfdr.de>; Tue, 11 Feb 2020 14:57:46 +0100 (CET)
Received: (qmail 7301 invoked by uid 550); 11 Feb 2020 13:57:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 7281 invoked from network); 11 Feb 2020 13:57:39 -0000
Subject: Re: [PATCH v7 00/11] add support for Clang's Shadow Call Stack
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
 Mark Rutland <mark.rutland@arm.com>, Dave Martin <Dave.Martin@arm.com>,
 Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>,
 Marc Zyngier <maz@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>,
 Jann Horn <jannh@google.com>, Miguel Ojeda
 <miguel.ojeda.sandonis@gmail.com>,
 Masahiro Yamada <yamada.masahiro@socionext.com>,
 clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20200128184934.77625-1-samitolvanen@google.com>
From: James Morse <james.morse@arm.com>
Message-ID: <63517cff-4bd6-bb6c-9a54-23de4f5fbb4a@arm.com>
Date: Tue, 11 Feb 2020 13:57:24 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200128184934.77625-1-samitolvanen@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit

Hi Sami,

On 28/01/2020 18:49, Sami Tolvanen wrote:
> This patch series adds support for Clang's Shadow Call Stack
> (SCS) mitigation, which uses a separately allocated shadow stack
> to protect against return address overwrites. More information
> can be found here:
> 
>   https://clang.llvm.org/docs/ShadowCallStack.html
> 
> SCS provides better protection against traditional buffer
> overflows than CONFIG_STACKPROTECTOR_*, but it should be noted
> that SCS security guarantees in the kernel differ from the ones
> documented for user space. The kernel must store addresses of
> shadow stacks used by inactive tasks and interrupt handlers in
> memory, which means an attacker capable reading and writing
> arbitrary memory may be able to locate them and hijack control
> flow by modifying shadow stacks that are not currently in use.
> 
> SCS is currently supported only on arm64, where the compiler
> requires the x18 register to be reserved for holding the current
> task's shadow stack pointer.

I found I had to add:
| KBUILD_CFLAGS := $(filter-out -ffixed-x18 $(CC_FLAGS_SCS), $(KBUILD_CFLAGS))

to drivers/firmware/efi/libstub/Makefile, to get this going.
I don't think there is much point supporting SCS for the EFIstub, its already isolated
from the rest of the kernel's C code by the __efistub symbol prefix machinery, and trying
to use it would expose us to buggy firmware at a point we can't handle it!

I can send a patch if its easier for you,


Thanks,

James
