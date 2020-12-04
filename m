Return-Path: <kernel-hardening-return-20535-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id B39B32CF71A
	for <lists+kernel-hardening@lfdr.de>; Fri,  4 Dec 2020 23:53:13 +0100 (CET)
Received: (qmail 3866 invoked by uid 550); 4 Dec 2020 22:53:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3846 invoked from network); 4 Dec 2020 22:53:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=APDwfrMJO9jpMmlvJs1QQfYlFxkBjLtMOQGI8Flupio=;
        b=vlYT2PP85xGxgcq4Dr0LjAqfSnHTJbDN9Qw9s716INhVlK2qIKh97cH0so65YWekJV
         ZkCddAaWBBeVyc79V1Qsk0bwBXFOYV/fbRRVmb3hqZ90wFkxjB6PyGd9Fl/4pFQAhhjZ
         AM6IB7GFEBqHL1Jg9yyWo4W0Nb7mb6UJHeOQir6VApItA3LGKTPi0G3m3U6izolVWg8S
         lneowIrUY4bLqR7zyKu8N2F2ZMtJSwvpwOZjKssZqamx23Iv78VtDQw/lQdiC6Po0aWG
         caBNxURcOkyiTRCfZKEEQPiFtZ4Uo4eYHfBI8tK9v8an2dHQPAwNADLFINV3H5bQRJ9b
         cZUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=APDwfrMJO9jpMmlvJs1QQfYlFxkBjLtMOQGI8Flupio=;
        b=AAxSWhXs5VqqgjNEs3YJANHfrsQLqiWIXRQCZdckTNYSUoL+OLLeTr4Cv6nUjXjVN7
         EF987IPkJpKzzywjRvF5j/MDtS3gvGix3TWiG20jp4+YC8Rc8Gg4LZWGHoULEtCpbToc
         qJUd2Fb2IQvGEw7gF7Jm7tuG6AG9mJZSL0f2NFIydvaPaW2RvmQ4e8Qmcj2E2gJ/qK1D
         HTO2ElSp/1iwsUQzo3Z+8IDgIDDBKHDa/XBjnNFLU0dCwWn7+uhDwLVFz+mCXOxCeqj0
         Emzx5LB7q75hrkfIR6L22tL+X6q114xSzWzbEGalfQ9IVu3/yKy4ZcZzk2UG4k1Tiqba
         gECw==
X-Gm-Message-State: AOAM5303HujjIOEJi27W3tS8PECztDIq3zyigXogwpMFS2erNhY5OUC/
	l88D2Zhfbbbz45A5a9NOH4el7y6KaqihSx9JekOraA==
X-Google-Smtp-Source: ABdhPJyEOufu1IYsUQg6fXqokcGK+WOlACM5vK4uRoSLdaEQytBNywFXfXG2M7YwyvYjCJIK/G4zrq6Skn/z29jgixU=
X-Received: by 2002:a67:ec3:: with SMTP id 186mr6679107vso.14.1607122373106;
 Fri, 04 Dec 2020 14:52:53 -0800 (PST)
MIME-Version: 1.0
References: <20201201213707.541432-1-samitolvanen@google.com>
 <20201203112622.GA31188@willie-the-truck> <CABCJKueby8pUoN7f5=6RoyLSt4PgWNx8idUej0sNwAi0F3Xqzw@mail.gmail.com>
 <20201203182252.GA32011@willie-the-truck> <CAKwvOdnvq=L=gQMv9MHaStmKMOuD5jvffzMedhp3gytYB6R7TQ@mail.gmail.com>
In-Reply-To: <CAKwvOdnvq=L=gQMv9MHaStmKMOuD5jvffzMedhp3gytYB6R7TQ@mail.gmail.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Fri, 4 Dec 2020 14:52:41 -0800
Message-ID: <CABCJKufgkq+k0DeYaXrzjXniy=T_N4sN1bxoK9=cUxTZN5xSVQ@mail.gmail.com>
Subject: Re: [PATCH v8 00/16] Add support for Clang LTO
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: Will Deacon <will@kernel.org>, Masahiro Yamada <masahiroy@kernel.org>, 
	Nathan Chancellor <natechancellor@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Josh Poimboeuf <jpoimboe@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, 
	linux-kbuild <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	PCI <linux-pci@vger.kernel.org>, Jian Cai <jiancai@google.com>, 
	Kristof Beyls <Kristof.Beyls@arm.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Dec 3, 2020 at 2:32 PM Nick Desaulniers <ndesaulniers@google.com> wrote:
>
> So I'd recommend to Sami to simply make the Kconfig also depend on
> clang's integrated assembler (not just llvm-nm and llvm-ar).

Sure, sounds good to me. What's the preferred way to test for this in Kconfig?

It looks like actually trying to test if we have an LLVM assembler
(e.g. using $(as-instr,.section
".linker-options","e",@llvm_linker_options)) doesn't work as Kconfig
doesn't pass -no-integrated-as to clang here. I could do something
simple like $(success,echo $(LLVM) $(LLVM_IAS) | grep -q "1 1").

Thoughts?

Sami
