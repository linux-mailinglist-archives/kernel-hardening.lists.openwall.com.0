Return-Path: <kernel-hardening-return-16725-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 9009D83568
	for <lists+kernel-hardening@lfdr.de>; Tue,  6 Aug 2019 17:35:53 +0200 (CEST)
Received: (qmail 29970 invoked by uid 550); 6 Aug 2019 15:35:47 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 29944 invoked from network); 6 Aug 2019 15:35:46 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1565105735;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=97K8pZ7S8v0HHICvQPuZRuC2rxMxs5QigvHbJw+cxYE=;
	b=BJcQZHKO3xWhrfbjqKM3DL1VP0CePTCbJZQ/vJlQfP01WRLt6dZNtkiQwxTtpb8t/BtsKf
	XgDrjO0vcmTkHcoszzEt1+W+Hxeffv1senq6tyLTVtacGzaBElvDFCqvSj9OBdKF8fJVro
	kycmyh2qzfKVp3Z3sfTt0LpS2nL/Iug=
Date: Tue, 6 Aug 2019 17:35:30 +0200
From: Borislav Petkov <bp@alien8.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Garnier <thgarnie@chromium.org>,
	kernel-hardening@lists.openwall.com, kristen@linux.intel.com,
	keescook@chromium.org, Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 04/11] x86/entry/64: Adapt assembly for PIE support
Message-ID: <20190806153530.GC25897@zn.tnic>
References: <20190730191303.206365-1-thgarnie@chromium.org>
 <20190730191303.206365-5-thgarnie@chromium.org>
 <20190805172854.GF18785@zn.tnic>
 <20190806135942.xnuovr4vbanbxneb@home.goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190806135942.xnuovr4vbanbxneb@home.goodmis.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Aug 06, 2019 at 09:59:42AM -0400, Steven Rostedt wrote:
> As Peter stated later in this thread, we only have the IRQ stack frame saved
> here, because we just took an NMI, and this is the logic to determine if it
> was a nested NMI or not (where we have to be *very* careful about touching the
> stack!)
> 
> That said, the code modified here is to test the NMI nesting logic (only
> enabled with CONFIG_DEBUG_ENTRY), and what it is doing is re-enabling NMIs
> before calling the first NMI handler, to help trigger nested NMIs without the
> need of a break point or page fault (iret enables NMIs again).
> 
> This code is in the path of the "first nmi" (we confirmed that this is not
> nested), which means that it should be safe to push onto the stack.

Thanks for the explanation!

> Yes, we need to save and restore whatever reg we used. The only comment I
> would make is to use %rdx instead of %rax as that has been our "scratch"
> register used before saving pt_regs. Just to be consistent.

Yap, makes sense.

Thx.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
