Return-Path: <kernel-hardening-return-19808-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 2D1F626121F
	for <lists+kernel-hardening@lfdr.de>; Tue,  8 Sep 2020 15:43:00 +0200 (CEST)
Received: (qmail 11408 invoked by uid 550); 8 Sep 2020 13:42:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 11376 invoked from network); 8 Sep 2020 13:42:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xd2oWJkrBNO95Z2fxVzWxksIKe3e21pnPKp8bkrKZIg=;
        b=kS3dWB8VQiDisNP5NDkv/W0BWN4UdAih//KXxzs5yABpE8/YVcEafAUuD/EiZUE17N
         KWnVPvP2s8+B7PvOPerD6j1Iys4qnAj0OvjI02KA1Bi3+mGKN8NDHhwIC/rEnXDFZ/k7
         3dhaai01z54o5WRQ4oAoKoR0fxXZ/qJRmSAGFBfd0liQVThAcYg8gWSsTyAvKOapSLM+
         yluUFiraOydcoP51UhqZk+TNvyNcDugW0AEpCGXXbKcifQOYfAYZK8hQEaSxhZpTIWd+
         W5dnITZDGDNV66aJpXzDKe1hF3SSxFsQzvcQA2Fr8+c2o14nIfHJcBsOFy6Vp+EGGDZL
         3G2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xd2oWJkrBNO95Z2fxVzWxksIKe3e21pnPKp8bkrKZIg=;
        b=sr4DA3JLx4/W55Yo5Aqx7B6EdgxUISE8VNxxf6sesuccIgGfM17JEDewviBEkfkHDm
         F6nCGGQ//dnXmKJmxzlKUCAuS9Lu8igA/ONE+H+JtJ5oreYTqj/XcPrJVtoJ/ToT0s5Z
         CCvAkg/uV6DpnRCyXnHjkugMmh3FeVAFzHW1df31MXz3PfHYMPfdr9f+j7tUUDN5JvdC
         OEP0Tb/sNm+MObQwo46FAWLkTvooFAdk0yfwrdEERPgBrpl0zkYloO3SwiAG8GsSCNPK
         k9xIP9Xrdi+PIzfjMDPgZBuCr9uR6TiHYlxCSCQvcByrRrsvVBnvuseYJ0jZMzmwRhEl
         7OoQ==
X-Gm-Message-State: AOAM533BXwCyZuKdtSp3fwNY5vdxg1WLBpYFqKGW7miT7bpyvygWRD7y
	sra9a4P5fq5PFwImxXwHc6tN9GdS3yLx+o0AXhg=
X-Google-Smtp-Source: ABdhPJy+kWXzj4FNXLYPJloVYc68j27SGmn6I5quJn/kq76MG8ycRFt5yJHDRK5ChXdsc0RHpMQxGbsaXoNtMmIP7ao=
X-Received: by 2002:a9d:7a92:: with SMTP id l18mr17096154otn.89.1599572561763;
 Tue, 08 Sep 2020 06:42:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200908075956.1069018-1-mic@digikod.net> <20200908075956.1069018-2-mic@digikod.net>
 <d216615b48c093ebe9349a9dab3830b646575391.camel@linux.ibm.com>
 <75451684-58f3-b946-dca4-4760fa0d7440@digikod.net> <CAEjxPJ49_BgGX50ZAhHh79Qy3OMN6sssnUHT_2yXqdmgyt==9w@mail.gmail.com>
 <CAEjxPJ6ZTKeunzJvWf_kS3QYjca6v1yJq=ad-jCCuDSgG6n60g@mail.gmail.com> <bdc10ab89cf9197e104f02a751009cf0d549ddf5.camel@linux.ibm.com>
