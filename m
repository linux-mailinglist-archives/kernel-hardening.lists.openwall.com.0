Return-Path: <kernel-hardening-return-16933-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 8F64EBE6D5
	for <lists+kernel-hardening@lfdr.de>; Wed, 25 Sep 2019 23:02:55 +0200 (CEST)
Received: (qmail 11957 invoked by uid 550); 25 Sep 2019 21:02:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 11934 invoked from network); 25 Sep 2019 21:02:47 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :content-transfer-encoding;
        bh=7xhrP95QBYJiSF2YxdsM/vyNYpW4G7L9q0PwFgts0Eg=;
        b=PhYrdbXFW7DxjoTBihqkbscUj3ihaM+7AY9Uko1qzd/uFoRL8eCcWcrRFhuukFI+Oz
         tHzDS4E8nYIttCuj/nMIfyN+ttt8eZInD6Ld0sgEK6AuJlEQGAUO5CV2x0pMB6curxMS
         NQeJZM+/oKiZHqo7s+oNvkBKelSGTUnca6lg8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding;
        bh=7xhrP95QBYJiSF2YxdsM/vyNYpW4G7L9q0PwFgts0Eg=;
        b=ezks/dUjFpam1IPQPKHLt8IXTMM6LP6WXCANBsxB45sbNMMY6ZZDsf86PIRw26UmYO
         p5yO4XABHJ/tKshOt9JvrUiM2hmcolwLBhEK6F41LIMOK5tjr/PYI8asDmaUPQZM615S
         aA4eJnNrv8r74gNO2IXBaxc3z4dP5w+5qNLZbgUN/nV9RIDh9WKJfYPecKNwyQ77viaV
         /UTR7r7WRIzjr0K3PqRjWt22tCmJPsBT7u0aQxSD77FrrY8ds8cn9OHcV8Lwpr5zY4FH
         oZlxrLj5WCwFi6TFSetO3CZpRGJKSBl+4uX6tGUskp9FXWotH2uDBiUZ69TiwEvPy/F2
         ohSw==
X-Gm-Message-State: APjAAAXimKnSQicrp035TGA98wpiVT1gvtLebtGGNdejBTOO4e0kXJiu
	pWJC0xtUXVG7hVg/jfZ5IYi6pQ==
X-Google-Smtp-Source: APXvYqy8enN66HCBAXgdyj2WiN3UN+3QBv7218MOZV3xhCqI5u1BW3NXe4CmUibg81qEWdaXeJbpZA==
X-Received: by 2002:a17:90a:8c14:: with SMTP id a20mr8916240pjo.45.1569445355367;
        Wed, 25 Sep 2019 14:02:35 -0700 (PDT)
Date: Wed, 25 Sep 2019 14:02:33 -0700
From: Kees Cook <keescook@chromium.org>
To: Paul Moore <paul@paul-moore.com>
Cc: linux-kernel@vger.kernel.org,
	=?iso-8859-1?Q?J=E9r=E9mie?= Galarneau <jeremie.galarneau@efficios.com>,
	s.mesoraca16@gmail.com, viro@zeniv.linux.org.uk,
	dan.carpenter@oracle.com, akpm@linux-foundation.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	kernel-hardening@lists.openwall.com, linux-audit@redhat.com,
	torvalds@linux-foundation.org
Subject: [PATCH] audit: Report suspicious O_CREAT usage
Message-ID: <201909251348.A1542A52@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

This renames the very specific audit_log_link_denied() to
audit_log_path_denied() and adds the AUDIT_* type as an argument. This
allows for the creation of the new AUDIT_ANOM_CREAT that can be used to
report the fifo/regular file creation restrictions that were introduced
in commit 30aba6656f61 ("namei: allow restricted O_CREAT of FIFOs and
regular files"). Without this change, discovering that the restriction
is enabled can be very challenging:
https://lore.kernel.org/lkml/CA+jJMxvkqjXHy3DnV5MVhFTL2RUhg0WQ-XVFW3ngDQOdkFq0PA@mail.gmail.com

Reported-by: J�r�mie Galarneau <jeremie.galarneau@efficios.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
This is not a complete fix because reporting was broken in commit
15564ff0a16e ("audit: make ANOM_LINK obey audit_enabled and
audit_dummy_context")
which specifically goes against the intention of these records: they
should _always_ be reported. If auditing isn't enabled, they should be
ratelimited.

Instead of using audit, should this just go back to using
pr_ratelimited()?
---
 fs/namei.c                 |  7 +++++--
 include/linux/audit.h      |  5 +++--
 include/uapi/linux/audit.h |  1 +
 kernel/audit.c             | 11 ++++++-----
 4 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 671c3c1a3425..0e60f81e1d5a 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -925,7 +925,7 @@ static inline int may_follow_link(struct nameidata *nd)
 		return -ECHILD;
 
 	audit_inode(nd->name, nd->stack[0].link.dentry, 0);
-	audit_log_link_denied("follow_link");
+	audit_log_path_denied(AUDIT_ANOM_LINK, "follow_link");
 	return -EACCES;
 }
 
@@ -993,7 +993,7 @@ static int may_linkat(struct path *link)
 	if (safe_hardlink_source(inode) || inode_owner_or_capable(inode))
 		return 0;
 
-	audit_log_link_denied("linkat");
+	audit_log_path_denied(AUDIT_ANOM_LINK, "linkat");
 	return -EPERM;
 }
 
