Return-Path: <kernel-hardening-return-18954-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 270371F5C5D
	for <lists+kernel-hardening@lfdr.de>; Wed, 10 Jun 2020 22:03:50 +0200 (CEST)
Received: (qmail 21876 invoked by uid 550); 10 Jun 2020 20:03:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 21855 invoked from network); 10 Jun 2020 20:03:43 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gMJmfBXQHkqYBkdWFgkIELmfTMw2QzimZzoX9rnpMvg=;
        b=VmhHMiuh5ohUCH3fDJnKjrDQRFL0Ji8PnJG1vfqLFDTNpxPKF/jUW6bjeiV5SjTR6o
         WXLVjXgIO5BzDsgibhA+L18doG6dCY7DA2U8R4aA2THMwHzIRdDqPqVTIOT51M5UhGjo
         pbeqxJDSxr/3GPDIEZHoH3PhBmMXdRDJJDdIM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gMJmfBXQHkqYBkdWFgkIELmfTMw2QzimZzoX9rnpMvg=;
        b=H0agp9TmeolXcWSnxgZCctiT0dNzBASHxqOohH12wEqhJncSbfTRUP6t7nPWFOhyp0
         Q8c4+GFnTnezs569P/sH7yY9ZtBEQ30jEdBAtvOReZHqrcM0bVhOcqubJSj/eOvvrshA
         MwLse1APS6Ny8loL2fnG6WqKP2iCLNWWHV779/Du0eEOQOGl9nR9KRGd6xycqoXjBLn9
         PPimEFrjO8QwNIcR36u0d7NlEm5VJboj1QUPg4sew0Nzn7VYp/V7PUFxqdIME+ugP7Jy
         eNVbIjh1+sDqEi8axCUNQ76J8yhe519pUP9UGboccZ7a0EUXvfJIAQSOkVNQ/+wheJqO
         6mAw==
X-Gm-Message-State: AOAM532lCBMaX9qH6gf7c2OfdHcAjVlBDS4VhyZ1yejK3FTWlNhC3Sj9
	dYcesQsVBangrWrKOPuVpOShFw==
X-Google-Smtp-Source: ABdhPJzkqdGCWRf/l2Trk3MffvrvqWcW6Bumgrl4Vv2VZmme66jypNqah8ksfCDrx7bzuNc50pX7OQ==
X-Received: by 2002:a17:90a:cb8d:: with SMTP id a13mr4644611pju.175.1591819409470;
        Wed, 10 Jun 2020 13:03:29 -0700 (PDT)
Date: Wed, 10 Jun 2020 13:03:27 -0700
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
Subject: Re: [PATCH 2/5] gcc-plugins/stackleak: Use asm instrumentation to
 avoid useless register saving
Message-ID: <202006101302.AC218FA1@keescook>
References: <20200604134957.505389-1-alex.popov@linux.com>
 <20200604134957.505389-3-alex.popov@linux.com>
 <202006091143.AD1A662@keescook>
 <757cbafb-1e13-8989-e30d-33c557d33cc4@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <757cbafb-1e13-8989-e30d-33c557d33cc4@linux.com>

On Wed, Jun 10, 2020 at 06:47:14PM +0300, Alexander Popov wrote:
> On 09.06.2020 21:46, Kees Cook wrote:
> The inline asm statement that is used for instrumentation is arch-specific.
> Trying to add
>   asm volatile("call stackleak_track_stack")
> in gcc plugin on aarch64 makes gcc break spectacularly.

Ah! Thank you, that eluded my eyes. :)

> I pass the target arch name to the plugin and check it explicitly to avoid that.
> 
> Moreover, I'm going to create a gcc enhancement request for supporting
> no_caller_saved_registers attribute on aarch64.

For arm64 right now it looks like the plugin will just remain
"inefficient" in these cleanup, as before, yes?

-- 
Kees Cook
