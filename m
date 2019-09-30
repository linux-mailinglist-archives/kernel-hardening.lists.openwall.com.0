Return-Path: <kernel-hardening-return-16977-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id DF250C2B1B
	for <lists+kernel-hardening@lfdr.de>; Tue,  1 Oct 2019 01:51:23 +0200 (CEST)
Received: (qmail 20215 invoked by uid 550); 30 Sep 2019 23:51:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 20183 invoked from network); 30 Sep 2019 23:51:17 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=uoUPfoqpvGGg+NGeSbdIvAS95caQRNPvjfk9skLTIZo=;
        b=dcK7ybFV81yNhSvCIxEePaWh3avBUdt7R4EmBjpoJ3lMjkC4HkVfKD7NZfTUAvRy4Q
         wp/3xTxP4XjGrUcj0XV4P48DByttP8j5dQMTBPC0pTYxyhJqyjwfYA1EKriHvkf50F3R
         M1Ek+LuC/6Wvzze+9NXSOLl0FvS5sJAYsh6J8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=uoUPfoqpvGGg+NGeSbdIvAS95caQRNPvjfk9skLTIZo=;
        b=pFx7XVfHRsGwDk47FojlFuoSKbkH9mIFrPYRxVNjO8mAHkDZE/5xZ8mM6Y4qM1Zzzr
         njpC8Z/h/ofSPR2TcCB718u8PGqZM2LJDU0tDfrV2f+qvEYwRYc9RVJABJum7S6aEqpU
         3HSXS5uEpMDoMLbhFyNzwnU8yvSTPaAZmFr5nZdVZ6WbCAtiQDLCyavuh6BUmPrcH//S
         LPoEH3YROZKfKrtz37QBEERI+4sJ+mBQ6gJPcemqx0y/N+GdYIYtGcQN8upnkogGZ4RS
         BOGnWbwJpV3hpClN12pNfzY1pupdjvff0A9agDxB56CmiuzYFEB18FM07utoXTIgnGNm
         yk3g==
X-Gm-Message-State: APjAAAUmf6DfDP9dRoVp1MwjGPDdvR3GXlj3gOMWcT/cxKoOuwhsq8+g
	rqo+1ddiqDY32NXNylMIZPEkvw==
X-Google-Smtp-Source: APXvYqz9DAx7FOwoVxfLxM5ugMI2ttJNNFfbLXEMuWWuV1gsmrzqAePPZhR4xMOzFLLjZRKVzy//hQ==
X-Received: by 2002:a17:902:209:: with SMTP id 9mr22325332plc.1.1569887465675;
        Mon, 30 Sep 2019 16:51:05 -0700 (PDT)
Date: Mon, 30 Sep 2019 16:51:03 -0700
From: Kees Cook <keescook@chromium.org>
To: Muni Sekhar <munisekharrms@gmail.com>
Cc: kernel-hardening@lists.openwall.com
Subject: Re: How to get the crash dump if system hangs?
Message-ID: <201909301645.5FA44A4@keescook>
References: <CAHhAz+htpQewAZcpGWD567KLksorc+arA3Mu=hkUX+y6567jGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHhAz+htpQewAZcpGWD567KLksorc+arA3Mu=hkUX+y6567jGA@mail.gmail.com>

On Thu, Sep 26, 2019 at 01:47:00AM +0530, Muni Sekhar wrote:
> I looked at the available tests with "cat
> /sys/kernel/debug/provoke-crash/DIRECT", from this I’d like to know
> which test causes system hang? I could not find any test case for
> deadlock, is any reason for this?

The various *LOCKUP tests will hang a CPU or task (though SPINLOCKUP
needs to be called twice). You could keep calling HARDLOCKUP until
you're out of CPUs, for example. :)

What kind of deadlock do you want to test?

> I’m having a Linux system, I’m seeing it gets hung during certain
> tests. When it hung, it does not even respond for SYSRQ button, only
> way to recover is power-button-only.  Does no response for SYSRQ
> button means kernel crashed?

That's an impressive hang! :(

> After reboot I looked at the kern.log and most of the times it has
> “^@^@^@^ ...“ line just before reboot. Can someone clarify me what the
> kernel log entry “^@^@^@^ ...“ means? I suspect kernel is crashed, but
> it does give any crashdump in kern.log.

That's a zero byte. I would suggest using something like pstore to
capture this in RAM instead of hoping it makes it to disk.

> Later I enabled the kernel crash dump(sudo apt install
> linux-crashdump) and rerun the test but still nothing copied to the
> disk(/var/crash/). I don’t have onboard serial port in my machine, so
> I tried get the crash dump via netconsole, but this method also does
> not able to catch the crash dump.
> 
> Can someone help me how to debug in this scenario?
> 
> And I'd like to know what other options available to get the crash
> dump? Can someone please clarify me on this?
> 
> Also , does the crash dump fails if incase deadlock occurs?
> 
> Any help will be greatly appreciated.

If you really need to hard-power your system to get it back, pstore may
only work if you're really quick and likely enable software ECC.

-- 
Kees Cook
