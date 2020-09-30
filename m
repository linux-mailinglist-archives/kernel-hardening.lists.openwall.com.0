Return-Path: <kernel-hardening-return-20062-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 25ED027DCF4
	for <lists+kernel-hardening@lfdr.de>; Wed, 30 Sep 2020 01:49:46 +0200 (CEST)
Received: (qmail 23909 invoked by uid 550); 29 Sep 2020 23:49:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 23889 invoked from network); 29 Sep 2020 23:49:40 -0000
Date: Tue, 29 Sep 2020 19:49:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com, John Wood <john.wood@gmx.com>,
 Matthew Wilcox <willy@infradead.org>, Jonathan Corbet <corbet@lwn.net>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann
 <dietmar.eggemann@arm.com>, Ben Segall <bsegall@google.com>, Mel Gorman
 <mgorman@suse.de>, Luis Chamberlain <mcgrof@kernel.org>, Iurii Zaikin
 <yzaikin@google.com>, James Morris <jmorris@namei.org>, "Serge E. Hallyn"
 <serge@hallyn.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-security-module@vger.kernel.org
Subject: Re: [RFC PATCH 3/6] security/fbfam: Use the api to manage
 statistics
Message-ID: <20200929194924.31640617@oasis.local.home>
In-Reply-To: <20200929194712.541c860c@oasis.local.home>
References: <20200910202107.3799376-1-keescook@chromium.org>
	<20200910202107.3799376-4-keescook@chromium.org>
	<202009101625.0E3B6242@keescook>
	<20200929194712.541c860c@oasis.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 29 Sep 2020 19:47:12 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Thu, 10 Sep 2020 16:33:38 -0700
> Kees Cook <keescook@chromium.org> wrote:
> 
> > > @@ -1940,6 +1941,7 @@ static int bprm_execve(struct linux_binprm *bprm,
> > >  	task_numa_free(current, false);
> > >  	if (displaced)
> > >  		put_files_struct(displaced);
> > > +	fbfam_execve();    
> > 
> > As mentioned in the other emails, I think this could trivially be
> > converted into an LSM: all the hooks are available AFAICT. If you only
> > want to introspect execve _happening_, you can use bprm_creds_for_exec
> > which is called a few lines above. Otherwise, my prior suggestion ("the
> > exec has happened" hook via brpm_cred_committing, etc).  
> 
> And if its information only, you could just register a callback to the
> trace_sched_process_exec() tracepoint and do whatever you want then.
> 
> The tracepoints are available for anyone to attach to. Not just tracing.
> 

And there's also trace_sched_process_fork() and
trace_sched_process_exit().

-- Steve
