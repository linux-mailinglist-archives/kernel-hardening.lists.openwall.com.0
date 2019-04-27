Return-Path: <kernel-hardening-return-15844-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id AEFC8B32C
	for <lists+kernel-hardening@lfdr.de>; Sat, 27 Apr 2019 12:22:32 +0200 (CEST)
Received: (qmail 13774 invoked by uid 550); 27 Apr 2019 10:22:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 13756 invoked from network); 27 Apr 2019 10:22:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=de/pNKGKEgMYXZXH86ILziX1rd53UXodWw8hsowIUv8=;
        b=FHS55DQa7HVVSxloxBDHY12J9GGU3TjeKB6GK1roRSZM4TMRfM9dYUlqrluVFxih7k
         iqu3tTBkjTimmoUUtRc9/3kuRbifUQxHT8LeZx+3LiD5TMcOcCNzsKRhSkft2PMnPL90
         Vq7F63S3Kk/KiYW3nP3OGcmjIyvV1UhWBerCN544Ts7nwYpebY5UhaYNAcmZAxFT/J8R
         UKBu4UL+M9o669No1gk+IM/qFwaWfD17ifFjhxENuLAmPXM7CnsSd3smT++LnH3M3sJn
         Y4o3DE6SPT1Yxd9AwUXeqYCObbDwq5rB1DHi/FXl3JAY0c54wEc4nLvawZwVSQ5PJZ9e
         +/YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=de/pNKGKEgMYXZXH86ILziX1rd53UXodWw8hsowIUv8=;
        b=h4Bmu/45L4KCas6/m6wQ1rZe1t5T8xkJHKXTx5ApXu9wCwyg+wL21OdSdq3wh9OvMp
         dAtzXhRP8PfADJVAHsLPIKvIPrNE0h5rRvkuJA94hEl0EydhDBtxtOMZqrQCRkK71PBJ
         RzqH/EMiRPhHCjJ1NkfI4lLL3tDzBQZOS7RBI2hJlmtIUdTrCafZ8jEFviU8xghkPgq5
         MeHBR1I5gOnOZq9V/Y43o5hEqY5mDKpfYHBjEdglr9g+m2E3/ULewUQDyz9LMY+4V2ov
         jKXI8SPnljqcYkekn+CfdQfLyzpOoXWAATrdSGwiB0CmgC5EzbMzQIVdjyaaslAjB/1E
         oAxw==
X-Gm-Message-State: APjAAAXjWEfmMUBObbaU7Cs5C0pokPxxkD3AtOJpqSd3c3UjzEgVTHds
	svneuXO1k0dhwE+KgMzApqo=
X-Google-Smtp-Source: APXvYqz9DACRCDQQ8Go5wbjbYqQ8/ZE2Kbv27Orbu2KzfOAXTXxbqBkygu2CrWu329RFlIYxLpfm2Q==
X-Received: by 2002:a7b:cf2b:: with SMTP id m11mr10741651wmg.56.1556360534355;
        Sat, 27 Apr 2019 03:22:14 -0700 (PDT)
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Sat, 27 Apr 2019 12:22:10 +0200
From: Ingo Molnar <mingo@kernel.org>
To: nadav.amit@gmail.com
Cc: Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
	Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com,
	Thomas Gleixner <tglx@linutronix.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, linux_dti@icloud.com,
	linux-integrity@vger.kernel.org,
	linux-security-module@vger.kernel.org, akpm@linux-foundation.org,
	kernel-hardening@lists.openwall.com, linux-mm@kvack.org,
	will.deacon@arm.com, ard.biesheuvel@linaro.org,
	kristen@linux.intel.com, deneen.t.dock@intel.com,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Nadav Amit <namit@vmware.com>
Subject: Re: [PATCH v6 00/24] x86: text_poke() fixes and executable lockdowns
Message-ID: <20190427102210.GA130188@gmail.com>
References: <20190426232303.28381-1-nadav.amit@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190426232303.28381-1-nadav.amit@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)


* nadav.amit@gmail.com <nadav.amit@gmail.com> wrote:

> From: Nadav Amit <namit@vmware.com>
> 
> *
> * This version fixes failed boots on 32-bit that were reported by 0day.
> * Patch 5 is added to initialize uprobes during fork initialization.
> * Patch 7 (which was 6 in the previous version) is updated - the code is
> * moved to common mm-init code with no further changes.
> *
> 
> This patchset improves several overlapping issues around stale TLB
> entries and W^X violations. It is combined from "x86/alternative:
> text_poke() enhancements v7" [1] and "Don't leave executable TLB entries
> to freed pages v2" [2] patchsets that were conflicting.

Which tree is this again? It doesn't apply to Linus's latest nor to -tip 
cleanly.

Thanks,

	Ingo
