Return-Path: <kernel-hardening-return-17731-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id EF4CC155FB0
	for <lists+kernel-hardening@lfdr.de>; Fri,  7 Feb 2020 21:39:04 +0100 (CET)
Received: (qmail 7205 invoked by uid 550); 7 Feb 2020 20:38:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 6143 invoked from network); 7 Feb 2020 20:38:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rSg7JMFRzPtoE945qQnjffCeXnLroF1u5VJV3uyBQCE=;
        b=TIVoYpqKWPU4FbaHxrhBJ1Bwm+O6hvlv52zIi5d26xjDUTZ4yMC+K1iis5YbHTIZVl
         9dHFuS4jNiXqxsq3FgyR0QBYCDDX0K20dUQm3BjtPvApP9txtUUaqU1OO0GhGh3Nep+F
         BPgz1uHXGrOg8F5sRqAfUFY9p4EvycZiJalM+RzKSVOw2pxxJOS10UZf+ODEOwWn1KTt
         ZqDzRMDMRWAmKXYblY7qJmxgBJymQDI6UbiK7qjXtkJzZqMTb1XCaabdFiCYMXNc+Ehz
         aCcOFiv0DV4rUQziYOvUisKifEZCM89iODF4OZ09LVnQd9aS0sQtw75L6vLrgV6rGOTX
         LtsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rSg7JMFRzPtoE945qQnjffCeXnLroF1u5VJV3uyBQCE=;
        b=R0iAZkx0tjPxeFBkyrbAU5LcQSDr/opQm5oHino31biNQVYcdtfLeakRfVOEjknVXR
         pWP50KjqUi/NQ2tPVz48P/r69mJAdhHVB6C0KgwcXpzB8FFly20yJxr9Wp1NVyClztYt
         TbsNCKYrIn1ZDDneyoEaxcxHDXg+emLTdcHsLJL+EUjTZh/ufa7GJ8Cxz7/DWHarRlpU
         +xcqnuyZv7oDZBOwkc5ekAZbBRQNpvxEO3SUn5bKrzcXA+bnQB7zdCPH2Q/EHyMqornX
         3kfpBSJYfSn+0qKVAGXJZLQpkn+XuYMpDamXkC8J4wDIw2Z8BA4WnsaHWeLGglwokNvM
         Jdmw==
X-Gm-Message-State: APjAAAW5Jc7fKLmm8Ox1lN2jNPeMMuCgVfzJrnejMOXWFRUQHAeNmV2a
	QuuggwDqGpN7FcMkC90WdBZaqTQdN5mo3kK9GDM=
X-Google-Smtp-Source: APXvYqydjzIv13caN2xryirukeMzD0uzG2GhLc51HcLRq8k2qIGBrJQP/yUUcBKY5ND3CTEXOXO+aNgXuI7aWIVoDew=
X-Received: by 2002:a1c:488a:: with SMTP id v132mr81301wma.153.1581107927512;
 Fri, 07 Feb 2020 12:38:47 -0800 (PST)
MIME-Version: 1.0
References: <20200120074344.504-1-dja@axtens.net> <20200120074344.504-6-dja@axtens.net>
In-Reply-To: <20200120074344.504-6-dja@axtens.net>
From: Daniel Micay <danielmicay@gmail.com>
Date: Fri, 7 Feb 2020 15:38:22 -0500
Message-ID: <CA+DvKQJ6jRHZeZteqY7q-9sU8v3xacSPj65uac3PQfst4cKiMA@mail.gmail.com>
Subject: Re: [PATCH 5/5] [RFC] mm: annotate memory allocation functions with
 their sizes
To: Daniel Axtens <dja@axtens.net>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux-MM <linux-mm@kvack.org>, 
	Kees Cook <keescook@chromium.org>, kernel list <linux-kernel@vger.kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"

There are some uses of ksize in the kernel making use of the real
usable size of memory allocations rather than only the requested
amount. It's incorrect when mixed with alloc_size markers, since if a
number like 14 is passed that's used as the upper bound, rather than a
rounded size like 16 returned by ksize. It's unlikely to trigger any
issues with only CONFIG_FORTIFY_SOURCE, but it becomes more likely
with -fsanitize=object-size or other library-based usage of
__builtin_object_size.
