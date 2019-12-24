Return-Path: <kernel-hardening-return-17523-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 48BD212A193
	for <lists+kernel-hardening@lfdr.de>; Tue, 24 Dec 2019 14:03:46 +0100 (CET)
Received: (qmail 13593 invoked by uid 550); 24 Dec 2019 13:03:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 13568 invoked from network); 24 Dec 2019 13:03:36 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1577192598;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=RPmKXDdfeilER4Cgaeoi2HiLWA8B3GNUxDgJuxdBXfU=;
	b=reF83Q8gQU8d8BbbxQtuMbOFtz4tNW0TWem/vVoR96GaFFqKuP34eCfMKbkHGHhpKGdri3
	pyPpxWQoCT/9pskvQWyrWoFHiWRqJx3nXMkEvHac9OE4eXfjVFUgDyv9Abz9tEzv8ew26N
	WtLUvAmpJ1NPS+Gi5gUtfB2R8Ui/FNQ=
Date: Tue, 24 Dec 2019 14:03:10 +0100
From: Borislav Petkov <bp@alien8.de>
To: Thomas Garnier <thgarnie@chromium.org>
Cc: kernel-hardening@lists.openwall.com, kristen@linux.intel.com,
	keescook@chromium.org, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org, Andy Lutomirski <luto@kernel.org>,
	Juergen Gross <jgross@suse.com>,
	Thomas Hellstrom <thellstrom@vmware.com>,
	"VMware, Inc." <pv-drivers@vmware.com>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Peter Zijlstra <peterz@infradead.org>,
	Will Deacon <will@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>, Jiri Slaby <jslaby@suse.cz>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alexios Zavras <alexios.zavras@intel.com>,
	Allison Randal <allison@lohutok.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux-foundation.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v10 00/11] x86: PIE support to extend KASLR randomization
Message-ID: <20191224130310.GE21017@zn.tnic>
References: <20191205000957.112719-1-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191205000957.112719-1-thgarnie@chromium.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, Dec 04, 2019 at 04:09:37PM -0800, Thomas Garnier wrote:
> Minor changes based on feedback and rebase from v9.
> 
> Splitting the previous serie in two. This part contains assembly code
> changes required for PIE but without any direct dependencies with the
> rest of the patchset.

Ok, modulo the minor commit message and comments fixup, this looks ok
and passes testing here.

I'm going to queue patches 2-11 of the next version unless someone
complains.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
