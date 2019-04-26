Return-Path: <kernel-hardening-return-15843-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 0FB8EB2F9
	for <lists+kernel-hardening@lfdr.de>; Sat, 27 Apr 2019 08:48:52 +0200 (CEST)
Received: (qmail 6111 invoked by uid 550); 27 Apr 2019 06:43:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 5983 invoked from network); 27 Apr 2019 06:43:50 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=TdxUBqKvjD04gvlVW2fqTrr9rgpG7ttN99ifXgy4wJ0=;
        b=fTkRQ/Y6ekEQNK89awlPXt7h4NxMjoecNBAMoo9ta42p80ijXkGhM1UL/BQmQFyWo6
         LJfDPrdOvXO5UvSlwALV9jzgVbZ3dPkOetjmwgngrd6Xv4mjhDuVn4pVdt7q+ACp200R
         xHDNjHe63z2eq8GDtYLwE09uCfrsylk7ZaSgnWZyDkP/bBrVBZQ5DR2PNo0INMO0nJJB
         A8319czkJRDzqjy/YpDHiQ5QMkoO+Q0Ds/GWZq+ooXRPBqH7Yybl6d/xzosC6sOQZDv0
         Hev5YYonTqwLdIPLk/p3TqQ3UvgcH8BaYIQHch4ej87FxDr5lyTtZXPQ+va/opGvDk71
         04vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=TdxUBqKvjD04gvlVW2fqTrr9rgpG7ttN99ifXgy4wJ0=;
        b=PuhGYb1CxO1LqqhnkkUlNAtnW10uzSHwaE6U7aZ5iIN8qczbgjLmHe2jBTMgb2JAuy
         o/pMgGJUFS092CiGkIqmxGjM1QBxrwGyvN7ZXs5kfY0QaLITs5EsxsdxGs16jDP8obEv
         gQ53g74Q09OjXZyhZKs3cqL4xmEiwTzq0TJKwi7ySV8xcCeEP6GL1tUyvxod94bM8B4c
         9xP8YB2Hoz6qXWeQeDp/O6v7/9y2zmV6y/+H1FZYE+prxhO8YLKls0Y0GlZ5Q4jCTx6z
         mcP8SVEDryLqJiJBOSh/YbWkHfCjBS8Z0A4iAcdCOgiwmSnHNG9wAs0AaBWtHy79HUN/
         S9MQ==
X-Gm-Message-State: APjAAAUoAZx3LhD8q/NjQaQ/N+lm0GNBSOyWaXUf0MNSuFwHHAQWfOtl
	srvzVhyYgLKiCx4iZD4VcDQ=
X-Google-Smtp-Source: APXvYqwkqefi+5wlFbKz/qeJ/65fu9i/qlczB3LZREQFaY/+lFjrw+S/8uXGcd/aBtDXpy5vBsJ5Xg==
X-Received: by 2002:a17:902:b715:: with SMTP id d21mr50699394pls.103.1556347418251;
        Fri, 26 Apr 2019 23:43:38 -0700 (PDT)
From: nadav.amit@gmail.com
To: Peter Zijlstra <peterz@infradead.org>,
	Borislav Petkov <bp@alien8.de>,
	Andy Lutomirski <luto@kernel.org>,
	Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	hpa@zytor.com,
	Thomas Gleixner <tglx@linutronix.de>,
	Nadav Amit <nadav.amit@gmail.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	linux_dti@icloud.com,
	linux-integrity@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	akpm@linux-foundation.org,
	kernel-hardening@lists.openwall.com,
	linux-mm@kvack.org,
	will.deacon@arm.com,
	ard.biesheuvel@linaro.org,
	kristen@linux.intel.com,
	deneen.t.dock@intel.com,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Nadav Amit <namit@vmware.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH v6 24/24] bpf: Fail bpf_probe_write_user() while mm is switched
Date: Fri, 26 Apr 2019 16:23:03 -0700
Message-Id: <20190426232303.28381-25-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190426232303.28381-1-nadav.amit@gmail.com>
References: <20190426232303.28381-1-nadav.amit@gmail.com>

From: Nadav Amit <namit@vmware.com>

When using a temporary mm, bpf_probe_write_user() should not be able to
write to user memory, since user memory addresses may be used to map
kernel memory.  Detect these cases and fail bpf_probe_write_user() in
such cases.

Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Alexei Starovoitov <ast@kernel.org>
Reported-by: Jann Horn <jannh@google.com>
Suggested-by: Jann Horn <jannh@google.com>
Signed-off-by: Nadav Amit <namit@vmware.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 kernel/trace/bpf_trace.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index d64c00afceb5..94b0e37d90ef 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -14,6 +14,8 @@
 #include <linux/syscalls.h>
 #include <linux/error-injection.h>
 
+#include <asm/tlb.h>
+
 #include "trace_probe.h"
 #include "trace.h"
 
@@ -163,6 +165,10 @@ BPF_CALL_3(bpf_probe_write_user, void *, unsafe_ptr, const void *, src,
 	 * access_ok() should prevent writing to non-user memory, but in
 	 * some situations (nommu, temporary switch, etc) access_ok() does
 	 * not provide enough validation, hence the check on KERNEL_DS.
+	 *
+	 * nmi_uaccess_okay() ensures the probe is not run in an interim
+	 * state, when the task or mm are switched. This is specifically
+	 * required to prevent the use of temporary mm.
 	 */
 
 	if (unlikely(in_interrupt() ||
@@ -170,6 +176,8 @@ BPF_CALL_3(bpf_probe_write_user, void *, unsafe_ptr, const void *, src,
 		return -EPERM;
 	if (unlikely(uaccess_kernel()))
 		return -EPERM;
+	if (unlikely(!nmi_uaccess_okay()))
+		return -EPERM;
 	if (!access_ok(unsafe_ptr, size))
 		return -EPERM;
 
-- 
2.17.1

