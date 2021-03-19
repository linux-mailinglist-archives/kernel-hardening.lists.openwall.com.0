Return-Path: <kernel-hardening-return-21015-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 14C823428E9
	for <lists+kernel-hardening@lfdr.de>; Fri, 19 Mar 2021 23:51:32 +0100 (CET)
Received: (qmail 9763 invoked by uid 550); 19 Mar 2021 22:51:21 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 9728 invoked from network); 19 Mar 2021 22:51:21 -0000
X-Originating-IP: 73.37.121.169
Subject: Re: Fine-grained Forward CFI on top of Intel CET / IBT
From: Joao Moreira <joao@overdrivepizza.com>
To: Kees Cook <keescook@chromium.org>
Cc: x86-64-abi@googlegroups.com, kernel-hardening@lists.openwall.com,
 samitolvanen@google.com, hjl.tools@gmail.com, linux-hardening@vger.kernel.org
References: <0537dc00-db0e-265b-9371-783c55717e74@overdrivepizza.com>
 <202103181230.2CA57FA5@keescook>
 <8e7dfa49-2c74-1349-017c-9a4700557519@overdrivepizza.com>
Message-ID: <632c02ef-efef-c068-1228-1b869d395142@overdrivepizza.com>
Date: Fri, 19 Mar 2021 15:51:04 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <8e7dfa49-2c74-1349-017c-9a4700557519@overdrivepizza.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US


>> That is a good point about R11 availability. Have you examined kernel
>> images for unintended gadgets? It seems like it'd be rare to find an 
>> arbitrary R11 load
>> followed by an indirect call together, but stranger gadgets show up, and
>> before the BPF JIT obfuscation happened, it was possible for attackers
>> (with sufficient access) to construct a series of immediates that would
>> contain the needed gadgets. (And not all systems run with BPF JIT
>> hardening enabled.)
>
> I haven't. On a CET-enabled environment, these unintended gadgets 
> would need to be preceded with an endbr instruction, otherwise they 
> won't be reachable indirectly. I assume that these cases can still 
> exist (specially in the presence of things like vulnerable BPF JIT or 
> if you consider full non-fineibt-instrumented functions working as 
> gadgets), but that this is a raised bar. Besides that, there are 
> patches like this one (which unfortunately was abandoned) that could 
> come handy:
>
> https://reviews.llvm.org/D88194
>
Actually (as clear in the end of the patch review) this was replaced by 
a different patch, which got in :)

review: https://reviews.llvm.org/D89178

commit: https://reviews.llvm.org/rGf385823e04f300c92ec03dbd660d621cc618a271


o/

Joao

