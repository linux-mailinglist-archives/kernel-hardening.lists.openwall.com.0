Return-Path: <kernel-hardening-return-17369-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id CCF42FD461
	for <lists+kernel-hardening@lfdr.de>; Fri, 15 Nov 2019 06:31:06 +0100 (CET)
Received: (qmail 1093 invoked by uid 550); 15 Nov 2019 05:30:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 32750 invoked from network); 15 Nov 2019 05:29:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=C9I5FqW0z8fenw97nfBVEeoAsOoFr9Mv0e0uFaFX9H0=;
        b=KdyazIcVt/KrZ4Q4dPukr55+0f+LWN3FdURkiejEjDxeIaipIHVsXos1gZ7NOv5oAC
         nBCU6ZcNEllQVcTxPM68PAW4OKdhuUVgvhoaKG9dWWFK2T3anLrxqjrWgpudcjZfD4Mh
         ArgbCrLslQ6DK1H1FpXuVXtZvw6Lu0L2HKHTs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=C9I5FqW0z8fenw97nfBVEeoAsOoFr9Mv0e0uFaFX9H0=;
        b=dM3fhO1u39okrTPhJvNM+HQYQmh7KSn10Vy+k1rEGuha1Y3kyTYqC7c3fd8qnxUv3h
         +13GtcBmsnTXJvXnIpgk7qbvJp1M137+wEnMBMU77K4ItriUIhXsZBTZSTCcT3XpBysN
         HNHFGITm4x/57ueGCI4wFLk1UgVocrVjTQrr9zfc7A1NzuSkX5agZMPw0yxd5siuIqMm
         ymmgBNHO1eaC7XkZzX7XXisBaAD08ZYDjXQzJB7gGq40e6KXz1XTAJT4yP485MBxQIFc
         3S497/0wvLFndox/Y7WdFG84p9jAPijQvNnxQSCm12U884L18Oi6VEgzDLL3WcETDigy
         zR9A==
X-Gm-Message-State: APjAAAXQsdwjSb/FSQoM3VBsxllc6yVwc9tWF9dto9INea3aWT6iqCZE
	QSqYUR738+B47jelM3j5zy8TWw==
X-Google-Smtp-Source: APXvYqwc5nrGGxexFGky4nRCM5cHAELptoH7k4Z94evZphJre2euyv6XPNoAvpYGEjuz34jD3TFjNQ==
X-Received: by 2002:a63:535c:: with SMTP id t28mr1441537pgl.173.1573795786355;
        Thu, 14 Nov 2019 21:29:46 -0800 (PST)
From: Kees Cook <keescook@chromium.org>
To: "David S. Miller" <davem@davemloft.net>
Cc: Kees Cook <keescook@chromium.org>,
	Ariel Elior <aelior@marvell.com>,
	Sudarsana Kalluru <skalluru@marvell.com>,
	GR-everest-linux-l2@marvell.com,
	Sami Tolvanen <samitolvanen@google.com>,
	netdev@vger.kernel.org,
	kernel-hardening@lists.openwall.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] bnx2x: Remove hw_reset_t function casts
Date: Thu, 14 Nov 2019 21:07:15 -0800
Message-Id: <20191115050715.6247-6-keescook@chromium.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191115050715.6247-1-keescook@chromium.org>
References: <20191115050715.6247-1-keescook@chromium.org>

All .rw_reset callbacks except bnx2x_84833_hw_reset_phy() use a
void return type. No callers of .hw_reset check a return value and
bnx2x_84833_hw_reset_phy() unconditionally returns 0. Remove all
hw_reset_t casts and fix the return type to void.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 .../net/ethernet/broadcom/bnx2x/bnx2x_link.c  | 20 +++++++++----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
index 7dd35aa75925..9638d65d8261 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
@@ -10201,8 +10201,8 @@ static u8 bnx2x_84833_get_reset_gpios(struct bnx2x *bp,
 	return reset_gpios;
 }
 
