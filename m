Return-Path: <kernel-hardening-return-15916-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 811FF19AD7
	for <lists+kernel-hardening@lfdr.de>; Fri, 10 May 2019 11:39:26 +0200 (CEST)
Received: (qmail 19743 invoked by uid 550); 10 May 2019 09:39:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 1489 invoked from network); 10 May 2019 09:00:48 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
	s=mail181024; t=1557478832;
	bh=a2N5ljKDh064bmfEmLWhlBmHgOU5t3wv3K3qWa5WcuE=;
	h=From:To:Cc:Subject:Date;
	b=Cvm0zx54BAVHFGb5yrLDvm3P596TBlTy47ZkN75dWg/mLGeqfTgpL3uv843OJLiDm
	 GgTWGBMc2t/innLjR1MBVud5NcGpEUTNtpUReV5HGJEp9q3wsS6y9JGuLVGiJon4pw
	 BVJV8GA7diEI1I3W/e6krcJerDsxjvw3urxEBSkr9f0Erk8xDSIV5Pt88U8MSBmc67
	 LWGEQCY1hlJ1lo9LxfUV+iHKVFcjyXU7jxxeCXdBgx0tx/su9nZvy/X9R1CP5BL4dr
	 EvqvwnezDosMEia7t9el1SyMn6vUQdV0xv293mN9k+UjT40SV723VygGv4VcuX9er8
	 lSrIee3T6t5mw==
From: Chris Packham <chris.packham@alliedtelesis.co.nz>
To: keescook@chromium.org,
	re.emese@gmail.com
Cc: kernel-hardening@lists.openwall.com,
	linux-kernel@vger.kernel.org,
	Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [PATCH] gcc-plugins: arm_ssp_per_task_plugin: Fix for older GCC < 6
Date: Fri, 10 May 2019 21:00:25 +1200
Message-Id: <20190510090025.4680-1-chris.packham@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
x-atlnz-ls: pat

Use gen_rtx_set instead of gen_rtx_SET. The former is a wrapper macro
that handles the difference between GCC versions implementing
the latter.

This fixes the following error on my system with g++ 5.4.0 as the host
compiler

   HOSTCXX -fPIC scripts/gcc-plugins/arm_ssp_per_task_plugin.o
 scripts/gcc-plugins/arm_ssp_per_task_plugin.c:42:14: error: macro "gen_r=
tx_SET" requires 3 arguments, but only 2 given
          mask)),
               ^
 scripts/gcc-plugins/arm_ssp_per_task_plugin.c: In function =E2=80=98unsi=
gned int arm_pertask_ssp_rtl_execute()=E2=80=99:
 scripts/gcc-plugins/arm_ssp_per_task_plugin.c:39:20: error: =E2=80=98gen=
_rtx_SET=E2=80=99 was not declared in this scope
    emit_insn_before(gen_rtx_SET

Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
---
 scripts/gcc-plugins/arm_ssp_per_task_plugin.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/gcc-plugins/arm_ssp_per_task_plugin.c b/scripts/gcc-=
plugins/arm_ssp_per_task_plugin.c
index 89c47f57d1ce..8c1af9bdcb1b 100644
--- a/scripts/gcc-plugins/arm_ssp_per_task_plugin.c
+++ b/scripts/gcc-plugins/arm_ssp_per_task_plugin.c
@@ -36,7 +36,7 @@ static unsigned int arm_pertask_ssp_rtl_execute(void)
 		mask =3D GEN_INT(sext_hwi(sp_mask, GET_MODE_PRECISION(Pmode)));
 		masked_sp =3D gen_reg_rtx(Pmode);
=20
-		emit_insn_before(gen_rtx_SET(masked_sp,
+		emit_insn_before(gen_rtx_set(masked_sp,
 					     gen_rtx_AND(Pmode,
 							 stack_pointer_rtx,
 							 mask)),
--=20
2.21.0

