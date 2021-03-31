Return-Path: <kernel-hardening-return-21072-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id F388034BC90
	for <lists+kernel-hardening@lfdr.de>; Sun, 28 Mar 2021 16:19:17 +0200 (CEST)
Received: (qmail 24334 invoked by uid 550); 28 Mar 2021 14:19:09 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 24310 invoked from network); 28 Mar 2021 14:19:08 -0000
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1616941137;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8jt5HUbqaBbpJnFpBonfd9d+7RkA3BHSrsmyPxYI6Ow=;
	b=MPtduieEpysU4q9js5b0yPqytBVqj1yGGjDnyAvsGIVcZRlh1fGCuPgfVVgOBFKMBTNevn
	fLl17KJGqS+zzYhMdcfKfoWMZEiIOJ/1IxDriACV0viIjOxWGlZer8SDDiVpAwayddS5Nr
	dKzFubYqsIfVfviXl0oePNENDLeHuSpGRwsjxcNazb1vgd/tTLiqC1L11q9sk3HJj7auzp
	2RFKTUCCknRw1+XvPIFRYtgjlb9HqycmRITXwMVyD29pfWJb/DT40AZ2N0HulmJEyJJdyi
	wHhXCK0OW2CGaOTWyHH5SniDM+3e2+oAlwxo6M7w6ZpvQul1zg54QDaFYymMpw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1616941137;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8jt5HUbqaBbpJnFpBonfd9d+7RkA3BHSrsmyPxYI6Ow=;
	b=HnBEwLsP7QX3vSPeVDkKOWL7X+V2OXCZ1w0icw1CyJUPckQDr18pNfiQHYF3yrMy/hE0TQ
	adt3cwnSbiDqF5Cw==
To: Kees Cook <keescook@chromium.org>
Cc: Kees Cook <keescook@chromium.org>, Elena Reshetova <elena.reshetova@intel.com>, x86@kernel.org, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Alexander Potapenko <glider@google.com>, Alexander Popov <alex.popov@linux.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Jann Horn <jannh@google.com>, Vlastimil Babka <vbabka@suse.cz>, David Hildenbrand <david@redhat.com>, Mike Rapoport <rppt@linux.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>, kernel-hardening@lists.openwall.com, linux-hardening@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 4/6] x86/entry: Enable random_kstack_offset support
In-Reply-To: <20210319212835.3928492-5-keescook@chromium.org>
References: <20210319212835.3928492-1-keescook@chromium.org> <20210319212835.3928492-5-keescook@chromium.org>
Date: Sun, 28 Mar 2021 16:18:56 +0200
Message-ID: <87h7kvcqen.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain

On Fri, Mar 19 2021 at 14:28, Kees Cook wrote:
> +
> +	/*
> +	 * x86_64 stack alignment means 3 bits are ignored, so keep
> +	 * the top 5 bits. x86_32 needs only 2 bits of alignment, so
> +	 * the top 6 bits will be used.
> +	 */
> +	choose_random_kstack_offset(rdtsc() & 0xFF);

Comment mumbles about 5/6 bits and the TSC value is masked with 0xFF and
then the applied offset is itself limited with 0x3FF.

Too many moving parts for someone who does not have the details of all
this memorized.

Thanks,

        tglx

