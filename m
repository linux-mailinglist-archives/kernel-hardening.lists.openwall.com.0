Return-Path: <kernel-hardening-return-17282-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 29AEAF005F
	for <lists+kernel-hardening@lfdr.de>; Tue,  5 Nov 2019 15:56:09 +0100 (CET)
Received: (qmail 30464 invoked by uid 550); 5 Nov 2019 14:56:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 30444 invoked from network); 5 Nov 2019 14:55:59 -0000
To: Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH v4 13/17] arm64: preserve x18 when CPU is suspended
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 05 Nov 2019 16:04:47 +0109
From: Marc Zyngier <maz@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>, Will Deacon
 <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Steven Rostedt
 <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, Ard
 Biesheuvel <ard.biesheuvel@linaro.org>, Dave Martin <dave.martin@arm.com>,
 Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, Mark
 Rutland <mark.rutland@arm.com>, Jann Horn <jannh@google.com>, Miguel Ojeda
 <miguel.ojeda.sandonis@gmail.com>, Masahiro Yamada
 <yamada.masahiro@socionext.com>, clang-built-linux
 <clang-built-linux@googlegroups.com>, Kernel Hardening
 <kernel-hardening@lists.openwall.com>, linux-arm-kernel
 <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <CABCJKueN+Op8xm+L3aSFgCL9BLC8b-WHj3oBYhf1W=OcX2aqCg@mail.gmail.com>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191101221150.116536-1-samitolvanen@google.com>
 <20191101221150.116536-14-samitolvanen@google.com>
 <02c56a5273f94e9d832182f1b3cb5097@www.loen.fr>
 <CABCJKucVON6uUMH6hVP7RODqH8u63AP3SgTCBWirrS30yDOmdA@mail.gmail.com>
 <CAKwvOdkDbX4zLChH_DKrnOah1sJjTA-e3uZOXUP6nUs-EaJreg@mail.gmail.com>
 <CABCJKueN+Op8xm+L3aSFgCL9BLC8b-WHj3oBYhf1W=OcX2aqCg@mail.gmail.com>
Message-ID: <5486328a221c9eaef8956983f70380f1@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: samitolvanen@google.com, ndesaulniers@google.com, will@kernel.org, catalin.marinas@arm.com, rostedt@goodmis.org, mhiramat@kernel.org, ard.biesheuvel@linaro.org, dave.martin@arm.com, keescook@chromium.org, labbott@redhat.com, mark.rutland@arm.com, jannh@google.com, miguel.ojeda.sandonis@gmail.com, yamada.masahiro@socionext.com, clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false

On 2019-11-05 01:11, Sami Tolvanen wrote:
> On Mon, Nov 4, 2019 at 1:59 PM Nick Desaulniers
> <ndesaulniers@google.com> wrote:
>>
>> On Mon, Nov 4, 2019 at 1:38 PM Sami Tolvanen 
>> <samitolvanen@google.com> wrote:
>> >
>> > On Mon, Nov 4, 2019 at 5:20 AM Marc Zyngier <maz@kernel.org> 
>> wrote:
>> > > >  ENTRY(cpu_do_suspend)
>> > > >       mrs     x2, tpidr_el0
>> > > > @@ -73,6 +75,9 @@ alternative_endif
>> > > >       stp     x8, x9, [x0, #48]
>> > > >       stp     x10, x11, [x0, #64]
>> > > >       stp     x12, x13, [x0, #80]
>> > > > +#ifdef CONFIG_SHADOW_CALL_STACK
>> > > > +     str     x18, [x0, #96]
>> > > > +#endif
>> > >
>> > > Do we need the #ifdefery here? We didn't add that to the KVM 
>> path,
>> > > and I'd feel better having a single behaviour, specially when
>> > > NR_CTX_REGS is unconditionally sized to hold 13 regs.
>> >
>> > I'm fine with dropping the ifdefs here in v5 unless someone 
>> objects to this.
>>
>> Oh, yeah I guess it would be good to be consistent.  Rather than 
>> drop
>> the ifdefs, would you (Marc) be ok with conditionally setting
>> NR_CTX_REGS based on CONFIG_SHADOW_CALL_STACK, and doing so in KVM?
>> (So 3 ifdefs, rather than 0)?
>>
>> Without any conditionals or comments, it's not clear why x18 is 
>> being
>> saved and restored (unless git blame survives, or a comment is added
>> in place of the ifdefs in v6).
>
> True. Clearing the sleep state buffer in cpu_do_resume is also
> pointless without CONFIG_SHADOW_CALL_STACK, so if the ifdefs are
> removed, some kind of an explanation is needed there.

I can't imagine the overhead being noticeable, and I certainly value
minimizing the testing space. Sticking a comment there should be
enough for people hacking on this to understand that this isn't
entirely dead code.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
