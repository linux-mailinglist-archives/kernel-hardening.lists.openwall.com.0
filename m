Return-Path: <kernel-hardening-return-18130-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id CBCCD183DC1
	for <lists+kernel-hardening@lfdr.de>; Fri, 13 Mar 2020 01:06:22 +0100 (CET)
Received: (qmail 25677 invoked by uid 550); 13 Mar 2020 00:06:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 25645 invoked from network); 13 Mar 2020 00:06:15 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=MT56InialoA5Gvuu17QFzhKM9mlaqKUsiERx8J8mK8A=;
        b=JiEN0kcC+FSY9JxDVE0c/Nf+raSXxIfGzQiQhnnpAW2AxKWxl8VwuQzkSN6DGlyY/D
         eDRiciH0xugCpu0Hh94n501CXjCftR1SK/fbXY07Qli4f+xGd0C7FqiyWqvh4IrwhRRq
         BU1O23uhLzOqB6dxjuJhz6ZTZ5UjPI4f54crU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=MT56InialoA5Gvuu17QFzhKM9mlaqKUsiERx8J8mK8A=;
        b=cu4Yf7v/I8I0Xmi+qoLMgBohiEimuKJv83anHcVn3z1bi/psSmgyiNqCU92dxzl11N
         X2qycMC9jAHV5LgSd0JJ0lLO9aIX3pWVI8LCKio5mV6J32DdJM7erdnt2CIOk86dGaGk
         pwSac+Tn6LeL1PgAKz+HxPPPZP6ysw3t2yUg2HmcpkLFdVocoLr9tIUx3Iyf/xdnOdEX
         BGUZ/51Lv5+AH5yFynqrZDSoAFOSxe0qJqxgkmbIs+/fxZwCCGpBc43XE5o3Xy9vk7P+
         XQv9qhYXLIGBm1k9wyGVGZQfjjJk3GStYP0lOtl0LipJsDZ3yKRdF8LuBz9AG7wX4UDu
         bNSA==
X-Gm-Message-State: ANhLgQ1xxfgjjfX3aVzetH8oYwihCmtsUsgtOhnBPWc9vYJtgwqh+TIs
	XKxNmINP7nRwM7jWb97srEvL1g==
X-Google-Smtp-Source: ADFU+vufqVAMrmsyN2FQR+i0rIhNKJocLKys2LdKmIIuznP6bLJC6/QtdecJYAQsRGo5+9W0tYLH9Q==
X-Received: by 2002:aa7:8217:: with SMTP id k23mr10886894pfi.257.1584057963010;
        Thu, 12 Mar 2020 17:06:03 -0700 (PDT)
Date: Thu, 12 Mar 2020 17:06:01 -0700
From: Kees Cook <keescook@chromium.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Jason Gunthorpe <jgg@mellanox.com>,
	Hector Marco-Gisbert <hecmargi@upv.es>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Russell King <linux@armlinux.org.uk>, Will Deacon <will@kernel.org>,
	Jann Horn <jannh@google.com>, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/6] x86/elf: Add table to document READ_IMPLIES_EXEC
Message-ID: <202003121705.6ABA79D8F0@keescook>
References: <20200225051307.6401-1-keescook@chromium.org>
 <20200225051307.6401-2-keescook@chromium.org>
 <20200311194446.GL3470@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200311194446.GL3470@zn.tnic>

On Wed, Mar 11, 2020 at 08:44:46PM +0100, Borislav Petkov wrote:
> Ozenn Mon, Feb 24, 2020 at 09:13:02PM -0800, Kees Cook wrote:
> > Add a table to document the current behavior of READ_IMPLIES_EXEC in
> > preparation for changing the behavior.
> > 
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
> > ---
> >  arch/x86/include/asm/elf.h | 19 +++++++++++++++++++
> >  1 file changed, 19 insertions(+)
> > 
> > diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
> > index 69c0f892e310..733f69c2b053 100644
> > --- a/arch/x86/include/asm/elf.h
> > +++ b/arch/x86/include/asm/elf.h
> > @@ -281,6 +281,25 @@ extern u32 elf_hwcap2;
> >  /*
> >   * An executable for which elf_read_implies_exec() returns TRUE will
> >   * have the READ_IMPLIES_EXEC personality flag set automatically.
> > + *
> > + * The decision process for determining the results are:
> > + *
> > + *              CPU: | lacks NX*  | has NX, ia32     | has NX, x86_64 |
> > + * ELF:              |            |                  |                |
> > + * -------------------------------|------------------|----------------|
> > + * missing GNU_STACK | exec-all   | exec-all         | exec-all       |
> > + * GNU_STACK == RWX  | exec-all   | exec-all         | exec-all       |
> > + * GNU_STACK == RW   | exec-none  | exec-none        | exec-none      |
> 
> In all those tables, you wanna do:
> 
> s/GNU_STACK/PT_GNU_STACK/g
> 
> so that it is clear what this define is.

Fair enough. :) I think I was trying to save 3 characters from earlier
tables that were wider. I'll send a v5.

Thanks!

-Kees

-- 
Kees Cook
