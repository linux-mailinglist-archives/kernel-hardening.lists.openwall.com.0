Return-Path: <kernel-hardening-return-18606-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 0C7AB1B4C25
	for <lists+kernel-hardening@lfdr.de>; Wed, 22 Apr 2020 19:51:23 +0200 (CEST)
Received: (qmail 30632 invoked by uid 550); 22 Apr 2020 17:51:17 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 30604 invoked from network); 22 Apr 2020 17:51:16 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZF6h4B8lRkEW+PGdoi5ViWh9NdqvBm+plj3edg+BLxs=;
        b=SbiBDMBjNOJtZvz674h6CaZCEGdmafbK0qSIOSSMTCWnqd5jMXbDXqcct8K8mtTChe
         4BmBYx34rurFf5imZkH6NB9jvIu0M0140rWbXixJsCfD/+8yfkJPCm/IHIsm3ZoRWfwb
         VIyeJQzY1bEBF+t0X5Jqa/2kR8k/V4WASdOqg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZF6h4B8lRkEW+PGdoi5ViWh9NdqvBm+plj3edg+BLxs=;
        b=B6CZ/FxoHBBnKTORE7Pdxlx+gYZBMEMfTLbwpLGPaBcVhIqoKFhSq5Avd/zymU/xjs
         SWbUmDjaJ2Mgsmqh92Go/i3hgRPCwUpdfqQpb213VPyQ23J7zd+KHmLaX4nhHylYPuQP
         RrCuxCF54WkgOqbQgQavj58QuQxpljrS60w5nlVHLeZ1unkvzASlxt2Eg54hw2/rQir8
         TpsrOi4I+WX9PPVcz3wReECorZrJcM7bH9rftTZRCDq4SryMcavIoUTB3eMk4leD/Im7
         96TkSDvQ6Tv9OFCOzEDBXyLpmHlvI8zoark+6hGTdngNJgpYJAFPzDvaZfSYBSzBpl5b
         kTWA==
X-Gm-Message-State: AGi0PubnqBBNpgR2LWRYFh2SyAVwaazfIik/O4j8KQQH2zS1H8Lmf/+S
	yn5r+uesNnhp2qXcWqqkCgkNIA==
X-Google-Smtp-Source: APiQypKgukJRS2MpdwcmV4gR8X/qlLkQhVOoNqLyqZFCT1UTaoEDKt7OxFkygmvQ9SLxUbFYDjP/kg==
X-Received: by 2002:a63:9e54:: with SMTP id r20mr141098pgo.301.1587577864965;
        Wed, 22 Apr 2020 10:51:04 -0700 (PDT)
Date: Wed, 22 Apr 2020 10:51:02 -0700
From: Kees Cook <keescook@chromium.org>
To: Will Deacon <will@kernel.org>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
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
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Jann Horn <jannh@google.com>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 01/12] add support for Clang's Shadow Call Stack (SCS)
Message-ID: <202004221047.3AEAECC1@keescook>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20200416161245.148813-1-samitolvanen@google.com>
 <20200416161245.148813-2-samitolvanen@google.com>
 <20200420171727.GB24386@willie-the-truck>
 <20200420211830.GA5081@google.com>
 <20200422173938.GA3069@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422173938.GA3069@willie-the-truck>

On Wed, Apr 22, 2020 at 06:39:47PM +0100, Will Deacon wrote:
> On Mon, Apr 20, 2020 at 02:18:30PM -0700, Sami Tolvanen wrote:
> > On Mon, Apr 20, 2020 at 06:17:28PM +0100, Will Deacon wrote:
> > > > +	 * The shadow call stack is aligned to SCS_SIZE, and grows
> > > > +	 * upwards, so we can mask out the low bits to extract the base
> > > > +	 * when the task is not running.
> > > > +	 */
> > > > +	return (void *)((unsigned long)task_scs(tsk) & ~(SCS_SIZE - 1));
> > > 
> > > Could we avoid forcing this alignment it we stored the SCS pointer as a
> > > (base,offset) pair instead? That might be friendlier on the allocations
> > > later on.
> > 
> > The idea is to avoid storing the current task's shadow stack address in
> > memory, which is why I would rather not store the base address either.
> 
> What I mean is that, instead of storing the current shadow stack pointer,
> we instead store a base and an offset. We can still clear the base, as you
> do with the pointer today, and I don't see that the offset is useful to
> an attacker on its own.
> 
> But more generally, is it really worthwhile to do this clearing at all? Can
> you (or Kees?) provide some justification for it, please? We don't do it
> for anything else, e.g. the pointer authentication keys, so something
> feels amiss here.

It's a hardening step to just reduce the lifetime of a valid address
exposed in memory. In fact, since there is a cache, I think it should be
wiped even in scs_release().

-- 
Kees Cook
