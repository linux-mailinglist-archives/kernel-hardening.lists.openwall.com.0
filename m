Return-Path: <kernel-hardening-return-20978-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id E80C933FDFF
	for <lists+kernel-hardening@lfdr.de>; Thu, 18 Mar 2021 05:04:36 +0100 (CET)
Received: (qmail 25969 invoked by uid 550); 18 Mar 2021 04:04:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 25934 invoked from network); 18 Mar 2021 04:04:29 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=k6xgS35NAw9ddV6Cg2946wYyG7dyozQ3RFEJ5VWEkSg=;
        b=FE2EqlDyohSlsRFmIQXSoIgcOEBN/pzThN8cUoIyESk+QjYoa2xpRG/VpOEwPKoCD5
         JNvFMK2A57S3cPAwF8B1Uf1DGZCrafeL8mRhNewTstJ4Ldm5VRQs8tSvUMd4zubMQ+T0
         Tvjv01Z9bZjcTsCPxDnX2x0EkNCuzowUOkp5Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=k6xgS35NAw9ddV6Cg2946wYyG7dyozQ3RFEJ5VWEkSg=;
        b=eZE5iuTldYz+/Cm9NLEc6ghL9JRqFhFBFJHhYvT7vkgYVt7Ech/lH6PAJ24Fe7VhrS
         VWdWeC0Cx86M/Goa2/XWrM3UyriAVf+U6813qGQOQTHO3bjq4q6ofYfkxXTuKXzei3dq
         XECJI8TVb3JMpsf45J2tnsqOuQFoiJ9W42NoeLV1hP6RCu7Mh22n2TwVVPLtTibrT7ga
         CnJZfMqKtPbIII1zpCOQUTJyPDdV01AlfR0a1qH3VxKutRVm+G1WapVAYavKlxJBLvYL
         BSI6kayEqVcNPGSjlI2flSv+hHkG66VQFSlNKwH0wlMYwtg+QTGfC+BDqI+eUOltQ1lR
         zgRg==
X-Gm-Message-State: AOAM532MXWdiugWuV4wgqgYyCf/AWt9hVbgwjFAppqWWZ3rdehwsyJ2d
	QLlafWtmPgiRkjnbNEOfEiBSnw==
X-Google-Smtp-Source: ABdhPJw8NebacgNtA8b8uA8z/4hFfYKnjGi0LvNBKxntVBxcJcXAhjh/h69nMKxiEvFxQzjsL0uG4Q==
X-Received: by 2002:a17:903:188:b029:e6:52f4:1b2d with SMTP id z8-20020a1709030188b02900e652f41b2dmr7757254plg.58.1616040257284;
        Wed, 17 Mar 2021 21:04:17 -0700 (PDT)
Date: Wed, 17 Mar 2021 21:04:15 -0700
From: Kees Cook <keescook@chromium.org>
To: John Wood <john.wood@gmx.com>
Cc: Jann Horn <jannh@google.com>, Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, James Morris <jmorris@namei.org>,
	Shuah Khan <shuah@kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andi Kleen <ak@linux.intel.com>,
	kernel test robot <oliver.sang@intel.com>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v6 5/8] security/brute: Mitigate a brute force attack
Message-ID: <202103172102.03F172613@keescook>
References: <20210307113031.11671-1-john.wood@gmx.com>
 <20210307113031.11671-6-john.wood@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210307113031.11671-6-john.wood@gmx.com>

