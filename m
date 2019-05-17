Return-Path: <kernel-hardening-return-15948-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 540B821AF6
	for <lists+kernel-hardening@lfdr.de>; Fri, 17 May 2019 17:51:48 +0200 (CEST)
Received: (qmail 31863 invoked by uid 550); 17 May 2019 15:51:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 31845 invoked from network); 17 May 2019 15:51:40 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=K3Vrlw7jjRTYTYz1AgzZI4h2eYnMN5BSgG9wzkqpLb0=;
        b=Q5IfUkcu0WjvcwlvR433YNjz64oeJCmRNDPkXbu+8hETl16gDKE6zTXpu6p7dkY4N6
         eVDjSXDI68k8ExtJHdN9UzmOP59bD8K8byBeWHXqf412MKC5e9prPRzi3StboEwqSfBQ
         8ZR2HIXUoQdqnMfp5QvDj8NFr5+DgQqGn8+ijVud/bPYdLOjbXeDS2j2K65qMHQbSC5v
         uZqu4G2sBJesTbY1c/9Aw5oiSoi6puEXKeTyG20jFKniAvjJRF/Pt1fqyb5+ev06/pNi
         1COM50IkfipdjLx3eakFwDTxCMtxfKpDbmZrjSvtJNABugPn0s2DEgjjb6XW07fkNBX/
         cpXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=K3Vrlw7jjRTYTYz1AgzZI4h2eYnMN5BSgG9wzkqpLb0=;
        b=EZtxHN4SOTGCWC05NhR8+IBlKIcfmku2mFUs1GqKNNxtDUXjAQdSjJnWB3HQV7PvRO
         lOcy9E++eROKSaLK0j5vcArJXxgKqLhsoHoBbH2O1Klx7KP8ShUxTN2Nd8RvK/ORfgXN
         QjDvvG4yVzlNuQ8GPelo1ojClyeCOiYFfylC5+X6bXTN8NbP2uEdtmQorp+sPFPCqZfD
         YCF7A6HQeNt7Mx5kIDMy2p54t1M2El7rtY1sVIFZr3p76uxBifmeL5NBgnYxzj3ozBJi
         BUUbtxkwhuIpJ1Xkt0Xze94y1o2V16X2wQpBghkdiWe5CMlKBLYwWf3eaVk4q6AK8RQx
         pg0Q==
X-Gm-Message-State: APjAAAVokCJslXYxLf8x0sOM8UaLTwN7lMNmY2WKCt1bksIugrIQA004
	KTcQPNCMBwbP0OYHzPnO5EGdUMtf8JfqM+Ua37xIWA==
X-Google-Smtp-Source: APXvYqyHBgjr6zQkV0VRITOnSTFo/Csy6VlzF4/NnOlUkrs7+IUo77Uxkz08YROnpav8K6N0iIzd8ewuExL2rchVXBY=
X-Received: by 2002:ab0:d95:: with SMTP id i21mr22915022uak.110.1558108288339;
 Fri, 17 May 2019 08:51:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190514143537.10435-1-glider@google.com> <20190514143537.10435-3-glider@google.com>
 <201905151752.2BD430A@keescook>
In-Reply-To: <201905151752.2BD430A@keescook>
From: Alexander Potapenko <glider@google.com>
Date: Fri, 17 May 2019 17:51:17 +0200
Message-ID: <CAG_fn=VVZ1FBygbAeTbdo2U2d2Zga6Z7wVitkqZB0YffCKYzag@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] lib: introduce test_meminit module
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, 
	Laura Abbott <labbott@redhat.com>, Jann Horn <jannh@google.com>, 
	Linux Memory Management List <linux-mm@kvack.org>, 
	linux-security-module <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 16, 2019 at 3:02 AM Kees Cook <keescook@chromium.org> wrote:
>
> On Tue, May 14, 2019 at 04:35:35PM +0200, Alexander Potapenko wrote:
> > Add tests for heap and pagealloc initialization.
> > These can be used to check init_on_alloc and init_on_free implementatio=
ns
> > as well as other approaches to initialization.
>
> This is nice! Easy way to test the results. It might be helpful to show
> here what to expect when loading this module:
Do you want me to add the expected output to the patch description?
> with either init_on_alloc=3D1 or init_on_free=3D1, I happily see:
>
>         test_meminit: all 10 tests in test_pages passed
>         test_meminit: all 40 tests in test_kvmalloc passed
>         test_meminit: all 20 tests in test_kmemcache passed
>         test_meminit: all 70 tests passed!
>
> and without:
>
>         test_meminit: test_pages failed 10 out of 10 times
>         test_meminit: test_kvmalloc failed 40 out of 40 times
>         test_meminit: test_kmemcache failed 10 out of 20 times
>         test_meminit: failures: 60 out of 70
>
>
> >
> > Signed-off-by: Alexander Potapenko <glider@google.com>
>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Tested-by: Kees Cook <keescook@chromium.org>
>
> note below...
>
> > [...]
> > diff --git a/lib/test_meminit.c b/lib/test_meminit.c
> > new file mode 100644
> > index 000000000000..67d759498030
> > --- /dev/null
> > +++ b/lib/test_meminit.c
> > @@ -0,0 +1,205 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > [...]
> > +module_init(test_meminit_init);
>
> I get a warning at build about missing the license:
>
> WARNING: modpost: missing MODULE_LICENSE() in lib/test_meminit.o
>
> So, following the SPDX line, just add:
>
> MODULE_LICENSE("GPL");
Will do, thanks!
> --
> Kees Cook



--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
