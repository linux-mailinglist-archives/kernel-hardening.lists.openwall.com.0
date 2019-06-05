Return-Path: <kernel-hardening-return-16061-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 8A75635D78
	for <lists+kernel-hardening@lfdr.de>; Wed,  5 Jun 2019 15:05:14 +0200 (CEST)
Received: (qmail 5312 invoked by uid 550); 5 Jun 2019 13:05:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 5288 invoked from network); 5 Jun 2019 13:05:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NRvNKqXzZztvQh3qtkPJBNz3Y41PCmY2mwresCdihvw=;
        b=Dvb5lvHNFy/YlX9VOpbVuAXgLc/Bkqb9FHL1QfulyPL3Nfu7LNFUDi2bdtRN38UIDB
         kpsq1w0ZNYuzjO5QiRB/VNBh4B2zYpwznNXZ2BcTi+m6xeubmV2GNyYxBYFe52W8b6at
         WcDyZ7BR4dByy2KBn+q2kg8uW24xdyRPcakrY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NRvNKqXzZztvQh3qtkPJBNz3Y41PCmY2mwresCdihvw=;
        b=e30maHCUm6Iu1TUnW1nPX+PYVgC7B0P1U+vgVted6U0GpyinslQh1rAiWQtmrvTdiw
         iQkXBoKVUXGwrSpkPkmpw+rRQbYee8xQajTnFWNMeY8sHup3xyMoL77rCM/en/rH9AEF
         IN6MYrOtjeGfUPcjAMJSKawPQgjJwG+ehZOnU0GoHfBEqwM/ty1VAkThdtRRHiAUotQz
         b52KWwYfH7IOdyuuYtUKDJvExHWXEQlpwFu5+kox6WBeEObwfXebSMpKTIUdX7NQ0skh
         51PzBZUcDrb+A7rWh2Yen1tX9M2UZU7mtlFzS7T7429ZmN2AtSnkkXyEbtQJvfYZ3mNO
         iTBw==
X-Gm-Message-State: APjAAAUTf7Iokv4U7YZUQxRIdHHMT+wG9uqvI1RDlL41zM2coPsY/8+g
	Qd3YtsZCaiIkNYzkTHTutQx/B68dP9qPB9a+zqEMpQ==
X-Google-Smtp-Source: APXvYqyt7OLKBZ4DAerRqhiAeTPqPshOGmAnuk0KkZaQmyvMV/dwuVHzpUT44mnRI2A50tJlbF4XhdP85jTinsVz67M=
X-Received: by 2002:a05:651c:87:: with SMTP id 7mr3383290ljq.184.1559739895494;
 Wed, 05 Jun 2019 06:04:55 -0700 (PDT)
MIME-Version: 1.0
References: <20190601222738.6856-1-joel@joelfernandes.org> <20190601222738.6856-5-joel@joelfernandes.org>
 <20190605012429.wmlvlgn4mb4jkvua@ca-dmjordan1.us.oracle.com>
In-Reply-To: <20190605012429.wmlvlgn4mb4jkvua@ca-dmjordan1.us.oracle.com>
From: Joel Fernandes <joel@joelfernandes.org>
Date: Wed, 5 Jun 2019 09:04:44 -0400
Message-ID: <CAEXW_YTsT5BY5Qbc6Jju2XmbHSQFELrGM9UaPPXY-ETmJaBrsA@mail.gmail.com>
Subject: Re: [RFC 4/6] workqueue: Convert for_each_wq to use built-in list check
To: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, 
	Bjorn Helgaas <bhelgaas@google.com>, Borislav Petkov <bp@alien8.de>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, 
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Josh Triplett <josh@joshtriplett.org>, 
	Kees Cook <keescook@chromium.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Lai Jiangshan <jiangshanlai@gmail.com>, Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org, 
	linux-pci@vger.kernel.org, Linux PM <linux-pm@vger.kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Neil Brown <neilb@suse.com>, 
	netdev <netdev@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	"Paul E. McKenney" <paulmck@linux.ibm.com>, Pavel Machek <pavel@ucw.cz>, 
	Peter Zilstra <peterz@infradead.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, rcu <rcu@vger.kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, 
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, Jun 4, 2019 at 9:25 PM Daniel Jordan <daniel.m.jordan@oracle.com> wrote:
>
> On Sat, Jun 01, 2019 at 06:27:36PM -0400, Joel Fernandes (Google) wrote:
> > list_for_each_entry_rcu now has support to check for RCU reader sections
> > as well as lock. Just use the support in it, instead of explictly
> > checking in the caller.
> >
> > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> > ---
> >  kernel/workqueue.c | 5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> >
> > diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> > index 9657315405de..91ed7aca16e5 100644
> > --- a/kernel/workqueue.c
> > +++ b/kernel/workqueue.c
> > @@ -424,9 +424,8 @@ static void workqueue_sysfs_unregister(struct workqueue_struct *wq);
> >   * ignored.
> >   */
> >  #define for_each_pwq(pwq, wq)                                                \
> > -     list_for_each_entry_rcu((pwq), &(wq)->pwqs, pwqs_node)          \
> > -             if (({ assert_rcu_or_wq_mutex(wq); false; })) { }       \
> > -             else
> > +     list_for_each_entry_rcu((pwq), &(wq)->pwqs, pwqs_node,          \
> > +                              lock_is_held(&(wq->mutex).dep_map))
> >
>
> I think the definition of assert_rcu_or_wq_mutex can also be deleted.

Sure, will do. Thank you.
