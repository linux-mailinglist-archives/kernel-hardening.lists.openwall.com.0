Return-Path: <kernel-hardening-return-18421-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id A036219E172
	for <lists+kernel-hardening@lfdr.de>; Sat,  4 Apr 2020 01:28:31 +0200 (CEST)
Received: (qmail 32719 invoked by uid 550); 3 Apr 2020 23:28:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 32687 invoked from network); 3 Apr 2020 23:28:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ig7LwYAL0F3gpSoAsrhhiXcU4mF6WOVfVlihZurEo5s=;
        b=HdYhe/GrgWmhKkmNme2y2h0124rmBccjJlXtG2zbYNWxp6pU06LyO0WmZ57NnvlIyT
         CRSCfokhU/mcRtpj1AdbJAf3scEMDJ6MnYkLprA1GI0nUwyGpj2atU3HuufIpmkA+lWa
         hTd2PEkCx4FR1jabjWgbsBcMNwfzF3Mpobj7s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ig7LwYAL0F3gpSoAsrhhiXcU4mF6WOVfVlihZurEo5s=;
        b=MoLMm29Cef9/OnJ2DG09TT3LDCyReWHI40EOe5+uph4ndLekzBJzy3RlkpqQ462lAQ
         AHpTUjYfwSVPPJT0fgT/WJu4q4xEHuLRpj55wj9lj5BC1V8naplWy8ze6nSJTRfisftH
         22NYXqsm3uBTyKGAg2JYQEK5io6nSme7A6qXFBHAypzQbXtXr118kvrXYEyyVBDVgPWw
         4uCj7Docs2NMCr3xCW+wcNR8aFU8HB+ab13q8y7IHpfyVmdg8/ocU9gAnCaAJKQBK2Te
         MhuZ+J5CXrzjIwlVmn+C90xBxHLkdPt/JT/BkEBvwIY/01aTOl3tggDWjLLhL/LMSdIj
         ZgcA==
X-Gm-Message-State: AGi0PuZbJ8hvC08VxwC/sfke+r+e9NF124ZRqy67hq4kuu+iXxS2cpYz
	xxkoAUtY5hKGZN/xkFOdG14LFg==
X-Google-Smtp-Source: APiQypLWT4pvW2zOZhUgaslgqCEhlYeuzckYBx3ELRPFqvpWGMFKiOTrDXrPFzyJTvbQEK2Kgc7Kig==
X-Received: by 2002:a17:90a:bf84:: with SMTP id d4mr12693059pjs.82.1585956492395;
        Fri, 03 Apr 2020 16:28:12 -0700 (PDT)
Date: Fri, 3 Apr 2020 16:28:10 -0700
From: Kees Cook <keescook@chromium.org>
To: "joao@overdrivepizza.com" <joao@overdrivepizza.com>
Cc: kernel-hardening@lists.openwall.com, vasileios_kemerlis@brown.edu,
	sandro@ic.unicamp.br
Subject: Re: kCFI sources
Message-ID: <202004031626.B2FDF354@keescook>
References: <3446-5e86ca00-7-77f96080@18228891>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3446-5e86ca00-7-77f96080@18228891>

On Fri, Apr 03, 2020 at 07:29:38AM +0200, joao@overdrivepizza.com wrote:
> FWIW, In case someone has any interest in looking into it, a month ago I uploaded the old sources for a kernel CFI prototype I implemented back in 2015/2016 (kCFI) here: https://github.com/kcfi/kcfi

Great; thanks!

> As is, the code supports kernel 3.19. It is no longer maintained and, given that the upstream Linux kernel may have its own CFI scheme somewhat soon, I don't believe that there is much sense in trying to forward-port it or anything. Either way, if it is useful for anyone, there you go.

Weren't there updates make to LLVM to provide a more fine-grained
bucketization of the function prototypes? (i.e. instead of all "void
func(void)" being in one bucket, they got chopped into more buckets?)

-- 
Kees Cook
