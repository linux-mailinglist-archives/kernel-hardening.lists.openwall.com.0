Return-Path: <kernel-hardening-return-17685-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 4F61E153C81
	for <lists+kernel-hardening@lfdr.de>; Thu,  6 Feb 2020 02:17:44 +0100 (CET)
Received: (qmail 30497 invoked by uid 550); 6 Feb 2020 01:17:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 30466 invoked from network); 6 Feb 2020 01:17:37 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1580951845;
	bh=c/QAJGFBDVSsnDraji7Se4DitpBF5jtF8Hj48+GNKlA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=YAcjUsaAMmZHn5DXHnE51FYVBrapMvmo+iDYBMDPkq3SAFg6Fe6WK1EP8KKtNhGjm
	 unUBXbE5SPleewtncfCn2YBnSdVvuS2puhY1kJtoNsjzDaE1KhKWeNkg9VapuV+CBh
	 KPvzhkGvvxJHj7S3miOofmJc+2YYG4KGkwyVqNAY=
X-Gm-Message-State: APjAAAWLn5zLBee6cR5Lhy4YqMUP8uVlj7MsUVetGOwjdEQPEIhYuokl
	/6kUrPbTMtCac/eX/JREptSyBPVdzG5GvHKis+CIPg==
X-Google-Smtp-Source: APXvYqwFbS10N2WftuTlDwIzWSDLb9H6kCzWQcP3jbZxJdg1lQL3WQdMBg7Hp5BrowW1+nlTRrL8d3TJrkKcVqUXKr8=
X-Received: by 2002:a1c:3906:: with SMTP id g6mr635337wma.49.1580951844067;
 Wed, 05 Feb 2020 17:17:24 -0800 (PST)
MIME-Version: 1.0
References: <20200205223950.1212394-1-kristen@linux.intel.com> <20200205223950.1212394-9-kristen@linux.intel.com>
In-Reply-To: <20200205223950.1212394-9-kristen@linux.intel.com>
From: Andy Lutomirski <luto@kernel.org>
Date: Wed, 5 Feb 2020 17:17:11 -0800
X-Gmail-Original-Message-ID: <CALCETrVnCAzj0atoE1hLjHgmWjWAKVdSLm-UMtukUwWgr7-N9Q@mail.gmail.com>
Message-ID: <CALCETrVnCAzj0atoE1hLjHgmWjWAKVdSLm-UMtukUwWgr7-N9Q@mail.gmail.com>
Subject: Re: [RFC PATCH 08/11] x86: Add support for finer grained KASLR
To: Kristen Carlson Accardi <kristen@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	"H. Peter Anvin" <hpa@zytor.com>, Arjan van de Ven <arjan@linux.intel.com>, Kees Cook <keescook@chromium.org>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, X86 ML <x86@kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Feb 5, 2020 at 2:39 PM Kristen Carlson Accardi
<kristen@linux.intel.com> wrote:
>
> At boot time, find all the function sections that have separate .text
> sections, shuffle them, and then copy them to new locations. Adjust
> any relocations accordingly.
>

> +       sort(base, num_syms, sizeof(int), kallsyms_cmp, kallsyms_swp);

Hah, here's a huge bottleneck.  Unless you are severely
memory-constrained, never do a sort with an expensive swap function
like this.  Instead allocate an array of indices that starts out as
[0, 1, 2, ...].  Sort *that* where the swap function just swaps the
indices.  Then use the sorted list of indices to permute the actual
data.  The result is exactly one expensive swap per item instead of
one expensive swap per swap.

--Andy
