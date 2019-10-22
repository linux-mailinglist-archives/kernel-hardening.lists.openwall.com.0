Return-Path: <kernel-hardening-return-17091-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id A5513E09A6
	for <lists+kernel-hardening@lfdr.de>; Tue, 22 Oct 2019 18:50:23 +0200 (CEST)
Received: (qmail 9841 invoked by uid 550); 22 Oct 2019 16:50:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 9820 invoked from network); 22 Oct 2019 16:50:17 -0000
Date: Tue, 22 Oct 2019 17:49:36 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Kees Cook <keescook@chromium.org>
Cc: Sami Tolvanen <samitolvanen@google.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Dave Martin <Dave.Martin@arm.com>,
	Laura Abbott <labbott@redhat.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/18] add support for Clang's Shadow Call Stack (SCS)
Message-ID: <20191022164936.GA1451@lakrids.cambridge.arm.com>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191018161033.261971-7-samitolvanen@google.com>
 <20191022162826.GC699@lakrids.cambridge.arm.com>
 <201910220929.ADF807CC@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201910220929.ADF807CC@keescook>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)

On Tue, Oct 22, 2019 at 09:30:53AM -0700, Kees Cook wrote:
> On Tue, Oct 22, 2019 at 05:28:27PM +0100, Mark Rutland wrote:
> > On Fri, Oct 18, 2019 at 09:10:21AM -0700, Sami Tolvanen wrote:
> > > +ifdef CONFIG_SHADOW_CALL_STACK
> > > +KBUILD_CFLAGS	+= -fsanitize=shadow-call-stack
> > > +DISABLE_SCS	:= -fno-sanitize=shadow-call-stack
> > > +export DISABLE_SCS
> > > +endif
> > 
> > I think it would be preferable to follow the example of CC_FLAGS_FTRACE
> > so that this can be filtered out, e.g.
> > 
> > ifdef CONFIG_SHADOW_CALL_STACK
> > CFLAGS_SCS := -fsanitize=shadow-call-stack
>   ^^^ was this meant to be CC_FLAGS_SCS here
> 
> > KBUILD_CFLAGS += $(CFLAGS_SCS)
>                      ^^^ and here?

Whoops; yes in both cases...

> > export CC_FLAGS_SCS
> > endif
> > 
> > ... with removal being:
> > 
> > CFLAGS_REMOVE := $(CC_FLAGS_SCS)
> > 
> > ... or:
> > 
> > CFLAGS_REMOVE_obj.o := $(CC_FLAGS_SCS)
> > 
> > That way you only need to define the flags once, so the enable and
> > disable falgs remain in sync by construction.
            ^^^^^ "flags" here, too.

Mark.
