Return-Path: <kernel-hardening-return-16002-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 4D82F2E186
	for <lists+kernel-hardening@lfdr.de>; Wed, 29 May 2019 17:49:04 +0200 (CEST)
Received: (qmail 25888 invoked by uid 550); 29 May 2019 15:48:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 25870 invoked from network); 29 May 2019 15:48:56 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cDz3GbUaoai6r6zW2MM2kvL6r+fuZogzUR81Y2LegRo=;
        b=HM+aD2WHWHXPATtRijrlE6pgyLNsdvu63KgjTL49oFkMJudqlZoYZ8f09bSgUZ00cM
         UBIFA2ig49PRFgbWTBqlRg0bT4x6o99kGSMBxaueQLiX9/in0ivbgL6eobEw5dh+VFne
         V8Y49LUYOrhunDFrh+PrlG1sdaO5FkdZgju4g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cDz3GbUaoai6r6zW2MM2kvL6r+fuZogzUR81Y2LegRo=;
        b=tMX/4T59gO1erLn01AC/NAY1XIzxfglbM8Iz7f2FsFoyJcCAQkW1wgKQJZ9mjTC1eD
         I0E9woZU9HA52uFM55ukGEMoFQ+vXMErHOh03Fi7P3ezXXU2NLQPGmRHLD77rx5kiYGj
         WaQov2PShbIBMeFHHAJHx7GepBB+zSvlFuhJSmquQlXJeJpAPRTmXvCv/lREKM/Vfnue
         urTRGqSw0HDBp1p85t5hl9gIvWqj7DVUGyIqrgUBomIBNHfPzDIoFQTJ5H3iplIkBUrK
         jORlJs2tDo85zlQ4irxXQNRTnCf/x534QisrZ+qQbERFZeUpNvaZlqtIalt+mPvxQ/E+
         Qgfw==
X-Gm-Message-State: APjAAAXjT4L2TJCkf6sZnhaQpx3RWmV8/ShprFT94JpVTmmfkxqT2ukx
	7YBHphoaj99cIbpVWfbJgRKidCJqcac=
X-Google-Smtp-Source: APXvYqxwvwn8fUPtpi47zlpKdJ8CeYZ4UJc6ekNxGSqydsbgnXuAIhUi8nZdRz0EcihcIRw9HBea6Q==
X-Received: by 2002:a6b:b790:: with SMTP id h138mr3052991iof.64.1559144924506;
        Wed, 29 May 2019 08:48:44 -0700 (PDT)
X-Received: by 2002:a5d:9d90:: with SMTP id 16mr6500257ion.132.1559144923364;
 Wed, 29 May 2019 08:48:43 -0700 (PDT)
MIME-Version: 1.0
References: <20190520231948.49693-1-thgarnie@chromium.org> <20190520231948.49693-12-thgarnie@chromium.org>
 <1b53b8eb-5dd3-fb57-d8db-06eedd0ce49f@suse.com>
In-Reply-To: <1b53b8eb-5dd3-fb57-d8db-06eedd0ce49f@suse.com>
From: Thomas Garnier <thgarnie@chromium.org>
Date: Wed, 29 May 2019 08:48:32 -0700
X-Gmail-Original-Message-ID: <CAJcbSZF1xcMpLDrOLkh493+ciVUqrku9WkWdb5xxAqWuXMjGZw@mail.gmail.com>
Message-ID: <CAJcbSZF1xcMpLDrOLkh493+ciVUqrku9WkWdb5xxAqWuXMjGZw@mail.gmail.com>
Subject: Re: [PATCH v7 11/12] x86/paravirt: Adapt assembly for PIE support
To: Juergen Gross <jgross@suse.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Kristen Carlson Accardi <kristen@linux.intel.com>, Alok Kataria <akataria@vmware.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	"H. Peter Anvin" <hpa@zytor.com>, "the arch/x86 maintainers" <x86@kernel.org>, 
	virtualization@lists.linux-foundation.org, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sun, May 26, 2019 at 10:47 PM Juergen Gross <jgross@suse.com> wrote:
>
> On 21/05/2019 01:19, Thomas Garnier wrote:
> > From: Thomas Garnier <thgarnie@google.com>
> >
> > if PIE is enabled, switch the paravirt assembly constraints to be
> > compatible. The %c/i constrains generate smaller code so is kept by
> > default.
> >
> > Position Independent Executable (PIE) support will allow to extend the
> > KASLR randomization range below 0xffffffff80000000.
> >
> > Signed-off-by: Thomas Garnier <thgarnie@google.com>
>
> Acked-by: Juergen Gross <jgross@suse.com>

Thanks Juergen.

>
>
> Juergen
