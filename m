Return-Path: <kernel-hardening-return-21065-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id B97A53482EE
	for <lists+kernel-hardening@lfdr.de>; Wed, 24 Mar 2021 21:35:02 +0100 (CET)
Received: (qmail 28516 invoked by uid 550); 24 Mar 2021 20:34:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 28496 invoked from network); 24 Mar 2021 20:34:55 -0000
Date: Thu, 25 Mar 2021 07:31:47 +1100 (AEDT)
From: James Morris <jmorris@namei.org>
To: =?ISO-8859-15?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
cc: Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, 
    "Serge E . Hallyn" <serge@hallyn.com>, Al Viro <viro@zeniv.linux.org.uk>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    Andy Lutomirski <luto@amacapital.net>, 
    Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
    Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>, 
    David Howells <dhowells@redhat.com>, Jeff Dike <jdike@addtoit.com>, 
    Jonathan Corbet <corbet@lwn.net>, Michael Kerrisk <mtk.manpages@gmail.com>, 
    Richard Weinberger <richard@nod.at>, Shuah Khan <shuah@kernel.org>, 
    Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>, 
    kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, 
    linux-arch@vger.kernel.org, linux-doc@vger.kernel.org, 
    linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
    linux-kselftest@vger.kernel.org, linux-security-module@vger.kernel.org, 
    x86@kernel.org, 
    =?ISO-8859-15?Q?Micka=EBl_Sala=FCn?= <mic@linux.microsoft.com>
Subject: Re: [PATCH v30 02/12] landlock: Add ruleset and domain management
In-Reply-To: <acda4be1-4076-a31d-fcfd-27764dd598c8@digikod.net>
Message-ID: <c9dc8adb-7fab-14a1-a658-40b288419fdf@namei.org>
References: <20210316204252.427806-1-mic@digikod.net> <20210316204252.427806-3-mic@digikod.net> <202103191114.C87C5E2B69@keescook> <acda4be1-4076-a31d-fcfd-27764dd598c8@digikod.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1665246916-200031253-1616617907=:3442585"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1665246916-200031253-1616617907=:3442585
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT

On Fri, 19 Mar 2021, Micka�l Sala�n wrote:

> 
> >> Cc: Kees Cook <keescook@chromium.org>
> >> Signed-off-by: Micka�l Sala�n <mic@linux.microsoft.com>
> >> Acked-by: Serge Hallyn <serge@hallyn.com>
> >> Link: https://lore.kernel.org/r/20210316204252.427806-3-mic@digikod.net
> > 
> > (Aside: you appear to be self-adding your Link: tags -- AIUI, this is
> > normally done by whoever pulls your series. I've only seen Link: tags
> > added when needing to refer to something else not included in the
> > series.)
> 
> It is an insurance to not lose history. :)

How will history be lost? The code is in the repo and discussions can 
easily be found by searching for subjects or message IDs.

Is anyone else doing this self linking?

-- 
James Morris
<jmorris@namei.org>

--1665246916-200031253-1616617907=:3442585--
