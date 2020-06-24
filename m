Return-Path: <kernel-hardening-return-19140-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 0A407207E76
	for <lists+kernel-hardening@lfdr.de>; Wed, 24 Jun 2020 23:27:57 +0200 (CEST)
Received: (qmail 28285 invoked by uid 550); 24 Jun 2020 21:27:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 28250 invoked from network); 24 Jun 2020 21:27:52 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=dcJg1Pmd9f78D6vA5vvd8lv5yiCcj7aT/KXUxx3p85w=; b=kW0Gs+LLCGSOFq3lO7r9YinA6h
	7xtahaSI1ma1wfxrkYodfw/iXU/zbFsJzgSO5Db8M5Kas3qE60Cck9uyn4jrjlZvm4WgRzqG9Ooo+
	jtCEqqSNm9W5tIGaN1elclBZcSfEZNv5jg8vAcfn+g1UJT8QHR4RwlPAuZfIuPNkOQap4e1qGfV0A
	cwt7PlLLvNImzMirpJd7/CDVC+M0Z9FaI9SC337TdLUSsHDB1EA/Z6q2MQrf71QVeEPDP0jb3OvhT
	EYDKEdVRjSgNUEKkA9mDDp6z8eth0zsksmz5WswtilA7uOUEs9S8I39JpTCT+viS29bezWW7uDl75
	mvKP2izA==;
Date: Wed, 24 Jun 2020 23:27:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	x86@kernel.org
Subject: Re: [PATCH 04/22] kbuild: lto: fix recordmcount
Message-ID: <20200624212737.GV4817@hirez.programming.kicks-ass.net>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200624203200.78870-5-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200624203200.78870-5-samitolvanen@google.com>

On Wed, Jun 24, 2020 at 01:31:42PM -0700, Sami Tolvanen wrote:
> With LTO, LLVM bitcode won't be compiled into native code until
> modpost_link. This change postpones calls to recordmcount until after
> this step.
> 
> In order to exclude specific functions from inspection, we add a new
> code section .text..nomcount, which we tell recordmcount to ignore, and
> a __nomcount attribute for moving functions to this section.

I'm confused, you only add this to functions in ftrace itself, which is
compiled with:

 KBUILD_CFLAGS = $(subst $(CC_FLAGS_FTRACE),,$(ORIG_CFLAGS))

and so should not have mcount/fentry sites anyway. So what's the point
of ignoring them further?

This Changelog does not explain.
