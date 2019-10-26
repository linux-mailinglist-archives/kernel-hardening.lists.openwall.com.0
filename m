Return-Path: <kernel-hardening-return-17134-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 78DF8E5E00
	for <lists+kernel-hardening@lfdr.de>; Sat, 26 Oct 2019 17:58:07 +0200 (CEST)
Received: (qmail 26615 invoked by uid 550); 26 Oct 2019 15:58:01 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 26597 invoked from network); 26 Oct 2019 15:58:00 -0000
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:599:800:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1539:1568:1593:1594:1711:1714:1730:1747:1777:1792:1981:2194:2199:2393:2559:2562:2828:2897:3138:3139:3140:3141:3142:3622:3867:4321:5007:6642:6742:7903:8660:10004:10400:10848:11026:11232:11658:11914:12043:12048:12297:12740:12760:12895:13069:13148:13230:13311:13357:13439:13848:14181:14659:14721:14819:15001:21080:21212:21451:21627:30054:30070:30074:30091,0,RBL:47.151.135.224:@perches.com:.lbl8.mailshell.net-62.8.0.100 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:27,LUA_SUMMARY:none
X-HE-Tag: sound93_43b2453be8601
X-Filterd-Recvd-Size: 2094
Message-ID: <2c13c39acb55df5dbb0d40c806bb1d7dc4bde2ae.camel@perches.com>
Subject: Re: [PATCH v2 05/17] add support for Clang's Shadow Call Stack (SCS)
From: Joe Perches <joe@perches.com>
To: samitolvanen@google.com, Will Deacon <will@kernel.org>, Catalin Marinas
	 <catalin.marinas@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Masami
	Hiramatsu <mhiramat@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
 Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>,
 Nick Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>,
 Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, Masahiro Yamada
 <yamada.masahiro@socionext.com>, clang-built-linux@googlegroups.com, 
 kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, 
 linux-kernel@vger.kernel.org
Date: Sat, 26 Oct 2019 08:57:41 -0700
In-Reply-To: <20191024225132.13410-6-samitolvanen@google.com>
References: <20191018161033.261971-1-samitolvanen@google.com>
	 <20191024225132.13410-1-samitolvanen@google.com>
	 <20191024225132.13410-6-samitolvanen@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2019-10-24 at 15:51 -0700, samitolvanen@google.com wrote:
> This change adds generic support for Clang's Shadow Call Stack,
> which uses a shadow stack to protect return addresses from being
> overwritten by an attacker. Details are available here:
[]
> diff --git a/include/linux/compiler-clang.h b/include/linux/compiler-clang.h
[]
> @@ -42,3 +42,9 @@
>   * compilers, like ICC.
>   */
>  #define barrier() __asm__ __volatile__("" : : : "memory")
> +
> +#if __has_feature(shadow_call_stack)
> +# define __noscs	__attribute__((no_sanitize("shadow-call-stack")))

__no_sanitize__


