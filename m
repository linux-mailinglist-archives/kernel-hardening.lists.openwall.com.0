Return-Path: <kernel-hardening-return-18565-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id B21101B0D05
	for <lists+kernel-hardening@lfdr.de>; Mon, 20 Apr 2020 15:43:51 +0200 (CEST)
Received: (qmail 19996 invoked by uid 550); 20 Apr 2020 13:43:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 19968 invoked from network); 20 Apr 2020 13:43:45 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587390213;
	bh=QZam6/Jc0zmflQrHk/tdI2JQLCdcFtvCqq02VxQ2xgQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=iUF22fF6UL3O3WqRu185lGxaT4VR1bUQPVizSD8ZNeX7VpAcN0ohK0bWwhmNPzVxR
	 nOF8P6I+1ry5tSjvG7rmO0ijXhF1jR9sl2Xri+8x95E5M9ZGydOVdK3p3IRJGb343n
	 FSAISa/0xSk89rwOJcJYA/PxID0SmIDz8CLiMmTk=
X-Gm-Message-State: AGi0PuabAlpRA00BgvVTZ+ZNYRVQVVhLgXF6V6QndMhpZEsJIWh1/myv
	FjP7De+xs2ZdePyBJt1UEgrc1MX2RVDmWRpvWHQ=
X-Google-Smtp-Source: APiQypKXum9Iy6YtGvuvucK0LrpReg+xpC/7+/mbiL65m2YUD50V074/5roSPLc8Gg4mpQXrq9k2/pZgUFrzmcrhhvM=
X-Received: by 2002:a02:3341:: with SMTP id k1mr16096555jak.74.1587390212759;
 Mon, 20 Apr 2020 06:43:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200415210452.27436-1-kristen@linux.intel.com>
 <20200415210452.27436-10-kristen@linux.intel.com> <CAMj1kXGbh=0nC_6SGTWjKeDPdwBrEW0_vRbjDzWyqqjY_88S7Q@mail.gmail.com>
 <cff1fa99-c692-d9f2-f077-60d630bb40bc@linux.intel.com>
In-Reply-To: <cff1fa99-c692-d9f2-f077-60d630bb40bc@linux.intel.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Mon, 20 Apr 2020 15:43:21 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHtT9Ope+rcuGipK20ovAWq7Vpt17zeLuFA=acRYPyxag@mail.gmail.com>
Message-ID: <CAMj1kXHtT9Ope+rcuGipK20ovAWq7Vpt17zeLuFA=acRYPyxag@mail.gmail.com>
Subject: Re: [PATCH 9/9] module: Reorder functions
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Kristen Carlson Accardi <kristen@linux.intel.com>, Kees Cook <keescook@chromium.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, hpa@zytor.com, 
	Jessica Yu <jeyu@kernel.org>, X86 ML <x86@kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, 
	rick.p.edgecomb@intel.com
Content-Type: text/plain; charset="UTF-8"

On Mon, 20 Apr 2020 at 15:37, Arjan van de Ven <arjan@linux.intel.com> wrote:
>
> On 4/20/2020 5:01 AM, Ard Biesheuvel wrote:
> > Is that the only prerequisite? I.e., is it sufficient for another
> > architecture to add -ffunction-sections to the module CFLAGS to get
> > this functionality? (assuming it defines CONFIG_FG_KASLR=y)
>
> I suspect you also need/want at least normal KASLR enabled as
> a "does it even make sense" common sense threshold

Fair enough. But that is more of a policy concern than a functional concern.

FWIW I took patches #8 and #9, hardwired a couple of CONFIG_FG_KASLR=y
checks and added the -ffunction-sections GCC option for the modules,
and everything appears to be working as expected on arm64. I was just
wondering if I was missing something.

Note that arm64 does not have a decompressor, so there the fine
grained randomization of the core kernel is not really feasible using
the approach presented here.
