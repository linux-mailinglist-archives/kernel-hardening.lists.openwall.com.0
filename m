Return-Path: <kernel-hardening-return-19080-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 1D217205CF8
	for <lists+kernel-hardening@lfdr.de>; Tue, 23 Jun 2020 22:07:53 +0200 (CEST)
Received: (qmail 11665 invoked by uid 550); 23 Jun 2020 20:07:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 11642 invoked from network); 23 Jun 2020 20:07:45 -0000
IronPort-SDR: Xz/CUfjnEf8yHiL/MpVWKEQzH5VlS9Zyf1GAYu/7dBXzfdiIwcYy/aT6o/DNbAwyyZVYb3B3RC
 35R3BIBuq8Tg==
X-IronPort-AV: E=McAfee;i="6000,8403,9661"; a="143312457"
X-IronPort-AV: E=Sophos;i="5.75,272,1589266800"; 
   d="scan'208";a="143312457"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
IronPort-SDR: BUquHP6/egIubskUC+wd1qMKZIo8Ikj9vc9R1L2KgEVN7Re1Fh7E6yhj8tO0FBTJxozd8Oe4ES
 HDhJEnS/VEsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,272,1589266800"; 
   d="scan'208";a="301379329"
Date: Tue, 23 Jun 2020 20:03:35 +0000
From: "Andersen, John" <john.s.andersen@intel.com>
To: Andy Lutomirski <luto@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
	Shuah Khan <shuah@kernel.org>,
	"Christopherson, Sean J" <sean.j.christopherson@intel.com>,
	Liran Alon <liran.alon@oracle.com>,
	Andrew Jones <drjones@redhat.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Kristen Carlson Accardi <kristen@linux.intel.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Wanpeng Li <wanpengli@tencent.com>,
	Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>,
	mchehab+huawei@kernel.org, Greg KH <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	pawan.kumar.gupta@linux.intel.com, Juergen Gross <jgross@suse.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Oliver Neukum <oneukum@suse.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Fenghua Yu <fenghua.yu@intel.com>, reinette.chatre@intel.com,
	vineela.tummalapalli@intel.com,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Arjan van de Ven <arjan@linux.intel.com>, caoj.fnst@cn.fujitsu.com,
	Baoquan He <bhe@redhat.com>, Arvind Sankar <nivedita@alum.mit.edu>,
	Kees Cook <keescook@chromium.org>,
	Dan Williams <dan.j.williams@intel.com>, eric.auger@redhat.com,
	aaronlewis@google.com, Peter Xu <peterx@redhat.com>,
	makarandsonare@google.com,
	"open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, kvm list <kvm@vger.kernel.org>,
	"open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: [PATCH 4/4] X86: Use KVM CR pin MSRs
Message-ID: <20200623200334.GA23@6540770db1d7>
References: <20200617190757.27081-1-john.s.andersen@intel.com>
 <20200617190757.27081-5-john.s.andersen@intel.com>
 <CALCETrXwzQDDd1rfBW+ptmijEjc2cMqfWGvJu-qqrqia5Ls=Uw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXwzQDDd1rfBW+ptmijEjc2cMqfWGvJu-qqrqia5Ls=Uw@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)

On Fri, Jun 19, 2020 at 10:13:25PM -0700, Andy Lutomirski wrote:
> On Wed, Jun 17, 2020 at 12:05 PM John Andersen
> <john.s.andersen@intel.com> wrote:
> > Guests using the kexec system call currently do not support
> > paravirtualized control register pinning. This is due to early boot
> > code writing known good values to control registers, these values do
> > not contain the protected bits. This is due to CPU feature
> > identification being done at a later time, when the kernel properly
> > checks if it can enable protections. As such, the pv_cr_pin command line
> > option has been added which instructs the kernel to disable kexec in
> > favor of enabling paravirtualized control register pinning. crashkernel
> > is also disabled when the pv_cr_pin parameter is specified due to its
> > reliance on kexec.
> 
> Is there a plan for fixing this for real?  I'm wondering if there is a
> sane weakening of this feature that still allows things like kexec.
> 

I'm pretty sure kexec can be fixed. I had it working at one point, I'm
currently in the process of revalidating this. The issue was though that
kexec only worked within the guest, not on the physical host, which I suspect
is related to the need for supervisor pages to be mapped, which seems to be
required before enabling SMAP (based on what I'd seen with the selftests and
unittests). I was also just blindly turning on the bits without checking for
support when I'd tried this, so that could have been the issue too.

I think most of the changes for just blindly enabling the bits were in
relocate_kernel, secondary_startup_64, and startup_32.

> What happens if a guest tries to reset?  For that matter, what happens
> when a guest vCPU sends SIPI to another guest vCPU?  The target CPU
> starts up in real mode, right?
>

In this case we hit kvm_vcpu_reset, where we clear pinning. Yes I believe it
starts up in real mode.

> There's no SMEP or SMAP in real mode, and real mode has basically no security
> mitigations at all.
> 

We'd thought about the switch to real mode being a case where we'd want to drop
pinning. However, we weren't sure how much weaker, if at all, it makes this
protection.

Unless someone knows, I'll probably need to do some digging into what an
exploit might look like that tries switching to real mode and switching back as
a way around this protection.

If we can use the switch to real mode as a drop pinning trigger then I think
that might just solve the kexec problem.

> PCID is an odd case.  I see no good reason to pin it, and pinning PCID
> on prevents use of 32-bit mode.

Maybe it makes sense to default to the values we have, but allow host userspace
to overwrite the allowed values, in case some other guest OS wants to do
something that Linux doesn't with PCID or other bits.
