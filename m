Return-Path: <kernel-hardening-return-20258-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 3F667297623
	for <lists+kernel-hardening@lfdr.de>; Fri, 23 Oct 2020 19:53:19 +0200 (CEST)
Received: (qmail 14050 invoked by uid 550); 23 Oct 2020 17:53:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 14007 invoked from network); 23 Oct 2020 17:53:12 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VtAgTEHRkAGqz+I14jNPk509SDkqha7SHbM3mBCCgZY=;
        b=bD+nsvaIX4zp29UYZ+2JOdkUFkScGE8zl+rcJpNB4AsWeJe0EJpHRYpGF9ckMXyEAE
         eY6nY+lL78x+HZe3dqUl0NiWH3V7J8yP9nwnBEh+ssJ6yWJ4KLH8KjbXfyTlckN25RX7
         VkolVVpARdJ1j3kH8s9VUT9CY4qpphaYqthbfNQ+WP3Ff4aSw3LUoU5qWGc7iUFJ4n7y
         m1vAyhI1jWbcMfYcHDitC0D/AAPkG/igpqDpwO4crbtgU3PRhg2xswA6w78CDzh0jrBy
         /flM8gaJ2HK0VxqkgAi4O0EsED4eLdGMthqGWhfNnXJsLLDe2P8RUXvO4B5ieoJOO2Y+
         XtuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VtAgTEHRkAGqz+I14jNPk509SDkqha7SHbM3mBCCgZY=;
        b=J6+6yzUshdvA9/erpCckv3JMWmpkUtE5WFukN5Uz9kIzTOU3YR81rgDl2bX/0l3aUx
         cr2C2bC55uo18dWHqZntgYsyB3El7VBhoENMKNHXSTyrubVr9NRWvWbmYH6fq3h2JT/g
         KCNxnAkaSOqj7QBvR1akPXOzGxXdJ/Lx5RGrF4kYGbtzpH8zS6kn4eTfAOgSF/ZE2TTD
         PhdX2gINjXS6yxdSDKpGOd09e7NJD9ouOWhdNGYcd6VGKjwBdWNSGWWfAL/p+DSLyJDa
         xqpJlEBJhWvo0rIoD2p3R+ipZypoI6LF0eP5T8Yyangpp6Djg37FObQ/dqEDj5SkHWH/
         k0hg==
X-Gm-Message-State: AOAM5323PzDw7pyJ3/wSuZzsKXiKb40vEx91YCtaDznOf9fpsG2mwpeN
	iQnrhii8Lq5HLioxVvLreKTSnsOms8ai4hIwAuo=
X-Google-Smtp-Source: ABdhPJy2EtC+Jp6f2du99WT/FJet4nqfOd4rMxYcV8yqiQVUKzPy9q5NN3+QK+mO/scRsa8G2nVIF4q9Fo9IJWlasYo=
X-Received: by 2002:a92:ba14:: with SMTP id o20mr2650068ili.76.1603475580876;
 Fri, 23 Oct 2020 10:53:00 -0700 (PDT)
MIME-Version: 1.0
References: <8584c14f-5c28-9d70-c054-7c78127d84ea@arm.com> <20201022075447.GO3819@arm.com>
 <78464155-f459-773f-d0ee-c5bdbeb39e5d@gmail.com> <202010221256.A4F95FD11@keescook>
 <180cd894-d42d-2bdb-093c-b5360b0ecb1e@gmail.com>
In-Reply-To: <180cd894-d42d-2bdb-093c-b5360b0ecb1e@gmail.com>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Fri, 23 Oct 2020 18:52:50 +0100
Message-ID: <CAJHCu1Jrtx=OVEiTVwPJg7CxRkV83tS=HsYeLoAGRf_tgYq_iQ@mail.gmail.com>
Subject: Re: BTI interaction between seccomp filters in systemd and glibc
 mprotect calls, causing service failures
To: Topi Miettinen <toiwoton@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, 
	Jeremy Linton <jeremy.linton@arm.com>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, libc-alpha@sourceware.org, 
	systemd-devel@lists.freedesktop.org, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Mark Brown <broonie@kernel.org>, Dave Martin <dave.martin@arm.com>, 
	Catalin Marinas <Catalin.Marinas@arm.com>, Will Deacon <will.deacon@arm.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

On Thu, 22 Oct 2020 at 23:24, Topi Miettinen <toiwoton@gmail.com> wrote:
> SARA looks interesting. What is missing is a prctl() to enable all W^X
> protections irrevocably for the current process, then systemd could
> enable it for services with MemoryDenyWriteExecute=yes.

SARA actually has a procattr[0] interface to do just that.
There is also a library[1] to help using it.

> I didn't also see specific measures against memfd_create() or file
> system W&X, but perhaps those can be added later.

You are right, there are no measures against those vectors.
It would be interesting to add them, though.

> Maybe pkey_mprotect()
> is not handled either unless it uses the same LSM hook as mprotect().

IIRC mprotect is implemented more or less as a pkey_mprotect with -1 as pkey.
The same LSM hook should cover both.

Salvatore

[0] https://lore.kernel.org/lkml/1562410493-8661-10-git-send-email-s.mesoraca16@gmail.com/
[1] https://github.com/smeso/libsara
