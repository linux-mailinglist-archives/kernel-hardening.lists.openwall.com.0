Return-Path: <kernel-hardening-return-20101-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 9DD7028431D
	for <lists+kernel-hardening@lfdr.de>; Tue,  6 Oct 2020 02:00:33 +0200 (CEST)
Received: (qmail 13835 invoked by uid 550); 6 Oct 2020 00:00:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 13803 invoked from network); 6 Oct 2020 00:00:27 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lMOsfwi87KqTZTytxIFmtZd/oiM8x07q/Mp8jyPAAXI=;
        b=TR41v40N3c0mT6iKV7st9SNhlg9QTdUELsrtGct+/7ED4AfArTHDYCsYjVMUkQrTa3
         TjLWrSiIYucTjdyPSil2F0f1UtirIgTuT1jSdLl4ISjQqsqs7BRoB50aBYiQw+Y7p0xW
         YlXFC0yuaCZWWhtfaFXRua4TpMPmDF+5ayx4Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lMOsfwi87KqTZTytxIFmtZd/oiM8x07q/Mp8jyPAAXI=;
        b=n2tNYYFopc4CQ0YqGFEhXibWZTuzVeKyyoRvol08Y3ku1y9uWCF74tM1XV5rzFuVl4
         REnQyr6cc2cOLBMncS5hyurVCmzVnnBPkvgS67QtFJzWNsgOgRyqxGpJNuiPpFS5O2ck
         /IkhGwNmFiZyu5Xdy2hr7VEQBArnBaU3iACCqOC7ATwRezQtRFoOf+mtq/YT6eY4itY2
         JLXc40n4TC+jSA8VxVmYtJpc0LiutatGlCAcQCSnUzfkdCtGfqrEStuFzMDYCeFO1V+e
         WjGJQzGVtN+BU5SLHeiR8nd0I9RiqgnipXet5N+6diJN+T0SxP2suJTZgivsf2sc7YdA
         6S7Q==
X-Gm-Message-State: AOAM533DUTdcDjK9jM2uEcmTP+bRkZbNlozgJu5ul5oACm8ZkFxbdtLE
	vPsHMiLzLFTxydt6SI0fi8Em4w==
X-Google-Smtp-Source: ABdhPJwWiBEIxSg5nqXR/ySYj20GAHUNH/4qqdyUS4ujisiRNJr16ZDSNzx/7HeR6hfmV6aR90nuLA==
X-Received: by 2002:a17:90a:3fcb:: with SMTP id u11mr1785643pjm.128.1601942415868;
        Mon, 05 Oct 2020 17:00:15 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Emese Revfy <re.emese@gmail.com>,
	"Tobin C. Harding" <me@tobin.cc>,
	Tycho Andersen <tycho@tycho.pizza>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-hardening@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: [PATCH v2] MAINTAINERS: Change hardening mailing list
Date: Mon,  5 Oct 2020 17:00:12 -0700
Message-Id: <20201006000012.2768958-1-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

As more email from git history gets aimed at the OpenWall
kernel-hardening@ list, there has been a desire to separate "new topics"
from "on-going" work. To handle this, the superset of hardening email
topics are now to be directed to linux-hardening@vger.kernel.org. Update
the MAINTAINERS file and the .mailmap to accomplish this, so that
linux-hardening@ can be treated like any other regular upstream kernel
development list.

Link: https://lore.kernel.org/linux-hardening/202010051443.279CC265D@keescook/
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 .mailmap    | 1 +
 MAINTAINERS | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/.mailmap b/.mailmap
index 50096b96c85d..91cea2d9a6a3 100644
--- a/.mailmap
+++ b/.mailmap
@@ -184,6 +184,7 @@ Leon Romanovsky <leon@kernel.org> <leonro@nvidia.com>
 Linas Vepstas <linas@austin.ibm.com>
 Linus Lüssing <linus.luessing@c0d3.blue> <linus.luessing@ascom.ch>
 Linus Lüssing <linus.luessing@c0d3.blue> <linus.luessing@web.de>
+<linux-hardening@vger.kernel.org> <kernel-hardening@lists.openwall.com>
 Li Yang <leoyang.li@nxp.com> <leoli@freescale.com>
 Li Yang <leoyang.li@nxp.com> <leo@zh-kernel.org>
 Lukasz Luba <lukasz.luba@arm.com> <l.luba@partner.samsung.com>
diff --git a/MAINTAINERS b/MAINTAINERS
index adc4f0619b19..8fa1d8ce2188 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7216,7 +7216,7 @@ F:	drivers/staging/gasket/
 GCC PLUGINS
 M:	Kees Cook <keescook@chromium.org>
 R:	Emese Revfy <re.emese@gmail.com>
-L:	kernel-hardening@lists.openwall.com
+L:	linux-hardening@vger.kernel.org
 S:	Maintained
 F:	Documentation/kbuild/gcc-plugins.rst
 F:	scripts/Makefile.gcc-plugins
@@ -9776,7 +9776,7 @@ F:	drivers/scsi/53c700*
 LEAKING_ADDRESSES
 M:	Tobin C. Harding <me@tobin.cc>
 M:	Tycho Andersen <tycho@tycho.pizza>
-L:	kernel-hardening@lists.openwall.com
+L:	linux-hardening@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tobin/leaks.git
 F:	scripts/leaking_addresses.pl
-- 
2.25.1

