Return-Path: <kernel-hardening-return-18791-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id A7D561D3345
	for <lists+kernel-hardening@lfdr.de>; Thu, 14 May 2020 16:42:02 +0200 (CEST)
Received: (qmail 12176 invoked by uid 550); 14 May 2020 14:41:56 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 12153 invoked from network); 14 May 2020 14:41:55 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IpKyFs1yszxKs0lfKzxRyfm8sy/4V4zXUkzdtSdkHLU=;
        b=X+1M/fmbQRViUiNWq5i8Wnhzf2ZxZWa44EfPqXFdhzGNfFrnMMGFlC9RiMxXJ091Ma
         NG/CNZqhzV1Qho131HIRtHnMmH2dd1a0u/Lnxs7n0oy487ROOuwOgwTDBO2IRRCDsPb3
         hmLh+/ITWKzvGRhNGI8R89GJSU8kqpyPsfmQQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IpKyFs1yszxKs0lfKzxRyfm8sy/4V4zXUkzdtSdkHLU=;
        b=tvITdAsYn2zpOGAfMVYomqr6KDqyAJoYbVsFuOtDWL6MlpJPTOQole1fhXx8zDJjpe
         RHqlKca6mxGVhuPsvb/xtvgo0WVMUrB1fsiNWW0zC+Kqa168roQcUfwAtFjsFFJY6BeM
         0SjEf28ZIGg+2l+rwn2lehV0ns1oTJHfAqEcz0/UZCKKK//YA9i14E11TzSHgQk1r36W
         YgXnZFBXAV1z2Z1w+DfcxcpsD/3m6TwbhRuaTGrq3QxCuDyDwZ1Eut+yAAJJ6qfu4h1d
         Pyuj6C2UHG6H8c4On53NPQzd+6GdUx7eeYeENP0AT1ygMYHNIS7/IeBkj+KRm+oMsan5
         bWew==
X-Gm-Message-State: AOAM531DGcG3zAdmOAndicTs/TFtJAQ6r2qzwBRC7LrQSF3l20HxNgQl
	FYJd+efwo5RLaInmVC3jRoB6Of7WOxE=
X-Google-Smtp-Source: ABdhPJw803NLliwJdw3Qk5o4x+XH/SQaDwZsQ2JFMZ1iNHIhcyH1GCLb3+bU8sx5k7WA09KC4Ps+iQ==
X-Received: by 2002:a17:902:b608:: with SMTP id b8mr4282064pls.163.1589467303571;
        Thu, 14 May 2020 07:41:43 -0700 (PDT)
Date: Thu, 14 May 2020 07:41:40 -0700
From: Kees Cook <keescook@chromium.org>
To: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Aleksa Sarai <cyphar@cyphar.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@kernel.org>,
	Christian Heimes <christian@python.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Deven Bowers <deven.desai@linux.microsoft.com>,
	Eric Chiang <ericchiang@google.com>,
	Florian Weimer <fweimer@redhat.com>,
	James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>,
	Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
	Matthew Garrett <mjg59@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mickael.salaun@ssi.gouv.fr>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Philippe =?iso-8859-1?Q?Tr=E9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
	Scott Shell <scottsh@microsoft.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Shuah Khan <shuah@kernel.org>, Steve Dower <steve.dower@python.org>,
	Steve Grubb <sgrubb@redhat.com>,
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	LSM List <linux-security-module@vger.kernel.org>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v5 3/6] fs: Enable to enforce noexec mounts or file exec
 through O_MAYEXEC
Message-ID: <202005140739.F3A4D8F3@keescook>
References: <20200505153156.925111-1-mic@digikod.net>
 <20200505153156.925111-4-mic@digikod.net>
 <CAEjxPJ7y2G5hW0WTH0rSrDZrorzcJ7nrQBjfps2OWV5t1BUYHw@mail.gmail.com>
 <202005131525.D08BFB3@keescook>
 <202005132002.91B8B63@keescook>
 <CAEjxPJ7WjeQAz3XSCtgpYiRtH+Jx-UkSTaEcnVyz_jwXKE3dkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEjxPJ7WjeQAz3XSCtgpYiRtH+Jx-UkSTaEcnVyz_jwXKE3dkw@mail.gmail.com>

On Thu, May 14, 2020 at 08:22:01AM -0400, Stephen Smalley wrote:
> On Wed, May 13, 2020 at 11:05 PM Kees Cook <keescook@chromium.org> wrote:
> >
> > On Wed, May 13, 2020 at 04:27:39PM -0700, Kees Cook wrote:
> > > Like, couldn't just the entire thing just be:
> > >
> > > diff --git a/fs/namei.c b/fs/namei.c
> > > index a320371899cf..0ab18e19f5da 100644
> > > --- a/fs/namei.c
> > > +++ b/fs/namei.c
> > > @@ -2849,6 +2849,13 @@ static int may_open(const struct path *path, int acc_mode, int flag)
> > >               break;
> > >       }
> > >
> > > +     if (unlikely(mask & MAY_OPENEXEC)) {
> > > +             if (sysctl_omayexec_enforce & OMAYEXEC_ENFORCE_MOUNT &&
> > > +                 path_noexec(path))
> > > +                     return -EACCES;
> > > +             if (sysctl_omayexec_enforce & OMAYEXEC_ENFORCE_FILE)
> > > +                     acc_mode |= MAY_EXEC;
> > > +     }
> > >       error = inode_permission(inode, MAY_OPEN | acc_mode);
> > >       if (error)
> > >               return error;
> > >
> >
> > FYI, I've confirmed this now. Effectively with patch 2 dropped, patch 3
> > reduced to this plus the Kconfig and sysctl changes, the self tests
> > pass.
> >
> > I think this makes things much cleaner and correct.
> 
> I think that covers inode-based security modules but not path-based
> ones (they don't implement the inode_permission hook).  For those, I
> would tentatively guess that we need to make sure FMODE_EXEC is set on
> the open file and then they need to check for that in their file_open
> hooks.

Does there need to be an FMODE_OPENEXEC, or is the presence of
FMODE_OPEN with FMODE_EXEC sufficient?

-- 
Kees Cook
