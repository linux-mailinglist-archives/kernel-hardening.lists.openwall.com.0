Return-Path: <kernel-hardening-return-16543-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 841F7710A8
	for <lists+kernel-hardening@lfdr.de>; Tue, 23 Jul 2019 06:35:46 +0200 (CEST)
Received: (qmail 1407 invoked by uid 550); 23 Jul 2019 04:35:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1372 invoked from network); 23 Jul 2019 04:35:40 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1563856527;
	bh=AQsp9oSHDzpg8J1OlQ5PcMgGVnkDTGm7+PlHh0iIzGo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=EhNhxh+G/R7iHdl9olwT2jJMO290P22pFxI4m+8/TVXtNhohSKKQWJwwkMk24ufOc
	 m5mpCkj8b8w4CgZAoql0aZ9wbzRrjh5iDAWE9RhRp1TOf4VO4QvYoHAtDnqhwM73Nu
	 XkgYNlcpF9aw4SPADa8wNfh/ix8qJAqFOoDZQycc=
Date: Mon, 22 Jul 2019 21:35:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
 linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Stephen
 Kitt <steve@sk2.org>, Kees Cook <keescook@chromium.org>, Nitin Gote
 <nitin.r.gote@intel.com>, jannh@google.com,
 kernel-hardening@lists.openwall.com, Rasmus Villemoes
 <rasmus.villemoes@prevas.dk>
Subject: Re: [PATCH 1/2] string: Add stracpy and stracpy_pad mechanisms
Message-Id: <20190722213527.18deeaf07ae036cce57035ea@linux-foundation.org>
In-Reply-To: <7ab8957eaf9b0931a59eff6e2bd8c5169f2f6c41.1563841972.git.joe@perches.com>
References: <cover.1563841972.git.joe@perches.com>
	<7ab8957eaf9b0931a59eff6e2bd8c5169f2f6c41.1563841972.git.joe@perches.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 22 Jul 2019 17:38:15 -0700 Joe Perches <joe@perches.com> wrote:

> Several uses of strlcpy and strscpy have had defects because the
> last argument of each function is misused or typoed.
> 
> Add macro mechanisms to avoid this defect.
> 
> stracpy (copy a string to a string array) must have a string
> array as the first argument (to) and uses sizeof(to) as the
> size.
> 
> These mechanisms verify that the to argument is an array of
> char or other compatible types like u8 or unsigned char.
> 
> A BUILD_BUG is emitted when the type of to is not compatible.
> 

It would be nice to include some conversions.  To demonstrate the need,
to test the code, etc.

