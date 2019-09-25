Return-Path: <kernel-hardening-return-16935-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 4FA03BE7E9
	for <lists+kernel-hardening@lfdr.de>; Wed, 25 Sep 2019 23:50:30 +0200 (CEST)
Received: (qmail 22417 invoked by uid 550); 25 Sep 2019 21:50:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 22385 invoked from network); 25 Sep 2019 21:50:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1569448212;
	bh=0hElOx3BzQbrRg4qLp+t1hnvhiKVtH9mNvFATszNKeU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=K7O5+35b6Ac+m64iTBbK2S6SB+lhgxNCKhjM7IcdVSDsv1wm7VwMvx8Y6X/oB6XEk
	 4u5uDYsizKBl250xDMeM150DYHz5cAUc3Ysh6oykM1xh2Oz8ds2ZhW5teJoNQwajnj
	 9nIEmyflO26x5euUTVsqw+gs4DY2MTPCjo/SjYYI=
Date: Wed, 25 Sep 2019 14:50:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
 linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Stephen
 Kitt <steve@sk2.org>, Kees Cook <keescook@chromium.org>, Nitin Gote
 <nitin.r.gote@intel.com>, jannh@google.com,
 kernel-hardening@lists.openwall.com, Rasmus Villemoes
 <rasmus.villemoes@prevas.dk>
Subject: Re: [PATCH V2 1/2] string: Add stracpy and stracpy_pad mechanisms
Message-Id: <20190925145011.c80c89b56fcee3060cf87773@linux-foundation.org>
In-Reply-To: <ed4611a4a96057bf8076856560bfbf9b5e95d390.1563889130.git.joe@perches.com>
References: <cover.1563889130.git.joe@perches.com>
	<ed4611a4a96057bf8076856560bfbf9b5e95d390.1563889130.git.joe@perches.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 23 Jul 2019 06:51:36 -0700 Joe Perches <joe@perches.com> wrote:

> Several uses of strlcpy and strscpy have had defects because the
> last argument of each function is misused or typoed.
> 
> Add macro mechanisms to avoid this defect.
> 
> stracpy (copy a string to a string array) must have a string
> array as the first argument (dest) and uses sizeof(dest) as the
> count of bytes to copy.
> 
> These mechanisms verify that the dest argument is an array of
> char or other compatible types like u8 or s8 or equivalent.
> 
> A BUILD_BUG is emitted when the type of dest is not compatible.
> 

I'm still reluctant to merge this because we don't have code in -next
which *uses* it.  You did have a patch for that against v1, I believe? 
Please dust it off and send it along?

