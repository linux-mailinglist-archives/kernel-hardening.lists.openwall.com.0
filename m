Return-Path: <kernel-hardening-return-20785-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 18BD5321AE9
	for <lists+kernel-hardening@lfdr.de>; Mon, 22 Feb 2021 16:14:12 +0100 (CET)
Received: (qmail 22371 invoked by uid 550); 22 Feb 2021 15:13:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 22326 invoked from network); 22 Feb 2021 15:12:59 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=S1lCywCtYVxEsnuw6UX2uJMQ5VyTPpsEmxTnLQJHs4w=;
        b=rWf86sGXPcNotlzO6S3Y7LO5Nm2WfrkvTP72KQo9Y1VVv5HcanSJASCmDSQC/FvS4l
         4X+BnIYovgNuWrjBcRMMgByxaJJKo+WuEdB5B4TeeH5KAB/k0o74OaToO8dP5U+NeEuv
         kjZevojzhOKXgUYIqK4jZ7+a8FFI4fyWPiYx976xmPlhyZGLbZFjCJRnjHuPAx0agih+
         CBwler96z49x42STZP1ftWGwflDrYvL5xmIdJrvmSrGhRlJ+bHCMVys2WE6akJcWlLDD
         pN58SYbZPSp/1g7GyQVoqT/QQavBz69bDTBxGFZjGXmlE5vLK087Q62L8G+gsKUJ9TPk
         vUPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S1lCywCtYVxEsnuw6UX2uJMQ5VyTPpsEmxTnLQJHs4w=;
        b=KwuOYqDblSW/x4EpBD8XkbVEvF3kSJMD0QDaGn6EE35a/TAi0L68ltziH7x9XeP3Iu
         q+2HID3AVdab6n3BSoNYf/0BMiKNbZHVMttGMjBRTmVtmR4hENb0eQB8WJCAFN14UYEL
         0Jm+sy3bRvAB0z8YTrE6cyZqfkcLUUEoNp+O3bE+4RoDdZmoO9yj08Ir5g5rKgCq3eAf
         pCWz3V+l/j3lLAo7tclSAoBjiBbwXAn7L4TO6dKS6C5Rv1KD4fZk/HMezddpoqEHVsyK
         bJhUnoSP77aSW7z6Al/ktZhoWPFPPD3s3kydNpyqMsM40Uyj56CzTDVVkm5OatKpM2gw
         g2sA==
X-Gm-Message-State: AOAM532uj85k+8GLi+VCjld9Oa4Dgm8zZ9Ks4ihkQSVwGtJD2XJctwzw
	JsxPsS7LXqxsxbb/aD9ZVBM=
X-Google-Smtp-Source: ABdhPJxdv2k+gVDTX8PjxaPQz6UiDFMRMwv8LZF9w+l6PKqIasSjklSPneGhJPBCNfwEJDSzCT51jg==
X-Received: by 2002:a7b:c14d:: with SMTP id z13mr14117614wmi.6.1614006768018;
        Mon, 22 Feb 2021 07:12:48 -0800 (PST)
From: Romain Perier <romain.perier@gmail.com>
To: Kees Cook <keescook@chromium.org>,
	kernel-hardening@lists.openwall.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Romain Perier <romain.perier@gmail.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 05/20] kobject: Manual replacement of the deprecated strlcpy() with return values
Date: Mon, 22 Feb 2021 16:12:16 +0100
Message-Id: <20210222151231.22572-6-romain.perier@gmail.com>
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
 lib/kobject_uevent.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index 7998affa45d4..9dca89b76a22 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -251,11 +251,11 @@ static int kobj_usermode_filter(struct kobject *kobj)
 
 static int init_uevent_argv(struct kobj_uevent_env *env, const char *subsystem)
 {
-	int len;
+	ssize_t len;
 
-	len = strlcpy(&env->buf[env->buflen], subsystem,
+	len = strscpy(&env->buf[env->buflen], subsystem,
 		      sizeof(env->buf) - env->buflen);
-	if (len >= (sizeof(env->buf) - env->buflen)) {
+	if (len == -E2BIG) {
 		WARN(1, KERN_ERR "init_uevent_argv: buffer size too small\n");
 		return -ENOMEM;
 	}

