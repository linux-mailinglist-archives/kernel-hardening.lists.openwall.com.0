Return-Path: <kernel-hardening-return-18831-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 7BFD91DAAFA
	for <lists+kernel-hardening@lfdr.de>; Wed, 20 May 2020 08:47:59 +0200 (CEST)
Received: (qmail 30635 invoked by uid 550); 20 May 2020 06:47:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 30586 invoked from network); 20 May 2020 06:47:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sakamocchi.jp;
	 h=from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding; s=fm1; bh=Xbd4QyjDbF3SZl1k6t/MWDx0nV
	5JpEWjamT7q5zFZII=; b=j55eY0K7CWhdP023ay70cQNnhbIJQCyegwrSOP42Rh
	IziFFYQ7A2/evQftoSjXUaP0ux+p1kS88a0iCwanIeqOG87NlR5K+9VD2Z4AMWkq
	kLFg8AooNZtpsGk94Hcqww80vT5Ud2iJMfJEfwC+f56EgJgg5yy5yebIhZti1fVr
	jQ/FlFcnwGWWaw+zht282gLV0edgnsocrD7PS0OaKLRCJzy7b4Js2io8zEK4l+m8
	uZ6sJ9XmEq6qRKHaFWGpyjWR+uytq7Eu73WMZHmzA9+J9W/MiMgSRyjDw3nLIDZ0
	ryJh/QxzaSa8Kfn2GiGIiIlpH7+AOK8Jz/D4hT1KcltA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:date:from
	:message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Xbd4QyjDbF3SZl1k6
	t/MWDx0nV5JpEWjamT7q5zFZII=; b=vxFpneb4AQRP42YQrOxd5MguOzBczVacw
	L2pSmH8J3dRi5QeW9wvFVoKgDDqSYK8Q14MpsX24Gx05G5XTfblfFaR3C8/q6rI/
	2XmShjE0TxY+6ZgpbXSbQYGb6UaLomWD1j3um+rf1OMqHNQwmsYJGorwSHH7vdDw
	Lw4XMi4o276un4C75CVK0HypgXzVZcgy8COHE8Kg/d/Ir0cpFE5vuwJlt11S8HfN
	vKGPGMbfHiCqOyl7koaGofle8w/NiWAi43VArjxIJCyK6puzm+Aeqda+dw/Iev+s
	PD8EIuSzoBIxcxM725omJOEelnOzUSbbunT5XtqzBd9Dcajed6OqQ==
X-ME-Sender: <xms:g9LEXsWJFdSbW1r7_l23A3C_F-_WS-AuHv9nCRowBAjn_96g79INLA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddtkedguddtkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpefvrghkrghshhhiucfurghkrghmohhtohcuoehoqdhtrghkrghs
    hhhisehsrghkrghmohgttghhihdrjhhpqeenucggtffrrghtthgvrhhnpeetieeuhfejke
    ekfeehteeikedvgeefhffggfdvieehhefhheeivdfhgfejjeduudenucffohhmrghinhep
    khgvrhhnvghlrdhorhhgnecukfhppedukedtrddvfeehrdefrdehgeenucevlhhushhtvg
    hrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehoqdhtrghkrghshhhisehs
    rghkrghmohgttghhihdrjhhp
X-ME-Proxy: <xmx:g9LEXgnDhMYZZj0Yeaf3VvhSVXXDmPMghHVRbuzkitF-M0CgOic-fQ>
    <xmx:g9LEXgZ5bV8guLeV3VsTRyZ4PUNYaYcFQO1yxR_hp4macoEiLvJs2Q>
    <xmx:g9LEXrVXwwZBlGf71tDBDnm2mSc1fMLAUpJp1Mv6ODzntLMoJ_f6Hw>
    <xmx:iNLEXrjPYfmQ0mMgmisOjMSJN3ivHeiCyDlICOFv1t8CNADHradYNPY8IiE>
From: Takashi Sakamoto <o-takashi@sakamocchi.jp>
To: oscar.carter@gmx.com,
	keescook@chromium.org,
	mchehab@kernel.org,
	clemens@ladisch.de,
	tiwai@suse.de,
	perex@perex.cz
Cc: kernel-hardening@lists.openwall.com,
	linux1394-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	levonshe@gmail.com,
	alsa-devel@alsa-project.org,
	stefanr@s5r6.in-berlin.de
Subject: [PATCH 0/2] firewire: obsolete cast of function callback toward CFI
Date: Wed, 20 May 2020 15:47:24 +0900
Message-Id: <20200520064726.31838-1-o-takashi@sakamocchi.jp>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Oscar Carter works for Control Flow Integrity build. Any cast
of function callback is inconvenient for the work. Unfortunately,
current code of firewire-core driver includes the cast[1] and Oscar
posted some patches to remove it[2]. The patch is itself good. However,
it includes changes existent kernel API and all of drivers as user
of the API get affects from the change.

This patchset is an alternative idea to add a new kernel API specific
for multichannel isoc context. The existent kernel API and drivers is
left as is.

Practically, no in-kernel drivers use the additional API. Although the
API is exported in the patchset, it's better to discuss about unexporting
the API.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/firewire/core-cdev.c#n985
[2] https://lore.kernel.org/lkml/20200519173425.4724-1-oscar.carter@gmx.com/

Regards

Takashi Sakamoto (2):
  firewire-core: add kernel API to construct multichannel isoc context
  firewire-core: obsolete cast of function callback

 drivers/firewire/core-cdev.c | 44 +++++++++++++++++++-----------------
 drivers/firewire/core-iso.c  | 17 ++++++++++++++
 include/linux/firewire.h     |  3 +++
 3 files changed, 43 insertions(+), 21 deletions(-)

-- 
2.25.1

