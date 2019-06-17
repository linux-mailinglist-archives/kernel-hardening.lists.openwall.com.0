Return-Path: <kernel-hardening-return-16170-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id B46D2494CD
	for <lists+kernel-hardening@lfdr.de>; Tue, 18 Jun 2019 00:10:48 +0200 (CEST)
Received: (qmail 27818 invoked by uid 550); 17 Jun 2019 22:10:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 27788 invoked from network); 17 Jun 2019 22:10:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1560809428;
	bh=6hk1cXgfeLMtsbZeOg0ZmMrTcg85OizuNzmzx7hw5Qk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=H48R91d0qMOGPYc36iLZLmJlRYEKAuboBC6PlZ9ejBJSJze08FWJ9JVor9FNIsA7u
	 lYq2c89IGdozntcAfBaEyx4Rd8jMHeGcEzDqBs2fxtvbpqhd0ZqIb3uoby3nU4r+NA
	 QC6TyqKkmVl9RQzC6UReWmI4QGQ4j6deJdV8sc14=
Date: Mon, 17 Jun 2019 15:10:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexander Potapenko <glider@google.com>
Cc: Christoph Lameter <cl@linux.com>, Kees Cook <keescook@chromium.org>,
 Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Hocko
 <mhocko@kernel.org>, James Morris <jmorris@namei.org>, "Serge E. Hallyn"
 <serge@hallyn.com>, Nick Desaulniers <ndesaulniers@google.com>, Kostya
 Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep
 Patil <sspatil@android.com>, Laura Abbott <labbott@redhat.com>, Randy
 Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>, Mark Rutland
 <mark.rutland@arm.com>, Marco Elver <elver@google.com>, linux-mm@kvack.org,
 linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v7 1/2] mm: security: introduce init_on_alloc=1 and
 init_on_free=1 boot options
Message-Id: <20190617151027.6422016d74a7dc4c7a562fc6@linux-foundation.org>
In-Reply-To: <20190617151050.92663-2-glider@google.com>
References: <20190617151050.92663-1-glider@google.com>
	<20190617151050.92663-2-glider@google.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 17 Jun 2019 17:10:49 +0200 Alexander Potapenko <glider@google.com> wrote:

> Slowdown for the new features compared to init_on_free=0,
> init_on_alloc=0:
> 
> hackbench, init_on_free=1:  +7.62% sys time (st.err 0.74%)
> hackbench, init_on_alloc=1: +7.75% sys time (st.err 2.14%)

Sanity check time.  Is anyone really going to use this?  Seriously,
honestly, for real?  If "yes" then how did we determine that?

Also, a bit of a nit: "init_on_alloc" and "init_on_free" aren't very
well chosen names for the boot options - they could refer to any kernel
object at all, really.  init_pages_on_alloc would be better?  I don't think
this matters much - the boot options are already chaotic.  But still...


