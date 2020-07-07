Return-Path: <kernel-hardening-return-19226-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id D7F6E2174CB
	for <lists+kernel-hardening@lfdr.de>; Tue,  7 Jul 2020 19:12:09 +0200 (CEST)
Received: (qmail 29842 invoked by uid 550); 7 Jul 2020 17:12:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 24574 invoked from network); 7 Jul 2020 16:57:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594141014;
	bh=Pxamgvc2FYcqKzB/kO/K+pvItVmdREDTa9V2Uq/pm90=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=WfluW2mALu5v2u4IsB9+2+vbjc5luGQpkCpWji2UWyn5eJGKh2+w3PCRaCORF0/YN
	 +46mUvg1IPuLlsjfbJFei4Opj8gC35QmxI1XVnc0h/gl29judPMY7nyXTpvF+QwI80
	 oPi+MhkEYdPflHpFGc+lNEnz/Mg7+kCFEw68dC9I=
Date: Tue, 7 Jul 2020 09:56:51 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney"
 <paulmck@kernel.org>, Kees Cook <keescook@chromium.org>, Nick Desaulniers
 <ndesaulniers@google.com>, clang-built-linux
 <clang-built-linux@googlegroups.com>, Kernel Hardening
 <kernel-hardening@lists.openwall.com>, linux-arch
 <linux-arch@vger.kernel.org>, linux-arm-kernel
 <linux-arm-kernel@lists.infradead.org>, Linux Kbuild mailing list
 <linux-kbuild@vger.kernel.org>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org, X86 ML
 <x86@kernel.org>
Subject: Re: [PATCH 00/22] add support for Clang LTO
Message-ID: <20200707095651.422f0b22@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200707160528.GA1300535@google.com>
References: <20200624203200.78870-1-samitolvanen@google.com>
	<CAK7LNASvb0UDJ0U5wkYYRzTAdnEs64HjXpEUL7d=V0CXiAXcNw@mail.gmail.com>
	<20200629232059.GA3787278@google.com>
	<20200707155107.GA3357035@google.com>
	<20200707160528.GA1300535@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 7 Jul 2020 09:05:28 -0700 Sami Tolvanen wrote:
> On Tue, Jul 07, 2020 at 08:51:07AM -0700, Sami Tolvanen wrote:
> > After spending some time debugging this with Nick, it looks like the
> > error is caused by a recent optimization change in LLVM, which together
> > with the inlining of ur_load_imm_any into jeq_imm, changes a runtime
> > check in FIELD_FIT that would always fail, to a compile-time check that
> > breaks the build. In jeq_imm, we have:
> > 
> >     /* struct bpf_insn: _s32 imm */
> >     u64 imm = insn->imm; /* sign extend */
> >     ...
> >     if (imm >> 32) { /* non-zero only if insn->imm is negative */
> >     	/* inlined from ur_load_imm_any */
> > 	u32 __imm = imm >> 32; /* therefore, always 0xffffffff */
> > 
> >         /*
> > 	 * __imm has a value known at compile-time, which means
> > 	 * __builtin_constant_p(__imm) is true and we end up with
> > 	 * essentially this in __BF_FIELD_CHECK:
> > 	 */
> > 	if (__builtin_constant_p(__imm) && __imm <= 255)  
> 
> Should be __imm > 255, of course, which means the compiler will generate
> a call to __compiletime_assert.

I think FIELD_FIT() should not pass the value into __BF_FIELD_CHECK().

So:

diff --git a/include/linux/bitfield.h b/include/linux/bitfield.h
index 48ea093ff04c..4e035aca6f7e 100644
--- a/include/linux/bitfield.h
+++ b/include/linux/bitfield.h
@@ -77,7 +77,7 @@
  */
 #define FIELD_FIT(_mask, _val)                                         \
        ({                                                              \
-               __BF_FIELD_CHECK(_mask, 0ULL, _val, "FIELD_FIT: ");     \
+               __BF_FIELD_CHECK(_mask, 0ULL, 0ULL, "FIELD_FIT: ");     \
                !((((typeof(_mask))_val) << __bf_shf(_mask)) & ~(_mask)); \
        })
 
It's perfectly legal to pass a constant which does not fit, in which
case FIELD_FIT() should just return false not break the build.

Right?
