Return-Path: <kernel-hardening-return-19448-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 0C28922CE5B
	for <lists+kernel-hardening@lfdr.de>; Fri, 24 Jul 2020 21:07:14 +0200 (CEST)
Received: (qmail 11845 invoked by uid 550); 24 Jul 2020 19:07:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 11820 invoked from network); 24 Jul 2020 19:07:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=K8G3uUfjFyIFqzumteD+M4ru95c1HdblPJFim2YrrQc=;
        b=TfSU45ZHogt7OfiCyfzi5HJwQpXCaBErFgsxF/klcZOJNMbPluYAeuTkmfRF6PRP+0
         qPofpQo09XDEFAIwNso+qC8OWaCL1kuBdc7+u0M1UyUwDQ5AJ/kU0XQOgHjox31zMmoT
         9ZxZB7qMyGdjF6eSprG4nA/KMSTr4DssTwLWY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=K8G3uUfjFyIFqzumteD+M4ru95c1HdblPJFim2YrrQc=;
        b=LWKByss7Rchm0sAoHGSwrfAikIJ1qRAklDjfLyxfres7OLxYtTrHz5qDwix60uUEWf
         /0XLAhK5AqT3shvq4zo3EJSX00sA4sNPtIJzdDWsKsd3HXwnFMKy8fJf53Le7yU3OPey
         qvu5unuk3qihAug1T48LsywPhxkDia8ymXGGAH3luWs35JtrPhod6BEjLAcfhQXOAkbN
         DYuUBO9lvrfVyUdg2JWVXYoKHFBYrkBH7WyEkyaaKulA7Hf3QC6wqwHF382FD1vCWOXV
         03FjRI7gQdC56D50a4UsrKZRSkVJgI4BPlsPoYt/6dRMziTr6KRg0op2nV3RSU6LFC8r
         DXkA==
X-Gm-Message-State: AOAM531ibiora1nmE/FuPYHyN0ccD3wayyMdRvZTopj86acyBCn7Hihu
	ywbcogqv1qElTnrcG/daraB2CA==
X-Google-Smtp-Source: ABdhPJxWLS6tUsSp9/04gZtLp8coD/ZXXJGK3pPOo1Byk/QIqCexX4j1ko4JP8edtB5bCGcIbL9c1A==
X-Received: by 2002:a17:90a:158f:: with SMTP id m15mr6686628pja.93.1595617615136;
        Fri, 24 Jul 2020 12:06:55 -0700 (PDT)
Date: Fri, 24 Jul 2020 12:06:53 -0700
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@kernel.org>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	Christian Heimes <christian@python.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Deven Bowers <deven.desai@linux.microsoft.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Eric Chiang <ericchiang@google.com>,
	Florian Weimer <fweimer@redhat.com>,
	James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>,
	Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
	Matthew Garrett <mjg59@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Philippe =?iso-8859-1?Q?Tr=E9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
	Scott Shell <scottsh@microsoft.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Shuah Khan <shuah@kernel.org>, Steve Dower <steve.dower@python.org>,
	Steve Grubb <sgrubb@redhat.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Thibaut Sautereau <thibaut.sautereau@clip-os.org>,
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v7 0/7] Add support for O_MAYEXEC
Message-ID: <202007241205.751EBE7@keescook>
References: <20200723171227.446711-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200723171227.446711-1-mic@digikod.net>

I think this looks good now.

Andrew, since you're already carrying my exec clean-ups (repeated here
in patch 1-3), can you pick the rest of this series too?

Thanks!

-Kees

