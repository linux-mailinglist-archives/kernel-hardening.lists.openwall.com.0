Return-Path: <kernel-hardening-return-16219-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 55FAD51AFA
	for <lists+kernel-hardening@lfdr.de>; Mon, 24 Jun 2019 20:52:34 +0200 (CEST)
Received: (qmail 5639 invoked by uid 550); 24 Jun 2019 18:52:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 5618 invoked from network); 24 Jun 2019 18:52:27 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FdoCyudKahKj0SWzDQQDRaNFjjN47T56TpYdFnqFN6Q=;
        b=kRGp38NKS88PVk+PViUY9+FG3kBjzBKqSGfcz5+5Y/W1/Jr3BFxvcCOuP4Qw0e2AFh
         wyrqr51vZkMW0DZdoGKB/tmVWR/CceaUKmxuF/RVBO05jo34VAEDxe6UOfmG7RbiBNcK
         JgcXh21EPzd8g8mq2UI/qbk9CH2EdMoBLaxgs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FdoCyudKahKj0SWzDQQDRaNFjjN47T56TpYdFnqFN6Q=;
        b=QZmhqTUMn38WQN4BzVytJfsM+QjsokKbcblAzsvakeCmdLvVYrCkDIu6MgKDEkyq8J
         zuhcWTZjJ4NDUTXvHXKJz/1rsK5w4/ANCgsYC7XmclIvCIkPDInXVrX9h7PZv6EC5PbH
         mhfCIlA9bpe9ehyPRTNcB07UWDTcrXhtA//BVcsJ8pysHPBd6T+dyx79WwaaiqC4nrkL
         Bv9NYsetlphzeOKV/8nscEMlysk3NuQ4vJsPXWSfzGj9gKw2Pd1QbxqeQkMJfigZgA7X
         P9XPBFhkxEZeHIBVh4wM/D/tz5gmhbQ9S3mS0yxpeYjTuGPQcN5kt0c0QPAcv6Lj7L2v
         XisQ==
X-Gm-Message-State: APjAAAWl6hK1W+dRnP72rkGVhn+3XDnqAQGj6BGGPU8/1ldM5I0kjXtv
	c+RxfTt2U2/4oEPqL2WKNkCb4A==
X-Google-Smtp-Source: APXvYqzlPMsfW8n2Fv5r2ooDKckw1uxgUmNEhj3pMv44Vv4CLYlBzRSS8TeY1keIvJ9fHxuKW3rh7Q==
X-Received: by 2002:a0c:8705:: with SMTP id 5mr3904110qvh.32.1561402335797;
        Mon, 24 Jun 2019 11:52:15 -0700 (PDT)
Date: Mon, 24 Jun 2019 14:52:14 -0400
From: Joel Fernandes <joel@joelfernandes.org>
To: linux-kernel@vger.kernel.org
Cc: jannh@google.com, oleg@redhat.com, mathieu.desnoyers@efficios.com,
	willy@infradead.org, peterz@infradead.org, will.deacon@arm.com,
	paulmck@linux.vnet.ibm.com, elena.reshetova@intel.com,
	keescook@chromium.org, kernel-team@android.com,
	kernel-hardening@lists.openwall.com,
	Andrew Morton <akpm@linux-foundation.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH RFC v2] Convert struct pid count to refcount_t
