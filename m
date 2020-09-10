Return-Path: <kernel-hardening-return-19853-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 254D3264D60
	for <lists+kernel-hardening@lfdr.de>; Thu, 10 Sep 2020 20:41:35 +0200 (CEST)
Received: (qmail 3963 invoked by uid 550); 10 Sep 2020 18:41:29 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3943 invoked from network); 10 Sep 2020 18:41:29 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=SVMzvLSxHR4YQ7P25QME/n/EPljnU8bFV5nCGi/Qx44=; b=nuYXudjIOEKrlWaHHeZyFkpQS2
	wwcSZk0K6RlZlYBKUfyyPTDC6keEIXtAj5sR8cW6zZPcdJenYgtUpeSbsI/A6IqqzX7UwTm3cLU54
	7NZMZ6oZ/ZnahlBszJVIHI9ljDrIk4+VtqAzRV0N6OKnwAuaXO690x5NJgJOP3DQUNmKZAKgzJFs3
	oOAuecoKw+/7+aDwFjfO1p5WdkwiGcJj2QfkXDILLlWhYQbcDm5GVAFw3XMqEGiWENVP58kACpBub
	AqdkMeObcGfzgvZvocq6uoEzPznHnpjFWZBJFcgewoWlHp6VxFSUUTNnxJtmcgtpnGt38QNE919lg
	kgp2qS6Q==;
Date: Thu, 10 Sep 2020 19:40:33 +0100
From: Matthew Wilcox <willy@infradead.org>
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: Mimi Zohar <zohar@linux.ibm.com>, linux-kernel@vger.kernel.org,
	Aleksa Sarai <cyphar@cyphar.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	Christian Heimes <christian@python.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Deven Bowers <deven.desai@linux.microsoft.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Eric Chiang <ericchiang@google.com>,
	Florian Weimer <fweimer@redhat.com>,
	James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>,
	Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
	Kees Cook <keescook@chromium.org>,
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
	Matthew Garrett <mjg59@google.com>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Philippe =?iso-8859-1?Q?Tr=E9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
	Scott Shell <scottsh@microsoft.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Shuah Khan <shuah@kernel.org>, Steve Dower <steve.dower@python.org>,
	Steve Grubb <sgrubb@redhat.com>,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	Thibaut Sautereau <thibaut.sautereau@clip-os.org>,
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH v9 0/3] Add introspect_access(2) (was O_MAYEXEC)
Message-ID: <20200910184033.GX6583@casper.infradead.org>
References: <20200910164612.114215-1-mic@digikod.net>
 <20200910170424.GU6583@casper.infradead.org>
 <f6e2358c-8e5e-e688-3e66-2cdd943e360e@digikod.net>
 <a48145770780d36e90f28f1526805a7292eb74f6.camel@linux.ibm.com>
 <880bb4ee-89a2-b9b0-747b-0f779ceda995@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <880bb4ee-89a2-b9b0-747b-0f779ceda995@digikod.net>

On Thu, Sep 10, 2020 at 08:38:21PM +0200, Mickaël Salaün wrote:
> There is also the use case of noexec mounts and file permissions. From
> user space point of view, it doesn't matter which kernel component is in
> charge of defining the policy. The syscall should then not be tied with
> a verification/integrity/signature/appraisal vocabulary, but simply an
> access control one.

permission()?
