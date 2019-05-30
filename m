Return-Path: <kernel-hardening-return-16013-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id B4A432FEE2
	for <lists+kernel-hardening@lfdr.de>; Thu, 30 May 2019 17:06:34 +0200 (CEST)
Received: (qmail 5255 invoked by uid 550); 30 May 2019 15:06:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 5228 invoked from network); 30 May 2019 15:06:24 -0000
From: "Paul E. McKenney" <paulmck@linux.ibm.com>
To: rcu@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, jiangshanlai@gmail.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, fweisbec@gmail.com,
        oleg@redhat.com, joel@joelfernandes.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        paulmck@linux.vnet.ibm.com, kernel-hardening@lists.openwall.com,
        kernel-team@android.com, "Paul E . McKenney" <paulmck@linux.ibm.com>
Subject: [PATCH tip/core/rcu 3/4] module: Make srcu_struct ptr array as read-only
Date: Thu, 30 May 2019 08:04:48 -0700
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190530150347.GA31311@linux.ibm.com>
References: <20190530150347.GA31311@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19053015-0060-0000-0000-00000349F73B
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011185; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01210787; UDB=6.00636159; IPR=6.00991822;
 MB=3.00027120; MTD=3.00000008; XFM=3.00000015; UTC=2019-05-30 15:06:10
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19053015-0061-0000-0000-0000498DFDC1
Message-Id: <20190530150449.31885-3-paulmck@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-30_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=13 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905300107

From: "Joel Fernandes (Google)" <joel@joelfernandes.org>

Since commit title ("srcu: Allocate per-CPU data for DEFINE_SRCU() in
modules"), modules that call DEFINE_{STATIC,}SRCU will have a new array
of srcu_struct pointers, which is used by srcu code to initialize and
clean up these structures and save valuable per-cpu reserved space.

There is no reason for this array of pointers to be writable, and can
cause security or other hidden bugs. Mark these are read-only after the
module init has completed.

Tested with the following diff to ensure array not writable:

(diff is a bit reduced to avoid patch command getting confused)
 a/kernel/module.c
 b/kernel/module.c
  -3506,6 +3506,14  static noinline int do_init_module [snip]
 	rcu_assign_pointer(mod->kallsyms, &mod->core_kallsyms);
 #endif
 	module_enable_ro(mod, true);
+
+	if (mod->srcu_struct_ptrs) {
+		// Check if srcu_struct_ptrs access is possible
+		char x = *(char *)mod->srcu_struct_ptrs;
+		*(char *)mod->srcu_struct_ptrs = 0;
+		*(char *)mod->srcu_struct_ptrs = x;
+	}
+
 	mod_tree_remove_init(mod);
 	disable_ro_nx(&mod->init_layout);
 	module_arch_freeing_init(mod);

Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: paulmck@linux.vnet.ibm.com
Cc: rostedt@goodmis.org
Cc: mathieu.desnoyers@efficios.com
Cc: rcu@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com
Cc: kernel-team@android.com
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.ibm.com>
---
 include/linux/srcutree.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/srcutree.h b/include/linux/srcutree.h
index 8af1824c46a8..9cfcc8a756ae 100644
--- a/include/linux/srcutree.h
+++ b/include/linux/srcutree.h
@@ -123,7 +123,7 @@ struct srcu_struct {
 #ifdef MODULE
 # define __DEFINE_SRCU(name, is_static)					\
 	is_static struct srcu_struct name;				\
-	struct srcu_struct *__srcu_struct_##name			\
+	struct srcu_struct * const __srcu_struct_##name			\
 		__section("___srcu_struct_ptrs") = &name
 #else
 # define __DEFINE_SRCU(name, is_static)					\
-- 
2.17.1

