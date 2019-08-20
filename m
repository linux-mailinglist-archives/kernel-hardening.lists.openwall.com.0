Return-Path: <kernel-hardening-return-16796-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 8879096ADF
	for <lists+kernel-hardening@lfdr.de>; Tue, 20 Aug 2019 22:48:32 +0200 (CEST)
Received: (qmail 28022 invoked by uid 550); 20 Aug 2019 20:48:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 27990 invoked from network); 20 Aug 2019 20:48:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:user-agent:mime-version;
        bh=LZBIIXu1/UHqSabMgKF/R4jdVdk9lvPWZfkjIsWMOZU=;
        b=K6cS7dm9Nq68tJjSh7u06oDcM5flkYQwVe8MAZdS0RAQtT18n0hIX19K3Y0cncQP2/
         loY5KI/iz6DHWxL3Zjvm4BxEfz3N44I7vqNWzlh8PIpTwp3e4vErC+4kGcG1mow2ZYkA
         arUJtQkkWWBEMQO0oHFtzrW+5rMUf2bDm9fybDdzb7Lvbp3QqJ6UiK7+51kGVtMcBHTJ
         PzZWmJe9L4tqkCFnhKD4ryjLKV5xPhQVsDX+3OSnl+2Tufmpb3aEF5hmPm/XB4IDvoN/
         KLCqFRMbY27HBF5OkKMxJyaJqNOOQsUZVfpnwhMzpng6muDpQrPzK79PW52rTCsfdy/o
         GSNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:user-agent
         :mime-version;
        bh=LZBIIXu1/UHqSabMgKF/R4jdVdk9lvPWZfkjIsWMOZU=;
        b=K4oP6VhgDRgv3VcPRVnlAUa1DEzIfPQDStULN69O2ic5U2WGZSvBGtcCz5JctH4/HD
         c3GIKrO1XHrJGlJpV9XCbKc0kt6cV5SrZQ8rJY+0AEV3mubxSpwy4aOrFvGEQW/GuXfV
         IifT53ek3BhFvcgmKDo0E8YzcBKGyR3ZeVgGfc3pFO5c6Lt2oWQgacUOM6T98nbjhdR+
         D5ZpOTlMncy86hXRSRrWwX6PhRTRYhIrkaiKStwmE0cLxNLP8ZyDvgcQGjxPrtFkypID
         MIL0gQKaglxnlWqGzTzdrbjntsDJVkccKfvK/A/76N0ddWtkKpzbeJ8uo51uCONxd5j7
         sTng==
X-Gm-Message-State: APjAAAUAnJ7UPmpEZ7lI5ZTp9sP94uuV5lQCUGGaf9RKagvGAahEzyvj
	IErN1as/D8WkOarb3HCZ4MBbu8va
X-Google-Smtp-Source: APXvYqwtfbCYYqZmogZcm1ftDqevgXTjZzlRowzY0rPsJcrMtURIvLv7pMdMEKjYNX0GdGVc/TvJaw==
X-Received: by 2002:a1c:a8c9:: with SMTP id r192mr2000038wme.43.1566334094323;
        Tue, 20 Aug 2019 13:48:14 -0700 (PDT)
From: sahara <kpark3469@gmail.com>
X-Google-Original-From: sahara <lastnite@sahara-mac>
Date: Wed, 21 Aug 2019 00:48:10 +0400 (GST)
To: kernel-hardening@lists.openwall.com
cc: keescook@chromium.org, re.emese@gmail.com, keun-o.park@darkmatter.ae
Subject: Re: [PATCH] latent_entropy: make builtin_frame_address implicit
Message-ID: <alpine.DEB.2.20.1908210040530.31813@sahara-mac>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII

>> --- a/scripts/gcc-plugins/latent_entropy_plugin.c
>> +++ b/scripts/gcc-plugins/latent_entropy_plugin.c
>> @@ -446,6 +446,8 @@ static void init_local_entropy(basic_block bb, tree 
local_entropy)
>>      frame_addr = create_var(ptr_type_node, "local_entropy_frameaddr");
>>
>>      /* 2. local_entropy_frameaddr = __builtin_frame_address() */
>> +    if (!builtin_decl_implicit_p(BUILT_IN_FRAME_ADDRESS))
>> +            set_builtin_decl_implicit_p(BUILT_IN_FRAME_ADDRESS, true);
>
>Interesting! Is this aarch64-specific or something that has changed in
>more recent GCC versions?
>
>Thanks!
>
>-Kees
>

This is Android's aarch64-specific. Tested and reproduced in 8.1.
I haven't seen this problem with Linaro toolchains.

- Sahara

