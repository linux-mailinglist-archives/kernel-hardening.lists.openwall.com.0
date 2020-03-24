Return-Path: <kernel-hardening-return-18183-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 7A0E5191662
	for <lists+kernel-hardening@lfdr.de>; Tue, 24 Mar 2020 17:28:40 +0100 (CET)
Received: (qmail 13567 invoked by uid 550); 24 Mar 2020 16:28:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 13531 invoked from network); 24 Mar 2020 16:28:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585067302;
	bh=OwaKuYa+9PST2bZOdVKnZ0hlu4DJ0Q8E1oQGPjlNHno=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=xaHWyl5k+iunZr/F/yLvuO1VnQ/BlNmfc5+iTDmwR79r08X32r7KVpME6hDbQXy6w
	 +ixeuUCtn0m6o70wDBGrLlIFnrtOO3MigjTiRmyQ3icXm+6sucMV8FrWqFyJyUk098
	 b311m4SPLQrNVwQbKCiNfN8ptJNhxWU4wU/bTwSE=
Date: Tue, 24 Mar 2020 17:28:20 +0100
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
Subject: Re: [RFC PATCH 17/21] linux/bit_spinlock.h: Include linux/processor.h
Message-ID: <20200324162820.GD2518046@kroah.com>
References: <20200324153643.15527-1-will@kernel.org>
 <20200324153643.15527-18-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324153643.15527-18-will@kernel.org>

On Tue, Mar 24, 2020 at 03:36:39PM +0000, Will Deacon wrote:
> Needed for cpu_relax().

Is this needed now, or for the next patch?  And if for next patch, why
not just add it then?

thanks,

greg k-h
