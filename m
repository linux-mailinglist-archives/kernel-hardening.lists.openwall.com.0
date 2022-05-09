Return-Path: <kernel-hardening-return-21560-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 95ADB52067E
	for <lists+kernel-hardening@lfdr.de>; Mon,  9 May 2022 23:10:49 +0200 (CEST)
Received: (qmail 21638 invoked by uid 550); 9 May 2022 21:10:23 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 16130 invoked from network); 9 May 2022 20:59:02 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:in-reply-to:references:from:user-agent:date:message-id
         :subject:to:cc;
        bh=yJKJ2ATgX9mu3/IffO/J0EaKq/jvo17mocUEhwCAE60=;
        b=XSieEDeLW/rwABKUVPDCvXH0w6sECAEnkGHzfrpHucsx1SHRgM/dcBpPOgHjWjsqCb
         leo0ETy5XMaX5kEfyv+oImCvgn/Nr2Cc8dOl33/gdLVYmaNnfeGnl1hjnE945VnzLQv+
         BbtHxr0VqtYXncjJAAbHq+uy1Wp20P5IVOeeI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:in-reply-to:references:from
         :user-agent:date:message-id:subject:to:cc;
        bh=yJKJ2ATgX9mu3/IffO/J0EaKq/jvo17mocUEhwCAE60=;
        b=sCHX7k9YYbB930gn+3Lr7FetZQVj2N6x+Aow6xw4LAIYdKeMbOH6QCx9ZKBwmHu1s+
         mtR7fOEunEZ61XzTVhVsmzce2bgZMxpMuvQ8xuMJiu58am9tPzuvNRpaP7PcTnIF9JTK
         dIVBlM2ochybY022XXwRfqpVU4wPhQv20swryQAw/bEz8l0jPRjPXlqHBi0eild1nipd
         0kR3aKEbk37bx2Bh6Sxdl0o9BZvJM6JmoUh2ZC7cg5nprc5h44Sd8GOF9NxVFnTYZM71
         e5Gv8VVY6541CTSdV6f5E8syhZlrKQMclsCHQWNPDTDH0tOGSif8z7Coql5+a0FrZEgh
         QXmQ==
X-Gm-Message-State: AOAM533tDtvnhZKWlJ9uYWp3tAv3WIGGgv9lrzSq90zpblbvQJ19qUf5
	7ttiPvvm/juE0N/M+ckyOLRv9kBrJGXQhpLtcT1b5Q==
X-Google-Smtp-Source: ABdhPJwgrl6Fn8gygCe1A38ovT3ghIsMz7Z+cffAmaDb1TNKssJHWbHAPz8jQeXiKh9qKc+zQcnEutlFHA7Nq+3CFlQ=
X-Received: by 2002:a4a:6b49:0:b0:329:99cd:4fb8 with SMTP id
 h9-20020a4a6b49000000b0032999cd4fb8mr6472783oof.25.1652129930567; Mon, 09 May
 2022 13:58:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8e472c9e-2076-bc25-5912-8433adf7b579@arbitrary.ch>
References: <8e472c9e-2076-bc25-5912-8433adf7b579@arbitrary.ch>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Mon, 9 May 2022 16:58:49 -0400
Message-ID: <CAE-0n53Ou1qgueFZ7zL-rFwsit6XJnYZkRtggdx3XXvL7HWrow@mail.gmail.com>
Subject: Re: [PATCH] Decouple slub_debug= from no_hash_pointers again
To: Peter Gerber <peter@arbitrary.ch>, kernel-hardening@lists.openwall.com, 
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, 
	Joonsoo Kim <iamjoonsoo.kim@lge.com>, Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org, 
	Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"

Quoting Peter Gerber (2022-05-08 07:56:29)
> While, as mentioned in 792702911f58, no_hash_pointers is what
> one wants for debugging, this option is also used for hardening.
>
> Various places recommend or use slub_debug for hardening:
>
> a) The Kernel Self Protection Project lists slub_debug as
>    a recommended setting. [1]
> b) Debian offers package hardening-runtime [2] which enables
>    slub_debug for hardening.
> c) Security- and privacy-oriented Tails enables slub_debug
>    by default [3].
>
> I understand that encountering hashed pointers during debugging
> is most unwanted. Thus, I updated the documentation to make
> it as clear as possible that no_hash_pointers is what one
> wants when using slub_debug for debugging. I also added a
> mentioned of the hardening use case in order to discourage
> any other, well-meant, tries to disable hashing with slub_debug.

Why not add a CONFIG_HARDENED_SLUB option that enables poisoning and
also makes slub debugging not print any messages to the kernel log
containing object internal details? Then it can be enabled in the kernel
config to harden slub and if the flag is enabled we don't hash pointers
based on 'slub_debug' existing on the commandline? And maybe add some
commandline argument like 'slub_debug=H' for "hardened" so it can be
turned off as well if it is built into the config.
