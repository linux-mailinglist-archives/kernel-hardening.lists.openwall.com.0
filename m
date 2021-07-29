Return-Path: <kernel-hardening-return-21335-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id F18C93DA761
	for <lists+kernel-hardening@lfdr.de>; Thu, 29 Jul 2021 17:20:48 +0200 (CEST)
Received: (qmail 20126 invoked by uid 550); 29 Jul 2021 15:20:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 5606 invoked from network); 29 Jul 2021 14:24:33 -0000
Date: Thu, 29 Jul 2021 16:24:15 +0200
From: Christian Brauner <christian.brauner@ubuntu.com>
To: John Cotton Ericson <mail@JohnEricson.me>
Cc: LKML <linux-kernel@vger.kernel.org>,
	David Laight <David.Laight@ACULAB.COM>,
	Andy Lutomirski <luto@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Jann Horn <jann@thejh.net>,
	Christian Brauner <christian.brauner@canonical.com>
Subject: Re: Leveraging pidfs for process creation without fork
Message-ID: <20210729142415.qovpzky537zkg3dp@wittgenstein>
References: <CAHmME9oHBtR4fBBUY8E_Oi7av-=OjOGkSNhQuMJMHhafCjazBw@mail.gmail.com>
 <CALCETrVGLx5yeHo7ExAmJZmPjVjcJiV7p1JOa4iUaW5DRoEvLQ@mail.gmail.com>
 <cf07f0732eb94dbfa67c9d56ceba738e@AcuMS.aculab.com>
 <f8457e20-c3cc-6e56-96a4-3090d7da0cb6@JohnEricson.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f8457e20-c3cc-6e56-96a4-3090d7da0cb6@JohnEricson.me>

On Wed, Jul 28, 2021 at 12:37:57PM -0400, John Cotton Ericson wrote:
> Hi,
> 
> I was excited to learn about about pidfds the other day, precisely in hopes
> that it would open the door to such a "sane process creation API". I
> searched the LKML, found this thread, and now hope to rekindle the
> discussion; my apologies if there has been more discussion since that I

Yeah, I haven't forgotten this discussion. A proposal is on my todo list
for this year. So far I've scheduled some time to work on this in the
fall.

Thanks!
Christian
