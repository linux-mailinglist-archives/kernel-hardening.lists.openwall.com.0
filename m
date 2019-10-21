Return-Path: <kernel-hardening-return-17075-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 85DAADE810
	for <lists+kernel-hardening@lfdr.de>; Mon, 21 Oct 2019 11:29:12 +0200 (CEST)
Received: (qmail 23766 invoked by uid 550); 21 Oct 2019 09:29:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 23742 invoked from network); 21 Oct 2019 09:29:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1571650134;
	bh=Ij6S89oTE2ChGvN/UW+DXJfdLK0DsQIGRLCpuPOoRWA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=zWZzDriip6tNCgfYO0M88aJAV5J/LSHelLDvXsN0JxFO1eO3wP1xf9jH9VOPlWeRr
	 l8gfqL/30jne+EhJJPVaCBHdwfmo0Jc+al53Fz46Fn92tge0OM9hWMU0I3I9+Es3ta
	 pEfX+JuiTXYfFUauJoNlctRr1EGfMdnBG4PgNxEc=
Date: Mon, 21 Oct 2019 18:28:49 +0900
From: Masami Hiramatsu <mhiramat@kernel.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ard
 Biesheuvel <ard.biesheuvel@linaro.org>, Dave Martin <Dave.Martin@arm.com>,
 Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, Mark
 Rutland <mark.rutland@arm.com>, Nick Desaulniers <ndesaulniers@google.com>,
 clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/18] add support for Clang's Shadow Call Stack
Message-Id: <20191021182849.d51a67b0c0fe74d8d524147f@kernel.org>
In-Reply-To: <20191018161033.261971-1-samitolvanen@google.com>
References: <20191018161033.261971-1-samitolvanen@google.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi,

On Fri, 18 Oct 2019 09:10:15 -0700
Sami Tolvanen <samitolvanen@google.com> wrote:

> This patch series adds support for Clang's Shadow Call Stack (SCS)
> mitigation, which uses a separately allocated shadow stack to protect
> against return address overwrites. More information can be found here:
> 
>   https://clang.llvm.org/docs/ShadowCallStack.html

Looks interesting, and like what function-graph tracing does...

> 
> SCS is currently supported only on arm64, where the compiler requires
> the x18 register to be reserved for holding the current task's shadow
> stack pointer. Because of this, the series includes four patches from
> Ard to remove x18 usage from assembly code and to reserve the register
> from general allocation.
> 
> With -fsanitize=shadow-call-stack, the compiler injects instructions
> to all non-leaf C functions to store the return address to the shadow
> stack and unconditionally load it again before returning. As a result,
> SCS is incompatible with features that rely on modifying function
> return addresses to alter control flow, such as function graph tracing
> and kretprobes. A copy of the return address is still kept in the
> kernel stack for compatibility with stack unwinding, for example.

Is it possible that kretprobes and function graph tracing modify the
SCS directly instead of changing real stack in that case?

Thank you,

-- 
Masami Hiramatsu <mhiramat@kernel.org>
