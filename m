Return-Path: <kernel-hardening-return-18215-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 9F710191C81
	for <lists+kernel-hardening@lfdr.de>; Tue, 24 Mar 2020 23:07:12 +0100 (CET)
Received: (qmail 18028 invoked by uid 550); 24 Mar 2020 22:07:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 17996 invoked from network); 24 Mar 2020 22:07:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=RgOSv5leUzdh9drlvUWI/yMDTMMdqFPXz0ZLHcJ9Qrk=; b=aAS4Q+6sODIaHbIvnMNlQ5KsSS
	WQ6pOZIKF1v1HbpnjpTp0sEEqKotsv7YAX/6keV3jCJi4monNTYQgMJDjQc6zZgSJyWEoAJJxrCn6
	2Wtau+W4MCGQhoG1DYaVOae5ieyPMQantZoA70LPpgA2d92YcmM9Opq94LM+64idGuHIarHnOa+fJ
	8g/FtxwMBiYi5ljyGa6nG/AzrKDh3BPJpxrV/7Nn030GCm7jOEH3LpTrxhyQH2Gl6SJDFbCgh7/Yu
	EHVYqlnS6JEoOjv8O8HKtL1Xt5PUyZ3W+zgHvzKrF2zatGASlP9ApCKZ12nWFczNHgWiHpAVILumF
	lFViESkw==;
Date: Tue, 24 Mar 2020 23:06:41 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Elena Reshetova <elena.reshetova@intel.com>, x86@kernel.org,
	Andy Lutomirski <luto@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Alexander Potapenko <glider@google.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Jann Horn <jannh@google.com>,
	"Perla, Enrico" <enrico.perla@intel.com>,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/5] jump_label: Provide CONFIG-driven build state
 defaults
Message-ID: <20200324220641.GT2452@worktop.programming.kicks-ass.net>
References: <20200324203231.64324-1-keescook@chromium.org>
 <20200324203231.64324-2-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324203231.64324-2-keescook@chromium.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Mar 24, 2020 at 01:32:27PM -0700, Kees Cook wrote:
> Choosing the initial state of static branches changes the assembly
> layout (if the condition is expected to be likely, inline, or unlikely,
> out of line via a jump). A few places in the kernel use (or could be
> using) a CONFIG to choose the default state, so provide the
> infrastructure to do this and convert the existing cases (init_on_alloc
> and init_on_free) to the new macros.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Cute,

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
