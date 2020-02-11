Return-Path: <kernel-hardening-return-17780-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 393A81599B5
	for <lists+kernel-hardening@lfdr.de>; Tue, 11 Feb 2020 20:26:07 +0100 (CET)
Received: (qmail 16112 invoked by uid 550); 11 Feb 2020 19:26:01 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 16077 invoked from network); 11 Feb 2020 19:26:00 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Fduhzb+WwBefc5G2IiZw7jkFkPhFvQRZKGxZZqFDo/E=;
        b=aBFZgI1bEVFMDfd8bvtXh9AZ1Mze2/1St6L/4BVij/mXj+0ZVWJe/BBz62kvdV/PUy
         KBlDmWnFixMHuEJ2x57jhZe2RZwo4KxOOAhGPDQppATODztQCUF1bGUHqwB2F+7dyFEs
         eKbWf5MArG16cSHqLbOgFxRg8G+4rPIDu1A8c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Fduhzb+WwBefc5G2IiZw7jkFkPhFvQRZKGxZZqFDo/E=;
        b=RhMqGHGMNYw1ULsa6vRjDPm14o/Hr6gs3ZIsVD+O/eOvvO1a7QUn7gSH48bc9yr+R2
         xYGU4b5wcT4lwrRjK10TivM8WsT/c+uxs71eCWj2bKCmcnwUpV+HQekXvfgMKW6OhW4F
         pjkkze48ccL1q5+vBJ1pJVKNXXhC0YF4AHBwtw/bqVNjugIi2hzDfe4/znft1Wc1e8Fx
         YnzSEt+ITpd1w6JjiwL7Ks8B+89w6wlPEUrgw/gOcOcJ2SoXiSgFQ2Zj+1HIIuzh/QrO
         sYw2HFliv8abjQfV6N67V+MdVT+xrkiDHBMehXK8pvdy7c/4fQ4qdgCkreMg+uxgerED
         HNqA==
X-Gm-Message-State: APjAAAW3sjLs9qPPIYQ3UVenOlVoHmg9u1XhZsiddencbs7WYJp8KBVW
	QedJ7PzMIQiU7T6oSgW+g4Fk+g==
X-Google-Smtp-Source: APXvYqzYyVOg7uqgSBmTXebLQ5IGOoof6bohkjL6i/HNSEw99SG6fXpTLlzi3kbK2a4VrLpxXNd1Pg==
X-Received: by 2002:a17:90a:b30b:: with SMTP id d11mr6814381pjr.22.1581449148710;
        Tue, 11 Feb 2020 11:25:48 -0800 (PST)
Date: Tue, 11 Feb 2020 11:25:46 -0800
From: Kees Cook <keescook@chromium.org>
To: shuah <shuah@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Hector Marco-Gisbert <hecmargi@upv.es>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will.deacon@arm.com>,
	Jason Gunthorpe <jgg@mellanox.com>, Jann Horn <jannh@google.com>,
	Russell King <linux@armlinux.org.uk>, x86@kernel.org,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 7/7] selftests/exec: Add READ_IMPLIES_EXEC tests
Message-ID: <202002111124.0A334167@keescook>
References: <20200210193049.64362-1-keescook@chromium.org>
 <20200210193049.64362-8-keescook@chromium.org>
 <4f8a5036-dc2a-90ad-5fc8-69560a5dd78e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f8a5036-dc2a-90ad-5fc8-69560a5dd78e@kernel.org>

On Tue, Feb 11, 2020 at 11:11:21AM -0700, shuah wrote:
> On 2/10/20 12:30 PM, Kees Cook wrote:
> > In order to check the matrix of possible states for handling
> > READ_IMPLIES_EXEC across native, compat, and the state of PT_GNU_STACK,
> > add tests for these execution conditions.
> > 
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> 
> No issues for this to go through tip.
> 
> A few problems to fix first. This fails to compile when 32-bit libraries
> aren't installed. It should fail the 32-bit part and run other checks.

Do you mean the Makefile should detect the missing compat build deps and
avoid building them? Testing compat is pretty important to this test, so
it seems like missing the build deps causing the build to fail is the
correct action here. This is likely true for the x86/ selftests too.

What would you like this to do?

-- 
Kees Cook
