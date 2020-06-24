Return-Path: <kernel-hardening-return-19099-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 16E8C207524
	for <lists+kernel-hardening@lfdr.de>; Wed, 24 Jun 2020 16:02:16 +0200 (CEST)
Received: (qmail 24450 invoked by uid 550); 24 Jun 2020 14:02:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 22234 invoked from network); 24 Jun 2020 12:52:50 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ImZMVmJ6KLEqHAgKJ4c32f0nuRv6OUnQsFfctRSAXJo=;
        b=rp63CXNNmJdvi7EOVw0W1SXMcaY8vfg8HjVrKLrYU/ZL/9ZzGzFZbZoPvKv7RH0OLA
         +n5w5IxJHUGqe4rStlPTTvwGWxZiykxAxp3KzvdFv/FKPaGB/wN21dSqCcFENC69ph/x
         rRMncFE30RREd2Qhg0zf8qkeS3FGYNStdjcUeIYJc1vD4ScaLo+siZSNnlGnyz7XF5II
         YyndAjAwxq/FI38Dl1iOngRMZ3BjXUz5c419ueTYAbkTQdL0+Md1UNrU5hKrGno7UxYV
         vS25NqcHdAbWbj0Ikwrke6OZQ2BTupDNJV8vvwZ4Qhz6RJrflS/8jcCcqrwymXqsD2sk
         APjQ==
X-Gm-Message-State: AOAM532lhE9x/ENXW+mxkgSlbH0BvG3mRAexMEHvzpleVOOaFLSpmxE5
	yrTNZdDPbH7HjYNoa5LdYjk=
X-Google-Smtp-Source: ABdhPJzddnf/uaOk9Rgp8vbxcf8lUTdU8rjuvn4Wiik8YZvkhsAy30AnlKe/2Lxzs/SCBU/Spfu6GQ==
X-Received: by 2002:a63:2a8a:: with SMTP id q132mr21027891pgq.279.1593003158753;
        Wed, 24 Jun 2020 05:52:38 -0700 (PDT)
Date: Wed, 24 Jun 2020 12:52:36 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: Alexander Popov <alex.popov@linux.com>
Cc: Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>,
	Emese Revfy <re.emese@gmail.com>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Michal Marek <michal.lkml@markovi.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	Thiago Jung Bauermann <bauerman@linux.ibm.com>,
	Jessica Yu <jeyu@kernel.org>, Sven Schnelle <svens@stackframe.org>,
	Iurii Zaikin <yzaikin@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Collingbourne <pcc@google.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Alexander Monakov <amonakov@ispras.ru>,
	Mathias Krause <minipli@googlemail.com>,
	PaX Team <pageexec@freemail.hu>,
	Brad Spengler <spender@grsecurity.net>,
	Laura Abbott <labbott@redhat.com>,
	Florian Weimer <fweimer@redhat.com>,
	kernel-hardening@lists.openwall.com, linux-kbuild@vger.kernel.org,
	x86@kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, gcc@gcc.gnu.org, notify@kernel.org
Subject: Re: [PATCH v2 2/5] ARM: vdso: Don't use gcc plugins for building
 vgettimeofday.c
Message-ID: <20200624125236.GF4332@42.do-not-panic.com>
References: <20200624123330.83226-1-alex.popov@linux.com>
 <20200624123330.83226-3-alex.popov@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200624123330.83226-3-alex.popov@linux.com>

On Wed, Jun 24, 2020 at 03:33:27PM +0300, Alexander Popov wrote:
> Don't use gcc plugins for building arch/arm/vdso/vgettimeofday.c to
> avoid unneeded instrumentation.
> 
> Signed-off-by: Alexander Popov <alex.popov@linux.com>

But why is skipping it safe?

  Luis
