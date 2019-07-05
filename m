Return-Path: <kernel-hardening-return-16346-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 61A635FD8D
	for <lists+kernel-hardening@lfdr.de>; Thu,  4 Jul 2019 21:54:10 +0200 (CEST)
Received: (qmail 23737 invoked by uid 550); 4 Jul 2019 19:54:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 23713 invoked from network); 4 Jul 2019 19:54:03 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1562270030;
	bh=D8dJJX8KT2Xl8Nh7bMvZgekUUmiAou9NFBVZsil11Lc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=YrQuDPw+rga1xtwxOX16kcC0a03XtrEZuxO6OMtfMYRlXCWQXEwoRhtzXiTaMi7UH
	 aY85ep5KDVRdkbbC3GGx6CKhK/VzlWNWBObEqB0mE5xBp8a7JvEcKmCN57ocm/RBNl
	 1jkz+TotL/QtoBgpN+wyIXo03MdfNEnor9UGm1Tk=
Date: Thu, 4 Jul 2019 12:53:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexander Potapenko <glider@google.com>
Cc: Christoph Lameter <cl@linux.com>, Kees Cook <keescook@chromium.org>,
 Michal Hocko <mhocko@suse.com>, James Morris
 <jamorris@linux.microsoft.com>, Masahiro Yamada
 <yamada.masahiro@socionext.com>, Michal Hocko <mhocko@kernel.org>, James
 Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Nick
 Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>,
 Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>,
 Jann Horn <jannh@google.com>, Mark Rutland <mark.rutland@arm.com>, Marco
 Elver <elver@google.com>, Qian Cai <cai@lca.pw>, Linux Memory Management
 List <linux-mm@kvack.org>, linux-security-module
 <linux-security-module@vger.kernel.org>, Kernel Hardening
 <kernel-hardening@lists.openwall.com>
Subject: Re: [PATCH v10 1/2] mm: security: introduce init_on_alloc=1 and
 init_on_free=1 boot options
Message-Id: <20190704125349.0dd001629a9c4b8e4cb9f227@linux-foundation.org>
In-Reply-To: <CAG_fn=XYRpeBgLpbwhaF=JfNHa-styydOKq8_SA3vsdMcXNgzw@mail.gmail.com>
References: <20190628093131.199499-1-glider@google.com>
	<20190628093131.199499-2-glider@google.com>
	<20190702155915.ab5e7053e5c0d49e84c6ed67@linux-foundation.org>
	<CAG_fn=XYRpeBgLpbwhaF=JfNHa-styydOKq8_SA3vsdMcXNgzw@mail.gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 3 Jul 2019 13:40:26 +0200 Alexander Potapenko <glider@google.com> wrote:

> > There are unchangelogged alterations between v9 and v10.  The
> > replacement of IS_ENABLED(CONFIG_PAGE_POISONING)) with
> > page_poisoning_enabled().
> In the case I send another version of the patch, do I need to
> retroactively add them to the changelog?

I don't think the world could stand another version ;)

Please simply explain this change for the reviewers?
