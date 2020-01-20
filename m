Return-Path: <kernel-hardening-return-17590-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 0FA6C142290
	for <lists+kernel-hardening@lfdr.de>; Mon, 20 Jan 2020 05:54:49 +0100 (CET)
Received: (qmail 19847 invoked by uid 550); 20 Jan 2020 04:54:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 19823 invoked from network); 20 Jan 2020 04:54:42 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xN3Z4EtUvjD28efJ92xKpoRYufScEeM5MB1/Qfws810=;
        b=W0L2jdRQ6MREKzDtBfeqsFqnHKSHfF7Sb0eeF/NO+1tO1ak2JirozIT8ho0P748UC9
         v4qHLYd83CfoETl2RH3lHI86fgn7phaWJtD2sN+sibKTOv/Q5NMU8XhsujL/2ad6Z4y/
         dfI+HuzKHI86RmSdmNVVEy0X3+DDCG3/jSsa0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xN3Z4EtUvjD28efJ92xKpoRYufScEeM5MB1/Qfws810=;
        b=rvHrDLh5/axyaZIMRqb5wnOMkkXH+E7mF2b7u3LxAYtL0R/7bRQuqYNYD/eApVO9Ir
         3QYYjzR4V17Ln1BYNwYZhcn94AULBKQ+nMy4QIRIP6BJVW1H4RMVsZqaaTrPUrnD1hVD
         TFi81yjS4RuViTe+QBmuxjWhhG5OUek4PtDjNP66aiNwPEE52ulwY9iQBppB2fUCP3Ck
         eKcg6Y5z7tb9cuEeJgXpjNfs2unEII26QBPa+KXw2HWPjT7FoS+G6NdCIpn08G2rEWKZ
         GHW2NYCTQKz8HoE9xuZJOgp8Jwri4bYUwkP4CmhqZf2IPd0/Nhl4STrgOZ2WHT34Eq/b
         Qg8w==
X-Gm-Message-State: APjAAAXv2pfJ+KTH8awmu9lQh6ESC75hmIPSnFhc/4xgs+Mwc/xg+XC8
	b4CbY9vF/H5Czw6ZM+CSvdq32lMw+Bo=
X-Google-Smtp-Source: APXvYqxbURRFxgJ90M08NbktU6NV4cTwTLt4WEZcRDxlNQeK+6mOpbIca82m89cBJLFfn4kJ+VH1eA==
X-Received: by 2002:a63:642:: with SMTP id 63mr56653726pgg.73.1579496069997;
        Sun, 19 Jan 2020 20:54:29 -0800 (PST)
From: Daniel Axtens <dja@axtens.net>
To: kernel-hardening@lists.openwall.com,
	akpm@linux-foundation.org,
	keescook@chromium.org
Cc: linux-kernel@vger.kernel.org,
	Daniel Axtens <dja@axtens.net>
Subject: [PATCH v2 0/2] FORTIFY_SOURCE: detect intra-object overflow in string functions
Date: Mon, 20 Jan 2020 15:54:22 +1100
Message-Id: <20200120045424.16147-1-dja@axtens.net>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the fortify feature was first introduced in commit 6974f0c4555e
("include/linux/string.h: add the option of fortified string.h functions"),
Daniel Micay observed:

  * It should be possible to optionally use __builtin_object_size(x, 1) for
    some functions (C strings) to detect intra-object overflows (like
    glibc's _FORTIFY_SOURCE=2), but for now this takes the conservative
    approach to avoid likely compatibility issues.

This patch set:

 - converts a number of string functions to use __builtin_object_size(x, 1)

 - adds LKDTM tests for both types of fortified function.

This change passes an allyesconfig on powerpc and x86, and an x86 kernel
built with it survives running with syz-stress from syzkaller, so it seems
safe so far.

Daniel Axtens (2):
  string.h: detect intra-object overflow in fortified string functions
  lkdtm: tests for FORTIFY_SOURCE

 drivers/misc/lkdtm/bugs.c  | 51 ++++++++++++++++++++++++++++++++++++++
 drivers/misc/lkdtm/core.c  |  2 ++
 drivers/misc/lkdtm/lkdtm.h |  2 ++
 include/linux/string.h     | 27 ++++++++++++--------
 4 files changed, 71 insertions(+), 11 deletions(-)

-- 
2.20.1

