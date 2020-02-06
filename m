Return-Path: <kernel-hardening-return-17703-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 7D0AB154424
	for <lists+kernel-hardening@lfdr.de>; Thu,  6 Feb 2020 13:37:58 +0100 (CET)
Received: (qmail 32211 invoked by uid 550); 6 Feb 2020 12:37:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 32191 invoked from network); 6 Feb 2020 12:37:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6fXR/mbSdG/GuSMMWg/QMGok/jnDT6wVXIjTyBjsSus=;
        b=YDPSl97I6ie5WoTko+sLjNuIbuKRJ0lnQHSRwMr5Y6HtI9GRn2CyTqHW9t0F/mCZTb
         PrqWx1eIhx1UOYMGHk1pWUX0UhRN1FQd6pUSajEMJoSkwJGyfF4hMsofqz5ytpoefHyN
         DN8hb4Rw0W7U6VO5nOyU0MyBMSfHWGyFgvovg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6fXR/mbSdG/GuSMMWg/QMGok/jnDT6wVXIjTyBjsSus=;
        b=TzL1BMJWXq2hyG7gkXZegNU7aDNdxFcUsNQ3I5AkoU8RKRpL7IdgQKiZ5UWQcKxen0
         7QH6GcX33QZLqOFGIXlOVtr+wVC+pKR3g4hPBkRu6DiHjvQUZ3/dQ/TtY17wsQ9vhqP3
         Rcyi4A72A0DIrPsfM+D5OOSCS/p9+RPKbn4vRVhpi5EGEgbrdDgKWGfZaDkABZ2POlue
         MAvcPNsLT4iSXD19E+2bcCorV7SM71oK9q7vx+2FoEdEhi0wf8RejrffWPZrxVKaWBte
         JEUDVV6JYHL5EmALUfjtENIUVZelpb5ddL+1Wao3YMSkpdn6qZpXKjRx1YiTm1OaDtRk
         7qWg==
X-Gm-Message-State: APjAAAXA95NrE5LbTPlgowb8iiHC0lyeHPXSIgWF1CYq26fLR8/mRdHi
	/G/jzmf7jrVED3oC1x8AAA7jcg==
X-Google-Smtp-Source: APXvYqxakL0/UPBmResyRSGCzxIsFRYduCjh/RPlXP67bb//K0x4goyhxhEXAJoeeeHituBlbyGvKQ==
X-Received: by 2002:a9d:1928:: with SMTP id j40mr30813778ota.68.1580992661363;
        Thu, 06 Feb 2020 04:37:41 -0800 (PST)
Date: Thu, 6 Feb 2020 04:37:39 -0800
From: Kees Cook <keescook@chromium.org>
To: Kristen Carlson Accardi <kristen@linux.intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
	arjan@linux.intel.com, rick.p.edgecombe@intel.com, x86@kernel.org,
	linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Subject: Re: [RFC PATCH 07/11] x86/tools: Adding relative relocs for
 randomized functions
Message-ID: <202002060435.CF7BFB723@keescook>
References: <20200205223950.1212394-1-kristen@linux.intel.com>
 <20200205223950.1212394-8-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200205223950.1212394-8-kristen@linux.intel.com>

On Wed, Feb 05, 2020 at 02:39:46PM -0800, Kristen Carlson Accardi wrote:
> If we are randomizing function sections, we are going to need
> to recalculate relative offsets for relocs that are either in
> the randomized sections, or refer to the randomized sections.
> Add code to detect whether a reloc satisifies these cases, and if
> so, add them to the appropriate reloc list.
> 
> Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>

Looks good to me. :)

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
