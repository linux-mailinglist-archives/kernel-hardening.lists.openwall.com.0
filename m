Return-Path: <kernel-hardening-return-18186-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 7ACFD1916A2
	for <lists+kernel-hardening@lfdr.de>; Tue, 24 Mar 2020 17:41:17 +0100 (CET)
Received: (qmail 23638 invoked by uid 550); 24 Mar 2020 16:41:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 23604 invoked from network); 24 Mar 2020 16:41:10 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585068058;
	bh=J+sBi6OHsndQd9FEdmPuvq1csEI2nMeek82p0CfttsE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JQVuRiwPCKjU04UpPRdYIydTIWN34Ckes2kwAEmqluB0EKanARLo3M1eOhvELfmKr
	 GFiHWNcdlqcOPIN9axBc1chyGXlS1EC5VEpRpQHzGoKlR7l5Qyeme+J5qumqThb7UW
	 eOdgdNj3L3ayY3B9dqHS4JxVHtn/rlcVfLxEum4w=
Date: Tue, 24 Mar 2020 17:40:56 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Will Deacon <will@kernel.org>
Cc: linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
	Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>,
	Maddie Stone <maddiestone@google.com>,
	Marco Elver <elver@google.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>, kernel-team@android.com,
	kernel-hardening@lists.openwall.com
Subject: Re: [RFC PATCH 20/21] list: Format CHECK_DATA_CORRUPTION error
 messages consistently
Message-ID: <20200324164056.GB2518746@kroah.com>
References: <20200324153643.15527-1-will@kernel.org>
 <20200324153643.15527-21-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324153643.15527-21-will@kernel.org>

On Tue, Mar 24, 2020 at 03:36:42PM +0000, Will Deacon wrote:
> The error strings printed when list data corruption is detected are
> formatted inconsistently.
> 
> Satisfy my inner-pedant by consistently using ':' to limit the message
> from its prefix and drop the terminating full stops where they exist.
> 
> Signed-off-by: Will Deacon <will@kernel.org>

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
