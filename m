Return-Path: <kernel-hardening-return-16212-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 3D41D4EA5E
	for <lists+kernel-hardening@lfdr.de>; Fri, 21 Jun 2019 16:16:28 +0200 (CEST)
Received: (qmail 25985 invoked by uid 550); 21 Jun 2019 14:16:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 18418 invoked from network); 21 Jun 2019 13:36:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HkLaDd9qBiOze0Unc7G7/2JGdF0V+AxhgqBCBD0faFg=;
        b=BFwyv2mQDtx4K+/JW0i2RDwexDJUJI/57J5SuyOq4zaUthV7Gi5o/XB+H1fyVhFwOf
         GLDaA/0AN8vObSniX9YYTuhiLC9D6ryHBigVjb6Hcg/mdfVO/VLHXY0bPymknAfvLq7N
         NiukfAJshgcG4yckhihCDPqrdd2Bt1fWPg4bFoVggsiMoH+aj5CWoqYh36A1gUCYW1Xp
         fyiKGWrDv/FOV74nSd7onokFxRc2YMOy5TRonm5eUaPNWKaGEKV402KxD6jWs3nbHKSs
         EXuS/VoC9yo7C+eyKb058s5rP6GAzhEWdkEbY7aPUSc4ZhcNwayFOQSf5bkk7GXqQaws
         WxSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HkLaDd9qBiOze0Unc7G7/2JGdF0V+AxhgqBCBD0faFg=;
        b=LCHQ8w0K3e2j9BEhMWuayque54RWUhWL+bpBchoQzfODFTs36cVxDvW2riGcKQEpQz
         v3MjK9MfkMgi1qjP2XQSpyITZSi9yLoMOn7IYi6QsrJ8nLdbpK0KOpM9cw6SysG5W0CG
         tWTkvJTnr/la0t6d/4IIn7hAnIx+KU0e//5LILBfE9QOegvyh/O2jz45etb7V32W7tRt
         Bcj9lt3FtjInzLJ+DmVwUhmamDovAUo4HFXfTSTpDzptRRR5Fvov/rtnHh41AaDx+A0x
         QnMrV64QGB4sJ3mvWPQG3bu2j+3NI8ISe6fWLE8khLVtBp8JkttN9L377u4DIIgdeaLw
         XG3w==
X-Gm-Message-State: APjAAAUoSCdwc0MetAKoDO+aoTICeswe8S+r4QRd8YzvZWVb+DxsUG3X
	PR5aQcDoBY2IAMIY5uSIXROluA==
X-Google-Smtp-Source: APXvYqwcscyJt3FoX0qWZrn2BTYE92bxsBtcJM7Uxw54ZEYNhfDICxku4GsAzZXPcYyvF/1JYrFVVQ==
X-Received: by 2002:a37:a397:: with SMTP id m145mr20209631qke.271.1561124173249;
        Fri, 21 Jun 2019 06:36:13 -0700 (PDT)
Message-ID: <1561124170.5154.43.camel@lca.pw>
Subject: Re: [PATCH v7 1/2] mm: security: introduce init_on_alloc=1 and
 init_on_free=1 boot options
From: Qian Cai <cai@lca.pw>
To: Alexander Potapenko <glider@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@linux.com>,  Kees Cook <keescook@chromium.org>, Masahiro Yamada
 <yamada.masahiro@socionext.com>, Michal Hocko <mhocko@kernel.org>, James
 Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Nick
 Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, 
 Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>,
 Jann Horn <jannh@google.com>,  Mark Rutland <mark.rutland@arm.com>, Marco
 Elver <elver@google.com>, Linux Memory Management List
 <linux-mm@kvack.org>, linux-security-module
 <linux-security-module@vger.kernel.org>, Kernel Hardening
 <kernel-hardening@lists.openwall.com>
