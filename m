Return-Path: <kernel-hardening-return-20216-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 922D428F9ED
	for <lists+kernel-hardening@lfdr.de>; Thu, 15 Oct 2020 22:10:31 +0200 (CEST)
Received: (qmail 30095 invoked by uid 550); 15 Oct 2020 20:10:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 30075 invoked from network); 15 Oct 2020 20:10:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1602792612;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JSZZdQFYiEF1TvfexFPRAVhe3w/8OtEerqz5dRK9QXg=;
	b=G9tprhOhLz+FW9hcDM7U7QTDR/I2CXNVeBo8JDFgwLrto4E6Hrsa8/hrEgidOSFEjEGh1X
	JvXRoEapTPS8Xrsnxm+ZHLMcHyVqLJIFUf80eKx2MIMmAmKIw6e0NsKh43oYG/7Z74nTtu
	hhDpL65MEg+lMRvvjuhzY62fmN/R31I=
X-MC-Unique: te9p4b8XOfue84xzeHLT6w-1
Date: Thu, 15 Oct 2020 15:10:00 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Sami Tolvanen <samitolvanen@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	x86@kernel.org
Subject: Re: [PATCH v6 02/25] objtool: Add a pass for generating __mcount_loc
Message-ID: <20201015201000.poiepgn5fssnogtf@treble>
References: <20201013003203.4168817-1-samitolvanen@google.com>
 <20201013003203.4168817-3-samitolvanen@google.com>
 <20201014165004.GA3593121@gmail.com>
 <20201014182115.GF2594@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201014182115.GF2594@hirez.programming.kicks-ass.net>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16

On Wed, Oct 14, 2020 at 08:21:15PM +0200, Peter Zijlstra wrote:
> On Wed, Oct 14, 2020 at 06:50:04PM +0200, Ingo Molnar wrote:
> > Meh, adding --mcount as an option to 'objtool check' was a valid hack for a 
> > prototype patchset, but please turn this into a proper subcommand, just 
> > like 'objtool orc' is.
> > 
> > 'objtool check' should ... keep checking. :-)
> 
> No, no subcommands. orc being a subcommand was a mistake.

Yup, it gets real awkward when trying to combine subcommands.

I proposed a more logical design:

  https://lkml.kernel.org/r/20201002141303.hyl72to37wudoi66@treble

-- 
Josh

