Return-Path: <kernel-hardening-return-21337-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id A181E3DB0B6
	for <lists+kernel-hardening@lfdr.de>; Fri, 30 Jul 2021 03:41:39 +0200 (CEST)
Received: (qmail 6122 invoked by uid 550); 30 Jul 2021 01:41:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 6090 invoked from network); 30 Jul 2021 01:41:31 -0000
Date: Fri, 30 Jul 2021 01:41:07 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: John Cotton Ericson <mail@johnericson.me>,
	LKML <linux-kernel@vger.kernel.org>,
	David Laight <David.Laight@aculab.com>,
	Andy Lutomirski <luto@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Jann Horn <jann@thejh.net>,
	Christian Brauner <christian.brauner@canonical.com>
Subject: Re: Leveraging pidfs for process creation without fork
Message-ID: <YQNYs+BKenJHBMSP@zeniv-ca.linux.org.uk>
References: <CAHmME9oHBtR4fBBUY8E_Oi7av-=OjOGkSNhQuMJMHhafCjazBw@mail.gmail.com>
 <CALCETrVGLx5yeHo7ExAmJZmPjVjcJiV7p1JOa4iUaW5DRoEvLQ@mail.gmail.com>
 <cf07f0732eb94dbfa67c9d56ceba738e@AcuMS.aculab.com>
 <f8457e20-c3cc-6e56-96a4-3090d7da0cb6@JohnEricson.me>
 <20210729142415.qovpzky537zkg3dp@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210729142415.qovpzky537zkg3dp@wittgenstein>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Thu, Jul 29, 2021 at 04:24:15PM +0200, Christian Brauner wrote:
> On Wed, Jul 28, 2021 at 12:37:57PM -0400, John Cotton Ericson wrote:
> > Hi,
> > 
> > I was excited to learn about about pidfds the other day, precisely in hopes
> > that it would open the door to such a "sane process creation API". I
> > searched the LKML, found this thread, and now hope to rekindle the
> > discussion; my apologies if there has been more discussion since that I
> 
> Yeah, I haven't forgotten this discussion. A proposal is on my todo list
> for this year. So far I've scheduled some time to work on this in the
> fall.

Keep in mind that quite a few places in kernel/exit.c very much rely upon the
lack of anything outside of thread group adding threads into it.  Same for
fs/exec.c.
