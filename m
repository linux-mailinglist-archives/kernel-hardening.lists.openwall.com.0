Return-Path: <kernel-hardening-return-19722-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 23E7025CA60
	for <lists+kernel-hardening@lfdr.de>; Thu,  3 Sep 2020 22:31:40 +0200 (CEST)
Received: (qmail 17788 invoked by uid 550); 3 Sep 2020 20:31:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 17691 invoked from network); 3 Sep 2020 20:31:12 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=Zc5fOwGj6FL/BwQcVTQqN8jM5Y1jCC9q7imUTY2UKoE=;
        b=BNgE/Ex9wBp4RTaOYT8mdtmEp7DyxnUyA64Gm9ruatFkrcdqc2eXDv2SBkpzV/SseI
         Ki3DuyZGJhALAJwszdk0ZBZ1pQ8vmCyKnoTFNknw5SoXwls+Es/Yr+2jbtbvBVnoGnj8
         wb51PO0riE7ubBDGPD3WVLD53IIwK8xSSBTHkIL/vRbXOKemRUASuxtn86yFiw7uwgyu
         VdRwxCfj2fp7s1clcD1U+wOiTo5zcL2Qy4YStNGcFrXmpSLzJE/QCYFNgoi8suDp+DYi
         IqApOtPKmt3CggpahQVRrrVTxOaPmT0JNkLKvsP/fv2bcPHB6DRWdPx80LxodGa3iCNs
         flmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Zc5fOwGj6FL/BwQcVTQqN8jM5Y1jCC9q7imUTY2UKoE=;
        b=ihXmyLKcwfO38uVo7y1kAKA2LEURjPWzEa7MS0oXO3CazFcmTEfNfG8b7taU43TYA+
         L2J+y/BBIZwmxC+d6OT7Wh8/bZuec086admNO3C4eClr7PeUcB0zM3ldGADlwADkdHmD
         K0ygyaYBHAse+5erC4QTcoHj1UFukQDgu4MbKLFE/wWB8r/X3sbTfACW9S+UJvPaKAK4
         hA6Xx7teEnP5FI1wM1Pq9AQVFBg9tlksU+bSclboWMgcpL1u6AiFB7S4C9fRWdOHQAgh
         ND3Jdx/GPatCtJDnMmo+u2TfrhuqbiHY0acOxQxztDtPzalyj9dft8V/+TAIkFWOAdhS
         h45A==
X-Gm-Message-State: AOAM531pyCyQtyC6bCQnKkdfHF+Qn0HN2D5cEsH71scZRHXQyKgvZOIc
	FL/7an8HZe/n9QfUgXBfWOX7FmSq/dfshc62/8c=
X-Google-Smtp-Source: ABdhPJwOs38+ji6mAOwxoH65cFtoyaDjS9TPKHuyLwiR1Gojf0+6KETd30w6tAaklsU6u1xgAxbmUkeOrgiUoBMDkZ4=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a5b:30b:: with SMTP id
 j11mr5537716ybp.483.1599165060985; Thu, 03 Sep 2020 13:31:00 -0700 (PDT)
Date: Thu,  3 Sep 2020 13:30:28 -0700
In-Reply-To: <20200903203053.3411268-1-samitolvanen@google.com>
Message-Id: <20200903203053.3411268-4-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com> <20200903203053.3411268-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH v2 03/28] lib/string.c: implement stpcpy
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, 
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-pci@vger.kernel.org, x86@kernel.org, 
	Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Nick Desaulniers <ndesaulniers@google.com>

LLVM implemented a recent "libcall optimization" that lowers calls to
`sprintf(dest, "%s", str)` where the return value is used to
`stpcpy(dest, str) - dest`. This generally avoids the machinery involved
in parsing format strings.  `stpcpy` is just like `strcpy` except it
returns the pointer to the new tail of `dest`.  This optimization was
introduced into clang-12.

Implement this so that we don't observe linkage failures due to missing
symbol definitions for `stpcpy`.

Similar to last year's fire drill with:
commit 5f074f3e192f ("lib/string.c: implement a basic bcmp")

