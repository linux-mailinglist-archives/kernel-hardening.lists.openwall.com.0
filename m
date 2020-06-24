Return-Path: <kernel-hardening-return-19129-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 5B924207D78
	for <lists+kernel-hardening@lfdr.de>; Wed, 24 Jun 2020 22:36:26 +0200 (CEST)
Received: (qmail 3756 invoked by uid 550); 24 Jun 2020 20:33:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3657 invoked from network); 24 Jun 2020 20:33:48 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=vVvCAj3rXahkiTyB3fdf4JdbPFhKMTMNyBg/koJzOHM=;
        b=A1OVxmohREiIQE9uWobns3DZjU2BjnF5/uRv4vfcaF2sodOxkh4sxle+6JGl3ADtOZ
         3fmTbkzX8W7ahG1bTGpXMMU9CdKC8UZUye2VucpEx7325i3QESTUcI83ndSOc6E8Kmzu
         N5PlhLkCWO4j4sIvQEk9eacQtD+bX2UY3Y5a4I1dsdat2Jm3e0YTj4ppvoCyl2YlPdbY
         ZyEZAXO2uSqBN9R05BjPoqjam4RsnD1PfD+i8NAuT2L+OMarD3RxLispCXwkir37c5B5
         L+Lu+ZWTjo7NmJwPgVCLx0NgAf7Qq1Qws+DG9FZOXnsn8vOlmmibTipSbU4GNNmhC8bb
         0u7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=vVvCAj3rXahkiTyB3fdf4JdbPFhKMTMNyBg/koJzOHM=;
        b=lqeVIZXChy6tyJT7ibfzwom1PjsZxqpjfewVgyL5KqOvHjxBjwqPWK7FHF1NSfQBpU
         dxnJ0d4PVIbVH9lxrNL139Wxr2MbYPvmfUad5bRmZQvYM9RvIPuvxu0zauSCTO10HDe0
         ZR6yR+NOcnS22zdpo72hncBX9qI9YviMOYFBBDIWYNNtDO1qqXg7OfhHrawzkyBOC3RN
         5YPpC/uhgCbeo76V7xKZ96CivbIecIsbCntxi9UWqZGTvS2cdErd4Rd7ATxwEKpqcHBq
         BpqikUYFMfZCm/y1apI/v5EZVO98AQFeahkRpyPWEdvnC63vbvr48wpYDYwmZc2XMXAi
         YyUA==
X-Gm-Message-State: AOAM531k+Ocutm+tliS84cTHRtm8yravoz1PRtamI3sEMLQMZINN2h/K
	uhkGkVGPhcy8EuNTaSsq6ItpbDsK+B47oS+6sFs=
X-Google-Smtp-Source: ABdhPJxFwd5sYHcpKP7HH5wq1l18/N0yS86uUmxUS0eTeAHpLUaXB5pBxjwc02CZmZmfKSgokc5xwqXiDOu/w8PP8nk=
X-Received: by 2002:a25:7450:: with SMTP id p77mr23380392ybc.155.1593030816256;
 Wed, 24 Jun 2020 13:33:36 -0700 (PDT)
Date: Wed, 24 Jun 2020 13:31:59 -0700
In-Reply-To: <20200624203200.78870-1-samitolvanen@google.com>
Message-Id: <20200624203200.78870-22-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
Subject: [PATCH 21/22] x86, relocs: Ignore L4_PAGE_OFFSET relocations
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, 
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-pci@vger.kernel.org, x86@kernel.org, 
	Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

L4_PAGE_OFFSET is a constant value, so don't warn about absolute
relocations.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 arch/x86/tools/relocs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/tools/relocs.c b/arch/x86/tools/relocs.c
index ce7188cbdae5..8f3bf34840ce 100644
--- a/arch/x86/tools/relocs.c
+++ b/arch/x86/tools/relocs.c
@@ -47,6 +47,7 @@ static const char * const sym_regex_kernel[S_NSYMTYPES] = {
 	[S_ABS] =
 	"^(xen_irq_disable_direct_reloc$|"
 	"xen_save_fl_direct_reloc$|"
+	"L4_PAGE_OFFSET|"
 	"VDSO|"
 	"__crc_)",
 
-- 
2.27.0.212.ge8ba1cc988-goog

