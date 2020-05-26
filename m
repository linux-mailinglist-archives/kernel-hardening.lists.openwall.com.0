Return-Path: <kernel-hardening-return-18603-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 4B0511B4BE8
	for <lists+kernel-hardening@lfdr.de>; Wed, 22 Apr 2020 19:40:14 +0200 (CEST)
Received: (qmail 16268 invoked by uid 550); 22 Apr 2020 17:40:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 16245 invoked from network); 22 Apr 2020 17:40:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587577195;
	bh=AGiU7qjKR7ZjubwJ6K3M5/8GasoseXdg8O+47fVqLuw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JyusGuPT4yl7OaJxaidjSDJ0k/CikIy6bBfxMY0e+Pl8R0Jyo0kh0xtn6x5NZmkJc
	 57TrOndBtCukynqsiQxqbtjZ/p4Kv1jhveVyOIXjcX+v2OQKZhsYeb5Uw/OHmxFOIs
	 4BB1KgVHdsNjWZXGTusGX+5UGalpUEJglG0CFtsA=
Date: Wed, 22 Apr 2020 18:39:47 +0100
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
Subject: Re: [PATCH v11 01/12] add support for Clang's Shadow Call Stack (SCS)
Message-ID: <20200422173938.GA3069@willie-the-truck>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20200416161245.148813-1-samitolvanen@google.com>
 <20200416161245.148813-2-samitolvanen@google.com>
 <20200420171727.GB24386@willie-the-truck>
 <20200420211830.GA5081@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200420211830.GA5081@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Apr 20, 2020 at 02:18:30PM -0700, Sami Tolvanen wrote:
> On Mon, Apr 20, 2020 at 06:17:28PM +0100, Will Deacon wrote:
> > > +	 * The shadow call stack is aligned to SCS_SIZE, and grows
> > > +	 * upwards, so we can mask out the low bits to extract the base
> > > +	 * when the task is not running.
> > > +	 */
> > > +	return (void *)((unsigned long)task_scs(tsk) & ~(SCS_SIZE - 1));
> > 
> > Could we avoid forcing this alignment it we stored the SCS pointer as a
> > (base,offset) pair instead? That might be friendlier on the allocations
> > later on.
> 
> The idea is to avoid storing the current task's shadow stack address in
> memory, which is why I would rather not store the base address either.

What I mean is that, instead of storing the current shadow stack pointer,
we instead store a base and an offset. We can still clear the base, as you
do with the pointer today, and I don't see that the offset is useful to
an attacker on its own.

But more generally, is it really worthwhile to do this clearing at all? Can
you (or Kees?) provide some justification for it, please? We don't do it
for anything else, e.g. the pointer authentication keys, so something
feels amiss here.

Thanks,

Will
