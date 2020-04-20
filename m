Return-Path: <kernel-hardening-return-18579-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 992751B184B
	for <lists+kernel-hardening@lfdr.de>; Mon, 20 Apr 2020 23:21:38 +0200 (CEST)
Received: (qmail 12202 invoked by uid 550); 20 Apr 2020 21:21:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 12176 invoked from network); 20 Apr 2020 21:21:32 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uz86WyXpZD4aK01AvgFxQcTobO1DIrQdnvHxYZU+v1g=;
        b=s2gZRkkKndLNkblWDyduoAGXU7tONSnx+h22+LKPEu1xCNTfj167lk3xFNDWULdibf
         QMmXoDoT+rU+/n0juU+cbwD3L89pQX8B7RqM6b/aCSeqv4YXlqrOO4AKDghtv3+qqQ5c
         9xGQ4xxcmUoGHJ2YasmZ+sQeoagJSOnbrLjQzqJ1Ny1eOugWVGpZQbRU3wquHEACr5DE
         jB6hPIIYqEb0mnGVUYO1tWwukp01nqN8oS52m7KJbvQ/CcUKezRRcKNOfYp8yr3Bvgwr
         WbhbJEhTDJz7ylqzkcGzSU7/R6hGkYphU0+6heCLt/VkVdVJD5Ozhfv8SC5l0apGuE7i
         dUUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uz86WyXpZD4aK01AvgFxQcTobO1DIrQdnvHxYZU+v1g=;
        b=KzYI4lbhNdVSFxc0XJ6NtUKwA6S52RNuSIuMw8YSZKfPv639Z1gftIW33Ytcz3AYgo
         6H1QPthfkva8pzMGuXzrIxYi3OlBosl0DTxnkj2m7xTg2qCl3aLn7gq0+sFVGXODhi4w
         ekoHJARv/XlITB7DZ4YH0QSsIea1UaDOygEZu6trEYhq6n6nvojJcoUGBrzKcZW3FQaG
         Dcp17w1puA/Ap+NcLcYD1WaA8MXsUnLTT0COpist+NjD1pLXcVFDpGS1DJelhfQ/HUcX
         0XlbC4vVhzVyILGVrrr8nwye/7YfaQPPxv8rhuwWwFY0sCL0peXilEG3XQhuj3Os6RdT
         NH8A==
X-Gm-Message-State: AGi0PuZ34dv/qq9m9VepR1yzUHpiEgRCMhlwOCi9x6mUXDF9DBK+soa0
	1Frwg22xw2bGGfmuHPqPtkN90w==
X-Google-Smtp-Source: APiQypIJ5dgZXInWQPnOxgl2H83kMh9t0kDEIPA3YY9dlUHOLn8dCodScN3RstdO6CqW8s/+YrPGlA==
X-Received: by 2002:a63:145a:: with SMTP id 26mr19419317pgu.238.1587417680555;
        Mon, 20 Apr 2020 14:21:20 -0700 (PDT)
Date: Mon, 20 Apr 2020 14:21:14 -0700
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Michal Marek <michal.lkml@markovi.net>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dave Martin <Dave.Martin@arm.com>,
	Kees Cook <keescook@chromium.org>,
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Jann Horn <jannh@google.com>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 02/12] scs: add accounting
Message-ID: <20200420212114.GA77284@google.com>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20200416161245.148813-1-samitolvanen@google.com>
 <20200416161245.148813-3-samitolvanen@google.com>
 <20200420171753.GD24386@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200420171753.GD24386@willie-the-truck>

On Mon, Apr 20, 2020 at 06:17:55PM +0100, Will Deacon wrote:
> > +#ifdef CONFIG_SHADOW_CALL_STACK
> > +		       nid, sum_zone_node_page_state(nid, NR_KERNEL_SCS_BYTES) / 1024,
> > +#endif
> 
> Why not just use KB everywhere instead of repeated division by 1024?

This was to correctly calculate memory usage with shadow stacks <1024
bytes. I don't think we need that anymore, so I'll change this to _KB in
the next version.

Sami
