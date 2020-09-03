Return-Path: <kernel-hardening-return-19761-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 621A725CD65
	for <lists+kernel-hardening@lfdr.de>; Fri,  4 Sep 2020 00:20:34 +0200 (CEST)
Received: (qmail 15382 invoked by uid 550); 3 Sep 2020 22:20:29 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 14326 invoked from network); 3 Sep 2020 22:20:28 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dmzINT6p66dX/e1LULkP+IK8q8rhLoHpFzoaZ62doLA=;
        b=R+gBqR6jMnk+6oKx2tqu8pEQMa6B4rvdU39xncVxP9cYGjTvu9Y7E6/eDwL4d91aZg
         2AWd6bD1I8hpzfCMHWXyOEAUYG/ByrfmTjLvqStAtIQAudEBj+5PL2eVmUhWK1C7kkkn
         PbOlpfhNaxLGq78/VBxGKRETiCVBKzIIjWBQY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dmzINT6p66dX/e1LULkP+IK8q8rhLoHpFzoaZ62doLA=;
        b=k15sZ7tJ6NXSom5w3LR8UzH2tfReot1nJQUdoiW/9mDqW4oir6LJD/b/XLga5vJtit
         Ks4xiK+xQVV4U8L/aEahyCnWNyFi6zGqRbAJy6jJ/uqWNuagaUHzB6yrfF/43bAOP73k
         VUwOxeSummvvP6xDKqmMHf4uCJ+0Nu4PNDl79IxP3BodFYY6Fmj919SZUQhpDKSVYZHy
         U5x2xpa4m6lLJcIWu4qOYtD71UDreJBnNug15CBdtdh2ERUNsvr9JItvq7YzxTp5wPI+
         Hw2qw9ty5DyyxKn+w3PARPQtUnHtdr9Tr4KvatmQjQJ8fJMb10zmNYqfuuXqy7g9MdbO
         femg==
X-Gm-Message-State: AOAM533ktuGo/v3Kat4i8q0s40NGLCyFj9RCE1qU7K+HpK51WBGh23/5
	KQ0KlUrNIZaN49sH6GQB7Sa1iw==
X-Google-Smtp-Source: ABdhPJzvTlWSfXCMJbRcWCpKisPl6QUA4PdiAul/EgxhmyHEf/e8MtwNFLvtPo2Deh4MEaqWvcd6DQ==
X-Received: by 2002:a17:902:aa91:: with SMTP id d17mr5955717plr.27.1599171616614;
        Thu, 03 Sep 2020 15:20:16 -0700 (PDT)
Date: Thu, 3 Sep 2020 15:20:14 -0700
From: Kees Cook <keescook@chromium.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	x86@kernel.org
Subject: Re: [PATCH v2 12/28] kbuild: lto: limit inlining
Message-ID: <202009031520.DCF0B90B65@keescook>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200903203053.3411268-1-samitolvanen@google.com>
 <20200903203053.3411268-13-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903203053.3411268-13-samitolvanen@google.com>

On Thu, Sep 03, 2020 at 01:30:37PM -0700, Sami Tolvanen wrote:
> This change limits function inlining across translation unit boundaries
> in order to reduce the binary size with LTO. The -import-instr-limit
> flag defines a size limit, as the number of LLVM IR instructions, for
> importing functions from other TUs, defaulting to 100.
> 
> Based on testing with arm64 defconfig, we found that a limit of 5 is a
> reasonable compromise between performance and binary size, reducing the
> size of a stripped vmlinux by 11%.
> 
> Suggested-by: George Burgess IV <gbiv@google.com>
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
