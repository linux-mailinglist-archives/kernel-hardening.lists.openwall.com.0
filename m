Return-Path: <kernel-hardening-return-16294-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id B6371586E7
	for <lists+kernel-hardening@lfdr.de>; Thu, 27 Jun 2019 18:22:02 +0200 (CEST)
Received: (qmail 32026 invoked by uid 550); 27 Jun 2019 16:21:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 31993 invoked from network); 27 Jun 2019 16:21:56 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=a11qEPyS+a9erWsxAU6/c8TjLgk6sFl5CXvB3mQcz9I=;
        b=nKfkCXy5eCVuDoeIFTGkYIqnKuEEM2ST1LszbWDR11xwtGgLe1J0hp+k1up1ZAtfdS
         ni/O5Jix3CqmfCyfbFkkYc/vadpPk/kq6xfwNHbcCZu9kBHlftrKl61ycNdWBjP3QjjN
         EhUHh4stl6e7oE1nwVTDN4xoBxsiXNrBS191U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=a11qEPyS+a9erWsxAU6/c8TjLgk6sFl5CXvB3mQcz9I=;
        b=U7Ntjbg0uedhWeV/UAklbiBM9hhN5kKzic5o+Wl7cAYV0XiQpsrXOdLr1RWEVOpT9i
         mYNNWWl9ztcAoF3NH7rsqocN2c/RnDWOvS13op3VBmGgSm9kNqiOL2kQhBCG3ls1T1ih
         DCinON/Ab8SoiNkKg8lbUJ1+yQtwc3+2jwqLwVOIDyVOlXQLVXLLlcjeylJJrf9+ad6w
         FZClTUXGBHUXSn/mUANbeMw1tGCjgAAaKCh/nihYmchrVToHfb+gxn61i36R/7GO6A5A
         pAw0wtRPUK2pHyVcLV49hgn9qfu7Ndko2emD/6YtBfeTOFVrjWJ7lTsjZT8zPjUoUcqr
         z7mA==
X-Gm-Message-State: APjAAAXDC8fo9mfI/GposIqpBLSJN54JNuHiOTfrdRB+WflioCGj+B0r
	UMw1bdya9HezVGNvueZWJlKRDw==
X-Google-Smtp-Source: APXvYqxhqvqy4C1utQ6meUJYk1YN8mhKuYds8OVyKDpmSXZV9Kgo2OSl15P/4pWzp4FpPs2Ix4uA8Q==
X-Received: by 2002:a17:902:9a95:: with SMTP id w21mr5587234plp.126.1561652504748;
        Thu, 27 Jun 2019 09:21:44 -0700 (PDT)
Date: Thu, 27 Jun 2019 09:21:42 -0700
From: Kees Cook <keescook@chromium.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: "Gote, Nitin R" <nitin.r.gote@intel.com>,
	"kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Subject: Re: Regarding have kfree() (and related) set the pointer to NULL too
Message-ID: <201906270908.28E5E1FDC3@keescook>
References: <12356C813DFF6F479B608F81178A561586BDFE@BGSMSX101.gar.corp.intel.com>
 <CAOMGZ=FfWUf=2wMKXJVOsfr5b394ERUbhQehEFOtMx8zh26M4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOMGZ=FfWUf=2wMKXJVOsfr5b394ERUbhQehEFOtMx8zh26M4w@mail.gmail.com>

On Thu, Jun 27, 2019 at 01:45:06PM +0200, Vegard Nossum wrote:
> On Thu, 27 Jun 2019 at 12:23, Gote, Nitin R <nitin.r.gote@intel.com> wrote:
> > Hi,
> >
> > I’m looking  into “have kfree() (and related) set the pointer to NULL too” task.
> >
> > As per my understanding, I did below changes :
> >
> > Could you please provide some points on below ways ?
> > @@ -3754,6 +3754,7 @@ void kfree(const void *objp)
> >         debug_check_no_obj_freed(objp, c->object_size);
> >         __cache_free(c, (void *)objp, _RET_IP_);
> >         local_irq_restore(flags);
> > +       objp = NULL;
> >
> > }
> 
> This will not do anything, since the assignment happens to the local
> variable inside kfree() rather than to the original expression that
> was passed to it as an argument.
> 
> Consider that the code in the caller looks like this:
> 
> void *x = kmalloc(...);
> kfree(x);
> pr_info("x = %p\n", x);
> 
> this will still print "x = (some non-NULL address)" because the
> variable 'x' in the caller still retains its original value.
> 
> You could try wrapping kfree() in a C macro, something like
> 
> #define kfree(x) real_kfree(x); (x) = NULL;

Right, though we want to avoid silent double-evaluation, so we have to
do some macro tricks. I suspect the starting point is something like:

#define kfree(x)			\
	do {				\
		typeof(x) *ptr = &(x);	\
		real_kfree(*ptr);	\
		*ptr = NULL;		\
	} while (0)

However, there are a non-zero number of places in the kernel where kfree()
is used on things that are not simple memory references, like function
return values, or copies of the actual reference:

	kfree(get_my_allocation(foo));

or

	previous = something->allocation;
	...
	kfree(prevous)

So the larger work is figuring out how to gracefully deal with those
using a reasonable API, or through refactoring.

However, before getting too far, it's worth going though past
use-after-free vulnerabilities to figure out how many would have been
rendered harmless (NULL deref instead of UaF) with this change. Has this
been studied before, etc. With this information it's easier to decide
if the benefit of this refactoring is worth the work to do it.

-- 
Kees Cook
