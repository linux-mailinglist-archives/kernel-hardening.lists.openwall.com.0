Return-Path: <kernel-hardening-return-18002-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id D6CD0172CC1
	for <lists+kernel-hardening@lfdr.de>; Fri, 28 Feb 2020 01:03:15 +0100 (CET)
Received: (qmail 23878 invoked by uid 550); 28 Feb 2020 00:01:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 23764 invoked from network); 28 Feb 2020 00:01:40 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Oz6De1dIYEgjxhRabTRk4CB78qRzDNYlR7Nzf0r7zm8=;
        b=Ej0qYQRkax6vt9VbEqKCxSCRfVTpbF6R6yfkIQH8hH+HCk4aampkSCQAJSBx/l3Eul
         QYdGcYFrpkp7QbTQ9dqQZFDOh3Tk90FzGpRVXkXIXRjJeG0HLpM37JMU0ecBnf624Z4b
         p9gSB349m5UGPUQTt7tNnLStSo1C536+EubDM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Oz6De1dIYEgjxhRabTRk4CB78qRzDNYlR7Nzf0r7zm8=;
        b=IRhCAKXHWbZzJ/SnEBZQADMkTosk7fjlyxtsUObXkQORK8jrmRp87kBEo4TBoWy5R9
         3nJMPu1sEzmS4W3JY/9zLa9jlVhOnfe0Exa4MlJxeUqyBPiQLFjjBxbCF+3LkDaycQzl
         LwAHQEFrQmhlA2kOmRDHMDoIFnvWq4iYUdghCGGoHxIFVS9FoDvxhQ3kp+wFStldnhZ/
         g5Abps1deIPWY1H7FY3rBS4yGtXkPVKbg2ww9iuRVVosKr9wp6gpqbil7v37cRlyjVAN
         40tUMSyKFaeW0Lbnt+VpqVyC03UDrI5XKqSgjzUOZDdsTce7ehzR6B/Gl2ngsVr+Kckm
         sbMA==
X-Gm-Message-State: APjAAAVUVXMKm45L2kpOHf/Jfr6dpOMgNgNIsm/bsRnJ61EATULHSlde
	NmdFDgPmZDlKdNcMpbAMrKR8MyZ1pyA=
X-Google-Smtp-Source: APXvYqyeGsdTWhXYKAUlxHWjZxN7BX3EeYNWjLkfclN9Kp12cCBJnK2qIKd/H/GKqRV9XMIxr86Wng==
X-Received: by 2002:a17:90a:868b:: with SMTP id p11mr1609353pjn.60.1582848088646;
        Thu, 27 Feb 2020 16:01:28 -0800 (PST)
From: Thomas Garnier <thgarnie@chromium.org>
To: kernel-hardening@lists.openwall.com
Cc: kristen@linux.intel.com,
	keescook@chromium.org,
	Thomas Garnier <thgarnie@chromium.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Peter Zijlstra <peterz@infradead.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v11 11/11] x86/alternatives: Adapt assembly for PIE support
Date: Thu, 27 Feb 2020 16:00:56 -0800
Message-Id: <20200228000105.165012-12-thgarnie@chromium.org>
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
In-Reply-To: <20200228000105.165012-1-thgarnie@chromium.org>
References: <20200228000105.165012-1-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Change the assembly options to work with pointers instead of integers.
The generated code is the same PIE just ensures input is a pointer.

Signed-off-by: Thomas Garnier <thgarnie@chromium.org>
---
 arch/x86/include/asm/alternative.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 13adca37c99a..43a148042656 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -243,7 +243,7 @@ static inline int alternatives_text_reserved(void *start, void *end)
 /* Like alternative_io, but for replacing a direct call with another one. */
 #define alternative_call(oldfunc, newfunc, feature, output, input...)	\
 	asm_inline volatile (ALTERNATIVE("call %P[old]", "call %P[new]", feature) \
-		: output : [old] "i" (oldfunc), [new] "i" (newfunc), ## input)
+		: output : [old] "X" (oldfunc), [new] "X" (newfunc), ## input)
 
 /*
  * Like alternative_call, but there are two features and respective functions.
@@ -256,8 +256,8 @@ static inline int alternatives_text_reserved(void *start, void *end)
 	asm_inline volatile (ALTERNATIVE_2("call %P[old]", "call %P[new1]", feature1,\
 		"call %P[new2]", feature2)				      \
 		: output, ASM_CALL_CONSTRAINT				      \
-		: [old] "i" (oldfunc), [new1] "i" (newfunc1),		      \
-		  [new2] "i" (newfunc2), ## input)
+		: [old] "X" (oldfunc), [new1] "X" (newfunc1),		      \
+		  [new2] "X" (newfunc2), ## input)
 
 /*
  * use this macro(s) if you need more than one output parameter
-- 
2.25.1.481.gfbce0eb801-goog

