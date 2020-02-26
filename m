Return-Path: <kernel-hardening-return-17965-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id F3617170ADA
	for <lists+kernel-hardening@lfdr.de>; Wed, 26 Feb 2020 22:50:59 +0100 (CET)
Received: (qmail 14200 invoked by uid 550); 26 Feb 2020 21:50:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 14162 invoked from network); 26 Feb 2020 21:50:53 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bVvtoF3dBwjUAYtU4MtEeTRU2gPLqCEKNNfUILCYJ2w=;
        b=ovFUiiOjUNXm43f9hWvoiPzifhXFcP6b+mP+nXDstTA+zT2SxPQxhwqxWHjomDOX4q
         6iRxXcQbIFlmwKnJVFmcXoAqAbpjcC6eX0F+FBnEXSAzyIPkmIHIok+O1CxgDiXwzNAh
         ovDkIzGs4bElZpTw1UxxcsiRisDeW5/rcQ6OkWbhrJEnQHvn/qchtOfjgIyWY7CPqrtv
         gvQPWMYDN9PdH1B7HH2SuJrbI7818c/vfij7NcOZo+RQD1W0j2A5vEId4z+b08TzV5mi
         n3yazdPMgYwRftBBLyOJT9IjhLDhtbu3ctwK3lD9fayA9KyyOhjDQrpXHeeQ2E9hNlK1
         o93g==
X-Gm-Message-State: APjAAAX7U+/fBBX9N2+07jOGDMzN5i2tUJaHFUvv1b+06jwUIPbFAmRo
	MxsUExLJuB9NzkJOG5D0cXc=
X-Google-Smtp-Source: APXvYqx8UV8YjcThLwuE4pseSIhWF+wgUfrcRuFfFy2RgtZSG7vFhqozsjyBFIY3a73ZGyacvn9lUA==
X-Received: by 2002:a37:4e97:: with SMTP id c145mr1416125qkb.253.1582753841181;
        Wed, 26 Feb 2020 13:50:41 -0800 (PST)
From: Arvind Sankar <nivedita@alum.mit.edu>
To: "Tobin C . Harding" <me@tobin.cc>,
	Tycho Andersen <tycho@tycho.ws>
Cc: kernel-hardening@lists.openwall.com,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] x86/mm/init_32: Don't print out kernel memory layout if KASLR
Date: Wed, 26 Feb 2020 16:50:39 -0500
Message-Id: <20200226215039.2842351-1-nivedita@alum.mit.edu>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For security, only show the virtual kernel memory layout if KASLR is
disabled.

Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
---
 arch/x86/mm/init_32.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 23df4885bbed..53635be69102 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -788,6 +788,10 @@ void __init mem_init(void)
 	x86_init.hyper.init_after_bootmem();
 
 	mem_init_print_info(NULL);
+
+	if (kaslr_enabled())
+		goto skip_layout;
+
 	printk(KERN_INFO "virtual kernel memory layout:\n"
 		"    fixmap  : 0x%08lx - 0x%08lx   (%4ld kB)\n"
 		"  cpu_entry : 0x%08lx - 0x%08lx   (%4ld kB)\n"
@@ -827,6 +831,7 @@ void __init mem_init(void)
 		(unsigned long)&_text, (unsigned long)&_etext,
 		((unsigned long)&_etext - (unsigned long)&_text) >> 10);
 
+skip_layout:
 	/*
 	 * Check boundaries twice: Some fundamental inconsistencies can
 	 * be detected at build time already.
-- 
2.24.1

