Return-Path: <kernel-hardening-return-17694-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 2E3771541FE
	for <lists+kernel-hardening@lfdr.de>; Thu,  6 Feb 2020 11:38:54 +0100 (CET)
Received: (qmail 2038 invoked by uid 550); 6 Feb 2020 10:38:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 2017 invoked from network); 6 Feb 2020 10:38:48 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=DjXmqETrMux+Kvl54ARTF4j5vGbLSPVcRuU0fti6CUI=; b=cElrmZOkO5QQfNB2K32XFgXSa+
	utFJ6s2akipb7LH6esgagCxAkyYZ+i5/T9dmvqBc+mgEDfb7gu9jQcxR0XIzhgNKru3P6RJocdX5K
	SZNwEUnHqIVsfVfhI1nXdzSzSRWAKBpWFXxYIa0NokFgIyBX2sufPqFq9BSBPbeMQlzZuruhnS7Hp
	3jIbpfGPfFxRIhQkhlAbK0Vodaydr59WGjJHs97FUQSk3VQCg/Pb1Hf6AhPvvjeXB6c8azGu1kU4+
	ecak7avhEjeiExdtb0yoy2UqF/0nzVSbPWu7lEcL/qxN1GlKET5F0Oi+yO3voqz8OF2h4jDDrWvP0
	ThB/X0EA==;
Date: Thu, 6 Feb 2020 11:38:30 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Kristen Carlson Accardi <kristen@linux.intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
	arjan@linux.intel.com, keescook@chromium.org,
	rick.p.edgecombe@intel.com, x86@kernel.org,
	linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Subject: Re: [RFC PATCH 08/11] x86: Add support for finer grained KASLR
Message-ID: <20200206103830.GW14879@hirez.programming.kicks-ass.net>
References: <20200205223950.1212394-1-kristen@linux.intel.com>
 <20200205223950.1212394-9-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200205223950.1212394-9-kristen@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, Feb 05, 2020 at 02:39:47PM -0800, Kristen Carlson Accardi wrote:
> +static long __start___ex_table_addr;
> +static long __stop___ex_table_addr;
> +static long _stext;
> +static long _etext;
> +static long _sinittext;
> +static long _einittext;

Should you not also adjust __jump_table, __mcount_loc,
__kprobe_blacklist and possibly others that include text addresses?
