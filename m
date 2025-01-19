Return-Path: <kernel-hardening-return-21920-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by mail.lfdr.de (Postfix) with SMTP id 4B148A1638F
	for <lists+kernel-hardening@lfdr.de>; Sun, 19 Jan 2025 19:35:21 +0100 (CET)
Received: (qmail 1910 invoked by uid 550); 19 Jan 2025 18:35:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1878 invoked from network); 19 Jan 2025 18:35:12 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ethancedwards.com;
	s=MBO0001; t=1737311701;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=4V7XghkPcR0oVjcTycJK4e/iLGu3i4fave38Oa1IOEA=;
	b=Jq01H3T1i9TakgR4RHf/FVBZk0960qa693M6NsvAv6GK9k8MblXPQMkB27j/F+tgncsZcJ
	yX6RhpekAyKhyE4qM3b6xgw8fBgCoF2oYUvVulZk9qHKQEr4v/1TKeUJFk1eiSkSpLXi7K
	BdPHE3W3E0ci+N1LP4ADU6WOUKMLacgvXFcfIweOj9oC0MnS+Ind3I4i7gM7Gkjkh5/uOZ
	b1qF9FwuoxPCMVauv8cb8X9BkZKj0Rl5j07Bl4zLg5l33xh8cnC4r2v7FwY5TkL6e55OdN
	CZ5uG9LchWBYO9FhmgDlXXOSQYfpNxRug1dQpqlYVCPHrMNOz6o0SvZ9VHejDQ==
Date: Sun, 19 Jan 2025 13:34:58 -0500
From: Ethan Carter Edwards <ethan@ethancedwards.com>
To: "rafael@kernel.org" <rafael@kernel.org>
Cc: "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>, 
	"linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, 
	"linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>
Subject: [PATCH v3] thermal/debugfs: change kzalloc to kcalloc
Message-ID: <dmv2euctawmijgffigu7qr4yn7jtby4afuy5fgymq6s35c5elu@inovmydfkaez>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 4YbhwP5Kw7z9scJ

We are replacing any instances of kzalloc(size * count, ...) with
kcalloc(count, size, ...) due to risk of overflow [1].

[1] https://www.kernel.org/doc/html/next/process/deprecated.html#open-coded-arithmetic-in-allocator-arguments
Link: https://github.com/KSPP/linux/issues/162

Signed-off-by: Ethan Carter Edwards <ethan@ethancedwards.com>
---
 v3: fix description and email client formatting
 v2: fix typo
 drivers/thermal/thermal_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/thermal_debugfs.c b/drivers/thermal/thermal_debugfs.c
index c800504c3cfe..29dc1431a252 100644
--- a/drivers/thermal/thermal_debugfs.c
+++ b/drivers/thermal/thermal_debugfs.c
@@ -876,7 +876,7 @@ void thermal_debug_tz_add(struct thermal_zone_device *tz)
 
 	tz_dbg->tz = tz;
 
-	tz_dbg->trips_crossed = kzalloc(sizeof(int) * tz->num_trips, GFP_KERNEL);
+	tz_dbg->trips_crossed = kcalloc(tz->num_trips, sizeof(int), GFP_KERNEL);
 	if (!tz_dbg->trips_crossed) {
 		thermal_debugfs_remove_id(thermal_dbg);
 		return;
-- 
2.47.1

