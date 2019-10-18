Return-Path: <kernel-hardening-return-17049-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id EC9C6DCD14
	for <lists+kernel-hardening@lfdr.de>; Fri, 18 Oct 2019 19:54:31 +0200 (CEST)
Received: (qmail 9824 invoked by uid 550); 18 Oct 2019 17:54:20 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 20300 invoked from network); 18 Oct 2019 17:04:43 -0000
Date: Fri, 18 Oct 2019 13:04:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Dave
 Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, Laura
 Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Nick
 Desaulniers <ndesaulniers@google.com>, clang-built-linux@googlegroups.com,
 kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>
Subject: Re: [PATCH 11/18] kprobes: disable kretprobes with SCS
Message-ID: <20191018130429.5df61f6b@gandalf.local.home>
In-Reply-To: <20191018161033.261971-12-samitolvanen@google.com>
References: <20191018161033.261971-1-samitolvanen@google.com>
	<20191018161033.261971-12-samitolvanen@google.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


[ Added Masami ]

On Fri, 18 Oct 2019 09:10:26 -0700
Sami Tolvanen <samitolvanen@google.com> wrote:

> With CONFIG_KRETPROBES, function return addresses are modified to
> redirect control flow to kretprobe_trampoline. This is incompatible with
> return address protection.
> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> ---
>  arch/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/Kconfig b/arch/Kconfig
> index a222adda8130..4646e3b34925 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -171,7 +171,7 @@ config ARCH_USE_BUILTIN_BSWAP
>  
>  config KRETPROBES
>  	def_bool y
> -	depends on KPROBES && HAVE_KRETPROBES
> +	depends on KPROBES && HAVE_KRETPROBES && ROP_PROTECTION_NONE

Again, this belongs in the arch code.

-- Steve

>  
>  config USER_RETURN_NOTIFIER
>  	bool


diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 41a9b4257b72..65557d7e6b5e 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -166,7 +166,7 @@ config ARM64
 	select HAVE_STACKPROTECTOR
 	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_KPROBES
-	select HAVE_KRETPROBES
+	select HAVE_KRETPROBES if ROP_PROTECTION_NONE
 	select HAVE_GENERIC_VDSO
 	select IOMMU_DMA if IOMMU_SUPPORT
 	select IRQ_DOMAIN