The kernel is somewhere between a "freestanding" environment (no full libc)
and "hosted" environment (many symbols from libc exist with the same
type, function signature, and semantics).

As H. Peter Anvin notes, there's not really a great way to inform the
compiler that you're targeting a freestanding environment but would like
to opt-in to some libcall optimizations (see pr/47280 below), rather than
opt-out.

Arvind notes, -fno-builtin-* behaves slightly differently between GCC
and Clang, and Clang is missing many __builtin_* definitions, which I
consider a bug in Clang and am working on fixing.

Masahiro summarizes the subtle distinction between compilers justly:
  To prevent transformation from foo() into bar(), there are two ways in
  Clang to do that; -fno-builtin-foo, and -fno-builtin-bar.  There is
  only one in GCC; -fno-buitin-foo.

(Any difference in that behavior in Clang is likely a bug from a missing
__builtin_* definition.)

Masahiro also notes:
  We want to disable optimization from foo() to bar(),
  but we may still benefit from the optimization from
  foo() into something else. If GCC implements the same transform, we
  would run into a problem because it is not -fno-builtin-bar, but
  -fno-builtin-foo that disables that optimization.

  In this regard, -fno-builtin-foo would be more future-proof than
  -fno-built-bar, but -fno-builtin-foo is still potentially overkill. We
  may want to prevent calls from foo() being optimized into calls to
  bar(), but we still may want other optimization on calls to foo().

It seems that compilers today don't quite provide the fine grain control
over which libcall optimizations pseudo-freestanding environments would
prefer.

Finally, Kees notes that this interface is unsafe, so we should not
encourage its use.  As such, I've removed the declaration from any
header, but it still needs to be exported to avoid linkage errors in
modules.

Reported-by: Sami Tolvanen <samitolvanen@google.com>
Suggested-by: Andy Lavr <andy.lavr@gmail.com>
Suggested-by: Arvind Sankar <nivedita@alum.mit.edu>
Suggested-by: Joe Perches <joe@perches.com>
Suggested-by: Masahiro Yamada <masahiroy@kernel.org>
Suggested-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Cc: stable@vger.kernel.org
Link: https://bugs.llvm.org/show_bug.cgi?id=47162
Link: https://bugs.llvm.org/show_bug.cgi?id=47280
Link: https://github.com/ClangBuiltLinux/linux/issues/1126
Link: https://man7.org/linux/man-pages/man3/stpcpy.3.html
Link: https://pubs.opengroup.org/onlinepubs/9699919799/functions/stpcpy.html
Link: https://reviews.llvm.org/D85963
---
 lib/string.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/lib/string.c b/lib/string.c
index 6012c385fb31..6bd0cf0fb009 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -272,6 +272,30 @@ ssize_t strscpy_pad(char *dest, const char *src, size_t count)
 }
 EXPORT_SYMBOL(strscpy_pad);
 
+/**
+ * stpcpy - copy a string from src to dest returning a pointer to the new end
+ *          of dest, including src's %NUL-terminator. May overrun dest.
+ * @dest: pointer to end of string being copied into. Must be large enough
+ *        to receive copy.
+ * @src: pointer to the beginning of string being copied from. Must not overlap
+ *       dest.
+ *
+ * stpcpy differs from strcpy in a key way: the return value is the new
+ * %NUL-terminated character. (for strcpy, the return value is a pointer to
+ * src. This interface is considered unsafe as it doesn't perform bounds
+ * checking of the inputs. As such it's not recommended for usage. Instead,
+ * its definition is provided in case the compiler lowers other libcalls to
+ * stpcpy.
+ */
+char *stpcpy(char *__restrict__ dest, const char *__restrict__ src);
+char *stpcpy(char *__restrict__ dest, const char *__restrict__ src)
+{
+	while ((*dest++ = *src++) != '\0')
+		/* nothing */;
+	return --dest;
+}
+EXPORT_SYMBOL(stpcpy);
+
 #ifndef __HAVE_ARCH_STRCAT
 /**
  * strcat - Append one %NUL-terminated string to another
-- 
2.28.0.402.g5ffc5be6b7-goog

