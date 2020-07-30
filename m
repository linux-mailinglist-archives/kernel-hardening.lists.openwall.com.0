Return-Path: <kernel-hardening-return-19495-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id C927A23344D
	for <lists+kernel-hardening@lfdr.de>; Thu, 30 Jul 2020 16:25:53 +0200 (CEST)
Received: (qmail 3096 invoked by uid 550); 30 Jul 2020 14:25:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3076 invoked from network); 30 Jul 2020 14:25:47 -0000
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6E69220B4908
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1596119136;
	bh=iQD4oMx1vXbV5tj3ST9M8eMgC4Qkots35Kpu1EaisYA=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
	b=hKwd9y4uik37h5AXO9wYYs/IAI7QSFqMmQrGXxVcsc7Zj8tY598SJwC87D8DnDzCT
	 oNB/IY35bqDRkvJr9zK4x/HZCTMj9yJelgItkU+vGout2ADwPWSIJ5OvDqFtemhKEt
	 ZIQoOyX9muMMkl7kDsT0vI3YDhumgFIjTlZDd61s=
Subject: Re: [PATCH v1 2/4] [RFC] x86/trampfd: Provide support for the
 trampoline file descriptor
To: Greg KH <gregkh@linuxfoundation.org>
Cc: kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, oleg@redhat.com, x86@kernel.org
References: <aefc85852ea518982e74b233e11e16d2e707bc32>
 <20200728131050.24443-1-madvenka@linux.microsoft.com>
 <20200728131050.24443-3-madvenka@linux.microsoft.com>
 <20200730090612.GA900546@kroah.com>
From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <f8a8c7b9-43b9-35de-343d-a1deeee2b769@linux.microsoft.com>
Date: Thu, 30 Jul 2020 09:25:34 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200730090612.GA900546@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US

Yes. I will fix this.

Thanks.

Madhavan

On 7/30/20 4:06 AM, Greg KH wrote:
> On Tue, Jul 28, 2020 at 08:10:48AM -0500, madvenka@linux.microsoft.com wrote:
>> +EXPORT_SYMBOL_GPL(trampfd_valid_regs);
> Why are all of these exported?  I don't see a module user in this
> series, or did I miss it somehow?
>
> EXPORT_SYMBOL* is only needed for symbols to be used by modules, not by
> code that is built into the kernel.
>
> thanks,
>
> greg k-h

