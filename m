Return-Path: <kernel-hardening-return-15932-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 1E14C20DAD
	for <lists+kernel-hardening@lfdr.de>; Thu, 16 May 2019 19:03:39 +0200 (CEST)
Received: (qmail 22487 invoked by uid 550); 16 May 2019 17:03:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 22434 invoked from network); 16 May 2019 17:03:31 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2OkSls3BBuVCd2Q9OzzUfEJIECS5yJPO8xcocfnTaN4=;
        b=Ros4p2hkOqmoHbdixDDcfrW1H7jyK9zIQYjqlUFzXr5CiZP+1t7cTKrai4i8J8Q1Jc
         TzF8dMleKNk7RbmmoaakWyHRVMp2G/Ig5tkzDXUlXt800e0jwOfhD+WEBmHapdlbmP4M
         EBbEoq8OjOlQ/XJdZ16uZvhYu/dMHPBTDkc+c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2OkSls3BBuVCd2Q9OzzUfEJIECS5yJPO8xcocfnTaN4=;
        b=NfT2zJBrqM2QcTrEm8MNM16iVQHs8Kop2aO/yFJTQFUe3dXESIjcTdYy/co0o7ffCK
         QAgkVjNBB8BQz2kQVEGm899YEeG9JNUK1IzvlupveEld7Xwz80pBjhQw9zs2pKcspWEC
         n0Vbf4e7U+FQyd+NKhCEZ7OKfBK3/pnKY+bpRiqtlEhjlm/cBt3wLUqcePCF3evADO5P
         GmJ7XUlp1fCcVDOgp6SqsGJZjzo8wWDiD8xJkqBc/CbBXmnTg8PtFW8Z6FDhWevQFRs4
         c1v97DlJtgv2BccpFApCMEnSaciboTDS8ol3EZ5NfcXXlP9D+/dkMjCIzmGC22L5gGjN
         egKw==
X-Gm-Message-State: APjAAAVhiKCOCm0Q8VE5fGFt6DmqOh/o5rFyGdsQbLMpAlzYhVW8j8nI
	clKwpYEYNKEE9+RCSJL4oeuJ/w==
X-Google-Smtp-Source: APXvYqxf86X0I5LWFcSKWu+jd0qD6qpD2y7bXzGg9HBoYqsOh3qhcsFm36RFG3tU2Ws97h56kHXWnw==
X-Received: by 2002:aa7:9a8c:: with SMTP id w12mr54743779pfi.187.1558026193892;
        Thu, 16 May 2019 10:03:13 -0700 (PDT)
Date: Thu, 16 May 2019 10:03:11 -0700
From: Kees Cook <keescook@chromium.org>
To: Alexander Potapenko <glider@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Kostya Serebryany <kcc@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Sandeep Patil <sspatil@android.com>,
	Laura Abbott <labbott@redhat.com>,
	Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-security-module <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] mm: security: introduce init_on_alloc=1 and
 init_on_free=1 boot options
Message-ID: <201905160953.903FD364BC@keescook>
References: <20190514143537.10435-1-glider@google.com>
 <20190514143537.10435-2-glider@google.com>
 <201905160907.92FAC880@keescook>
 <CAG_fn=VsJmyuEUYy16R_M5Hu2CX-PJkz9Kw4rdy9XUCAYHwV5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG_fn=VsJmyuEUYy16R_M5Hu2CX-PJkz9Kw4rdy9XUCAYHwV5g@mail.gmail.com>

On Thu, May 16, 2019 at 06:42:37PM +0200, Alexander Potapenko wrote:
> I suspect the slowdown of init_on_free is bigger than that of
> PAX_SANITIZE_MEMORY, as we've set the goal to have fully zeroed memory
> at alloc time.
> If we want a mode that only wipes the user data upon free() but
> doesn't eliminate all uninit memory, then we can make it faster.

Yeah, I sent a separate email that discusses this a bit more.

I think the goals of init_on_alloc and init_on_free are likely a bit
different. Given init_on_alloc's much more cache-friendly performance,
I think that it's likely the right way forward for getting to fully zeroed
memory at alloc time. (Though I note that it already includes exclusions:
such tradeoffs won't be unique to init_on_free.)

init_on_free appears to give us similar coverage (but also reduces the
lifetime of unused data), but isn't cache-friendly so it looks to need
a lot more tuning/trade-offs. (Not that we shouldn't include it! It'll
just need a bit more care to be reasonable.)

> > +void __init report_meminit(void)
> > +{
> > +       const char *stack;
> > +
> > +       if (IS_ENABLED(CONFIG_INIT_STACK_ALL))
> > +               stack = "all";
> > +       else if (IS_ENABLED(CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL))
> > +               stack = "byref_all";
> > +       else if (IS_ENABLED(CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF))
> > +               stack = "byref";
> > +       else if (IS_ENABLED(CONFIG_GCC_PLUGIN_STRUCTLEAK_USER))
> > +               stack = "__user";
> > +       else
> > +               stack = "off";
> > +
> > +       /* Report memory auto-initialization states for this boot. */
> > +       pr_info("mem auto-init: stack:%s, heap alloc:%s, heap free:%s\n",
> > +               stack, want_init_on_alloc(GFP_KERNEL) ? "on" : "off",
> > +               want_init_on_free() ? "on" : "off");
> > +}
> >
> > To get a boot line like:
> >
> >         mem auto-init: stack:off, heap alloc:off, heap free:on
> For stack there's no binary on/off, as you can potentially build half
> of the kernel with stack instrumentation and another half without it.
> We could make the instrumentation insert a static global flag into
> each translation unit, but this won't give us any interesting info.

Well, yes, that's technically true, but I think reporting the kernel
config here would make sense. If someone intentionally bypasses the
stack auto-init for portions of the kernel, we can't meaningfully report
it here. There will be exceptions for stack auto-init and heap auto-init.

-- 
Kees Cook
