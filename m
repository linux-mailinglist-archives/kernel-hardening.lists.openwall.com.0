Return-Path: <kernel-hardening-return-18676-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id E2EA71BD433
	for <lists+kernel-hardening@lfdr.de>; Wed, 29 Apr 2020 07:48:35 +0200 (CEST)
Received: (qmail 28504 invoked by uid 550); 29 Apr 2020 05:48:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 28469 invoked from network); 29 Apr 2020 05:48:30 -0000
Authentication-Results: localhost; dkim=pass
	reason="1024-bit key; insecure key"
	header.d=c-s.fr header.i=@c-s.fr header.b=sxDEfEHR; dkim-adsp=pass;
	dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
	t=1588139297; bh=RWrrzhROU4AhMQscVmJW7ryjjm/lvlZTjaZEPqwpCCA=;
	h=Subject:To:References:From:Date:In-Reply-To:From;
	b=sxDEfEHROz7DoqWfDtZXBSzeILx1ptRB8IpA32eMMdM9ajc4S441WmWPeIlg6tVMJ
	 F4K/PGnlmbtqI6e8PZdUDZ6lV6yDHcNGpiQVvlKNuBQF1nofMy41PI07sGc2BIAAHT
	 0wsuMiNf1gY8rFsnuaZdOz2X9HGOeWzrSQ7B0sHg=
X-Virus-Scanned: amavisd-new at c-s.fr
Subject: Re: [RFC PATCH v2 1/5] powerpc/mm: Introduce temporary mm
To: "Christopher M. Riedl" <cmr@informatik.wtf>,
 linuxppc-dev@lists.ozlabs.org, kernel-hardening@lists.openwall.com
References: <20200429020531.20684-1-cmr@informatik.wtf>
 <20200429020531.20684-2-cmr@informatik.wtf>
From: Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <d481ec66-8e14-614f-8e33-d381ce606bc5@c-s.fr>
Date: Wed, 29 Apr 2020 07:48:11 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200429020531.20684-2-cmr@informatik.wtf>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit



Le 29/04/2020 à 04:05, Christopher M. Riedl a écrit :
> x86 supports the notion of a temporary mm which restricts access to
> temporary PTEs to a single CPU. A temporary mm is useful for situations
> where a CPU needs to perform sensitive operations (such as patching a
> STRICT_KERNEL_RWX kernel) requiring temporary mappings without exposing
> said mappings to other CPUs. A side benefit is that other CPU TLBs do
> not need to be flushed when the temporary mm is torn down.
> 
> Mappings in the temporary mm can be set in the userspace portion of the
> address-space.
> 
> Interrupts must be disabled while the temporary mm is in use. HW
> breakpoints, which may have been set by userspace as watchpoints on
> addresses now within the temporary mm, are saved and disabled when
> loading the temporary mm. The HW breakpoints are restored when unloading
> the temporary mm. All HW breakpoints are indiscriminately disabled while
> the temporary mm is in use.

Why do we need to use a temporary mm all the time ?

Doesn't each CPU have its own mm already ? Only the upper address space 
is shared between all mm's but each mm has its own lower address space, 
at least when it is running a user process. Why not just use that mm ? 
As we are mapping then unmapping with interrupts disabled, there is no 
risk at all that the user starts running while the patch page is mapped, 
so I'm not sure why switching to a temporary mm is needed.


> 
> Based on x86 implementation:
> 
> commit cefa929c034e
> ("x86/mm: Introduce temporary mm structs")
> 
> Signed-off-by: Christopher M. Riedl <cmr@informatik.wtf>

Christophe
