Return-Path: <kernel-hardening-return-16074-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id D074E39B08
	for <lists+kernel-hardening@lfdr.de>; Sat,  8 Jun 2019 06:32:22 +0200 (CEST)
Received: (qmail 11997 invoked by uid 550); 8 Jun 2019 04:32:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 11964 invoked from network); 8 Jun 2019 04:32:14 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yjh1zYzaoG1at1rH8FiT6vjLog0lbXyR57eX3mI8RWU=;
        b=caKHMyw7CKhNBoh8+uD8iWldTaFNU7mgpUoQcT5cZWa57bvFXUypbqC9UuZA+o/1Th
         HrAQxMHVqSIe84G97GnjpXRWVOQgsVZNdOja08NiXb27xJYrnjs/TVXYK71ZV06RzRta
         FUh5UsLnrE3Yll2X0tVnoig0ej/Dg0hboiq3I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yjh1zYzaoG1at1rH8FiT6vjLog0lbXyR57eX3mI8RWU=;
        b=kjsN80PYopEUiV1eAtFx8h4zm5SzGMcQ7No6x+Fp3DkL9LqIejfZ/WUiWq3PjAHH3H
         BxkU2yNxFZFtLf4c/JIeUTW0eJ5gLDMjYlR2K+OF+t95Z92CgQ2Yg3Qh7OBDTh240uwZ
         B6eguTwiR/cRASwXop4Y6sHV2tVw6QeNAxuX0XZvdNNxQP60kdHkgDgW023+Inpvsmgs
         YIqMyp9WwAvdQNH0GjAnUbMH8V+FoK00mAxf3+vY7fnfgQM6eU+D/bcTqPLBl+5JAbEm
         Ye9G2/YXFQoHoTB3tZAT9CApTDIoXw66t7wVX3Vpy+xp5AL4o0ZLv03hT0kGm4fO4IqA
         o3qw==
X-Gm-Message-State: APjAAAUyfp0yii6W9zR9hUhB/t3abjOKSkedltY+kz4m7Q1OOBAU/p4v
	rMRX2w/mENpgIoVg/mUnm/Zdog==
X-Google-Smtp-Source: APXvYqzKf+YgeQAHUTRfi7wKWBZYUr8JctGMzGm1jKwC1I9aMfwRbYFBvrA3T+gvDBsHqT3A4qaCZQ==
X-Received: by 2002:a17:902:8ec7:: with SMTP id x7mr18234973plo.50.1559968322409;
        Fri, 07 Jun 2019 21:32:02 -0700 (PDT)
Date: Fri, 7 Jun 2019 21:32:00 -0700
From: Kees Cook <keescook@chromium.org>
To: Romain Perier <romain.perier@gmail.com>
Cc: Shyam Saini <mayhs11saini@gmail.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: Get involved
Message-ID: <201906072117.A1C045C@keescook>
References: <CABgxDo+x3r=8HFxyM89HAc_FdY6+kBpJR5RpAgpOYsu0xZtshQ@mail.gmail.com>
 <CABgxDoJ-ue6HKyBR_q8cmbOp8DFnZDVf7zbxv8_wmHh7uis_vw@mail.gmail.com>
 <CAOfkYf4OxG-vkCOoWvmGxyRg3UVFcGszkdStKSoXf5qqyF_RQA@mail.gmail.com>
 <CABgxDoLe3fXNLob3pnj7Nn2v54Htqr+cg5gRRQPxFK7HPX85=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABgxDoLe3fXNLob3pnj7Nn2v54Htqr+cg5gRRQPxFK7HPX85=Q@mail.gmail.com>

On Fri, Jun 07, 2019 at 08:16:42PM +0200, Romain Perier wrote:
> Hi,

Hi! Sorry for the late reply: I've been travelling this week. :P

> Okay, np. I will select another one then :) (hehe that's the game ;) )
> 
> @Kees: do you have something in mind (as a new task) ?

Shyam, you'd also started FIELD_SIZEOF refactoring, but never sent a v2
patch if I was following correctly? Is there one or the other of these
tasks you'd like help with?  https://patchwork.kernel.org/patch/10900187/

Romain, what do you think about reviewing NLA code? I'd mentioned a
third task here:
https://www.openwall.com/lists/kernel-hardening/2019/04/17/8

Quoting...


- audit and fix all misuse of NLA_STRING

This is a following up on noticing the misuse of NLA_STRING (no NUL
terminator), getting used with regular string functions (that expect a
NUL termination):
https://lore.kernel.org/lkml/1519329289.2637.12.camel@sipsolutions.net/T/#u

It'd be nice if someone could inspect all the NLA_STRING
representations and find if there are any other problems like this
(and see if there was a good way to systemically fix the problem).



For yet another idea would be to get syzkaller[1] set up and enable
integer overflow detection (by adding "-fsanitize=signed-integer-overflow"
to KBUILD_CFLAGS) and start finding and fixes cases like this[2].

Thanks and let me know what you think!

-Kees

[1] https://github.com/google/syzkaller/blob/master/docs/linux/setup.md
[2] https://lore.kernel.org/lkml/20180824215439.GA46785@beast/


-- 
Kees Cook
