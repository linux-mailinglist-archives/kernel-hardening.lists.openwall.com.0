Return-Path: <kernel-hardening-return-21068-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 6BA5234A07C
	for <lists+kernel-hardening@lfdr.de>; Fri, 26 Mar 2021 05:31:13 +0100 (CET)
Received: (qmail 9960 invoked by uid 550); 26 Mar 2021 04:31:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 9940 invoked from network); 26 Mar 2021 04:31:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=35XopTC+7WOzIQnHzWXImRYQHw0CHWkdoXHcf/+9Onk=;
        b=FuXqSLOY5UJibY4x5cy44xNCqVYXhs/QB8SAK6Ph5plXJluUdlmzkl2vYUhpV/m3iz
         fBwsgAxyhUwk4l2OzfotcXS7ilTz5vz/4D0pRkceuJfu6MDHX6kEBtNhBX+0z1Q+x9Rq
         gJAq/6u1b6zvaFaFWLn9VBJN47ayz/H6CG+SQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=35XopTC+7WOzIQnHzWXImRYQHw0CHWkdoXHcf/+9Onk=;
        b=J7nYVYKIHHOlfU84qomDC9RUs0MxpqAwrXxL79mGCQnC6/g3swJwVoqF0VlA3XaRLB
         ZxrXw9WuiRR6+XczJ4EO2cBA70Ak37Xf30R9/Jd9rrnQFx8SHg2BwQHuo6i12qbkfSOy
         mIBx/4W4mOQBtfVLRoZ349CNwBczWnD0RtgW7eBOwsajTFwckHu5GnSWGuKyYEUeZDsl
         2z2FqjmGpIz+vq7dbSejFPAZVpb6l+u0jke6ZW5rgfS9nfZ5nCbF0sYC75wMIAU3k8/u
         LVn0dJE1TLfjmH2bCegxaSrFpmHu9cbTomS9m6Uc+ylT/sMTmrwB9095f8h+qZMAaHyj
         uCOw==
X-Gm-Message-State: AOAM533NIJ2fxwc1b3swAyDRvMM2MpxoRvu5bRXjFU961yCqC3fBi5CB
	YC0fZCUUDOIsZehxiL1s8jwYYg==
X-Google-Smtp-Source: ABdhPJxJ4Uh8qq7VGivmsaxoe1yrWQkMSLzdjT7KyXHUDkthLjeUOIqUGrr9oa/zfMmenb3JnsesWA==
X-Received: by 2002:a62:7f86:0:b029:20a:a195:bb36 with SMTP id a128-20020a627f860000b029020aa195bb36mr11204021pfd.4.1616733055463;
        Thu, 25 Mar 2021 21:30:55 -0700 (PDT)
Date: Thu, 25 Mar 2021 21:30:53 -0700
From: Kees Cook <keescook@chromium.org>
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>,
	"Serge E . Hallyn" <serge@hallyn.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Casey Schaufler <casey@schaufler-ca.com>,
	David Howells <dhowells@redhat.com>, Jeff Dike <jdike@addtoit.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	Richard Weinberger <richard@nod.at>, Shuah Khan <shuah@kernel.org>,
	Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>,
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-security-module@vger.kernel.org, x86@kernel.org,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@linux.microsoft.com>
Subject: Re: [PATCH v31 10/12] selftests/landlock: Add user space tests
Message-ID: <202103252130.54C78E4@keescook>
References: <20210324191520.125779-1-mic@digikod.net>
 <20210324191520.125779-11-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210324191520.125779-11-mic@digikod.net>

On Wed, Mar 24, 2021 at 08:15:18PM +0100, Micka�l Sala�n wrote:
> From: Micka�l Sala�n <mic@linux.microsoft.com>
> 
> Test all Landlock system calls, ptrace hooks semantic and filesystem
> access-control with multiple layouts.
> 
> Test coverage for security/landlock/ is 93.6% of lines.  The code not
> covered only deals with internal kernel errors (e.g. memory allocation)
> and race conditions.
> 
> Cc: James Morris <jmorris@namei.org>
> Cc: Jann Horn <jannh@google.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Serge E. Hallyn <serge@hallyn.com>
> Cc: Shuah Khan <shuah@kernel.org>
> Signed-off-by: Micka�l Sala�n <mic@linux.microsoft.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
