Return-Path: <kernel-hardening-return-15971-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 6E1F22443D
	for <lists+kernel-hardening@lfdr.de>; Tue, 21 May 2019 01:22:45 +0200 (CEST)
Received: (qmail 5120 invoked by uid 550); 20 May 2019 23:20:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 4011 invoked from network); 20 May 2019 23:20:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UAWq/U5Cl0xown3M4zRB/+A5GL/fjUvY6epXW6tZYg8=;
        b=G0HLUh6e5TXicptzdHaHOv99joSx3699BQ8oyB/a0rkjhYW7ff2j5Ih3DdY0sE2cQQ
         KhjhgRjPCPS1V8fXDvwbrPnkCGW/mVdHN6Ttl77xBMR/BZADsnAvSEtUZOsfEC6E6IUX
         AyND8sQeuZOujIQL/Ec8EEinbyM55WevZVORQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UAWq/U5Cl0xown3M4zRB/+A5GL/fjUvY6epXW6tZYg8=;
        b=bWwveAfx5UR6Nh8zehaTOTLHKuJmhb2c/avQWCk91WujUCJXwOvYMMh9TjaR1v2mMk
         EmrM+fe9hjkoryL2xtD8To+tBdlRLf9gyVEvP+/Y1ABW5kMQWFGFAjqxfgJDrpGlGsXa
         9fZ/dZNJsN0P4q/Ykdct/2s1Uh702HJZU1zFpJ2N0vhJ2GrHc3o6MaAnjlUld5mA6t7q
         qY7SI4Kn4JuACk0Od6CmCrOAS9HN2PxBApwA8y0VHZLoModrZiL2PvtQoWsLR3K7y+wV
         xKJF2O6xn9sl5YkqP7gnDlg0XfFLpW2srxyDC2o8XIsvMaORn1IErZY7SH3AdjL41qLA
         T79w==
X-Gm-Message-State: APjAAAUIvm+3y+bxshlunVg7bueMYSeymNWO1qu2cW/oDJsIReU4PFk1
	VMo2ck4IPSrFfSPhOQXC6lHfVmbzb6Y=
X-Google-Smtp-Source: APXvYqxuu3FAJVEvYAXGWouOaAg7HLWlZ4XubtLPm7DBKhdz9pXfHrYPG/mUBKLkmdSNklZAcrdxLA==
X-Received: by 2002:a17:902:6bc4:: with SMTP id m4mr2396808plt.266.1558394422567;
        Mon, 20 May 2019 16:20:22 -0700 (PDT)
From: Thomas Garnier <thgarnie@chromium.org>
To: kernel-hardening@lists.openwall.com
Cc: kristen@linux.intel.com,
	Thomas Garnier <thgarnie@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Nadav Amit <namit@vmware.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v7 12/12] x86/alternatives: Adapt assembly for PIE support
Date: Mon, 20 May 2019 16:19:37 -0700
Message-Id: <20190520231948.49693-13-thgarnie@chromium.org>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
In-Reply-To: <20190520231948.49693-1-thgarnie@chromium.org>
References: <20190520231948.49693-1-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Thomas Garnier <thgarnie@google.com>

Change the assembly options to work with pointers instead of integers.

Position Independent Executable (PIE) support will allow to extend the
KASLR randomization range below 0xffffffff80000000.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
 arch/x86/include/asm/alternative.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 094fbc9c0b1c..28a838106e5f 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -243,7 +243,7 @@ static inline int alternatives_text_reserved(void *start, void *end)
 /* Like alternative_io, but for replacing a direct call with another one. */
 #define alternative_call(oldfunc, newfunc, feature, output, input...)	\
 	asm volatile (ALTERNATIVE("call %P[old]", "call %P[new]", feature) \
-		: output : [old] "i" (oldfunc), [new] "i" (newfunc), ## input)
+		: output : [old] "X" (oldfunc), [new] "X" (newfunc), ## input)
 
 /*
  * Like alternative_call, but there are two features and respective functions.
@@ -256,8 +256,8 @@ static inline int alternatives_text_reserved(void *start, void *end)
 	asm volatile (ALTERNATIVE_2("call %P[old]", "call %P[new1]", feature1,\
 		"call %P[new2]", feature2)				      \
 		: output, ASM_CALL_CONSTRAINT				      \
-		: [old] "i" (oldfunc), [new1] "i" (newfunc1),		      \
-		  [new2] "i" (newfunc2), ## input)
+		: [old] "X" (oldfunc), [new1] "X" (newfunc1),		      \
+		  [new2] "X" (newfunc2), ## input)
 
 /*
  * use this macro(s) if you need more than one output parameter
-- 
2.21.0.1020.gf2820cf01a-goog

