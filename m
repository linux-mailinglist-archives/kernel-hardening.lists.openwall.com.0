Return-Path: <kernel-hardening-return-15945-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id F3E9B219A2
	for <lists+kernel-hardening@lfdr.de>; Fri, 17 May 2019 16:12:02 +0200 (CEST)
Received: (qmail 9245 invoked by uid 550); 17 May 2019 14:11:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 9224 invoked from network); 17 May 2019 14:11:56 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yPJC3km5fQmSqwkKg0IjAisXnGkZMwPlofzvwmFfzTw=;
        b=EhjgdN7emCfeHXsoZMJ6Wj40u+K0XLKFFOKVL9cg3V+WH/c2YCU/n4ecYmVtHgKjHJ
         dtcKp1uarWS6UvEpwooJa4R7FNsW2kXMw4xOacmOPwlyZidzuxlrR+0uvSHkNLn5yUII
         +XP3M436OKMrLZSqSNxWKTmBL+mve4IC0pu2mPDyLlKaIRWUa/MqVE/uQn0Eu9tNH0Ab
         H1TItWp/mTaqBicBRuNPZ/zsD8Yl8IgYY4D/Eg47qVFNmJqUR9MFTMapElXkIPIIVeNF
         RfmK79DUWvsHRfjG9l+OaVKWPE9M65hLfms3E9J6bR595KANlWKWG/AscHpg+TRC5Ga6
         EJRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yPJC3km5fQmSqwkKg0IjAisXnGkZMwPlofzvwmFfzTw=;
        b=E7dfogMkcAwjja6EOKp2zMp9gC/sTfWZf1J1DMfXWkNObc8jI4HkBiQjXE1gfKGDZ3
         MHVWhZX/ae9BZYXFmEJwLzVRaG4PFx/7bjzmvE1ecClHKmNSykLKFaI4d/NaluRhjWSd
         MulpZUGbGCtSUvwTxal6N8nGE3BGzRW9ucJcjEl9/dXpe/E4MduPpSEzvrrNqu265frT
         9C2+ltzozHARg7W7s+VBNxRCG00MhE2nv8yNeEBkIneyoK28ozDjFl25WNnFoD6Se0dF
         MfsKb3UzTk4WddyEKPybbEY7y+XvsKHQ7+D5kvKtz89uegTfMuoI5ww56cKvAriHrOWa
         pf5A==
X-Gm-Message-State: APjAAAW9rucpb+q1S4sKySM8EfF4k9xHj3aHV/sxPrt49oN6g+Of9d2b
	sEf2meoIOo2RDrTx+G8VSPKueOw/1CruNb1VrDtEkQ==
X-Google-Smtp-Source: APXvYqzNwEP3/rmvtRb4XJJMVsKuA4IxchtkUNa8GybLvlIZbRD9HfA6ovC4X627LbY06pBrs3DVvrUPTJ2RagiavLQ=
X-Received: by 2002:ab0:1d8e:: with SMTP id l14mr6084453uak.72.1558102303960;
 Fri, 17 May 2019 07:11:43 -0700 (PDT)
MIME-Version: 1.0
References: <20190514143537.10435-1-glider@google.com> <20190514143537.10435-2-glider@google.com>
 <20190517140446.GA8846@dhcp22.suse.cz>
In-Reply-To: <20190517140446.GA8846@dhcp22.suse.cz>
From: Alexander Potapenko <glider@google.com>
Date: Fri, 17 May 2019 16:11:32 +0200
Message-ID: <CAG_fn=W4k=mijnUpF98Hu6P8bFMHU81FHs4Swm+xv1k0wOGFFQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] mm: security: introduce init_on_alloc=1 and
 init_on_free=1 boot options
To: Michal Hocko <mhocko@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, 
	Kees Cook <keescook@chromium.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Nick Desaulniers <ndesaulniers@google.com>, 
	Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, 
	Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>, 
	Mark Rutland <mark.rutland@arm.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	linux-security-module <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 17, 2019 at 4:04 PM Michal Hocko <mhocko@kernel.org> wrote:
>
> On Tue 14-05-19 16:35:34, Alexander Potapenko wrote:
> > The new options are needed to prevent possible information leaks and
> > make control-flow bugs that depend on uninitialized values more
> > deterministic.
> >
> > init_on_alloc=3D1 makes the kernel initialize newly allocated pages and=
 heap
> > objects with zeroes. Initialization is done at allocation time at the
> > places where checks for __GFP_ZERO are performed.
> >
> > init_on_free=3D1 makes the kernel initialize freed pages and heap objec=
ts
> > with zeroes upon their deletion. This helps to ensure sensitive data
> > doesn't leak via use-after-free accesses.
>
> Why do we need both? The later is more robust because even free memory
> cannot be sniffed and the overhead might be shifted from the allocation
> context (e.g. to RCU) but why cannot we stick to a single model?
init_on_free appears to be slower because of cache effects. It's
several % in the best case vs. <1% for init_on_alloc.

> --
> Michal Hocko
> SUSE Labs



--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
