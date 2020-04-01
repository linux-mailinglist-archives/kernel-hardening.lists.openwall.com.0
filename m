Return-Path: <kernel-hardening-return-18360-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 9507219B751
	for <lists+kernel-hardening@lfdr.de>; Wed,  1 Apr 2020 22:55:45 +0200 (CEST)
Received: (qmail 11887 invoked by uid 550); 1 Apr 2020 20:55:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 11864 invoked from network); 1 Apr 2020 20:55:40 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yuHnHVGl5Hl/LCLky/lKRjfVSplQ/H5ogoCU1HMx1e8=;
        b=WWbKUEBx25usiEQ2sOtMr/aJGGNl/SWad/qB+6BBXRmLdbbOPDw+0Em7vvCLC8KHwE
         L0cmqvLGhMWA3DKwcIP/ALfr/FFFkSk9t8gs4fHWuRB/MEmppOKWwLyW0SIfro25/I7O
         JCyragl/0Fvlx0Ib8Kr7EkEmR2XWHQ4+fVTn8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yuHnHVGl5Hl/LCLky/lKRjfVSplQ/H5ogoCU1HMx1e8=;
        b=qhgePKKFE4WO56vtFvf5YgwsxdVqgW5eDDdD91cXhNHWM5RQB+zulMM6oS1h05WpPk
         KOZuAAy1pggL990ElCTvYON8BHjfp/ctg2CEga/4pSkSztbaoUcMC8N8lSWnIPi+yCtd
         WWfNj69ngD0ffbpaXRHTdNqUJvAGIobwCjkYEX6NmxmZsiYXPDeymWqbrTcz7BZvzNLj
         I9UWFqbXvK+068SpI3xCVewiD2s1xYh+L4O3Nhm2EMyq8HYGbWLBp8G9/wqbq5C9Vt7m
         ebp+0dnieemZlXYcE08UiJKw0nyOwjMX0ylC72ZrDx2ObqnaOkJM4jEPJFUjPIDWu7+m
         fiEQ==
X-Gm-Message-State: AGi0PuYXXc1ttIYrcj+fwiF/qgFyyviRqQIOyB1EOJdNSHtTT9TM7dZd
	sWVIht5BRXeAJfhlmOUT6i0gaBNEnug=
X-Google-Smtp-Source: APiQypKDasVmR7YVokdunmCp3BS+ewgIj78dVPryxLID16N7jCVfXb2g8O2OjRyhVAhfQ+UKx0WK1w==
X-Received: by 2002:a19:c1c5:: with SMTP id r188mr22892lff.191.1585774528811;
        Wed, 01 Apr 2020 13:55:28 -0700 (PDT)
X-Received: by 2002:a2e:8652:: with SMTP id i18mr62644ljj.265.1585774527625;
 Wed, 01 Apr 2020 13:55:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200324215049.GA3710@pi3.com.pl> <202003291528.730A329@keescook> <87zhbvlyq7.fsf_-_@x220.int.ebiederm.org>
In-Reply-To: <87zhbvlyq7.fsf_-_@x220.int.ebiederm.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 1 Apr 2020 13:55:11 -0700
X-Gmail-Original-Message-ID: <CAHk-=wihrtjjSsF6mGc7wjrtVQ-pha9ZAeo1rQAeuO1hr+i1qw@mail.gmail.com>
Message-ID: <CAHk-=wihrtjjSsF6mGc7wjrtVQ-pha9ZAeo1rQAeuO1hr+i1qw@mail.gmail.com>
Subject: Re: [PATCH] signal: Extend exec_id to 64bits
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Adam Zabrocki <pi3@pi3.com.pl>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Jann Horn <jannh@google.com>, 
	Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>, 
	Bernd Edlinger <bernd.edlinger@hotmail.de>, Kees Cook <keescook@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, Apr 1, 2020 at 1:50 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
>
> I have updated the update of exec_id on exec to use WRITE_ONCE
> and the read of exec_id in do_notify_parent to use READ_ONCE
> to make it clear that there is no locking between these two
> locations.

Ack, makes sense to me.

Just put it in your branch, this doesn't look urgent, considering that
it's something that has been around forever.

            Linus
