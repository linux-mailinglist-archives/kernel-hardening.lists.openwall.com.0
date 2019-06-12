Return-Path: <kernel-hardening-return-16115-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 816BA42E90
	for <lists+kernel-hardening@lfdr.de>; Wed, 12 Jun 2019 20:26:10 +0200 (CEST)
Received: (qmail 15549 invoked by uid 550); 12 Jun 2019 18:26:04 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 15518 invoked from network); 12 Jun 2019 18:26:03 -0000
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
X-ExtLoop1: 1
Date: Wed, 12 Jun 2019 11:25:50 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Marius Hillenbrand <mhillenb@amazon.de>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com, linux-mm@kvack.org,
	Alexander Graf <graf@amazon.de>,
	David Woodhouse <dwmw@amazon.co.uk>
Subject: Re: [RFC 00/10] Process-local memory allocations for hiding KVM
 secrets
Message-ID: <20190612182550.GI20308@linux.intel.com>
References: <20190612170834.14855-1-mhillenb@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190612170834.14855-1-mhillenb@amazon.de>
User-Agent: Mutt/1.5.24 (2015-08-30)

On Wed, Jun 12, 2019 at 07:08:24PM +0200, Marius Hillenbrand wrote:
> The Linux kernel has a global address space that is the same for any
> kernel code. This address space becomes a liability in a world with
> processor information leak vulnerabilities, such as L1TF. With the right
> cache load gadget, an attacker-controlled hyperthread pair can leak
> arbitrary data via L1TF. Disabling hyperthreading is one recommended
> mitigation, but it comes with a large performance hit for a wide range
> of workloads.
> 
> An alternative mitigation is to not make certain data in the kernel
> globally visible, but only when the kernel executes in the context of
> the process where this data belongs to.
>
> This patch series proposes to introduce a region for what we call
> process-local memory into the kernel's virtual address space. Page
> tables and mappings in that region will be exclusive to one address
> space, instead of implicitly shared between all kernel address spaces.
> Any data placed in that region will be out of reach of cache load
> gadgets that execute in different address spaces. To implement
> process-local memory, we introduce a new interface kmalloc_proclocal() /
> kfree_proclocal() that allocates and maps pages exclusively into the
> current kernel address space. As a first use case, we move architectural
> state of guest CPUs in KVM out of reach of other kernel address spaces.

Can you briefly describe what types of attacks this is intended to
mitigate?  E.g. guest-guest, userspace-guest, etc...  I don't want to
make comments based on my potentially bad assumptions.
 
> The patch set is a prototype for x86-64 that we have developed on top of
> kernel 4.20.17 (with cherry-picked commit d253ca0c3865 "x86/mm/cpa: Add
> set_direct_map_*() functions"). I am aware that the integration with KVM
> will see some changes while rebasing to 5.x. Patches 7 and 8, in

Ha, "some" :-)

> particular, help make patch 9 more readable, but will be dropped in
> rebasing. We have tested the code on both Intel and AMDs, launching VMs
> in a loop. So far, we have not done in-depth performance evaluation.
> Impact on starting VMs was within measurement noise.
