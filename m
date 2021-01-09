Return-Path: <kernel-hardening-return-20616-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 1238B2F00F3
	for <lists+kernel-hardening@lfdr.de>; Sat,  9 Jan 2021 16:46:50 +0100 (CET)
Received: (qmail 28576 invoked by uid 550); 9 Jan 2021 15:46:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 28556 invoked from network); 9 Jan 2021 15:46:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=p4G4kzlXe85FDh9nr6ety8HEaHTVitPIdX68eNq7YoM=;
        b=b8WREEKJPvYg3zx7oELzMncDnGWo0z/Hn2hvkbAZNWfbrA/5VRXu3tfrMGG3Z5XsiQ
         YYh0wj3MTKkhX3w273hWJu901loGFbN5ZQCL0tIAcRAU2tNE/jvmAOchI3D3cLwdtTqM
         7pqx1PrZ8DeFeEnztgbWjjj8QquQiI4UtPTUvDqBKrWVKCNy2BvtVyfHONUd5OihjUuu
         41duMXwhF3UMnxoKtBPD058ww/Gqw40GO7zD+p/BUHW7HrsGgpYwK/pLPVtpM77KfiDW
         78M6JW7t0vswJY4TuNKPKX5AAtEmkMGAqNwxsb3aOIKYdLdI8Isw2mA3IPNNxBy2cUJo
         139Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=p4G4kzlXe85FDh9nr6ety8HEaHTVitPIdX68eNq7YoM=;
        b=DI/5LiqoSnJ8L+V78vhlq7FOMkCMJuLAtNBlJf+A5ahjK8Iya/LPd5RWPG9vfTKWQa
         SzdYqC/Cn9yZV7iWK0nXdKbEs/v+wSLPCo9ZiBXQvUvOhO6nAqfWBaPQVCqpYNukrjT7
         uBiUQmuTHOz7BuaGAg37fhLtsgAFHPnoM8rcaQpQmL5mtSQQpoJT7yPTk6xxy6G8Us0l
         2ZME4hHZPTJxNr3TjpAHB8WatVI9O2cnTW3/2ak2jK7z/kwlmv+wShRZtoF9XndphjF6
         zAhNo90I0EZdMzROG8L0BIHofpeJph7MQ1A9Dj7VlNiB/Yf85D4LWnmtSsn04Pl7uPxV
         552w==
X-Gm-Message-State: AOAM531Cyf0ZFEVdGjd53NhyPgAEB4MxrDceqaRDUxtIiP+MttAXcT28
	GcEJpDKQgH2mZRD8Ls89X7pLgDO6mXmuDK9ZTjs=
X-Google-Smtp-Source: ABdhPJzfGJf6btSfZbEMaCeHEpE1yiatLPzmj4sNKHJDVqYiQdPCBe98JajmModQH00NOG/cIKfbOE+Ue3vZADnBYjM=
X-Received: by 2002:a6b:c9cb:: with SMTP id z194mr9324513iof.110.1610207192321;
 Sat, 09 Jan 2021 07:46:32 -0800 (PST)
MIME-Version: 1.0
References: <20201211184633.3213045-1-samitolvanen@google.com>
 <CA+icZUWYxO1hHW-_vrJid7EstqQRYQphjO3Xn6pj6qfEYEONbA@mail.gmail.com> <20210109153646.zrmglpvr27f5zd7m@treble>
In-Reply-To: <20210109153646.zrmglpvr27f5zd7m@treble>
From: Sedat Dilek <sedat.dilek@gmail.com>
Date: Sat, 9 Jan 2021 16:46:21 +0100
Message-ID: <CA+icZUUiucbsQZtJKYdD7Y7Cq8hJZdBwsF0U0BFbaBtnLY3Nsw@mail.gmail.com>
Subject: Re: [PATCH v9 00/16] Add support for Clang LTO
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Sami Tolvanen <samitolvanen@google.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Kees Cook <keescook@chromium.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, 
	Clang-Built-Linux ML <clang-built-linux@googlegroups.com>, kernel-hardening@lists.openwall.com, 
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-pci@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, Jan 9, 2021 at 4:36 PM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
>
> On Sat, Jan 09, 2021 at 03:54:20PM +0100, Sedat Dilek wrote:
> > I am interested in having Clang LTO (Clang-CFI) for x86-64 working and
> > help with testing.
> >
> > I tried the Git tree mentioned in [3] <jpoimboe.git#objtool-vmlinux>
> > (together with changes from <peterz.git#x86/urgent>).
> >
> > I only see in my build-log...
> >
> > drivers/gpu/drm/i915/gem/i915_gem_execbuffer.o: warning: objtool:
> > eb_relocate_parse_slow()+0x3d0: stack state mismatch: cfa1=7+120
> > cfa2=-1+0
> > drivers/gpu/drm/i915/gem/i915_gem_execbuffer.o: warning: objtool:
> > eb_copy_relocations()+0x229: stack state mismatch: cfa1=7+120
> > cfa2=-1+0
> >
> > ...which was reported and worked on in [1].
> >
> > This is with Clang-IAS version 11.0.1.
> >
> > Unfortunately, the recent changes in <samitolvanen.github#clang-cfi>
> > do not cleanly apply with Josh stuff.
> > My intention/wish was to report this combination of patchsets "heals"
> > a lot of objtool-warnings for vmlinux.o I observed with Clang-CFI.
> >
> > Is it possible to have a Git branch where Josh's objtool-vmlinux is
> > working together with Clang-LTO?
> > For testing purposes.
>
> I updated my branch with my most recent work from before the holidays,
> can you try it now?  It still doesn't fix any of the crypto warnings,
> but I'll do that in a separate set after posting these next week.
>

Thanks, Josh.

Did you push it (oh ah push it push it really really really good...)
to your remote Git please :-).

- Sedat -

[1] https://www.youtube.com/watch?v=vCadcBR95oU
