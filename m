Return-Path: <kernel-hardening-return-17041-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 2BE48DCC10
	for <lists+kernel-hardening@lfdr.de>; Fri, 18 Oct 2019 18:58:35 +0200 (CEST)
Received: (qmail 17873 invoked by uid 550); 18 Oct 2019 16:58:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 17853 invoked from network); 18 Oct 2019 16:58:29 -0000
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::,RULES_HIT:41:355:379:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1981:2194:2199:2393:2559:2562:2828:2897:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:4321:5007:7903:8660:10004:10400:10848:11026:11232:11658:11914:12043:12048:12297:12438:12679:12740:12760:12895:13069:13148:13230:13311:13357:13439:13848:14659:14721:21080:21212:21451:21611:21627:30054:30070:30091,0,RBL:47.151.135.224:@perches.com:.lbl8.mailshell.net-62.8.0.100 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:25,LUA_SUMMARY:none
X-HE-Tag: fruit53_8252359efdc20
X-Filterd-Recvd-Size: 2322
Message-ID: <8268ba22cccae0dccf5a8d1902bc1409877fbd4e.camel@perches.com>
Subject: Re: [PATCH 06/18] add support for Clang's Shadow Call Stack (SCS)
From: Joe Perches <joe@perches.com>
To: Sami Tolvanen <samitolvanen@google.com>, Will Deacon <will@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, Steven Rostedt
 <rostedt@goodmis.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
 Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>,
 Nick Desaulniers <ndesaulniers@google.com>,
 clang-built-linux@googlegroups.com,  kernel-hardening@lists.openwall.com,
 linux-arm-kernel@lists.infradead.org,  linux-kernel@vger.kernel.org
Date: Fri, 18 Oct 2019 09:58:14 -0700
In-Reply-To: <20191018161033.261971-7-samitolvanen@google.com>
References: <20191018161033.261971-1-samitolvanen@google.com>
	 <20191018161033.261971-7-samitolvanen@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.32.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2019-10-18 at 09:10 -0700, Sami Tolvanen wrote:
> This change adds generic support for Clang's Shadow Call Stack, which
> uses a shadow stack to protect return addresses from being overwritten
> by an attacker
[]
> .diff --git a/include/linux/compiler-clang.h b/include/linux/compiler-clang.h
[]
> @@ -42,3 +42,5 @@
>   * compilers, like ICC.
>   */
>  #define barrier() __asm__ __volatile__("" : : : "memory")
> +
> +#define __noscs		__attribute__((no_sanitize("shadow-call-stack")))

trivia:

This should likely use the __ prefix and suffix form:

#define __noscs		__attribute__((__no_sanitize__("shadow-call-stack")))

as should the __no_sanitize_address above this

> diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
[]
> @@ -202,6 +202,10 @@ struct ftrace_likely_data {
>  # define randomized_struct_fields_end
>  #endif
>  
> +#ifndef __noscs
> +# define __noscs
> +#endif
> +
>  #ifndef asm_volatile_goto
>  #define asm_volatile_goto(x...) asm goto(x)
>  #endif


