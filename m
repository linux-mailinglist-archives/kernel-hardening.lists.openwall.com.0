Return-Path: <kernel-hardening-return-19259-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 4428C218D79
	for <lists+kernel-hardening@lfdr.de>; Wed,  8 Jul 2020 18:48:19 +0200 (CEST)
Received: (qmail 16095 invoked by uid 550); 8 Jul 2020 16:48:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 16072 invoked from network); 8 Jul 2020 16:48:12 -0000
IronPort-SDR: CS/kNqdRPLP+kQ7PaZi4TlZXXtGlLnVFKRsqObPvakSiuRwphc1ekpqAXSgZgT/71v3S7QzYT0
 inPVOrU6II+Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9676"; a="136095910"
X-IronPort-AV: E=Sophos;i="5.75,328,1589266800"; 
   d="scan'208";a="136095910"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
IronPort-SDR: 6MMsL8LobZj0NHElNGCZR9i1cX0Q5HUgnhNzrWmrFw9BeX368h7tv6pHkD8THPX8VxVTuCLjrj
 HtBYQMlWkiJw==
X-IronPort-AV: E=Sophos;i="5.75,328,1589266800"; 
   d="scan'208";a="280009112"
Message-ID: <6cba1bdea35eb19492c5d2674f2a58aae8635155.camel@linux.intel.com>
Subject: Re: [PATCH v3 09/10] kallsyms: Hide layout
From: Kristen Carlson Accardi <kristen@linux.intel.com>
To: "Luck, Tony" <tony.luck@intel.com>, Kees Cook <keescook@chromium.org>, 
	Jann Horn <jannh@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Arjan van de Ven <arjan@linux.intel.com>,
 the arch/x86 maintainers <x86@kernel.org>, kernel list
 <linux-kernel@vger.kernel.org>, Kernel Hardening
 <kernel-hardening@lists.openwall.com>, "Edgecombe, Rick P"
 <rick.p.edgecombe@intel.com>
Date: Wed, 08 Jul 2020 09:47:55 -0700
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F7F68AC3B@ORSMSX115.amr.corp.intel.com>
References: <20200623172327.5701-1-kristen@linux.intel.com>
	 <20200623172327.5701-10-kristen@linux.intel.com>
	 <CAG48ez3YHoPOTZvabsNUcr=GP-rX+OXhNT54KcZT9eSQ28Fb8Q@mail.gmail.com>
	 <202006240815.45AAD55@keescook>
	 <f34eb868e609a1a8a7f19b77fe5d00bf3555bb00.camel@linux.intel.com>
	 <3908561D78D1C84285E8C5FCA982C28F7F68AC3B@ORSMSX115.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Tue, 2020-07-07 at 23:16 +0000, Luck, Tony wrote:
> > Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
> > Reviewed-by: Tony Luck <tony.luck@intel.com>
> > Tested-by: Tony Luck <tony.luck@intel.com>
> 
> I'll happily review and test again ... but since you've made
> substantive
> changes, you should drop these tags until I do.

Will do - thanks! If nobody thinks this is a horrible direction, I'll
clean up this patch and submit it with the rest as part of v4.

> 
> FWIW I think random order is a good idea.  Do you shuffle once?
> Or every time somebody opens /proc/kallsyms?

I am shuffling every single time that somebody opens /proc/kallsyms -
this is because it's possible that somebody has loaded modules or bpf
stuff and there may be new/different symbols to display.


