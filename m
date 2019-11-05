Return-Path: <kernel-hardening-return-17294-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 4B594F073D
	for <lists+kernel-hardening@lfdr.de>; Tue,  5 Nov 2019 21:50:15 +0100 (CET)
Received: (qmail 21628 invoked by uid 550); 5 Nov 2019 20:50:09 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 21606 invoked from network); 5 Nov 2019 20:50:08 -0000
Date: Tue, 5 Nov 2019 09:04:26 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Dave Martin <Dave.Martin@arm.com>,
	Kees Cook <keescook@chromium.org>,
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Jann Horn <jannh@google.com>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	clang-built-linux <clang-built-linux@googlegroups.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 10/17] arm64: disable kretprobes with SCS
Message-ID: <20191105090426.GA4743@lakrids.cambridge.arm.com>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191101221150.116536-1-samitolvanen@google.com>
 <20191101221150.116536-11-samitolvanen@google.com>
 <20191104170454.GA2024@lakrids.cambridge.arm.com>
 <CABCJKue=yZqe23DYg3_WyiSKhxXS+GXe+3skhvYon4ytkfH+XA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABCJKue=yZqe23DYg3_WyiSKhxXS+GXe+3skhvYon4ytkfH+XA@mail.gmail.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)

On Mon, Nov 04, 2019 at 03:42:09PM -0800, Sami Tolvanen wrote:
> On Mon, Nov 4, 2019 at 9:05 AM Mark Rutland <mark.rutland@arm.com> wrote:
> > I'm a bit confused as to why that's the case -- could you please
> > elaborate on how this is incompatible?
> >
> > IIUC kretrobes works by patching the function entry point with a BRK, so
> > that it can modify the LR _before_ it is saved to the stack. I don't see
> > how SCS affects that.
> 
> You're correct. While this may not be optimal for reducing attack
> surface, I just tested this to confirm that there's no functional
> conflict. I'll drop this and related patches from v5.

Great; thanks for confirming!

Mark.