On Thu, Jul 23, 2020 at 07:12:20PM +0200, Micka�l Sala�n wrote:
> Hi,
> 
> This seventh patch series do not set __FMODE_EXEC for the sake of
> simplicity.  A notification feature could be added later if needed.  The
> handling of all file types is now well defined and tested: by default,
> when opening a path, access to a directory is denied (with EISDIR),
> access to a regular file depends on the sysctl policy, and access to
> other file types (i.e. fifo, device, socket) is denied if there is any
> enforced policy.  There is new tests covering all these cases (cf.
> test_file_types() ).
> 
> As requested by Mimi Zohar, I completed the series with one of her
> patches for IMA.  I also picked Kees Cook's patches to consolidate exec
> permission checking into do_filp_open()'s flow.
> 
> 
> # Goal of O_MAYEXEC
> 
> The goal of this patch series is to enable to control script execution
> with interpreters help.  A new O_MAYEXEC flag, usable through
> openat2(2), is added to enable userspace script interpreters to delegate
> to the kernel (and thus the system security policy) the permission to
> interpret/execute scripts or other files containing what can be seen as
> commands.
> 
> A simple system-wide security policy can be enforced by the system
> administrator through a sysctl configuration consistent with the mount
> points or the file access rights.  The documentation patch explains the
> prerequisites.
> 
> Furthermore, the security policy can also be delegated to an LSM, either
> a MAC system or an integrity system.  For instance, the new kernel
> MAY_OPENEXEC flag closes a major IMA measurement/appraisal interpreter
> integrity gap by bringing the ability to check the use of scripts [1].
> Other uses are expected, such as for magic-links [2], SGX integration
> [3], bpffs [4] or IPE [5].
> 
> 
> # Prerequisite of its use
> 
> Userspace needs to adapt to take advantage of this new feature.  For
> example, the PEP 578 [6] (Runtime Audit Hooks) enables Python 3.8 to be
> extended with policy enforcement points related to code interpretation,
> which can be used to align with the PowerShell audit features.
> Additional Python security improvements (e.g. a limited interpreter
> withou -c, stdin piping of code) are on their way [7].
> 
> 
> # Examples
> 
> The initial idea comes from CLIP OS 4 and the original implementation
> has been used for more than 12 years:
> https://github.com/clipos-archive/clipos4_doc
> Chrome OS has a similar approach:
> https://chromium.googlesource.com/chromiumos/docs/+/master/security/noexec_shell_scripts.md
> 
> Userland patches can be found here:
> https://github.com/clipos-archive/clipos4_portage-overlay/search?q=O_MAYEXEC
> Actually, there is more than the O_MAYEXEC changes (which matches this search)
> e.g., to prevent Python interactive execution. There are patches for
> Bash, Wine, Java (Icedtea), Busybox's ash, Perl and Python. There are
> also some related patches which do not directly rely on O_MAYEXEC but
> which restrict the use of browser plugins and extensions, which may be
> seen as scripts too:
> https://github.com/clipos-archive/clipos4_portage-overlay/tree/master/www-client
> 
> An introduction to O_MAYEXEC was given at the Linux Security Summit
> Europe 2018 - Linux Kernel Security Contributions by ANSSI:
> https://www.youtube.com/watch?v=chNjCRtPKQY&t=17m15s
> The "write xor execute" principle was explained at Kernel Recipes 2018 -
> CLIP OS: a defense-in-depth OS:
> https://www.youtube.com/watch?v=PjRE0uBtkHU&t=11m14s
> See also an overview article: https://lwn.net/Articles/820000/
> 
> 
> This patch series can be applied on top of v5.8-rc5 .  This can be tested
> with CONFIG_SYSCTL.  I would really appreciate constructive comments on
> this patch series.
> 
> Previous version:
> https://lore.kernel.org/lkml/20200505153156.925111-1-mic@digikod.net/
> 
> 
> [1] https://lore.kernel.org/lkml/1544647356.4028.105.camel@linux.ibm.com/
> [2] https://lore.kernel.org/lkml/20190904201933.10736-6-cyphar@cyphar.com/
> [3] https://lore.kernel.org/lkml/CALCETrVovr8XNZSroey7pHF46O=kj_c5D9K8h=z2T_cNrpvMig@mail.gmail.com/
> [4] https://lore.kernel.org/lkml/CALCETrVeZ0eufFXwfhtaG_j+AdvbzEWE0M3wjXMWVEO7pj+xkw@mail.gmail.com/
> [5] https://lore.kernel.org/lkml/20200406221439.1469862-12-deven.desai@linux.microsoft.com/
> [6] https://www.python.org/dev/peps/pep-0578/
> [7] https://lore.kernel.org/lkml/0c70debd-e79e-d514-06c6-4cd1e021fa8b@python.org/
> 
> Regards,
> 
> Kees Cook (3):
>   exec: Change uselib(2) IS_SREG() failure to EACCES
>   exec: Move S_ISREG() check earlier
>   exec: Move path_noexec() check earlier
> 
> Micka�l Sala�n (3):
>   fs: Introduce O_MAYEXEC flag for openat2(2)
>   fs,doc: Enable to enforce noexec mounts or file exec through O_MAYEXEC
>   selftest/openat2: Add tests for O_MAYEXEC enforcing
> 
> Mimi Zohar (1):
>   ima: add policy support for the new file open MAY_OPENEXEC flag
> 
>  Documentation/ABI/testing/ima_policy          |   2 +-
>  Documentation/admin-guide/sysctl/fs.rst       |  49 +++
>  fs/exec.c                                     |  23 +-
>  fs/fcntl.c                                    |   2 +-
>  fs/namei.c                                    |  36 +-
>  fs/open.c                                     |  12 +-
>  include/linux/fcntl.h                         |   2 +-
>  include/linux/fs.h                            |   3 +
>  include/uapi/asm-generic/fcntl.h              |   7 +
>  kernel/sysctl.c                               |  12 +-
>  security/integrity/ima/ima_main.c             |   3 +-
>  security/integrity/ima/ima_policy.c           |  15 +-
>  tools/testing/selftests/kselftest_harness.h   |   3 +
>  tools/testing/selftests/openat2/Makefile      |   3 +-
>  tools/testing/selftests/openat2/config        |   1 +
>  tools/testing/selftests/openat2/helpers.h     |   1 +
>  .../testing/selftests/openat2/omayexec_test.c | 325 ++++++++++++++++++
>  17 files changed, 470 insertions(+), 29 deletions(-)
>  create mode 100644 tools/testing/selftests/openat2/config
>  create mode 100644 tools/testing/selftests/openat2/omayexec_test.c
> 
> -- 
> 2.27.0
> 

-- 
Kees Cook
