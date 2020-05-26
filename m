Return-Path: <kernel-hardening-return-18785-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 0BE961D2574
	for <lists+kernel-hardening@lfdr.de>; Thu, 14 May 2020 05:38:20 +0200 (CEST)
Received: (qmail 30621 invoked by uid 550); 14 May 2020 03:38:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 30585 invoked from network); 14 May 2020 03:38:14 -0000
Date: Thu, 14 May 2020 13:37:49 +1000 (AEST)
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
Subject: Re: [PATCH v17 05/10] fs,landlock: Support filesystem
 access-control
In-Reply-To: <20200511192156.1618284-6-mic@digikod.net>
Message-ID: <alpine.LRH.2.21.2005141335280.30052@namei.org>
References: <20200511192156.1618284-1-mic@digikod.net> <20200511192156.1618284-6-mic@digikod.net>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1665246916-1014880157-1589427470=:30052"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1665246916-1014880157-1589427470=:30052
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Mon, 11 May 2020, Mickaël Salaün wrote:


> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 45cc10cdf6dd..2276642f8e05 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1517,6 +1517,11 @@ struct super_block {
>  	/* Pending fsnotify inode refs */
>  	atomic_long_t s_fsnotify_inode_refs;
>  
> +#ifdef CONFIG_SECURITY_LANDLOCK
> +	/* References to Landlock underlying objects */
> +	atomic_long_t s_landlock_inode_refs;
> +#endif
> +

This needs to be converted to the LSM API via superblock blob stacking.

See Casey's old patch: 
https://lore.kernel.org/linux-security-module/20190829232935.7099-2-casey@schaufler-ca.com/



-- 
James Morris
<jmorris@namei.org>

--1665246916-1014880157-1589427470=:30052--
