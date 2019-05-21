Return-Path: <kernel-hardening-return-15973-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id BBACA24638
	for <lists+kernel-hardening@lfdr.de>; Tue, 21 May 2019 05:13:56 +0200 (CEST)
Received: (qmail 24292 invoked by uid 550); 21 May 2019 03:13:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 24274 invoked from network); 21 May 2019 03:13:49 -0000
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com x4L3D2bH2993928
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2019051801; t=1558408387;
	bh=aiRlJguT2uUGYCs0b9eGTl9PzBot2H8W+Hal5KY2RqE=;
	h=Date:In-Reply-To:References:Subject:To:CC:From:From;
	b=ko1F5kNq5n1OHIo6F0Zc2qrfDqkUvuRQWq9C5/+EaUAE/m1EeM5WJu+m0+utA6TK3
	 Ft9kkLJbq1ckQkwevWJA3WrvpJpy4PyivMqzM9C3R3Vmo5GXsksuj6qEG2+db/apqQ
	 BBGSdtNO/SHn6wPEBb0sf6jOQJ6ofU+VmbsGgoTjJmSrkyHWgFP9EScizv1jYeiPHL
	 Ibb8Upegp3dk3mWDtAwsuMXDhgT2zSYt+yUyjN6nQLJIuoYdtSkoJsbb2Et8gPjfFF
	 4Zu/M78BlTbtuw1tCd8I5C+kqt/N55WKncdKA2pi53se74qg0kIvXwGk9JMqGqDylC
	 YMgUtr60m94iQ==
Date: Mon, 20 May 2019 20:12:55 -0700
User-Agent: K-9 Mail for Android
In-Reply-To: <20190520231948.49693-4-thgarnie@chromium.org>
References: <20190520231948.49693-1-thgarnie@chromium.org> <20190520231948.49693-4-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v7 03/12] x86: Add macro to get symbol address for PIE support
To: Thomas Garnier <thgarnie@chromium.org>,
        kernel-hardening@lists.openwall.com
CC: kristen@linux.intel.com, Thomas Garnier <thgarnie@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Nadav Amit <namit@vmware.com>,
        Jann Horn <jannh@google.com>, linux-kernel@vger.kernel.org
From: hpa@zytor.com
Message-ID: <FF111368-9173-4AC2-9A79-E79A52B104DD@zytor.com>

On May 20, 2019 4:19:28 PM PDT, Thomas Garnier <thgarnie@chromium=2Eorg> wr=
ote:
>From: Thomas Garnier <thgarnie@google=2Ecom>
>
>Add a new _ASM_MOVABS macro to fetch a symbol address=2E It will be used
>to replace "_ASM_MOV $<symbol>, %dst" code construct that are not
>compatible with PIE=2E
>
>Signed-off-by: Thomas Garnier <thgarnie@google=2Ecom>
>---
> arch/x86/include/asm/asm=2Eh | 1 +
> 1 file changed, 1 insertion(+)
>
>diff --git a/arch/x86/include/asm/asm=2Eh b/arch/x86/include/asm/asm=2Eh
>index 3ff577c0b102=2E=2E3a686057e882 100644
>--- a/arch/x86/include/asm/asm=2Eh
>+++ b/arch/x86/include/asm/asm=2Eh
>@@ -30,6 +30,7 @@
> #define _ASM_ALIGN	__ASM_SEL(=2Ebalign 4, =2Ebalign 8)
>=20
> #define _ASM_MOV	__ASM_SIZE(mov)
>+#define _ASM_MOVABS	__ASM_SEL(movl, movabsq)
> #define _ASM_INC	__ASM_SIZE(inc)
> #define _ASM_DEC	__ASM_SIZE(dec)
> #define _ASM_ADD	__ASM_SIZE(add)

This is just about *always* wrong on x86-86=2E We should be using leaq sym=
(%rip),%reg=2E If it isn't reachable by leaq, then it is a non-PIE symbol l=
ike percpu=2E You do have to keep those distinct!
--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
