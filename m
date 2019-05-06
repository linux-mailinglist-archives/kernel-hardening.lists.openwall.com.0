Return-Path: <kernel-hardening-return-15872-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 63D291484C
	for <lists+kernel-hardening@lfdr.de>; Mon,  6 May 2019 12:22:20 +0200 (CEST)
Received: (qmail 26431 invoked by uid 550); 6 May 2019 10:22:14 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 26083 invoked from network); 6 May 2019 10:21:17 -0000
Date: Mon, 6 May 2019 12:21:12 +0200
From: Solar Designer <solar@openwall.com>
To: kernel-hardening@lists.openwall.com
Subject: race-free process signaling
Message-ID: <20190506102112.GA12668@openwall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i

Hi,

I totally missed the recent work in this area (I'm not on LKML), and am
now wondering whether the solution that got in ("use /proc/<pid> fds as
stable handles on struct pid"):

https://lwn.net/Articles/773459/
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a9dce6679d736cb3d612af39bab9f31f8db66f9b

is better or worse than what I had proposed in 1999 and 2005 ("locking"
of pids for the caller's own visibility only):

https://marc.info/?l=linux-kernel&m=112784189115058

[Subject starts with "PID reuse safety for userspace apps", in case MARC
is ever gone and someone wants to look this up in another archive.

I proposed a lockpid syscall back then, but I'd use a mere prctl now.]

I still like my proposal much better - no dependency on procfs, much
simpler implementation - but perhaps I'm missing the context here.

Maybe I should have sent a patch back then.  Oh well.

Alexander
