Return-Path: <kernel-hardening-return-18142-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id CF0B8188B0A
	for <lists+kernel-hardening@lfdr.de>; Tue, 17 Mar 2020 17:48:02 +0100 (CET)
Received: (qmail 3842 invoked by uid 550); 17 Mar 2020 16:47:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3810 invoked from network); 17 Mar 2020 16:47:56 -0000
Date: Tue, 17 Mar 2020 16:47:09 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
	Arnd Bergmann <arnd@arndb.de>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	James Morris <jmorris@namei.org>, Jann Horn <jann@thejh.net>,
	Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mickael.salaun@ssi.gouv.fr>,
	"Serge E . Hallyn" <serge@hallyn.com>,
	Shuah Khan <shuah@kernel.org>,
	Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>,
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-security-module@vger.kernel.org, x86@kernel.org
Subject: Re: [RFC PATCH v14 06/10] landlock: Add syscall implementation
Message-ID: <20200317164709.GA23230@ZenIV.linux.org.uk>
References: <20200224160215.4136-1-mic@digikod.net>
 <20200224160215.4136-7-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200224160215.4136-7-mic@digikod.net>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Mon, Feb 24, 2020 at 05:02:11PM +0100, Mickaël Salaün wrote:

> +static int get_path_from_fd(u64 fd, struct path *path)

> +	/*
> +	 * Only allows O_PATH FD: enable to restrict ambiant (FS) accesses
> +	 * without requiring to open and risk leaking or misuing a FD.  Accept
> +	 * removed, but still open directory (S_DEAD).
> +	 */
> +	if (!(f.file->f_mode & FMODE_PATH) || !f.file->f_path.mnt ||
					      ^^^^^^^^^^^^^^^^^^^
Could you explain what that one had been be about?  The underlined
subexpression is always false; was that supposed to check some
condition and if so, which one?
