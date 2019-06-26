Return-Path: <kernel-hardening-return-16252-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 8D593568C5
	for <lists+kernel-hardening@lfdr.de>; Wed, 26 Jun 2019 14:27:28 +0200 (CEST)
Received: (qmail 5216 invoked by uid 550); 26 Jun 2019 12:27:21 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 5171 invoked from network); 26 Jun 2019 12:27:21 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6kfkIhuHoPIjfMfVB0Ztiwt1Me6klHBycZVbDOiK0gk=;
        b=LA9vnejysG80LoRMNK06zRKNClzSYlPIdhO2BG8R5WimhgksbZNGFBE1+GUiQLEifw
         eagA1Ss7o118bXvq49QRHs+qJqELP+XQixvQAYDIsNY3C8BcfX7mpLNtT8ORoVLO0I87
         c0MDtIeXo60EqlRh1gnyMvvuq9qf0CzKX64dtRn0ifZI4hXXE0kqy16Q5v4HugyKWeK2
         UuwCITTAl5UFtiD9Rs4b/geol+F+Nyj5TAz6c5zFvVJKZYPyKWMPY2Z6T+8dQC+CzHVK
         xBAsf8dcoFTgafsDg4Thp/2Chqjg9t5WhkYXBT/PqOpgZF0AEy8MdUMfUE56k+QPMpzj
         VlTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6kfkIhuHoPIjfMfVB0Ztiwt1Me6klHBycZVbDOiK0gk=;
        b=tqkiKfP4Xvdo76xQLzdY68DLxC6BcwCNCZtVeQwElDIc0oJ7jsjz+gmP41ZBTLfonU
         qAoX2WlBb/WU9YGQSSOUxC5sTeF61Uko+Yvsw3IgDL5Siu+9HIsvK/pv1wN9wH6GiuSi
         FxjnHZrCgrt56+0msh0T9Oo2DCxsnsSwv/+B40UsO74R6fmiiNe9E67ULHfmIvljL1iE
         9uQPIhOgr57DkKYTOVOi1TC/WnaBo7YgNszmTOWLySRy9kHdoVRigZnsTybiRmSYvCsI
         4QKaT60ReXWDghdn9I2oAfuhC+G8sVzj20a0OMNKaOAMqm631i4fgPrXT8nmS71ZkT4l
         tpFw==
X-Gm-Message-State: APjAAAVMrmwmemRfc08RDOByfr3QwGr/UwhtoEGnciuUTgo9c0i0Ra1l
	kNsgjBdTLz0q0X/IwS8UtrYcLuSSW1OYGzYQKsAx/A==
X-Google-Smtp-Source: APXvYqzFVn7+Sobi3957YqMqzgXYiYzf1aj+EhLLCRNEuqntRTM8bUrv2ro9eKC8ad0q35LYmIjx6cO3FPMvsDikbes=
X-Received: by 2002:a67:11c1:: with SMTP id 184mr2733987vsr.217.1561552028933;
 Wed, 26 Jun 2019 05:27:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190626121943.131390-1-glider@google.com>
In-Reply-To: <20190626121943.131390-1-glider@google.com>
From: Alexander Potapenko <glider@google.com>
Date: Wed, 26 Jun 2019 14:26:57 +0200
Message-ID: <CAG_fn=V5o-wt5PQ4LSarpXrEGfbrdbtSFqOOag=nmMrxf4gfnA@mail.gmail.com>
Subject: Re: [PATCH v8 0/3] add init_on_alloc/init_on_free boot options
To: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, 
	Kees Cook <keescook@chromium.org>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Hocko <mhocko@kernel.org>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, 
	Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>, 
	Mark Rutland <mark.rutland@arm.com>, Marco Elver <elver@google.com>, Qian Cai <cai@lca.pw>, 
	Linux Memory Management List <linux-mm@kvack.org>, 
	linux-security-module <linux-security-module@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 26, 2019 at 2:19 PM Alexander Potapenko <glider@google.com> wro=
te:
>
> Provide init_on_alloc and init_on_free boot options.
akpm: May I kindly ask you to replace the two patches from this series
in the -mm tree with their newer versions?

> These are aimed at preventing possible information leaks and making the
> control-flow bugs that depend on uninitialized values more deterministic.
>
> Enabling either of the options guarantees that the memory returned by the
> page allocator and SL[AU]B is initialized with zeroes.
> SLOB allocator isn't supported at the moment, as its emulation of kmem
> caches complicates handling of SLAB_TYPESAFE_BY_RCU caches correctly.
>
> Enabling init_on_free also guarantees that pages and heap objects are
> initialized right after they're freed, so it won't be possible to access
> stale data by using a dangling pointer.
>
> As suggested by Michal Hocko, right now we don't let the heap users to
> disable initialization for certain allocations. There's not enough
> evidence that doing so can speed up real-life cases, and introducing
> ways to opt-out may result in things going out of control.
>
> To: Andrew Morton <akpm@linux-foundation.org>
> To: Christoph Lameter <cl@linux.com>
> To: Kees Cook <keescook@chromium.org>
> Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: James Morris <jmorris@namei.org>
> Cc: "Serge E. Hallyn" <serge@hallyn.com>
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Cc: Kostya Serebryany <kcc@google.com>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Cc: Sandeep Patil <sspatil@android.com>
> Cc: Laura Abbott <labbott@redhat.com>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: Jann Horn <jannh@google.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Marco Elver <elver@google.com>
> Cc: Qian Cai <cai@lca.pw>
> Cc: linux-mm@kvack.org
> Cc: linux-security-module@vger.kernel.org
> Cc: kernel-hardening@lists.openwall.com
>
> Alexander Potapenko (2):
>   mm: security: introduce init_on_alloc=3D1 and init_on_free=3D1 boot
>     options
>   mm: init: report memory auto-initialization features at boot time
>
>  .../admin-guide/kernel-parameters.txt         |  9 +++
>  drivers/infiniband/core/uverbs_ioctl.c        |  2 +-
>  include/linux/mm.h                            | 22 ++++++
>  init/main.c                                   | 24 +++++++
>  mm/dmapool.c                                  |  4 +-
>  mm/page_alloc.c                               | 71 +++++++++++++++++--
>  mm/slab.c                                     | 16 ++++-
>  mm/slab.h                                     | 19 +++++
>  mm/slub.c                                     | 43 +++++++++--
>  net/core/sock.c                               |  2 +-
>  security/Kconfig.hardening                    | 29 +++++++++
>  12 files changed, 204 insertions(+), 19 deletions(-)
> ---
>  v3: dropped __GFP_NO_AUTOINIT patches
>  v5: dropped support for SLOB allocator, handle SLAB_TYPESAFE_BY_RCU
>  v6: changed wording in boot-time message
>  v7: dropped the test_meminit.c patch (picked by Andrew Morton already),
>      minor wording changes
>  v8: fixes for interoperability with other heap debugging features
> --
> 2.22.0.410.gd8fdbe21b5-goog
>


--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
