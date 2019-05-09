Return-Path: <kernel-hardening-return-15912-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 75A0B18E03
	for <lists+kernel-hardening@lfdr.de>; Thu,  9 May 2019 18:27:54 +0200 (CEST)
Received: (qmail 5278 invoked by uid 550); 9 May 2019 16:27:47 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 26166 invoked from network); 9 May 2019 15:38:47 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5YwQ7pSduzStb02SylGKVrjZm5E2uXA+GvWIb5JRr7I=;
        b=H5YrD2LANg0XDBX7Y8dX3WkFbyNGuKqmc5AwTCh3L8XKM1fCfygAH6ZZiCtp9tqqlD
         RxH8VecF/mXAPPFyCplZvNSO/9v006AbuWT/n6pPPRhI4nrP96doRX6Xq1znHbO4VVQ/
         G3kcSqpeEXJBkxBuWZHB/O1+9AApxfAZUUs9ezP38DJDepTh3xANJ/OLFaHQBMLj9Wm5
         MuJG8j7w2G1sbeBewcHXyCRfwk4iMjYXN1tb8k0QAz9IxchlTla8nJbb1BQ7G/YzDMOO
         Y/KBoLfQw/G64pRnlHf18UE8WP4NpZegiPor/cUFu6kDqVkX1EEz1g1AITn6aA211vqv
         Dzpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5YwQ7pSduzStb02SylGKVrjZm5E2uXA+GvWIb5JRr7I=;
        b=jIt+aaWibQbGvTlVVmTI1zWQTrfHM7CkAqNvgh8jRfzPovDo2Mq03eDeWfCcVi9AE3
         FEDx9WsZO65QM0cKVYZKvALPJF4jf9+9nYgYOsZb0M83PFq66fuQE/Bt5ALRF6gLGcFZ
         Kt9ohGsfd8J/2JEtglGQh33qqDjifMYyZkyDfrJTR2ehAOOBTO/79nNueUZsnWAO73MK
         kF1SwpFbI7yIA1bi9ju/wp+7Sq3qLmERaaWt+Y4TSkfWqAJehKm40i0nE5tevuXfKxtH
         Km7Q5v16tpR9rs6L1/OcsQzRGskDpr8JaNpCYAqiUhuyl8zKqniWI9siIua6HzZWsEvZ
         WNfg==
X-Gm-Message-State: APjAAAU1ss63gfCP6HX56/uYhVrvK9sd5nh0O3JuYiwFzP5X+dFdagX2
	SJDAyxNABuGRH61PWFjqycFOFQ==
X-Google-Smtp-Source: APXvYqxqQ737rcyEeTeKDmNxTm839RB0ZfC55simHYlp8b5BDIhwUb8yXIjBmSqvxOC2ppuwaQgrnQ==
X-Received: by 2002:a62:2b43:: with SMTP id r64mr6112838pfr.210.1557416314921;
        Thu, 09 May 2019 08:38:34 -0700 (PDT)
Date: Thu, 9 May 2019 08:38:28 -0700
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
Message-ID: <20190509153828.GA261205@google.com>
References: <20190507161321.34611-1-keescook@chromium.org>
 <20190507170039.GB1399@sol.localdomain>
 <CAGXu5jL7pWWXuJMinghn+3GjQLLBYguEtwNdZSQy++XGpGtsHQ@mail.gmail.com>
 <20190507215045.GA7528@sol.localdomain>
 <20190508133606.nsrzthbad5kynavp@gondor.apana.org.au>
 <CAGXu5jKdsuzX6KF74zAYw3PpEf8DExS9P0Y_iJrJVS+goHFbcA@mail.gmail.com>
 <20190509020439.GB693@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190509020439.GB693@sol.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, May 08, 2019 at 07:04:40PM -0700, Eric Biggers wrote:
> And I also asked whether indirect calls to asm code are even allowed
> with CFI. IIRC, the AOSP kernels have been patched to remove them from
> arm64

At least with clang, indirect calls to stand-alone assembly functions
trip CFI checks, which is why Android kernels use static inline stubs
to convert these to direct calls instead.

Sami
