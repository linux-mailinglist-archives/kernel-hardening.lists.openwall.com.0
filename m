Return-Path: <kernel-hardening-return-20886-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 4D7CB33034C
	for <lists+kernel-hardening@lfdr.de>; Sun,  7 Mar 2021 18:26:01 +0100 (CET)
Received: (qmail 7319 invoked by uid 550); 7 Mar 2021 17:25:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 7279 invoked from network); 7 Mar 2021 17:25:54 -0000
IronPort-SDR: 9VhhbqHaqJwVQ9TgkBm5jEwrL4f/MpUcX3UU+eTseKshHJn5S0Jv6/PS9XXZIySBFgdO8PBI/Z
 /9zqPsUAKwfg==
X-IronPort-AV: E=McAfee;i="6000,8403,9916"; a="167824089"
X-IronPort-AV: E=Sophos;i="5.81,230,1610438400"; 
   d="scan'208";a="167824089"
IronPort-SDR: rSoFigCEmmTYnqnwUTH2pXaCT5FBs+xAJ1e4TvkEBQ41R2+ZebVFnZ6085RExhtLtl5o7mip47
 upLDQWNxvz5w==
X-IronPort-AV: E=Sophos;i="5.81,230,1610438400"; 
   d="scan'208";a="430081838"
Date: Sun, 7 Mar 2021 09:25:40 -0800
From: Andi Kleen <ak@linux.intel.com>
To: John Wood <john.wood@gmx.com>
Cc: Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, James Morris <jmorris@namei.org>,
	Shuah Khan <shuah@kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v5 7/8] Documentation: Add documentation for the Brute LSM
Message-ID: <20210307172540.GS472138@tassilo.jf.intel.com>
References: <20210227153013.6747-1-john.wood@gmx.com>
 <20210227153013.6747-8-john.wood@gmx.com>
 <878s78dnrm.fsf@linux.intel.com>
 <20210302183032.GA3049@ubuntu>
 <20210307151920.GR472138@tassilo.jf.intel.com>
 <20210307164520.GA16296@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210307164520.GA16296@ubuntu>

> processes created from it will be killed. If the systemd restart the network
> daemon and it will crash again, then the systemd will be killed. I think this
> way the attack is fully mitigated.

Wouldn't that panic the system? Killing init is usually a panic.

> > Or if it's a interactive login you log in again.
> 
> First the login will be killed (if it fails with a fatal signal) and if it is
> restarted, the process that exec() it again will be killed. In this case I think
> that the threat is also completely mitigated.

Okay so sshd will be killed. And if it gets restarted eventually init,
so panic again.

That's a fairly drastic consequence because even without panic 
it means nobody can fix the system anymore without a console.

So probably the mitigation means that most such attacks eventually lead
to a panic because they will reach init sooner or later.

Another somewhat worrying case is some bug that kills KVM guests.
So if the bug can be triggered frequently you can kill all the
virtualization management infrastructure.

I don't remember seeing a discussion of such drastic consequences in
your description. It might be ok depending on the use case,
but people certainly need to be aware of it.

It's probably not something you want to have enabled by default ever.

-Andi

