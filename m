Return-Path: <kernel-hardening-return-17893-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 4662D16AB70
	for <lists+kernel-hardening@lfdr.de>; Mon, 24 Feb 2020 17:29:40 +0100 (CET)
Received: (qmail 20476 invoked by uid 550); 24 Feb 2020 16:29:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 20434 invoked from network); 24 Feb 2020 16:29:33 -0000
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,  LKML <linux-kernel@vger.kernel.org>,  Kernel Hardening <kernel-hardening@lists.openwall.com>,  Linux API <linux-api@vger.kernel.org>,  Linux FS Devel <linux-fsdevel@vger.kernel.org>,  Linux Security Module <linux-security-module@vger.kernel.org>,  Akinobu Mita <akinobu.mita@gmail.com>,  Alexey Dobriyan <adobriyan@gmail.com>,  Andrew Morton <akpm@linux-foundation.org>,  Andy Lutomirski <luto@kernel.org>,  Daniel Micay <danielmicay@gmail.com>,  Djalal Harouni <tixxdz@gmail.com>,  "Dmitry V . Levin" <ldv@altlinux.org>,  Greg Kroah-Hartman <gregkh@linuxfoundation.org>,  Ingo Molnar <mingo@kernel.org>,  "J . Bruce Fields" <bfields@fieldses.org>,  Jeff Layton <jlayton@poochiereds.net>,  Jonathan Corbet <corbet@lwn.net>,  Kees Cook <keescook@chromium.org>,  Oleg Nesterov <oleg@redhat.com>,  Solar Designer <solar@openwall.com>,  Alexey Gladkov <gladkov.alexey@gmail.com>
References: <20200210150519.538333-8-gladkov.alexey@gmail.com>
	<87v9odlxbr.fsf@x220.int.ebiederm.org>
	<20200212144921.sykucj4mekcziicz@comp-core-i7-2640m-0182e6>
	<87tv3vkg1a.fsf@x220.int.ebiederm.org>
	<CAHk-=wg52stFtUxMOxs3afkwDWmWn1JXC7RJ7dPsTrJbnxpZVg@mail.gmail.com>
	<87v9obipk9.fsf@x220.int.ebiederm.org>
	<CAHk-=wgwmu4jpmOqW0+Lz0dcem1Fub=ThLHvmLobf_WqCq7bwg@mail.gmail.com>
	<20200212200335.GO23230@ZenIV.linux.org.uk>
	<CAHk-=wi+1CPShMFvJNPfnrJ8DD8uVKUOQ5TQzQUNGLUkeoahkg@mail.gmail.com>
	<20200212203833.GQ23230@ZenIV.linux.org.uk>
	<20200212204124.GR23230@ZenIV.linux.org.uk>
	<CAHk-=wi5FOGV_3tALK3n6E2fK3Oa_yCYkYQtCSaXLSEm2DUCKg@mail.gmail.com>
	<87lfp7h422.fsf@x220.int.ebiederm.org>
	<CAHk-=wgmn9Qds0VznyphouSZW6e42GWDT5H1dpZg8pyGDGN+=w@mail.gmail.com>
	<87pnejf6fz.fsf@x220.int.ebiederm.org>
	<871rqpaswu.fsf_-_@x220.int.ebiederm.org>
	<871rqk2brn.fsf_-_@x220.int.ebiederm.org>
Date: Mon, 24 Feb 2020 10:27:17 -0600
In-Reply-To: <871rqk2brn.fsf_-_@x220.int.ebiederm.org> (Eric W. Biederman's
	message of "Mon, 24 Feb 2020 10:25:16 -0600")
Message-ID: <87pne40x3u.fsf_-_@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1j6Gbg-0007qC-Jo;;;mid=<87pne40x3u.fsf_-_@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/UflptKI2kFaz4P7DX3c7LedTcEBcQNz8=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa07.xmission.com
X-Spam-Level: *
X-Spam-Status: No, score=1.0 required=8.0 tests=ALL_TRUSTED,BAYES_50,
	DCC_CHECK_NEGATIVE,T_TooManySym_01,XMGappySubj_01,XMSubLong
	autolearn=disabled version=3.4.2