In-Reply-To: <bdc10ab89cf9197e104f02a751009cf0d549ddf5.camel@linux.ibm.com>
From: Stephen Smalley <stephen.smalley.work@gmail.com>
Date: Tue, 8 Sep 2020 09:42:30 -0400
Message-ID: <CAEjxPJ5evWDSv-T-p=4OX29Pr584ZRAsnYoxSRd4qFDoryB+fQ@mail.gmail.com>
Subject: Re: [RFC PATCH v8 1/3] fs: Introduce AT_INTERPRETED flag for faccessat2(2)
To: Mimi Zohar <zohar@linux.ibm.com>
Cc: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, 
	linux-kernel <linux-kernel@vger.kernel.org>, Aleksa Sarai <cyphar@cyphar.com>, 
	Alexei Starovoitov <ast@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, 
	Christian Brauner <christian.brauner@ubuntu.com>, Christian Heimes <christian@python.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Deven Bowers <deven.desai@linux.microsoft.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Eric Biggers <ebiggers@kernel.org>, 
	Eric Chiang <ericchiang@google.com>, Florian Weimer <fweimer@redhat.com>, 
	James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, 
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>, Matthew Garrett <mjg59@google.com>, 
	Matthew Wilcox <willy@infradead.org>, Michael Kerrisk <mtk.manpages@gmail.com>, 
	Miklos Szeredi <mszeredi@redhat.com>, 
	=?UTF-8?Q?Philippe_Tr=C3=A9buchet?= <philippe.trebuchet@ssi.gouv.fr>, 
	Scott Shell <scottsh@microsoft.com>, 
	Sean Christopherson <sean.j.christopherson@intel.com>, Shuah Khan <shuah@kernel.org>, 
	Steve Dower <steve.dower@python.org>, Steve Grubb <sgrubb@redhat.com>, 
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, 
	Thibaut Sautereau <thibaut.sautereau@clip-os.org>, 
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>, kernel-hardening@lists.openwall.com, 
	linux-api@vger.kernel.org, linux-integrity@vger.kernel.org, 
	LSM List <linux-security-module@vger.kernel.org>, 
	Linux FS Devel <linux-fsdevel@vger.kernel.org>, 
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>, 
	=?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@linux.microsoft.com>, 
	John Johansen <john.johansen@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 8, 2020 at 9:29 AM Mimi Zohar <zohar@linux.ibm.com> wrote:
>
> On Tue, 2020-09-08 at 08:52 -0400, Stephen Smalley wrote:
> > On Tue, Sep 8, 2020 at 8:50 AM Stephen Smalley
> > <stephen.smalley.work@gmail.com> wrote:
> > >
> > > On Tue, Sep 8, 2020 at 8:43 AM Micka=C3=ABl Sala=C3=BCn <mic@digikod.=
net> wrote:
> > > >
> > > >
> > > > On 08/09/2020 14:28, Mimi Zohar wrote:
> > > > > Hi Mickael,
> > > > >
> > > > > On Tue, 2020-09-08 at 09:59 +0200, Micka=C3=ABl Sala=C3=BCn wrote=
:
> > > > >> +                    mode |=3D MAY_INTERPRETED_EXEC;
> > > > >> +                    /*
> > > > >> +                     * For compatibility reasons, if the system=
-wide policy
> > > > >> +                     * doesn't enforce file permission checks, =
then
> > > > >> +                     * replaces the execute permission request =
with a read
> > > > >> +                     * permission request.
> > > > >> +                     */
> > > > >> +                    mode &=3D ~MAY_EXEC;
> > > > >> +                    /* To be executed *by* user space, files mu=
st be readable. */
> > > > >> +                    mode |=3D MAY_READ;
> > > > >
> > > > > After this change, I'm wondering if it makes sense to add a call =
to
> > > > > security_file_permission().  IMA doesn't currently define it, but
> > > > > could.
> > > >
> > > > Yes, that's the idea. We could replace the following inode_permissi=
on()
> > > > with file_permission(). I'm not sure how this will impact other LSM=
s though.
>
> I wasn't suggesting replacing the existing security_inode_permission
> hook later, but adding a new security_file_permission hook here.
>
> > >
> > > They are not equivalent at least as far as SELinux is concerned.
> > > security_file_permission() was only to be used to revalidate
> > > read/write permissions previously checked at file open to support
> > > policy changes and file or process label changes.  We'd have to modif=
y
> > > the SELinux hook if we wanted to have it check execute access even if
> > > nothing has changed since open time.
> >
> > Also Smack doesn't appear to implement file_permission at all, so it
> > would skip Smack checking.
>
> My question is whether adding a new security_file_permission call here
> would break either SELinux or Apparmor?

selinux_inode_permission() has special handling for MAY_ACCESS so we'd
need to duplicate that into selinux_file_permission() ->
selinux_revalidate_file_permission().  Also likely need to adjust
selinux_file_permission() to explicitly check whether the mask
includes any permissions not checked at open time.  So some changes
would be needed here.  By default, it would be a no-op unless there
was a policy reload or the file was relabeled between the open(2) and
the faccessat(2) call.
