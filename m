Return-Path: <kernel-hardening-return-16337-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 549B55D7BA
	for <lists+kernel-hardening@lfdr.de>; Tue,  2 Jul 2019 23:04:47 +0200 (CEST)
Received: (qmail 22036 invoked by uid 550); 2 Jul 2019 21:04:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 21908 invoked from network); 2 Jul 2019 21:04:23 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=SUVDDvVHWZQdqqeYC3Ylmti8VS+Hw8xp8Rwtgp+EZ08=;
        b=SJrNkPBd+yGmaL7MwJlDAL3hoOg5/PNlXpqH4fiOUCEjDU7XvuOMciXmB8cPoT+n2/
         HU33Fh6VqqDMT1goa9ATaIP7k1LBzcGA1ct8CbccucMTiIHK2XyZgpK/X09Vu8ILkbWH
         9dJ2f4Owt/Sb6TPBTgMQ0eM3q07WV42g0a0+o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=SUVDDvVHWZQdqqeYC3Ylmti8VS+Hw8xp8Rwtgp+EZ08=;
        b=HirNF25+cVAzPfHg6Ik2tcX9B61tFXNsDY7nxwaVzAM7ftBHL2L8jph+2NXr6evng1
         netr3GJjgLRUqWqUbmAb5ffpNb6IWg6cDCxInYD3gA4WYDlk8V0uQNiMmLNLkM97lZ3A
         xQQDxBcJUO4VWMYwI7aUwvrgvfB1319KBofPv1JjFVE0x93nzfzrnblM62JyWeJTRzmL
         e8mI8FVM2vomBoQ9plPinVfVUpYR7bJIzHTGtzIrSOtXKRjfZAA+VqHQUKHovHtmt6LQ
         sYwggPRxn3qO0d7SS2QxQz505nZyL4JHCQGguT/XwL7GpMtcqaMvzPrQxg2D4AV1suwE
         J+kg==
X-Gm-Message-State: APjAAAXMPJChbU08UwT8uR9F8TyCH8hdEs/c7vRt1KlqrFynFUWZvwDA
	UHOLoG0qGkjDGv4gPq3UTEYvWQ==
X-Google-Smtp-Source: APXvYqwcJJEeXoRvcEHyUpuRg4L8X6jsMqgQTja/9PFIrJ95fLg+i/GQWS7UMCTozQh4UkRafF7X8Q==
X-Received: by 2002:a17:90a:384d:: with SMTP id l13mr8060330pjf.86.1562101451990;
        Tue, 02 Jul 2019 14:04:11 -0700 (PDT)
Date: Tue, 2 Jul 2019 10:25:04 -0700
From: Kees Cook <keescook@chromium.org>
To: Stephen Kitt <steve@sk2.org>
Cc: Nitin Gote <nitin.r.gote@intel.com>, jannh@google.com,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH] checkpatch: Added warnings in favor of strscpy().
Message-ID: <201907021024.D1C8E7B2D@keescook>
References: <1561722948-28289-1-git-send-email-nitin.r.gote@intel.com>
 <20190629181537.7d524f7d@sk2.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190629181537.7d524f7d@sk2.org>

On Sat, Jun 29, 2019 at 06:15:37PM +0200, Stephen Kitt wrote:
> On Fri, 28 Jun 2019 17:25:48 +0530, Nitin Gote <nitin.r.gote@intel.com> wrote:
> > 1. Deprecate strcpy() in favor of strscpy().
> 
> This isn’t a comment “against” this patch, but something I’ve been wondering
> recently and which raises a question about how to handle strcpy’s deprecation
> in particular. There is still one scenario where strcpy is useful: when GCC
> replaces it with its builtin, inline version...
> 
> Would it be worth introducing a macro for strcpy-from-constant-string, which
> would check that GCC’s builtin is being used (when building with GCC), and
> fall back to strscpy otherwise?

How would you suggest it operate? A separate API, or something like the
existing overloaded strcpy() macros in string.h?

-- 
Kees Cook
