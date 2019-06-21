Return-Path: <kernel-hardening-return-16206-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 199794E2C2
	for <lists+kernel-hardening@lfdr.de>; Fri, 21 Jun 2019 11:12:20 +0200 (CEST)
Received: (qmail 28249 invoked by uid 550); 21 Jun 2019 09:12:14 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 28228 invoked from network); 21 Jun 2019 09:12:13 -0000
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Date: Fri, 21 Jun 2019 11:11:59 +0200
From: Michal Hocko <mhocko@kernel.org>
To: Alexander Potapenko <glider@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>, Kees Cook <keescook@chromium.org>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Kostya Serebryany <kcc@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Sandeep Patil <sspatil@android.com>,
	Laura Abbott <labbott@redhat.com>,
	Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>,
	Mark Rutland <mark.rutland@arm.com>, Marco Elver <elver@google.com>,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-security-module <linux-security-module@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: [PATCH v7 1/2] mm: security: introduce init_on_alloc=1 and
 init_on_free=1 boot options
Message-ID: <20190621091159.GD3429@dhcp22.suse.cz>
References: <20190617151050.92663-1-glider@google.com>
 <20190617151050.92663-2-glider@google.com>
 <20190621070905.GA3429@dhcp22.suse.cz>
 <CAG_fn=UFj0Lzy3FgMV_JBKtxCiwE03HVxnR8=f9a7=4nrUFXSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG_fn=UFj0Lzy3FgMV_JBKtxCiwE03HVxnR8=f9a7=4nrUFXSw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Fri 21-06-19 10:57:35, Alexander Potapenko wrote:
> On Fri, Jun 21, 2019 at 9:09 AM Michal Hocko <mhocko@kernel.org> wrote:
[...]
> > > diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
> > > index fd5c95ff9251..2f75dd0d0d81 100644
> > > --- a/kernel/kexec_core.c
> > > +++ b/kernel/kexec_core.c
> > > @@ -315,7 +315,7 @@ static struct page *kimage_alloc_pages(gfp_t gfp_mask, unsigned int order)
> > >               arch_kexec_post_alloc_pages(page_address(pages), count,
> > >                                           gfp_mask);
> > >
> > > -             if (gfp_mask & __GFP_ZERO)
> > > +             if (want_init_on_alloc(gfp_mask))
> > >                       for (i = 0; i < count; i++)
> > >                               clear_highpage(pages + i);
> > >       }
> >
> > I am not really sure I follow here. Why do we want to handle
> > want_init_on_alloc here? The allocated memory comes from the page
> > allocator and so it will get zeroed there. arch_kexec_post_alloc_pages
> > might touch the content there but is there any actual risk of any kind
> > of leak?
> You're right, we don't want to initialize this memory if init_on_alloc is on.
> We need something along the lines of:
>   if (!static_branch_unlikely(&init_on_alloc))
>     if (gfp_mask & __GFP_ZERO)
>       // clear the pages
> 
> Another option would be to disable initialization in alloc_pages() using a flag.

Or we can simply not care and keen the code the way it is. First of all
it seems that nobody actually does use __GFP_ZERO unless I have missed
soemthing
	- kimage_alloc_pages(KEXEC_CONTROL_MEMORY_GFP, order); # GFP_KERNEL | __GFP_NORETRY
	- kimage_alloc_pages(gfp_mask, 0);
		- kimage_alloc_page(image, GFP_KERNEL, KIMAGE_NO_DEST);
		- kimage_alloc_page(image, GFP_HIGHUSER, maddr);

but even if we actually had a user do we care about double intialization
for something kexec related? It is not any hot path AFAIR.

-- 
Michal Hocko
SUSE Labs
