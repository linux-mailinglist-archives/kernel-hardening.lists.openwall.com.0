Return-Path: <kernel-hardening-return-18851-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id F124A1DD9A2
	for <lists+kernel-hardening@lfdr.de>; Thu, 21 May 2020 23:43:18 +0200 (CEST)
Received: (qmail 22085 invoked by uid 550); 21 May 2020 21:43:14 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 22064 invoked from network); 21 May 2020 21:43:13 -0000
IronPort-SDR: glqs0StXiwlKKKHqOeE9PS5f+U9zL2UI0cU9HLK81BWdz592YhfWBfE8Xbgl9r4reQ2sP0Iwl6
 pLPxWOplKCtA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
IronPort-SDR: VrRXXdswApTlmZiOJa6cs5ElnoZWHUwIDfzGnv+RA2jY/ZIdpIR0z5RnIuWMewWb6r5X06yxA5
 OInBbJzWRJuQ==
X-IronPort-AV: E=Sophos;i="5.73,419,1583222400"; 
   d="scan'208";a="300460084"
Message-ID: <7c8685090dd36ab0175ae91d1421f4cd7fb6aff0.camel@linux.intel.com>
Subject: Re: [PATCH v2 7/9] x86: Add support for function granular KASLR
From: Kristen Carlson Accardi <kristen@linux.intel.com>
To: Kees Cook <keescook@chromium.org>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, Jonathan Corbet
	 <corbet@lwn.net>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	arjan@linux.intel.com, linux-kernel@vger.kernel.org, 
	kernel-hardening@lists.openwall.com, rick.p.edgecombe@intel.com, Tony Luck
	 <tony.luck@intel.com>, linux-doc@vger.kernel.org
Date: Thu, 21 May 2020 14:42:56 -0700
In-Reply-To: <202005211301.4853672E2@keescook>
References: <20200521165641.15940-1-kristen@linux.intel.com>
	 <20200521165641.15940-8-kristen@linux.intel.com>
	 <202005211301.4853672E2@keescook>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

Hi Kees,
Thanks for your review - I will incorporate what I can into v3, or
explain why not once I give it a try :).

On Thu, 2020-05-21 at 14:08 -0700, Kees Cook wrote:
> > 
<snip>

> On Thu, May 21, 2020 at 09:56:38AM -0700, Kristen Carlson Accardi
> wrote:
> > +	/*
> > +	 * sometimes we are updating a relative offset that would
> > +	 * normally be relative to the next instruction (such as a
> > call).
> > +	 * In this case to calculate the target, you need to add 32bits
> > to
> > +	 * the pc to get the next instruction value. However, sometimes
> > +	 * targets are just data that was stored in a table such as
> > ksymtab
> > +	 * or cpu alternatives. In this case our target is not relative
> > to
> > +	 * the next instruction.
> > +	 */
> 
> Excellent and scary comment. ;) Was this found by trial and error?
> That
> sounds "fun" to debug. :P

This did suck to debug. Thank goodness for debugging with gdb in a VM.
As you know, I had previously had a patch to use a prand to be able to
retain the same layout across boots, and that came in handy here. While
we decided to not submit this functionality with this initial merge
attempt, I will add it on in the future as it does make debugging much
easier when you can reliably duplicate failure modes.


