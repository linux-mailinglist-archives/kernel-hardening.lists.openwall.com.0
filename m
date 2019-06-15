Return-Path: <kernel-hardening-return-16150-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 3C35C46DF6
	for <lists+kernel-hardening@lfdr.de>; Sat, 15 Jun 2019 05:09:03 +0200 (CEST)
Received: (qmail 3167 invoked by uid 550); 15 Jun 2019 03:08:56 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3133 invoked from network); 15 Jun 2019 03:08:56 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=s3h9liOL4pzy4K3mokxNpyJvGGWg+jIohBl0u3f0MSw=;
        b=nLJrviAAsir3PYO/XtH16yQzp8ONsbHuhdT8WIRi/kJGgxZSSD55ofOhQDDYeUdiu0
         A7bYKKKzCmbwF1kdcQlqcIp/DseAP6aT5PVkQZaEIVEVBXstCULU0UiiNAXsNo5l2zrV
         gUD/9w6GoXQk/0PpZRJIVFj+/Sv4EozCcSF+I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=s3h9liOL4pzy4K3mokxNpyJvGGWg+jIohBl0u3f0MSw=;
        b=tvOUx3V2r1dUKJgzCDK4i7qM5/gIRDKmZ2laiOWKHmRrhgrTjod2yj890KotrKU0ry
         SEvjsS9SXzupxryHHKPVHfvWbJhkASDBCWReVYK2KGS8BIM7OK8RD0+JIMD/zEhytmQp
         pYbZFPrRB/PmvC8WRnydc7aNu29W1nGQLdyMJQErWKZETN4WaP8sUqRSfGZHQP1G7v2a
         Ii4MdPNeDsknMJ7+qhesWgy1xNODcD00+Z6tW21hD8T6wC4gsPzYjNPvexXY7dDn/GTG
         MO3kwkW73XLiYjGoNBuuftV6V75gJTJopvpZdExqEnFiAI8AXv91v1lv+NEjZr07R6Pw
         Z5lA==
X-Gm-Message-State: APjAAAXvDcOIAAZrhgptde66LvdJG3HGHmkQpL3/e+w+iFOGTNZP8Y+S
	CpyqDi4o9UNTth1AI+G0b6LwpQ==
X-Google-Smtp-Source: APXvYqxIMz0tLLWT+ykuDfGa2gdns1WEiGTzOvYHKMsnAh3J26q1NOxQ3TGblUcsPdaDOSE8lxsQOg==
X-Received: by 2002:a63:f402:: with SMTP id g2mr37256655pgi.197.1560568124036;
        Fri, 14 Jun 2019 20:08:44 -0700 (PDT)
Date: Fri, 14 Jun 2019 20:08:42 -0700
From: Kees Cook <keescook@chromium.org>
To: Jann Horn <jannh@google.com>
Cc: Denis 'GNUtoo' Carikli <GNUtoo@cyberdimension.org>,
	Emese Revfy <re.emese@gmail.com>,
	Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-arm-kernel@lists.infradead.org,
	Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH] security: do not enable CONFIG_GCC_PLUGINS by default
Message-ID: <201906142002.833D224C6F@keescook>
References: <20190614145755.10926-1-GNUtoo@cyberdimension.org>
 <CAG48ez30+VOj78rCiWMKtm0tHdVR67CcrHVCV-FFCfK-nRQTOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez30+VOj78rCiWMKtm0tHdVR67CcrHVCV-FFCfK-nRQTOw@mail.gmail.com>

On Fri, Jun 14, 2019 at 06:05:19PM +0200, Jann Horn wrote:
> On Fri, Jun 14, 2019 at 5:10 PM Denis 'GNUtoo' Carikli
> <GNUtoo@cyberdimension.org> wrote:
> > Booting was broken by the following commit:
> >   9f671e58159a ("security: Create "kernel hardening" config area")
> 
> I don't think GCC_PLUGINS alone is supposed to generate any code? It
> just makes it possible to enable a bunch of other kconfig flags that
> can generate code.
> 
> STACKPROTECTOR_PER_TASK defaults to y and depends on GCC_PLUGINS, so
> is that perhaps what broke? Can you try whether disabling just that
> works for you?

Yes, this has come up before: the option you want to disable is as Jann
mentions: CONFIG_STACKPROTECTOR_PER_TASK.

> My guess is that maybe there is some early boot code that needs to
> have the stack protector disabled, or something like that.

Right, though I'm not sure what portion would be specific to that
device. You can turn off SSP on a per-file basis with:

CFLAGS_target.o += $(DISABLE_ARM_SSP_PER_TASK_PLUGIN)

or per-Makefile, as in arch/arm/boot/compressed/Makefile.

-- 
Kees Cook