Date: Fri, 21 Jun 2019 09:36:10 -0400
In-Reply-To: <CAG_fn=XKK5+nC5LErJ+zo7dt3N-cO7zToz=bN2R891dMG_rncA@mail.gmail.com>
References: <20190617151050.92663-1-glider@google.com>
	 <20190617151050.92663-2-glider@google.com>
	 <1561120576.5154.35.camel@lca.pw>
	 <CAG_fn=XKK5+nC5LErJ+zo7dt3N-cO7zToz=bN2R891dMG_rncA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6 (3.22.6-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 2019-06-21 at 15:31 +0200, Alexander Potapenko wrote:
> On Fri, Jun 21, 2019 at 2:36 PM Qian Cai <cai@lca.pw> wrote:
> > 
> > On Mon, 2019-06-17 at 17:10 +0200, Alexander Potapenko wrote:
> > > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > > index d66bc8abe0af..50a3b104a491 100644
> > > --- a/mm/page_alloc.c
> > > +++ b/mm/page_alloc.c
> > > @@ -136,6 +136,48 @@ unsigned long totalcma_pages __read_mostly;
> > > 
> > >  int percpu_pagelist_fraction;
> > >  gfp_t gfp_allowed_mask __read_mostly = GFP_BOOT_MASK;
> > > +#ifdef CONFIG_INIT_ON_ALLOC_DEFAULT_ON
> > > +DEFINE_STATIC_KEY_TRUE(init_on_alloc);
> > > +#else
> > > +DEFINE_STATIC_KEY_FALSE(init_on_alloc);
> > > +#endif
> > > +#ifdef CONFIG_INIT_ON_FREE_DEFAULT_ON
> > > +DEFINE_STATIC_KEY_TRUE(init_on_free);
> > > +#else
> > > +DEFINE_STATIC_KEY_FALSE(init_on_free);
> > > +#endif
> > > +
> > 
> > There is a problem here running kernels built with clang,
> > 
> > [    0.000000] static_key_disable(): static key 'init_on_free+0x0/0x4' used
> > before call to jump_label_init()
> > [    0.000000] WARNING: CPU: 0 PID: 0 at ./include/linux/jump_label.h:314
> > early_init_on_free+0x1c0/0x200
> > [    0.000000] Modules linked in:
> > [    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 5.2.0-rc5-next-
> > 20190620+
> > #11
> > [    0.000000] pstate: 60000089 (nZCv daIf -PAN -UAO)
> > [    0.000000] pc : early_init_on_free+0x1c0/0x200
> > [    0.000000] lr : early_init_on_free+0x1c0/0x200
> > [    0.000000] sp : ffff100012c07df0
> > [    0.000000] x29: ffff100012c07e20 x28: ffff1000110a01ec
> > [    0.000000] x27: 0000000000000001 x26: ffff100011716f88
> > [    0.000000] x25: ffff100010d367ae x24: ffff100010d367a5
> > [    0.000000] x23: ffff100010d36afd x22: ffff100011716758
> > [    0.000000] x21: 0000000000000000 x20: 0000000000000000
> > [    0.000000] x19: 0000000000000000 x18: 000000000000002e
> > [    0.000000] x17: 000000000000000f x16: 0000000000000040
> > [    0.000000] x15: 0000000000000000 x14: 6d756a206f74206c
> > [    0.000000] x13: 6c61632065726f66 x12: 6562206465737520
> > [    0.000000] x11: 0000000000000000 x10: 0000000000000000
> > [    0.000000] x9 : 0000000000000000 x8 : 0000000000000000
> > [    0.000000] x7 : 73203a2928656c62 x6 : ffff1000144367ad
> > [    0.000000] x5 : ffff100012c07b28 x4 : 000000000000000f
> > [    0.000000] x3 : ffff1000101b36ec x2 : 0000000000000001
> > [    0.000000] x1 : 0000000000000001 x0 : 000000000000005d
> > [    0.000000] Call trace:
> > [    0.000000]  early_init_on_free+0x1c0/0x200
> > [    0.000000]  do_early_param+0xd0/0x104
> > [    0.000000]  parse_args+0x204/0x54c
> > [    0.000000]  parse_early_param+0x70/0x8c
> > [    0.000000]  setup_arch+0xa8/0x268
> > [    0.000000]  start_kernel+0x80/0x588
> > [    0.000000] random: get_random_bytes called from __warn+0x164/0x208 with
> > crng_init=0
> > 
> > > diff --git a/mm/slub.c b/mm/slub.c
> > > index cd04dbd2b5d0..9c4a8b9a955c 100644
> > > --- a/mm/slub.c
> > > +++ b/mm/slub.c
> > > @@ -1279,6 +1279,12 @@ static int __init setup_slub_debug(char *str)
> > >       if (*str == ',')
> > >               slub_debug_slabs = str + 1;
> > >  out:
> > > +     if ((static_branch_unlikely(&init_on_alloc) ||
> > > +          static_branch_unlikely(&init_on_free)) &&
> > > +         (slub_debug & SLAB_POISON)) {
> > > +             pr_warn("disabling SLAB_POISON: can't be used together with
> > > memory auto-initialization\n");
> > > +             slub_debug &= ~SLAB_POISON;
> > > +     }
> > >       return 1;
> > >  }
> > 
> > I don't think it is good idea to disable SLAB_POISON here as if people have
> > decided to enable SLUB_DEBUG later already, they probably care more to make
> > sure
> > those additional checks with SLAB_POISON are still running to catch memory
> > corruption.
> 
> The problem is that freed buffers can't be both poisoned and zeroed at
> the same time.
> Do you think we need to disable memory initialization in that case instead?

Yes, disable init_on_free|alloc and keep SLAB_POISON sounds good to me.
