Return-Path: <kernel-hardening-return-20750-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 8290D317046
	for <lists+kernel-hardening@lfdr.de>; Wed, 10 Feb 2021 20:36:44 +0100 (CET)
Received: (qmail 30323 invoked by uid 550); 10 Feb 2021 19:36:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 30291 invoked from network); 10 Feb 2021 19:36:36 -0000
Date: Wed, 10 Feb 2021 13:36:24 -0600
From: "Serge E. Hallyn" <serge@hallyn.com>
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>,
	"Serge E . Hallyn" <serge@hallyn.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Jeff Dike <jdike@addtoit.com>, Jonathan Corbet <corbet@lwn.net>,
	Kees Cook <keescook@chromium.org>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	Richard Weinberger <richard@nod.at>, Shuah Khan <shuah@kernel.org>,
	Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>,
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-security-module@vger.kernel.org, x86@kernel.org,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@linux.microsoft.com>
Subject: Re: [PATCH v28 07/12] landlock: Support filesystem access-control
Message-ID: <20210210193624.GA29893@mail.hallyn.com>
References: <20210202162710.657398-1-mic@digikod.net>
 <20210202162710.657398-8-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210202162710.657398-8-mic@digikod.net>
User-Agent: Mutt/1.9.4 (2018-02-28)

On Tue, Feb 02, 2021 at 05:27:05PM +0100, Micka�l Sala�n wrote:
> From: Micka�l Sala�n <mic@linux.microsoft.com>
> 
> Thanks to the Landlock objects and ruleset, it is possible to identify
> inodes according to a process's domain.  To enable an unprivileged

This throws me off a bit.  "identify inodes according to a process's domain".
What exactly does it mean?  "identify" how ?

> process to express a file hierarchy, it first needs to open a directory
> (or a file) and pass this file descriptor to the kernel through
> landlock_add_rule(2).  When checking if a file access request is
> allowed, we walk from the requested dentry to the real root, following
> the different mount layers.  The access to each "tagged" inodes are
> collected according to their rule layer level, and ANDed to create
> access to the requested file hierarchy.  This makes possible to identify
> a lot of files without tagging every inodes nor modifying the
> filesystem, while still following the view and understanding the user
> has from the filesystem.
> 
> Add a new ARCH_EPHEMERAL_INODES for UML because it currently does not
> keep the same struct inodes for the same inodes whereas these inodes are
> in use.

-serge
