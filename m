Return-Path: <kernel-hardening-return-15978-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 005B12678C
	for <lists+kernel-hardening@lfdr.de>; Wed, 22 May 2019 17:58:06 +0200 (CEST)
Received: (qmail 29985 invoked by uid 550); 22 May 2019 15:57:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 29961 invoked from network); 22 May 2019 15:57:59 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=csIO6/r6boDgls5PxYVv4WnR4nG5C2hWLcsvu4wXyRE=;
        b=I5c1PJ8QlNgcKHXLHGh8brj9dKeIc23jMxGlGishmc7jg0dw/3WNuuAICPR4vHase6
         PXKRpc3p3PBlZCgxRTvLDlTyAmIMxmJ7uAylqP0Oum+ZxW7HPwc5ZhsSqR+PuIQLF2kn
         rmWAp7Sa8igzbVYZCptsBDsyBpbNGWwDEp1Gg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=csIO6/r6boDgls5PxYVv4WnR4nG5C2hWLcsvu4wXyRE=;
        b=cf5Otqqfdgtqc76U8gZ+bgnu3mpLSvFupgkOF7dMSmqR6pB0UH+5rRAHkRxHrROMgX
         6r/48RalrGJq1ncfLY6nAjYv1A/KuS4ndXzjLT7w001cVrBAqWYhfEGOoHEyB64Ipzuh
         PwvKdSS63EKJpbKtzoW3PV2c2mXIdW7C5VHWryP9GgsqbE+gm6U7ZnfwBfGPPHMmhf+9
         nR7ARDQFeb9pjIkjUxGaFEMc51CbJZZaXubddtdtXD3C/uIo+TrXvAEDODe0/OY8XhyC
         RQL7dnkGrl+fB97To2doUSxo+Jy1eJRawVDozxzsINkMZPq0s0nHaHJnIUmezdqu7gjH
         wITQ==
X-Gm-Message-State: APjAAAUZRIZvTAlfAMUbOgsdZL+pU0SDQRQ3HOBuoO7Nylwu6uwaWR7y
	roNn7upvtV3bZPLXBjtMG/ONF4jW3ZM=
X-Google-Smtp-Source: APXvYqz353D9QmKFCDvV7NmW82YP0mBKN087O69TfzyOtUGCNxN1srZfp/GOugZM4/t4papFjlsk9g==
X-Received: by 2002:a02:6209:: with SMTP id d9mr9347158jac.34.1558540666993;
        Wed, 22 May 2019 08:57:46 -0700 (PDT)
X-Received: by 2002:a02:5143:: with SMTP id s64mr8139039jaa.54.1558540664324;
 Wed, 22 May 2019 08:57:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190520231948.49693-1-thgarnie@chromium.org> <20190520231948.49693-4-thgarnie@chromium.org>
 <FF111368-9173-4AC2-9A79-E79A52B104DD@zytor.com>
In-Reply-To: <FF111368-9173-4AC2-9A79-E79A52B104DD@zytor.com>
From: Thomas Garnier <thgarnie@chromium.org>
Date: Wed, 22 May 2019 08:57:33 -0700
X-Gmail-Original-Message-ID: <CAJcbSZEYZLj_UQCQZzqxiOJEoWb2EzuUgaaFCkUBBFuKepHh8w@mail.gmail.com>
Message-ID: <CAJcbSZEYZLj_UQCQZzqxiOJEoWb2EzuUgaaFCkUBBFuKepHh8w@mail.gmail.com>
Subject: Re: [PATCH v7 03/12] x86: Add macro to get symbol address for PIE support
To: "H . Peter Anvin" <hpa@zytor.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Kristen Carlson Accardi <kristen@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	"the arch/x86 maintainers" <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Nadav Amit <namit@vmware.com>, 
	Jann Horn <jannh@google.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, May 20, 2019 at 8:13 PM <hpa@zytor.com> wrote:
>
> On May 20, 2019 4:19:28 PM PDT, Thomas Garnier <thgarnie@chromium.org> wrote:
> >From: Thomas Garnier <thgarnie@google.com>
> >
> >Add a new _ASM_MOVABS macro to fetch a symbol address. It will be used
> >to replace "_ASM_MOV $<symbol>, %dst" code construct that are not
> >compatible with PIE.
> >
> >Signed-off-by: Thomas Garnier <thgarnie@google.com>
> >---
> > arch/x86/include/asm/asm.h | 1 +
> > 1 file changed, 1 insertion(+)
> >
> >diff --git a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
> >index 3ff577c0b102..3a686057e882 100644
> >--- a/arch/x86/include/asm/asm.h
> >+++ b/arch/x86/include/asm/asm.h
> >@@ -30,6 +30,7 @@
> > #define _ASM_ALIGN    __ASM_SEL(.balign 4, .balign 8)
> >
> > #define _ASM_MOV      __ASM_SIZE(mov)
> >+#define _ASM_MOVABS   __ASM_SEL(movl, movabsq)
> > #define _ASM_INC      __ASM_SIZE(inc)
> > #define _ASM_DEC      __ASM_SIZE(dec)
> > #define _ASM_ADD      __ASM_SIZE(add)
>
> This is just about *always* wrong on x86-86. We should be using leaq sym(%rip),%reg. If it isn't reachable by leaq, then it is a non-PIE symbol like percpu. You do have to keep those distinct!

Yes, I agree. This patch is just having a shortcut when it is a
non-PIE symbol. The other patches try to separate the use cases where
a leaq sym(%rip) would work versus the need for a movabsq. There are
multiple cases where relative references are not possible because the
memory layout is different (hibernation, early boot or others).

> --
> Sent from my Android device with K-9 Mail. Please excuse my brevity.
