Return-Path: <kernel-hardening-return-20467-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 2A97A2C8388
	for <lists+kernel-hardening@lfdr.de>; Mon, 30 Nov 2020 12:52:49 +0100 (CET)
Received: (qmail 32627 invoked by uid 550); 30 Nov 2020 11:52:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 32607 invoked from network); 30 Nov 2020 11:52:40 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1606737148;
	bh=ZiZagQtRbUz77A0qHJ/6d4tgOyHKNO+y3elnQs2W+xw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MnNpDy1IneXFXP/lQupOBnMLxBRe5aJE3S3AeMbB5b0qt3ZR65WOmJaShZf3bd0Xx
	 wt8jX8yj5HEw/l01qC8cRnrqIuZ7ah7LMJfsVUDMV4xuXzrh4/7bKTGlnvKmeAcGnj
	 WiTprgJ8Vio2K37i3mmw4xbiu/TLHBswxaM7XYfk=
Date: Mon, 30 Nov 2020 11:52:22 +0000
From: Will Deacon <will@kernel.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v7 14/17] arm64: vdso: disable LTO
Message-ID: <20201130115222.GC24563@willie-the-truck>
References: <20201118220731.925424-1-samitolvanen@google.com>
 <20201118220731.925424-15-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201118220731.925424-15-samitolvanen@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, Nov 18, 2020 at 02:07:28PM -0800, Sami Tolvanen wrote:
> Disable LTO for the vDSO by filtering out CC_FLAGS_LTO, as there's no
> point in using link-time optimization for the small about of C code.

"about" => "amount" ?

> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> ---
>  arch/arm64/kernel/vdso/Makefile | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

With the typo fixed:

Acked-by: Will Deacon <will@kernel.org>

Will
