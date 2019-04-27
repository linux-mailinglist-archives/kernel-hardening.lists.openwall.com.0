Return-Path: <kernel-hardening-return-15845-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 31143B32D
	for <lists+kernel-hardening@lfdr.de>; Sat, 27 Apr 2019 12:32:56 +0200 (CEST)
Received: (qmail 22288 invoked by uid 550); 27 Apr 2019 10:32:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 22267 invoked from network); 27 Apr 2019 10:32:50 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	 bh=/wfN9cbY70jLMmaBiwAoTgOUu22N+b34JaAv4aDSiiM=; b=d1C1qdVOjLCTuijW+/UiQ9tUY
	u2JXmjimTsgGi9pPouHXGSi+f0eSxX0HIH7HWyjHD2y24faIPOC4LiwlTeQlVCXXwbH52+wK2P9eq
	yywoc+V3Gs/cQiwL8dgcGe75sw2HjavlRB57PNztNaUYzClj6YzlZMrjM04q4hUgigqLhYxdSJbxb
	jeQuxl+5ANx0PaU2uwc7aLcQ72NXWvHAUBx2/u7X9KKyGjw7AJE3sQYMtfdJ/YUur1FQpoIwTn1Er
	TXQQB6JzS3+BxL+eHmI18UWhjqcfLspCmuQ+hJBQiE5jEtCdrDhzwhLyK56zyuxFS/xnc9IAWvgY+
	zs64p7GnA==;
Date: Sat, 27 Apr 2019 12:32:24 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: nadav.amit@gmail.com
Cc: Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
	x86@kernel.org, hpa@zytor.com, Thomas Gleixner <tglx@linutronix.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, linux_dti@icloud.com,
	linux-integrity@vger.kernel.org,
	linux-security-module@vger.kernel.org, akpm@linux-foundation.org,
	kernel-hardening@lists.openwall.com, linux-mm@kvack.org,
	will.deacon@arm.com, ard.biesheuvel@linaro.org,
	kristen@linux.intel.com, deneen.t.dock@intel.com,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Nadav Amit <namit@vmware.com>
Subject: Re: [PATCH v6 00/24] x86: text_poke() fixes and executable lockdowns
Message-ID: <20190427103224.GG2623@hirez.programming.kicks-ass.net>
References: <20190426232303.28381-1-nadav.amit@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190426232303.28381-1-nadav.amit@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Fri, Apr 26, 2019 at 04:22:39PM -0700, nadav.amit@gmail.com wrote:
> From: Nadav Amit <namit@vmware.com>
> 
> *
> * This version fixes failed boots on 32-bit that were reported by 0day.
> * Patch 5 is added to initialize uprobes during fork initialization.
> * Patch 7 (which was 6 in the previous version) is updated - the code is
> * moved to common mm-init code with no further changes.
> *

I've added patch 5 and updated patch 7, I've left the rest of the
patches from the previous series (and kept my re-ordering of the
patches).

I pushed it all out to 0day again. Let's see if it's happy now.

