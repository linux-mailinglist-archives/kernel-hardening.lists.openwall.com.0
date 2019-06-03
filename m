Return-Path: <kernel-hardening-return-16044-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 9BC0432F9C
	for <lists+kernel-hardening@lfdr.de>; Mon,  3 Jun 2019 14:29:10 +0200 (CEST)
Received: (qmail 1694 invoked by uid 550); 3 Jun 2019 12:29:04 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1676 invoked from network); 3 Jun 2019 12:29:04 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WvqHOC4rVKX462WwE0yHSlmBZF1YO9aROqbvN/HfH6Y=;
        b=PYGUZK+GV8eTc/sc1/LJV2/FRh6sJ3eQVXqtHpM1WdCHjxWxGcJHVX6no/5nw7UnO6
         DV0yDj/ec3TxqyDkkmaBhVAS4R0g44dxp9/lCrwxqbNfRaWzZra8qYmAc+YZXjsgn2FX
         UGutllvZNq/hEvDPh7uqahFLrpIWsFBdileHo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WvqHOC4rVKX462WwE0yHSlmBZF1YO9aROqbvN/HfH6Y=;
        b=uefp5qclCp77Pbyc8TvPHcTHeKFPYsjEbWuZYDp/qNESq5yy41IgeRwBb88w5qRpBO
         uTTUEYgoq24FNSbZi9CZhnuzJG3tO+8VhsPhFCuyro99m26UCctm8VYmKFlwIKjQDcBR
         gq6SFoP/IqYUq2mfAx0FuYIqLErWo6rHfJw3QCgA8bHk3/JUU8sqHY1qCWk4TIcMj+KS
         d5JmnmmE0uY9d7gMRHOAjZADyopJvQEMsrE13xnZiRAeXKETtZoFzbGpfPyc4w1imCKk
         RwR38+yttpo4ay1y4EUEpJIz2+ropSJLjbSQu3rKOD9BI3qugTtryaz/3iSqMtm+c08D
         1soA==
X-Gm-Message-State: APjAAAU14plTyhOWGTkf9kKr/JKXHq2YZxHqXPObaIEnImPqy8nRe3Q/
	oUfa1YECXF7H4SiM6aC/z731H5rAcxtC+vglLPx/zw==
X-Google-Smtp-Source: APXvYqzHzzga29JITONK+bAJt2s0MgC0PRTzbGVoOX6cnbI/p9OIDGMPiEXt3Q9ji63k1yr8CtUni9paU765sGDmFMs=
X-Received: by 2002:a2e:9742:: with SMTP id f2mr13977662ljj.184.1559564932484;
 Mon, 03 Jun 2019 05:28:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190601222738.6856-1-joel@joelfernandes.org> <20190601222738.6856-3-joel@joelfernandes.org>
 <20190602070014.GA543@amd> <CAEXW_YT3t4Hb6wKsjXPGng+YbA5rhNRa7OSdZwdN4AKGfVkX3g@mail.gmail.com>
 <CAEXW_YSM2wwah2Q7LKmUO1Dp7GG62ciQA1nZ7GLw3m6cyuXXTw@mail.gmail.com> <20190603064212.GA7400@amd>
In-Reply-To: <20190603064212.GA7400@amd>
From: Joel Fernandes <joel@joelfernandes.org>
Date: Mon, 3 Jun 2019 08:28:41 -0400
Message-ID: <CAEXW_YSz8SNQCTnJj_86uJvRX3LFEQ6xJX-UV07HGwwA7oLwvg@mail.gmail.com>
Subject: Re: [RFC 2/6] ipv4: add lockdep condition to fix for_each_entry
To: Pavel Machek <pavel@denx.de>
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
	"Paul E. McKenney" <paulmck@linux.ibm.com>, Peter Zilstra <peterz@infradead.org>, 
	"Rafael J. Wysocki" <rjw@rjwysocki.net>, rcu <rcu@vger.kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, 
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, Jun 3, 2019 at 2:42 AM Pavel Machek <pavel@denx.de> wrote:
>
> On Sun 2019-06-02 08:24:35, Joel Fernandes wrote:
> > On Sun, Jun 2, 2019 at 8:20 AM Joel Fernandes <joel@joelfernandes.org> wrote:
> > >
> > > On Sun, Jun 2, 2019 at 3:00 AM Pavel Machek <pavel@denx.de> wrote:
> > > >
> > > > On Sat 2019-06-01 18:27:34, Joel Fernandes (Google) wrote:
> > > > > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> > > >
> > > > This really needs to be merged to previous patch, you can't break
> > > > compilation in middle of series...
> > > >
> > > > Or probably you need hlist_for_each_entry_rcu_lockdep() macro with
> > > > additional argument, and switch users to it.
> > >
> > > Good point. I can also just add a temporary transition macro, and then
> > > remove it in the last patch. That way no new macro is needed.
> >
> > Actually, no. There is no compilation break so I did not follow what
> > you mean. The fourth argument to the hlist_for_each_entry_rcu is
> > optional. The only thing that happens is new lockdep warnings will
> > arise which later parts of the series fix by passing in that fourth
> > argument.
>
> Sorry, I missed that subtlety. Might be worth it enabling the lockdep
> warning last in the series...

Good idea, will do! Thanks.
