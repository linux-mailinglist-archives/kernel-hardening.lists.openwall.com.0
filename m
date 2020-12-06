Return-Path: <kernel-hardening-return-20536-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 673942D0141
	for <lists+kernel-hardening@lfdr.de>; Sun,  6 Dec 2020 07:50:52 +0100 (CET)
Received: (qmail 21540 invoked by uid 550); 6 Dec 2020 06:50:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 21520 invoked from network); 6 Dec 2020 06:50:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xEFX9m1tSvdSJQ3/EiaRpiuUqPA/jqJsIXCgLkJIHTI=;
        b=DzK6LtMphXGVMKUPACceGTUsVVmN1cNs/QClR/+YjCKMnWe4BnLQBIJsKr7tKxkNyY
         w8fYOkrp4AJry9LpefYGu1ZK0PRDfStCJRHpd340BZOhkyFknzV9Qv1a8xkVOdyY9zFf
         gj6zMq1tQBs9MJGB2si/iNyk8qcAPb1OkxqdQ0kknvb2P9OxzdM9jt0tLWQNa3/KRgUW
         26EXDEONiip05JtUgT3RheVciiRVzO2cil6qzk6OBDikvUihqXg+enkPIQLrcSwu//N1
         F9oG7BK1bIa+jJndHBOVysL6/gUrP1m+nsgJWeLkzCRdImG92pho9jGdEKn0kHXouQT4
         KWgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xEFX9m1tSvdSJQ3/EiaRpiuUqPA/jqJsIXCgLkJIHTI=;
        b=kyYVT72HqNbEwsmp0x+nocDM5cY9Mn6RIUiaHh2mTn8Z+awO7mQ4CtpGhEPeiP99Tw
         GLXo2QtQn897MRriFoREBygQKn+8JTPzvjIZZ6bUc12aOCBzdrTjB/mMDG3kGvc+f+HO
         1oO88ANSN82dm4oITrTmN1rylj89AwG+dv4a1J1i6Utyd6ZQGu9vhbyhXHRT/bYi7iY1
         x05sxgd4CMBk819vul9KH6x6idMJ7NroQzOxC3toTC6GDmQysUPgwvuafV6zFQ0+YYiD
         G2KJDbHYLyyFvDCHCzY/YllnggFYH38X/CvOGwHJ26+xeXdsH5AChXhiU85t+PhRhRp2
         bflw==
X-Gm-Message-State: AOAM533060o3dSPpjptQ7CPdH1X+QMvCeqaJ/TQWHcwksgZRIuHV0oMC
	xWhsu0FCjlPR9awyE4XLxGo=
X-Google-Smtp-Source: ABdhPJwZVi5tRrvxZ13o7P0VRkdeEgYwBAdwWzBfj6NClRTOtnOrrhmD5vISX/qn43sceqJ+Sz+PdQ==
X-Received: by 2002:a5d:958b:: with SMTP id a11mr13034197ioo.160.1607237432100;
        Sat, 05 Dec 2020 22:50:32 -0800 (PST)
Date: Sat, 5 Dec 2020 23:50:28 -0700
From: Nathan Chancellor <natechancellor@gmail.com>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>,
	Will Deacon <will@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	clang-built-linux <clang-built-linux@googlegroups.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-arch <linux-arch@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	linux-kbuild <linux-kbuild@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	PCI <linux-pci@vger.kernel.org>, Jian Cai <jiancai@google.com>,
	Kristof Beyls <Kristof.Beyls@arm.com>
Subject: Re: [PATCH v8 00/16] Add support for Clang LTO
Message-ID: <20201206065028.GA2819096@ubuntu-m3-large-x86>
References: <20201201213707.541432-1-samitolvanen@google.com>
 <20201203112622.GA31188@willie-the-truck>
 <CABCJKueby8pUoN7f5=6RoyLSt4PgWNx8idUej0sNwAi0F3Xqzw@mail.gmail.com>
 <20201203182252.GA32011@willie-the-truck>
 <CAKwvOdnvq=L=gQMv9MHaStmKMOuD5jvffzMedhp3gytYB6R7TQ@mail.gmail.com>
 <CABCJKufgkq+k0DeYaXrzjXniy=T_N4sN1bxoK9=cUxTZN5xSVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABCJKufgkq+k0DeYaXrzjXniy=T_N4sN1bxoK9=cUxTZN5xSVQ@mail.gmail.com>

On Fri, Dec 04, 2020 at 02:52:41PM -0800, Sami Tolvanen wrote:
> On Thu, Dec 3, 2020 at 2:32 PM Nick Desaulniers <ndesaulniers@google.com> wrote:
> >
> > So I'd recommend to Sami to simply make the Kconfig also depend on
> > clang's integrated assembler (not just llvm-nm and llvm-ar).
> 
> Sure, sounds good to me. What's the preferred way to test for this in Kconfig?
> 
> It looks like actually trying to test if we have an LLVM assembler
> (e.g. using $(as-instr,.section
> ".linker-options","e",@llvm_linker_options)) doesn't work as Kconfig
> doesn't pass -no-integrated-as to clang here. I could do something
> simple like $(success,echo $(LLVM) $(LLVM_IAS) | grep -q "1 1").
> 
> Thoughts?
> 
> Sami

I think

    depends on $(success,test $(LLVM_IAS) -eq 1)

should work, at least according to my brief test.

Cheers,
Nathan
