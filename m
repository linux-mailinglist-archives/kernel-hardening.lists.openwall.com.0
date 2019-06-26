Return-Path: <kernel-hardening-return-16271-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 035D7574E7
	for <lists+kernel-hardening@lfdr.de>; Thu, 27 Jun 2019 01:28:55 +0200 (CEST)
Received: (qmail 21784 invoked by uid 550); 26 Jun 2019 23:28:49 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 21766 invoked from network); 26 Jun 2019 23:28:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1561591716;
	bh=bvxU9GtnxrSS6JL5vSuxzibwl2B9AdNA5bQBLj2CaHo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=zmegpjl0RaiGNlS93NVud3hTVj0twmtsxSir+O4KVOYh5+Vxzeaoc1YAvUKF3f2na
	 9F1F4ANmd9ITzobFe0KSzL85XYPqL1ZmzSjigvfJe/ej50so4Sd4RwAxntdbVjEX1/
	 h3edJ8Doi2xX1X0wWnUsOQrr70SVJqduegIQBWf4=
Date: Wed, 26 Jun 2019 16:28:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexander Potapenko <glider@google.com>
Cc: Christoph Lameter <cl@linux.com>, Kees Cook <keescook@chromium.org>,
 Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Hocko
 <mhocko@kernel.org>, James Morris <jmorris@namei.org>, "Serge E. Hallyn"
 <serge@hallyn.com>, Nick Desaulniers <ndesaulniers@google.com>, Kostya
 Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep
 Patil <sspatil@android.com>, Laura Abbott <labbott@redhat.com>, Randy
 Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>, Mark Rutland
 <mark.rutland@arm.com>, Marco Elver <elver@google.com>, Qian Cai
 <cai@lca.pw>, linux-mm@kvack.org, linux-security-module@vger.kernel.org,
 kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v8 1/2] mm: security: introduce init_on_alloc=1 and
 init_on_free=1 boot options
Message-Id: <20190626162835.0947684d36ef01639f969232@linux-foundation.org>
In-Reply-To: <20190626121943.131390-2-glider@google.com>
References: <20190626121943.131390-1-glider@google.com>
	<20190626121943.131390-2-glider@google.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 26 Jun 2019 14:19:42 +0200 Alexander Potapenko <glider@google.com> wrote:

>  v8:
>   - addressed comments by Michal Hocko: revert kernel/kexec_core.c and
>     apply initialization in dma_pool_free()
>   - disable init_on_alloc/init_on_free if slab poisoning or page
>     poisoning are enabled, as requested by Qian Cai
>   - skip the redzone when initializing a freed heap object, as requested
>     by Qian Cai and Kees Cook
>   - use s->offset to address the freeptr (suggested by Kees Cook)
>   - updated the patch description, added Signed-off-by: tag

v8 failed to incorporate 

https://ozlabs.org/~akpm/mmots/broken-out/mm-security-introduce-init_on_alloc=1-and-init_on_free=1-boot-options-fix.patch
and
https://ozlabs.org/~akpm/mmots/broken-out/mm-security-introduce-init_on_alloc=1-and-init_on_free=1-boot-options-fix-2.patch

it's conventional to incorporate such fixes when preparing a new
version of a patch.

