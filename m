Return-Path: <kernel-hardening-return-16088-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id AFEA13BEB6
	for <lists+kernel-hardening@lfdr.de>; Mon, 10 Jun 2019 23:33:07 +0200 (CEST)
Received: (qmail 7610 invoked by uid 550); 10 Jun 2019 21:33:01 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 7589 invoked from network); 10 Jun 2019 21:33:00 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=u65kJhZ2c0w54Nc/i9RYT+l58N6im9e9Q29G/YH/uuc=;
        b=ijZRqYOHAJLGYs5vVBH7AyvxnX3poiS7Ze8fMa8xMMZFUFQkNHIHUJuCZa0E+HU7KK
         ZEEdHPDvfDlVSbqAvrXP3rviz6pH3j9htRBPT5NIqJKjGJE+FjxllNFI8RlkWV1QA19g
         aArbTyQM1D+rcblnoPAFTe/gzDozuxJ5mSkQw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=u65kJhZ2c0w54Nc/i9RYT+l58N6im9e9Q29G/YH/uuc=;
        b=EmO+D1lFuZcDcdpsy6rsVA1csCzVeHqMdSD+DYkizwlEEbIZYwRDtq5yUxOfK6SLyf
         LP6u5MzVcsIFTz/41XTM8xxS1ZnSRnAmOAxxGqSFdn4Lzd7XxCq5oNZuTd/vxd8L1eTw
         43ZdT4V9EIjCf205VSG6CWymqvIdLyfeHZ+MOpeddr/LMtmgcnpz43FKH8UQK1wKf/Z1
         r22X+Hfe8uw74BQF7OMoLn19JfWSiuWoLFXLQ2W5z8VJeRPGTHaxqTyBWXHohEolfKtZ
         0i/kKa8a57M5kl0rvE9Y2JXyENyup2IDM3RoQI7rVQqJgESSr2wdDbES+2knWPP5pTi/
         08fw==
X-Gm-Message-State: APjAAAU1nEr31zysCseYAeqbPqQGGfNxMaeKNMv730lbRkN2GNY7/xl+
	O+HGx/FMUPUnX9k2yJZtNuxBKQ==
X-Google-Smtp-Source: APXvYqyQzwsz4g4vXj8Aq9NRG67WJeqq4COKYtOvIJxo3DWxXcQEhMnNrnrMg8J5OGqUXm+tPqrSlw==
X-Received: by 2002:aa7:8145:: with SMTP id d5mr77831178pfn.11.1560202368916;
        Mon, 10 Jun 2019 14:32:48 -0700 (PDT)
Date: Mon, 10 Jun 2019 14:32:47 -0700
From: Kees Cook <keescook@chromium.org>
To: Thomas Garnier <thgarnie@chromium.org>
Cc: kernel-hardening@lists.openwall.com, kristen@linux.intel.com,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
	Andy Lutomirski <luto@kernel.org>, Juergen Gross <jgross@suse.com>,
	Alok Kataria <akataria@vmware.com>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Garnier <thgarnie@google.com>, Nadav Amit <namit@vmware.com>,
	Jann Horn <jannh@google.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	Andi Kleen <ak@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Feng Tang <feng.tang@intel.com>, Jan Beulich <JBeulich@suse.com>,
	Maran Wilson <maran.wilson@oracle.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	virtualization@lists.linux-foundation.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v7 00/12] x86: PIE support to extend KASLR randomization
Message-ID: <201906101432.B642E297F@keescook>
References: <20190520231948.49693-1-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190520231948.49693-1-thgarnie@chromium.org>

On Mon, May 20, 2019 at 04:19:25PM -0700, Thomas Garnier wrote:
> Splitting the previous serie in two. This part contains assembly code
> changes required for PIE but without any direct dependencies with the
> rest of the patchset.

Thanks for doing this! It should be easier to land the "little" fixes so
there's less to review for the big PIE changes down the road.

-- 
Kees Cook
