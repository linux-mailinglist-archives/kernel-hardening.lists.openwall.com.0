Return-Path: <kernel-hardening-return-19688-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 1054B2544F8
	for <lists+kernel-hardening@lfdr.de>; Thu, 27 Aug 2020 14:29:18 +0200 (CEST)
Received: (qmail 20464 invoked by uid 550); 27 Aug 2020 12:29:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 26618 invoked from network); 27 Aug 2020 09:49:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=iNFyrfAX8/Dn97tnpLT6eU3mzRCVxFI29SHF2tFkwxs=;
        b=oYzlD63HjA4+DgXzN/1Ec87ehOgzdrOBe9xX47ITGPxUYdy+i0ojrGPm4cGks3PSNN
         HvGhEtGGNd6KePcpw1D2UWrBHxc0z/LuEJrhXT/lETucxjtAkxJ6YgNTpZTEOIMHnrOt
         v8NFwYQmtIAyVMt16KmBGv7XsAFMclfxvGb5Uo3IE5bT7bsiWPCBnQ+R+wY8478XLio3
         +2E2HrNgT/0kBwkNaNxUFJAOBL8oawX3FTVnvEPusCpqGXP+6/oh52SRyzJ5ngbpG0Il
         AtSxn7vV+6RjPbEZo0EmBcTJcFZuizUFOfda9FAVTPK8DlR/BDZsEmL9rm+TKjHEgspz
         ZRlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=iNFyrfAX8/Dn97tnpLT6eU3mzRCVxFI29SHF2tFkwxs=;
        b=HQt8ceNZVXg/2HZY14uIRPMNfDi9vtMDLogybwnusUpCKymOGMMGOTM8pGBtyzR6U3
         T9DTjtWTe0GAU2JggpdiNvaExduwHQ8Qo9eNgdNOAg0MkA/OKs7CpuBqKkblaFZprGW3
         Y6kGCvtKRWZ6k6qQIWxk0ZtEtOhz9mQFjh0Gl4tmYcyzLqOfcfRusim9+jUraxG4GQOe
         7xPsRjf4ewPgQ1153BzM0Jp8rcND6WN9Ql9WksPS8Rx/JcbhvxtovQmZJe+oIkSLWRhR
         zpuTwZ16L9kILgm3T8Gk99M6/ao01AWuu25EboKyD9FKxRFIC9FtqIjLALDyCp/kiEmv
         PNyQ==
X-Gm-Message-State: AOAM5325BJfYIf2MSdHpDHhDOoiKo/H5Ewbvl1qz0r7iqP9ya08luNNM
	1LBKorBUnOSfJc1LiLCxggY=
X-Google-Smtp-Source: ABdhPJws8TUBrPbN9lQbtTHLNVjZCVt2cECt/XVnEfPGgUck2J+q/BX4fGva8KrSrGEPM6fODacOqw==
X-Received: by 2002:a17:906:3091:: with SMTP id 17mr3818701ejv.515.1598521773405;
        Thu, 27 Aug 2020 02:49:33 -0700 (PDT)
From: Lukas Bulwahn <lukas.bulwahn@gmail.com>
X-Google-Original-From: Lukas Bulwahn <lukas@gmail.com>
Date: Thu, 27 Aug 2020 11:49:31 +0200 (CEST)
X-X-Sender: lukas@felia
To: Greg KH <gregkh@linuxfoundation.org>
cc: Mrinal Pandey <mrinalmni@gmail.com>, skhan@linuxfoundation.org, 
    Linux-kernel-mentees@lists.linuxfoundation.org, lukas.bulwahn@gmail.com, 
    keescook@chromium.org, re.emese@gmail.com, maennich@google.com, 
    tglx@linutronix.de, akpm@linux-foundation.org, 
    kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, 
    linux-spdx@vger.kernel.org
Subject: Re: [PATCH] scripts: Add intended executable mode and SPDX license
In-Reply-To: <20200827094344.GA400189@kroah.com>
Message-ID: <alpine.DEB.2.21.2008271145370.25858@felia>
References: <20200827092405.b6hymjxufn2nvgml@mrinalpandey> <20200827094344.GA400189@kroah.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII



On Thu, 27 Aug 2020, Greg KH wrote:

> On Thu, Aug 27, 2020 at 02:54:05PM +0530, Mrinal Pandey wrote:
> > commit b72231eb7084 ("scripts: add spdxcheck.py self test") added the file
> > spdxcheck-test.sh to the repository without the executable flag and license
> > information.
> > 
> > commit eb8305aecb95 ("scripts: Coccinelle script for namespace
> > dependencies.") added the file nsdeps, commit 313dd1b62921 ("gcc-plugins:
> > Add the randstruct plugin") added the file gcc-plugins/gen-random-seed.sh
> > and commit 9b4ade226f74 ("xen: build infrastructure for generating
> > hypercall depending symbols") added the file xen-hypercalls.sh without the
> > executable bit.
> > 
> > Set to usual modes for these files and provide the SPDX license for
> > spdxcheck-test.sh. No functional changes.
> > 
> > Signed-off-by: Mrinal Pandey <mrinalmni@gmail.com>
> > ---
> > applies cleanly on next-20200827
> > 
> > Kees, Matthias, Thomas, please ack this patch.
> > 
> > Andrew, please pick this minor non-urgent cleanup patch once the
> > mainainers ack.
> > 
> >  scripts/gcc-plugins/gen-random-seed.sh | 0
> >  scripts/nsdeps                         | 0
> >  scripts/spdxcheck-test.sh              | 1 +
> >  scripts/xen-hypercalls.sh              | 0
> >  4 files changed, 1 insertion(+)
> >  mode change 100644 => 100755 scripts/gcc-plugins/gen-random-seed.sh
> >  mode change 100644 => 100755 scripts/nsdeps
> >  mode change 100644 => 100755 scripts/spdxcheck-test.sh
> >  mode change 100644 => 100755 scripts/xen-hypercalls.sh
> 
> This does 2 different things in one patch, shouldn't this be 2 different
> patches?  One to change the permissions and one to add the SPDX line?
>

For me, this was one thing: minor cleanup; and taking one 
minor patch is easier than taking two, but you make the call. Then, the 
two or even three patches would also just travel through different trees, 
the spdx tree and Andrew's.

Lukas
