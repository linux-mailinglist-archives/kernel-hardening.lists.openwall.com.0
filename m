Return-Path: <kernel-hardening-return-18942-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id D905E1F469D
	for <lists+kernel-hardening@lfdr.de>; Tue,  9 Jun 2020 20:48:26 +0200 (CEST)
Received: (qmail 18302 invoked by uid 550); 9 Jun 2020 18:48:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 18279 invoked from network); 9 Jun 2020 18:48:21 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=j2PL+pbfi1kh+J0AmLH2dyW1hfo8dchWmGFi/N5y4y0=;
        b=doetDBC8GLhAH/GPYh2nF/OZwCESJtT3x/5JwmFQppNQJr5rFhUwRcyR9FtefDzGs1
         RdTitQklosNO5HKOvlQUQJc+B3qoYVCfPRU7nKjg3lVc0+kFRfhloN8Q1BIilhESUAsl
         UifY/flT3XKb72YemuUE0ejI83VnmR69D+rOc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=j2PL+pbfi1kh+J0AmLH2dyW1hfo8dchWmGFi/N5y4y0=;
        b=iFMBN54sA2/3nM2NG0hNvrCscBEriTG27M6vbAHr88RBQRxRPBK152DJyxCSgQlkvx
         0g3XMWfkQ0MRnYjCw4g1zqlHPHqgEdzTzPjgVNDbjkRJrdQjgJtK0ivrCRSKFLFcFeqU
         lMMEaVVGNtYbKSSDGcAOL6sE/mLmde/M96zn2zceChM1BM6OE1S3fJBZoqryjz/81XqG
         JzWE10qEc4/7HsXbyPS3nJ8iIuu5cKEUDr+VoEbgOt+SqGROZMMwePNjk2Xh7GHd8RFC
         hyiGwKu20bQUKgrPUsSufiOwgSRck2DA/PZfAIK79SKuS313NiEx85EgK51xF4pegHrm
         dYUA==
X-Gm-Message-State: AOAM5309MlnFTIkBXKIn2meoP7bE+KxmFu9sgC9VV+4TWRKEXaLCWv9U
	KD7WwgxNpSUVMYxlpE933YT7GQ==
X-Google-Smtp-Source: ABdhPJyddt1fAWGutCRi8Fa6NrDKr2oQjU7wdUGjNSxmmyNx0/oNHsTyK+GsePEnmx8lD9WMuMMOGA==
X-Received: by 2002:a17:90a:2647:: with SMTP id l65mr6474171pje.20.1591728489562;
        Tue, 09 Jun 2020 11:48:09 -0700 (PDT)
Date: Tue, 9 Jun 2020 11:48:07 -0700
From: Kees Cook <keescook@chromium.org>
To: Alexander Popov <alex.popov@linux.com>
Cc: Emese Revfy <re.emese@gmail.com>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Michal Marek <michal.lkml@markovi.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	Thiago Jung Bauermann <bauerman@linux.ibm.com>,
	Luis Chamberlain <mcgrof@kernel.org>, Jessica Yu <jeyu@kernel.org>,
	Sven Schnelle <svens@stackframe.org>,
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
Subject: Re: [PATCH 4/5] gcc-plugins/stackleak: Don't instrument itself
Message-ID: <202006091147.1B8E3ABE@keescook>
References: <20200604134957.505389-1-alex.popov@linux.com>
 <20200604134957.505389-5-alex.popov@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200604134957.505389-5-alex.popov@linux.com>

On Thu, Jun 04, 2020 at 04:49:56PM +0300, Alexander Popov wrote:
> There is no need to try instrumenting functions in kernel/stackleak.c.
> Otherwise that can cause issues if the cleanup pass of stackleak gcc plugin
> is disabled.
> 
> Signed-off-by: Alexander Popov <alex.popov@linux.com>

Acked-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
