Return-Path: <kernel-hardening-return-16234-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 2017455881
	for <lists+kernel-hardening@lfdr.de>; Tue, 25 Jun 2019 22:13:43 +0200 (CEST)
Received: (qmail 23612 invoked by uid 550); 25 Jun 2019 20:13:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 23574 invoked from network); 25 Jun 2019 20:13:36 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1561493604;
	bh=zCv6kKhHIg090YMBMNDY2BYklOSjhYrzuCeFFpymNkU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=WedqG7Qsxekzs4sp8b57+T7xTTB/2C7mb5BKmZUeYEwEb1LmnDg1dMRmkgJr8vxNi
	 iimzKMWaqrUGb0wQS9y1ch/IscRKU9NH2UEJKkOEFcX5U13+O1PE52RexeOhJcEqnC
	 Ly88kyfygoWe9nWUlzqqdNB2Dzp+cRRqlTQXo2sw=
X-Gm-Message-State: APjAAAWaCxCXvjx+3jYFahVVQvg9yYRGWkQG3dgBOXdeDaMd6kPbov+G
	sPXTW83m2Y05jHnYJ0ygOH00DU/YFZLRzWvbOvwKbw==
X-Google-Smtp-Source: APXvYqy+ySl3tS5sUHDWeT6Qzv2P/gAyMriecApQgJWQ0hQyxmac0CpzqMhTDRwVxeQc7qdaMOUkRMBb9g0oFV4s5Dc=
X-Received: by 2002:adf:a443:: with SMTP id e3mr2454wra.221.1561493603008;
 Tue, 25 Jun 2019 13:13:23 -0700 (PDT)
MIME-Version: 1.0
References: <87v9wty9v4.fsf@oldenburg2.str.redhat.com> <201906251131.419D8ACB@keescook>
In-Reply-To: <201906251131.419D8ACB@keescook>
From: Andy Lutomirski <luto@kernel.org>
Date: Tue, 25 Jun 2019 13:13:11 -0700
X-Gmail-Original-Message-ID: <CALCETrWg+vZWAdY-6etLnh=wyB1aXdG9s8ASUXX=cjjFm7CKZQ@mail.gmail.com>
Message-ID: <CALCETrWg+vZWAdY-6etLnh=wyB1aXdG9s8ASUXX=cjjFm7CKZQ@mail.gmail.com>
Subject: Re: Detecting the availability of VSYSCALL
To: Kees Cook <keescook@chromium.org>
Cc: Florian Weimer <fweimer@redhat.com>, Linux API <linux-api@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-x86_64@vger.kernel.org, 
	linux-arch <linux-arch@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, 
	"Carlos O'Donell" <carlos@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Jun 25, 2019 at 1:08 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Tue, Jun 25, 2019 at 05:15:27PM +0200, Florian Weimer wrote:
> > Should we try mapping something at the magic address (without MAP_FIXED)
> > and see if we get back a different address?  Something in the auxiliary
> > vector would work for us, too, but nothing seems to exists there
> > unfortunately.
>
> It seems like mmap() won't even work because it's in the high memory
> area. I can't map something a page under the vsyscall page either, so I
> can't distinguish it with mmap, mprotect, madvise, or msync. :(
>

I keep contemplating making munmap() work on it.  That would nicely
answer the question: if munmap() fails, it's not there, and, if
munmap() succeeds, it's not there :)
