Return-Path: <kernel-hardening-return-16942-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 977B7BED7E
	for <lists+kernel-hardening@lfdr.de>; Thu, 26 Sep 2019 10:35:30 +0200 (CEST)
Received: (qmail 17764 invoked by uid 550); 26 Sep 2019 08:35:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 17732 invoked from network); 26 Sep 2019 08:35:24 -0000
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::,RULES_HIT:41:355:379:599:800:960:967:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1394:1437:1515:1516:1518:1534:1543:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2525:2553:2560:2565:2682:2685:2691:2692:2828:2859:2915:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3355:3622:3653:3865:3866:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:6119:7903:8957:8985:9025:10004:10128:10400:10848:10967:11026:11232:11658:11914:12043:12050:12296:12297:12438:12555:12663:12740:12760:12895:12986:13019:13132:13141:13161:13229:13230:13231:13439:14181:14659:14721:21080:21433:21627:21740:21788:21811:30012:30029:30034:30054:30069:30079:30083:30090:30091,0,RBL:172.58.27.131:@perches.com:.lbl8.mailshell.net-62.14.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:
X-HE-Tag: mark42_83ec9d085000a
X-Filterd-Recvd-Size: 4603
Message-ID: <56dc4de7e0db153cb10954ac251cb6c27c33da4a.camel@perches.com>
Subject: Re: [PATCH V2 1/2] string: Add stracpy and stracpy_pad mechanisms
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, Julia Lawall
	 <julia.lawall@lip6.fr>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
 linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Stephen
 Kitt <steve@sk2.org>, Kees Cook <keescook@chromium.org>, Nitin Gote
 <nitin.r.gote@intel.com>, jannh@google.com,
 kernel-hardening@lists.openwall.com,  Rasmus Villemoes
 <rasmus.villemoes@prevas.dk>
Date: Thu, 26 Sep 2019 01:34:36 -0700
In-Reply-To: <20190925145011.c80c89b56fcee3060cf87773@linux-foundation.org>
References: <cover.1563889130.git.joe@perches.com>
	 <ed4611a4a96057bf8076856560bfbf9b5e95d390.1563889130.git.joe@perches.com>
	 <20190925145011.c80c89b56fcee3060cf87773@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.32.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2019-09-25 at 14:50 -0700, Andrew Morton wrote:
> On Tue, 23 Jul 2019 06:51:36 -0700 Joe Perches <joe@perches.com> wrote:
> 
> > Several uses of strlcpy and strscpy have had defects because the
> > last argument of each function is misused or typoed.
> > 
> > Add macro mechanisms to avoid this defect.
> > 
> > stracpy (copy a string to a string array) must have a string
> > array as the first argument (dest) and uses sizeof(dest) as the
> > count of bytes to copy.
> > 
> > These mechanisms verify that the dest argument is an array of
> > char or other compatible types like u8 or s8 or equivalent.
> > 
> > A BUILD_BUG is emitted when the type of dest is not compatible.
> > 
> 
> I'm still reluctant to merge this because we don't have code in -next
> which *uses* it.  You did have a patch for that against v1, I believe? 
> Please dust it off and send it along?

https://lore.kernel.org/lkml/CAHk-=wgqQKoAnhmhGE-2PBFt7oQs9LLAATKbYa573UO=DPBE0Q@mail.gmail.com/

I gave up, especially after the snark from Linus
where he wrote I don't understand this stuff.

He's just too full of himself here merely using
argument from authority.

Creating and using a function like copy_string with
both source and destination lengths specified is
is also potentially a large source of defects where
the stracpy macro atop strscpy does not have a
defect path other than the src not being a string
at all.

I think the analysis of defects in string function
in the kernel is overly difficult today given the
number of possible uses of pointer and length in
strcpy/strncpy/strlcpy/stracpy.

I think also that there is some sense in what he
wrote against the "word salad" use of str<foo>cpy,
but using stracpy as a macro when possible instead
of strscpy also makes the analysis of defects rather
simpler.

The trivial script cocci I posted works well for the
simple cases.

https://lore.kernel.org/cocci/66fcdbf607d7d0bea41edb39e5579d63b62b7d84.camel@perches.com/

The more complicated cocci script Julia posted is
still not quite correct as it required intermediate
compilation for verification of specified lengths.

https://lkml.org/lkml/2019/7/25/1406

Tell me again if you still want it and maybe the
couple conversions that mm/ would get.

via:

$ spatch --all-includes --in-place -sp-file str.cpy.cocci mm
$ git diff --stat -p mm
--
 mm/dmapool.c | 2 +-
 mm/zswap.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/dmapool.c b/mm/dmapool.c
index fe5d33060415..b3a4feb423f8 100644
--- a/mm/dmapool.c
+++ b/mm/dmapool.c
@@ -158,7 +158,7 @@ struct dma_pool *dma_pool_create(const char *name, struct device *dev,
 	if (!retval)
 		return retval;
 
-	strlcpy(retval->name, name, sizeof(retval->name));
+	stracpy(retval->name, name);
 
 	retval->dev = dev;
 
diff --git a/mm/zswap.c b/mm/zswap.c
index 08b6cefae5d8..c6cd38de185a 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -533,7 +533,7 @@ static struct zswap_pool *zswap_pool_create(char *type, char *compressor)
 	}
 	pr_debug("using %s zpool\n", zpool_get_type(pool->zpool));
 
-	strlcpy(pool->tfm_name, compressor, sizeof(pool->tfm_name));
+	stracpy(pool->tfm_name, compressor);
 	pool->tfm = alloc_percpu(struct crypto_comp *);
 	if (!pool->tfm) {
 		pr_err("percpu alloc failed\n");



