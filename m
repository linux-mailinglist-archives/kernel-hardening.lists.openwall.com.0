Return-Path: <kernel-hardening-return-17587-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id B24C21416C0
	for <lists+kernel-hardening@lfdr.de>; Sat, 18 Jan 2020 10:19:44 +0100 (CET)
Received: (qmail 14160 invoked by uid 550); 18 Jan 2020 09:19:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 14124 invoked from network); 18 Jan 2020 09:19:36 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z7V6E0TDaKraOo9dTt7jhc6TLdoMlUlp/uyIAC+ZTcI=;
        b=r5Osyi+5S7I7ieJbRoinobkAaTllvHQz6AIaLQiYADUQlxAhGTpSFct10Rbv/qtQPE
         XeQcvA/TRKGpFLwD5gVeUdVLPE5SFwnaYYXJ09z9LSlZ97mXMTSlaIdv3kesQ6zD7o+C
         Iqilhd9nvoenPTM0cdlDK9qXTOP7vvglydomTJkikqduytMLU706Obi4jiFowybtbViF
         93GtIc0xCZ7BAhaBAOlOKgSo77ZOJ/h/4ntx0g05wHFtFKwmmVfV8Rw7DmZrwumRApv6
         2JN3gsKiuVf1UXzL0PyPH/jOaFC4nlRGCFG5rOk/4sjfNUfOFYWVYrG8VrH/xB4a1Yc6
         0VkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z7V6E0TDaKraOo9dTt7jhc6TLdoMlUlp/uyIAC+ZTcI=;
        b=PlXXDYbf2w6bKU69rLAhzwEgd4UUqbenivh72Fz0CoDVcpYeHl+/57fhmARWqGS9cU
         m7ujpELl/dWqBAK3wIF9JXJkyKJLyBVuPYVKb2WPx83bN1D/9MI9zgV3IhC0DDQQgcKv
         3npY/PiHV2Ve2Jc4MKzpCxGX4wr9a4rhS7/tCAMiYxDZTH7ltIehjfswuR4/An8aGO/5
         9BZMBs29LgFifP+nS2AA0spl2mIFKw+5r5ECDOI4vNHx1zTZm+KMHaJecwtfb2E99JPG
         +pne7olm2TGy1SYIc0HkuRJzb1DZggQM/F1H0KCnyoyMBATpV3eTD2WXWdezbtWHSuJ7
         LWig==
X-Gm-Message-State: APjAAAXXYd16L3qWKV+X6SgfePKH1gjKvPyEvSxt1w/p4MpTb3i759Wg
	HADfyhA7pOU7LhZVe27dOPyC8PEGQUjnANm1Wjb1Nw==
X-Google-Smtp-Source: APXvYqySu7QSqXqUmm7G/+6P0CGxNfV2qDMzuVTo/0NaUw5yglIxMT0d3on5SEunQ2/Vpk1yqcdlYTa4b1UTbvflla4=
X-Received: by 2002:aed:3b6e:: with SMTP id q43mr11061878qte.57.1579339163936;
 Sat, 18 Jan 2020 01:19:23 -0800 (PST)
MIME-Version: 1.0
References: <20200116012321.26254-1-keescook@chromium.org> <20200116012321.26254-6-keescook@chromium.org>
 <CACT4Y+batRaj_PaDnfzLjpLDOCChhpiayKeab-rNLx5LAj1sSQ@mail.gmail.com>
 <202001161548.9E126B774F@keescook> <CACT4Y+Z9o4B37-sNU2582FBv_2+evgyKVbVo-OAufLrsney=wA@mail.gmail.com>
 <202001171317.5E3C106F@keescook>
In-Reply-To: <202001171317.5E3C106F@keescook>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Sat, 18 Jan 2020 10:19:12 +0100
Message-ID: <CACT4Y+ansnGK3woNmiZurj1eGfygbz7anxRqYe_VPs-_HE2u6g@mail.gmail.com>
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

On Fri, Jan 17, 2020 at 10:20 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Fri, Jan 17, 2020 at 10:54:36AM +0100, Dmitry Vyukov wrote:
> > On Fri, Jan 17, 2020 at 12:49 AM Kees Cook <keescook@chromium.org> wrote:
> > >
> > > On Thu, Jan 16, 2020 at 06:23:01AM +0100, Dmitry Vyukov wrote:
> > > > On Thu, Jan 16, 2020 at 2:24 AM Kees Cook <keescook@chromium.org> wrote:
> > > > >
> > > > > As done in the full WARN() handler, panic_on_warn needs to be cleared
> > > > > before calling panic() to avoid recursive panics.
> > > > >
> > > > > Signed-off-by: Kees Cook <keescook@chromium.org>
> > > > > ---
> > > > >  mm/kasan/report.c | 10 +++++++++-
> > > > >  1 file changed, 9 insertions(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/mm/kasan/report.c b/mm/kasan/report.c
> > > > > index 621782100eaa..844554e78893 100644
> > > > > --- a/mm/kasan/report.c
> > > > > +++ b/mm/kasan/report.c
> > > > > @@ -92,8 +92,16 @@ static void end_report(unsigned long *flags)
> > > > >         pr_err("==================================================================\n");
> > > > >         add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
> > > > >         spin_unlock_irqrestore(&report_lock, *flags);
> > > > > -       if (panic_on_warn)
> > > > > +       if (panic_on_warn) {
> > > > > +               /*
> > > > > +                * This thread may hit another WARN() in the panic path.
> > > > > +                * Resetting this prevents additional WARN() from panicking the
> > > > > +                * system on this thread.  Other threads are blocked by the
> > > > > +                * panic_mutex in panic().
> > > >
> > > > I don't understand part about other threads.
> > > > Other threads are not necessary inside of panic(). And in fact since
> > > > we reset panic_on_warn, they will not get there even if they should.
> > > > If I am reading this correctly, once one thread prints a warning and
> > > > is going to panic, other threads may now print infinite amounts of
> > > > warning and proceed past them freely. Why is this the behavior we
> > > > want?
> > >
> > > AIUI, the issue is the current thread hitting another WARN and blocking
> > > on trying to call panic again. WARNs encountered during the execution of
> > > panic() need to not attempt to call panic() again.
> >
> > Yes, but the variable is global and affects other threads and the
> > comment talks about other threads, and that's the part I am confused
> > about (for both comment wording and the actual behavior). For the
> > "same thread hitting another warning" case we need a per-task flag or
> > something.
>
> This is duplicating the common panic-on-warn logic (see the generic bug
> code), so I'd like to just have the same behavior between the three
> implementations of panic-on-warn (generic bug, kasan, ubsan), and then
> work to merge them into a common handler, and then perhaps fix the
> details of the behavior. I think it's more correct to allow the panicing
> thread to complete than to care about what the other threads are doing.
> Right now, a WARN within the panic code will either a) hang the machine,
> or b) not panic, allowing the rest of the threads to continue, maybe
> then hitting other WARNs and hanging. The generic bug code does not
> suffer from this.

I see. Then:

Acked-by: Dmitry Vyukov <dvyukov@google.com>
