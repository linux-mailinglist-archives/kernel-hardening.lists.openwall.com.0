Return-Path: <kernel-hardening-return-16489-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id B68CB6B0CA
	for <lists+kernel-hardening@lfdr.de>; Tue, 16 Jul 2019 23:13:21 +0200 (CEST)
Received: (qmail 3788 invoked by uid 550); 16 Jul 2019 21:13:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3757 invoked from network); 16 Jul 2019 21:13:14 -0000
Date: Tue, 16 Jul 2019 14:12:59 -0700 (PDT)
Message-Id: <20190716.141259.1717459496779829137.davem@davemloft.net>
To: paulmck@linux.ibm.com
Cc: joel@joelfernandes.org, linux-kernel@vger.kernel.org,
 kuznet@ms2.inr.ac.ru, bhelgaas@google.com, bp@alien8.de,
 c0d1n61at3@gmail.com, edumazet@google.com, gregkh@linuxfoundation.org,
 yoshfuji@linux-ipv6.org, hpa@zytor.com, mingo@redhat.com, corbet@lwn.net,
 josh@joshtriplett.org, keescook@chromium.org,
 kernel-hardening@lists.openwall.com, kernel-team@android.com,
 jiangshanlai@gmail.com, lenb@kernel.org, linux-acpi@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-pci@vger.kernel.org,
 linux-pm@vger.kernel.org, mathieu.desnoyers@efficios.com, neilb@suse.com,
 netdev@vger.kernel.org, oleg@redhat.com, pavel@ucw.cz,
 peterz@infradead.org, rjw@rjwysocki.net, rasmus.villemoes@prevas.dk,
 rcu@vger.kernel.org, rostedt@goodmis.org, tj@kernel.org,
 tglx@linutronix.de, will@kernel.org, x86@kernel.org
Subject: Re: [PATCH 4/9] ipv4: add lockdep condition to fix for_each_entry
 (v1)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20190716183955.GF14271@linux.ibm.com>
References: <20190715143705.117908-1-joel@joelfernandes.org>
	<20190715143705.117908-5-joel@joelfernandes.org>
	<20190716183955.GF14271@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 16 Jul 2019 14:13:01 -0700 (PDT)

From: "Paul E. McKenney" <paulmck@linux.ibm.com>
Date: Tue, 16 Jul 2019 11:39:55 -0700

> On Mon, Jul 15, 2019 at 10:37:00AM -0400, Joel Fernandes (Google) wrote:
>> Using the previous support added, use it for adding lockdep conditions
>> to list usage here.
>> 
>> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> 
> We need an ack or better from the subsystem maintainer for this one.

Acked-by: David S. Miller <davem@davemloft.net>
