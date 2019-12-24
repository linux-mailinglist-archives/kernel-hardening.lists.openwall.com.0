Return-Path: <kernel-hardening-return-17521-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id BCB07129E29
	for <lists+kernel-hardening@lfdr.de>; Tue, 24 Dec 2019 07:42:09 +0100 (CET)
Received: (qmail 6005 invoked by uid 550); 24 Dec 2019 06:41:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 5869 invoked from network); 24 Dec 2019 06:41:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=fm3; bh=031jmz6EBoYNU
	R3BaH2ZU2C1q/5jOCaWENRfD+QKc+Q=; b=P3aqrYxlqgqNLryt/+agi2lJE9MlC
	TVtsSGwzXhQiEB0ZupsOPcAjZ86hxSvVUccAOKqMOpwfMnduRBRj3QDXGhTMmmUS
	nvXt82ERRzVU9hA9QRw91KjwebFYoNNK3SCsVl+AM5cZTHX+DLqXlsCiksmFoUQG
	YCPTek/mQWs/+Qm8JDBvLmEmwgSsqmUGEQM+GFomYwd0TbuydOyYVkT+qnmAEnBI
	eexxu2sCnZWeM/uEts+UxVTh/2cmxEt0rPYoa5wTR+6zT2sJTKbCfNifBnazthlh
	ONJFNZBMMTH+KPzYXWmyzOt7SQ12smTrrCWaZqmuRRv18tkQI4YZcHZqg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:date:from
	:in-reply-to:message-id:mime-version:references:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; bh=031jmz6EBoYNUR3BaH2ZU2C1q/5jOCaWENRfD+QKc+Q=; b=b6cfNRNB
	tAiNoGF4zmFPw9I2vWAGbwM05+5KJWbItqyFoviB97OgAZBuMUKwsyq7BoyE+PTV
	BJl5ioCPxM0sLipxeXHR71huJ4rEcfsLNe8J5C5ox8t2WFblTONmg75SHn/3o8Gt
	Oxulcuh4R7AFx6srqEACnYGBdt10dSeFVhUxap+/yxy/b99tudRXew/q30qbIxwy
	xr8Rcp00RdTxjPG4GIrk48hIS2SLDAkFwLhsfN16vt1tTgIbssgl2kdsvC8a3fWV
	mj2vdhztSEfxsQmavqTMwJko2zOIP7dSJ3HLHE/PDnbqUV8LbhNqpRoI805mjzc8
	xX1WRy0rIEClOg==
X-ME-Sender: <xms:K7MBXnZptm4ht6QcHFc8F8l-_rXS0vHwjGHxcInYgjFDCKuOCKfqzg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddvuddgieelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdlfedtmdenucfjughrpefhvf
    fufffkofgjfhgggfestdekredtredttdenucfhrhhomheptfhushhsvghllhcuvehurhhr
    vgihuceorhhushgtuhhrsehruhhsshgvlhhlrdgttgeqnecukfhppeduvddvrdelledrke
    dvrddutdenucfrrghrrghmpehmrghilhhfrhhomheprhhushgtuhhrsehruhhsshgvlhhl
    rdgttgenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:K7MBXiNWZFBIIySvkHUai3cayvBSXca15ruMIfFX_X_ylc9EaFyj8w>
    <xmx:K7MBXlVYserwBLRsM55Cl6gQmyLUQvPCIOqAsvzvE7VgAFwjT8Ah1Q>
    <xmx:K7MBXnI36ZnGj5FOa9WlW-cWsihi85ln8vYxUGWnXuUKnDiFTFOqFA>
    <xmx:K7MBXntmEtYU4BTdzCUYk7JrgfE0tpXXZmYAtJMO46ygWY-4HWnShQ>
From: Russell Currey <ruscur@russell.cc>
To: linuxppc-dev@lists.ozlabs.org
Cc: ajd@linux.ibm.com,
	mpe@ellerman.id.au,
	christophe.leroy@c-s.fr,
	npiggin@gmail.com,
	kernel-hardening@lists.openwall.com,
	Russell Currey <ruscur@russell.cc>
Subject: [PATCH 2/2] powerpc: Remove STRICT_KERNEL_RWX incompatibility with RELOCATABLE
Date: Tue, 24 Dec 2019 17:41:26 +1100
Message-Id: <20191224064126.183670-2-ruscur@russell.cc>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191224064126.183670-1-ruscur@russell.cc>
References: <20191224064126.183670-1-ruscur@russell.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I have tested this with the Radix MMU and everything seems to work, and
the previous patch for Hash seems to fix everything too.
STRICT_KERNEL_RWX should still be disabled by default for now.

Please test STRICT_KERNEL_RWX + RELOCATABLE!

Signed-off-by: Russell Currey <ruscur@russell.cc>
---
 arch/powerpc/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 1ec34e16ed65..6093c48976bf 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -133,7 +133,7 @@ config PPC
 	select ARCH_HAS_PTE_SPECIAL
 	select ARCH_HAS_MEMBARRIER_CALLBACKS
 	select ARCH_HAS_SCALED_CPUTIME		if VIRT_CPU_ACCOUNTING_NATIVE && PPC_BOOK3S_64
-	select ARCH_HAS_STRICT_KERNEL_RWX	if ((PPC_BOOK3S_64 || PPC32) && !RELOCATABLE && !HIBERNATION)
+	select ARCH_HAS_STRICT_KERNEL_RWX	if ((PPC_BOOK3S_64 || PPC32) && !HIBERNATION)
 	select ARCH_HAS_TICK_BROADCAST		if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_HAS_UACCESS_FLUSHCACHE
 	select ARCH_HAS_UACCESS_MCSAFE		if PPC64
-- 
2.24.1