@@ -1031,6 +1031,9 @@ static int may_create_in_sticky(struct dentry * const dir,
 	    (dir->d_inode->i_mode & 0020 &&
 	     ((sysctl_protected_fifos >= 2 && S_ISFIFO(inode->i_mode)) ||
 	      (sysctl_protected_regular >= 2 && S_ISREG(inode->i_mode))))) {
+		audit_log_path_denied(AUDIT_ANOM_CREAT,
+				      S_ISFIFO(inode->i_mode) ? "fifo"
+							      : "regular");
 		return -EACCES;
 	}
 	return 0;
diff --git a/include/linux/audit.h b/include/linux/audit.h
index aee3dc9eb378..b3715e2ee1c5 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -156,7 +156,8 @@ extern void		    audit_log_d_path(struct audit_buffer *ab,
 					     const struct path *path);
 extern void		    audit_log_key(struct audit_buffer *ab,
 					  char *key);
-extern void		    audit_log_link_denied(const char *operation);
+extern void		    audit_log_path_denied(int type,
+						  const char *operation);
 extern void		    audit_log_lost(const char *message);
 
 extern int audit_log_task_context(struct audit_buffer *ab);
@@ -217,7 +218,7 @@ static inline void audit_log_d_path(struct audit_buffer *ab,
 { }
 static inline void audit_log_key(struct audit_buffer *ab, char *key)
 { }
-static inline void audit_log_link_denied(const char *string)
+static inline void audit_log_path_denied(int type, const char *string);
 { }
 static inline int audit_log_task_context(struct audit_buffer *ab)
 {
diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index c89c6495983d..3ad935527177 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -143,6 +143,7 @@
 #define AUDIT_ANOM_PROMISCUOUS      1700 /* Device changed promiscuous mode */
 #define AUDIT_ANOM_ABEND            1701 /* Process ended abnormally */
 #define AUDIT_ANOM_LINK		    1702 /* Suspicious use of file links */
+#define AUDIT_ANOM_CREAT	    1703 /* Suspicious file creation */
 #define AUDIT_INTEGRITY_DATA	    1800 /* Data integrity verification */
 #define AUDIT_INTEGRITY_METADATA    1801 /* Metadata integrity verification */
 #define AUDIT_INTEGRITY_STATUS	    1802 /* Integrity enable status */
diff --git a/kernel/audit.c b/kernel/audit.c
index da8dc0db5bd3..ed7402ac81b6 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -2155,18 +2155,19 @@ void audit_log_task_info(struct audit_buffer *ab)
 EXPORT_SYMBOL(audit_log_task_info);
 
 /**
- * audit_log_link_denied - report a link restriction denial
- * @operation: specific link operation
+ * audit_log_path_denied - report a path restriction denial
+ * @type: audit message type (AUDIT_ANOM_LINK, AUDIT_ANOM_CREAT, etc)
+ * @operation: specific operation name
  */
-void audit_log_link_denied(const char *operation)
+void audit_log_path_denied(int type, const char *operation)
 {
 	struct audit_buffer *ab;
 
 	if (!audit_enabled || audit_dummy_context())
 		return;
 
-	/* Generate AUDIT_ANOM_LINK with subject, operation, outcome. */
-	ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_ANOM_LINK);
+	/* Generate log with subject, operation, outcome. */
+	ab = audit_log_start(audit_context(), GFP_KERNEL, type);
 	if (!ab)
 		return;
 	audit_log_format(ab, "op=%s", operation);
-- 
2.17.1


-- 
Kees Cook
