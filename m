Return-Path: <kernel-hardening-return-18319-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 43CDB198B6B
	for <lists+kernel-hardening@lfdr.de>; Tue, 31 Mar 2020 06:49:48 +0200 (CEST)
Received: (qmail 19693 invoked by uid 550); 31 Mar 2020 04:49:09 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 19610 invoked from network); 31 Mar 2020 04:49:09 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=fm1; bh=lHgLupnwwVnW8
	9H6t1yvE2k1Yy07V091CXapypcIwwE=; b=nqxRHgiEPi5NinYUkV2aNj2sL+Qc+
	kSp/2HgirIj6UqUYLLP7yByXPkcd5AaxtHJ8T5iyawOYdLjoDcY0g315ujNVXhwi
	2MucyVwY4UUTp1UfvuNMT8DaWM2AP0h/uGUn9SAqG6mnHFzoF1PTBriFM0NDzDO6
	wjnJy7uFHgO+XzMTTrKy2agUgknxxwFzWgVgT4ztwi5k7FDY/zYWRoPh6ggJFCye
	xp3vCu3+feEd9BWeO0h3zBqV008ZsdZfh1kJ2xBBejwcSHqW5rJHG/npGEOGoj4t
	yO6kLtTDYR9vMD/59z6ehlhgGnk/+EtCcK59YD82H0l1Q3QWze3piad0A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:date:from
	:in-reply-to:message-id:mime-version:references:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; bh=lHgLupnwwVnW89H6t1yvE2k1Yy07V091CXapypcIwwE=; b=mn0VXpGd
	6hLPBw4/6qJ8uqM+gOHVN+he5HuYAAex8VzjnKvkeD+t+OfzIq16fm2yl3ttFRb1
	lluQcpDOXGAYCR94RqbModPGf14IFw30RKUWaoay7S9+sCtcQvNcji5dnFD8kDh8
	VgGpFACHiwrjz9jM/b2RPyDNDBdEfPfE0U9ig/9AarceDV1WKJTRbijkj6iL8pR6
	0zV9Hk31BLz7WTKNyP7T79NgM/FGvJiQpS+fWjWmM034Y+UuY6EEOBtQrHxW9wEq
	05pGoPZFea3FBrrcQu2tX9L8mXLaePxUe1G3iUYJNZMpy6U30/bzythYL670sNEp
	GE1yNuce743M8w==
X-ME-Sender: <xms:ucuCXrtTV3mSwpj6fXO5qD5ip9t_WaNwJkg_T0gCY_qUF27eMpXwxg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeiiedgkeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    gfrhhlucfvnfffucdludehmdenucfjughrpefhvffufffkofgjfhgggfestdekredtredt
    tdenucfhrhhomheptfhushhsvghllhcuvehurhhrvgihuceorhhushgtuhhrsehruhhssh
    gvlhhlrdgttgeqnecukfhppeduvddurdeghedrvdduvddrvdefleenucevlhhushhtvghr
    ufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehruhhstghurhesrhhushhsvg
    hllhdrtggt
X-ME-Proxy: <xmx:ucuCXoHf7XYuHxOL2orRatnLUiLr4gonUyb_GTXxkcK8GZr62rQgEw>
    <xmx:ucuCXpOG5N0V0ubSJWX6vjZWmNET52ruNnLGRvWl9hnrfMF10aaLEg>
    <xmx:ucuCXoF3KLiaduWDwHE57yGlTw6ESOYx2U3-uLJzpbuJQYrFWzJXGQ>
    <xmx:ucuCXkAOZSFE6zv2K4MmpcTwbfzfgePYqb2HcYfFs3lc9-Nj0Xrcig>
From: Russell Currey <ruscur@russell.cc>
To: linuxppc-dev@lists.ozlabs.org
Cc: Russell Currey <ruscur@russell.cc>,
	christophe.leroy@c-s.fr,
	mpe@ellerman.id.au,
	ajd@linux.ibm.com,
	dja@axtens.net,
	npiggin@gmail.com,
	kernel-hardening@lists.openwall.com,
	Joel Stanley <joel@joel.id.au>
Subject: [PATCH v7 5/7] powerpc/configs: Enable STRICT_MODULE_RWX in skiroot_defconfig
Date: Tue, 31 Mar 2020 15:48:23 +1100
Message-Id: <20200331044825.591653-6-ruscur@russell.cc>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331044825.591653-1-ruscur@russell.cc>
References: <20200331044825.591653-1-ruscur@russell.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

skiroot_defconfig is the only powerpc defconfig with STRICT_KERNEL_RWX
enabled, and if you want memory protection for kernel text you'd want it
for modules too, so enable STRICT_MODULE_RWX there.

Acked-by: Joel Stanley <joel@joel.id.au>
Signed-off-by: Russell Currey <ruscur@russell.cc>
---
 arch/powerpc/configs/skiroot_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/configs/skiroot_defconfig b/arch/powerpc/configs/skiroot_defconfig
index 1b6bdad36b13..66d20dbe67b7 100644
--- a/arch/powerpc/configs/skiroot_defconfig
+++ b/arch/powerpc/configs/skiroot_defconfig
@@ -51,6 +51,7 @@ CONFIG_CMDLINE="console=tty0 console=hvc0 ipr.fast_reboot=1 quiet"
 # CONFIG_PPC_MEM_KEYS is not set
 CONFIG_JUMP_LABEL=y
 CONFIG_STRICT_KERNEL_RWX=y
+CONFIG_STRICT_MODULE_RWX=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 CONFIG_MODULE_SIG_FORCE=y
-- 
2.26.0

