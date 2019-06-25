Return-Path: <kernel-hardening-return-16249-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 3167C55BEA
	for <lists+kernel-hardening@lfdr.de>; Wed, 26 Jun 2019 01:03:34 +0200 (CEST)
Received: (qmail 12237 invoked by uid 550); 25 Jun 2019 23:03:20 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 12204 invoked from network); 25 Jun 2019 23:03:19 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vCqj6Gl5Q+n6lzWdb5L2oHqmQfEmkpa5M5PzJg/vAX0=;
        b=Xb+hHpzdadY3+SZLz7lziYzk74KcI7TJz4DoosGtrKHDRZWbmvbRnU0CnFGMpbcfuF
         Pk8kgfMcbnxZL00uBqYQOwGOH9t5TcnZt6TJlMwfK2h4iErKeRRXNLG8Z4F7C8ydio1j
         1HlMw7Gv2XjLypWKJS+g0r87+zG+TkbGD5M+MCKwEw9yRo0GLdGXm6Lfzpcu+k9UE9d0
         F/M1TF1+T/R8J7RiHvYkadgyTfoCuki9o2u4q3pGOwFIW5+XofAOHXF5gW7KhBQtx+kT
         A/0C/2uSQzf7ymawbvg8ME7Vop7uFjg1N3hzdSaT8Xbqmd1KmjrxGBiqWXqzyhqm7B5L
         Mkkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vCqj6Gl5Q+n6lzWdb5L2oHqmQfEmkpa5M5PzJg/vAX0=;
        b=sqWiYDDysL3PfzIh3RgjI96GMXTxS2/CNzNIjBxYjH2Th0dwNqgA6UUroB63jv10oa
         aV0yr0Q24L9Mr0IyzI8ZWti7zD6zqVOsXHd6vQE8LhWiWfsZRGUsycml+TBiAOcN40Xz
         Kgu/eShgGXzt5Pm3/IkbclOV36KUzUh7lLTgK5fEtZM1+Wnbdf8zpX319YvUwGqidXYY
         P5sluAhewkvXkzzT9k0D+OlhoUcdyXnPc0GM1bIXq3ddSJxHecTeyiK4FnOXjVXLPOTc
         hocibJ3J8iiGfARHT2cgyKRkqAHnsGtBnVW2SaM/rSwXtGHq2cY0FxIZ0mVy4jWiJZQz
         UOXg==
X-Gm-Message-State: APjAAAV4C8bws0ZhlA+2t3FrEIXY9u6fp1yNbFFbTZAzncID31TL0EhP
	omxM3K0X7lWrkuRuVvPgOgf/yscAEAriFrOnnQs=
X-Google-Smtp-Source: APXvYqwMki2vRi0D6xb9XX2ObQWdMs2vNpF7/ZvfvRpFFo74l4CVr0RYcBMIdgXXJPnYTSSDRLHNjCE2a1Zni1qeP0M=
X-Received: by 2002:a19:6e4d:: with SMTP id q13mr691917lfk.6.1561503788417;
 Tue, 25 Jun 2019 16:03:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190625215239.11136-1-mic@digikod.net> <20190625215239.11136-3-mic@digikod.net>
In-Reply-To: <20190625215239.11136-3-mic@digikod.net>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Tue, 25 Jun 2019 16:02:57 -0700
Message-ID: <CAADnVQ+Twio22VSi21RR5TY1Zm-1xRTGmREcXLSs5Jv-KWGTiw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v9 02/10] bpf: Add eBPF program subtype and
 is_valid_subtype() verifier
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Aleksa Sarai <cyphar@cyphar.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, 
	Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, 
	"David S . Miller" <davem@davemloft.net>, "Eric W . Biederman" <ebiederm@xmission.com>, 
	James Morris <jmorris@namei.org>, Jann Horn <jann@thejh.net>, 
	John Johansen <john.johansen@canonical.com>, Jonathan Corbet <corbet@lwn.net>, 
	Kees Cook <keescook@chromium.org>, Michael Kerrisk <mtk.manpages@gmail.com>, 
	=?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mickael.salaun@ssi.gouv.fr>, 
	Paul Moore <paul@paul-moore.com>, Sargun Dhillon <sargun@sargun.me>, 
	"Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, Stephen Smalley <sds@tycho.nsa.gov>, 
	Tejun Heo <tj@kernel.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, 
	Thomas Graf <tgraf@suug.ch>, Tycho Andersen <tycho@tycho.ws>, Will Drewry <wad@chromium.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, 
	Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, 
	LSM List <linux-security-module@vger.kernel.org>, 
	Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 25, 2019 at 3:04 PM Micka=C3=ABl Sala=C3=BCn <mic@digikod.net> =
wrote:
>
> The goal of the program subtype is to be able to have different static
> fine-grained verifications for a unique program type.
>
> The struct bpf_verifier_ops gets a new optional function:
> is_valid_subtype(). This new verifier is called at the beginning of the
> eBPF program verification to check if the (optional) program subtype is
> valid.
>
> The new helper bpf_load_program_xattr() enables to verify a program with
> subtypes.
>
> For now, only Landlock eBPF programs are using a program subtype (see
> next commits) but this could be used by other program types in the
> future.
>
> Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: David S. Miller <davem@davemloft.net>
> Link: https://lkml.kernel.org/r/20160827205559.GA43880@ast-mbp.thefaceboo=
k.com
> ---
>
> Changes since v8:
> * use bpf_load_program_xattr() instead of bpf_load_program() and add
>   bpf_verify_program_xattr() to deal with subtypes
> * remove put_extra() since there is no more "previous" field (for now)
>
> Changes since v7:
> * rename LANDLOCK_SUBTYPE_* to LANDLOCK_*
> * move subtype in bpf_prog_aux and use only one bit for has_subtype
>   (suggested by Alexei Starovoitov)

sorry to say, but I don't think the landlock will ever land,
since posting huge patches once a year is missing a lot of development
that is happening during that time.
This 2/10 patch is an example.
subtype concept was useful 2 years ago when v6 was posted.
Since then bpf developers faced very similar problem in other parts
and it was solved with 'expected_attach_type' field.
See commit 5e43f899b03a ("bpf: Check attach type at prog load time")
dated March 2018.
