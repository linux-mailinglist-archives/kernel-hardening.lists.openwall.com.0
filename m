Return-Path: <kernel-hardening-return-15977-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 65D5725813
	for <lists+kernel-hardening@lfdr.de>; Tue, 21 May 2019 21:15:12 +0200 (CEST)
Received: (qmail 28159 invoked by uid 550); 21 May 2019 19:15:04 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 32329 invoked from network); 21 May 2019 18:23:42 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=KfCh0884v4bVSRmnlQWvFHPVad54nh6+zV1JwGfTT18=;
        b=ezXHTWxKgXYe5C2JJlTooG4x8QRdPU2kupBFx4GtzVhA5nQtBUyh6BM/1RueM8AS/k
         6OoXYA8UWfHmaGLGH63oTnKdc/hgM6U5snfh4/NUrIh9cszPD9ffCGNUGuUXxQ0WlN98
         XBJPW//CBwzRf/CO/KH0yQHIdUJzhxo2o7n7EanN968FiuK+2qsiqac6xaFLorWkp8gN
         eumRz+urIYZw2exl7SoT9zAYVJm2Hues/i2cizOyMC5A7Lg9UdEnQ7KrO4DuKSl8DOPj
         eh5RwrIamiSfiUGiZRsO/VYfyYSCHZx2H0qsR8ju8pCa31p/pmW6eGqknMWvRQiTB8Zs
         Qe7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=KfCh0884v4bVSRmnlQWvFHPVad54nh6+zV1JwGfTT18=;
        b=C88+5+JMXhK4NPtZwsCOJDRreauqjH9CcjW2u8z7Vxv79cCUiV1UDXKRttDQNUfJZ4
         /j72cuU3cXG/RXQU5TBUpp2/LUO/DKgmdiIlKteRRtERAEPtI/XMLBY+VFEiwmBlhEdM
         n4A0c5orsX68LA2g+caGKbkNyFCbiXKMxcXdVXLd7Dwy/Uxd69xxilEUASH+uPeV2I/q
         FgSHyKm/Q+Gg3MG0fPpFvXVF6vnHm2wu7LD/e1CziuEJh/x4EE6/4EjZzoEWhvIxArNk
         nA5JlKzgCVJtXPlO1n5glU+wCtBH5qfcauaIAS77NFNPmQwUVfNzfhyXiHTNtNkYfClw
         wk1w==
X-Gm-Message-State: APjAAAXkBraykgo4OeHim3sAwBWZQBsJ4j+9d+IsBfOQNd7AC0mPPW1t
	btQQB3t7J5p07H6Ej4rKrF0=
X-Google-Smtp-Source: APXvYqyq9fkKQCI2jYxjXU5Wezw/aNAfjUEpEGcLTTLQsDr4RHgDTz3kOJ/NQ/QW6Fic3FdQjJ3mwA==
X-Received: by 2002:a17:902:1029:: with SMTP id b38mr44439686pla.72.1558463010726;
        Tue, 21 May 2019 11:23:30 -0700 (PDT)
Date: Tue, 21 May 2019 23:53:23 +0530
From: Himanshu Jha <himanshujha199640@gmail.com>
To: Jann Horn <jannh@google.com>
Cc: linux-sparse@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>,
	clang-built-linux <clang-built-linux@googlegroups.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: Sparse context checking Vs Clang Thread Safety analysis
Message-ID: <20190521182322.GB15859@himanshu-Vostro-3559>
References: <20190520164214.GA14656@himanshu-Vostro-3559>
 <CAG48ez2+NoQ4mtm=PCyz005O4Efmszxo3Z7wgaF_5xx1nYO8dQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez2+NoQ4mtm=PCyz005O4Efmszxo3Z7wgaF_5xx1nYO8dQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)

Hi Jann,

