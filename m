Return-Path: <kernel-hardening-return-20863-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id DB5323273E5
	for <lists+kernel-hardening@lfdr.de>; Sun, 28 Feb 2021 19:57:20 +0100 (CET)
Received: (qmail 21807 invoked by uid 550); 28 Feb 2021 18:57:14 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 21774 invoked from network); 28 Feb 2021 18:57:13 -0000
IronPort-SDR: WA1DsHZ8rzgtEw3nQGvA4bHefeUSi6+EWgL3LwkSF4k51Ixv2jTrBtx/VUvDRrx0pTGG790CXw
 xiusasfHgPrw==
X-IronPort-AV: E=McAfee;i="6000,8403,9909"; a="247701732"
X-IronPort-AV: E=Sophos;i="5.81,213,1610438400"; 
   d="scan'208";a="247701732"
IronPort-SDR: xO1quA5tSkLr7Wa+aYfB/kLKW49fcvhM94c931ze3tJs/vunXvX5r099AOLt2c3f4sxun4b6LN
 d6gKQrkop9Iw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,213,1610438400"; 
   d="scan'208";a="368370565"
From: Andi Kleen <ak@linux.intel.com>
To: John Wood <john.wood@gmx.com>
Cc: Kees Cook <keescook@chromium.org>,  Jann Horn <jannh@google.com>,  Randy Dunlap <rdunlap@infradead.org>,  Jonathan Corbet <corbet@lwn.net>,  James Morris <jmorris@namei.org>,  Shuah Khan <shuah@kernel.org>,  "Serge E. Hallyn" <serge@hallyn.com>,  Greg Kroah-Hartman <gregkh@linuxfoundation.org>,  linux-doc@vger.kernel.org,  linux-kernel@vger.kernel.org,  linux-security-module@vger.kernel.org,  linux-kselftest@vger.kernel.org,  kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v5 7/8] Documentation: Add documentation for the Brute LSM
References: <20210227153013.6747-1-john.wood@gmx.com>
	<20210227153013.6747-8-john.wood@gmx.com>
Date: Sun, 28 Feb 2021 10:56:45 -0800
In-Reply-To: <20210227153013.6747-8-john.wood@gmx.com> (John Wood's message of
	"Sat, 27 Feb 2021 16:30:12 +0100")
Message-ID: <878s78dnrm.fsf@linux.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain

John Wood <john.wood@gmx.com> writes:
> +
> +To detect a brute force attack it is necessary that the statistics shared by all
> +the fork hierarchy processes be updated in every fatal crash and the most
> +important data to update is the application crash period.

So I haven't really followed the discussion and also not completely read
the patches (so apologies if that was already explained or is documented
somewhere else).

But what I'm missing here is some indication how much
memory these statistics can use up and how are they limited.

How much is the worst case extra memory consumption?

If there is no limit how is DoS prevented?

If there is a limit, there likely needs to be a way to throw out
information, and so the attack would just shift to forcing the kernel
to throw out this information before retrying.

e.g. if the data is hold for the parent shell: restart the parent
shell all the time.
e.g. if the data is hold for the sshd daemon used to log in:
Somehow cause sshd to respawn to discard the statistics.

Do I miss something here? How is that mitigated?

Instead of discussing all the low level tedious details of the
statistics it would be better to focus on these "high level"
problems here.

-Andi

