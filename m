Return-Path: <kernel-hardening-return-18986-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 698541FA137
	for <lists+kernel-hardening@lfdr.de>; Mon, 15 Jun 2020 22:17:58 +0200 (CEST)
Received: (qmail 17462 invoked by uid 550); 15 Jun 2020 20:17:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 17439 invoked from network); 15 Jun 2020 20:17:52 -0000
Date: Mon, 15 Jun 2020 16:17:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Oscar Carter <oscar.carter@gmx.com>
Cc: Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@redhat.com>,
 kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel/trace: Remove function callback casts
Message-ID: <20200615161738.18d07ce6@oasis.local.home>
In-Reply-To: <20200614070154.6039-1-oscar.carter@gmx.com>
References: <20200614070154.6039-1-oscar.carter@gmx.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 14 Jun 2020 09:01:54 +0200
Oscar Carter <oscar.carter@gmx.com> wrote:

> In an effort to enable -Wcast-function-type in the top-level Makefile to
> support Control Flow Integrity builds, remove all the function callback
> casts.
> 
> To do this, use the ftrace_ops_list_func function as a wrapper when the
> arch not supports ftrace ops instead of the use of a function cast.
> 

We need more tricker than this.

> Signed-off-by: Oscar Carter <oscar.carter@gmx.com>
> ---
>  kernel/trace/ftrace.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index c163c3531faf..ed1efc0e3a25 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -119,13 +119,12 @@ struct ftrace_ops __rcu *ftrace_ops_list __read_mostly = &ftrace_list_end;
>  ftrace_func_t ftrace_trace_function __read_mostly = ftrace_stub;
>  struct ftrace_ops global_ops;
> 
> -#if ARCH_SUPPORTS_FTRACE_OPS
>  static void ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip,
>  				 struct ftrace_ops *op, struct pt_regs *regs);
> -#else
> +
> +#if !ARCH_SUPPORTS_FTRACE_OPS
>  /* See comment below, where ftrace_ops_list_func is defined */
>  static void ftrace_ops_no_ops(unsigned long ip, unsigned long parent_ip);
> -#define ftrace_ops_list_func ((ftrace_func_t)ftrace_ops_no_ops)

The reason for the typecast is because this gets called from asm with only two parameters.

>  #endif
> 
>  static inline void ftrace_ops_init(struct ftrace_ops *ops)
> @@ -6860,6 +6859,12 @@ static void ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip,
>  }
>  NOKPROBE_SYMBOL(ftrace_ops_list_func);
>  #else
> +static void ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip,
> +				 struct ftrace_ops *op, struct pt_regs *regs)
> +{
> +	ftrace_ops_no_ops(ip, parent_ip);
> +}
> +
>  static void ftrace_ops_no_ops(unsigned long ip, unsigned long parent_ip)
>  {
>  	__ftrace_ops_list_func(ip, parent_ip, NULL, NULL);
> --
> 2.20.1

