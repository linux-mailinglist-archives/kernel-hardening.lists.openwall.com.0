Return-Path: <kernel-hardening-return-18117-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id C988117ED97
	for <lists+kernel-hardening@lfdr.de>; Tue, 10 Mar 2020 02:04:59 +0100 (CET)
Received: (qmail 26339 invoked by uid 550); 10 Mar 2020 01:04:27 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 26242 invoked from network); 10 Mar 2020 01:04:27 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=fm1; bh=Z84AqZl7dQCow
	nF4r9rNWqCkiMXAjJ064l1LHKxjRLw=; b=RIWKLTk9lOqpnzngpZsEoGRC1Y0it
	QonWOBaNq3SZnlo1CU0zFMjPxdFJCLogJw7qmrvUfrPyjxxqPGlkPtoBYhAnuKYt
	CImG/9IvVNPGqo4GD+LNnsmFMXWpjrQqLUPFxsOmgFmrb4bsGfAdlAp4yZDPfCcg
	zATOqE/La1i5fDiC2R5EODBjgEMwzvjVOjCpquOX2E+8rf5NhGGJPMbcxyxUDXLC
	YDGqapzHJFihAKPsDSz7U5FFOg3z7yt5gbObclWZ6YIxGKJAaR3eSO2HjRISZkD/
	GKXkdhaz9nU8YKtt6GzzETtudn6DSHKWbsGzX8fEbrat78oUgrxpnLzQA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:date:from
	:in-reply-to:message-id:mime-version:references:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; bh=Z84AqZl7dQCownF4r9rNWqCkiMXAjJ064l1LHKxjRLw=; b=k/WUSDMT
	avbXihHj1eHQoiLVD1PXMuaY/o8bbadcQMJNaJwuiKRnKIS/Cjun9xEkq2sbgC0G
	OJsiVLpNiVKr9MQCDbnoGkLLxhPHTyuZEwds4L8XjIpi3IXga/pCacuIjtDJusjh
	YRMIpKwu5n060JaA2pLGUakfMrsf5MI34XUd5EOKky7lbO0vS99iSt30CWGufV63
	s2W5/VAIEfFLO86ktJ9bKiO53mRd7hlz4932xCURj5QaqQ6Hv5dVecaWM75Ug0WL
	W10PHXGsDiUaniLLHaO1r+2aHtk6l8mAUkoa1EFqxK+IohsWhUA6fWS1WnnpLn2b
	ZLOsR7XLVtwIkg==
X-ME-Sender: <xms:j-dmXjn9Pob2d8K9ltI0SCcbPWWbUpkF5t8bymf5eautajqeruuPRg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudduledgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdlfedtmdenucfjughrpefhvf
    fufffkofgjfhgggfestdekredtredttdenucfhrhhomheptfhushhsvghllhcuvehurhhr
    vgihuceorhhushgtuhhrsehruhhsshgvlhhlrdgttgeqnecukfhppeduvddvrdelledrke
    dvrddutdenucevlhhushhtvghrufhiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhm
    pehruhhstghurhesrhhushhsvghllhdrtggt
X-ME-Proxy: <xmx:j-dmXp6diB5FHyIxcRUMzYE2xToHEyEc7Oo_qagSdyjJKUnge_P9-A>
    <xmx:j-dmXo7WC9MROTyDrQSFV6jtyi7CFP79fgnPETl95m-PrgfTCjaXUw>
    <xmx:j-dmXpRF6i46qjcKACdO_Q98NdfU9BTuVqellR9XooXuo303Ws9zkA>
    <xmx:j-dmXuWx6uGu6LkkeBQqP7PuYgn_Q7q0phLIKjloWKFpgRcUyXK3cw>
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
Subject: [PATCH v6 4/7] powerpc: Set ARCH_HAS_STRICT_MODULE_RWX
Date: Tue, 10 Mar 2020 12:03:35 +1100
Message-Id: <20200310010338.21205-5-ruscur@russell.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310010338.21205-1-ruscur@russell.cc>
References: <20200310010338.21205-1-ruscur@russell.cc>
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
index bd074246e34e..e1fc7fba10bf 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -131,6 +131,7 @@ config PPC
 	select ARCH_HAS_SCALED_CPUTIME		if VIRT_CPU_ACCOUNTING_NATIVE && PPC_BOOK3S_64
 	select ARCH_HAS_SET_MEMORY
 	select ARCH_HAS_STRICT_KERNEL_RWX	if ((PPC_BOOK3S_64 || PPC32) && !HIBERNATION)
+	select ARCH_HAS_STRICT_MODULE_RWX	if ARCH_HAS_STRICT_KERNEL_RWX
 	select ARCH_HAS_TICK_BROADCAST		if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_HAS_UACCESS_FLUSHCACHE
 	select ARCH_HAS_UACCESS_MCSAFE		if PPC64
-- 
2.25.1

