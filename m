Return-Path: <kernel-hardening-return-19509-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 62A25234B17
	for <lists+kernel-hardening@lfdr.de>; Fri, 31 Jul 2020 20:32:10 +0200 (CEST)
Received: (qmail 5933 invoked by uid 550); 31 Jul 2020 18:32:04 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 5913 invoked from network); 31 Jul 2020 18:32:03 -0000
Date: Fri, 31 Jul 2020 19:31:46 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc: Andy Lutomirski <luto@kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Linux API <linux-api@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	linux-integrity <linux-integrity@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	LSM List <linux-security-module@vger.kernel.org>,
	Oleg Nesterov <oleg@redhat.com>, X86 ML <x86@kernel.org>
Subject: Re: [PATCH v1 0/4] [RFC] Implement Trampoline File Descriptor
Message-ID: <20200731183146.GD67415@C02TD0UTHF1T.local>
References: <20200728131050.24443-1-madvenka@linux.microsoft.com>
 <CALCETrVy5OMuUx04-wWk9FJbSxkrT2vMfN_kANinudrDwC4Cig@mail.gmail.com>
 <6540b4b7-3f70-adbf-c922-43886599713a@linux.microsoft.com>
 <CALCETrWnNR5v3ZCLfBVQGYK8M0jAvQMaAc9uuO05kfZuh-4d6w@mail.gmail.com>
 <46a1adef-65f0-bd5e-0b17-54856fb7e7ee@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46a1adef-65f0-bd5e-0b17-54856fb7e7ee@linux.microsoft.com>

On Fri, Jul 31, 2020 at 12:13:49PM -0500, Madhavan T. Venkataraman wrote:
> On 7/30/20 3:54 PM, Andy Lutomirski wrote:
> > On Thu, Jul 30, 2020 at 7:24 AM Madhavan T. Venkataraman
> > <madvenka@linux.microsoft.com> wrote:
> Dealing with multiple architectures
> -----------------------------------------------
> 
> One good reason to use trampfd is multiple architecture support. The
> trampoline table in a code page approach is neat. I don't deny that at
> all. But my question is - can it be used in all cases?
> 
> It requires PC-relative data references. I have not worked on all architectures.
> So, I need to study this. But do all ISAs support PC-relative data references?

Not all do, but pretty much any recent ISA will as it's a practical
necessity for fast position-independent code.

> Even in an ISA that supports it, there would be a maximum supported offset
> from the current PC that can be reached for a data reference. That maximum
> needs to be at least the size of a base page in the architecture. This is because
> the code page and the data page need to be separate for security reasons.
> Do all ISAs support a sufficiently large offset?

ISAs with pc-relative addessing can usually generate PC-relative
addresses into a GPR, from which they can apply an arbitrarily large
offset.

> When the kernel generates the code for a trampoline, it can hard code data values
> in the generated code itself so it does not need PC-relative data referencing.
> 
> And, for ISAs that do support the large offset, we do have to implement and
> maintain the code page stuff for different ISAs for each application and library
> if we did not use trampfd.

Trampoline code is architecture specific today, so I don't see that as a
major issue. Common structural bits can probably be shared even if the
specifid machine code cannot.

[...]

> Security
> -----------
> 
> With the user level trampoline table approach, the data part of the trampoline table
> can be hacked by an attacker if an application has a vulnerability. Specifically, the
> target PC can be altered to some arbitrary location. Trampfd implements an
> "Allowed PCS" context. In the libffi changes, I have created a read-only array of
> all ABI handlers used in closures for each architecture. This read-only array
> can be used to restrict the PC values for libffi trampolines to prevent hacking.
> 
> To generalize, we can implement security rules/features if the trampoline
> object is in the kernel.

I don't follow this argument. If it's possible to statically define that
in the kernel, it's also possible to do that in userspace without any
new kernel support.

[...]

> Trampfd is a framework that can be used to implement multiple things. May be,
> a few of those things can also be implemented in user land itself. But I think having
> just one mechanism to execute dynamic code objects is preferable to having
> multiple mechanisms not standardized across all applications.

In abstract, having a common interface sounds nice, but in practice
elements of this are always architecture-specific (e.g. interactiosn
with HW CFI), and that common interface can result in more pain as it
doesn't fit naturally into the context that ISAs were designed for (e.g. 
where control-flow instructions are extended with new semantics).

It also meass that you can't share the rough approach across OSs which
do not implement an identical mechanism, so for code abstracting by ISA
first, then by platform/ABI, there isn't much saving.

Thanks,
Mark.
