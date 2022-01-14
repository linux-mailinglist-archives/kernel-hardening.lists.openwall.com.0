Return-Path: <kernel-hardening-return-21538-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id A6A6E48EAAB
	for <lists+kernel-hardening@lfdr.de>; Fri, 14 Jan 2022 14:29:14 +0100 (CET)
Received: (qmail 15521 invoked by uid 550); 14 Jan 2022 13:28:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 15374 invoked from network); 14 Jan 2022 13:28:50 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1642166918;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i7Hb3kE5ydsp6WhjzeEMuriHMwtkc9A+4GAC1LGLZ9Q=;
	b=VK09i/CajmAH+YL8HVRqIiQ+DnJNMIPmvZkR0JyRN47ohLc2K+nJfU1XZ/w2rPpqQnYgoB
	ZcozIkMhvkFxKY/IW6BzIwoAj3Fx7nt82PEa2kIFVDi8gSMQIYx6J7T3177Df8ZN1ESDpW
	ALIqyfAOLlR3ud2zKSxXE13YUEKtjWw=
X-MC-Unique: A6VT-Y_FOmK3YvPx4rqxCA-1
From: Florian Weimer <fweimer@redhat.com>
To: "Andy Lutomirski" <luto@kernel.org>
Cc: linux-arch@vger.kernel.org,  "Linux API" <linux-api@vger.kernel.org>,
  linux-x86_64@vger.kernel.org,  kernel-hardening@lists.openwall.com,
  linux-mm@kvack.org,  "the arch/x86 maintainers" <x86@kernel.org>,
  musl@lists.openwall.com,  "Dave Hansen via Libc-alpha"
 <libc-alpha@sourceware.org>,  "Linux Kernel Mailing List"
 <linux-kernel@vger.kernel.org>,  "Dave Hansen" <dave.hansen@intel.com>,
  "Kees Cook" <keescook@chromium.org>,  "Andrei Vagin" <avagin@gmail.com>
Subject: Re: [PATCH v3 2/3] selftests/x86/Makefile: Support per-target
 $(LIBS) configuration
References: <3a1c8280967b491bf6917a18fbff6c9b52e8df24.1641398395.git.fweimer@redhat.com>
	<54ae0e1f8928160c1c4120263ea21c8133aa3ec4.1641398395.git.fweimer@redhat.com>
	<034075bd-aac5-9b97-6d09-02d9dd658a0b@kernel.org>
	<87lezjxpnc.fsf@oldenburg.str.redhat.com>
	<5a4f01f4-cd16-47dd-880b-dcfb7ec5daeb@www.fastmail.com>
Date: Fri, 14 Jan 2022 14:28:25 +0100
In-Reply-To: <5a4f01f4-cd16-47dd-880b-dcfb7ec5daeb@www.fastmail.com> (Andy
	Lutomirski's message of "Thu, 13 Jan 2022 18:34:20 -0800")
Message-ID: <87wnj2tpja.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16

* Andy Lutomirski:

> On Thu, Jan 13, 2022, at 2:00 PM, Florian Weimer wrote:
>> * Andy Lutomirski:
>>
>>> On 1/5/22 08:03, Florian Weimer wrote:
>>>> And avoid compiling PCHs by accident.
>>>> 
>>>
>>> The patch seems fine, but I can't make heads or tails of the
>>> $SUBJECT. Can you help me?
>>
>> What about this?
>>
>> selftests/x86/Makefile: Set linked libraries using $(LIBS)
>>
>> I guess that it's possible to use make features to set this per target
>> isn't important.
>
> I think that's actually important -- it's nice to explain to make
> dummies (e.g. me) what the purpose is is.  I assume it's so that a
> given test can override the libraries.  Also, you've conflated two
> different changes into one patch: removal of .h and addition of LIBS.

Do you want me to split this further into two commits?

  selftests/x86/Makefile: Per-target configuration of linked libraries

  Targets can set $(LIBS) to specify a different set of libraries than the
  defaults (or no libraries at all).

And:

  selftests/x86/Makefile: Do not pass header files as compiler inputs

  Filtering out .h files avoids accidentally creating a precompiled
  header.

I didn't want to game commit metrics.

Thanks,
Florian

