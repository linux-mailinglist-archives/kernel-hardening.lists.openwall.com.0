Return-Path: <kernel-hardening-return-19713-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 099372573BC
	for <lists+kernel-hardening@lfdr.de>; Mon, 31 Aug 2020 08:33:54 +0200 (CEST)
Received: (qmail 19805 invoked by uid 550); 31 Aug 2020 06:33:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 31839 invoked from network); 31 Aug 2020 05:45:39 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=QpctQpS39czKh39FA3DsibwWwLFrQ9w8q7Ndiy8iuZ4=;
        b=SthwgJj9Az/3r32xLQsxuUe6T0MewJhKyV/Hco3TxmWIHJj4DepBs8La5TxnUWFCCG
         YDn3y6jKbzNdsEUab+UBYdjdvbPZomqG13t6p8nzlelUtTXVQS1uaGXb80OBXi+4Au46
         1L99scYJ1+LtDsC0z9eqriy6BlmgGSmz/z5KSiSQjMTS1UULHACE/5DaJ3g3oP9V0tn+
         C3kyRGQK3bTbPAdNgXOpiaUidK5MERG8Tl2BHWeof41BecEt9Tnk+4OqBnN8F5QmevL6
         pOXpVep53mhoYUJxxhX6fNo279JakvMOSGWcnagCYOiR+6vNOpVVBtpi5yRoxBjyL1K6
         bkNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=QpctQpS39czKh39FA3DsibwWwLFrQ9w8q7Ndiy8iuZ4=;
        b=Z+2rWSgZ7U8QcW7niixHanIBsm2ywLNYtRzPrJgHK6q+Eq3G/DRT4oUFc3CUq2BhkQ
         2pzZsSkPW6lM5amthxGOyxQS9YF81EEwB6/hdPtQuRuhggSmRuqjXTHk+eeOhOJKx+fa
         kTO6mRr2ac2I9O23joXYkkmb0I4w2sFapLZ7pqZtUN+UBb6iYWVwv6JlW1VH6uC+E3xY
         keLAMlgoghoyvTXR9iTR7L0ScpfftPHTEnxTacFyVIQ3NSsoeRxkbF4kaIzC9qail/JD
         DOc8nIWfMNrt1UvG0MCtO64u+DZaNKE+/9WpU1a+eKf7Qwu+W8lnUttd72SLvCwbNOtO
         K/QA==
X-Gm-Message-State: AOAM533JB3SRJAv5xdEh5zso92iq68xuGukKhjV1nLvaa7htFpAy43l4
	xOXlFlva3ged4uxsLN0wvC4=
X-Google-Smtp-Source: ABdhPJww5C52aNdNrjE6lwcruAeSoi0YPmIcXls0hV/emdb9wLo+Twlo+eLLVBqIT1XjQOuheM96mQ==
X-Received: by 2002:a17:907:270d:: with SMTP id w13mr10151624ejk.191.1598852727702;
        Sun, 30 Aug 2020 22:45:27 -0700 (PDT)
From: Lukas Bulwahn <lukas.bulwahn@gmail.com>
X-Google-Original-From: Lukas Bulwahn <lukas@gmail.com>
Date: Mon, 31 Aug 2020 07:45:25 +0200 (CEST)
X-X-Sender: lukas@felia
To: Andrew Morton <akpm@linux-foundation.org>, keescook@chromium.org
cc: Mrinal Pandey <mrinalmni@gmail.com>, skhan@linuxfoundation.org, 
    Linux-kernel-mentees@lists.linuxfoundation.org, lukas.bulwahn@gmail.com, 
    re.emese@gmail.com, maennich@google.com, tglx@linutronix.de, 
    gregkh@linuxfoundation.org, kernel-hardening@lists.openwall.com, 
    linux-kernel@vger.kernel.org, linux-spdx@vger.kernel.org
Subject: Re: [PATCH] scripts: Add intended executable mode and SPDX license
In-Reply-To: <20200830174409.c24c3f67addcce0cea9a9d4c@linux-foundation.org>
Message-ID: <alpine.DEB.2.21.2008310714560.8556@felia>
References: <20200827092405.b6hymjxufn2nvgml@mrinalpandey> <20200830174409.c24c3f67addcce0cea9a9d4c@linux-foundation.org>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII



On Sun, 30 Aug 2020, Andrew Morton wrote:

> On Thu, 27 Aug 2020 14:54:05 +0530 Mrinal Pandey <mrinalmni@gmail.com> wrote:
> 
> > commit b72231eb7084 ("scripts: add spdxcheck.py self test") added the file
> > spdxcheck-test.sh to the repository without the executable flag and license
> > information.
> 
> The x bit shouldn't matter.
> 
> If someone downloads and applies patch-5.9.xz (which is a supported way
> of obtaining a kernel) then patch(1) will erase the x bit anyway.
>

Andrew, Kees,

thanks for the feedback.

As his mentor, I see two valuable tasks for Mrinal to work on:

1. Document this knowledge how scripts should be called, not relying on 
the executable bit, probably best somewhere here:
./Documentation/kbuild/makefiles.rst, a new section on using dedicated 
scripts in chapter 3 ("The  kbuild files").

https://www.kernel.org/doc/html/latest/kbuild/makefiles.html#the-kbuild-files

2. Determine if there are places in the build Makefiles that do rely on 
the executable bit and fix those script invocations. (Kees' idea of remove 
all executable bits and see...)


Lukas
