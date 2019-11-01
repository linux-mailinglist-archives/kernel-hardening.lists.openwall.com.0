Return-Path: <kernel-hardening-return-17226-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id B040CEC5CB
	for <lists+kernel-hardening@lfdr.de>; Fri,  1 Nov 2019 16:45:07 +0100 (CET)
Received: (qmail 29765 invoked by uid 550); 1 Nov 2019 15:45:01 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 29745 invoked from network); 1 Nov 2019 15:45:01 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EryZRTfyuksqxAOsiXgBnBsO6Q4g8OGONpcbT/2UUtU=;
        b=g4gJ23AXi6bRyNKKbF6kjh2Pk/SIgEmk0fMp7yU2OpLF1/ZSxEbdKQ2jcL1t/s7J/0
         r0bV9COqOeg4Cq5X18jTt+9/QOwnZtzmoXU43GWevEdIG1WGMtRc2pCbbksNon998ATC
         RYHfnk/oc6w0lpn4KlG1RD+XtSSxaBWmYd1V9RlWndHbQ5tvHLVM2OtZ6ek4cI2xWRNt
         R3iakDWD0UnL0SsREP4Ka3pRfim+0rka4bOI/E6Y1rBKqdoZulqYrnLmldF6BQw22qOB
         hqW6VUonfcohOf+Nawcc27KX/td24YYGGrBLxrNdceLzOMTOw2m0wiX1Fd48dG5wZunR
         2c0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EryZRTfyuksqxAOsiXgBnBsO6Q4g8OGONpcbT/2UUtU=;
        b=r8tXIRrhe6NL9XsyTrrfAFnBwuJh4gTRAkYerk8Za7viBb6sH5HpeAn8IY7JescOkw
         842qJRDE8zIbhb7DmuZZ1l8LOkaVoCNDcfV6MxKvgeVwTEEheNQhJUdad7YjL/fi8QW1
         teJDxoLHhuj5SizI/0Ne2iQlImNKMfAGhi9nyECgQsPbTPpk2zQVVCpxBeTbpSM0dpjA
         sdqVmyFSBfs95PuYeuxuZMuoZDindVVAwfrrno6IwLf0GZvvrzTjBzmwxr98rcmuVlTu
         XgQnhxCsSxUwUWEcGuhreWD6mLyYSlMw8nBQbntwkM1z9CLdkyk+61e6DzC2D9cu/bQz
         cRcA==
X-Gm-Message-State: APjAAAV+GH5S5qet8YnM3VeMjryUOABOfidC4uHYpEIU+bKTbT8JkLx2
	+VexJjzomaLyLTOerXT69/Tn6Q11s6njapG459vSwQ==
X-Google-Smtp-Source: APXvYqyH1Rx5ASstI+WbI3lXJTQCoOfcyvqAY38q2Tn/ntuwQF2PZaPqzpHPsoiSZYGDDuhXsCRPVJfLzeJkdoFRyBg=
X-Received: by 2002:a67:e951:: with SMTP id p17mr3253133vso.112.1572623088869;
 Fri, 01 Nov 2019 08:44:48 -0700 (PDT)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191031164637.48901-1-samitolvanen@google.com> <20191031164637.48901-18-samitolvanen@google.com>
 <201910312042.5AF689AAC@keescook>
In-Reply-To: <201910312042.5AF689AAC@keescook>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Fri, 1 Nov 2019 08:44:37 -0700
Message-ID: <CABCJKudW0tFrWryKj3-xW_eLWPSpCkaT9a14c9PH4a6-TT_=iw@mail.gmail.com>
Subject: Re: [PATCH v3 17/17] arm64: implement Shadow Call Stack
To: Kees Cook <keescook@chromium.org>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Dave Martin <Dave.Martin@arm.com>, 
	Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, 
	Nick Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, Oct 31, 2019 at 8:45 PM Kees Cook <keescook@chromium.org> wrote:
> The only suggestion would be calling attention the clearing step (both in
> comments below and in the commit log), just to record the earlier
> discussion about it.

Sure, makes sense. I'll add comments about this in v4.

Sami
