Return-Path: <kernel-hardening-return-19869-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id AE0BA2652B1
	for <lists+kernel-hardening@lfdr.de>; Thu, 10 Sep 2020 23:22:42 +0200 (CEST)
Received: (qmail 13810 invoked by uid 550); 10 Sep 2020 21:22:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 13787 invoked from network); 10 Sep 2020 21:22:36 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N10c9+tEMvd+V1v5/kjFg7uIplbi+YryLR/t+QNnqsU=;
        b=Pmbtzx/w5PJRKpuyzWZgUthB5SqsFujhymQl5gJo8f6W3hvApNoms7SWH1Ie3t+Xhv
         G4BzucZpRgNaCDRkBPiUSWCjEuLpi8agAsdGI/QBUu92rYGZ8Pp3MkAt2a24+m/S5x3B
         6epqPgVItTvZ5dHCiaBsFReRRMDht3h8fKCaRGh1IkHnw2lateEx0y9mDjHKtpX8Y8Nz
         pj8E/O7vvbiRPAFHA3pzg1fCXA5Q5JExBVpXPTHZUF0gtsfus/hcwcxmf9RfgHDwtSxq
         1bx0ofN7Nm21fcXiPRlbKh/d5ruR2ePp3ji5Py5uWlztcfvuDu+7GtC29bjR7vEOzNWS
         NI6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N10c9+tEMvd+V1v5/kjFg7uIplbi+YryLR/t+QNnqsU=;
        b=opw4LpolRW07/w/joCnNmKkoawdYUOnRkBlTAb7i10dJ0uEiUkfq3bfWZCxB5BFmDG
         /vSRFXwY4UH6aVZATJN+ZN47CIG4CLSX2yrQF7gJoKm1FbElOVSlxC98rLLRSXfDeWu2
         AIKNjhhhZRvRParR6z/ZDgAsvY3wqQ+OZYH4jHvZpT5ncl28qmwp0mNptMyi87yUwcmP
         xSyKVcRPRu4AJfTJ6TfKHRL8CMDKrvnXKxHZz8eMhhldI0TS2xoo8a+ZES6zLtTL438F
         yIxFEzSfcctozRZS6Yg+G176I8dkEWi/vrQn6wG56zGkAUKkdOqnykwuX2aWaUG4/RKo
         NWig==
X-Gm-Message-State: AOAM530cVC6Ref4FHLOphUx0Tzay5UsJVzc+cynWe8G3NibvgfPVq7jL
	Mm9t78T66bNC6MUef/T8sdpceuEYOegOS7JGW9bE7w==
X-Google-Smtp-Source: ABdhPJz1ZXFqvRU0UEmWsJMjbaIMk2L+dkrdUn+tEviQSYc6CnuQg/EudEOu/jzT2CS0AbLrfEZiZReKFnSsXFJuWYE=
X-Received: by 2002:a17:906:4088:: with SMTP id u8mr11408126ejj.184.1599772945031;
 Thu, 10 Sep 2020 14:22:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200910202107.3799376-1-keescook@chromium.org> <20200910202107.3799376-2-keescook@chromium.org>
In-Reply-To: <20200910202107.3799376-2-keescook@chromium.org>
From: Jann Horn <jannh@google.com>
Date: Thu, 10 Sep 2020 23:21:58 +0200
Message-ID: <CAG48ez1V=oVczCCSuRaWX=bbN2cOi0Y9q48=e-Fuhg7mwMOi0A@mail.gmail.com>
Subject: Re: [RFC PATCH 1/6] security/fbfam: Add a Kconfig to enable the fbfam feature
To: Kees Cook <keescook@chromium.org>, John Wood <john.wood@gmx.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Matthew Wilcox <willy@infradead.org>, Jonathan Corbet <corbet@lwn.net>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Luis Chamberlain <mcgrof@kernel.org>, Iurii Zaikin <yzaikin@google.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, linux-doc@vger.kernel.org, 
	kernel list <linux-kernel@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	linux-security-module <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, Sep 10, 2020 at 10:21 PM Kees Cook <keescook@chromium.org> wrote:
> From: John Wood <john.wood@gmx.com>
>
> Add a menu entry under "Security options" to enable the "Fork brute
> force attack mitigation" feature.
[...]
> +config FBFAM

Please give this a more descriptive name than FBFAM. Some name where,
if a random kernel developer sees an "#ifdef" with that name in some
random piece of kernel code, they immediately have a rough idea for
what kind of feature this is.

Perhaps something like THROTTLE_FORK_CRASHES. Or something else that
is equally descriptive.

> +       bool "Fork brute force attack mitigation"
> +       default n

"default n" is superfluous and should AFAIK be omitted.

> +       help
> +         This is a user defense that detects any fork brute force attack
> +         based on the application's crashing rate. When this measure is
> +         triggered the fork system call is blocked.

This help text claims that the mitigation will block fork(), but patch
6/6 actually kills the process hierarchy.
