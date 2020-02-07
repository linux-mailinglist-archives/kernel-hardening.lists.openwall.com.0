Return-Path: <kernel-hardening-return-17729-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id E7668155490
	for <lists+kernel-hardening@lfdr.de>; Fri,  7 Feb 2020 10:24:51 +0100 (CET)
Received: (qmail 30283 invoked by uid 550); 7 Feb 2020 09:24:45 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 30253 invoked from network); 7 Feb 2020 09:24:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=yaE19GgpjVX5EZUeoCXo1Tot1/ENKsmmaOeID2j9w7k=; b=fuRDhn/wOjdvyk0m/AyqA/kup7
	zrsbwXouGB5slDalE0R/KNtPkUPPkbVHPhS9GkjhGlxd2QdwEG+HgNMz8WK+EqsCwmUHfP2i3YUb6
	/Nt5s0JUx4pw2up1M/cQs/WXlr1o8zdkaAhQ2nh6fVIfysjqB1RrqFlu0wVpeYZn9/7l1PHcHe1PA
	S00jCNQJeqSygWrfPYXDdPej8QUmNXK0In69nBO8Rp6pX2DRS3frF6KHbQE8Hx7/qbQi1E6eXZMVF
	BYhV/FD4QlgOXZL6y1VtNr/6Ba1Gk6AoZ5sfo5Pq2L0W8Et7/gUgUzxQgGvovtV4xX42g6v3mKFcT
	CJFQnSOg==;
Date: Fri, 7 Feb 2020 10:24:23 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kristen Carlson Accardi <kristen@linux.intel.com>,
	Kees Cook <keescook@chromium.org>, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
	arjan@linux.intel.com, rick.p.edgecombe@intel.com, x86@kernel.org,
	linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Subject: Re: [RFC PATCH 06/11] x86: make sure _etext includes function
 sections
Message-ID: <20200207092423.GC14914@hirez.programming.kicks-ass.net>
References: <75f0bd0365857ba4442ee69016b63764a8d2ad68.camel@linux.intel.com>
 <B413445A-F1F0-4FB7-AA9F-C5FF4CEFF5F5@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <B413445A-F1F0-4FB7-AA9F-C5FF4CEFF5F5@amacapital.net>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Thu, Feb 06, 2020 at 12:02:36PM -0800, Andy Lutomirski wrote:
> Also, in the shiny new era of
> Intel-CPUs-can’t-handle-Jcc-spanning-a-cacheline, function alignment
> may actually matter.

*groan*, indeed. I just went and looked that up. I missed this one in
all the other fuss :/

So per:

  https://www.intel.com/content/dam/support/us/en/documents/processors/mitigations-jump-conditional-code-erratum.pdf

the toolchain mitigations only work if the offset in the ifetch window
(32 bytes) is preserved. Which seems to suggest we ought to align all
functions to 32byte before randomizing it, otherwise we're almost
guaranteed to change this offset by the act of randomizing.

