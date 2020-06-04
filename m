Return-Path: <kernel-hardening-return-18929-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 249D71EE697
	for <lists+kernel-hardening@lfdr.de>; Thu,  4 Jun 2020 16:26:16 +0200 (CEST)
Received: (qmail 17733 invoked by uid 550); 4 Jun 2020 14:26:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 17713 invoked from network); 4 Jun 2020 14:26:09 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QBoURK9IvkbwBs1kPGIuS8onwD7joVufvI7DnXYuvi0=;
        b=eCFjxOTAU45BkEXkm9dz6n9yVUTYKjF0lfqsZeaFC/6ify5YGNdJzi4s/42EJQZhBX
         1nyzwSJOUmHwTC4erzNqLYt8oP3Z9mcusdfhj7KwKo7ODOGeIntpb/jlb6NeGSOKC7zs
         2vxUEqxohHamBIFMr3SHgxK2PndlbotB5rKYm+Nr69EgxtRXHQOW/J5C2HYX4E7orDmD
         CLpVwcKlAHqOChEXa+jjLzSQApNsSM0P2DZgA16woVD/aZcsvKBrVEkn2y6s2mids0Y8
         bvhEzQ6JPoIN2jCASEnd2HlER4AKNlCgfiSozQwnM4G8f8hoZpJVCgO+rFQneglybL6p
         l2lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QBoURK9IvkbwBs1kPGIuS8onwD7joVufvI7DnXYuvi0=;
        b=NAc+tGsI/zHhVXJFshom0ESGSMkAAKyxx51I+HkHkj2ajwSx3d7ajFU+igbrkIQj62
         zRfCQOqNBqjR7iokbBsprZIIE4FHSq4ZAcKFPoWP6j21cMYIKSyPO7DFhaDyd8l5Ym6M
         uF8GMCtISyUQi7At6Zk1Kf3xyUwhQ0n0Edj9mUGuMg1/I2wMLexEvVPdV3lC3psDNkfJ
         g3b8hcYj+KKkJRCIP7N4lyuhBDipzlVc3f2VKKdAkuSLF5znJQD4mDNYPtoyffz46jsz
         VAraqYUMMC+RMEnW+SASVnaj8WLmmUm3fNPemZqF2LgYlpqajW91jA/bOFeXu2Ga5AGS
         lYNQ==
X-Gm-Message-State: AOAM533PsI3Sir7aGrNJAWFlMN49xpvYPGAHskq8znFHA+uUPdFWrtbN
	71wLkQBWr/p/fafCB0Z5Dz/7tSGtmAmVDe+oXf/JkA==
X-Google-Smtp-Source: ABdhPJwh/YOClis/hIwcKj8vHzbw8wx9bOB6tTVkvL98ptRj6m7SsH1K4mSctfjnB9d0qvovuLDzYkm1/ruBzlolZfc=
X-Received: by 2002:a2e:9455:: with SMTP id o21mr2270197ljh.415.1591280758179;
 Thu, 04 Jun 2020 07:25:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200604134957.505389-1-alex.popov@linux.com> <20200604134957.505389-6-alex.popov@linux.com>
 <20200604135806.GA3170@willie-the-truck> <CAG48ez0H_+EBd1wekk2oddSzLsgzincyZb_dB+s5atudB23YyA@mail.gmail.com>
 <ab7b6e17-69c5-dce9-a0ae-d12964319433@linux.com>
In-Reply-To: <ab7b6e17-69c5-dce9-a0ae-d12964319433@linux.com>
From: Jann Horn <jannh@google.com>
Date: Thu, 4 Jun 2020 16:25:31 +0200
Message-ID: <CAG48ez3LZ1xzAYHm23JOXTFBZqaHkVVZXwSe+VmmCBTwxKOdUQ@mail.gmail.com>
Subject: Re: [PATCH 5/5] gcc-plugins/stackleak: Don't instrument
 vgettimeofday.c in arm64 VDSO
To: Alexander Popov <alex.popov@linux.com>
Cc: Will Deacon <will@kernel.org>, Kees Cook <keescook@chromium.org>, 
	Emese Revfy <re.emese@gmail.com>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, Michal Marek <michal.lkml@markovi.net>, 
	Andrew Morton <akpm@linux-foundation.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, 
	Thiago Jung Bauermann <bauerman@linux.ibm.com>, Luis Chamberlain <mcgrof@kernel.org>, Jessica Yu <jeyu@kernel.org>, 
	Sven Schnelle <svens@stackframe.org>, Iurii Zaikin <yzaikin@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Peter Collingbourne <pcc@google.com>, Naohiro Aota <naohiro.aota@wdc.com>, 
	Alexander Monakov <amonakov@ispras.ru>, Mathias Krause <minipli@googlemail.com>, 
	PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, 
	Laura Abbott <labbott@redhat.com>, Florian Weimer <fweimer@redhat.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-kbuild@vger.kernel.org, 
	"the arch/x86 maintainers" <x86@kernel.org>, Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	kernel list <linux-kernel@vger.kernel.org>, gcc@gcc.gnu.org, notify@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, Jun 4, 2020 at 4:21 PM Alexander Popov <alex.popov@linux.com> wrote:
> On 04.06.2020 17:14, Jann Horn wrote:
> > Maybe at some point we should replace exclusions based on
> > GCC_PLUGINS_CFLAGS and KASAN_SANITIZE and UBSAN_SANITIZE and
> > OBJECT_FILES_NON_STANDARD and so on with something more generic...
> > something that says "this file will not be built into the normal
> > kernel, it contains code that runs in realmode / userspace / some
> > similarly weird context, and none of our instrumentation
> > infrastructure is available there"...
>
> Good idea. I would also add 'notrace' to that list.

Hm? notrace code should definitely still be subject to sanitizer
instrumentation.
