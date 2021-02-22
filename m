Return-Path: <kernel-hardening-return-20793-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id AAF1C321B07
	for <lists+kernel-hardening@lfdr.de>; Mon, 22 Feb 2021 16:16:46 +0100 (CET)
Received: (qmail 24183 invoked by uid 550); 22 Feb 2021 15:13:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 24073 invoked from network); 22 Feb 2021 15:13:09 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7hFnLRkgd4Q0qw+7HAuuUUWLWJVPby5EiSXIS4L9oGQ=;
        b=dT612FLTVPEz8XRs6mxabgghhhSms68v480SapGnLo7hxIioNIX+ObgFDoRQuVg5S4
         vAVjOP6C0XlZwDHg1qPCuB3tf2Pelmamb5mfcceNfCa1UKyeyViUmHUDJLgRyS1ut308
         d6TQwzb2cIwABwhaJE0AC9Ea3QBZmVSiWT6J9nwYqR8z6JVLP5fJE5i7M0yDxSmIXt05
         jb6IJgXvyo1XkwSxbrpfoSdTcvnYX3nSJuSSWWDgrOrB/SDGqpZr0xz1rKH6bR7QMYGV
         4nNuhf2kPoPdYm6w3edgiTNVx81wadjOmh2Nx8odGuQJ8uG/3NxzX2wbLm4vQfJ9UCZD
         5FiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7hFnLRkgd4Q0qw+7HAuuUUWLWJVPby5EiSXIS4L9oGQ=;
        b=S/jzfpmab7eO6XKPmGZx/9OL0iIwWL6IuyeDHQPwlra8J/bw4kwFyEEYE7DVEJCV5t
         W12CEdYX4OwHpfpx5fdEBWOW5u22QJFXSbhJuU/XYZzF5ur8Pn/77jTGoXJt2y6PJq6h
         Zbp+iqvent6WbMoxxDIY8aPHMb0/hRq0VNHzc+1/y4Fu0imXOFYImne+JeYqQHcHrX4s
         zLBg+BLT0RpJqKC5Vjff1uiwe0ZWFdt19uPWmz4I/GFghnyQYW+Vwc7tMEKoLo7Hwsh8
         7zBNR5nmyLLsfgEBwxUrk+tInY1l/mQI4jP8/VM+pvNT2H4OM0+u9Qsvupq/cEq5Oz+z
         Uagg==
X-Gm-Message-State: AOAM531MftJEIvPatHNskcKNoAbG7U4caXSGOSlw/9lm5V06IQyB931U
	7FYjimJf9JEO9pm4H3HiqzE=
X-Google-Smtp-Source: ABdhPJzVilHCS3gxDmaUXrsQs/QpvPLFYyKQGlIV5aFkTOiZdT7NP4nfll4p9JTad+ZeVYS+ou+FOA==
X-Received: by 2002:a05:600c:3399:: with SMTP id o25mr20222396wmp.13.1614006777981;
        Mon, 22 Feb 2021 07:12:57 -0800 (PST)
From: Romain Perier <romain.perier@gmail.com>
To: Kees Cook <keescook@chromium.org>,
	kernel-hardening@lists.openwall.com,
	Steffen Maier <maier@linux.ibm.com>,
	Benjamin Block <bblock@linux.ibm.com>
Cc: Romain Perier <romain.perier@gmail.com>,
	linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 13/20] scsi: zfcp: Manual replacement of the deprecated strlcpy() with return values
Date: Mon, 22 Feb 2021 16:12:24 +0100
Message-Id: <20210222151231.22572-14-romain.perier@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210222151231.22572-1-romain.perier@gmail.com>
References: <20210222151231.22572-1-romain.perier@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The strlcpy() reads the entire source buffer first, it is dangerous if
the source buffer lenght is unbounded or possibility non NULL-terminated.
It can lead to linear read overflows, crashes, etc...

As recommended in the deprecated interfaces [1], it should be replaced
by strscpy.

This commit replaces all calls to strlcpy that handle the return values
by the corresponding strscpy calls with new handling of the return
values (as it is quite different between the two functions).

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy

Signed-off-by: Romain Perier <romain.perier@gmail.com>
---
 drivers/s390/scsi/zfcp_fc.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_fc.c b/drivers/s390/scsi/zfcp_fc.c
index d24cafe02708..8a65241011b9 100644
--- a/drivers/s390/scsi/zfcp_fc.c
+++ b/drivers/s390/scsi/zfcp_fc.c
@@ -877,14 +877,16 @@ static void zfcp_fc_rspn(struct zfcp_adapter *adapter,
 	struct zfcp_fsf_ct_els *ct_els = &fc_req->ct_els;
 	struct zfcp_fc_rspn_req *rspn_req = &fc_req->u.rspn.req;
 	struct fc_ct_hdr *rspn_rsp = &fc_req->u.rspn.rsp;
-	int ret, len;
+	int ret;
+	ssize_t len;
 
 	zfcp_fc_ct_ns_init(&rspn_req->ct_hdr, FC_NS_RSPN_ID,
 			   FC_SYMBOLIC_NAME_SIZE);
 	hton24(rspn_req->rspn.fr_fid.fp_fid, fc_host_port_id(shost));
-	len = strlcpy(rspn_req->rspn.fr_name, fc_host_symbolic_name(shost),
+	len = strscpy(rspn_req->rspn.fr_name, fc_host_symbolic_name(shost),
 		      FC_SYMBOLIC_NAME_SIZE);
-	rspn_req->rspn.fr_name_len = len;
+	if (len != -E2BIG)
+		rspn_req->rspn.fr_name_len = len;
 
 	sg_init_one(&fc_req->sg_req, rspn_req, sizeof(*rspn_req));
 	sg_init_one(&fc_req->sg_rsp, rspn_rsp, sizeof(*rspn_rsp));

