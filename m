Return-Path: <kernel-hardening-return-18294-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 8BCB8197AA6
	for <lists+kernel-hardening@lfdr.de>; Mon, 30 Mar 2020 13:25:59 +0200 (CEST)
Received: (qmail 32228 invoked by uid 550); 30 Mar 2020 11:25:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 32196 invoked from network); 30 Mar 2020 11:25:54 -0000
Date: Mon, 30 Mar 2020 12:25:36 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Elena Reshetova <elena.reshetova@intel.com>, x86@kernel.org,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Jann Horn <jannh@google.com>,
	"Perla, Enrico" <enrico.perla@intel.com>,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/5] stack: Optionally randomize kernel stack offset
 each syscall
Message-ID: <20200330112536.GD1309@C02TD0UTHF1T.local>
References: <20200324203231.64324-1-keescook@chromium.org>
 <20200324203231.64324-4-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324203231.64324-4-keescook@chromium.org>

On Tue, Mar 24, 2020 at 01:32:29PM -0700, Kees Cook wrote:
> +/*
> + * Do not use this anywhere else in the kernel. This is used here because
> + * it provides an arch-agnostic way to grow the stack with correct
> + * alignment. Also, since this use is being explicitly masked to a max of
> + * 10 bits, stack-clash style attacks are unlikely. For more details see
> + * "VLAs" in Documentation/process/deprecated.rst
> + */
> +void *__builtin_alloca(size_t size);
> +
> +#define add_random_kstack_offset() do {					\
> +	if (static_branch_maybe(CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT,	\
> +				&randomize_kstack_offset)) {		\
> +		u32 offset = this_cpu_read(kstack_offset);		\
> +		char *ptr = __builtin_alloca(offset & 0x3FF);		\
> +		asm volatile("" : "=m"(*ptr));				\

Is this asm() a homebrew OPTIMIZER_HIDE_VAR(*ptr)? If the asm
constraints generate metter code, could we add those as alternative
constraints in OPTIMIZER_HIDE_VAR() ?

Mark.
