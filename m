Return-Path: <kernel-hardening-return-20207-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 4C06628E8E1
	for <lists+kernel-hardening@lfdr.de>; Thu, 15 Oct 2020 00:47:19 +0200 (CEST)
Received: (qmail 5281 invoked by uid 550); 14 Oct 2020 22:47:14 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 5260 invoked from network); 14 Oct 2020 22:47:13 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1ZkeuWYx0x8NcK97W3bc1qXSyhy0ywO9Zu1gztVJSpU=;
        b=WE3ire40GLinUOppIi7ZcbOVETm0WyX7RLx7xCaymADCWSNOR8y2/RwcPtSnft1aFu
         0ChZJ7ygTGlmsX8EVM6bGmei1Zx5q2bj0yebVv+SOHsAiV0uEn+oar9jyVds8dZOPeFt
         NDilDA6BdcrnvpJnue+wzGel9tWEzsFUzutQ0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1ZkeuWYx0x8NcK97W3bc1qXSyhy0ywO9Zu1gztVJSpU=;
        b=Y7WkNFrBfLZwalQejAtlOYAddynAAO1qA+L3ahobw0xoUKmv3sbgGwCKE9k5cn5Bzs
         2nRuC3JbBQ1+Ust85ABO1Nyp/wGGOcC6FxYBZt2H68l9Eg5wztwqxcg3WC83xZ87YQoA
         j+4iTHcjU1sZDXu71GVwUFFn8OgtjT729O3IzZfHq+/ZLUFsbdcn8vclGDl4Nu+d+wSn
         9n7xE684J8e4snN+XCitUoeBudBUlQt5tUuqdjk7fe0G7DIDs7hF4663UqBgRNaXplSs
         +aBMjvd5432xnr/jD7D20DNP5QdJ3JiZ9Mqhrwy2oXuMFDeKaQkVBZHLghn45uUl2wl+
         9ClA==
X-Gm-Message-State: AOAM531gpepi3FfUUAV1e2TccT77JVH3P116in/jqv6KOoixeZQTR1kL
	3AUIlmscr1BZ2QVp6DX3ZvOs8A==
X-Google-Smtp-Source: ABdhPJw7BSKlM7cAv8r7/0jhJx32xhaKYpzsb2RiBeH0xy7bNtYmDuLkURklLKzHhQnxbTes9rTU2A==
X-Received: by 2002:a17:90a:f0ca:: with SMTP id fa10mr1313834pjb.130.1602715621497;
        Wed, 14 Oct 2020 15:47:01 -0700 (PDT)
Date: Wed, 14 Oct 2020 15:46:59 -0700
From: Kees Cook <keescook@chromium.org>
To: Thomas Gleixner <tglx@linutronix.de>,
	Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	x86@kernel.org
Subject: Re: [PATCH v6 22/25] x86/asm: annotate indirect jumps
Message-ID: <202010141545.1E2A393C62@keescook>
References: <20201013003203.4168817-1-samitolvanen@google.com>
 <20201013003203.4168817-23-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201013003203.4168817-23-samitolvanen@google.com>

On Mon, Oct 12, 2020 at 05:32:00PM -0700, Sami Tolvanen wrote:
> Running objtool --vmlinux --duplicate on vmlinux.o produces a few
> warnings about indirect jumps with retpoline:
> 
>   vmlinux.o: warning: objtool: wakeup_long64()+0x61: indirect jump
>   found in RETPOLINE build
>   ...
> 
> This change adds ANNOTATE_RETPOLINE_SAFE annotations to the jumps
> in assembly code to stop the warnings.
> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

This looks like it's an independent fix -- can an x86 maintainer pick
up this patch directly?

-- 
Kees Cook