Message-ID: <20190624185214.GA211230@google.com>
References: <20190624184534.209896-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190624184534.209896-1-joel@joelfernandes.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Jun 24, 2019 at 02:45:34PM -0400, Joel Fernandes (Google) wrote:
> struct pid's count is an atomic_t field used as a refcount. Use
> refcount_t for it which is basically atomic_t but does additional
> checking to prevent use-after-free bugs.
> 
> For memory ordering, the only change is with the following:
>  -	if ((atomic_read(&pid->count) == 1) ||
>  -	     atomic_dec_and_test(&pid->count)) {
>  +	if (refcount_dec_and_test(&pid->count)) {
>  		kmem_cache_free(ns->pid_cachep, pid);
> 
> Here the change is from:
> Fully ordered --> RELEASE + ACQUIRE (as per refcount-vs-atomic.rst)
> This ACQUIRE should take care of making sure the free happens after the
> refcount_dec_and_test().
> 
> The above hunk also removes atomic_read() since it is not needed for the
> code to work and it is unclear how beneficial it is. The removal lets
> refcount_dec_and_test() check for cases where get_pid() happened before
> the object was freed.
> 
> Cc: jannh@google.com
> Cc: oleg@redhat.com
> Cc: mathieu.desnoyers@efficios.com
> Cc: willy@infradead.org
> Cc: peterz@infradead.org
> Cc: will.deacon@arm.com
> Cc: paulmck@linux.vnet.ibm.com
> Cc: elena.reshetova@intel.com
> Cc: keescook@chromium.org
> Cc: kernel-team@android.com
> Cc: kernel-hardening@lists.openwall.com
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> 
> ---
> Changed to RFC to get any feedback on the memory ordering.

I had a question about refcount_inc().

As per Documentation/core-api/refcount-vs-atomic.rst , it says:

A control dependency (on success) for refcounters guarantees that
if a reference for an object was successfully obtained (reference
counter increment or addition happened, function returned true),
then further stores are ordered against this operation.

However, in refcount_inc() I don't see any memory barriers (in the case where
CONFIG_REFCOUNT_FULL=n). Is the documentation wrong?

get_pid() does a refcount_inc() but doesn't have any memory barriers either.

thanks,

 - Joel


> 
>  include/linux/pid.h | 5 +++--
>  kernel/pid.c        | 7 +++----
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/pid.h b/include/linux/pid.h
> index 14a9a39da9c7..8cb86d377ff5 100644
> --- a/include/linux/pid.h
> +++ b/include/linux/pid.h
> @@ -3,6 +3,7 @@
>  #define _LINUX_PID_H
>  
>  #include <linux/rculist.h>
> +#include <linux/refcount.h>
>  
>  enum pid_type
>  {
> @@ -56,7 +57,7 @@ struct upid {
>  
>  struct pid
>  {
> -	atomic_t count;
> +	refcount_t count;
>  	unsigned int level;
>  	/* lists of tasks that use this pid */
>  	struct hlist_head tasks[PIDTYPE_MAX];
> @@ -69,7 +70,7 @@ extern struct pid init_struct_pid;
>  static inline struct pid *get_pid(struct pid *pid)
>  {
>  	if (pid)
> -		atomic_inc(&pid->count);
> +		refcount_inc(&pid->count);
>  	return pid;
>  }
>  
> diff --git a/kernel/pid.c b/kernel/pid.c
> index 20881598bdfa..89c4849fab5d 100644
> --- a/kernel/pid.c
> +++ b/kernel/pid.c
> @@ -37,7 +37,7 @@
>  #include <linux/init_task.h>
>  #include <linux/syscalls.h>
>  #include <linux/proc_ns.h>
> -#include <linux/proc_fs.h>
> +#include <linux/refcount.h>
>  #include <linux/sched/task.h>
>  #include <linux/idr.h>
>  
> @@ -106,8 +106,7 @@ void put_pid(struct pid *pid)
>  		return;
>  
>  	ns = pid->numbers[pid->level].ns;
> -	if ((atomic_read(&pid->count) == 1) ||
> -	     atomic_dec_and_test(&pid->count)) {
> +	if (refcount_dec_and_test(&pid->count)) {
>  		kmem_cache_free(ns->pid_cachep, pid);
>  		put_pid_ns(ns);
>  	}
> @@ -210,7 +209,7 @@ struct pid *alloc_pid(struct pid_namespace *ns)
>  	}
>  
>  	get_pid_ns(ns);
> -	atomic_set(&pid->count, 1);
> +	refcount_set(&pid->count, 1);
>  	for (type = 0; type < PIDTYPE_MAX; ++type)
>  		INIT_HLIST_HEAD(&pid->tasks[type]);
>  
> -- 
> 2.22.0.410.gd8fdbe21b5-goog
