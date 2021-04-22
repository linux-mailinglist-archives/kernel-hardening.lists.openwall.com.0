Return-Path: <kernel-hardening-return-21218-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id F4207368744
	for <lists+kernel-hardening@lfdr.de>; Thu, 22 Apr 2021 21:36:05 +0200 (CEST)
Received: (qmail 31956 invoked by uid 550); 22 Apr 2021 19:35:58 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 31910 invoked from network); 22 Apr 2021 19:35:58 -0000
Date: Fri, 23 Apr 2021 05:31:53 +1000 (AEST)
From: James Morris <jmorris@namei.org>
To: =?ISO-8859-15?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
cc: Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>, 
    "Serge E . Hallyn" <serge@hallyn.com>, Al Viro <viro@zeniv.linux.org.uk>, 
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
    x86@kernel.org
Subject: Re: [PATCH v34 00/13] Landlock LSM
In-Reply-To: <20210422154123.13086-1-mic@digikod.net>
Message-ID: <9c775578-627c-e682-873a-ec7b763a7fcd@namei.org>
References: <20210422154123.13086-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1665246916-1978797647-1619119913=:395662"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1665246916-1978797647-1619119913=:395662
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 22 Apr 2021, Mickaël Salaün wrote:

> Hi,
> 
> This updated patch series adds a new patch on top of the previous ones.
> It brings a new flag to landlock_create_ruleset(2) that enables
> efficient and simple backward compatibility checks for future evolutions
> of Landlock (e.g. new access-control rights).

Applied to git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git 
landlock_lsm_v34

and it replaces the v33 branch in next-testing.


-- 
James Morris
<jmorris@namei.org>

--1665246916-1978797647-1619119913=:395662--
