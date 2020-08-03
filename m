Return-Path: <kernel-hardening-return-19547-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 198FF23AFB6
	for <lists+kernel-hardening@lfdr.de>; Mon,  3 Aug 2020 23:39:42 +0200 (CEST)
Received: (qmail 31806 invoked by uid 550); 3 Aug 2020 21:39:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 16287 invoked from network); 3 Aug 2020 21:12:52 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1596489160;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oDk7BkLvturoY2j4bZcgcnngVm0+SqYFOos8ttHdu5Y=;
	b=ibtNellM00vePrmGPY8fXUxPZMwzewkpNw7hc4a4gxGynHnFTCrXMQZ6nk9uE9Vc3Gfz4S
	gdDjgyaIiJGV4i8N+vMxZTK8LSkQ3XSGnHM4CRIicvTHHTlGBlgX3XMaZczJXPWry4Htul
	V6ZmYKV4E4uGT+ec0E+EBJuOur1YGf8=
X-MC-Unique: GjiaqvMBOICm3jt1_nLYPw-1
Date: Mon, 3 Aug 2020 17:12:28 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: Joe Lawrence <joe.lawrence@redhat.com>,
	Evgenii Shatokhin <eshatokhin@virtuozzo.com>,
	Kristen Carlson Accardi <kristen@linux.intel.com>,
	Miroslav Benes <mbenes@suse.cz>, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, arjan@linux.intel.com,
	x86@kernel.org, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com, rick.p.edgecombe@intel.com,
	live-patching@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
	Jessica Yu <jeyu@kernel.org>
Subject: Re: [PATCH v4 00/10] Function Granular KASLR
Message-ID: <20200803211228.GC30810@redhat.com>
References: <20200717170008.5949-1-kristen@linux.intel.com>
 <alpine.LSU.2.21.2007221122110.10163@pobox.suse.cz>
 <e9c4d88b-86db-47e9-4299-3fac45a7e3fd@virtuozzo.com>
 <202008031043.FE182E9@keescook>
 <fc6d2289-af97-5cf8-a4bb-77c2b0b8375c@redhat.com>
 <20200803193837.GB30810@redhat.com>
 <202008031310.4F8DAA20@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202008031310.4F8DAA20@keescook>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14

Hi -

On Mon, Aug 03, 2020 at 01:11:27PM -0700, Kees Cook wrote:
> [...]
> > Systemtap needs to know base addresses of loaded text & data sections,
> > in order to perform relocation of probe point PCs and context data
> > addresses.  It uses /sys/module/...., kind of under protest, because
> > there seems to exist no MODULE_EXPORT'd API to get at that information
> > some other way.
> 
> Wouldn't /proc/kallsysms entries cover this? I must be missing
> something...

We have relocated based on sections, not some subset of function
symbols accessible that way, partly because DWARF line- and DIE- based
probes can map to addresses some way away from function symbols, into
function interiors, or cloned/moved bits of optimized code.  It would
take some work to prove that function-symbol based heuristic
arithmetic would have just as much reach.

- FChE

