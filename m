Return-Path: <kernel-hardening-return-17746-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 9B65D157F45
	for <lists+kernel-hardening@lfdr.de>; Mon, 10 Feb 2020 16:55:18 +0100 (CET)
Received: (qmail 5698 invoked by uid 550); 10 Feb 2020 15:55:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 5678 invoked from network); 10 Feb 2020 15:55:12 -0000
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,425,1574150400"; 
   d="scan'208";a="380142760"
Subject: Re: [RFC PATCH 06/11] x86: make sure _etext includes function
 sections
To: Peter Zijlstra <peterz@infradead.org>, Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@amacapital.net>,
 Kristen Carlson Accardi <kristen@linux.intel.com>, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, hpa@zytor.com, rick.p.edgecombe@intel.com,
 x86@kernel.org, linux-kernel@vger.kernel.org,
 kernel-hardening@lists.openwall.com
References: <75f0bd0365857ba4442ee69016b63764a8d2ad68.camel@linux.intel.com>
 <B413445A-F1F0-4FB7-AA9F-C5FF4CEFF5F5@amacapital.net>
 <20200207092423.GC14914@hirez.programming.kicks-ass.net>
 <202002091742.7B1E6BF19@keescook>
 <20200210105117.GE14879@hirez.programming.kicks-ass.net>
From: Arjan van de Ven <arjan@linux.intel.com>
Message-ID: <43b7ba31-6dca-488b-8a0e-72d9fdfd1a6b@linux.intel.com>
Date: Mon, 10 Feb 2020 07:54:58 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20200210105117.GE14879@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit

> 
> I'll leave it to others to figure out the exact details. But afaict it
> should be possible to have fine-grained-randomization and preserve the
> workaround in the end.
> 

the most obvious "solution" is to compile with an alignment of 4 bytes (so tight packing)
and then in the randomizer preserve the offset within 32 bytes, no matter what it is

that would get you an average padding of 16 bytes which is a bit more than now but not too insane
(queue Kees' argument that tiny bits of padding are actually good)




