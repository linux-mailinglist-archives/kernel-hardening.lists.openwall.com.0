Return-Path: <kernel-hardening-return-20063-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id E01D127DD45
	for <lists+kernel-hardening@lfdr.de>; Wed, 30 Sep 2020 02:13:19 +0200 (CEST)
Received: (qmail 1318 invoked by uid 550); 30 Sep 2020 00:13:14 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1284 invoked from network); 30 Sep 2020 00:13:13 -0000
Date: Tue, 29 Sep 2020 20:12:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, Kees
 Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>,
 clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com,
 linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-pci@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v4 06/29] tracing: move function tracer options to
 Kconfig
Message-ID: <20200929201257.1570aadd@oasis.local.home>
In-Reply-To: <20200929214631.3516445-7-samitolvanen@google.com>
References: <20200929214631.3516445-1-samitolvanen@google.com>
	<20200929214631.3516445-7-samitolvanen@google.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 29 Sep 2020 14:46:08 -0700
Sami Tolvanen <samitolvanen@google.com> wrote:

> +++ b/kernel/trace/Kconfig
> @@ -595,6 +595,22 @@ config FTRACE_MCOUNT_RECORD
>  	depends on DYNAMIC_FTRACE
>  	depends on HAVE_FTRACE_MCOUNT_RECORD
>  
> +config FTRACE_MCOUNT_USE_PATCHABLE_FUNCTION_ENTRY
> +	bool
> +	depends on FTRACE_MCOUNT_RECORD
> +
> +config FTRACE_MCOUNT_USE_CC
> +	def_bool y
> +	depends on $(cc-option,-mrecord-mcount)

Does the above get executed at every build? Or does a make *config need
to be done? If someone were to pass a .config to someone else that had
a compiler that didn't support this, would it be changed if the person
just did a make?

-- Steve


> +	depends on !FTRACE_MCOUNT_USE_PATCHABLE_FUNCTION_ENTRY
> +	depends on FTRACE_MCOUNT_RECORD
> +
> +config FTRACE_MCOUNT_USE_RECORDMCOUNT
> +	def_bool y
> +	depends on !FTRACE_MCOUNT_USE_PATCHABLE_FUNCTION_ENTRY
> +	depends on !FTRACE_MCOUNT_USE_CC
> +	depends on FTRACE_MCOUNT_RECORD
> +
>  config TRACING_MAP
>  	bool
>  	depends on ARCH_HAVE_NMI_SAFE_CMPXCHG
