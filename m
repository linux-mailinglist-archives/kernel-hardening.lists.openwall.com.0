Return-Path: <kernel-hardening-return-16905-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 143F7B8DBF
	for <lists+kernel-hardening@lfdr.de>; Fri, 20 Sep 2019 11:28:05 +0200 (CEST)
Received: (qmail 32493 invoked by uid 550); 20 Sep 2019 09:25:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 32174 invoked from network); 20 Sep 2019 09:25:46 -0000
From: Jason Yan <yanaijie@huawei.com>
To: <mpe@ellerman.id.au>, <linuxppc-dev@lists.ozlabs.org>,
	<diana.craciun@nxp.com>, <christophe.leroy@c-s.fr>,
	<benh@kernel.crashing.org>, <paulus@samba.org>, <npiggin@gmail.com>,
	<keescook@chromium.org>, <kernel-hardening@lists.openwall.com>
CC: <linux-kernel@vger.kernel.org>, <wangkefeng.wang@huawei.com>,
	<yebin10@huawei.com>, <thunder.leizhen@huawei.com>,
	<jingxiangfeng@huawei.com>, <zhaohongjiang@huawei.com>, <oss@buserror.net>,
	Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v7 09/12] powerpc/fsl_booke/kaslr: support nokaslr cmdline parameter
Date: Fri, 20 Sep 2019 17:45:43 +0800
Message-ID: <20190920094546.44948-10-yanaijie@huawei.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190920094546.44948-1-yanaijie@huawei.com>
References: <20190920094546.44948-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected

One may want to disable kaslr when boot, so provide a cmdline parameter
'nokaslr' to support this.

Signed-off-by: Jason Yan <yanaijie@huawei.com>
Cc: Diana Craciun <diana.craciun@nxp.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Reviewed-by: Diana Craciun <diana.craciun@nxp.com>
Tested-by: Diana Craciun <diana.craciun@nxp.com>
Reviewed-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 arch/powerpc/mm/nohash/kaslr_booke.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/powerpc/mm/nohash/kaslr_booke.c b/arch/powerpc/mm/nohash/kaslr_booke.c
index aa1b60c782e7..4a75f2d9bf0e 100644
--- a/arch/powerpc/mm/nohash/kaslr_booke.c
+++ b/arch/powerpc/mm/nohash/kaslr_booke.c
@@ -281,6 +281,11 @@ static unsigned long __init kaslr_legal_offset(void *dt_ptr, unsigned long index
 	return koffset;
 }
 
+static inline __init bool kaslr_disabled(void)
+{
+	return strstr(boot_command_line, "nokaslr") != NULL;
+}
+
 static unsigned long __init kaslr_choose_location(void *dt_ptr, phys_addr_t size,
 						  unsigned long kernel_sz)
 {
@@ -290,6 +295,8 @@ static unsigned long __init kaslr_choose_location(void *dt_ptr, phys_addr_t size
 	unsigned long index;
 
 	kaslr_get_cmdline(dt_ptr);
+	if (kaslr_disabled())
+		return 0;
 
 	random = get_boot_seed(dt_ptr);
 
-- 
2.17.2

