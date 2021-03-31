Return-Path: <kernel-hardening-return-21095-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id C52F034FABA
	for <lists+kernel-hardening@lfdr.de>; Wed, 31 Mar 2021 09:50:39 +0200 (CEST)
Received: (qmail 22424 invoked by uid 550); 31 Mar 2021 07:50:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 22396 invoked from network); 31 Mar 2021 07:50:32 -0000
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1617177020;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RZw6jkxG2tvSevv3X2+abnTHnXCHkwF4cE7lD/cYS0c=;
	b=jUZ1Puxo9W22AXzcFYFJ62E72Axd/SK2ZV8cEve6PHL2b0LfRU4wESftLlahc7fWxip4AM
	BBRqghhiGBRl7jKDiWl61U/Kd8GE0BO2yzFsmrzPH5KFvgHJ3Bxb6nEqyxkwbVsMNDyC4p
	71QTjwCX7E4m3wMy0qF1RkjLiPTthV91YEW3gFxDvP8NNM6uZ42CyhB6MesNOu0wQuu1qy
	XPq1pF/txTA47YN+pLN3i8C8eweRc2FE3U7tq1qThEBzCMhpE9NNDxzGE0AubaVIh4W3sH
	UgvB+tZgA6eTvr+vAKcvVXMVUOfPorneRFlwQ+GN0M68PY7bXY2FOr1ztCMdWA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1617177020;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RZw6jkxG2tvSevv3X2+abnTHnXCHkwF4cE7lD/cYS0c=;
	b=MN+pzWVv1yf6pCY2oCNeGdwPONSSKq5G0kTaSCVNpA6ZRX43kxrMo6DqtDgPG5dGcxWZs+
	+KgsgvXLPSPQFzCg==
To: Kees Cook <keescook@chromium.org>
Cc: Kees Cook <keescook@chromium.org>, Elena Reshetova <elena.reshetova@intel.com>, x86@kernel.org, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Alexander Potapenko <glider@google.com>, Alexander Popov <alex.popov@linux.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Jann Horn <jannh@google.com>, Vlastimil Babka <vbabka@suse.cz>, David Hildenbrand <david@redhat.com>, Mike Rapoport <rppt@linux.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>, kernel-hardening@lists.openwall.com, linux-hardening@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 4/6] x86/entry: Enable random_kstack_offset support
In-Reply-To: <20210330205750.428816-5-keescook@chromium.org>
References: <20210330205750.428816-1-keescook@chromium.org> <20210330205750.428816-5-keescook@chromium.org>
Date: Wed, 31 Mar 2021 09:50:20 +0200
Message-ID: <87lfa369tv.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain

On Tue, Mar 30 2021 at 13:57, Kees Cook wrote:

> Allow for a randomized stack offset on a per-syscall basis, with roughly
> 5-6 bits of entropy, depending on compiler and word size. Since the
> method of offsetting uses macros, this cannot live in the common entry
> code (the stack offset needs to be retained for the life of the syscall,
> which means it needs to happen at the actual entry point).
>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
