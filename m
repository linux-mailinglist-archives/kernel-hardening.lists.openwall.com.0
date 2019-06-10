Return-Path: <kernel-hardening-return-16079-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 397863BBB8
	for <lists+kernel-hardening@lfdr.de>; Mon, 10 Jun 2019 20:21:03 +0200 (CEST)
Received: (qmail 20073 invoked by uid 550); 10 Jun 2019 18:20:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 20039 invoked from network); 10 Jun 2019 18:20:56 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2E0dyILuyKocdN2dzRdjtFgXYIqxsld9kBniaIiEbeY=;
        b=UvNhd/3a4AQxQ1SmbuSnzhG9x+IVIMMqkfUdY3Rl2tjLt8qR+0DOXZ3NpoJoGD8heY
         xt2BPUGG7NKODEWZhBS/4MSYeFigI/fxwplsoL+MDns/l79R24SY0gxY6rwMQ6onkb/q
         NdD9QMwjqww44kbImu30OA3LyNEqGyBB2hgi8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2E0dyILuyKocdN2dzRdjtFgXYIqxsld9kBniaIiEbeY=;
        b=GFZhLn9NQpSAmn/YPAvOeVgWjdaFrFr1KM+PTa71ohKFjRTn5iVQeRpvVPHr6XO3i+
         DRuRMQ0YpVLE6zm8RC4X9LyS3k1a4KVkw/k90ky/TdCMrK3XJDN/Chu2hiYb7GgNNqEw
         5mXp+gTBlFYJNGlRZ7iuDXZowPlEiCB8RHYbIlqkeIYW9DnyAcXLfvRRXfZA3gypZHm5
         7O9imAufr6FyHX4h0b0Ei1MX6o2nyhmkcEQUIx0tq9IJc2kTcJj5JgwDKg+k4IBmEKSj
         YjsfPn2jLtqeVLnepdBzI7Bf20zQ3g0L7HK2+qnBpLJN+u/drSFHNZsa7PXYPkDwaRba
         r5WQ==
X-Gm-Message-State: APjAAAVHddX9OqQhCaAc9g5gKcBKD6sVeI710aQ5veORb/DBM0vDHuX9
	F5hkIOXiwaUoQQWVcPwNTDb7Qw==
X-Google-Smtp-Source: APXvYqwtn9H9L60ATbVPj+3CQXzk8bT2AR8+AzzC6dbQ7Vai+T2I6Fq2Mv1ENatnOVsEoHPRRa3AQA==
X-Received: by 2002:a62:1ec1:: with SMTP id e184mr76241786pfe.185.1560190844873;
        Mon, 10 Jun 2019 11:20:44 -0700 (PDT)
Date: Mon, 10 Jun 2019 11:20:43 -0700
From: Kees Cook <keescook@chromium.org>
To: "Khajapasha, Mohammed" <mohammed.khajapasha@intel.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Subject: Re: Regarding add detection for double-reads
Message-ID: <201906101111.0868D6BE6@keescook>
References: <1EBC98102E7E77409022937977AC6892FF10E6@BGSMSX110.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1EBC98102E7E77409022937977AC6892FF10E6@BGSMSX110.gar.corp.intel.com>

On Mon, Jun 10, 2019 at 05:19:17PM +0000, Khajapasha, Mohammed wrote:
> As discussed over IRC, could you please provide some point on "add detection for double-reads".

Hi!

This was about following up on building a good Coccinelle script that
would warn about cases where the kernel reads from userspace twice at
the same location which may result in bugs like reading the size of a
structure at the start of a structure, allocating a size, then filling
the structure with a second read (at which point the size may have
changed). For example:

struct example {
	unsigned int bytes;
	unsigned int flags;
	u8 data[];
}

int do_user_interface(struct example __user *user_instance)
{
	struct example *instance;
	unsigned int size;

	copy_from_user(&size, user_instance, sizeof(size));
	instance = kmalloc(size, GFP_KERNEL);
	if (!instance)
		return -EINVAL;
	copy_from_user(instance, user_instance, size);
	perform_actions(instance);
}

The "bytes" field of the instance passed to perform_actions() may not
contain the right value, leading to possible heap overflows when
accessing instance->data[]...

What's needed after the second copy_from_user() is:

	if (instance.bytes != size) {
		kfree(instance);
		return -EINVAL;
	}

But _finding_ the cases is what I'd like to nail down and get into the
kernel scripts. The thread that needs following up is here:

https://lore.kernel.org/lkml/20160426222442.GA8104@www.outflux.net


-- 
Kees Cook
