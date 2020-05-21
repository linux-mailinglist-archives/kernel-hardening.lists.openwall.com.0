Return-Path: <kernel-hardening-return-18855-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 26CE11DDB40
	for <lists+kernel-hardening@lfdr.de>; Fri, 22 May 2020 01:43:43 +0200 (CEST)
Received: (qmail 12235 invoked by uid 550); 21 May 2020 23:43:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 12215 invoked from network); 21 May 2020 23:43:37 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Kees Cook <keescook@chromium.org>
Cc: Kristen Carlson Accardi <kristen@linux.intel.com>, mingo@redhat.com, bp@alien8.de, arjan@linux.intel.com, x86@kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, rick.p.edgecombe@intel.com
Subject: Re: [PATCH v2 0/9] Function Granular KASLR
In-Reply-To: <202005211604.86AE1C2@keescook>
Date: Fri, 22 May 2020 01:43:15 +0200
Message-ID: <87tv08svl8.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001

Kees,

Kees Cook <keescook@chromium.org> writes:
> On Fri, May 22, 2020 at 12:26:30AM +0200, Thomas Gleixner wrote:
>> I understand how this is supposed to work, but I fail to find an
>> explanation how all of this is preserving the text subsections we have,
>> i.e. .kprobes.text, .entry.text ...?
>
> I had the same question when I first started looking at earlier versions
> of this series! :)
>
>> I assume that the functions in these subsections are reshuffled within
>> their own randomized address space so that __xxx_text_start and
>> __xxx_text_end markers still make sense, right?
>
> No, but perhaps in the future. Right now, they are entirely ignored and
> left untouched.

I'm fine with that restriction, but for a moment I got worried that this
might screw up explicit subsections.

This really want's to be clearly expressed in the cover letter and the
changelogs so that such questions don't arise again.

<SNIP>

> So, before any of that, just .text.* is a good first step, and after
> that I think next would be getting .text randomized relative to the other
> .text.* sections (IIUC, it is entirely untouched currently, so only the
> standard KASLR base offset moves it around). Only after that do we start
> poking around trying to munge the special section contents (which
> requires use solving a few problems simultaneously). :)

Thanks for the detailed explanation!

       tglx
