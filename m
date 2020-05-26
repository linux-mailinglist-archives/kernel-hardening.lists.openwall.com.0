Return-Path: <kernel-hardening-return-18703-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 7A35E1C1F14
	for <lists+kernel-hardening@lfdr.de>; Fri,  1 May 2020 22:59:45 +0200 (CEST)
Received: (qmail 15849 invoked by uid 550); 1 May 2020 20:59:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 1868 invoked from network); 1 May 2020 20:36:21 -0000
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2E03E20B717B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1588365369;
	bh=cyxau+BJRB8pNdZIKeMiXqeTQ9iFyycCE0oPRNjr7fo=;
	h=From:Subject:To:Cc:References:Date:In-Reply-To:From;
	b=FX9Weop6wlrng0/8hGiSCdvgxdFkS+Z1/o9Fe4MU2xRO9DBB4XKEBWREI7DJ2vIxB
	 mVkhUIl3E7l3C9Q95xLWCgPgC+JrcQHOEv14018rn+OSDBX0RpMUzq2jsbqtw2LFQW
	 qxY32+/8JumhhaegNkX6DhGnshtSVVHR7REqYTnw=
From: Deven Bowers <deven.desai@linux.microsoft.com>
Subject: Re: [PATCH v4 1/5] fs: Add support for an O_MAYEXEC flag on
 openat2(2)
To: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>,
 linux-kernel@vger.kernel.org
Cc: Aleksa Sarai <cyphar@cyphar.com>, Alexei Starovoitov <ast@kernel.org>,
 Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>,
 Christian Heimes <christian@python.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Eric Chiang <ericchiang@google.com>,
 Florian Weimer <fweimer@redhat.com>, James Morris <jmorris@namei.org>,
 Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>,
 Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>,
 Matthew Garrett <mjg59@google.com>, Matthew Wilcox <willy@infradead.org>,
 Michael Kerrisk <mtk.manpages@gmail.com>,
 =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mickael.salaun@ssi.gouv.fr>,
 Mimi Zohar <zohar@linux.ibm.com>,
 =?UTF-8?Q?Philippe_Tr=c3=a9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
 Scott Shell <scottsh@microsoft.com>,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Shuah Khan <shuah@kernel.org>, Steve Dower <steve.dower@python.org>,
 Steve Grubb <sgrubb@redhat.com>,
 Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
 Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
 kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20200430132320.699508-1-mic@digikod.net>
 <20200430132320.699508-2-mic@digikod.net>
Message-ID: <12e3c9f0-a419-53a9-f404-7ce206709fe4@linux.microsoft.com>
Date: Fri, 1 May 2020 13:36:08 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200430132320.699508-2-mic@digikod.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit



On 4/30/2020 6:23 AM, Mickaël Salaün wrote:
> When the O_MAYEXEC flag is passed, openat2(2) may be subject to
> additional restrictions depending on a security policy managed by the
> kernel through a sysctl or implemented by an LSM thanks to the
> inode_permission hook. 
> This new flag is ignored by open(2) and openat(2).

Reviewed-by: Deven Bowers <deven.desai@linux.microsoft.com>