-static int bnx2x_84833_hw_reset_phy(struct bnx2x_phy *phy,
-				struct link_params *params)
+static void bnx2x_84833_hw_reset_phy(struct bnx2x_phy *phy,
+				     struct link_params *params)
 {
 	struct bnx2x *bp = params->bp;
 	u8 reset_gpios;
@@ -10230,8 +10230,6 @@ static int bnx2x_84833_hw_reset_phy(struct bnx2x_phy *phy,
 	udelay(10);
 	DP(NETIF_MSG_LINK, "84833 hw reset on pin values 0x%x\n",
 		reset_gpios);
-
-	return 0;
 }
 
 static int bnx2x_8483x_disable_eee(struct bnx2x_phy *phy,
@@ -11737,7 +11735,7 @@ static const struct bnx2x_phy phy_warpcore = {
 	.link_reset	= bnx2x_warpcore_link_reset,
 	.config_loopback = bnx2x_set_warpcore_loopback,
 	.format_fw_ver	= NULL,
-	.hw_reset	= (hw_reset_t)bnx2x_warpcore_hw_reset,
+	.hw_reset	= bnx2x_warpcore_hw_reset,
 	.set_link_led	= NULL,
 	.phy_specific_func = NULL
 };
@@ -11768,7 +11766,7 @@ static const struct bnx2x_phy phy_7101 = {
 	.link_reset	= bnx2x_common_ext_link_reset,
 	.config_loopback = bnx2x_7101_config_loopback,
 	.format_fw_ver	= bnx2x_7101_format_ver,
-	.hw_reset	= (hw_reset_t)bnx2x_7101_hw_reset,
+	.hw_reset	= bnx2x_7101_hw_reset,
 	.set_link_led	= bnx2x_7101_set_link_led,
 	.phy_specific_func = NULL
 };
@@ -11919,7 +11917,7 @@ static const struct bnx2x_phy phy_8727 = {
 	.link_reset	= bnx2x_8727_link_reset,
 	.config_loopback = NULL,
 	.format_fw_ver	= bnx2x_format_ver,
-	.hw_reset	= (hw_reset_t)bnx2x_8727_hw_reset,
+	.hw_reset	= bnx2x_8727_hw_reset,
 	.set_link_led	= bnx2x_8727_set_link_led,
 	.phy_specific_func = bnx2x_8727_specific_func
 };
@@ -11954,7 +11952,7 @@ static const struct bnx2x_phy phy_8481 = {
 	.link_reset	= bnx2x_8481_link_reset,
 	.config_loopback = NULL,
 	.format_fw_ver	= bnx2x_848xx_format_ver,
-	.hw_reset	= (hw_reset_t)bnx2x_8481_hw_reset,
+	.hw_reset	= bnx2x_8481_hw_reset,
 	.set_link_led	= bnx2x_848xx_set_link_led,
 	.phy_specific_func = NULL
 };
@@ -12026,7 +12024,7 @@ static const struct bnx2x_phy phy_84833 = {
 	.link_reset	= bnx2x_848x3_link_reset,
 	.config_loopback = NULL,
 	.format_fw_ver	= bnx2x_848xx_format_ver,
-	.hw_reset	= (hw_reset_t)bnx2x_84833_hw_reset_phy,
+	.hw_reset	= bnx2x_84833_hw_reset_phy,
 	.set_link_led	= bnx2x_848xx_set_link_led,
 	.phy_specific_func = bnx2x_848xx_specific_func
 };
@@ -12060,7 +12058,7 @@ static const struct bnx2x_phy phy_84834 = {
 	.link_reset	= bnx2x_848x3_link_reset,
 	.config_loopback = NULL,
 	.format_fw_ver	= bnx2x_848xx_format_ver,
-	.hw_reset	= (hw_reset_t)bnx2x_84833_hw_reset_phy,
+	.hw_reset	= bnx2x_84833_hw_reset_phy,
 	.set_link_led	= bnx2x_848xx_set_link_led,
 	.phy_specific_func = bnx2x_848xx_specific_func
 };
@@ -12094,7 +12092,7 @@ static const struct bnx2x_phy phy_84858 = {
 	.link_reset	= bnx2x_848x3_link_reset,
 	.config_loopback = NULL,
 	.format_fw_ver	= bnx2x_8485x_format_ver,
-	.hw_reset	= (hw_reset_t)bnx2x_84833_hw_reset_phy,
+	.hw_reset	= bnx2x_84833_hw_reset_phy,
 	.set_link_led	= bnx2x_848xx_set_link_led,
 	.phy_specific_func = bnx2x_848xx_specific_func
 };
-- 
2.17.1

