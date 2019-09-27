Return-Path: <kernel-hardening-return-16948-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 649D3C05DA
	for <lists+kernel-hardening@lfdr.de>; Fri, 27 Sep 2019 14:57:51 +0200 (CEST)
Received: (qmail 15832 invoked by uid 550); 27 Sep 2019 12:57:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 15800 invoked from network); 27 Sep 2019 12:57:44 -0000
X-IronPort-AV: E=Sophos;i="5.64,555,1559512800"; 
   d="scan'208";a="403686033"
Date: Fri, 27 Sep 2019 05:57:28 -0700 (PDT)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: julia@hadrien
To: Joe Perches <joe@perches.com>
cc: Andrew Morton <akpm@linux-foundation.org>, 
    Linus Torvalds <torvalds@linux-foundation.org>, 
    linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, 
    Stephen Kitt <steve@sk2.org>, Kees Cook <keescook@chromium.org>, 
    Nitin Gote <nitin.r.gote@intel.com>, jannh@google.com, 
    kernel-hardening@lists.openwall.com, 
    Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: Re: [PATCH V2 1/2] string: Add stracpy and stracpy_pad mechanisms
In-Reply-To: <56dc4de7e0db153cb10954ac251cb6c27c33da4a.camel@perches.com>
Message-ID: <alpine.DEB.2.21.1909270555030.2143@hadrien>
References: <cover.1563889130.git.joe@perches.com>  <ed4611a4a96057bf8076856560bfbf9b5e95d390.1563889130.git.joe@perches.com>  <20190925145011.c80c89b56fcee3060cf87773@linux-foundation.org> <56dc4de7e0db153cb10954ac251cb6c27c33da4a.camel@perches.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII



On Thu, 26 Sep 2019, Joe Perches wrote:

> On Wed, 2019-09-25 at 14:50 -0700, Andrew Morton wrote:
> > On Tue, 23 Jul 2019 06:51:36 -0700 Joe Perches <joe@perches.com> wrote:
> >
> > > Several uses of strlcpy and strscpy have had defects because the
> > > last argument of each function is misused or typoed.
> > >
> > > Add macro mechanisms to avoid this defect.
> > >
> > > stracpy (copy a string to a string array) must have a string
> > > array as the first argument (dest) and uses sizeof(dest) as the
> > > count of bytes to copy.
> > >
> > > These mechanisms verify that the dest argument is an array of
> > > char or other compatible types like u8 or s8 or equivalent.
> > >
> > > A BUILD_BUG is emitted when the type of dest is not compatible.
> > >
> >
> > I'm still reluctant to merge this because we don't have code in -next
> > which *uses* it.  You did have a patch for that against v1, I believe?
> > Please dust it off and send it along?
>
> https://lore.kernel.org/lkml/CAHk-=wgqQKoAnhmhGE-2PBFt7oQs9LLAATKbYa573UO=DPBE0Q@mail.gmail.com/
>
> I gave up, especially after the snark from Linus
> where he wrote I don't understand this stuff.
>
> He's just too full of himself here merely using
> argument from authority.
>
> Creating and using a function like copy_string with
> both source and destination lengths specified is
> is also potentially a large source of defects where
> the stracpy macro atop strscpy does not have a
> defect path other than the src not being a string
> at all.
>
> I think the analysis of defects in string function
> in the kernel is overly difficult today given the
> number of possible uses of pointer and length in
> strcpy/strncpy/strlcpy/stracpy.
>
> I think also that there is some sense in what he
> wrote against the "word salad" use of str<foo>cpy,
> but using stracpy as a macro when possible instead
> of strscpy also makes the analysis of defects rather
> simpler.
>
> The trivial script cocci I posted works well for the
> simple cases.
>
> https://lore.kernel.org/cocci/66fcdbf607d7d0bea41edb39e5579d63b62b7d84.camel@perches.com/
>
> The more complicated cocci script Julia posted is
> still not quite correct as it required intermediate
> compilation for verification of specified lengths.

The problem seems to be detecting whether the string can reach user level
and knowing whether padding is needed.  There are many cases where the
copied string is a constant and can easily be checked to fit into the
destination.  But without further investigation that I am not able to do
at the moment, it's not clear how to address the user level issue.

julia

>
> https://lkml.org/lkml/2019/7/25/1406
>
> Tell me again if you still want it and maybe the
> couple conversions that mm/ would get.
>
> via:
>
> $ spatch --all-includes --in-place -sp-file str.cpy.cocci mm
> $ git diff --stat -p mm
> --
>  mm/dmapool.c | 2 +-
>  mm/zswap.c   | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/mm/dmapool.c b/mm/dmapool.c
> index fe5d33060415..b3a4feb423f8 100644
> --- a/mm/dmapool.c
> +++ b/mm/dmapool.c
> @@ -158,7 +158,7 @@ struct dma_pool *dma_pool_create(const char *name, struct device *dev,
>  	if (!retval)
>  		return retval;
>
> -	strlcpy(retval->name, name, sizeof(retval->name));
> +	stracpy(retval->name, name);
>
>  	retval->dev = dev;
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 08b6cefae5d8..c6cd38de185a 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -533,7 +533,7 @@ static struct zswap_pool *zswap_pool_create(char *type, char *compressor)
>  	}
>  	pr_debug("using %s zpool\n", zpool_get_type(pool->zpool));
>
> -	strlcpy(pool->tfm_name, compressor, sizeof(pool->tfm_name));
> +	stracpy(pool->tfm_name, compressor);
>  	pool->tfm = alloc_percpu(struct crypto_comp *);
>  	if (!pool->tfm) {
>  		pr_err("percpu alloc failed\n");
>
>
>
>
