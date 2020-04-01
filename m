Return-Path: <kernel-hardening-return-18351-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 3129419A654
	for <lists+kernel-hardening@lfdr.de>; Wed,  1 Apr 2020 09:35:42 +0200 (CEST)
Received: (qmail 28044 invoked by uid 550); 1 Apr 2020 07:35:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 3548 invoked from network); 1 Apr 2020 00:03:30 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RmTvz/L6YmOrh3p07+F8l4GXjEVQNak2kA1fSgQ4Mjo=;
        b=aIxiKBCsylb6yX3xKI+LsQsqD0w6HyUuOtycBCSZkXBMPqOnHc2TtCNpmmKNjSX4jz
         E6TkCysPrh15L662DEQtnYOMpbMzgrTHXK5wlH1ZxSK49B0DvmybzIoSoUVjJ54XGjVF
         Hrc0IC9VXLt5tbsUM8us6woO1kz1OpIhbRAbP2KvBxV6+vX0k2ozWBnhNbWvXR7/LKi5
         +Y657UvUeShXYWfIsXFmeCc+OvGOrcRJrxnUCjrCRGiwdY6qwkrtOoIq+8UEDgFkGeli
         xtrnkBU+0ImdgeOiXjy+I3Utt/iM9GAvVf/qRtf7hFA66IKrs8PioREy9drD+gIIklg8
         KU6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RmTvz/L6YmOrh3p07+F8l4GXjEVQNak2kA1fSgQ4Mjo=;
        b=KctTDFhGKduld2+28jGBMKjKvZDk75GFsCt26FzDvaB9+a3ZWGwNvSFhEbUJ0eSNMe
         vpoI4VEgdxRchGgcNfUdyWGYFRhI0rq9I2I6FEFPQuvJDZZSeAq26468XxLE1wLgOAmR
         tv7m9P+4TSpDKNo8g+GTNhPvhH9W6pj4oFqHAUpmuqm7dovqKgLECXJJEVd5MklsR7YI
         nTfoRyw/PVy3vr0R4ADbO5nwnD5u/cLgt4OZt2Ol3IyjB9pgj/m7eykxKSkgTcT+LflO
         1ymiLkVGRKOCr+kisWm6I2b5CVEGWcgTI/W6RwDu6X6/Mu4P/dpZS5elyq640OsMF2gC
         wt3A==
X-Gm-Message-State: ANhLgQ1WQr2QV1lyGaOJHeXeMoaZK8aylR4XKA70i8tQ4RrjNTmGrqzB
	C0MGVCYbrF3NL8XeCBoq3qfhz3GCBz0LDBkD4KY=
X-Google-Smtp-Source: ADFU+vu6cimqTEAdtf39u8/T8WKKgNSMwihn5EK0r1F+dpBI+yAtS8ffjb/s/DQe8an3NADwSJckknxiktPrBP5Bf4E=
X-Received: by 2002:a0c:bc15:: with SMTP id j21mr18213275qvg.228.1585699398382;
 Tue, 31 Mar 2020 17:03:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200331215536.34162-1-slava@bacher09.org>
In-Reply-To: <20200331215536.34162-1-slava@bacher09.org>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Tue, 31 Mar 2020 17:03:07 -0700
Message-ID: <CAEf4BzZXtCPhhntbgrqL0z9aX4yrNUXfFZPk+qb_5-+Nx6PRzw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf] kbuild: fix dependencies for DEBUG_INFO_BTF
To: Slava Bacherikov <slava@bacher09.org>
Cc: Andrii Nakryiko <andriin@fb.com>, Kees Cook <keescook@chromium.org>, bpf <bpf@vger.kernel.org>, 
	open list <linux-kernel@vger.kernel.org>, Jann Horn <jannh@google.com>, 
	Alexei Starovoitov <alexei.starovoitov@gmail.com>, Daniel Borkmann <daniel@iogearbox.net>, 
	kernel-hardening@lists.openwall.com, Liu Yiding <liuyd.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Mar 31, 2020 at 2:57 PM Slava Bacherikov <slava@bacher09.org> wrote:
>
> Currently turning on DEBUG_INFO_SPLIT when DEBUG_INFO_BTF is also
> enabled will produce invalid btf file, since gen_btf function in
> link-vmlinux.sh script doesn't handle *.dwo files.
>
> Enabling DEBUG_INFO_REDUCED will also produce invalid btf file, and
> using GCC_PLUGIN_RANDSTRUCT with BTF makes no sense.
>
> Signed-off-by: Slava Bacherikov <slava@bacher09.org>
> Reported-by: Jann Horn <jannh@google.com>
> Reported-by: Liu Yiding <liuyd.fnst@cn.fujitsu.com>
> Fixes: e83b9f55448a ("kbuild: add ability to generate BTF type info for vmlinux")
> ---

LGTM, but let's wait on Kees about COMPILE_TEST dependency...

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  lib/Kconfig.debug | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index f61d834e02fe..9ae288e2a6c0 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -223,6 +223,7 @@ config DEBUG_INFO_DWARF4
>  config DEBUG_INFO_BTF
>         bool "Generate BTF typeinfo"
>         depends on DEBUG_INFO
> +       depends on !DEBUG_INFO_SPLIT && !DEBUG_INFO_REDUCED && !GCC_PLUGIN_RANDSTRUCT
>         help
>           Generate deduplicated BTF type information from DWARF debug info.
>           Turning this on expects presence of pahole tool, which will convert
> --
> 2.24.1
>
