Return-Path: <kernel-hardening-return-16838-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 6ADAAA3EA6
	for <lists+kernel-hardening@lfdr.de>; Fri, 30 Aug 2019 21:48:10 +0200 (CEST)
Received: (qmail 23768 invoked by uid 550); 30 Aug 2019 19:48:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 23732 invoked from network); 30 Aug 2019 19:48:02 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lfElKMam/T9V6bsHLEtrVU85ksJ2VDYhroR6xFrZWzc=;
        b=S2+GEn1dwls7W9EjbKis0gEXBDsdZQPxoEf3WKnPui0h4AaQOe1DySp16Ru1yOEUR7
         Mm6Q+D3hLV7Y3ti33qQgOpq2rSHyLPakdr2RDl46NbsvRtJ4YLZUZ0V3ZWDGJCD9sZrB
         SQf4HSxDlqVFWh152qgTsEBU0mXYPt3NoxqBA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lfElKMam/T9V6bsHLEtrVU85ksJ2VDYhroR6xFrZWzc=;
        b=M3I1RVKDhqmhGAwQyaIgPmeJ5+QhNFZbBkehOtz0/l/B8GnlNV/ZFafQvh1+yuUUtj
         3vW0P92NGlRiLMlZLcEftlvan12xUi07XzmqeTOIIJ8qlBsT5W2ZZE/mEM91SqAFNw/s
         IW1nDWR78L/05/KosWU+spyPw/uC5QYk7O0RMStas8/8JVda11SygvQWTu8DsL7irOof
         T0sNmXfkovBO1wYcKkW/TK7wZOEIeoCS+Cj6GcQok6BemzlrI/T6//WMYoym6OVCPcsb
         ookXhTidO34eRg2fkEYBinmYDKTflb6eIbcUu/Cp5YgEkmZKJUTaT0m0fjDOlNRi3mEi
         DxyQ==
X-Gm-Message-State: APjAAAW8ptLCowsvYmQbDR5WtatV5lInKZnBM06JZUoU7I4wlwxOIKDS
	AB2sMKyQE6YIEZijJ7YNuH/EFw==
X-Google-Smtp-Source: APXvYqzQ7f5w2apaQfPAmRolacGQV7qES2OFHKPlOr231SsxxsJG+Tu1jnpgIbKXgFIB/alf1uAmAQ==
X-Received: by 2002:a17:90a:d990:: with SMTP id d16mr219208pjv.55.1567194470301;
        Fri, 30 Aug 2019 12:47:50 -0700 (PDT)
Date: Fri, 30 Aug 2019 12:47:48 -0700
From: Kees Cook <keescook@chromium.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Jason Yan <yanaijie@huawei.com>, kernel-hardening@lists.openwall.com,
	linux-fsdevel@vger.kernel.org
Subject: Re: CONFIG_HARDENED_USERCOPY
Message-ID: <201908301242.EAC8111@keescook>
References: <6e02a518-fea9-19fe-dca7-0323a576750d@huawei.com>
 <201908290914.F0F929EA@keescook>
 <20190830042958.GC7777@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190830042958.GC7777@dread.disaster.area>

On Fri, Aug 30, 2019 at 02:29:58PM +1000, Dave Chinner wrote:
> On Thu, Aug 29, 2019 at 09:15:36AM -0700, Kees Cook wrote:
> > On Thu, Aug 29, 2019 at 08:42:30PM +0800, Jason Yan wrote:
> > > We found an issue of kernel bug related to HARDENED_USERCOPY.
> > > When copying an IO buffer to userspace, HARDENED_USERCOPY thought it is
> > > illegal to copy this buffer. Actually this is because this IO buffer was
> > > merged from two bio vectors, and the two bio vectors buffer was allocated
> > > with kmalloc() in the filesystem layer.
> > 
> > Ew. I thought the FS layer was always using page_alloc?
> 
> No, they don't. It's perfectly legal to use heap memory for bio
> buffers - we've been doing it since, at least, XFS got merged all
> those years ago.

Okay, so I have some observations/thoughts about this:

- This "cross allocation merging" is going to continue being a problem
  in the future when we have hardware-backed allocation tagging (like
  ARM's MTE). It'll be exactly the same kind of detection: a tagged
  pointer crossed into a separately allocated region and access through
  it will be rejected.

- I don't think using _copy_to_user() unconditionally is correct here
  unless we can be absolutely sure that the size calculation really
  was correct. (i.e. is the merge close enough to the copy that the
  non-merge paths don't lose the validation?)

- If this has gone until now to get noticed (hardened usercopy was
  introduced in v4.8), is this optimization (and, frankly, layering
  violation) actually useful?

- We could just turn off allocation merging in the face of having
  hardened usercopy or allocation tagging enabled...

-- 
Kees Cook
