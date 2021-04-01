Return-Path: <kernel-hardening-return-21132-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 4BC23352139
	for <lists+kernel-hardening@lfdr.de>; Thu,  1 Apr 2021 23:00:30 +0200 (CEST)
Received: (qmail 3492 invoked by uid 550); 1 Apr 2021 21:00:23 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3466 invoked from network); 1 Apr 2021 21:00:22 -0000
Date: Thu, 1 Apr 2021 16:59:20 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Roy Yang <royyang@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, keescook@chromium.org,
        akpm@linux-foundation.org, alex.popov@linux.com,
        ard.biesheuvel@linaro.org, catalin.marinas@arm.com, corbet@lwn.net,
        david@redhat.com, elena.reshetova@intel.com,
        Alexander Potapenko <glider@google.com>, Jann Horn <jannh@google.com>,
        kernel-hardening@lists.openwall.com,
        linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, luto@kernel.org,
        mark.rutland@arm.com, peterz@infradead.org, rdunlap@infradead.org,
        rppt@linux.ibm.com, tglx@linutronix.de, vbabka@suse.cz,
        will@kernel.org, x86@kernel.org
Subject: Re: [PATCH v8 0/6] Optionally randomize kernel stack offset each
 syscall
Message-ID: <YGY0KAgMmm4XlaS8@mit.edu>
References: <CANemeMjOw4sOzMxjdjJcWKD315u+KRn19h687GMbkQdP5Jc_kQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANemeMjOw4sOzMxjdjJcWKD315u+KRn19h687GMbkQdP5Jc_kQ@mail.gmail.com>

On Thu, Apr 01, 2021 at 01:49:17PM -0700, Roy Yang wrote:
> Thanks Ted, Casey and Al Viro. I am sorry for the inconvenience.
> 
> I tried to follow the instructions listed under
> https://lore.kernel.org/lkml/20210330205750.428816-1-keescook@chromium.org/
> using git-send-email
> 
> Thought that will reply to the original thread with the original
> subject . Let me know what I can do to correct this to avoid
> confusion.

It did chain to the original thread; that's how I was able to figure
out the context.  However, it looks like in your reply, you set the
subject to be:

[PATCH] Where we are for this patch?

And the problem is if someone had deleted the original e-mail chain
--- for example, optimizing the kernel stack is not one of the
subjects that I normally closely track, I had already deleted those
e-mail chains.  So all I saw (and I suspect all Al saw) was a message
with the above subject line, and no context.

If you had kept the original subject line, then those of us who mostly
focus on file system stuff would have known that it's an area which is
covered by other maintainers, and we wouldn't have deleted your query
and let someone else respond.

Cheers,

					- Ted

P.S.  I personally find the use "git-send-email" to reply to be so
much of a pain that I just use a non-google.com address to which I can
use a traditional threaded mail-reader (such as mutt) and I can send
e-mail without having to worry about the DMARC nonsense.  :-)

