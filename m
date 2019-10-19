Return-Path: <kernel-hardening-return-17060-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 5819BDD5C0
	for <lists+kernel-hardening@lfdr.de>; Sat, 19 Oct 2019 02:22:13 +0200 (CEST)
Received: (qmail 9268 invoked by uid 550); 19 Oct 2019 00:22:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 9250 invoked from network); 19 Oct 2019 00:22:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZqICylESWKf0IpOr+KHkluRNlL0wf5TguV6mXdP4QGA=;
        b=SJhBGhz9kYlPN0TADnvJp8G2Y17kwQLx8bFgEQxXC4oPBXVPQajIkOkF46KrnCk3Y+
         SIhUxsEMZpo0mO71reWB5iYnGBSvSPpnlhJ7SOGmsAzO1r/eCW2htdVksbO0SI9DIYUV
         omVMOJI5aJQYPBTuWOcF+vN49kJ/Z38IZ5w69/IWpI0dZkus3V70HRJmjzixpNFSsrH7
         zFdeP18no8PweXdELrMKy1nvLYeUemGKl7HG8j1bU8GRNXdqGvneSPtLFgWbG2ZCxBd6
         JFKB+kpkVv5yQiadF2KjhDCmed79/Dn/ssCkl2cq1nYz+heSuFAzelrZNVV5W1OmMhq6
         qcQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZqICylESWKf0IpOr+KHkluRNlL0wf5TguV6mXdP4QGA=;
        b=PsZxRNCdrNFL3oP5cq5texO90rTzFgvkiQ/qhzuOBRGwI93WZDfKlQxsvL5e8n4xph
         r0wInzEMDIcelMw0kn8L68qjsu13l8Fdm8HQzQQMQOjFQSsMEsR3MKZs7cxVdvj2KONl
         4ciiB6tC03Vhy29HpNwUb6zINqKRxg/xZrA0DviQGd55ITXFMRv9nefynyrcX15LbgdP
         ptKaHMZ93k2PPNOp5zjpuRtm7InbsJv7urC+MonE7Kso+Sk4JYcD7I0ANzvfy3k+3ts5
         i/ZslF3LcD7Enm56V2Ow568cZf7xksDIdVrRx7ljpj2IbUr8n4r0VQ7NNDI0glQLAFbF
         mBWw==
X-Gm-Message-State: APjAAAVhKoCkM0E6MVell8uT+ovCeqMufOub2QN36SXw9fMzEQXBnY51
	WQZboCD2mEjWJkIvZ2g30mpYrORwJg63KPYb64E=
X-Google-Smtp-Source: APXvYqxT5yYNPjiMSlzwumlj8UjSOAfCmDmgAcpOZOM10R//Skv4aoDktplFaX7g2Ws72X/gbHtxdVXSSeajbRTRouQ=
X-Received: by 2002:ac2:55b4:: with SMTP id y20mr7590271lfg.173.1571444515448;
 Fri, 18 Oct 2019 17:21:55 -0700 (PDT)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191018161033.261971-7-samitolvanen@google.com> <CAKwvOd=z3RxvJeNV1sBE=Y1b6HgXdnT4M9bwMrUNZcvcSOqwTw@mail.gmail.com>
 <CABCJKud6+F=yhTo6xTXkHhtLWcSE99K=NcfKW_5E4swS4seKMw@mail.gmail.com>
 <CANiq72=PSzufQkW+2fikdDfZ5ZR1sw2epvxv--mytWZkTZQ9sg@mail.gmail.com> <CAKwvOdkqfbXVQ8dwoT5RVza6bZw3cBQUEGcuRHu0-LhObkg--w@mail.gmail.com>
In-Reply-To: <CAKwvOdkqfbXVQ8dwoT5RVza6bZw3cBQUEGcuRHu0-LhObkg--w@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sat, 19 Oct 2019 02:21:44 +0200
Message-ID: <CANiq72m_+YLLWuRGi=yZBAUj2WHSbw9E+jQ02LbXyq3b12Vb6g@mail.gmail.com>
Subject: Re: [PATCH 06/18] add support for Clang's Shadow Call Stack (SCS)
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: Sami Tolvanen <samitolvanen@google.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Dave Martin <Dave.Martin@arm.com>, 
	Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, 
	Mark Rutland <mark.rutland@arm.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Oct 18, 2019 at 10:33 PM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> Sami pointed out to me off thread that __has_attribute would only
> check `no_sanitize`, not `shadow-call-stack`.  So maybe best to keep
> the definition here (include/linux/compiler-clang.h), but wrapped in a
> `__has_feature` check so that Clang 6.0 doesn't start complaining.

Ah, good point -- agreed!

Cheers,
Miguel
