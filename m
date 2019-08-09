Return-Path: <kernel-hardening-return-16779-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 5FF6E8812E
	for <lists+kernel-hardening@lfdr.de>; Fri,  9 Aug 2019 19:29:38 +0200 (CEST)
Received: (qmail 9705 invoked by uid 550); 9 Aug 2019 17:29:31 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 9682 invoked from network); 9 Aug 2019 17:29:31 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1565371759;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=lPOAxolSCgoaWZk1kS26/9P2YdNN990Xnj6QZv/OKPs=;
	b=JPo0s4zQc0LOr/iSubZgHo+6UW032/vJHsP9WcS+UDI/EnyKB7AGlEFb7DrhdJD4cli6iC
	sZqU61sBSSuNLzfnRg5ex3ZGW7tmyKd8j9lDzuY+hgp7tyGkJDC9I1HDWP6QtPzLrAe7a5
	9gnFutMjJSQIZda43F1Zd+d+GgVlqyQ=
Date: Fri, 9 Aug 2019 19:30:03 +0200
From: Borislav Petkov <bp@alien8.de>
To: Thomas Garnier <thgarnie@chromium.org>
Cc: kernel-hardening@lists.openwall.com, kristen@linux.intel.com,
	keescook@chromium.org, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org, Juergen Gross <jgross@suse.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Maran Wilson <maran.wilson@oracle.com>,
	Feng Tang <feng.tang@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 08/11] x86/boot/64: Adapt assembly for PIE support
Message-ID: <20190809173003.GG2152@zn.tnic>
References: <20190730191303.206365-1-thgarnie@chromium.org>
 <20190730191303.206365-9-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190730191303.206365-9-thgarnie@chromium.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

chOn Tue, Jul 30, 2019 at 12:12:52PM -0700, Thomas Garnier wrote:
> Change the assembly code to use only relative references of symbols for the
> kernel to be PIE compatible.
> 
> Early at boot, the kernel is mapped at a temporary address while preparing
> the page table. To know the changes needed for the page table with KASLR,

These manipulations need to be done regardless of whether KASLR is
enabled or not. You're basically accomodating them to PIE.

> the boot code calculate the difference between the expected address of the

calculates

> kernel and the one chosen by KASLR. It does not work with PIE because all
> symbols in code are relatives. Instead of getting the future relocated
> virtual address, you will get the current temporary mapping.

Please avoid "you", "we" etc personal pronouns in commit messages.

> Instructions were changed to have absolute 64-bit references.

From Documentation/process/submitting-patches.rst:

 "Describe your changes in imperative mood, e.g. "make xyzzy do frotz"
  instead of "[This patch] makes xyzzy do frotz" or "[I] changed xyzzy
  to do frotz", as if you are giving orders to the codebase to change
  its behaviour."

Thx.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
