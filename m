Return-Path: <kernel-hardening-return-20506-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id B178A2CAF17
	for <lists+kernel-hardening@lfdr.de>; Tue,  1 Dec 2020 22:47:30 +0100 (CET)
Received: (qmail 12030 invoked by uid 550); 1 Dec 2020 21:47:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 12008 invoked from network); 1 Dec 2020 21:47:23 -0000
Date: Tue, 1 Dec 2020 16:47:08 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>,
 Josh Poimboeuf <jpoimboe@redhat.com>, Peter Zijlstra
 <peterz@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Paul E. McKenney" <paulmck@kernel.org>, Kees Cook <keescook@chromium.org>,
 Nick Desaulniers <ndesaulniers@google.com>,
 clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com,
 linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-pci@vger.kernel.org
Subject: Re: [PATCH v8 01/16] tracing: move function tracer options to
 Kconfig
Message-ID: <20201201164708.19066850@gandalf.local.home>
In-Reply-To: <20201201213707.541432-2-samitolvanen@google.com>
References: <20201201213707.541432-1-samitolvanen@google.com>
	<20201201213707.541432-2-samitolvanen@google.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue,  1 Dec 2020 13:36:52 -0800
Sami Tolvanen <samitolvanen@google.com> wrote:

> Move function tracer options to Kconfig to make it easier to add
> new methods for generating __mcount_loc, and to make the options
> available also when building kernel modules.
> 
> Note that FTRACE_MCOUNT_USE_* options are updated on rebuild and
> therefore, work even if the .config was generated in a different
> environment.

Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> ---


-- Steve
