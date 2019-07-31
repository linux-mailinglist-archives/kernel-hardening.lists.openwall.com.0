Return-Path: <kernel-hardening-return-16674-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 935F37CB64
	for <lists+kernel-hardening@lfdr.de>; Wed, 31 Jul 2019 20:01:38 +0200 (CEST)
Received: (qmail 7575 invoked by uid 550); 31 Jul 2019 18:01:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 7518 invoked from network); 31 Jul 2019 18:01:32 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Uc5jwJklnJNO+SO7UIEO8rMk1YcQmTcBnS2sF72FTD4=;
        b=gO8mfx0Bxe2dxij++YpcsM3Sa5nSlhLQE0ZKDTw/hHi31gj8cbCSCNAio3hEwSlGWZ
         Ojb6VeechO7IfifaNjrjrwZibn+zdNmD89yI9mswEMt8opxnf5WGebrkRAsK/kaNvQ5d
         STGUJPr0c+xePspbNV08JEOOpOwM9TCqxTt8NIahn/pSthgGLdwn20OmtF8xyOXKmPgz
         71F93jSN6YcS/bWm0qYzIUUtKboibdlT27F6hxd9tg9LuvZjWxXVLpuT6QNPDpaHzSOP
         6NEn10gG/fAG+7BmQM9veAXsNEi9gSf+Biz6oFru/LM5tOsGRBn4eMbtVlRHd/BchhiP
         DGSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Uc5jwJklnJNO+SO7UIEO8rMk1YcQmTcBnS2sF72FTD4=;
        b=HZdlkobDc5PJwlrKoC0rEKiv5pbWS7tz8m64lmip7ouilnWlO36YzKQEk5q0RYlyZE
         c3xc65q7j5E3M4SJ0hihEfy7HHj3ne/r1ZlsnxNkw5fSCNuibe3HdJN6ldAsnkNvTIKx
         5NEgNb6Z0NF103poFkqGyzA5C73yQLacsJEcfqZrjcVP1z3DNwulctEoeqySaYMzBg3+
         0Yb0VvrUBo9VPlFR3aFKX4LvPPVN5XXryxJfjI1NRDLOh6ot4bAgDdQ4YHwaY6niSLPO
         7qVmP35DfCVBmRKzSv/H6UX6FRBRNtLiozttT1SOJJ9Xnkpnrs+4x9kNVJV3EDDUGBqb
         K5mQ==
X-Gm-Message-State: APjAAAXH7SLvrIDhtnpb94dMiWgtfq30Fm452rLCKvk79gCeY0bZWyJu
	OqkKEUnkQav3k0JflTf79eo=
X-Google-Smtp-Source: APXvYqze1/83nMpL8uB6451tOE4ZN6kEkl1Lb4W1Cl9uslzXzrIJdUtBMTmICBFdjlKVUBvf4TC04Q==
X-Received: by 2002:a63:8ac3:: with SMTP id y186mr114569747pgd.13.1564596080955;
        Wed, 31 Jul 2019 11:01:20 -0700 (PDT)
Date: Thu, 1 Aug 2019 03:01:10 +0900
From: Joonwon Kang <kjw1627@gmail.com>
To: keescook@chromium.org
Cc: re.emese@gmail.com, kernel-hardening@lists.openwall.com,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	jinb.park7@gmail.com
Subject: [PATCH 1/2] randstruct: fix a bug in is_pure_ops_struct()
Message-ID: <2ba5ebfa2c622ece4952b5068b4154213794e5c4.1564595346.git.kjw1627@gmail.com>
References: <cover.1564595346.git.kjw1627@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1564595346.git.kjw1627@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)

Before this, there were false negatives in the case where a struct
contains other structs which contain only function pointers because
of unreachable code in is_pure_ops_struct().

Signed-off-by: Joonwon Kang <kjw1627@gmail.com>
---
 scripts/gcc-plugins/randomize_layout_plugin.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/scripts/gcc-plugins/randomize_layout_plugin.c b/scripts/gcc-plugins/randomize_layout_plugin.c
index 6d5bbd31db7f..bd29e4e7a524 100644
--- a/scripts/gcc-plugins/randomize_layout_plugin.c
+++ b/scripts/gcc-plugins/randomize_layout_plugin.c
@@ -443,13 +443,13 @@ static int is_pure_ops_struct(const_tree node)
 		if (node == fieldtype)
 			continue;
 
-		if (!is_fptr(fieldtype))
-			return 0;
-
-		if (code != RECORD_TYPE && code != UNION_TYPE)
+		if (code == RECORD_TYPE || code == UNION_TYPE) {
+			if (!is_pure_ops_struct(fieldtype))
+				return 0;
 			continue;
+		}
 
-		if (!is_pure_ops_struct(fieldtype))
+		if (!is_fptr(fieldtype))
 			return 0;
 	}
 
-- 
2.17.1

