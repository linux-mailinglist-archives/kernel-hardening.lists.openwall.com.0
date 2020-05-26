Return-Path: <kernel-hardening-return-18784-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 1A8351D254E
	for <lists+kernel-hardening@lfdr.de>; Thu, 14 May 2020 05:10:04 +0200 (CEST)
Received: (qmail 7989 invoked by uid 550); 14 May 2020 03:09:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 7954 invoked from network); 14 May 2020 03:09:58 -0000
Date: Thu, 14 May 2020 13:09:32 +1000 (AEST)
From: James Morris <jmorris@namei.org>
To: =?ISO-8859-15?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Andy Lutomirski <luto@amacapital.net>, Arnd Bergmann <arnd@arndb.de>,
        Casey Schaufler <casey@schaufler-ca.com>, Jann Horn <jannh@google.com>,
        Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        =?ISO-8859-15?Q?Micka=EBl_Sala=FCn?= <mickael.salaun@ssi.gouv.fr>,
        "Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>,
        Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>,
        kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-security-module@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v17 02/10] landlock: Add ruleset and domain management
In-Reply-To: <20200511192156.1618284-3-mic@digikod.net>
Message-ID: <alpine.LRH.2.21.2005141302330.30052@namei.org>
References: <20200511192156.1618284-1-mic@digikod.net> <20200511192156.1618284-3-mic@digikod.net>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1665246916-408680353-1589425772=:30052"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1665246916-408680353-1589425772=:30052
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Mon, 11 May 2020, Mickaël Salaün wrote:

> + * .. warning::
> + *
> + *   It is currently not possible to restrict some file-related actions
> + *   accessible through these syscall families: :manpage:`chdir(2)`,
> + *   :manpage:`truncate(2)`, :manpage:`stat(2)`, :manpage:`flock(2)`,
> + *   :manpage:`chmod(2)`, :manpage:`chown(2)`, :manpage:`setxattr(2)`,
> + *   :manpage:`ioctl(2)`, :manpage:`fcntl(2)`.
> + *   Future Landlock evolutions will enable to restrict them.

I have to wonder how useful Landlock will be without more coverage per 
the above.

It would be helpful if you could outline a threat model for this initial 
version, so people can get an idea of what kind of useful protection may
be gained from it.

Are there any distros or other major users who are planning on enabling or 
at least investigating Landlock?

Do you have any examples of a practical application of this scheme?



-- 
James Morris
<jmorris@namei.org>

--1665246916-408680353-1589425772=:30052--
