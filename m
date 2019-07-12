Return-Path: <kernel-hardening-return-16417-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id CFB8366618
	for <lists+kernel-hardening@lfdr.de>; Fri, 12 Jul 2019 07:19:58 +0200 (CEST)
Received: (qmail 26138 invoked by uid 550); 12 Jul 2019 05:19:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 26117 invoked from network); 12 Jul 2019 05:19:52 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1562908780;
	bh=yE7S5fzJoVQNuX0LT96I6+TD22L2qYACRj+IFS/83eU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kNq5Dy+my5tAbdckuPkkqqy713gpH02voNBbWAc0YMm+F2x/aSJj+DmEypI2Tl56C
	 5N+Lrf92INs2kOIY1DJsNeTGh9AYPWqkDAm+/AjWkoIHhCmmq0tGj/bw9QuQlpr+MG
	 JTIHGaL/pzpQCDvHKHjaVVofZsfkYdXSV8e3jimc=
Date: Fri, 12 Jul 2019 07:19:37 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc: linux-kernel@vger.kernel.org, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
	Bjorn Helgaas <bhelgaas@google.com>, Borislav Petkov <bp@alien8.de>,
	c0d1n61at3@gmail.com, "David S. Miller" <davem@davemloft.net>,
	edumazet@google.com, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
	Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org,
	kernel-hardening@lists.openwall.com,
	Lai Jiangshan <jiangshanlai@gmail.com>, Len Brown <lenb@kernel.org>,
	linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
	linux-pm@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, neilb@suse.com,
	netdev@vger.kernel.org, oleg@redhat.com,
	"Paul E. McKenney" <paulmck@linux.ibm.com>,
	Pavel Machek <pavel@ucw.cz>, peterz@infradead.org,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Rasmus Villemoes <rasmus.villemoes@prevas.dk>, rcu@vger.kernel.org,
	Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, will@kernel.org,
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [PATCH v1 3/6] driver/core: Convert to use built-in RCU list
 checking
Message-ID: <20190712051937.GA4682@kroah.com>
References: <20190711234401.220336-1-joel@joelfernandes.org>
 <20190711234401.220336-4-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190711234401.220336-4-joel@joelfernandes.org>
User-Agent: Mutt/1.12.1 (2019-06-15)

On Thu, Jul 11, 2019 at 07:43:58PM -0400, Joel Fernandes (Google) wrote:
> list_for_each_entry_rcu has built-in RCU and lock checking. Make use of
> it in driver core.
> 
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> ---
>  drivers/base/base.h          |  1 +
>  drivers/base/core.c          | 10 ++++++++++
>  drivers/base/power/runtime.c | 15 ++++++++++-----
>  3 files changed, 21 insertions(+), 5 deletions(-)

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
