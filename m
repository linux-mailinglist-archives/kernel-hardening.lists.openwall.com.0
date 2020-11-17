Return-Path: <kernel-hardening-return-20405-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 44D492B595F
	for <lists+kernel-hardening@lfdr.de>; Tue, 17 Nov 2020 06:38:27 +0100 (CET)
Received: (qmail 11391 invoked by uid 550); 17 Nov 2020 05:38:20 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 11359 invoked from network); 17 Nov 2020 05:38:19 -0000
Date: Tue, 17 Nov 2020 16:37:35 +1100 (AEDT)
From: James Morris <jmorris@namei.org>
To: =?ISO-8859-15?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
cc: "Serge E . Hallyn" <serge@hallyn.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Andy Lutomirski <luto@amacapital.net>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Casey Schaufler <casey@schaufler-ca.com>, Jann Horn <jannh@google.com>,
        Jeff Dike <jdike@addtoit.com>, Jonathan Corbet <corbet@lwn.net>,
        Kees Cook <keescook@chromium.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Richard Weinberger <richard@nod.at>, Shuah Khan <shuah@kernel.org>,
        Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>,
        kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-security-module@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH v24 00/12] Landlock LSM
In-Reply-To: <20201112205141.775752-1-mic@digikod.net>
Message-ID: <alpine.LRH.2.21.2011171635410.23193@namei.org>
References: <20201112205141.775752-1-mic@digikod.net>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1665246916-1723075868-1605591457=:23193"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1665246916-1723075868-1605591457=:23193
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 12 Nov 2020, Mickaël Salaün wrote:

> Hi,
> 
> This patch series simplifies the code, makes stacked access-control more
> consistent (from the user point of view), properly handles memory
> allocation errors, and adds more tests (covering layered ruleset corner
> cases).  Most of these changes were sent as a separate patch series:
> https://lore.kernel.org/lkml/20201111213442.434639-1-mic@digikod.net/
> 
> James and Jann, could you please take a look at the main changes
> (patches 2, 7 and 8)?

We definitely need more review on these changes that came in. I'll drop 
the previous patchset from my tree and wait until the latest code is fully 
reviewed.

Fundamental locking issues and similar should be worked out before 
submitting for mainline merge.

-- 
James Morris
<jmorris@namei.org>

--1665246916-1723075868-1605591457=:23193--
