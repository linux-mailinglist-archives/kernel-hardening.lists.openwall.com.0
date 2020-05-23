Return-Path: <kernel-hardening-return-18860-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 65F8F1DF44D
	for <lists+kernel-hardening@lfdr.de>; Sat, 23 May 2020 04:58:21 +0200 (CEST)
Received: (qmail 15454 invoked by uid 550); 23 May 2020 02:58:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 15419 invoked from network); 23 May 2020 02:58:14 -0000
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:967:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2525:2553:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3353:3622:3871:3876:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4605:5007:6119:9025:10004:10400:10848:11026:11232:11658:11914:12043:12297:12555:12740:12760:12895:12986:13069:13311:13357:13439:14181:14659:14721:21080:21451:21627:21811:30054:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: robin60_3f0f18a26d2c
X-Filterd-Recvd-Size: 2777
Message-ID: <beb95a8af767ab38d694f59847d2f2f6692e115a.camel@perches.com>
Subject: Re: [PATCH] x86/mm/init: Stop printing pgt_buf addresses
From: Joe Perches <joe@perches.com>
To: Arvind Sankar <nivedita@alum.mit.edu>
Cc: "Tobin C . Harding" <me@tobin.cc>, Tycho Andersen <tycho@tycho.ws>, 
 kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski
 <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
 linux-kernel@vger.kernel.org
Date: Fri, 22 May 2020 19:57:59 -0700
In-Reply-To: <20200523015129.GA717759@rani.riverdale.lan>
References: <20200229231120.1147527-1-nivedita@alum.mit.edu>
	 <20200523015129.GA717759@rani.riverdale.lan>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.2-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2020-05-22 at 21:51 -0400, Arvind Sankar wrote:
> On Sat, Feb 29, 2020 at 06:11:20PM -0500, Arvind Sankar wrote:
> > This currently leaks kernel physical addresses into userspace.
> > 
> > Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
> > ---
> >  arch/x86/mm/init.c | 2 --
> >  1 file changed, 2 deletions(-)
> > 
> > diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> > index e7bb483557c9..dc4711f09cdc 100644
> > --- a/arch/x86/mm/init.c
> > +++ b/arch/x86/mm/init.c
> > @@ -121,8 +121,6 @@ __ref void *alloc_low_pages(unsigned int num)
> >  	} else {
> >  		pfn = pgt_buf_end;
> >  		pgt_buf_end += num;
> > -		printk(KERN_DEBUG "BRK [%#010lx, %#010lx] PGTABLE\n",
> > -			pfn << PAGE_SHIFT, (pgt_buf_end << PAGE_SHIFT) - 1);
> >  	}
> >  
> >  	for (i = 0; i < num; i++) {
> > -- 
> > 2.24.1
> > 
> 
> Ping.
> 
> https://lore.kernel.org/lkml/20200229231120.1147527-1-nivedita@alum.mit.edu/

If this output is at all valuable,
perhaps emit them as hashed pointers?

Maybe:

---
 arch/x86/mm/init.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 1bba16c5742b..44f0d6592c7e 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -121,8 +121,9 @@ __ref void *alloc_low_pages(unsigned int num)
 	} else {
 		pfn = pgt_buf_end;
 		pgt_buf_end += num;
-		printk(KERN_DEBUG "BRK [%#010lx, %#010lx] PGTABLE\n",
-			pfn << PAGE_SHIFT, (pgt_buf_end << PAGE_SHIFT) - 1);
+		printk(KERN_DEBUG "BRK [0x%8p, 0x%8p] PGTABLE\n",
+		       (void *)(pfn << PAGE_SHIFT),
+		       (void *)((pgt_buf_end << PAGE_SHIFT) - 1));
 	}
 
 	for (i = 0; i < num; i++) {