On Sun, Mar 07, 2021 at 12:30:28PM +0100, John Wood wrote:
> In order to mitigate a brute force attack all the offending tasks involved
> in the attack must be killed. In other words, it is necessary to kill all
> the tasks that share the fork and/or exec statistical data related to the
> attack. Moreover, if the attack happens through the fork system call, the
> processes that have the same group_leader that the current task (the task
> that has crashed) must be avoided since they are in the path to be killed.
> 
> When the SIGKILL signal is sent to the offending tasks, the function
> "brute_kill_offending_tasks" will be called in a recursive way from the
> task_fatal_signal LSM hook due to a small crash period. So, to avoid kill
> again the same tasks due to a recursive call of this function, it is
> necessary to disable the attack detection for the involved hierarchies.
> 
> To disable the attack detection, set to zero the last crash timestamp and
> avoid to compute the application crash period in this case.
> 
> Signed-off-by: John Wood <john.wood@gmx.com>
> ---
>  security/brute/brute.c | 141 ++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 132 insertions(+), 9 deletions(-)
> 
> diff --git a/security/brute/brute.c b/security/brute/brute.c
> index 38e5e050964a..36a3286a02dd 100644
> --- a/security/brute/brute.c
> +++ b/security/brute/brute.c
> @@ -22,6 +22,7 @@
>  #include <linux/math64.h>
>  #include <linux/netdevice.h>
>  #include <linux/path.h>
> +#include <linux/pid.h>
>  #include <linux/printk.h>
>  #include <linux/refcount.h>
>  #include <linux/rwlock.h>
> @@ -64,7 +65,7 @@ struct brute_cred {
>   * @lock: Lock to protect the brute_stats structure.
>   * @refc: Reference counter.
>   * @faults: Number of crashes.
> - * @jiffies: Last crash timestamp.
> + * @jiffies: Last crash timestamp. If zero, the attack detection is disabled.
>   * @period: Crash period's moving average.
>   * @saved_cred: Saved credentials.
>   * @network: Network activity flag.
> @@ -571,6 +572,125 @@ static inline void print_fork_attack_running(void)
>  	pr_warn("Fork brute force attack detected [%s]\n", current->comm);
>  }
> 
> +/**
> + * brute_disabled() - Test if the brute force attack detection is disabled.
> + * @stats: Statistical data shared by all the fork hierarchy processes.
> + *
> + * The brute force attack detection enabling/disabling is based on the last
> + * crash timestamp. A zero timestamp indicates that this feature is disabled. A
> + * timestamp greater than zero indicates that the attack detection is enabled.
> + *
> + * The statistical data shared by all the fork hierarchy processes cannot be
> + * NULL.
> + *
> + * It's mandatory to disable interrupts before acquiring the brute_stats::lock
> + * since the task_free hook can be called from an IRQ context during the
> + * execution of the task_fatal_signal hook.
> + *
> + * Context: Must be called with interrupts disabled and brute_stats_ptr_lock
> + *          held.
> + * Return: True if the brute force attack detection is disabled. False
> + *         otherwise.
> + */
> +static bool brute_disabled(struct brute_stats *stats)
> +{
> +	bool disabled;
> +
> +	spin_lock(&stats->lock);
> +	disabled = !stats->jiffies;
> +	spin_unlock(&stats->lock);
> +
> +	return disabled;
> +}
> +
> +/**
> + * brute_disable() - Disable the brute force attack detection.
> + * @stats: Statistical data shared by all the fork hierarchy processes.
> + *
> + * To disable the brute force attack detection it is only necessary to set the
> + * last crash timestamp to zero. A zero timestamp indicates that this feature is
> + * disabled. A timestamp greater than zero indicates that the attack detection
> + * is enabled.
> + *
> + * The statistical data shared by all the fork hierarchy processes cannot be
> + * NULL.
> + *
> + * Context: Must be called with interrupts disabled and brute_stats_ptr_lock
> + *          and brute_stats::lock held.
> + */
> +static inline void brute_disable(struct brute_stats *stats)
> +{
> +	stats->jiffies = 0;
> +}
> +
> +/**
> + * enum brute_attack_type - Brute force attack type.
> + * @BRUTE_ATTACK_TYPE_FORK: Attack that happens through the fork system call.
> + * @BRUTE_ATTACK_TYPE_EXEC: Attack that happens through the execve system call.
> + */
> +enum brute_attack_type {
> +	BRUTE_ATTACK_TYPE_FORK,
> +	BRUTE_ATTACK_TYPE_EXEC,
> +};
> +
> +/**
> + * brute_kill_offending_tasks() - Kill the offending tasks.
> + * @attack_type: Brute force attack type.
> + * @stats: Statistical data shared by all the fork hierarchy processes.
> + *
> + * When a brute force attack is detected all the offending tasks involved in the
> + * attack must be killed. In other words, it is necessary to kill all the tasks
> + * that share the same statistical data. Moreover, if the attack happens through
> + * the fork system call, the processes that have the same group_leader that the
> + * current task must be avoided since they are in the path to be killed.
> + *
> + * When the SIGKILL signal is sent to the offending tasks, this function will be
> + * called again from the task_fatal_signal hook due to a small crash period. So,
> + * to avoid kill again the same tasks due to a recursive call of this function,
> + * it is necessary to disable the attack detection for this fork hierarchy.

Hah. Interesting. I wonder if there is a better way to handle this. Hmm.

> + *
> + * The statistical data shared by all the fork hierarchy processes cannot be
> + * NULL.
> + *
> + * It's mandatory to disable interrupts before acquiring the brute_stats::lock
> + * since the task_free hook can be called from an IRQ context during the
> + * execution of the task_fatal_signal hook.
> + *
> + * Context: Must be called with interrupts disabled and tasklist_lock and
> + *          brute_stats_ptr_lock held.
> + */
> +static void brute_kill_offending_tasks(enum brute_attack_type attack_type,
> +				       struct brute_stats *stats)
> +{
> +	struct task_struct *p;
> +	struct brute_stats **p_stats;
> +
> +	spin_lock(&stats->lock);
> +
> +	if (attack_type == BRUTE_ATTACK_TYPE_FORK &&
> +	    refcount_read(&stats->refc) == 1) {
> +		spin_unlock(&stats->lock);
> +		return;
> +	}

refcount_read() isn't a safe way to check that there is only 1
reference. What's this trying to do?

> +
> +	brute_disable(stats);
> +	spin_unlock(&stats->lock);
> +
> +	for_each_process(p) {
> +		if (attack_type == BRUTE_ATTACK_TYPE_FORK &&
> +		    p->group_leader == current->group_leader)
> +			continue;
> +
> +		p_stats = brute_stats_ptr(p);
> +		if (*p_stats != stats)
> +			continue;
> +
> +		do_send_sig_info(SIGKILL, SEND_SIG_PRIV, p, PIDTYPE_PID);
> +		pr_warn_ratelimited("Offending process %d [%s] killed\n",
> +				    p->pid, p->comm);
> +	}
> +}
> +
>  /**
>   * brute_manage_fork_attack() - Manage a fork brute force attack.
>   * @stats: Statistical data shared by all the fork hierarchy processes.
> @@ -586,8 +706,8 @@ static inline void print_fork_attack_running(void)
>   * since the task_free hook can be called from an IRQ context during the
>   * execution of the task_fatal_signal hook.
>   *
> - * Context: Must be called with interrupts disabled and brute_stats_ptr_lock
> - *          held.
> + * Context: Must be called with interrupts disabled and tasklist_lock and
> + *          brute_stats_ptr_lock held.
>   * Return: The last crash timestamp before updating it.
>   */
>  static u64 brute_manage_fork_attack(struct brute_stats *stats, u64 now)
> @@ -595,8 +715,10 @@ static u64 brute_manage_fork_attack(struct brute_stats *stats, u64 now)
>  	u64 last_fork_crash;
> 
>  	last_fork_crash = brute_update_crash_period(stats, now);
> -	if (brute_attack_running(stats))
> +	if (brute_attack_running(stats)) {
>  		print_fork_attack_running();
> +		brute_kill_offending_tasks(BRUTE_ATTACK_TYPE_FORK, stats);
> +	}
> 
>  	return last_fork_crash;
>  }
> @@ -783,8 +905,10 @@ static void brute_manage_exec_attack(struct brute_stats *stats, u64 now,
>  	if (fork_period == exec_period)
>  		return;
> 
> -	if (brute_attack_running(exec_stats))
> +	if (brute_attack_running(exec_stats)) {
>  		print_exec_attack_running(exec_stats);
> +		brute_kill_offending_tasks(BRUTE_ATTACK_TYPE_EXEC, exec_stats);
> +	}
>  }
> 
>  /**
> @@ -900,10 +1024,9 @@ static void brute_task_fatal_signal(const kernel_siginfo_t *siginfo)
>  	read_lock(&tasklist_lock);
>  	read_lock_irqsave(&brute_stats_ptr_lock, flags);
> 
> -	if (WARN(!*stats, "No statistical data\n"))
> -		goto unlock;
> -
> -	if (!brute_threat_model_supported(siginfo, *stats))
> +	if (WARN(!*stats, "No statistical data\n") ||
> +	    brute_disabled(*stats) ||
> +	    !brute_threat_model_supported(siginfo, *stats))
>  		goto unlock;
> 
>  	last_fork_crash = brute_manage_fork_attack(*stats, now);
> --
> 2.25.1
> 

-- 
Kees Cook
