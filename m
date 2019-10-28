Return-Path: <kernel-hardening-return-17139-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 865C8E7924
	for <lists+kernel-hardening@lfdr.de>; Mon, 28 Oct 2019 20:23:16 +0100 (CET)
Received: (qmail 22129 invoked by uid 550); 28 Oct 2019 19:23:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 22094 invoked from network); 28 Oct 2019 19:23:09 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=DjF/eNvkGdaDeX7wOk+AYNOQrW66dThZabixiWsapkU=;
        b=brI1TRWDsIZBjI7b4p2HXPWwsbosgEcDNEaZeRPmu2zo3oYzeSXz7bz4Zdq9iGPtqm
         L8wlHG1a6QFtRHIFoSpZ44cFImA6eTeGV1kXtWoqefGEIbKvw4jYJP2ua2NuBmV4Zb4a
         Z9X8XhRM8Om6fLW1H+JLe/5X18tAgkUK6EtWc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=DjF/eNvkGdaDeX7wOk+AYNOQrW66dThZabixiWsapkU=;
        b=T8WMUHAEcyM2+5u6lNFu4E2WNn7PWdBjy87+OpGrjJmMgo4k1zdRBQ7bC+/ZKO7HQZ
         Xt/Yiso1mO5WMFLnM6T9BWJO4bV7seupLbyACf62axUZNix71N9cl4LYFuDXRxlikgks
         z2TK+EuO+R33ouXRm7X4wsGHFhWcHMaC482hCzJmlSXwg3vv3yPbkhNECIs1IZFIPHLI
         hGDdNQUcM+ibTeoZCKqYW7HEL9Ply0erL+JEvCSOG/1XF/QSoFpeGH1wQgdcEq/6uar2
         jE5HzBrDs1Tcimz7YsLR0HSxUVU7HIreX3hLlg7IXLGapPt1w6w75klrp20YdWN3Hrys
         HZ9g==
X-Gm-Message-State: APjAAAXn2W6yKyekYgaCI7uDlF9n0Uvn/LJqD9OvBXhkliH/m6Gkb2by
	WXujs/812vWXvMNRt1y+T9RLKw==
X-Google-Smtp-Source: APXvYqxtsUFXcTPTM+iV3+5SaYyNwo1Ir3mDhCcQnW9ccD9CRa8DG6kE9oTdn2X7xF85a+5Ww2VWlw==
X-Received: by 2002:a63:1c24:: with SMTP id c36mr19598598pgc.292.1572290577563;
        Mon, 28 Oct 2019 12:22:57 -0700 (PDT)
Date: Mon, 28 Oct 2019 12:22:55 -0700
From: Kees Cook <keescook@chromium.org>
To: Muni Sekhar <munisekharrms@gmail.com>
Cc: kernel-hardening@lists.openwall.com
Subject: Re: How to get the crash dump if system hangs?
Message-ID: <201910281220.D2ABC01B@keescook>
References: <CAHhAz+htpQewAZcpGWD567KLksorc+arA3Mu=hkUX+y6567jGA@mail.gmail.com>
 <201909301645.5FA44A4@keescook>
 <CAHhAz+jyZmLBsFBxLG_XmZRBrprrxa49T+07NhcrsH4Yi6jp6A@mail.gmail.com>
 <201910031417.2AEEE7B@keescook>
 <CAHhAz+iUOum7EV1g9W=vFHZ0kq9US7L4CJFX4=QbSExrgBX7yg@mail.gmail.com>
 <201910100950.5179A62E2@keescook>
 <CAHhAz+j9oaAY9_sn16J2c=U+iidZKu3mp0pRpPZAvu4dJPetkg@mail.gmail.com>
 <201910101106.9ACB5DB@keescook>
 <CAHhAz+hw251beDeaWRFV7oShngSQ_KAACXAzb45EZRBdZ3kbSg@mail.gmail.com>
 <CAHhAz+g6RBPKfUMne6Me_ha3FwUWj6a_pA=dYshyjAtOuu+SfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHhAz+g6RBPKfUMne6Me_ha3FwUWj6a_pA=dYshyjAtOuu+SfA@mail.gmail.com>

On Fri, Oct 25, 2019 at 07:40:58AM +0530, Muni Sekhar wrote:
> After loading the ramoops module, I see it generates dmesg and console logs.

Excellent!

> I’ve a actual test case where my system gets frozen  so have no
> software control. I executed this test case and as expected my system
> has frozen and recovered it by powering it on(cold boot?) and then
> loaded the ramoops but this time no files present in /sys/fs/pstore.

I wonder if you could use a hardware watchdog driver of some kind to
trigger the soft reboot?

> If you restart a PC in cold(hard) boot, is it possible to see the RAM
> memory(previous boot) still? I really I don’t know how it works.

It depends a lot on your chipset and RAM. It sounds like your system
very quickly wipes its RAM contents on a cold reset.

> So, is there a  way to automatically reboot the Linux system when it
> freezes? I set “kernel.softlockup_panic = 1, kernel.unknown_nmi_panic
> = 1, kernel.softlockup_all_cpu_backtrace = 1, kernel.panic = 1,
> kernel.panic_on_io_nmi = 1, kernel.panic_on_oops = 1,
> kernel.panic_on_stackoverflow = 1, kernel.panic_on_unrecovered_nmi =
> 1”, but it does not helped to reboot when it freezes.

See if Documentation/nmi_watchdog.txt helps?

Good luck!

-- 
Kees Cook
