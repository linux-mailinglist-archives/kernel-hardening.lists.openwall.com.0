Return-Path: <kernel-hardening-return-17713-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 4F2FC154815
	for <lists+kernel-hardening@lfdr.de>; Thu,  6 Feb 2020 16:30:10 +0100 (CET)
Received: (qmail 25849 invoked by uid 550); 6 Feb 2020 15:30:04 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 25829 invoked from network); 6 Feb 2020 15:30:04 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YRGPQTxySG8GGpnc9qj5oMJ9OxtV3T+CuCWWaPN4Sm4=;
        b=kFOBTaZbZk+6VKEeWwEi3ZTRFP/6WLlVpOAShTiRr6XWtBhvXRtaP9jNzjcAtx6mC4
         XLPvHoCNhHi6uHkJp2f8UYY+pa7Psn7d5gKhEKBimDVNaaf4ntcqdXDrpTTnSA+ukBgK
         LmJZ1U9B8ui6kIWVlnXutoSc+pjCv7h//L/BRrY6HOzk9M5R+ySe5/cbDJkv6DScyvd5
         eE8Kwrn41QarPcUKuFzYM1deV2vxmVaYXb2U2nkAlMpNCQpH+Wsu59bLZt30EvJdrFfM
         CHUAl52gdg+8/Ulbz+2TKm7X3gjMhfqFNPJP4oDdxXMzdm18yolhvGgBKlLI+8KxLAj/
         NSjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=YRGPQTxySG8GGpnc9qj5oMJ9OxtV3T+CuCWWaPN4Sm4=;
        b=XCmlvSssRTzZLBp7NCW2k38NBQbqbz7g0CpiCJNV7Y5tITnPy5aUmZoeHeVh7o5P/Y
         qtFc/eVURe9HfFiJjta/XQcCMvFchqw6HGtNU9bVwlUAGspCgdk9zM4WBExy6FECUyww
         qGXfAq65X+OKdwO5fSL2IiSvlbWYXe24eLtF77vYO83vki+WPNPXeBYS8BUJqf2LaeoE
         2p3dvfChzmK2l35WuWzXBFicgZzh/obTLHAv9tvYrtQlLJl+XIo2Sa9jGIu/vKEq7N4T
         nCvLJjJUNHQRRdHoJ+VHV0+p1e5smVphPSsw9EQeJJ8vZ4ZC4Gk9+XmUKE/FonM5pCjy
         NQMg==
X-Gm-Message-State: APjAAAX+VpaocoKrGONEnWhPhRxmhsFmDhEJZ5CJwMOdvoFarXnbhWJ9
	wrkRW1gIZbbM5wq2d1ScRsI=
X-Google-Smtp-Source: APXvYqxxQY40erXrrieQVRQf7QWTeCZdyuefKx4EU2WMpDcQ4vU+EACDTUD+UXJEsoRGYnQmhHLxbw==
X-Received: by 2002:a0c:fac8:: with SMTP id p8mr2824512qvo.47.1581002992198;
        Thu, 06 Feb 2020 07:29:52 -0800 (PST)
Sender: Arvind Sankar <niveditas98@gmail.com>
From: Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date: Thu, 6 Feb 2020 10:29:50 -0500
To: Kees Cook <keescook@chromium.org>
Cc: Kristen Carlson Accardi <kristen@linux.intel.com>, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
	arjan@linux.intel.com, rick.p.edgecombe@intel.com, x86@kernel.org,
	linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Subject: Re: [RFC PATCH 06/11] x86: make sure _etext includes function
 sections
Message-ID: <20200206152949.GA3055637@rani.riverdale.lan>
References: <20200205223950.1212394-1-kristen@linux.intel.com>
 <20200205223950.1212394-7-kristen@linux.intel.com>
 <202002060408.84005CEFFD@keescook>
 <20200206143941.GA3044151@rani.riverdale.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200206143941.GA3044151@rani.riverdale.lan>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Thu, Feb 06, 2020 at 09:39:43AM -0500, Arvind Sankar wrote:
> On Thu, Feb 06, 2020 at 04:26:23AM -0800, Kees Cook wrote:
> > I know x86_64 stack alignment is 16 bytes. I cannot find evidence for
> > what function start alignment should be. It seems the linker is 16 byte
> > aligning these functions, when I think no alignment is needed for
> > function starts, so we're wasting some memory (average 8 bytes per
> > function, at say 50,000 functions, so approaching 512KB) between
> > functions. If we can specify a 1 byte alignment for these orphan
> > sections, that would be nice, as mentioned in the cover letter: we lose
> > a 4 bits of entropy to this alignment, since all randomized function
> > addresses will have their low bits set to zero.
> > 
> 
> The default function alignment is 16-bytes for x64 at least with gcc.
> You can use -falign-functions to specify a different alignment.
> 
> There was some old discussion on reducing it [1] but it doesn't seem to
> have been merged.
> 
> [1] https://lore.kernel.org/lkml/tip-4874fe1eeb40b403a8c9d0ddeb4d166cab3f37ba@git.kernel.org/

Though I don't think the entropy loss is real. With 50k functions, you
can use at most log(50k!) = ~35 KiB worth of entropy in permuting them,
no matter what the alignment is. The only way you can get more is if you
have more than 50k slots to put them in.
