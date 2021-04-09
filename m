Return-Path: <kernel-hardening-return-21185-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id C07F135A1A7
	for <lists+kernel-hardening@lfdr.de>; Fri,  9 Apr 2021 17:06:44 +0200 (CEST)
Received: (qmail 28350 invoked by uid 550); 9 Apr 2021 15:06:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 28318 invoked from network); 9 Apr 2021 15:06:37 -0000
IronPort-SDR: 9cvajuLgcxqhhWHJh9Vl38A+ssI34bROd+PvIDPvNcQU/0IJFE3J/JV/BGHL7seUR4WVhXO3cc
 +Rjzv1T+DVjg==
X-IronPort-AV: E=McAfee;i="6000,8403,9949"; a="193329890"
X-IronPort-AV: E=Sophos;i="5.82,209,1613462400"; 
   d="scan'208";a="193329890"
IronPort-SDR: /wVm2hicwDL+mPMJldBYgRL/zdJftraLv1zqEdg9igTL/jIoY+gywi1ZJn0rJ6GqFugbQf3xIG
 Oco/Bu8CydIg==
X-IronPort-AV: E=Sophos;i="5.82,209,1613462400"; 
   d="scan'208";a="416297977"
Date: Fri, 9 Apr 2021 08:06:21 -0700
From: Andi Kleen <ak@linux.intel.com>
To: John Wood <john.wood@gmx.com>
Cc: Valdis =?utf-8?Q?Kl=C4=93tnieks?= <valdis.kletnieks@vt.edu>,
	kernelnewbies@kernelnewbies.org, Kees Cook <keescook@chromium.org>,
	kernel-hardening@lists.openwall.com
Subject: Re: Notify special task kill using wait* functions
Message-ID: <20210409150621.GJ3762101@tassilo.jf.intel.com>
References: <20210403070226.GA3002@ubuntu>
 <145687.1617485641@turing-police>
 <20210404094837.GA3263@ubuntu>
 <193167.1617570625@turing-police>
 <20210405073147.GA3053@ubuntu>
 <115437.1617753336@turing-police>
 <20210407175151.GA3301@ubuntu>
 <184666.1617827926@turing-police>
 <20210408015148.GB3762101@tassilo.jf.intel.com>
 <20210409142933.GA3150@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210409142933.GA3150@ubuntu>

> > Any caching of state is inherently insecure because any caches of limited
> > size can be always thrashed by a purposeful attacker. I suppose the
> > only thing that would work is to actually write something to the
> > executable itself on disk, but of course that doesn't always work either.
> 
> I'm also working on this. In the next version I will try to find a way to
> prevent brute force attacks through the execve system call with more than
> one level of forking.

Thanks.

Thinking more about it what I wrote above wasn't quite right. The cache
would only need to be as big as the number of attackable services/suid
binaries. Presumably on many production systems that's rather small,
so a cache (which wouldn't actually be a cache, but a complete database)
might actually work.

-Andi
