Return-Path: <kernel-hardening-return-15915-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 490AA192F4
	for <lists+kernel-hardening@lfdr.de>; Thu,  9 May 2019 21:33:22 +0200 (CEST)
Received: (qmail 9410 invoked by uid 550); 9 May 2019 19:33:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 5554 invoked from network); 9 May 2019 19:28:12 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mSogdT1b1TrauWJdc0+lW0R8qL7KGKdwvRVPra/F2u4=;
        b=ge8R844S9rhQhPZywYJzkfKzn0+UrddioB1eT3CI+Rxgh7FM5k/Nj631+ajLB5i98z
         qBuIhlAi7+7nh6F7Z1rJckUuSkcwqxtG9sGhGQoT+x1lUg6X3OXiC6ccNVUb1g4+KJ3l
         N1+vO7n2+b3u1X/Did/QTcwhdXYLekpehe87DVnoLH6kY+122yYPr/Ex9cn7pf7BP/W1
         FlrT5uOI64/8jOOZYvR1fypE9LJklRZHypbB9rqVJZx8+MtL+1Nrohw+knyr2bfi5W17
         OI+nfZAAHolUUB31C+q4yU4AmDT6PfWpOuppbMD9XX7P7zp9QAx71kIPMtx5e3xSH1Q5
         tKkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mSogdT1b1TrauWJdc0+lW0R8qL7KGKdwvRVPra/F2u4=;
        b=LuqGW41Eh2RpgRMkC6gRwZqxgA+t3OMPHYO8XsYcI2N4L0npaCRm7sINLtQiFRaW1w
         49n8M6kTvKzwG94DAcO9YI6QFubTmGGrp2QXqtzTd9uk9R2ZDnyyUfdThDwZYVHUZo1z
         WCgAlCfkzF8exsh+sz4stusWZ3rukNd5v1aQ8Km1rwj9XZpBDmqzfTboVnnCCSZOjK+k
         Y6g2oZx5vkkABFMlknU0vHCsmdoyGqdyi5agOcPSp2XvuLnmSZvVUNJw2MVqz1Wz35jP
         T8evaSOWdXHyfkDZx2otJ0N7b/LOJY7FCcSFP6zfYgpDWa9MzyzDU6ztIkK3BD85aPMu
         pmPQ==
X-Gm-Message-State: APjAAAUdnmqdgr6l18o+eSh/wnihQZHj94ynVv3T5+rynfB1Oye1iPk6
	w2ayv47wE7qJdHItCWm0lcKUTA==
X-Google-Smtp-Source: APXvYqz/zYt5LNbOUqYwUYqUaZNqn28INg1eTCOj3kgCLcwZ9Gnpmql4xKPflas+TJJo6HIP9ZvJow==
X-Received: by 2002:a62:1897:: with SMTP id 145mr7992573pfy.122.1557430079463;
        Thu, 09 May 2019 12:27:59 -0700 (PDT)
Date: Thu, 9 May 2019 12:27:53 -0700
From: Sami Tolvanen <samitolvanen@google.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Kees Cook <keescook@chromium.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Joao Moreira <jmoreira@suse.de>, Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>, X86 ML <x86@kernel.org>,
	linux-crypto <linux-crypto@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: [PATCH v3 0/7] crypto: x86: Fix indirect function call casts
Message-ID: <20190509192753.GA233211@google.com>
References: <20190507161321.34611-1-keescook@chromium.org>
 <20190507170039.GB1399@sol.localdomain>
 <CAGXu5jL7pWWXuJMinghn+3GjQLLBYguEtwNdZSQy++XGpGtsHQ@mail.gmail.com>
 <20190507215045.GA7528@sol.localdomain>
 <20190508133606.nsrzthbad5kynavp@gondor.apana.org.au>
 <CAGXu5jKdsuzX6KF74zAYw3PpEf8DExS9P0Y_iJrJVS+goHFbcA@mail.gmail.com>
 <20190509020439.GB693@sol.localdomain>
 <20190509153828.GA261205@google.com>
 <20190509175822.GB12602@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190509175822.GB12602@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Thu, May 09, 2019 at 10:58:23AM -0700, Eric Biggers wrote:
> Is there any way to annotate assembly functions such that they work
> directly with CFI?

Not to my knowledge.

Sami
