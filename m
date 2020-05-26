Return-Path: <kernel-hardening-return-18566-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 353601B0D35
	for <lists+kernel-hardening@lfdr.de>; Mon, 20 Apr 2020 15:48:11 +0200 (CEST)
Received: (qmail 24486 invoked by uid 550); 20 Apr 2020 13:48:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 24461 invoked from network); 20 Apr 2020 13:48:05 -0000
IronPort-SDR: B5Z0kQINEU9j+Hc5dl5DTWoQRoH4kpDgIwdaWWxGtAlFU6d+nMYIjOPlle1v6+PNwWzT8mARMi
 hgYKa0BHyuEw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
IronPort-SDR: jwQolS9u+4721QdJFLXFEOkkXhmo1m2C+SFHHPT0cni8hJqTPMwOlDTulPPYyhjJrhSb2AZYL8
 yASKG9D7+w1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,406,1580803200"; 
   d="scan'208";a="279244431"
Subject: Re: [PATCH 9/9] module: Reorder functions
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Kristen Carlson Accardi <kristen@linux.intel.com>,
 Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 hpa@zytor.com, Jessica Yu <jeyu@kernel.org>, X86 ML <x86@kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 kernel-hardening@lists.openwall.com, rick.p.edgecomb@intel.com
References: <20200415210452.27436-1-kristen@linux.intel.com>
 <20200415210452.27436-10-kristen@linux.intel.com>
 <CAMj1kXGbh=0nC_6SGTWjKeDPdwBrEW0_vRbjDzWyqqjY_88S7Q@mail.gmail.com>
 <cff1fa99-c692-d9f2-f077-60d630bb40bc@linux.intel.com>
 <CAMj1kXHtT9Ope+rcuGipK20ovAWq7Vpt17zeLuFA=acRYPyxag@mail.gmail.com>
From: Arjan van de Ven <arjan@linux.intel.com>
Message-ID: <578416ef-3d1d-4b64-2be7-0ae1f5b84796@linux.intel.com>
Date: Mon, 20 Apr 2020 06:47:52 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAMj1kXHtT9Ope+rcuGipK20ovAWq7Vpt17zeLuFA=acRYPyxag@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 4/20/2020 6:43 AM, Ard Biesheuvel wrote:

> 
> Note that arm64 does not have a decompressor, so there the fine
> grained randomization of the core kernel is not really feasible using
> the approach presented here.

maybe do a "memcpy" decompressor as an option? :-)

> 

