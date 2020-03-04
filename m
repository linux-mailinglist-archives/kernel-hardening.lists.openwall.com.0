Return-Path: <kernel-hardening-return-18058-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 91637178DA3
	for <lists+kernel-hardening@lfdr.de>; Wed,  4 Mar 2020 10:41:38 +0100 (CET)
Received: (qmail 8145 invoked by uid 550); 4 Mar 2020 09:41:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 8120 invoked from network); 4 Mar 2020 09:41:32 -0000
Authentication-Results:mail.zytor.com; dkim=permerror (bad message/signature format)
From: "H. Peter Anvin" <hpa@zytor.com>
Message-Id: <202003040940.0249eM5n306088@mail.zytor.com>
Date: Wed, 04 Mar 2020 01:40:15 -0800
User-Agent: K-9 Mail for Android
In-Reply-To: <202003031314.1AFFC0E@keescook>
References: <20200228000105.165012-1-thgarnie@chromium.org> <202003022100.54CEEE60F@keescook> <20200303095514.GA2596@hirez.programming.kicks-ass.net> <CAJcbSZH1oON2VC2U8HjfC-6=M-xn5eU+JxHG2575iMpVoheKdA@mail.gmail.com> <6e7e4191612460ba96567c16b4171f2d2f91b296.camel@linux.intel.com> <202003031314.1AFFC0E@keescook>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v11 00/11] x86: PIE support to extend KASLR randomization
To: Kees Cook <keescook@chromium.org>,
        Kristen Carlson Accardi <kristen@linux.intel.com>
CC: Thomas Garnier <thgarnie@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        the arch/x86 maintainers <x86@kernel.org>,
        Andy Lutomirski <luto@kernel.org>, Juergen Gross <jgross@suse.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        "VMware, Inc." <pv-drivers@vmware.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>, Jiri Slaby <jslaby@suse.cz>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Cao jin <caoj.fnst@cn.fujitsu.com>,
        Allison Randal <allison@lohutok.net>, Linux.Crypto@zytor.com

Mailing List <linux-crypto@vger.kernel.org>,LKML <linux-kernel@vger.kernel.org>,virtualization@lists.linux-foundation.org,Linux PM list <linux-pm@vger.kernel.org>
From: hpa@zytor.com
Message-ID: <F35C8DBD-9AC3-46F2-9043-6CB9A4FDDDC9@zytor.com>

On March 3, 2020 1:19:22 PM PST, Kees Cook <keescook@chromium=2Eorg> wrote:
>On Tue, Mar 03, 2020 at 01:01:26PM -0800, Kristen Carlson Accardi
>wrote:
>> On Tue, 2020-03-03 at 07:43 -0800, Thomas Garnier wrote:
>> > On Tue, Mar 3, 2020 at 1:55 AM Peter Zijlstra
><peterz@infradead=2Eorg>
>> > wrote:
>> > > On Mon, Mar 02, 2020 at 09:02:15PM -0800, Kees Cook wrote:
>> > > > On Thu, Feb 27, 2020 at 04:00:45PM -0800, Thomas Garnier wrote:
>> > > > > Minor changes based on feedback and rebase from v10=2E
>> > > > >=20
>> > > > > Splitting the previous serie in two=2E This part contains
>> > > > > assembly code
>> > > > > changes required for PIE but without any direct dependencies
>> > > > > with the
>> > > > > rest of the patchset=2E
>> > > > >=20
>> > > > > Note: Using objtool to detect non-compliant PIE relocations
>is
>> > > > > not yet
>> > > > > possible as this patchset only includes the simplest PIE
>> > > > > changes=2E
>> > > > > Additional changes are needed in kvm, xen and percpu code=2E
>> > > > >=20
>> > > > > Changes:
>> > > > >  - patch v11 (assembly);
>> > > > >    - Fix comments on x86/entry/64=2E
>> > > > >    - Remove KASLR PIE explanation on all commits=2E
>> > > > >    - Add note on objtool not being possible at this stage of
>> > > > > the patchset=2E
>> > > >=20
>> > > > This moves us closer to PIE in a clean first step=2E I think
>these
>> > > > patches
>> > > > look good to go, and unblock the work in kvm, xen, and percpu
>> > > > code=2E Can
>> > > > one of the x86 maintainers pick this series up?
>> > >=20
>> > > But,=2E=2E=2E do we still need this in the light of that fine-grain=
ed
>> > > kaslr
>> > > stuff?
>> > >=20
>> > > What is the actual value of this PIE crud in the face of that?
>> >=20
>> > If I remember well, it makes it easier/better but I haven't seen a
>> > recent update on that=2E Is that accurate Kees?
>>=20
>> I believe this patchset is valuable if people are trying to brute
>force
>> guess the kernel location, but not so awesome in the event of
>> infoleaks=2E In the case of the current fgkaslr implementation, we only
>> randomize within the existing text segment memory area - so with PIE
>> the text segment base can move around more, but within that it
>wouldn't
>> strengthen anything=2E So, if you have an infoleak, you learn the base
>> instantly, and are just left with the same extra protection you get
>> without PIE=2E
>
>Right -- PIE improves both non- and fg- KASLR similarly, in the sense
>that the possible entropy for base offset is expanded=2E It also opens
>the
>door to doing even more crazy things=2E (e=2Eg=2E why keep the kernel tex=
t
>all
>in one contiguous chunk?)
>
>And generally speaking, it seems a nice improvement to me, as it gives
>the kernel greater addressing flexibility=2E

The difference in entropy between fgkaslr and extending the kernel to the =
PIC memory model (which is the real thing this is doing) is immense:

The current kASLR has maybe 9 bits of entropy=2E PIC-model could extend th=
at by at most 16 bits at considerable cost in performance and complexity=2E=
 Fgkaslr would provide many kilobits worth of entropy; the limiting factor =
would be the random number source used! With a valid RNG, no two boots acro=
ss all the computers in the world across all time would have an infinitesim=
al probability of ever being the same; never mind the infoleak issue=2E

In addition to the combinatorics, fgkaslr pushes randomization right as we=
ll as left, so even for the address of any one individual function you get =
a gain of 15-17 bits=2E

"More is better" is a truism, but so is Amdahl's Law=2E


--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
