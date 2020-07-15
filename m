Return-Path: <kernel-hardening-return-19330-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 4E9F92215AC
	for <lists+kernel-hardening@lfdr.de>; Wed, 15 Jul 2020 22:02:48 +0200 (CEST)
Received: (qmail 15578 invoked by uid 550); 15 Jul 2020 20:02:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 15558 invoked from network); 15 Jul 2020 20:02:41 -0000
IronPort-SDR: tUgjGVWGFiPDxjyp0szRX/p23euK4qq+d3iia+dulHQr4ywAd19MACytcSGalqDLBELjVJH23f
 3FYqFj8zpzRQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9683"; a="136708777"
X-IronPort-AV: E=Sophos;i="5.75,356,1589266800"; 
   d="scan'208";a="136708777"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
IronPort-SDR: MkLInbnvcc7MzlFRLFR80N9TF9i4byCNeQBBRI8k0z1B4lJxv76xTM1XavfvVhqrC+mI3YeVsJ
 gxdjPuQGecwA==
X-IronPort-AV: E=Sophos;i="5.75,356,1589266800"; 
   d="scan'208";a="324931027"
Date: Wed, 15 Jul 2020 19:58:48 +0000
From: "Andersen, John" <john.s.andersen@intel.com>
To: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Andy Lutomirski <luto@kernel.org>,
	Arvind Sankar <nivedita@alum.mit.edu>,
	Dave Hansen <dave.hansen@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
	Shuah Khan <shuah@kernel.org>, Liran Alon <liran.alon@oracle.com>,
	Andrew Jones <drjones@redhat.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Kristen Carlson Accardi <kristen@linux.intel.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Wanpeng Li <wanpengli@tencent.com>,
	Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Greg KH <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Juergen Gross <jgross@suse.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Oliver Neukum <oneukum@suse.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Fenghua Yu <fenghua.yu@intel.com>, reinette.chatre@intel.com,
	vineela.tummalapalli@intel.com,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Arjan van de Ven <arjan@linux.intel.com>, caoj.fnst@cn.fujitsu.com,
	Baoquan He <bhe@redhat.com>, Kees Cook <keescook@chromium.org>,
	Dan Williams <dan.j.williams@intel.com>, eric.auger@redhat.com,
	aaronlewis@google.com, Peter Xu <peterx@redhat.com>,
	makarandsonare@google.com,
	"open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, kvm list <kvm@vger.kernel.org>,
	"open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: [PATCH 2/4] KVM: x86: Introduce paravirt feature CR0/CR4 pinning
Message-ID: <20200715195848.GE25@760745902f30>
References: <20200707211244.GN20096@linux.intel.com>
 <19b97891-bbb0-1061-5971-549a386f7cfb@intel.com>
 <31eb5b00-9e2a-aa10-0f20-4abc3cd35112@redhat.com>
 <20200709154412.GA25@64c96d3be97b>
 <af6ac772-318d-aab0-ce5f-55cf92f6e96d@intel.com>
 <CALCETrWxt0CHUoonWX1fgbM46ydJPQZhj8Q=G+45EG4wW3wZqQ@mail.gmail.com>
 <6040c3b3-cac9-cc0e-f0de-baaa274920a2@intel.com>
 <CALCETrUHcpqjDfAM9SbrZUM7xcS2wkVm=r1Nb1JmxV7A-KAeUQ@mail.gmail.com>
 <20200714053930.GC25@760745902f30>
 <20200715044129.GA11248@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715044129.GA11248@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)

On Tue, Jul 14, 2020 at 09:41:29PM -0700, Sean Christopherson wrote:
> On Tue, Jul 14, 2020 at 05:39:30AM +0000, Andersen, John wrote:
> > With regards to FSGSBASE, are we open to validating and adding that to the
> > DEFAULT set as a part of a separate patchset? This patchset is focused on
> > replicating the functionality we already have natively.
> 
> Kees added FSGSBASE pinning in commit a13b9d0b97211 ("x86/cpu: Use pinning
> mask for CR4 bits needing to be 0"), so I believe it's a done deal already.

Ah my bad. Thanks, I'll look into it.
