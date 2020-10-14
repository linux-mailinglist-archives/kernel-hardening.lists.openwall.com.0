Return-Path: <kernel-hardening-return-20201-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 6234728E600
	for <lists+kernel-hardening@lfdr.de>; Wed, 14 Oct 2020 20:08:06 +0200 (CEST)
Received: (qmail 24535 invoked by uid 550); 14 Oct 2020 18:07:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 24498 invoked from network); 14 Oct 2020 18:07:58 -0000
Date: Thu, 15 Oct 2020 05:07:12 +1100 (AEDT)
From: James Morris <jmorris@namei.org>
To: =?ISO-8859-15?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
cc: linux-kernel@vger.kernel.org, "Serge E . Hallyn" <serge@hallyn.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Richard Weinberger <richard@nod.at>,
        Andy Lutomirski <luto@amacapital.net>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Casey Schaufler <casey@schaufler-ca.com>, Jann Horn <jannh@google.com>,
        Jeff Dike <jdike@addtoit.com>, Jonathan Corbet <corbet@lwn.net>,
        Kees Cook <keescook@chromium.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>,
        kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-security-module@vger.kernel.org, x86@kernel.org,
        =?ISO-8859-15?Q?Micka=EBl_Sala=FCn?= <mic@linux.microsoft.com>
Subject: Re: [PATCH v21 07/12] landlock: Support filesystem access-control
In-Reply-To: <20201008153103.1155388-8-mic@digikod.net>
Message-ID: <alpine.LRH.2.21.2010150504360.26012@namei.org>
References: <20201008153103.1155388-1-mic@digikod.net> <20201008153103.1155388-8-mic@digikod.net>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1665246916-928235661-1602698835=:26012"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1665246916-928235661-1602698835=:26012
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 8 Oct 2020, Mickaël Salaün wrote:

> +config ARCH_EPHEMERAL_STATES
> +	def_bool n
> +	help
> +	  An arch should select this symbol if it does not keep an internal kernel
> +	  state for kernel objects such as inodes, but instead relies on something
> +	  else (e.g. the host kernel for an UML kernel).
> +

This is used to disable Landlock for UML, correct? I wonder if it could be 
more specific: "ephemeral states" is a very broad term.

How about something like ARCH_OWN_INODES ?


-- 
James Morris
<jmorris@namei.org>

--1665246916-928235661-1602698835=:26012--