On Mon, May 20, 2019 at 09:01:26PM +0200, 'Jann Horn' via Clang Built Linux wrote:
> +kernel-hardening
> 
> On Mon, May 20, 2019 at 6:42 PM Himanshu Jha
> <himanshujha199640@gmail.com> wrote:
> > I'm an undergrad student working on Google Summer of Code'19 Project[1]
> > to apply clang thread safety analysis feature on linux kernel to find bugs
> > related to concurrency/race condtions with Lukas & clangbuiltlinux
> > community.
> >
> > Since sparse has similar context checking feature, I started
> > investigating by looking the source and some other resources such as
> > LWN[2] about the internals.
> >
> > `-Wcontext` is my prime focus for now and currently we have:
> >
> > himanshu@himanshu-Vostro-3559:~/linux-next$ make C=2 CF="-Wcontext" 2>&1 >/dev/null | grep -w 'context' | wc -l
> > 772
> >
> > o Why do we have so many open warnings for context imbalance ? Or
> >   Why did we stop at some point annotating the codebase ?
> 
> Many developers don't use sparse, and sparse doesn't support some
> locking patterns that the kernel uses.

I understand little interest in sparse warnings among developers.

I see frequently patches related to fixing codebase such as:
https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/commit/?h=char-misc-testing&id=324fa64cf4189094bc4df744a9e7214a1b81d845

and by 0-day bot:
https://lore.kernel.org/lkml/201905210520.GS4ztecg%25lkp@intel.com/

> > o Does sparse stores some sort of context counter since we didn't get
> > any warnings for `bad_difflocks` which locks 'lock1' and unlocks 'lock2'
> > ?
> 
> Yes. Sparse currently ignores the context and only has a simple
> counter shared by all locks.
> 
> > o What exactly the usage of `__acquire/__release` ?
> > I have used it to shut up the warning for lockfn & unlockfn above.
> 
> You use those to inform sparse where you're taking a lock or releasing
> a lock; and some parts of the kernel also use it to inform sparse of
> places where a lock is effectively taken, even though there is no
> actual locking call (e.g. when two pointers point to the same object,
> and therefore you only need to actually call the locking function once
> instead of twice).
> 
> [...]
> > So, clang thread safety analysis[3] follows a different mechanism
> > to overcome what we have observed above.
> >
> > I did small analysis on a C program[4] and a device driver[5].
> >
> > Clang analysis has many annotations available to suitable annotate the
> > codebase which can be found in the documentation[3].
> >
> > Quite surprisingly, Philipp proposed[6] `__protected_by` feature which is
> > very similar to `guarded_by`[7] feature implemented in Clang.
> >
> > Similarly, Johannes proposed[8] the same with a different implementation.
> >
> > Questions from both you:
> >
> > o Why was it not deployed in sparse ?
> >
> > o Does the lock protecting the data should be a global variable ?
> >
> > ie.,
> >
> > struct foo {
> >         struct mutex lock;
> >         int balance __protected_by(lock);
> > }
> >
> > Can this be done ? Or lock should be global ?
> >
> > Because clang analysis wants it to be global!
> >
> > There are other attribute restrictions as well for clang analysis:
> > https://github.com/llvm-mirror/clang/blob/master/test/Sema/attr-capabilities.c
> >
> >
> > *Most Important*
> > Could you please point me some critical data examples that you know in
> > the kernel source which should be protected. This would help us a lot!
> 
> The complicated thing in the kernel is that almost any structure
> member can be accessed without locking under some circumstances - for
> example, when a structure is initialized, or when the structure is
> being freed and all other references to the object have gone away. On
> top of that, many fields can be accessed under multiple locking
> mechanisms - e.g. many fields can be read under either a
> spinlock/mutex or in an RCU read-critical section. And there are
> functions that conditionally acquire a lock and signal the state of
> the lock through their return value - for example,
> mutex_lock_killable() and mutex_lock_interruptible().

Yes, I understand.

Maybe TRY_ACQUIRE() would fit such a situation:
https://clang.llvm.org/docs/ThreadSafetyAnalysis.html#try-acquire-bool-try-acquire-shared-bool


> I think that static analysis of locking is a great thing, but the
> kernel doesn't exactly make it easy. In particular, I think it is
> going to require annotations that you can use to tell the compiler
> which state of its lifecycle an object is in (since that can influence
> locking rules), and annotations that tell the compiler what the
> semantics of functions like mutex_lock_killable() are.

I will try with the easy ones in the beginning and share the analysis.


Thanks for your time!
-- 
Himanshu Jha
Undergraduate Student
Department of Electronics & Communication
Guru Tegh Bahadur Institute of Technology
