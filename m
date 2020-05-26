Return-Path: <kernel-hardening-return-18564-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 45F051B0CD6
	for <lists+kernel-hardening@lfdr.de>; Mon, 20 Apr 2020 15:37:37 +0200 (CEST)
Received: (qmail 13658 invoked by uid 550); 20 Apr 2020 13:37:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 13638 invoked from network); 20 Apr 2020 13:37:29 -0000
IronPort-SDR: ZkRVLwK//mF0oopkVQQ7GoFD087Le6yqVfAHgOvks4u/1FreFMYyZWYuB3cUr6d7K8+q7inWe6
 0LS/CtdL6HLA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
IronPort-SDR: vt2Cpxgf/VyAygW430U5YyGa47SK2s/6vIwyWW+Y1T1iX68HonZOtbt8Uu23Tuc4lXlPEJ83q8
 lTYVzBCgebyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,406,1580803200"; 
   d="scan'208";a="279241230"
Subject: Re: [PATCH 9/9] module: Reorder functions
To: Ard Biesheuvel <ardb@kernel.org>,
 Kristen Carlson Accardi <kristen@linux.intel.com>
Cc: Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 hpa@zytor.com, Jessica Yu <jeyu@kernel.org>, X86 ML <x86@kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 kernel-hardening@lists.openwall.com, rick.p.edgecomb@intel.com
References: <20200415210452.27436-1-kristen@linux.intel.com>
 <20200415210452.27436-10-kristen@linux.intel.com>
 <CAMj1kXGbh=0nC_6SGTWjKeDPdwBrEW0_vRbjDzWyqqjY_88S7Q@mail.gmail.com>
From: Arjan van de Ven <arjan@linux.intel.com>
Message-ID: <cff1fa99-c692-d9f2-f077-60d630bb40bc@linux.intel.com>
Date: Mon, 20 Apr 2020 06:37:17 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAMj1kXGbh=0nC_6SGTWjKeDPdwBrEW0_vRbjDzWyqqjY_88S7Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 4/20/2020 5:01 AM, Ard Biesheuvel wrote:
> Is that the only prerequisite? I.e., is it sufficient for another
> architecture to add -ffunction-sections to the module CFLAGS to get
> this functionality? (assuming it defines CONFIG_FG_KASLR=y)

I suspect you also need/want at least normal KASLR enabled as
a "does it even make sense" common sense threshold
