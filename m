Return-Path: <kernel-hardening-return-16594-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id CF30F76EB7
	for <lists+kernel-hardening@lfdr.de>; Fri, 26 Jul 2019 18:16:18 +0200 (CEST)
Received: (qmail 29943 invoked by uid 550); 26 Jul 2019 16:16:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 29901 invoked from network); 26 Jul 2019 16:16:10 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9pxdI8Q1eQGc6MFJDXbX8IPKQf5e9FjRtdij/Ccdk+g=;
        b=GhJtb6y3IvR2euTrzUQLBPzuWpMC1r078nOKLTS2B26A9HymM6QBFZfT03uDUsxGMt
         qEU5Dj5ZPRoFY2MiQMolT8V6egN2ZpXNx0R/y1ExRSFTnrcIQQkTlH+qisWgVrr+fhu5
         fwWtJB/yQ5JNCDew1FsG+XjvLgH1fzf99fEmQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9pxdI8Q1eQGc6MFJDXbX8IPKQf5e9FjRtdij/Ccdk+g=;
        b=pjF+ldIyFcp/xHyoYLOzTttNnVIjI/p5PscJTae0jcdqEENQaMy1QUdILaSz8q+ysf
         tDYyianJbGv+VJ3/AUseHTP+NSfIDSKA3ZPUxL5ZeWFP9pfsGi0esVx8ZVxzSNfFvpGZ
         uBeKOv02kcXJp4E9Xz3QXBCVLYxQdlcX1fAWVTPLGeH4NgjQ5UuYDxa6rtVd7xMwOtev
         SR9dOt1Zktj80bm5k18sHxBkB2fLBmvRn5M9zg9NzAI/FNj2L4ETdMjfkHC7ILa1FTbS
         Ic29+eXEez2tHWpG8TW1rdJV47094vwawloVR9ICcXePxMenHugvNSQBGQpASl0Dd5JM
         R05Q==
X-Gm-Message-State: APjAAAUL9DWRLdZIRBncjvK0l/Ca1JFwafbdWTmbnVPBhrK1YMWE6rph
	2W+nizis7n42YsdID7vxo9sCgA==
X-Google-Smtp-Source: APXvYqxorBpjLgP/KwuMcH8kC+695azPg68CPTEJ3NXXlbisGsg21F6WBT3zy6Q5jm5oFPVjAt8Owg==
X-Received: by 2002:a62:5344:: with SMTP id h65mr23349574pfb.32.1564157758990;
        Fri, 26 Jul 2019 09:15:58 -0700 (PDT)
Date: Fri, 26 Jul 2019 09:15:57 -0700
From: Kees Cook <keescook@chromium.org>
To: Jason Yan <yanaijie@huawei.com>
Cc: mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org,
	diana.craciun@nxp.com, christophe.leroy@c-s.fr,
	benh@kernel.crashing.org, paulus@samba.org, npiggin@gmail.com,
	kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
	wangkefeng.wang@huawei.com, yebin10@huawei.com,
	thunder.leizhen@huawei.com, jingxiangfeng@huawei.com,
	fanchengyang@huawei.com
Subject: Re: [RFC PATCH 00/10] implement KASLR for powerpc/fsl_booke/32
Message-ID: <201907260914.E37F9B041@keescook>
References: <20190717080621.40424-1-yanaijie@huawei.com>
 <e6ad41bc-5d5a-cf3f-b308-e1863b4fef99@huawei.com>
 <201907251252.0C58037@keescook>
 <877d818d-b3ec-1cea-d024-4ad6aea7af60@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877d818d-b3ec-1cea-d024-4ad6aea7af60@huawei.com>

On Fri, Jul 26, 2019 at 03:20:26PM +0800, Jason Yan wrote:
> The boot code only maps one 64M zone at early start. If the kernel crosses
> two 64M zones, we need to map two 64M zones. Keep the kernel in one 64M
> saves a lot of complex codes.

Ah-ha. Gotcha. Thanks for the clarification.

> Yes, if this feature can be accepted, I will start to work with powerpc64
> KASLR and other things like CONFIG_RANDOMIZE_MEMORY.

Awesome. :)

-- 
Kees Cook
