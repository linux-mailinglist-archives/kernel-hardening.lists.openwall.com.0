Return-Path: <kernel-hardening-return-18569-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id E08DA1B12CC
	for <lists+kernel-hardening@lfdr.de>; Mon, 20 Apr 2020 19:18:20 +0200 (CEST)
Received: (qmail 5851 invoked by uid 550); 20 Apr 2020 17:18:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 5821 invoked from network); 20 Apr 2020 17:18:13 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587403081;
	bh=8Cti+W7qcMTc3i7ivCfS06mEpTJP5zYv2iWrbD/RTtg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=n8kgySIFfBQIcj6Ia2jB/kXabMFi8z3ZnfxRD6sXtUSU5WkP7GyhdFFnNX9oGyhnV
	 mhWjwdOQ+04RDru0OIhK+bLIVHdU0fkAMOot1o2sNYiPhmoqv95P7YoCTgT0+QheZR
	 P5uQTK0OZzAOJTiqi4PCUeQwAx7St1L9HyeIHsPI=
Date: Mon, 20 Apr 2020 18:17:55 +0100
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
Subject: Re: [PATCH v11 02/12] scs: add accounting
Message-ID: <20200420171753.GD24386@willie-the-truck>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20200416161245.148813-1-samitolvanen@google.com>
 <20200416161245.148813-3-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200416161245.148813-3-samitolvanen@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Thu, Apr 16, 2020 at 09:12:35AM -0700, Sami Tolvanen wrote:
> This change adds accounting for the memory allocated for shadow stacks.
> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/base/node.c    |  6 ++++++
>  fs/proc/meminfo.c      |  4 ++++
>  include/linux/mmzone.h |  3 +++
>  kernel/scs.c           | 20 ++++++++++++++++++++
>  mm/page_alloc.c        |  6 ++++++
>  mm/vmstat.c            |  3 +++
>  6 files changed, 42 insertions(+)
> 
> diff --git a/drivers/base/node.c b/drivers/base/node.c
> index 10d7e818e118..502ab5447c8d 100644
> --- a/drivers/base/node.c
> +++ b/drivers/base/node.c
> @@ -415,6 +415,9 @@ static ssize_t node_read_meminfo(struct device *dev,
>  		       "Node %d AnonPages:      %8lu kB\n"
>  		       "Node %d Shmem:          %8lu kB\n"
>  		       "Node %d KernelStack:    %8lu kB\n"
> +#ifdef CONFIG_SHADOW_CALL_STACK
> +		       "Node %d ShadowCallStack:%8lu kB\n"
> +#endif
>  		       "Node %d PageTables:     %8lu kB\n"
>  		       "Node %d NFS_Unstable:   %8lu kB\n"
>  		       "Node %d Bounce:         %8lu kB\n"
> @@ -438,6 +441,9 @@ static ssize_t node_read_meminfo(struct device *dev,
>  		       nid, K(node_page_state(pgdat, NR_ANON_MAPPED)),
>  		       nid, K(i.sharedram),
>  		       nid, sum_zone_node_page_state(nid, NR_KERNEL_STACK_KB),
> +#ifdef CONFIG_SHADOW_CALL_STACK
> +		       nid, sum_zone_node_page_state(nid, NR_KERNEL_SCS_BYTES) / 1024,
> +#endif

Why not just use KB everywhere instead of repeated division by 1024?

Will
