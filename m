Return-Path: <kernel-hardening-return-18218-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id C0B8A192785
	for <lists+kernel-hardening@lfdr.de>; Wed, 25 Mar 2020 12:50:42 +0100 (CET)
Received: (qmail 10128 invoked by uid 550); 25 Mar 2020 11:50:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 17697 invoked from network); 25 Mar 2020 03:15:24 -0000
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-09.nifty.com 02P3EoCw025927
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
	s=dec2015msa; t=1585106091;
	bh=S5jEMGj/iPjxiPM2qpwETTmm50qFMMgViufRDHA4UYY=;
	h=From:To:Cc:Subject:Date:From;
	b=Fn32tZyU6S/FbmgTUNVYw/4mgJsDn7KA/fxkT/MCad0McZ3zqYtMJSj1sCVuNl+2A
	 NaXYDYrLmdttewD0irHM2OQFQ5x3LwX9JHjnrDrEifjNgcGJmXmJC06KwqYD4N73Pk
	 EUt3WS4kao/rxOcQKWldzMdttDHJWApWk+mIbFcP8v2g+VmvsKk9pOWd3d8NRUAwO/
	 M3I3R8DR6SAeiyj/Wg3QZ47DJGNdVm16I1eR5nkz0Npa79NVQCGz7C10cMkQ4nfWFd
	 9kIx/6WnzyqL6LvmcOtW+HfbETF2duFoijog6PE+opUO84lGozT7Nuxa+dNAoy+q2A
	 oxyeCKZaYP2uA==
X-Nifty-SrcIP: [153.142.97.92]
From: Masahiro Yamada <masahiroy@kernel.org>
To: linux-kbuild@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com,
        Masahiro Yamada <masahiroy@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] kconfig: remove unused variable in qconf.cc
Date: Wed, 25 Mar 2020 12:14:31 +0900
Message-Id: <20200325031433.28223-1-masahiroy@kernel.org>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

If this file were compiled with -Wall, the following warning would be
reported:

scripts/kconfig/qconf.cc:312:6: warning: unused variable ‘i’ [-Wunused-variable]
  int i;
      ^

The commit prepares to turn on -Wall for C++ host programs.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
---

 scripts/kconfig/qconf.cc | 2 --
 1 file changed, 2 deletions(-)

diff --git a/scripts/kconfig/qconf.cc b/scripts/kconfig/qconf.cc
index 82773cc35d35..50a5245d87bb 100644
--- a/scripts/kconfig/qconf.cc
+++ b/scripts/kconfig/qconf.cc
@@ -309,8 +309,6 @@ ConfigList::ConfigList(ConfigView* p, const char *name)
 	  showName(false), showRange(false), showData(false), mode(singleMode), optMode(normalOpt),
 	  rootEntry(0), headerPopup(0)
 {
-	int i;
-
 	setObjectName(name);
 	setSortingEnabled(false);
 	setRootIsDecorated(true);
-- 
2.17.1

