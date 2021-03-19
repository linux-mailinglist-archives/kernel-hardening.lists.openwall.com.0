Return-Path: <kernel-hardening-return-20988-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 5E9F234233E
	for <lists+kernel-hardening@lfdr.de>; Fri, 19 Mar 2021 18:26:44 +0100 (CET)
Received: (qmail 22110 invoked by uid 550); 19 Mar 2021 17:26:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 22087 invoked from network); 19 Mar 2021 17:26:38 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=G2ciI+8gLo1fSwlXD2q75g0c52yk/hMrZ0yweTlh3Wk=;
        b=VcZIRP1tPwWzWYflvDs2QtRdxoWgthJmMjpQFcvI0cw/Oi8U3fDykMwMJHUCRgLwLN
         IHz3cdgeMpGlUNdsWBkf889IaBIr31ob91+6VjKlBUZbqbRwigbvyhVbfasbWmvR5lSa
         t3CWNSy3svupvHUJAS0mJ7ozPSUoiXCBicW70=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=G2ciI+8gLo1fSwlXD2q75g0c52yk/hMrZ0yweTlh3Wk=;
        b=gKfO1MS25RCL4DKEdhf4jpsiPzOWCqy40A+5wbSWDjdK84axIR2zaGADMwmMTMWmwn
         f+DmJn+twNdjMgjih05a4K9uJc0p6vA659Gg9zBYuVHGUN9lo3iXMp4iXOQudOMkjtyB
         vTwQ/38pXAYOvphRaEpK0DSlGXBgFdXuwN/ciSsa6b9vzMjA9BSWYBS7eUG3DuuoOcD1
         FpwegEBA1GWBHY3rTW2bGiJCfEH7IJdXm5sHkMT/OmVMOFBIuJVpf3lQIU/BtD5SvUfO
         DI3Vu+HWQ3cjsIyg3YJCV4aAsmMUp1Cyh9Gmvz8BU9NvQVcxjCyjrSZDM3/Zvd1jtLN2
         S0YQ==
X-Gm-Message-State: AOAM5316jKUbKg7q4zRstl2BF5JSbszSiQmbY20HWhnlP1bcjAGrt3uz
	dXScJwT561QK0hoOPiVYu4lvgw==
X-Google-Smtp-Source: ABdhPJzOKA9F+yXMnxyRNFmJt9DfXWSRK0fZPjEUoInFJxIRVNA3uwgGEl8gbZRw8mSeGT/QAF3Jqw==
X-Received: by 2002:a17:90a:a403:: with SMTP id y3mr10703577pjp.227.1616174786403;
        Fri, 19 Mar 2021 10:26:26 -0700 (PDT)
Date: Fri, 19 Mar 2021 10:26:25 -0700
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
Subject: Re: [PATCH v30 11/12] samples/landlock: Add a sandbox manager example
Message-ID: <202103191026.E2F74F8D9@keescook>
References: <20210316204252.427806-1-mic@digikod.net>
 <20210316204252.427806-12-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210316204252.427806-12-mic@digikod.net>

On Tue, Mar 16, 2021 at 09:42:51PM +0100, Micka�l Sala�n wrote:
> From: Micka�l Sala�n <mic@linux.microsoft.com>
> 
> Add a basic sandbox tool to launch a command which can only access a
> list of file hierarchies in a read-only or read-write way.
> 
> Cc: James Morris <jmorris@namei.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Serge E. Hallyn <serge@hallyn.com>
> Signed-off-by: Micka�l Sala�n <mic@linux.microsoft.com>

I'm very happy to see any example!

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
