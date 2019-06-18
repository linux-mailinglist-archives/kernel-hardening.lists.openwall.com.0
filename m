Return-Path: <kernel-hardening-return-16176-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id BFF914989C
	for <lists+kernel-hardening@lfdr.de>; Tue, 18 Jun 2019 07:19:51 +0200 (CEST)
Received: (qmail 26018 invoked by uid 550); 18 Jun 2019 05:19:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 25999 invoked from network); 18 Jun 2019 05:19:45 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1560835173;
	bh=D6idtN2vuJNZSoRrBJEbsCDVqnmpSZdTylzmezC3ViA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=zpPILBBCAqMR9mMbYvimRhFwP9kZjL2AU5MfjZJzY+WvSEkteYVoW+sbq7pdcFPzw
	 7gcuAso+EV/aRtthzZDjhBmjrmxqfdLWq9frm+edibB8kMEZifuHcKNvThHI+539eX
	 cWp7GyxgMkZgpW/SDbOJ6lRDGCDBgF5xmFGDc2Io=
Date: Mon, 17 Jun 2019 22:19:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: Alexander Potapenko <glider@google.com>, Christoph Lameter
 <cl@linux.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michal
 Hocko <mhocko@kernel.org>, James Morris <jmorris@namei.org>,
 "Serge E. Hallyn" <serge@hallyn.com>, Nick Desaulniers
 <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitry
 Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, Laura
 Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Jann
 Horn <jannh@google.com>, Mark Rutland <mark.rutland@arm.com>, Marco Elver
 <elver@google.com>, linux-mm@kvack.org,
 linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v7 1/2] mm: security: introduce init_on_alloc=1 and
 init_on_free=1 boot options
Message-Id: <20190617221932.7406c74b6a8114a406984b70@linux-foundation.org>
In-Reply-To: <201906172157.8E88196@keescook>
References: <20190617151050.92663-1-glider@google.com>
	<20190617151050.92663-2-glider@google.com>
	<20190617151027.6422016d74a7dc4c7a562fc6@linux-foundation.org>
	<201906172157.8E88196@keescook>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 17 Jun 2019 22:07:41 -0700 Kees Cook <keescook@chromium.org> wrote:

> This is expected to be on-by-default on Android and Chrome
> OS. And it gives the opportunity for anyone else to use it under distros
> too via the boot args. (The init_on_free feature is regularly requested
> by folks where memory forensics is included in their thread models.)

Thanks.  I added the above to the changelog.  I assumed s/thread/threat/
