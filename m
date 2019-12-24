Return-Path: <kernel-hardening-return-17518-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 33366129DF7
	for <lists+kernel-hardening@lfdr.de>; Tue, 24 Dec 2019 06:56:46 +0100 (CET)
Received: (qmail 21956 invoked by uid 550); 24 Dec 2019 05:56:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 21867 invoked from network); 24 Dec 2019 05:56:17 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=fm3; bh=iBR0oQDDjQO6Y
	Gl4XkS1WHXbmGR1LldgL5SE2D45VZ8=; b=S4Zlhh/DMWIu3RBFXKAJEZoLpOUz6
	zNcsQHS6x/eOYYJ+0B7vTXL79+S9pTZG3tnAxW3r7TORPtlCF4bbu/+iFNgG1WY2
	VnDDf0+vHvENtXN16uCQiLqpCgU6nAhJ0vPnNX1uIsHtDBNH1TyQTBuC0puR5bwE
	YTN9wB26mTQ1JEA9KdTeUr56cEszq2XbnUUsSuhNbyoDK3sJ3DE4zuxbzV4KmygY
	QGABM73ytLQiGxXFzwQwdffQOoSzEqywNM0NZa6FhsJAOjUafbY+Anr8HVPQ1+uE
	4uRPI43Go4J/78xM+X2ur5mBFH327fnEOBaCf1qlXTiJgeg6YRJrlXoFg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:date:from
	:in-reply-to:message-id:mime-version:references:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; bh=iBR0oQDDjQO6YGl4XkS1WHXbmGR1LldgL5SE2D45VZ8=; b=K15uznEx
	FjNaTkcMEvX1L8kj7tPSHbgCSB30bFIG46NTXv2uBZPc/TiAGgNDvPbUnAgDMNiA
	WNKwIFPz22mfVO711TvkAkaHNVREZ0QSrTC4SpJ61oU6S9sA1P2ChNxFwxMysmuu
	3KHp/79uR/6ZUKpxZd/9RYAJTcZkSKGbCo99inhdiw2EzQYGkq6flxxPOyQRBNMi
	o5Y+VWqH0TdW+RI0gsXpTimWrzu+IGomUa5RWA7Z6ym4Lm7lRlRoVCPeDNNqyMZ9
	6sLHFlJt+gzm1CyB5wJa9vugSlFaWfalWsPdkoSD6XTsz9EP13YRozJeLCuz/xxJ
	m4/FK1iQGeZzYw==
X-ME-Sender: <xms:dqgBXmNVcEfCWslCuH-z67fl38NWTnDZybfPaJpTyhWWp4SrHOBNoA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddvuddgieduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdlfedtmdenucfjughrpefhvf
    fufffkofgjfhgggfestdekredtredttdenucfhrhhomheptfhushhsvghllhcuvehurhhr
    vgihuceorhhushgtuhhrsehruhhsshgvlhhlrdgttgeqnecukfhppeduvddvrdelledrke
    dvrddutdenucfrrghrrghmpehmrghilhhfrhhomheprhhushgtuhhrsehruhhsshgvlhhl
    rdgttgenucevlhhushhtvghrufhiiigvpedv
X-ME-Proxy: <xmx:dqgBXlbjbS7We3HGYiX9G1ECSIvs-fjP3sTp1nzxfE4IShrBv0Budw>
    <xmx:dqgBXkJSI4GO1MXi8renvHaEK_Mxl4CE5OOxttYmQJWgTGVXMgLcIQ>
    <xmx:dqgBXs_B3B98ndLlqYRRBeMEUH51TMrP353nFfX2OKjcj2tktUN5Tg>
    <xmx:dqgBXry5wPW2hf8U_yY-uNEigS-byEopnEPxteZ73GNxbRslKL5xzg>
From: Russell Currey <ruscur@russell.cc>
To: linuxppc-dev@lists.ozlabs.org
Cc: Russell Currey <ruscur@russell.cc>,
	christophe.leroy@c-s.fr,
	joel@jms.id.au,
	mpe@ellerman.id.au,
	ajd@linux.ibm.com,
	dja@axtens.net,
	npiggin@gmail.com,
	kernel-hardening@lists.openwall.com
Subject: [PATCH v6 4/5] powerpc: Set ARCH_HAS_STRICT_MODULE_RWX
Date: Tue, 24 Dec 2019 16:55:44 +1100
Message-Id: <20191224055545.178462-5-ruscur@russell.cc>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191224055545.178462-1-ruscur@russell.cc>
References: <20191224055545.178462-1-ruscur@russell.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To enable strict module RWX on powerpc, set:

    CONFIG_STRICT_MODULE_RWX=y

You should also have CONFIG_STRICT_KERNEL_RWX=y set to have any real
security benefit.

ARCH_HAS_STRICT_MODULE_RWX is set to require ARCH_HAS_STRICT_KERNEL_RWX.
This is due to a quirk in arch/Kconfig and arch/powerpc/Kconfig that
makes STRICT_MODULE_RWX *on by default* in configurations where
STRICT_KERNEL_RWX is *unavailable*.

Since this doesn't make much sense, and module RWX without kernel RWX
doesn't make much sense, having the same dependencies as kernel RWX
works around this problem.

Signed-off-by: Russell Currey <ruscur@russell.cc>
---
 arch/powerpc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index f0b9b47b5353..97ea012fdff9 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -135,6 +135,7 @@ config PPC
 	select ARCH_HAS_SCALED_CPUTIME		if VIRT_CPU_ACCOUNTING_NATIVE && PPC_BOOK3S_64
 	select ARCH_HAS_SET_MEMORY
 	select ARCH_HAS_STRICT_KERNEL_RWX	if ((PPC_BOOK3S_64 || PPC32) && !RELOCATABLE && !HIBERNATION)
+	select ARCH_HAS_STRICT_MODULE_RWX	if ARCH_HAS_STRICT_KERNEL_RWX
 	select ARCH_HAS_TICK_BROADCAST		if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_HAS_UACCESS_FLUSHCACHE
 	select ARCH_HAS_UACCESS_MCSAFE		if PPC64
-- 
2.24.1

