Return-Path: <kernel-hardening-return-16232-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id DB2F65586A
	for <lists+kernel-hardening@lfdr.de>; Tue, 25 Jun 2019 22:08:28 +0200 (CEST)
Received: (qmail 15623 invoked by uid 550); 25 Jun 2019 20:08:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 15605 invoked from network); 25 Jun 2019 20:08:21 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QTBYIsHI8zTMLEyvwtX6vz4jgxzEbNHxNVg1zzv+uWs=;
        b=GFD4YL7rkGte7dY9QecMGQVpBAuunM7M4kNB4I4J4HToFkTT6kzO4mzdswjpF7r040
         S9GAX102W+LhmXZ4yS3Q53lWrLv0qMrY09Rn9OEGQf3DWq6oOD93s6yEIZi9ZSY/8mOE
         tHZM21Pp0ucGbM3ZzgASmEvwhutvcH3mQAzmk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QTBYIsHI8zTMLEyvwtX6vz4jgxzEbNHxNVg1zzv+uWs=;
        b=IG8s9HEkBtcs3cFqMvUJSezV5DOSGtLfNwUMEIdcGlUPmlKDKdiUCjrqJXex4vqrqi
         E+O1m2psWztJWVqmtGzfHfPCT55s+xUBpfBqKwSljsxk3J60Qi2pnps84Sur6ZHc+bXg
         +zyjXR+58TS4fEIb+3/y6s3JEYM9Lbp0THDHEHDfl7g5Ta3fx3+/ornLotpklkRW1okQ
         00IoKsUp2eQot4aHA/LfU0g4uwaaiWvhUC/8k56YBOJk31hXw1zHIVrU4+3jGpk2vQJz
         KAhIUGSP0sEMA8H2uu3/B2mCNcG+yy5s8VUPuAdY6CLg3ID1G7cNoWO7d8FVzFrhEgVH
         SguQ==
X-Gm-Message-State: APjAAAVvvqKoA2sxkl3iQVimZeNP9D1dfM//r+Drs29eDgF7j5wMI/XB
	cFGfabbDe9buBRuKpScwy6ZIMw==
X-Google-Smtp-Source: APXvYqz4wFwSx2u/z3fzZResgKJfp4GOCsNFxJX8Qh/tN021DReuR4LVm+X37zl/gnxfdS1yHAMYkA==
X-Received: by 2002:a65:62cb:: with SMTP id m11mr25236218pgv.27.1561493289120;
        Tue, 25 Jun 2019 13:08:09 -0700 (PDT)
Date: Tue, 25 Jun 2019 13:08:07 -0700
From: Kees Cook <keescook@chromium.org>
To: Florian Weimer <fweimer@redhat.com>
Cc: linux-api@vger.kernel.org, kernel-hardening@lists.openwall.com,
	linux-x86_64@vger.kernel.org, linux-arch@vger.kernel.org,
	Andy Lutomirski <luto@kernel.org>,
	Carlos O'Donell <carlos@redhat.com>
Subject: Re: Detecting the availability of VSYSCALL
Message-ID: <201906251131.419D8ACB@keescook>
References: <87v9wty9v4.fsf@oldenburg2.str.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87v9wty9v4.fsf@oldenburg2.str.redhat.com>

On Tue, Jun 25, 2019 at 05:15:27PM +0200, Florian Weimer wrote:
> Should we try mapping something at the magic address (without MAP_FIXED)
> and see if we get back a different address?  Something in the auxiliary
> vector would work for us, too, but nothing seems to exists there
> unfortunately.

It seems like mmap() won't even work because it's in the high memory
area. I can't map something a page under the vsyscall page either, so I
can't distinguish it with mmap, mprotect, madvise, or msync. :(

-- 
Kees Cook
