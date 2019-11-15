Return-Path: <kernel-hardening-return-17367-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id F0AD3FD45A
	for <lists+kernel-hardening@lfdr.de>; Fri, 15 Nov 2019 06:30:30 +0100 (CET)
Received: (qmail 32643 invoked by uid 550); 15 Nov 2019 05:29:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 32381 invoked from network); 15 Nov 2019 05:29:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=lIff/HsuYUX4uhwWTx3aVYOPFjp52ImXeumnDjDhshw=;
        b=ZdTwm1d9Efmg5RBCb17XYd2ALis+3DV0tULR7SyLWLxP+EZEDSbYJw1GwgFrS5k7gr
         ZgOx0JDnwMInLiyLce5YAK+7xftVVhpwBFj1PPNIOV2rsfdXiE9FWu6snqZtBcn8xqjY
         kZyZbbHrGojcc/ySkh6p1kBCxP1A8tatQW4iA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=lIff/HsuYUX4uhwWTx3aVYOPFjp52ImXeumnDjDhshw=;
        b=gtsCQVR8e6fQXSBm0JKEne7+HG0PHNK2C8cnx3UYY1IIcdP1hzsXBeHpZqxsXSB67I
         HM1jjeEC8jktYsC6GTwxzIZ3XAWkLu7ZexuLTkSE7x667zNDdG2DXbKmBr142Qc5ZsQz
         pAZlUu2Gm+7vHYqfJG85PPs3JwhVgFSkD03UZd/Toej8YhBEQ+zziYRJl/tbq7GwVhid
         NpTvXpmHp6Z1nLYbUUiEGcquIAW12J372UoMds6FGMhDmtjnPAVbYtNLmSXSNIxsAIAv
         z0cc0Od1noGi8xf2McmzkxJdkC8fPv737B4ceWLDuRBg0lQqUBcCqDamvXmRjvRyBz+d
         ItaQ==
X-Gm-Message-State: APjAAAVJ1kStA1hMY4qfdy/PsFHXFGn2YYtrr+caC65KSO8uPJ/vUSDx
	HWAXMB09roXYTSIwuIFGZEgoXw==
X-Google-Smtp-Source: APXvYqy1G7d5ZLVqWMGLxX/au94Dv620lNHG5W446Zfu+MhtTYOS4k1eWDSBXwuFhLnBKVd1HLzF3w==
X-Received: by 2002:a17:90a:a616:: with SMTP id c22mr17732430pjq.46.1573795781306;
        Thu, 14 Nov 2019 21:29:41 -0800 (PST)
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
Subject: [PATCH 0/5] bnx2x: Remove function casts
Date: Thu, 14 Nov 2019 21:07:10 -0800
Message-Id: <20191115050715.6247-1-keescook@chromium.org>
X-Mailer: git-send-email 2.17.1

In order to make the entire kernel usable under Clang's Control Flow
Integrity protections, function prototype casts need to be avoided
because this will trip CFI checks at runtime (i.e. a mismatch between
the caller's expected function prototype and the destination function's
prototype). Many of these cases can be found with -Wcast-function-type,
which found that bnx2x had a bunch of needless (or at least confusing)
function casts. This series removes them all.

-Kees

Kees Cook (5):
  bnx2x: Drop redundant callback function casts
  bnx2x: Remove read_status_t function casts
  bnx2x: Remove config_init_t function casts
  bnx2x: Remove format_fw_ver_t function casts
  bnx2x: Remove hw_reset_t function casts

 .../net/ethernet/broadcom/bnx2x/bnx2x_link.c  | 351 +++++++++---------
 .../net/ethernet/broadcom/bnx2x/bnx2x_link.h  |   6 +-
 2 files changed, 171 insertions(+), 186 deletions(-)

-- 
2.17.1

