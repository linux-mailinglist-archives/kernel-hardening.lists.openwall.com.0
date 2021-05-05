Return-Path: <kernel-hardening-return-21238-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id A9032373664
	for <lists+kernel-hardening@lfdr.de>; Wed,  5 May 2021 10:38:02 +0200 (CEST)
Received: (qmail 13521 invoked by uid 550); 5 May 2021 08:37:56 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 13489 invoked from network); 5 May 2021 08:37:55 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jK0moekqG1xhMRv7+xXp4lJk9jp8uiNxobgiWKXh+5A=; b=jkvUVKohOf8O1K994UUXsnu1Gj
	pAAaW1jnaye2Wb2MFj/ciaGL47PIcPViHLq0CnU333G/XawQNPK0MV6jmzZ4iyBgSQMki6+TDvuy3
	hBUKvCswsLWem6snP55iS3jVqkke/+1gG137r3Igj/sdeN6oBGiR5ejHqcP/5OYtpMBlxQlB0WvYZ
	XUmLfDJtEqZ3rlw81tUS47E6aBsOEjpbYfbPZzqkON39WlzByDrdH6PpKXhyVLiOTqB/200jKL5pv
	RtP0WEXVcHu+1wVhJHtq1jJEiB5kNS5Dmu64OI+dtC1CWvHBIwfvdgtby5nCAAbOX0JIxQC66ZV60
	1Vbtr6cA==;
Date: Wed, 5 May 2021 10:37:29 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kees Cook <keescook@chromium.org>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, dave.hansen@intel.com,
	luto@kernel.org, linux-mm@kvack.org, x86@kernel.org,
	akpm@linux-foundation.org, linux-hardening@vger.kernel.org,
	kernel-hardening@lists.openwall.com, ira.weiny@intel.com,
	rppt@kernel.org, dan.j.williams@intel.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 0/9] PKS write protected page tables
Message-ID: <YJJZSdVoP6yBbIjN@hirez.programming.kicks-ass.net>
References: <20210505003032.489164-1-rick.p.edgecombe@intel.com>
 <202105042253.ECBBF6B6@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202105042253.ECBBF6B6@keescook>

On Tue, May 04, 2021 at 11:25:31PM -0700, Kees Cook wrote:

> It looks like PKS-protected page tables would be much like the
> RO-protected text pages in the sense that there is already code in
> the kernel to do things to make it writable, change text, and set it
> read-only again (alternatives, ftrace, etc).

We don't actually modify text by changing the mapping at all. We modify
through a writable (but not executable) temporary alias on the page (on
x86).

Once a mapping is RX it will *never* be writable again (until we tear it
all down).
