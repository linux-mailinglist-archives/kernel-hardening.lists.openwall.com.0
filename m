Return-Path: <kernel-hardening-return-21183-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 2FA693591AF
	for <lists+kernel-hardening@lfdr.de>; Fri,  9 Apr 2021 03:52:35 +0200 (CEST)
Received: (qmail 26500 invoked by uid 550); 9 Apr 2021 01:52:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 26468 invoked from network); 9 Apr 2021 01:52:27 -0000
Date: Fri, 9 Apr 2021 11:48:49 +1000 (AEST)
From: James Morris <jmorris@namei.org>
To: =?ISO-8859-15?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
cc: Jann Horn <jannh@google.com>, "Serge E . Hallyn" <serge@hallyn.com>, 
    Al Viro <viro@zeniv.linux.org.uk>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    Andy Lutomirski <luto@amacapital.net>, 
    Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
    Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>, 
    David Howells <dhowells@redhat.com>, Jeff Dike <jdike@addtoit.com>, 
    Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, 
    Michael Kerrisk <mtk.manpages@gmail.com>, 
    Richard Weinberger <richard@nod.at>, Shuah Khan <shuah@kernel.org>, 
    Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>, 
    kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, 
    linux-arch@vger.kernel.org, linux-doc@vger.kernel.org, 
    linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
    linux-kselftest@vger.kernel.org, linux-security-module@vger.kernel.org, 
    x86@kernel.org
Subject: Re: [PATCH v33 00/12] Landlock LSM
In-Reply-To: <20210407160726.542794-1-mic@digikod.net>
Message-ID: <d7f25c43-8bea-2640-292b-df2fcceae428@namei.org>
References: <20210407160726.542794-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

I've added this to my tree at:

git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git landlock_lsm_v33

and merged that into the next-testing branch which is pulled into Linux 
next.


-- 
James Morris
<jmorris@namei.org>

