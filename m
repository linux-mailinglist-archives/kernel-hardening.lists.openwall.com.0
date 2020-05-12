Return-Path: <kernel-hardening-return-18773-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 078841D0174
	for <lists+kernel-hardening@lfdr.de>; Wed, 13 May 2020 00:00:38 +0200 (CEST)
Received: (qmail 7474 invoked by uid 550); 12 May 2020 22:00:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 7453 invoked from network); 12 May 2020 22:00:32 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=+79i6CNjIBAM9t+ay0r61vFhVwB4nVo6+b6hHSQ4Fro=;
        b=Z/kjEVE7ijoWI2BF5GmEwAS2TVMlcwmQ3piX8x8xKGksNXYU58li/dNrs7QXxUoz7v
         WcPUKAYo4D+A3Vjcp2GxS4KQ9NMekKqFlUGG2RHxbDNQhoqZoY/xpwrNADyPpkJA3XMs
         ldEER+nN+tYegKNCyBNg4B35WbSpqTnd27sU0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=+79i6CNjIBAM9t+ay0r61vFhVwB4nVo6+b6hHSQ4Fro=;
        b=NuUmaQyeiI6S0r1ZpFaCcH0iAIMxK434lKOuYguvARmFCLcoVns+xBoYtdUxVYGnnO
         KZ6qag5aLSX8FhJjJC2oMlgWMPBP2hPOnHPKGAXf282aEomC4XzS5Ei3wIOGEOaTfTpZ
         /F13br/+F979VStTrTRzWP8tt/1bjMvikkxI4QdNIfdwjTVyNiKCDIKZa0jp7wIxpFMZ
         d2wWhej3tg3PQrrxAUxhjAQTrhlqx0LUqC/GB2cvF8syW14b2YcSkNvZtAZWApNZDReP
         hemEAPhHmEkagoF+kmlk2W6Q2YcUpWrDwoiWONDEInwGc5mPkDCoH6M1dq91eRR73FF0
         f+tw==
X-Gm-Message-State: AGi0PuY4VePeJvJSo2GfhDxhDfQGgcb8hp/Ms5pFNNhvnRfwkZ9fwh6Q
	kzEP1nKYr+zzbBjNuDIP7ouUTg==
X-Google-Smtp-Source: APiQypKLh7L5M6Z91bm0o0e2Xo3kz9JFIjZHGl9tokP3YDbmJ9kq2VCMFUVZ8H/2dEcftnriFb6DmQ==
X-Received: by 2002:a17:90a:6343:: with SMTP id v3mr31509425pjs.127.1589320820943;
        Tue, 12 May 2020 15:00:20 -0700 (PDT)
Date: Tue, 12 May 2020 15:00:19 -0700
From: Kees Cook <keescook@chromium.org>
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: linux-kernel@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@kernel.org>,
	Christian Heimes <christian@python.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Deven Bowers <deven.desai@linux.microsoft.com>,
	Eric Chiang <ericchiang@google.com>,
	Florian Weimer <fweimer@redhat.com>,
	James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>,
	Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
	Matthew Garrett <mjg59@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mickael.salaun@ssi.gouv.fr>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Philippe =?iso-8859-1?Q?Tr=E9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
	Scott Shell <scottsh@microsoft.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Shuah Khan <shuah@kernel.org>, Steve Dower <steve.dower@python.org>,
	Steve Grubb <sgrubb@redhat.com>,
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v5 5/6] doc: Add documentation for the
 fs.open_mayexec_enforce sysctl
Message-ID: <202005121459.158C3AE75@keescook>
References: <20200505153156.925111-1-mic@digikod.net>
 <20200505153156.925111-6-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200505153156.925111-6-mic@digikod.net>

On Tue, May 05, 2020 at 05:31:55PM +0200, Mickaël Salaün wrote:
> This sysctl enables to propagate executable permission to userspace
> thanks to the O_MAYEXEC flag.
> 
> Signed-off-by: Mickaël Salaün <mic@digikod.net>
> Reviewed-by: Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
> Cc: Aleksa Sarai <cyphar@cyphar.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Kees Cook <keescook@chromium.org>

I think this should be folded into the patch that adds the sysctl.

-- 
Kees Cook
