Return-Path: <kernel-hardening-return-19771-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id D8BBF25CDFE
	for <lists+kernel-hardening@lfdr.de>; Fri,  4 Sep 2020 00:45:23 +0200 (CEST)
Received: (qmail 12016 invoked by uid 550); 3 Sep 2020 22:45:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 11984 invoked from network); 3 Sep 2020 22:45:18 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eNUX/+cTGqvgJ3/bHzJkiLjPir7L2OtlnI7Fkl+Xb2A=;
        b=EnTAgexJsxXcgEbYIyXAxzgDAfpWUMxvmgoddQQgsTw/gu1PMimkQi0sFP+vzoRcoR
         R5cz17bX6mXjaaXhIIENszOU7GVzd7UtV6ivYdntcxzorGKNslOUw1wAcWUJDwdLZcXs
         t89r3dF6Bm22f/kj6qlw0hvfFybNvnGy7LAoY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eNUX/+cTGqvgJ3/bHzJkiLjPir7L2OtlnI7Fkl+Xb2A=;
        b=Gmvh2kcwcyqXCZhmeP1z+pWNfEMoM2rSIRXSEBlyHQkPjR7JZKFaTeJaT6mbIlUtd0
         HfTty7TpJP0cUovmSPMUnIVa3SIHN7gn2j675ADTRX5G8DZl2o0qarvJMtpbRt9dAT40
         US/7NKDWGrg0X2rYBR+yUhoSa+VNwQGGWUUeeVNOFL4PU6z1QfKw5L4yOD4LZF5x5omi
         UwJvvdBk+u/G66qeM72NxlfRSKn3jVozJSAQqRz7S0WFZcQcp1aG5hmhQRBOj16BsRpb
         vGAec8Il/whBeZzJDq9KcypPuOIgMTAdO6u01SasGTroMuBMIAfBfGTIHZg4pyfIE1cR
         K57g==
X-Gm-Message-State: AOAM532pV3wNZcrcxhDU9HIJPekP8uBue5YEb9OQYbgi07hPwRdDqw0f
	4eB17EsCRabZGkAAX8edBtnojQ==
X-Google-Smtp-Source: ABdhPJyNZusftJcT3VvVFgkaB8aDPyaKtOWJ1b5YXcXD0oRJUTHNPVuoSuBrwlfSbjV/D5xOI4z0Ow==
X-Received: by 2002:a17:902:7045:: with SMTP id h5mr6014077plt.4.1599173106022;
        Thu, 03 Sep 2020 15:45:06 -0700 (PDT)
Date: Thu, 3 Sep 2020 15:45:04 -0700
From: Kees Cook <keescook@chromium.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	x86@kernel.org
Subject: Re: [PATCH v2 23/28] arm64: vdso: disable LTO
Message-ID: <202009031544.61133BF@keescook>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200903203053.3411268-1-samitolvanen@google.com>
 <20200903203053.3411268-24-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903203053.3411268-24-samitolvanen@google.com>

On Thu, Sep 03, 2020 at 01:30:48PM -0700, Sami Tolvanen wrote:
> Disable LTO for the vDSO by filtering out CC_FLAGS_LTO, as there's no
> point in using link-time optimization for the small about of C code.
> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

Yup. (And another replacement of the non-functional DISABLE_LTO...)

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
