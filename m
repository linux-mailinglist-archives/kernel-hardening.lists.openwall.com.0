Return-Path: <kernel-hardening-return-21064-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 8FDEB3481FE
	for <lists+kernel-hardening@lfdr.de>; Wed, 24 Mar 2021 20:34:01 +0100 (CET)
Received: (qmail 30350 invoked by uid 550); 24 Mar 2021 19:33:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 30330 invoked from network); 24 Mar 2021 19:33:54 -0000
Subject: Re: [PATCH v31 01/12] landlock: Add object management
To: James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>,
 "Serge E . Hallyn" <serge@hallyn.com>, Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
 Andrew Morton <akpm@linux-foundation.org>,
 Andy Lutomirski <luto@amacapital.net>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, Arnd Bergmann
 <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>,
 David Howells <dhowells@redhat.com>, Jeff Dike <jdike@addtoit.com>,
 Jonathan Corbet <corbet@lwn.net>, Michael Kerrisk <mtk.manpages@gmail.com>,
 Richard Weinberger <richard@nod.at>, Shuah Khan <shuah@kernel.org>,
 Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>,
 kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-security-module@vger.kernel.org,
 x86@kernel.org, =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?=
 <mic@linux.microsoft.com>
References: <20210324191520.125779-1-mic@digikod.net>
 <20210324191520.125779-2-mic@digikod.net>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <3908b240-8a4b-9bd7-bb5f-b59eaed7cb1f@digikod.net>
Date: Wed, 24 Mar 2021 20:34:19 +0100
User-Agent:
MIME-Version: 1.0
In-Reply-To: <20210324191520.125779-2-mic@digikod.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit


On 24/03/2021 20:15, Mickaël Salaün wrote:
[...]
> diff --git a/security/landlock/object.h b/security/landlock/object.h
> new file mode 100644
> index 000000000000..3e5d5b6941c3
> --- /dev/null
> +++ b/security/landlock/object.h
> @@ -0,0 +1,91 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Landlock LSM - Object management
> + *
> + * Copyright © 2016-2020 Mickaël Salaün <mic@digikod.net>
> + * Copyright © 2018-2020 ANSSI
> + */
> +
> +#ifndef _SECURITY_LANDLOCK_OBJECT_H
> +#define _SECURITY_LANDLOCK_OBJECT_H
> +
> +#include <linux/compiler_types.h>
> +#include <linux/refcount.h>
> +#include <linux/spinlock.h>
> +
> +struct landlock_object;
> +
> +/**
> + * struct landlock_object_underops - Operations on an underlying object
> + */
> +struct landlock_object_underops {
> +	/**
> +	 * @release: Releases the underlying object (e.g. iput() for an inode).
> +	 */
> +	void (*release)(struct landlock_object *const object)
> +		__releases(object->lock);
> +};
> +
> +/**
> + * struct landlock_object - Security blob tied to a kernel object
> + *
> + * The goal of this structure is to enable to tie a set of ephemeral access
> + * rights (pertaining to different domains) to a kernel object (e.g an inode)
> + * in a safe way.  This implies to handle concurrent use and modification.
> + *
> + * The lifetime of a &struct landlock_object depends of the rules referring to

You should read "depends on"…
