Return-Path: <kernel-hardening-return-17512-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 3B1BB128055
	for <lists+kernel-hardening@lfdr.de>; Fri, 20 Dec 2019 17:06:07 +0100 (CET)
Received: (qmail 25605 invoked by uid 550); 20 Dec 2019 16:05:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 24561 invoked from network); 20 Dec 2019 16:05:59 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1576857943;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=now08Y2oy2o19viSQFHKiMgrD230zjDgXyIOJ6tB9lw=;
	b=aIAAJvaOIogB7Lgjqg2MezcBRvwlqF6cISkSvtB/ChZDrZxGPYjAW18gir/RG7bTjJtjmT
	yDVKFPqZketJP8JXsAAQ2DQ+6uZYAc96tT2zcXzbwGYDc69Z0WMF5l2i1jMnemz8hpJz2l
	x+gnkf7QxFwPCjduL1KkzpUrfuP1NNE=
Date: Fri, 20 Dec 2019 17:05:37 +0100
From: Borislav Petkov <bp@alien8.de>
To: Thomas Garnier <thgarnie@chromium.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Kristen Carlson Accardi <kristen@linux.intel.com>,
	Kees Cook <keescook@chromium.org>,
	Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	the arch/x86 maintainers <x86@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v10 04/11] x86/entry/64: Adapt assembly for PIE support
Message-ID: <20191220160537.GE1397@zn.tnic>
References: <20191205000957.112719-1-thgarnie@chromium.org>
 <20191205000957.112719-5-thgarnie@chromium.org>
 <20191205090355.GC2810@hirez.programming.kicks-ass.net>
 <CAJcbSZF+vGE6ZseiQfcis2NMcimmpwvov_P-tZe--z5UxJPDdg@mail.gmail.com>
 <20191206102649.GC2844@hirez.programming.kicks-ass.net>
 <CAJcbSZHLcSN4BK=N7M3Kv9q-hkPe6dDxbHaRCG9v2JVwhSZxfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAJcbSZHLcSN4BK=N7M3Kv9q-hkPe6dDxbHaRCG9v2JVwhSZxfw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Fri, Dec 06, 2019 at 08:35:09AM -0800, Thomas Garnier wrote:
> > Yes, but there it made sense since the PUSH actually created that field
> > of the frame, here it is nonsensical. What this instruction does is put
> > the address of the '1f' label into RDX, which is then stuck into the
> > (R)IP field on the next instruction.
> 
> Got it, make sense. Thanks.
> 
> >
> > > > > +     movq    %rdx, 8(%rsp)   /* Put 1f on return address */

And pls write it out as "put the address of the '1f' label into RDX"
instead of "Put 1f on return address" which could be misunderstood.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
