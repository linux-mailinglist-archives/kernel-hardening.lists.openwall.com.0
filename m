Return-Path: <kernel-hardening-return-18809-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 580381D3DA9
	for <lists+kernel-hardening@lfdr.de>; Thu, 14 May 2020 21:37:37 +0200 (CEST)
Received: (qmail 1691 invoked by uid 550); 14 May 2020 19:37:31 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1650 invoked from network); 14 May 2020 19:37:30 -0000
Date: Fri, 15 May 2020 05:37:03 +1000 (AEST)
From: James Morris <jmorris@namei.org>
To: =?ISO-8859-15?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
cc: Casey Schaufler <casey@schaufler-ca.com>, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andy Lutomirski <luto@amacapital.net>, Arnd Bergmann <arnd@arndb.de>,
        Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
        Kees Cook <keescook@chromium.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        =?ISO-8859-15?Q?Micka=EBl_Sala=FCn?= <mickael.salaun@ssi.gouv.fr>,
        "Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>,
        Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>,
        kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-security-module@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v17 05/10] fs,landlock: Support filesystem
 access-control
In-Reply-To: <2561827e-020c-9a76-98ae-9514904c69f9@digikod.net>
Message-ID: <alpine.LRH.2.21.2005150536440.7929@namei.org>
References: <20200511192156.1618284-1-mic@digikod.net> <20200511192156.1618284-6-mic@digikod.net> <alpine.LRH.2.21.2005141335280.30052@namei.org> <c159d845-6108-4b67-6527-405589fa5382@digikod.net> <alpine.LRH.2.21.2005150329580.26489@namei.org>
 <2561827e-020c-9a76-98ae-9514904c69f9@digikod.net>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1665246916-72433049-1589485024=:7929"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1665246916-72433049-1589485024=:7929
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Thu, 14 May 2020, Mickaël Salaün wrote:

> > fsnotify is not an LSM.
> 
> Yes, so I'll need to add a new LSM hook for this (release) call, right?

Unless an existing one will work.

-- 
James Morris
<jmorris@namei.org>

--1665246916-72433049-1589485024=:7929--
