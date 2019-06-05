Return-Path: <kernel-hardening-return-16058-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 10A5135572
	for <lists+kernel-hardening@lfdr.de>; Wed,  5 Jun 2019 04:59:23 +0200 (CEST)
Received: (qmail 23670 invoked by uid 550); 5 Jun 2019 02:59:17 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 23652 invoked from network); 5 Jun 2019 02:59:17 -0000
X-Gm-Message-State: APjAAAX885CaQreFyK/OvqwKJCv5Co8GHqng0KX191o5JhXHcw7hvcmS
	wffHwdUCNsneUrt79+5rG3HYsro7J2tLzK1YAFk=
X-Google-Smtp-Source: APXvYqx0zD6+nJsipKcI4YhuafI0LOjO2HohBt0bJDrYS5nqRQkmcFza4mi9SRarsBvA9WtFARtyqran6EnB439LpOM=
X-Received: by 2002:a37:68ca:: with SMTP id d193mr19119973qkc.240.1559703540328;
 Tue, 04 Jun 2019 19:59:00 -0700 (PDT)
MIME-Version: 1.0
References: <20190529123812.43089-1-glider@google.com> <20190529123812.43089-3-glider@google.com>
 <20190531181832.e7c3888870ce9e50db9f69e6@linux-foundation.org>
 <CAG_fn=XBq-ipvZng3hEiGwyQH2rRNFbN_Cj0r+5VoJqou0vovA@mail.gmail.com>
 <201906032010.8E630B7@keescook> <CAPDLWs-JqUx+_sDtsER=keDu9o2NKYQ3mvZVXLY8deXOMZoH=g@mail.gmail.com>
 <CAG_fn=UxfaFVZbtnO0VefKhi3iZUYn5ybe_Nvo0rCOxxA2nn-Q@mail.gmail.com>
In-Reply-To: <CAG_fn=UxfaFVZbtnO0VefKhi3iZUYn5ybe_Nvo0rCOxxA2nn-Q@mail.gmail.com>
From: Kaiwan N Billimoria <kaiwan@kaiwantech.com>
Date: Wed, 5 Jun 2019 08:28:43 +0530
X-Gmail-Original-Message-ID: <CAPDLWs__StRJ3AwXNDL3D=_nEkzB_Hto+8+55V=npw63R6_SMQ@mail.gmail.com>
Message-ID: <CAPDLWs__StRJ3AwXNDL3D=_nEkzB_Hto+8+55V=npw63R6_SMQ@mail.gmail.com>
Subject: Re: [PATCH v5 2/3] mm: init: report memory auto-initialization
 features at boot time
To: Alexander Potapenko <glider@google.com>
Cc: Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@linux.com>, Dmitry Vyukov <dvyukov@google.com>, James Morris <jmorris@namei.org>, 
	Jann Horn <jannh@google.com>, Kostya Serebryany <kcc@google.com>, Laura Abbott <labbott@redhat.com>, 
	Mark Rutland <mark.rutland@arm.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, 
	Matthew Wilcox <willy@infradead.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Sandeep Patil <sspatil@android.com>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Souptick Joarder <jrdr.linux@gmail.com>, Marco Elver <elver@google.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Linux Memory Management List <linux-mm@kvack.org>, 
	linux-security-module <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-CMAE-Envelope: MS4wfFkK7O9VhgDOR2ErfFWuD+E0/t80uuIVDD4pD+G4pY+0gme5vPjYJnonJXg8p0irF7/bzi7hSnqUc1Y07Sn9g7qChrd+Pn0FegpZ9qGEeahZLjbjMSGr
 tBmTmoLIgbfXdtloQyTyiGDxXyJDyTzjECIa9bH8JZKBRQR8MhQuw8LPZl2os5mAf+cfFIUluwIHkYy6bbgDRP97xfyFBoqQrvE=

On Tue, Jun 4, 2019 at 8:36 PM Alexander Potapenko <glider@google.com> wrote:
>
> On Tue, Jun 4, 2019 at 8:01 AM Kaiwan N Billimoria
> <kaiwan@kaiwantech.com> wrote:
> >
> > On Tue, Jun 4, 2019 at 8:44 AM Kees Cook <keescook@chromium.org> wrote:
> > >
> > > On Mon, Jun 03, 2019 at 11:24:49AM +0200, Alexander Potapenko wrote:
> > > > On Sat, Jun 1, 2019 at 3:18 AM Andrew Morton <akpm@linux-foundation.org> wrote:
> > > > >
> > > > > On Wed, 29 May 2019 14:38:11 +0200 Alexander Potapenko <glider@google.com> wrote:
> > > > >
> > > > > > Print the currently enabled stack and heap initialization modes.
> > > > > >
> > > > > > The possible options for stack are:
> > > > > >  - "all" for CONFIG_INIT_STACK_ALL;
> > > > > >  - "byref_all" for CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL;
> > > > > >  - "byref" for CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF;
> > > > > >  - "__user" for CONFIG_GCC_PLUGIN_STRUCTLEAK_USER;
> > > > > >  - "off" otherwise.
> > > > > >
> > > > > > Depending on the values of init_on_alloc and init_on_free boottime
> > > > > > options we also report "heap alloc" and "heap free" as "on"/"off".
> > > > >
> > > > > Why?
> > > > >
> > > > > Please fully describe the benefit to users so that others can judge the
> > > > > desirability of the patch.  And so they can review it effectively, etc.
> > > > I'm going to update the description with the following passage:
> > > >
> > > >     Print the currently enabled stack and heap initialization modes.
> > > >
> > > >     Stack initialization is enabled by a config flag, while heap
> > > >     initialization is configured at boot time with defaults being set
> > > >     in the config. It's more convenient for the user to have all information
> > > >     about these hardening measures in one place.
> > > >
> > > > Does this make sense?
> > > > > Always!
> > > > >
> > > > > > In the init_on_free mode initializing pages at boot time may take some
> > > > > > time, so print a notice about that as well.
> > > > >
> > > > > How much time?
> > > > I've seen pauses up to 1 second, not actually sure they're worth a
> > > > separate line in the log.
> > > > Kees, how long were the delays in your case?
> > >
> > > I didn't measure it, but I think it was something like 0.5 second per GB.
> > > I noticed because normally boot flashes by. With init_on_free it pauses
> > > for no apparent reason, which is why I suggested the note. (I mean *I*
> > > knew why it was pausing, but it might surprise someone who sets
> > > init_on_free=1 without really thinking about what's about to happen at
> > > boot.)
> >
> > (Pardon the gmail client)
> > How about:
> > - if (want_init_on_free())
> > -               pr_info("Clearing system memory may take some time...\n");
> > +  if (want_init_on_free())
> > +              pr_info("meminit: clearing system memory may take some
> > time...\n");
> Yes, adding a prefix may give the users better understanding of who's
> clearing the memory.
> We should stick to the same prefix as before though, i.e. "mem auto-init"

True, agreed.
--
Kaiwan
