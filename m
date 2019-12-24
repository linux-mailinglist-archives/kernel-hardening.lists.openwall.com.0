Return-Path: <kernel-hardening-return-17514-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 3ECD4129DF1
	for <lists+kernel-hardening@lfdr.de>; Tue, 24 Dec 2019 06:56:14 +0100 (CET)
Received: (qmail 19760 invoked by uid 550); 24 Dec 2019 05:56:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 19721 invoked from network); 24 Dec 2019 05:56:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding; s=fm3; bh=quBZcC5Nj15k+G+ee0d2Sguypc
	PXvk8rxSpa/ZtL4BE=; b=XjahVPXMeph/schhBdXTzGRdm3VhVmGKt6OrPT6Dzb
	hfeEnvGzaDB1GOzWUuGUWy8b09znxYHokZq9JXupd1DvgK8y5ptklT5uPHY0Z/mC
	0FDBaQt51Jn3lSejDB6YyF3pkvictdJKWa9UMyhiOZF7o4DkkSnRgPyzGEfMO0eb
	DUsTFTFkFmiYwEoEPcRuNlKZ5yfzHi9F3ls/nKJ/pKfo1YvqARfxdF6ngdZEh+p7
	FW8FWEzpdGVWal+MdaKUpXdpiJ0fyJUcuu00FDfeLP1kWeavRAsmGoVsifbCbO8s
	h3psPt2ChciymIksKw9TSFA6UmHtOMxTjL8X10UJS3SA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:date:from
	:message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=quBZcC5Nj15k+G+ee
	0d2SguypcPXvk8rxSpa/ZtL4BE=; b=fjTuryOiDFR+IKhOm4xNdGKh93s3o4fSQ
	elZNNIljI8oSJmFCoXgDfU1LgLMsdLD37AehyFvY+wa+HTOP1xqlNNnTWGzBpGPd
	PNaUA8D3r15QRxPx8yuPGeN1WRRG4ox1UEjdFPQtnfgIuSBOdmnOmW3fLfl+q3cu
	HVGIBbRM9oVmUTIQZLKrJhE4gA0DtvJTcxlBzqWhzJxuiTrwx6XDcRkLKlC4Qcs3
	bakWHf0Bl0uRgC/ezpU3W2o04nr6tu+ltIKgnO4180Hzk4cyZDysX/DGwufFYbd8
	CnsCw7Ar1taYIwAjJz3tOnfcvEu5tv3YAvUwEmZp8URb/HWixETJg==
X-ME-Sender: <xms:aagBXltYeLkDxWnfsR48r3c7NlCIPqfEa4tF9FxsiLZeY6EmgOLGMg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddvuddgieduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdludehmdenogevohgrshhtrg
    hlqdfhgeduvddqtddvucdludehtddmnecujfgurhephffvufffkffoggfgsedtkeertder
    tddtnecuhfhrohhmpeftuhhsshgvlhhlucevuhhrrhgvhicuoehruhhstghurhesrhhush
    hsvghllhdrtggtqeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgpdhoiihlrggsshdr
    ohhrghenucfkphepuddvvddrleelrdekvddruddtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehruhhstghurhesrhhushhsvghllhdrtggtnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:aagBXitWqBZvi3RRE2AL7wjwcQJ1Z04R_VJ6B5Ni0zyzybAR5cKoLQ>
    <xmx:aagBXjw_Zl6HoaMtTbGDd5QWZuE7dBysBU0PahNN-C8evukBXAs4gA>
    <xmx:aagBXgjep3Dbi8xh1qkhYgClaPMK4awHtEyYR3mbYU-iKt3zL7ZF0g>
    <xmx:aqgBXqkuKaF3LIf7SS9A8p10obwq4DOaaZKpmxRhs8CIRTGdYpFBIQ>
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
Subject: [PATCH v6 0/5] Implement STRICT_MODULE_RWX for powerpc
Date: Tue, 24 Dec 2019 16:55:40 +1100
Message-Id: <20191224055545.178462-1-ruscur@russell.cc>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v5 cover letter: https://lore.kernel.org/kernel-hardening/20191030073111.140493-1-ruscur@russell.cc/
v4 cover letter: https://lists.ozlabs.org/pipermail/linuxppc-dev/2019-October/198268.html
v3 cover letter: https://lists.ozlabs.org/pipermail/linuxppc-dev/2019-October/198023.html

Changes since v5:
	[1/5]: Addressed review comments from Christophe Leroy (thanks!)
	[2/5]: Use patch_instruction() instead of memcpy() thanks to mpe

Thanks for the feedback, hopefully this is the final iteration.  I have a patch
to remove the STRICT_KERNEL_RWX incompatibility with RELOCATABLE for book3s64
coming soon, so with that we should have a great basis for powerpc RWX going
forward.

Russell Currey (5):
  powerpc/mm: Implement set_memory() routines
  powerpc/kprobes: Mark newly allocated probes as RO
  powerpc/mm/ptdump: debugfs handler for W+X checks at runtime
  powerpc: Set ARCH_HAS_STRICT_MODULE_RWX
  powerpc/configs: Enable STRICT_MODULE_RWX in skiroot_defconfig

 arch/powerpc/Kconfig                   |  2 +
 arch/powerpc/Kconfig.debug             |  6 +-
 arch/powerpc/configs/skiroot_defconfig |  1 +
 arch/powerpc/include/asm/set_memory.h  | 32 ++++++++++
 arch/powerpc/kernel/kprobes.c          |  6 +-
 arch/powerpc/mm/Makefile               |  1 +
 arch/powerpc/mm/pageattr.c             | 83 ++++++++++++++++++++++++++
 arch/powerpc/mm/ptdump/ptdump.c        | 21 ++++++-
 8 files changed, 147 insertions(+), 5 deletions(-)
 create mode 100644 arch/powerpc/include/asm/set_memory.h
 create mode 100644 arch/powerpc/mm/pageattr.c

-- 
2.24.1

