Return-Path: <kernel-hardening-return-18354-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 274DA19ADBC
	for <lists+kernel-hardening@lfdr.de>; Wed,  1 Apr 2020 16:22:37 +0200 (CEST)
Received: (qmail 32753 invoked by uid 550); 1 Apr 2020 14:22:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 32721 invoked from network); 1 Apr 2020 14:22:30 -0000
From: Slava Bacherikov <slava@bacher09.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bacher09.org;
	s=reg; t=1585750936;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6PA6evFBA3OhoMmMTkr0x/OR3XEpPNK02N3kYgs/0fY=;
	b=WHb2HyAqpVVozuh8wufIBqW+oj9uTdjbGnGsyEXPc7/TaCXQjFjLlFvyjWIWzbUeFHxjMJ
	MS+CV9sKgxO+0GYdsxZts5OAsRg+ujd1m5PkErXUf9f4ii1JfPdjUbg2Do8Z+tw3C35aCe
	C07xU6daqkxWfDHWpYGCzu4ZwMVyA+Q=
To: keescook@chromium.org
Cc: andriin@fb.com,
	bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jannh@google.com,
	alexei.starovoitov@gmail.com,
	daniel@iogearbox.net,
	kernel-hardening@lists.openwall.com,
	liuyd.fnst@cn.fujitsu.com,
	Slava Bacherikov <slava@bacher09.org>,
	KP Singh <kpsingh@google.com>
Subject: [PATCH v3 bpf] kbuild: fix dependencies for DEBUG_INFO_BTF
Date: Wed,  1 Apr 2020 17:20:58 +0300
Message-Id: <20200401142057.453892-1-slava@bacher09.org>
In-Reply-To: <202004010033.A1523890@keescook>
References: <202004010033.A1523890@keescook>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes

Currently turning on DEBUG_INFO_SPLIT when DEBUG_INFO_BTF is also
enabled will produce invalid btf file, since gen_btf function in
link-vmlinux.sh script doesn't handle *.dwo files.

Enabling DEBUG_INFO_REDUCED will also produce invalid btf file, and
using GCC_PLUGIN_RANDSTRUCT with BTF makes no sense.

Signed-off-by: Slava Bacherikov <slava@bacher09.org>
Reported-by: Jann Horn <jannh@google.com>
Reported-by: Liu Yiding <liuyd.fnst@cn.fujitsu.com>
Acked-by: KP Singh <kpsingh@google.com>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Fixes: e83b9f55448a ("kbuild: add ability to generate BTF type info for vmlinux")
---
 lib/Kconfig.debug | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index f61d834e02fe..b94227be2d62 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -222,7 +222,9 @@ config DEBUG_INFO_DWARF4
 
 config DEBUG_INFO_BTF
 	bool "Generate BTF typeinfo"
-	depends on DEBUG_INFO
+	depends on DEBUG_INFO || COMPILE_TEST
+	depends on !DEBUG_INFO_SPLIT && !DEBUG_INFO_REDUCED
+	depends on !GCC_PLUGIN_RANDSTRUCT || COMPILE_TEST
 	help
 	  Generate deduplicated BTF type information from DWARF debug info.
 	  Turning this on expects presence of pahole tool, which will convert
