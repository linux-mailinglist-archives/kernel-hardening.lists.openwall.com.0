Return-Path: <kernel-hardening-return-20928-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id E416F337EAA
	for <lists+kernel-hardening@lfdr.de>; Thu, 11 Mar 2021 21:05:41 +0100 (CET)
Received: (qmail 28332 invoked by uid 550); 11 Mar 2021 20:05:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 28300 invoked from network); 11 Mar 2021 20:05:34 -0000
IronPort-SDR: mXrUCZmINt7XLRUjWHIWPBMPWvc6Id0NXsl+N8QZWcaPgoApRTQ1RV5T6k+pkX1trdqQKJojLX
 v3pBmeHiAryw==
X-IronPort-AV: E=McAfee;i="6000,8403,9920"; a="185377203"
X-IronPort-AV: E=Sophos;i="5.81,241,1610438400"; 
   d="scan'208";a="185377203"
IronPort-SDR: FbBl7vt7kRG6veBODarDsB6owtweSKVaX9+h//dt0YVjEZAl/r6yUr3KXsCzySdt6nLFYsX+T2
 3OzFsKxYCx8w==
X-IronPort-AV: E=Sophos;i="5.81,241,1610438400"; 
   d="scan'208";a="387131641"
Date: Thu, 11 Mar 2021 12:05:17 -0800
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
Message-ID: <20210311200517.GG203350@tassilo.jf.intel.com>
References: <20210227153013.6747-1-john.wood@gmx.com>
 <20210227153013.6747-8-john.wood@gmx.com>
 <878s78dnrm.fsf@linux.intel.com>
 <20210302183032.GA3049@ubuntu>
 <20210307151920.GR472138@tassilo.jf.intel.com>
 <20210307164520.GA16296@ubuntu>
 <20210307172540.GS472138@tassilo.jf.intel.com>
 <20210307180541.GA17108@ubuntu>
 <20210307224927.GT472138@tassilo.jf.intel.com>
 <20210309184054.GA3058@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210309184054.GA3058@ubuntu>


<scenario that init will not be killed>

Thanks.

Okay but that means that the brute force attack can just continue
because the attacked daemon will be respawned?

You need some way to stop the respawning, otherwise the
mitigation doesn't work for daemons.


-Andi

