Return-Path: <kernel-hardening-return-16179-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id C4D9849A6E
	for <lists+kernel-hardening@lfdr.de>; Tue, 18 Jun 2019 09:23:32 +0200 (CEST)
Received: (qmail 30465 invoked by uid 550); 18 Jun 2019 07:23:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 30430 invoked from network); 18 Jun 2019 07:23:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dEsKaJXoDJkA5TF5UYVq8fg5KxBVITSyK3x9GUtiEtI=;
        b=Q3hIMOin+2zsiD8vYGq/3X6J1SuuZzyIZPPwpUEiQeLrbWpi/e1dq/7SIryYs4OKgc
         z3rBAFLdOtYt5Z6olZwKQ9lf4/HPu177OQzeogJM6fwI+hQdSKKC1Lc2JnWSoyRQ5HQj
         0ZhHg35UUTzkR/GiUtfC7uR78c1KItYhO5Bb4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dEsKaJXoDJkA5TF5UYVq8fg5KxBVITSyK3x9GUtiEtI=;
        b=aYW3n0tykt/pGIwhbO97AuJPTyEeyXe04GQJmg8kPpFOkNih7XfzIw5FttYP4InjBd
         dVZDbHsjw4bob0GPWMEOiM9z8a8JHqifiZ2IckPdOJ14EAWHJyo0/T3Qi+u3KSDldbKK
         R0wwPPx7cYAt5EfjC9Kenudd/HFBRkRkgN4y6J0nWc9vHNA36k8JVQS37oldCw/1hOfZ
         koWC+QDoXonJKFZmgPVPBsJKJfOt1nBHTxyR1woWezWeFxWeTeOWuAzHt/4E+KlL8KQh
         cAz4jNFuLJqCYYTLbGsQHK3ieE49g/bfdS+Z52r4yZYg//Yh3xStKJEjR40cFrxIx2vU
         o6sA==
X-Gm-Message-State: APjAAAXwmgSR3kiCsGqw2/Nqs9z6/1euv7i+H5YMM4quDlhjkOnArXW5
	8jjhJCnmmhKcjwEx6kVqB8KEVw==
X-Google-Smtp-Source: APXvYqzD7fAz73M0c0VOd4C2AvHukf6CXWL7neDgSk4Ft1Gef+dHJA31Bnp0vePUR0O2PI6rnZm4qA==
X-Received: by 2002:a63:5c15:: with SMTP id q21mr1379707pgb.248.1560842594126;
        Tue, 18 Jun 2019 00:23:14 -0700 (PDT)
Date: Tue, 18 Jun 2019 00:23:11 -0700
From: Kees Cook <keescook@chromium.org>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v3 1/3] lkdtm: Check for SMEP clearing protections
Message-ID: <201906180019.EEA60F3@keescook>
References: <20190618045503.39105-1-keescook@chromium.org>
 <20190618045503.39105-2-keescook@chromium.org>
 <580611da-fd97-e82e-b604-581f105416ee@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <580611da-fd97-e82e-b604-581f105416ee@rasmusvillemoes.dk>

On Tue, Jun 18, 2019 at 09:10:13AM +0200, Rasmus Villemoes wrote:
> On 18/06/2019 06.55, Kees Cook wrote:
> 
> > +#else
> > +	pr_err("FAIL: this test is x86_64-only\n");
> > +#endif
> > +}
> 
> Why expose it at all on all other architectures? If you wrap the
> CRASHTYPE() in an #ifdef, you can also guard the whole lkdtm_UNSET_SMEP
> definition (the declaration in lkdtm.h can stay, possibly with a comment
> saying /* x86-64 only */).

My preference for LKDTM is for all the tests to be visible regardless
of architecture so that the testing "environment" doesn't have to change
depending on architecture. I've found it easier to deal with when I ran
test harnesses on Chrome OS where I had cross-architectural scripts.
Doing a side-by-side with a PASS and an XFAIL was more sensible to
compare than a PASS and a missing test.

-- 
Kees Cook
