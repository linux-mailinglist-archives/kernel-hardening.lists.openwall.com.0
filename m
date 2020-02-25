Return-Path: <kernel-hardening-return-17920-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 7F49E16EE1A
	for <lists+kernel-hardening@lfdr.de>; Tue, 25 Feb 2020 19:36:15 +0100 (CET)
Received: (qmail 30571 invoked by uid 550); 25 Feb 2020 18:36:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 30533 invoked from network); 25 Feb 2020 18:36:09 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/Oq7ZlHByEKisw958sDxdjAX7fiFkXlFc5ymByAOxAI=;
        b=DS824e58go8okeMKOqEHEbHc21x7FkHA0PkE7JjUV/ffMD1jaGlRVRKQiy5G78ZSYi
         w1g8VqpgDd0aOt7TLWrv9NKqWgKZYpnTPxeD6k9lHXhVVPmM22eWvb8eWDmVot6ePvL1
         8WChB0KvbivUsKRrpzgsb+e+Tym3KoTwLEdn4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/Oq7ZlHByEKisw958sDxdjAX7fiFkXlFc5ymByAOxAI=;
        b=sWaeHfPW8FqdO5ccMoZka3gW/pPpBSRE/gC+JMNp4q6yF2FLiBZJPxMuzb7PHkv8N+
         X43iJYmj16TwwMYOpElVAMZa+fjHv9ryxDdN+nnX6f63YcHU21FS07lbKGPN9LPFmd7R
         RFiVpQhkVGj0poxOntHt+6W6OS62NH8qgByB/+HZmzN+y37EcNG751NMHRgOgOTD/W7w
         4QUmaAGiRwo9H2oboJBZPi7KdpJ8VjPO1CZs2Cr4LOmbyn1Jq2mzXM3pK/h8N3WrH475
         Vcp5SfNqh3LwgSyqrX6WBAAp22Q2P1LmdADLpTDrAbykgy0yOYffUNlAL/OzPt1WBJpa
         RYxw==
X-Gm-Message-State: APjAAAV5iF1XUNE0RLK3TE6KTY5zy7jNrHB0EBJLf1klC/cnBezxqo1j
	HcdTOqrmbdt1i6s7/3wnC2pADeN6jd8=
X-Google-Smtp-Source: APXvYqyPmhYJr4gUqySGuqxkFqZHzAJ4hcxUjGcAw4ErEw4uaojqet99DnUp7LnumFp67PKFXpJf/w==
X-Received: by 2002:a17:90a:7187:: with SMTP id i7mr379790pjk.6.1582655757813;
        Tue, 25 Feb 2020 10:35:57 -0800 (PST)
Date: Tue, 25 Feb 2020 10:35:56 -0800
From: Kees Cook <keescook@chromium.org>
To: Daniel Micay <danielmicay@gmail.com>
Cc: Daniel Axtens <dja@axtens.net>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Linux-MM <linux-mm@kvack.org>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 5/5] [RFC] mm: annotate memory allocation functions with
 their sizes
Message-ID: <202002251035.AD29F84@keescook>
References: <20200120074344.504-1-dja@axtens.net>
 <20200120074344.504-6-dja@axtens.net>
 <CA+DvKQJ6jRHZeZteqY7q-9sU8v3xacSPj65uac3PQfst4cKiMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+DvKQJ6jRHZeZteqY7q-9sU8v3xacSPj65uac3PQfst4cKiMA@mail.gmail.com>

On Fri, Feb 07, 2020 at 03:38:22PM -0500, Daniel Micay wrote:
> There are some uses of ksize in the kernel making use of the real
> usable size of memory allocations rather than only the requested
> amount. It's incorrect when mixed with alloc_size markers, since if a
> number like 14 is passed that's used as the upper bound, rather than a
> rounded size like 16 returned by ksize. It's unlikely to trigger any
> issues with only CONFIG_FORTIFY_SOURCE, but it becomes more likely
> with -fsanitize=object-size or other library-based usage of
> __builtin_object_size.

I think the solution here is to use a macro that does the per-bucket
rounding and applies them to the attributes. Keep the bucket size lists
in sync will likely need some BUILD_BUG_ON()s or similar.

-- 
Kees Cook
