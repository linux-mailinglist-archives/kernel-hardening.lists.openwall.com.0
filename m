Return-Path: <kernel-hardening-return-16939-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id B4643BEBC4
	for <lists+kernel-hardening@lfdr.de>; Thu, 26 Sep 2019 07:58:03 +0200 (CEST)
Received: (qmail 26315 invoked by uid 550); 26 Sep 2019 05:57:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 1024 invoked from network); 25 Sep 2019 20:17:22 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=J/s5UzAqezbutC2oi9AdlFVsV79wc1mf153fqreYkJA=;
        b=XoAnc0BEr4KHsLAuzeHQBerOL8lPo77zoG87AKkcm6jIrLTJwywECfIyo5boErAtWS
         91dT7Bw6TTfD0lTbD33dFgUVtjxVhH926ISFxggsUo1OMZ70Cyrpe5sKtIHLzl3OIVpI
         hQ2wWjw1EwzlbPlyaHbAnNh4CvOHpTzDO7rsOtFTESAnFWgNa++TKlX3n2RCYZgopNi0
         PcMXjeRWKJPVng8GjExZOfTfXW3fDbwTp2orQmx3sEbFxH8ALeEnFP7HatVCuEVggdam
         o5/aYPurmcLgVIFaEH1L/PbC3vyU8B0UpEfmfjV24fn5a4/uVGcq7ULN3wps313OTUGk
         SADg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=J/s5UzAqezbutC2oi9AdlFVsV79wc1mf153fqreYkJA=;
        b=KGFcvaUEQ0wELWSWxNZ4eUPKACwsMgBCq/V88Zi+bEk5Xk7Yz+iG5fNmkr97xShP2R
         ni8919dJ8MYpDKJOmHbWkbgj0OQATwg1rySnEpQSf8jM+6TuO+esg5zEAadS27q+4kg7
         tHdjE41rMHM0BmPL8iKYsqHL9X0dLyudFVa1kYeDX2tuKMAJHRmoY3RyAZac6tnYSpVg
         k+JZzW7rFpy/WR28nVFJeYkBJ861ewNrncIHvJ3zu6gcdeEpULju7JQ3VHQrMD00GTnW
         nRunbq1TUfNs5LszfVOm4BFtjOhZCHqcQw2TjiMTgulII0FODc5BZVqvNnMD+/C81MRT
         ewLQ==
X-Gm-Message-State: APjAAAUwLhcn6wjb1bFMuN7Lhn0rNXqZzZAlnnp707Lg6Y94YfyOHtsU
	R9qW6nCHvk/NwaCD4TaZH7iIj6TFWpOOBI8qVD9l/mHP
X-Google-Smtp-Source: APXvYqyd+8rxxjJwXPgJRd0jPcCUyfx+W6Y+lSjoktiQDjrnhtDxLZG9EakMZjeaZ5WjHOCaYY5TPggbrX2H4Cjjc+Y=
X-Received: by 2002:aca:39c1:: with SMTP id g184mr6134186oia.128.1569442630589;
 Wed, 25 Sep 2019 13:17:10 -0700 (PDT)
MIME-Version: 1.0
From: Muni Sekhar <munisekharrms@gmail.com>
Date: Thu, 26 Sep 2019 01:47:00 +0530
Message-ID: <CAHhAz+htpQewAZcpGWD567KLksorc+arA3Mu=hkUX+y6567jGA@mail.gmail.com>
Subject: How to get the crash dump if system hangs?
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi All,

I looked at the available tests with "cat
/sys/kernel/debug/provoke-crash/DIRECT", from this I=E2=80=99d like to know
which test causes system hang? I could not find any test case for
deadlock, is any reason for this?

I=E2=80=99m having a Linux system, I=E2=80=99m seeing it gets hung during c=
ertain
tests. When it hung, it does not even respond for SYSRQ button, only
way to recover is power-button-only.  Does no response for SYSRQ
button means kernel crashed?

After reboot I looked at the kern.log and most of the times it has
=E2=80=9C^@^@^@^ ...=E2=80=9C line just before reboot. Can someone clarify =
me what the
kernel log entry =E2=80=9C^@^@^@^ ...=E2=80=9C means? I suspect kernel is c=
rashed, but
it does give any crashdump in kern.log.

Later I enabled the kernel crash dump(sudo apt install
linux-crashdump) and rerun the test but still nothing copied to the
disk(/var/crash/). I don=E2=80=99t have onboard serial port in my machine, =
so
I tried get the crash dump via netconsole, but this method also does
not able to catch the crash dump.

Can someone help me how to debug in this scenario?

And I'd like to know what other options available to get the crash
dump? Can someone please clarify me on this?

Also , does the crash dump fails if incase deadlock occurs?

Any help will be greatly appreciated.



--=20
Thanks,
Sekhar
