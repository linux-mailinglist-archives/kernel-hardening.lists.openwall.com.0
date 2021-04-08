Return-Path: <kernel-hardening-return-21177-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 3C2C43579E6
	for <lists+kernel-hardening@lfdr.de>; Thu,  8 Apr 2021 03:52:12 +0200 (CEST)
Received: (qmail 13809 invoked by uid 550); 8 Apr 2021 01:52:04 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 13777 invoked from network); 8 Apr 2021 01:52:04 -0000
IronPort-SDR: +U0BR/vKhs3FBjnEYhP4d8gz02lONGp2NuQj9+yEjv+0gAaG62PzwVMFEpW/eqVxabdAFfXy4D
 A8Rb0OnsNY6A==
X-IronPort-AV: E=McAfee;i="6000,8403,9947"; a="193481444"
X-IronPort-AV: E=Sophos;i="5.82,205,1613462400"; 
   d="scan'208";a="193481444"
IronPort-SDR: KkR7dmnwh/S7YKPk0/ghxR1MAb5d5PEbZ44OrCZwAq1WClc6HLdQJvy1HHc+m6t1nK3J4S4aim
 8qvBzS4+CIrA==
X-IronPort-AV: E=Sophos;i="5.82,205,1613462400"; 
   d="scan'208";a="519655562"
Date: Wed, 7 Apr 2021 18:51:48 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Valdis =?utf-8?Q?Kl=C4=93tnieks?= <valdis.kletnieks@vt.edu>
Cc: John Wood <john.wood@gmx.com>, kernelnewbies@kernelnewbies.org,
	Kees Cook <keescook@chromium.org>,
	kernel-hardening@lists.openwall.com
Subject: Re: Notify special task kill using wait* functions
Message-ID: <20210408015148.GB3762101@tassilo.jf.intel.com>
References: <20210402124932.GA3012@ubuntu>
 <106842.1617421818@turing-police>
 <20210403070226.GA3002@ubuntu>
 <145687.1617485641@turing-police>
 <20210404094837.GA3263@ubuntu>
 <193167.1617570625@turing-police>
 <20210405073147.GA3053@ubuntu>
 <115437.1617753336@turing-police>
 <20210407175151.GA3301@ubuntu>
 <184666.1617827926@turing-police>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <184666.1617827926@turing-police>

> I didn't even finish the line that starts "From now on.." before I started
> wondering "How can I abuse this to hang or crash a system?"  And it only took
> me a few seconds to come up with an attack. All you need to do is find a way to
> sigsegv /bin/bash... and that's easy to do by forking, excecve /bin/bash, and
> then use ptrace() to screw the child process's stack and cause a sigsegv.
> 
> Say goodnight Gracie...

Yes there is certainly DoS potential, but that's kind of inevitable
for the proposal. It's a trade between allowing attacks and allowing DoS,
with the idea that a DoS is more benign.

I'm more worried that it doesn't actually prevent the attacks 
unless we make sure systemd and other supervisor daemons understand it,
so that they don't restart.

Any caching of state is inherently insecure because any caches of limited
size can be always thrashed by a purposeful attacker. I suppose the
only thing that would work is to actually write something to the 
executable itself on disk, but of course that doesn't always work either.

-Andi
