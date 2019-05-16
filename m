Return-Path: <kernel-hardening-return-15929-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 3416020CD1
	for <lists+kernel-hardening@lfdr.de>; Thu, 16 May 2019 18:20:20 +0200 (CEST)
Received: (qmail 12212 invoked by uid 550); 16 May 2019 16:20:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 12194 invoked from network); 16 May 2019 16:20:11 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yP0cE4pkGcJKdZW9ZXRUC1LKbWz6dsrqiIXXwI8zTkw=;
        b=OqrofeOSP4xGgbSa919UicUmiJIY7a17QopQmpjZGC12Qp2G0pFiBpicR3AMAuhKAI
         r7C0WU5Smn/UMH1Klt5YhfyIJC7Qjd/AJx7o7zjf/xdnrpP9CXJuO/CXymY3Fqd6uCMm
         If0iGWx2csNJG0uAl7NIatFjqgY/SrMySeC4k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yP0cE4pkGcJKdZW9ZXRUC1LKbWz6dsrqiIXXwI8zTkw=;
        b=bRuYVAzDtMMOyb/nIBJJ0lwm2UPLRCqH07XbqCwezdBehFTqdqKF4vpgns+bvx9qQ2
         XARHzgMw0UvxNqKUk106Rt34qTo2BrX/oIz/GEJOgwr12UJNQMmgT3XxrZ/BKmNQMhrO
         kLcHaIE3puNBn2vEB2FiHCHbFzoRyGUDS9lWUJpJ2NU2ySLoMfLGmI1Bd9on2uXK+deX
         z6v7XwCcqmcMVT+iBym3NhvSuXR5vZc/+O4j7ZwU/LS7VbmLKj8Xf280zmAAcS6dNf4p
         Yoh3xp+Bng0Pzq4PGf6/U8Dx0zzH3luJohcQ2hq1eJOJ4Bi20owExDp/Y0ArEhQFnRwD
         KGyA==
X-Gm-Message-State: APjAAAXKDyhLo2p6rKxL2w2+H8ls1SrqGrOYrZsZ/eeWdUeS84EGKZKa
	Oan6HnJFAz4vnBb7m67Tx9lcKQ==
X-Google-Smtp-Source: APXvYqwwdVxU3RArLVptXXf5WDtbyUwQfbfyfrx6F7sflsYNsu9rOlPCdFs7Ea9DF7EOfykQSK+7Lw==
X-Received: by 2002:a17:902:8c82:: with SMTP id t2mr43276568plo.256.1558023599081;
        Thu, 16 May 2019 09:19:59 -0700 (PDT)
Date: Thu, 16 May 2019 09:19:56 -0700
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
Subject: Re: [PATCH v2 1/4] mm: security: introduce init_on_alloc=1 and
 init_on_free=1 boot options
Message-ID: <201905160907.92FAC880@keescook>
References: <20190514143537.10435-1-glider@google.com>
 <20190514143537.10435-2-glider@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190514143537.10435-2-glider@google.com>

On Tue, May 14, 2019 at 04:35:34PM +0200, Alexander Potapenko wrote:
> Slowdown for the new features compared to init_on_free=0,
> init_on_alloc=0:
> 
> hackbench, init_on_free=1:  +7.62% sys time (st.err 0.74%)
> hackbench, init_on_alloc=1: +7.75% sys time (st.err 2.14%)

I wonder if the patch series should be reorganized to introduce
__GFP_NO_AUTOINIT first, so that when the commit with benchmarks appears,
we get the "final" numbers...

> Linux build with -j12, init_on_free=1:  +8.38% wall time (st.err 0.39%)
> Linux build with -j12, init_on_free=1:  +24.42% sys time (st.err 0.52%)
> Linux build with -j12, init_on_alloc=1: -0.13% wall time (st.err 0.42%)
> Linux build with -j12, init_on_alloc=1: +0.57% sys time (st.err 0.40%)

I'm working on reproducing these benchmarks. I'd really like to narrow
down the +24% number here. But it does 

> The slowdown for init_on_free=0, init_on_alloc=0 compared to the
> baseline is within the standard error.

I think the use of static keys here is really great: this is available
by default for anyone that wants to turn it on.

I'm thinking, given the configuable nature of this, it'd be worth adding
a little more detail at boot time. I think maybe a separate patch could
be added to describe the kernel's memory auto-initialization features,
and add something like this to mm_init():

+void __init report_meminit(void)
+{
+	const char *stack;
+
+	if (IS_ENABLED(CONFIG_INIT_STACK_ALL))
+		stack = "all";
+	else if (IS_ENABLED(CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL))
+		stack = "byref_all";
+	else if (IS_ENABLED(CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF))
+		stack = "byref";
+	else if (IS_ENABLED(CONFIG_GCC_PLUGIN_STRUCTLEAK_USER))
+		stack = "__user";
+	else
+		stack = "off";
+
+	/* Report memory auto-initialization states for this boot. */
+	pr_info("mem auto-init: stack:%s, heap alloc:%s, heap free:%s\n",
+		stack, want_init_on_alloc(GFP_KERNEL) ? "on" : "off",
+		want_init_on_free() ? "on" : "off");
+}

To get a boot line like:

	mem auto-init: stack:off, heap alloc:off, heap free:on

And one other thought I had was that in the init_on_free=1 case, there is
a large pause at boot while memory is being cleared. I think it'd be handy
to include a comment about that, just to keep people from being surprised:

diff --git a/init/main.c b/init/main.c
index cf0c3948ce0e..aea278392338 100644
--- a/init/main.c
+++ b/init/main.c
@@ -529,6 +529,8 @@ static void __init mm_init(void)
 	 * bigger than MAX_ORDER unless SPARSEMEM.
 	 */
 	page_ext_init_flatmem();
+	if (want_init_on_free())
+		pr_info("Clearing system memory ...\n");
 	mem_init();
 	kmem_cache_init();
 	pgtable_init();

Beyond these thoughts, I think this series is in good shape.

Andrew (or anyone else) do you have any concerns about this?

-- 
Kees Cook
