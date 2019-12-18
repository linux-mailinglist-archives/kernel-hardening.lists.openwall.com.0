Return-Path: <kernel-hardening-return-17509-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id F3526124E3B
	for <lists+kernel-hardening@lfdr.de>; Wed, 18 Dec 2019 17:46:13 +0100 (CET)
Received: (qmail 14310 invoked by uid 550); 18 Dec 2019 16:46:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 14287 invoked from network); 18 Dec 2019 16:46:08 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1576687556;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=veM79yV+cFFmEZLqNeH8K6a+RQqwXlPU3rmWJpTwMAc=;
	b=fBUPT53IBka5z+KEVntYJcp7wP7qQ54cuPs5kQAraLooNx6fq5wjTyKSH0eiAUSHdDQ1+G
	fpdc81ctMpM6X7VTsRs8eitVE/G7pe4KbfRLNC4VSx/2MN3Nx5BUFW7T1KT/ThFYRm+sCa
	0TJ3xDKmODWlqfF7szBdTWqtsny89pw=
Date: Wed, 18 Dec 2019 17:45:43 +0100
From: Borislav Petkov <bp@alien8.de>
To: Thomas Garnier <thgarnie@chromium.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Kristen Carlson Accardi <kristen@linux.intel.com>,
	Kees Cook <keescook@chromium.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	the arch/x86 maintainers <x86@kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v10 01/11] x86/crypto: Adapt assembly for PIE support
Message-ID: <20191218164543.GH24886@zn.tnic>
References: <20191205000957.112719-1-thgarnie@chromium.org>
 <20191205000957.112719-2-thgarnie@chromium.org>
 <20191218124604.GE24886@zn.tnic>
 <CAJcbSZE56E_JqWpxvpHd194SAVn0fGJRiJWmLy=zfOyTthsGCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAJcbSZE56E_JqWpxvpHd194SAVn0fGJRiJWmLy=zfOyTthsGCg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, Dec 18, 2019 at 08:35:32AM -0800, Thomas Garnier wrote:
> In the last discussion, we mentioned Ingo (and other people) asked us

The last discussion ended up with:

https://lkml.kernel.org/r/CAJcbSZEnPeCnkpc%2BuHmBWRJeaaw4TPy9HPkSGeriDb6mN6HR1g@mail.gmail.com

which I read as, you'll remove that silly sentence from every commit
message.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
