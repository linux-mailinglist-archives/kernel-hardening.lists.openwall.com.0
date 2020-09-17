Return-Path: <kernel-hardening-return-19911-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 0CA4C26E280
	for <lists+kernel-hardening@lfdr.de>; Thu, 17 Sep 2020 19:33:32 +0200 (CEST)
Received: (qmail 23975 invoked by uid 550); 17 Sep 2020 17:33:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 23955 invoked from network); 17 Sep 2020 17:33:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1600363948;
	bh=AtpaLz5T0doiwW45rKTXhN9OPitxExJgCcjhtNz0x98=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ohypy2arTKNnnt5P7OISH5u0hYMNI9QHrKofdzzgZeUnStbOrMbKMVNOYKh4xW/CT
	 DdVMbhxcC1Qe2rl+QUlZwiTimUC6iyTlXiG9lmFNd7zDu3xrJ+nTV5k+qUalyXpXsI
	 kup9FdV36ywl0bYuqPHc4cYzLP5MNpRkNYBUHOsY=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Date: Thu, 17 Sep 2020 19:32:09 +0200
From: John Wood <john.wood@gmx.com>
To: Jann Horn <jannh@google.com>
Cc: Kees Cook <keescook@chromium.org>, John Wood <john.wood@gmx.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Iurii Zaikin <yzaikin@google.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>, linux-doc@vger.kernel.org,
	kernel list <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-security-module <linux-security-module@vger.kernel.org>
Subject: Re: [RFC PATCH 1/6] security/fbfam: Add a Kconfig to enable the
 fbfam feature
Message-ID: <20200917173209.GA3637@ubuntu>
References: <20200910202107.3799376-1-keescook@chromium.org>
 <20200910202107.3799376-2-keescook@chromium.org>
 <CAG48ez1V=oVczCCSuRaWX=bbN2cOi0Y9q48=e-Fuhg7mwMOi0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez1V=oVczCCSuRaWX=bbN2cOi0Y9q48=e-Fuhg7mwMOi0A@mail.gmail.com>
X-Provags-ID: V03:K1:R5ZkovHXd6oUrfcKmVNF76tjDIn4TAPnGKJDjlfIyNZe9chhDUt
 Esh/G27SFDsxpGe3eTJoHTkEtlKWjMzGSWaf4NY77J0KknyMS4Kn3FifB6lpQ9wSsgJm6aR
 GWM1FOcKZJ7nuqitu7T9wYT0c/x3o41HPECfOOo6S21tnSwhYbEzXGPZ8NK/o/DFW7XB3Cr
 jdRHD05vg7a/XdyN7NGVA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:2EwjqjK0MgQ=:/EQ9AcFBVAGmYLV0pBWY8o
 gGXaUX/Hrs+puPZlxpfVGLXljFqWb6OiDmPwAY2thvJg4l6AbbOyWUdB4nBcfr7iKOdENAuhx
 pQ4bNDY7GY1UU1d6Pv8DcngCqiZaYa4/DawXqocZWNM1Tz5y/bhozMcuP56FRjvuff8OxA+9X
 HLRazrcudN8ngT4em/zcaDW45kFKUZTYutAJd2+EiyDuO85dyqK4jTcEp9KQMx/D8VfAsjLZZ
 Q4wtOIJWsOabrl7PYLK/VxJ5qyz9OPiCUsA1HDP4xMZ80DAokIaZouvDQ+fQmwyZaK7S/wjpI
 Bkfs9DOXHXJLyCkesWegBHVL0VW/faumfNSmW+UgcBUESsbpJ83fBYIjmib/XNZ9e7QbGlSa5
 YrEgFd+CXFX4DXFJSreOitylLWFRvdHQXOwTUpd2edPFkbNncR4gUhuj3r+SThc7SUSaZNzSz
 uURl/7xuQc70tcAeiVkIZENia5TPm+TskYe363azzRMCG/7zehjUIKOqjrAwLozehmz1X4cBi
 AqkSQFkb3bMKHhIMpSqHZsQMpdCOUQPH303CclE8vyHY4MrfzmuyAg0Eb8YYOCW/SAiKckLuS
 JMZ1zc0lzLubYvPgMZ13Q90eMfljXzUF8kEfTSLx/pC3ra4UpvpC5WcJ8Nr0wtxWteHuJsXO1
 c4cxi/F7vkNHk6wUNs1SEJGjdX1DcIrP/opUd3FNsPKVdobJTBB1Ww362z1AilN3N34l/ugCT
 U+O0XR8EtrojZ+EBfPCW0AhNZ2eoRmJC297qrM96zLc2EHMP4DRIel73HJbRt1MncUkmQLkJN
 aMXWoGHiu0kRlECH7Q9uNw17jiSPFliufWs1lLXyuemIetIPyMANdTxT7RItjKu0Ptxn4Ox3d
 2PlT6jxh0+MFIq3oNy6YnQA+xo9VoC/lB9mQFU1by/IJGHucsLX13TQCM/C8cbm5AiHNxYYmE
 BvMl5UbU42mynW17o3O/gPVqDraNibeoll5csMsjYYkWsObrS7rbUQevlLvGaNcRqndummrz6
 GPxkOTfn2/SXeWQVtoTsPYc/KDTFUm3N6PO595ABECxEs+dZSUhC5wjh6ML+HXhe0CFgkyiN+
 cHhIPiVFu1o2hEFblWyOc8X6PP8i2ZQd87HTv6hrOhsbK9CPBlEbFPiATC7F9iJJdXpxPcQuP
 N62qqddxXJ0qJjvYSgwvHQi5cW2GGOzTRSr6rWfV4kvJpdeac0CyuonkHkAnf+IA4Qmz/eq3n
 FaQlsdU1+IuVNDpWlBn7tE3lYxb/PxZdeZwcn7A==
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 10, 2020 at 11:21:58PM +0200, Jann Horn wrote:
> On Thu, Sep 10, 2020 at 10:21 PM Kees Cook <keescook@chromium.org> wrote=
:
> > From: John Wood <john.wood@gmx.com>
> >
> > Add a menu entry under "Security options" to enable the "Fork brute
> > force attack mitigation" feature.
> [...]
> > +config FBFAM
>
> Please give this a more descriptive name than FBFAM. Some name where,
> if a random kernel developer sees an "#ifdef" with that name in some
> random piece of kernel code, they immediately have a rough idea for
> what kind of feature this is.
>
> Perhaps something like THROTTLE_FORK_CRASHES. Or something else that
> is equally descriptive.

Ok, understood. This will be fixed for the next version. Thanks.

> > +       bool "Fork brute force attack mitigation"
> > +       default n
>
> "default n" is superfluous and should AFAIK be omitted.

Ok. I will remove it. Thanks.

> > +       help
> > +         This is a user defense that detects any fork brute force att=
ack
> > +         based on the application's crashing rate. When this measure =
is
> > +         triggered the fork system call is blocked.
>
> This help text claims that the mitigation will block fork(), but patch
> 6/6 actually kills the process hierarchy.

Sorry, it's a mistake. It was the first idea but finally the implementatio=
n
changed and this description not was modified. Apologies. It will be fixed
for the next version.

Thanks,
John Wood
