Return-Path: <kernel-hardening-return-16532-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id ACC1670883
	for <lists+kernel-hardening@lfdr.de>; Mon, 22 Jul 2019 20:27:34 +0200 (CEST)
Received: (qmail 13530 invoked by uid 550); 22 Jul 2019 18:27:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 13497 invoked from network); 22 Jul 2019 18:27:27 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	 bh=tGQ3tU84YUPv9anAGKOasBEXJrM8FRAxn66lIhfR02Q=; b=DrTCv0T34g/AEpsLdSUB+OweT
	BU7fu+Dm0wrSTGO41re0jxJH+t+vM9hye9RL1wAr88bj0oPWG70t2JBWoOI48HrxEMlVPACbeN1uu
	/ch/Hmv1HcofsIRa5N2G5LiDoyS7rybkBUntp6Vndt3qIKhBnQTqQWRwkkXEP16OLtG6iVXbr4Ee6
	/dIFiZlM864pj2EDvEf/bCQtAHA6Sm4ltZVMH4ZT8suuvxhHl7Eyy0p7VoDwYOioVWqQhYZyUlQyn
	eVCYgn6N9nZvdHT5OXq2lpHXkTaQNKAVrPqr3EDFcnwZjOk+8HtfltejH6pNYK8GHwVU9i9a/fxB2
	5eGUReVYA==;
Date: Mon, 22 Jul 2019 11:27:04 -0700
From: Matthew Wilcox <willy@infradead.org>
To: Joe Perches <joe@perches.com>
Cc: Kees Cook <keescook@chromium.org>, Nitin Gote <nitin.r.gote@intel.com>,
	akpm@linux-foundation.org, corbet@lwn.net, apw@canonical.com,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com,
	Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: Re: [RFC PATCH] string.h: Add stracpy/stracpy_pad (was: Re: [PATCH]
 checkpatch: Added warnings in favor of strscpy().)
Message-ID: <20190722182703.GE363@bombadil.infradead.org>
References: <1562219683-15474-1-git-send-email-nitin.r.gote@intel.com>
 <f6a4c2b601bb59179cb2e3b8f4d836a1c11379a3.camel@perches.com>
 <d1524130f91d7cfd61bc736623409693d2895f57.camel@perches.com>
 <201907221031.8B87A9DE@keescook>
 <b9bb5550b264d4b29b2b20f7ff8b1b40d20def6a.camel@perches.com>
 <2c959c56c23d0052e5c35ecfa2f6051b17fb2798.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c959c56c23d0052e5c35ecfa2f6051b17fb2798.camel@perches.com>
User-Agent: Mutt/1.11.4 (2019-03-13)

On Mon, Jul 22, 2019 at 10:58:15AM -0700, Joe Perches wrote:
> On Mon, 2019-07-22 at 10:43 -0700, Joe Perches wrote:
> > On Mon, 2019-07-22 at 10:33 -0700, Kees Cook wrote:
> > > On Thu, Jul 04, 2019 at 05:15:57PM -0700, Joe Perches wrote:
> > > > On Thu, 2019-07-04 at 13:46 -0700, Joe Perches wrote:
> > > > > On Thu, 2019-07-04 at 11:24 +0530, Nitin Gote wrote:
> > > > > > Added warnings in checkpatch.pl script to :
> > > > > > 
> > > > > > 1. Deprecate strcpy() in favor of strscpy().
> > > > > > 2. Deprecate strlcpy() in favor of strscpy().
> > > > > > 3. Deprecate strncpy() in favor of strscpy() or strscpy_pad().
> > > > > > 
> > > > > > Updated strncpy() section in Documentation/process/deprecated.rst
> > > > > > to cover strscpy_pad() case.
> > > > 
> > > > []
> > > > 
> > > > I sent a patch series for some strscpy/strlcpy misuses.
> > > > 
> > > > How about adding a macro helper to avoid the misuses like:
> > > > ---
> > > >  include/linux/string.h | 16 ++++++++++++++++
> > > >  1 file changed, 16 insertions(+)
> > > > 
> > > > diff --git a/include/linux/string.h b/include/linux/string.h
> > > > index 4deb11f7976b..ef01bd6f19df 100644
> > > > --- a/include/linux/string.h
> > > > +++ b/include/linux/string.h
> > > > @@ -35,6 +35,22 @@ ssize_t strscpy(char *, const char *, size_t);
> > > >  /* Wraps calls to strscpy()/memset(), no arch specific code required */
> > > >  ssize_t strscpy_pad(char *dest, const char *src, size_t count);
> > > >  
> > > > +#define stracpy(to, from)					\
> > > > +({								\
> > > > +	size_t size = ARRAY_SIZE(to);				\
> > > > +	BUILD_BUG_ON(!__same_type(typeof(*to), char));		\
> > > > +								\
> > > > +	strscpy(to, from, size);				\
> > > > +})

Where does the 'a' in 'stracpy' come from?  Googling around finds other
people using a function called stracpy, but it takes different arguments.
http://stracpy.blogspot.com/ takes a size argument, as does
https://docs.polserver.com/doxygen/html/d5/dce/stracpy_8cpp_source.html

The one in the 'Links' webbrowser (can't find a link to its source) seems
like a strdup clone.

