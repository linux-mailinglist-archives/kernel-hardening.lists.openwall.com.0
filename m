Return-Path: <kernel-hardening-return-20455-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 66DD82C133D
	for <lists+kernel-hardening@lfdr.de>; Mon, 23 Nov 2020 19:34:47 +0100 (CET)
Received: (qmail 23889 invoked by uid 550); 23 Nov 2020 18:34:39 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 23863 invoked from network); 23 Nov 2020 18:34:39 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ducm/uE+sMkPK2UOgkqYMUQ4ilvqi+LJ419ruam/qFs=;
        b=a28npanXu2b+2Zm6spF8Xxq67i0FF1mofgAXLZrp9sWLlq5VqELCHg7nNtL/fggxfy
         4CvQOkS95wisZC5OOhHXgHc7fhFAJxswBiURdiMJ9pvomlaHamPT+ykt9lAJiikZ+dLt
         osQObvLhHeCEfH726pPrnktuPN+mM05X3eQTo9OM7P951PbVbYXAJtMdKWsW3ZpOJycz
         Fo60Q7UeI0dsFGaQdho0oc4TBDEtFVDe4gG5sgoLUuJHQYabpl1Mv31/0zpxLkiYJIlP
         yNiDIkVOpAML5h30am2pinK5OAxNIvR/ui0KubaSslDdw6PBBAOOjQrByts6Koo1ViWx
         IqJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ducm/uE+sMkPK2UOgkqYMUQ4ilvqi+LJ419ruam/qFs=;
        b=WYCOql6uQFn3LayfwA8JVSgwOsu/KRUz1Fq69lY2cdVDquCstKyX9EPORYv5pMiUs4
         LHNiTv4+i62BxgD1RXL/fdpp3RxL5gqnmHsUmBQ3eSBjx8xJLDp3DCe22Hk6GPWYtMYM
         8e7Hgso5D+RRtoSWDasVS+A5HT171iW6vckdAPo6F6ILcBhUminMxOdWQtSXncuSQI/q
         Vwm6EkOllmGDkyQkamwvmvMLDs7Kn7iQbRccZRl5QM3P+wXk5ILh+afuq4PIQ7KzixGY
         jC6oRHOd7k9Q/qwwW5FpIsxDsvBGW7gYgg/UtaWl/Edu/MJn7jCzCymnnACdbUmOGh2c
         HHYA==
X-Gm-Message-State: AOAM533vRLWkImw9TRCp0dJzn7jXjwbq1HgmaCpw8ixcfQGF7eKT68Y0
	4N6OXnz0kX9P7iIje8tgZJjhnJOP5mCLXGm+lDv4Vg==
X-Google-Smtp-Source: ABdhPJzC0vN0JaDRTG9c5TGsH9fkbupHyjbfe084sm69JglMhlEIa99nGJXCtSMl92Ch4dEphBLEyKdnjfaSUw9p8Ug=
X-Received: by 2002:a1f:b245:: with SMTP id b66mr1161485vkf.3.1606156467081;
 Mon, 23 Nov 2020 10:34:27 -0800 (PST)
MIME-Version: 1.0
References: <20201118220731.925424-1-samitolvanen@google.com>
 <20201118220731.925424-16-samitolvanen@google.com> <20201123102149.ogl642tw234qod62@google.com>
In-Reply-To: <20201123102149.ogl642tw234qod62@google.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Mon, 23 Nov 2020 10:34:16 -0800
Message-ID: <CABCJKudwt6xDUMADRjXU04bxZFFWOFOs_26TJGHV_vnP8Qs5Jw@mail.gmail.com>
Subject: Re: [PATCH v7 15/17] KVM: arm64: disable LTO for the nVHE directory
To: David Brazdil <dbrazdil@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Will Deacon <will@kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Kees Cook <keescook@chromium.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, 
	linux-kbuild <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	linux-pci@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, Nov 23, 2020 at 2:21 AM David Brazdil <dbrazdil@google.com> wrote:
>
> Hey Sami,
>
> On Wed, Nov 18, 2020 at 02:07:29PM -0800, Sami Tolvanen wrote:
> > We use objcopy to manipulate ELF binaries for the nVHE code,
> > which fails with LTO as the compiler produces LLVM bitcode
> > instead. Disable LTO for this code to allow objcopy to be used.
>
> We now partially link the nVHE code (generating machine code) before objcopy,
> so I think you should be able to drop this patch now. Tried building your
> branch without it, ran a couple of unit tests and all seems fine.

Great, thanks for testing this, David! I'll drop this patch from v8.

Sami
