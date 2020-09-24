Return-Path: <kernel-hardening-return-19997-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 101032771C8
	for <lists+kernel-hardening@lfdr.de>; Thu, 24 Sep 2020 15:06:27 +0200 (CEST)
Received: (qmail 27868 invoked by uid 550); 24 Sep 2020 13:06:19 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 27841 invoked from network); 24 Sep 2020 13:06:19 -0000
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Date: Thu, 24 Sep 2020 15:06:06 +0200 (CEST)
From: Miroslav Benes <mbenes@suse.cz>
To: Kristen Carlson Accardi <kristen@linux.intel.com>
cc: keescook@chromium.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
    Josh Poimboeuf <jpoimboe@redhat.com>, Jiri Kosina <jikos@kernel.org>, 
    Petr Mladek <pmladek@suse.com>, Joe Lawrence <joe.lawrence@redhat.com>, 
    arjan@linux.intel.com, x86@kernel.org, linux-kernel@vger.kernel.org, 
    kernel-hardening@lists.openwall.com, rick.p.edgecombe@intel.com, 
    live-patching@vger.kernel.org
Subject: Re: [PATCH v5 10/10] livepatch: only match unique symbols when using
 fgkaslr
In-Reply-To: <20200923173905.11219-11-kristen@linux.intel.com>
Message-ID: <alpine.LSU.2.21.2009241453400.6602@pobox.suse.cz>
References: <20200923173905.11219-1-kristen@linux.intel.com> <20200923173905.11219-11-kristen@linux.intel.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

Hi,

On Wed, 23 Sep 2020, Kristen Carlson Accardi wrote:

> If any type of function granular randomization is enabled, the sympos
> algorithm will fail, as it will be impossible to resolve symbols when
> there are duplicates using the previous symbol position.
> 
> Override the value of sympos to always be zero if fgkaslr is enabled for
> either the core kernel or modules, forcing the algorithm
> to require that only unique symbols are allowed to be patched.
> 
> Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
> ---
>  kernel/livepatch/core.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index f76fdb925532..da08e40f2da2 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -170,6 +170,17 @@ static int klp_find_object_symbol(const char *objname, const char *name,
>  		kallsyms_on_each_symbol(klp_find_callback, &args);
>  	mutex_unlock(&module_mutex);
>  
> +	/*
> +	 * If any type of function granular randomization is enabled, it
> +	 * will be impossible to resolve symbols when there are duplicates
> +	 * using the previous symbol position (i.e. sympos != 0). Override
> +	 * the value of sympos to always be zero in this case. This will
> +	 * force the algorithm to require that only unique symbols are
> +	 * allowed to be patched.
> +	 */
> +	if (IS_ENABLED(CONFIG_FG_KASLR) || IS_ENABLED(CONFIG_MODULE_FG_KASLR))
> +		sympos = 0;

This should work, but I wonder if we should make it more explicit. With 
the change the user will get the error with "unresolvable ambiguity for 
symbol..." if they specify sympos and the symbol is not unique. It could 
confuse them.

So, how about it making it something like

if (IS_ENABLED(CONFIG_FG_KASLR) || IS_ENABLED(CONFIG_MODULE_FG_KASLR))
	if (sympos) {
		pr_err("fgkaslr is enabled, specifying sympos for symbol '%s' in object '%s' does not work.\n",
			name, objname);
		*addr = 0;
		return -EINVAL;
	}

? (there could be goto to the error out at the end of the function).

In that case, if sympos is not specified, the user will get the message 
which matches the reality. If the user specifies it, they will get the 
error in case of fgkaslr.

Thanks for dealing with it
Miroslav
