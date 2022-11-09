Return-Path: <kernel-hardening-return-21589-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by mail.lfdr.de (Postfix) with SMTP id 2CBD7623006
	for <lists+kernel-hardening@lfdr.de>; Wed,  9 Nov 2022 17:20:07 +0100 (CET)
Received: (qmail 32628 invoked by uid 550); 9 Nov 2022 16:19:58 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 32128 invoked from network); 9 Nov 2022 16:19:10 -0000
Date: Wed, 9 Nov 2022 17:19:04 +0100
From: Solar Designer <solar@openwall.com>
To: Kees Cook <keescook@chromium.org>
Cc: Jann Horn <jannh@google.com>, linux-hardening@vger.kernel.org,
	kernel-hardening@lists.openwall.com,
	Greg KH <gregkh@linuxfoundation.org>,
	Linus Torvalds <torvalds@linuxfoundation.org>,
	Seth Jenkins <sethjenkins@google.com>,
	"Eric W . Biederman" <ebiederm@xmission.com>,
	Andy Lutomirski <luto@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] exit: Put an upper limit on how often we can oops
Message-ID: <20221109161904.GA10899@openwall.com>
References: <20221107201317.324457-1-jannh@google.com> <20221107211440.GA4233@openwall.com> <CAG48ez2-xUawSs4ji_+0Bnyn_QTiS930UiOypXreU_RhwhVo_w@mail.gmail.com> <202211080923.8BAEA9980@keescook> <202211081100.AA81FBE964@keescook>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202211081100.AA81FBE964@keescook>
User-Agent: Mutt/1.4.2.3i

On Tue, Nov 08, 2022 at 11:38:22AM -0800, Kees Cook wrote:
> On Tue, Nov 08, 2022 at 09:24:40AM -0800, Kees Cook wrote:
> > On Mon, Nov 07, 2022 at 10:48:20PM +0100, Jann Horn wrote:
> > > On Mon, Nov 7, 2022 at 10:15 PM Solar Designer <solar@openwall.com> wrote:
> > > > On Mon, Nov 07, 2022 at 09:13:17PM +0100, Jann Horn wrote:
> > > > > +oops_limit
> > > > > +==========
> > > > > +
> > > > > +Number of kernel oopses after which the kernel should panic when
> > > > > +``panic_on_oops`` is not set.
> > > >
> > > > Rather than introduce this separate oops_limit, how about making
> > > > panic_on_oops (and maybe all panic_on_*) take the limit value(s) instead
> > > > of being Boolean?  I think this would preserve the current behavior at
> > > > panic_on_oops = 0 and panic_on_oops = 1, but would introduce your
> > > > desired behavior at panic_on_oops = 10000.  We can make 10000 the new
> > > > default.  If a distro overrides panic_on_oops, it probably sets it to 1
> > > > like RHEL does.
> > > >
> > > > Are there distros explicitly setting panic_on_oops to 0?  If so, that
> > > > could be a reason to introduce the separate oops_limit.
> > > >
> > > > I'm not advocating one way or the other - I just felt this should be
> > > > explicitly mentioned and decided on.
> > > 
> > > I think at least internally in the kernel, it probably works better to
> > > keep those two concepts separate? For example, sparc has a function
> > > die_nmi() that uses panic_on_oops to determine whether the system
> > > should panic when a watchdog detects a lockup.
> > 
> > Internally, yes, the kernel should keep "panic_on_oops" to mean "panic
> > _NOW_ on oops?" but I would agree with Solar -- this is a counter as far
> > as userspace is concerned. "Panic on Oops" after 1 oops, 2, oopses, etc.
> > I would like to see this for panic_on_warn too, actually.
> 
> Hm, in looking at this more closely, I think it does make sense as you
> already have it. The count is for the panic_on_oops=0 case, so even in
> userspace, trying to remap that doesn't make a bunch of sense. So, yes,
> let's keep this as-is.

I don't follow your logic there - maybe you got confused?  Yes, as
proposed the count is for panic_on_oops=0, but that's just weird - first
kind of request no panic with panic_on_oops=0, then override that with
oops_limit=10000.  I think it is more natural to request
panic_on_oops=10000 in one step.  Also, I think it is more natural to
preserve panic_on_oops=0's meaning of no panic on Oops.

To me, about the only reason to introduce the override is if we want to
literally override a distro's explicit default of panic_on_oops=0.

Alexander