X-Spam-Report: 
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	*  0.5 XMGappySubj_01 Very gappy subject
	*  0.7 XMSubLong Long Subject
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=81]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=81 
X-Spam-Combo: *;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 344 ms - load_scoreonly_sql: 0.06 (0.0%),
	signal_user_changed: 2.9 (0.9%), b_tie_ro: 1.99 (0.6%), parse: 1.07
	(0.3%), extract_message_metadata: 12 (3.4%), get_uri_detail_list: 1.86
	(0.5%), tests_pri_-1000: 15 (4.3%), tests_pri_-950: 1.27 (0.4%),
	tests_pri_-900: 1.07 (0.3%), tests_pri_-90: 28 (8.1%), check_bayes: 26
	(7.7%), b_tokenize: 11 (3.2%), b_tok_get_all: 7 (2.1%), b_comp_prob:
	2.1 (0.6%), b_tok_touch_all: 3.7 (1.1%), b_finish: 0.66 (0.2%),
	tests_pri_0: 271 (78.8%), check_dkim_signature: 0.63 (0.2%),
	check_dkim_adsp: 2.2 (0.6%), poll_dns_idle: 0.68 (0.2%), tests_pri_10:
	2.1 (0.6%), tests_pri_500: 7 (2.1%), rewrite_mail: 0.00 (0.0%)
Subject: [PATCH v2 2/6] proc: Generalize proc_sys_prune_dcache into proc_prune_siblings_dcache
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)


This prepares the way for allowing the pid part of proc to use this
dcache pruning code as well.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/proc/inode.c       | 38 ++++++++++++++++++++++++++++++++++++++
 fs/proc/internal.h    |  1 +
 fs/proc/proc_sysctl.c | 35 +----------------------------------
 3 files changed, 40 insertions(+), 34 deletions(-)

diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index bdae442d5262..74ce4a8d05eb 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -103,6 +103,44 @@ void __init proc_init_kmemcache(void)
 	BUILD_BUG_ON(sizeof(struct proc_dir_entry) >= SIZEOF_PDE);
 }
 
+void proc_prune_siblings_dcache(struct hlist_head *inodes, spinlock_t *lock)
+{
+	struct inode *inode;
+	struct proc_inode *ei;
+	struct hlist_node *node;
+	struct super_block *sb;
+
+	rcu_read_lock();
+	for (;;) {
+		node = hlist_first_rcu(inodes);
+		if (!node)
+			break;
+		ei = hlist_entry(node, struct proc_inode, sibling_inodes);
+		spin_lock(lock);
+		hlist_del_init_rcu(&ei->sibling_inodes);
+		spin_unlock(lock);
+
+		inode = &ei->vfs_inode;
+		sb = inode->i_sb;
+		if (!atomic_inc_not_zero(&sb->s_active))
+			continue;
+		inode = igrab(inode);
+		rcu_read_unlock();
+		if (unlikely(!inode)) {
+			deactivate_super(sb);
+			rcu_read_lock();
+			continue;
+		}
+
+		d_prune_aliases(inode);
+		iput(inode);
+		deactivate_super(sb);
+
+		rcu_read_lock();
+	}
+	rcu_read_unlock();
+}
+
 static int proc_show_options(struct seq_file *seq, struct dentry *root)
 {
 	struct super_block *sb = root->d_sb;
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 366cd3aa690b..ba9a991824a5 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -210,6 +210,7 @@ extern const struct inode_operations proc_pid_link_inode_operations;
 extern const struct super_operations proc_sops;
 
 void proc_init_kmemcache(void);
+void proc_prune_siblings_dcache(struct hlist_head *inodes, spinlock_t *lock);
 void set_proc_pid_nlink(void);
 extern struct inode *proc_get_inode(struct super_block *, struct proc_dir_entry *);
 extern void proc_entry_rundown(struct proc_dir_entry *);
diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 42fbb7f3c587..5da9d7f7ae34 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -269,40 +269,7 @@ static void unuse_table(struct ctl_table_header *p)
 
 static void proc_sys_prune_dcache(struct ctl_table_header *head)
 {
-	struct inode *inode;
-	struct proc_inode *ei;
-	struct hlist_node *node;
-	struct super_block *sb;
-
-	rcu_read_lock();
-	for (;;) {
-		node = hlist_first_rcu(&head->inodes);
-		if (!node)
-			break;
-		ei = hlist_entry(node, struct proc_inode, sibling_inodes);
-		spin_lock(&sysctl_lock);
-		hlist_del_init_rcu(&ei->sibling_inodes);
-		spin_unlock(&sysctl_lock);
-
-		inode = &ei->vfs_inode;
-		sb = inode->i_sb;
-		if (!atomic_inc_not_zero(&sb->s_active))
-			continue;
-		inode = igrab(inode);
-		rcu_read_unlock();
-		if (unlikely(!inode)) {
-			deactivate_super(sb);
-			rcu_read_lock();
-			continue;
-		}
-
-		d_prune_aliases(inode);
-		iput(inode);
-		deactivate_super(sb);
-
-		rcu_read_lock();
-	}
-	rcu_read_unlock();
+	proc_prune_siblings_dcache(&head->inodes, &sysctl_lock);
 }
 
 /* called under sysctl_lock, will reacquire if has to wait */
-- 
2.25.0

