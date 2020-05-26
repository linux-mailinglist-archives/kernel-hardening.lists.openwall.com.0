Return-Path: <kernel-hardening-return-18568-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 943BA1B12C8
	for <lists+kernel-hardening@lfdr.de>; Mon, 20 Apr 2020 19:18:09 +0200 (CEST)
Received: (qmail 3936 invoked by uid 550); 20 Apr 2020 17:18:01 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3890 invoked from network); 20 Apr 2020 17:18:00 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587403069;
	bh=wXEAfThnDs14N1G/spAtmfJQE33jZSGAx1cIEKIIuc0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ph/dGiaW6TygCcuAfJaNmpuzQDZkB3Fcj9NIV3BJO6mMxd7giMQgjXFhuJSUDQYFR
	 gZ3RV//pTvooHvX3I1ePN4Q//oI89A9oXCSzfPmLTT3Eh9DIizNl4CnAJKoR6P7BEw
	 Y5eQXMPJpUVmD5phFHnzKLJXCdESnzk7IjbYWxfk=
Date: Mon, 20 Apr 2020 18:17:42 +0100
From: Will Deacon <will@kernel.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Michal Marek <michal.lkml@markovi.net>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dave Martin <Dave.Martin@arm.com>,
	Kees Cook <keescook@chromium.org>,
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Jann Horn <jannh@google.com>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 03/12] scs: add support for stack usage debugging
Message-ID: <20200420171741.GC24386@willie-the-truck>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20200416161245.148813-1-samitolvanen@google.com>
 <20200416161245.148813-4-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200416161245.148813-4-samitolvanen@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Thu, Apr 16, 2020 at 09:12:36AM -0700, Sami Tolvanen wrote:
> Implements CONFIG_DEBUG_STACK_USAGE for shadow stacks. When enabled,
> also prints out the highest shadow stack usage per process.
> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> ---
>  kernel/scs.c | 39 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 39 insertions(+)
> 
> diff --git a/kernel/scs.c b/kernel/scs.c
> index 5245e992c692..ad74d13f2c0f 100644
> --- a/kernel/scs.c
> +++ b/kernel/scs.c
> @@ -184,6 +184,44 @@ int scs_prepare(struct task_struct *tsk, int node)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_DEBUG_STACK_USAGE
> +static inline unsigned long scs_used(struct task_struct *tsk)
> +{
> +	unsigned long *p = __scs_base(tsk);
> +	unsigned long *end = scs_magic(p);
> +	unsigned long s = (unsigned long)p;
> +
> +	while (p < end && READ_ONCE_NOCHECK(*p))
> +		p++;

I think the expectation is that the caller has already checked that the
stack is not corrupted, so I'd probably throw a couple of underscores
in front of the function name, along with a comment.

Also, is tsk ever != current?

> +
> +	return (unsigned long)p - s;
> +}
> +
> +static void scs_check_usage(struct task_struct *tsk)
> +{
> +	static DEFINE_SPINLOCK(lock);
> +	static unsigned long highest;
> +	unsigned long used = scs_used(tsk);
> +
> +	if (used <= highest)
> +		return;
> +
> +	spin_lock(&lock);
> +
> +	if (used > highest) {
> +		pr_info("%s (%d): highest shadow stack usage: %lu bytes\n",
> +			tsk->comm, task_pid_nr(tsk), used);
> +		highest = used;
> +	}
> +
> +	spin_unlock(&lock);

Do you really need this lock? I'd have thought you could cmpxchg()
highest instead.

Will
