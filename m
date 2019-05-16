Return-Path: <kernel-hardening-return-15931-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 8019A20D70
	for <lists+kernel-hardening@lfdr.de>; Thu, 16 May 2019 18:53:22 +0200 (CEST)
Received: (qmail 11871 invoked by uid 550); 16 May 2019 16:53:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 11853 invoked from network); 16 May 2019 16:53:15 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6LcSRBYGYblE8KnG9YkzHNeJWSKv1kS+36NXuNsO3Vk=;
        b=ibB5Z1OYQwc98aDEYCmgshR4HnNV1ewVWdMdm/6CKYXPVekT2bhzH4PkYIc0CBN6g0
         3RVcq3LMmZ5Q5lyRNGhCySSZnXDeQlR3o+rYJ7XjtWaWqiP4S8z4OyyjXHTScR2eI/lD
         BGuI6KsW5NIL4fQ067WG0tUG+O+QUq3y5B3pg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6LcSRBYGYblE8KnG9YkzHNeJWSKv1kS+36NXuNsO3Vk=;
        b=sDht0dCO3cKO0k3kyGT+/7m+FSD7xgvH9P/N8zWCKBFD5OQ571jroHqSAZ2XNOODbo
         VSclBwKAdK0zcbC8ktsbWOQtAtGPBcwoxv5gMbW//0SnYCQ/t5WLiANvn9P1kHIfxDQ4
         ef17bTsI0AeBXOgBfk1XhTHj4mTStXGu/DKTneqHSocnGPkDrQsOudD0XtbKY13qTXEx
         a20rFSSD2HXABasz96oQofHAbJN+pYhTXQxBzaY7ag5i4iGyopfMdEQ0QbRqcqt2zbOG
         /t5mwKS1XSe4sO1lnUdJoTnOAK2INydbtqkiMeJjzM6Rvdu96WlnmjVEkYRS5FjeI87c
         v5Cw==
X-Gm-Message-State: APjAAAW5be+GpLrEJAzvNJVa5EvJdaAtrENsWah97pmUd8fOlSD1aFe5
	NSP07mcbi6nyHT0S1tzBTLq0Cw==
X-Google-Smtp-Source: APXvYqzxktrdR74/jozDFmScyT7V6rFj+OxDZS8IbmNkChFWgpOSZeP4blgwp9KkSVtUQXVkKb0mfw==
X-Received: by 2002:a17:902:7797:: with SMTP id o23mr50309891pll.147.1558025583725;
        Thu, 16 May 2019 09:53:03 -0700 (PDT)
Date: Thu, 16 May 2019 09:53:01 -0700
From: Kees Cook <keescook@chromium.org>
To: Alexander Potapenko <glider@google.com>
Cc: akpm@linux-foundation.org, cl@linux.com,
	kernel-hardening@lists.openwall.com,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Kostya Serebryany <kcc@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Sandeep Patil <sspatil@android.com>,
	Laura Abbott <labbott@redhat.com>,
	Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>,
	Mark Rutland <mark.rutland@arm.com>, linux-mm@kvack.org,
	linux-security-module@vger.kernel.org
Subject: Re: [PATCH v2 4/4] net: apply __GFP_NO_AUTOINIT to AF_UNIX sk_buff
 allocations
Message-ID: <201905160923.BD3E530EFC@keescook>
References: <20190514143537.10435-1-glider@google.com>
 <20190514143537.10435-5-glider@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190514143537.10435-5-glider@google.com>

On Tue, May 14, 2019 at 04:35:37PM +0200, Alexander Potapenko wrote:
> Add sock_alloc_send_pskb_noinit(), which is similar to
> sock_alloc_send_pskb(), but allocates with __GFP_NO_AUTOINIT.
> This helps reduce the slowdown on hackbench in the init_on_alloc mode
> from 6.84% to 3.45%.

Out of curiosity, why the creation of the new function over adding a
gfp flag argument to sock_alloc_send_pskb() and updating callers? (There
are only 6 callers, and this change already updates 2 of those.)

> Slowdown for the initialization features compared to init_on_free=0,
> init_on_alloc=0:
> 
> hackbench, init_on_free=1:  +7.71% sys time (st.err 0.45%)
> hackbench, init_on_alloc=1: +3.45% sys time (st.err 0.86%)

In the commit log it might be worth mentioning that this is only
changing the init_on_alloc case (in case it's not already obvious to
folks). Perhaps there needs to be a split of __GFP_NO_AUTOINIT into
__GFP_NO_AUTO_ALLOC_INIT and __GFP_NO_AUTO_FREE_INIT? Right now __GFP_NO_AUTOINIT is only checked for init_on_alloc:

static inline bool want_init_on_alloc(gfp_t flags)
{
        if (static_branch_unlikely(&init_on_alloc))
                return !(flags & __GFP_NO_AUTOINIT);
        return flags & __GFP_ZERO;
}
...
static inline bool want_init_on_free(void)
{
        return static_branch_unlikely(&init_on_free);
}

On a related note, it might be nice to add an exclusion list to
the kmem_cache_create() cases, since it seems likely that further
tuning will be needed there. For example, with the init_on_free-similar
PAX_MEMORY_SANITIZE changes in the last public release of PaX/grsecurity,
the following were excluded from wipe-on-free:

	buffer_head
	names_cache
	mm_struct
	vm_area_struct
	anon_vma
	anon_vma_chain
	skbuff_head_cache
	skbuff_fclone_cache

Adding these and others (with details on why they were selected),
might improve init_on_free performance further without trading too
much coverage.

Having a kernel param with a comma-separated list of cache names and
the logic to add __GFP_NO_AUTOINIT at creation time would be a nice
(and cheap!) debug feature to let folks tune things for their specific
workloads, if they choose to. (And it could maybe also know what "none"
meant, to actually remove the built-in exclusions, similar to what
PaX's "pax_sanitize_slab=full" does.)

-- 
Kees Cook
