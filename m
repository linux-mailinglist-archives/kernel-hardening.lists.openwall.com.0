Return-Path: <kernel-hardening-return-17585-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 73C2D1406FB
	for <lists+kernel-hardening@lfdr.de>; Fri, 17 Jan 2020 10:55:06 +0100 (CET)
Received: (qmail 24533 invoked by uid 550); 17 Jan 2020 09:55:01 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 24499 invoked from network); 17 Jan 2020 09:55:00 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9kFTYGfEs/9SAwkwxZ+xsP/qfPJbE8uiwbZB2GtkwYs=;
        b=My897psDZMBwagGQ6Yi8DBTaWGenjkCZMzRCLm8NPW/mGNtq38BSN08w5wQQM+67Kd
         ZZ2l3SSjTkNAcsHHgtSilAg0k1IiFrAMAeC6viap/LEsk69WKbKDIK2uFP9brFczpQ6Q
         YYKHCsf99brQVXdGMqvuMpMh3ldHkPT9S1CgoEk5UPuqwjxUeY2OLJlHo6Fi/iVo6Cm9
         cKDVEGrlLDyvWXrf2I72c+Zbe9NeYw1sU/I4QINM9DWHruo8lPgjy8VFCUlxOyZMdtiL
         cNkv6OUZqUD8HHRUaSlxfDEvM7E2iSljjRMoIn0KnMl2rNhrf3/B608b8ftO7y6BcFV9
         W/ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9kFTYGfEs/9SAwkwxZ+xsP/qfPJbE8uiwbZB2GtkwYs=;
        b=eavhWLBxFPbfcZOEUeVtX39H+zoE6mqDc990Jv6gq/7wUmODHuT4Xf4J06E5KVKcn+
         ThGOqm+qCxzvnqLjJMhqxgYhYcOyHm7Ml4zBN05dKuA9ufb9Tu2eAU0lwLtMlp1LTPtI
         WAssRYiTWMM/Q8CsitJJyr05FArsKcgFv9frNx45Tkt13MtTG8p7p8H2tegH5uBheuy7
         B3mVSsQVah7kALyEPxHMJ7QScb8E4RyII1tc35f9bi91MlE3D1dzqCo/hHg8zGJhoZj9
         iTTb0A1XuzYOQ8R3GyTc+84A/0o6cLEpUakqX32nU9VPPIVYoF1VbcqDe5v3y3y2M34z
         OBuw==
X-Gm-Message-State: APjAAAW6CIKeKZAdLScaQdqOV4YONnM/+/3n2OxFOiVAZ3Bz3UzGwYIh
	qhnIpPIyga2VXfCKOPo72xxkd0TM3hIo+LsaQQbOIg==
X-Google-Smtp-Source: APXvYqyeAb62xWiJYO2EfOnZ6vBYKZ/xLoxyS448Kg9u42z1XSWmFokBtRGediMr1jNmAm9go9FNWbbQw82+syEo1ho=
X-Received: by 2002:a05:620a:1136:: with SMTP id p22mr37884710qkk.8.1579254888242;
 Fri, 17 Jan 2020 01:54:48 -0800 (PST)
MIME-Version: 1.0
References: <20200116012321.26254-1-keescook@chromium.org> <20200116012321.26254-6-keescook@chromium.org>
 <CACT4Y+batRaj_PaDnfzLjpLDOCChhpiayKeab-rNLx5LAj1sSQ@mail.gmail.com> <202001161548.9E126B774F@keescook>
In-Reply-To: <202001161548.9E126B774F@keescook>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Fri, 17 Jan 2020 10:54:36 +0100
Message-ID: <CACT4Y+Z9o4B37-sNU2582FBv_2+evgyKVbVo-OAufLrsney=wA@mail.gmail.com>
Subject: Re: [PATCH v3 5/6] kasan: Unset panic_on_warn before calling panic()
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>, 
	Elena Petrova <lenaptr@google.com>, Alexander Potapenko <glider@google.com>, 
	Dan Carpenter <dan.carpenter@oracle.com>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, 
	Arnd Bergmann <arnd@arndb.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, 
	kasan-dev <kasan-dev@googlegroups.com>, Linux-MM <linux-mm@kvack.org>, 
	LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, 
	syzkaller <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, Jan 17, 2020 at 12:49 AM Kees Cook <keescook@chromium.org> wrote:
>
> On Thu, Jan 16, 2020 at 06:23:01AM +0100, Dmitry Vyukov wrote:
> > On Thu, Jan 16, 2020 at 2:24 AM Kees Cook <keescook@chromium.org> wrote:
> > >
> > > As done in the full WARN() handler, panic_on_warn needs to be cleared
> > > before calling panic() to avoid recursive panics.
> > >
> > > Signed-off-by: Kees Cook <keescook@chromium.org>
> > > ---
> > >  mm/kasan/report.c | 10 +++++++++-
> > >  1 file changed, 9 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/mm/kasan/report.c b/mm/kasan/report.c
> > > index 621782100eaa..844554e78893 100644
> > > --- a/mm/kasan/report.c
> > > +++ b/mm/kasan/report.c
> > > @@ -92,8 +92,16 @@ static void end_report(unsigned long *flags)
> > >         pr_err("==================================================================\n");
> > >         add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
> > >         spin_unlock_irqrestore(&report_lock, *flags);
> > > -       if (panic_on_warn)
> > > +       if (panic_on_warn) {
> > > +               /*
> > > +                * This thread may hit another WARN() in the panic path.
> > > +                * Resetting this prevents additional WARN() from panicking the
> > > +                * system on this thread.  Other threads are blocked by the
> > > +                * panic_mutex in panic().
> >
> > I don't understand part about other threads.
> > Other threads are not necessary inside of panic(). And in fact since
> > we reset panic_on_warn, they will not get there even if they should.
> > If I am reading this correctly, once one thread prints a warning and
> > is going to panic, other threads may now print infinite amounts of
> > warning and proceed past them freely. Why is this the behavior we
> > want?
>
> AIUI, the issue is the current thread hitting another WARN and blocking
> on trying to call panic again. WARNs encountered during the execution of
> panic() need to not attempt to call panic() again.

Yes, but the variable is global and affects other threads and the
comment talks about other threads, and that's the part I am confused
about (for both comment wording and the actual behavior). For the
"same thread hitting another warning" case we need a per-task flag or
something.

> -Kees
>
> >
> > > +                */
> > > +               panic_on_warn = 0;
> > >                 panic("panic_on_warn set ...\n");
> > > +       }
> > >         kasan_enable_current();
> > >  }
>
> --
> Kees Cook
