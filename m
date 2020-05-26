Return-Path: <kernel-hardening-return-18813-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 84C911D481B
	for <lists+kernel-hardening@lfdr.de>; Fri, 15 May 2020 10:27:54 +0200 (CEST)
Received: (qmail 28587 invoked by uid 550); 15 May 2020 08:27:47 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 28549 invoked from network); 15 May 2020 08:27:46 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CMngIYbw7ybU9IAzJZ6Tc4ns5sarohLF06y1eTpMF68=;
        b=f6bk26IVNWB1qZSJM9yU2PJGKYwp/iI+c8K0nKBu+UDBR1K6kV7n0q/UsLlCTcsqt3
         12BxDQzbHpc0B5xQjoxUGSzLfImmEcs9LDaPRK5JzB4GBpwaOjTopyTZ5GMDhtPoM1+C
         SrvRLadyIqF7e8OzsQmElpiHJS+KPJvmJCCPc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CMngIYbw7ybU9IAzJZ6Tc4ns5sarohLF06y1eTpMF68=;
        b=XR/6wx2UX468Vg6AHUv6mI+VSBnICNL5+HE95kQ8PsYTQ9xBzeT/E7g33dQQbpOGaH
         JIjDpnx4tLQNZAGG98VnOMRan5yC6OQ4E/kioHl6FWPvIBKqTYHWZOlGCLEjYE6Uivst
         a0W82T0uyIPZqLZ9bnyMKt5JfRzlt0ifJtTQuDojgxsd064nTsqKwecLfrCY33YYWrSq
         fYFgAnZ2vb/KhPfz0xZ6pnrED/Hgo+Apre/yU/n4MV2hrnjln09i90gXP/9b9o4mjeFK
         Ihl5XNOcSneeMErBHQ/o5xqDZ7Ya4Vz/ccdain+fElqKv11tqlN4k4Q//AaRw1P9VWeE
         RSyA==
X-Gm-Message-State: AOAM531NK8Ut9gb+GSFCej/wa4A9I4J5lZ8Ly8XZHg3GdqB1U8t8XzlM
	t8/UCJlFbbLebJCbwKatV45W6xjTSC8=
X-Google-Smtp-Source: ABdhPJzUjrpjv+xe3PXpAOcRrkzdUuGNdtbbZKf23rOTq2Oyr1/iZA9OH/qrW6fpXzLQ7wtXOV1IGA==
X-Received: by 2002:a63:750b:: with SMTP id q11mr2054620pgc.138.1589531255133;
        Fri, 15 May 2020 01:27:35 -0700 (PDT)
Date: Fri, 15 May 2020 01:27:32 -0700
From: Kees Cook <keescook@chromium.org>
To: Oscar Carter <oscar.carter@gmx.com>
Cc: kernel-hardening@lists.openwall.com
Subject: Re: Get involved in the KSPP
Message-ID: <202005150125.8EDF28F00@keescook>
References: <20200509122007.GA5356@ubuntu>
 <202005110912.3A26AF11@keescook>
 <20200514172037.GA3127@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514172037.GA3127@ubuntu>

On Thu, May 14, 2020 at 07:20:37PM +0200, Oscar Carter wrote:
> On Mon, May 11, 2020 at 09:15:18AM -0700, Kees Cook wrote:
> > One mostly mechanical bit of work would be this:
> > https://github.com/KSPP/linux/issues/20
> > There are likely more fixes needed to build the kernel with
> > -Wcast-function-type (especially on non-x86 kernels). So that would let
> > you learn about cross-compiling, etc.
> >
> > Let us know what you think!
> 
> Great. This task seems good to me. I'm already working on it but I would like to
> know if it's correct to compile my work against the master branch of Linus tree
> or if there is some other better branch and tree.

For doing these kinds of things I tend to recommend either the last
full release from Linus (e.g. v5.6) or, if you want, the latest -rc2
(e.g. v5.7-rc2). Both are tagged, so you can based your tree on them
easily:

$ git clone ....
$ git checkout v5.7-rc2 -b devel/cast-function-type
$ *do stuff, etc*

-- 
Kees Cook
