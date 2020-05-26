Return-Path: <kernel-hardening-return-18406-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 8BB3F19D194
	for <lists+kernel-hardening@lfdr.de>; Fri,  3 Apr 2020 09:59:36 +0200 (CEST)
Received: (qmail 11842 invoked by uid 550); 3 Apr 2020 07:59:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 11807 invoked from network); 3 Apr 2020 07:59:29 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	message-id:subject:from:to:cc:date:in-reply-to:references
	:content-type:mime-version:content-transfer-encoding; s=fm1; bh=
	nd+7G8s6MZrgGUYenpUJDE9f0FAk5ae6re4bdlUv6Pk=; b=e9cOEAQ8CFWqvYoG
	95Yn5S5hEqMTwMxm2ykJBW0NA8XmJcyi0fRAC4DSBANBWeEQ+hxiW+m1RLKkL2IH
	fyPQil4SxPwbYb03JzGkcRFmehdOsIG44Ej/CX1w4ucn5k7+17eO0cU8pvGq49/o
	ZF/ZcY8qXGRLDuX8TTMMKy6y0Ui25Swqyt8K/+H0sjVI1KZZeTEPybM+jZoQbL3P
	kpKYHsiIr/nctd9IESqMKVf0EK1L/52nrQoSXQlxVfdKGI8AIfWa21Z4/9GGXh7X
	OW1jRneeGSbwgeKJy2II5XTWrc6tXcvkb9PJg9u8TXUqISmKk27Vb5HfXh+ISved
	kmQRag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:from:in-reply-to:message-id:mime-version:references
	:subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm2; bh=nd+7G8s6MZrgGUYenpUJDE9f0FAk5ae6re4bdlUv6
	Pk=; b=FMzZwVpAsfdbkN/HK6dzZjUYHOXT1QbyuPguizILdd5CTrpimZ2iUEsXs
	A5XvQT3ErWBFVVNIRFMukqK9UzhoREGYZ83KWK0kYXNIOPs6Iec1i6oiqKRX5t9K
	58WOy0kPighqBgPKh4aZcOhMcyktzt2VsW62rwoERRkidFbfpHNWbOtzPvg+8S+y
	3qK/VVMECF2psirHGCpP1MuTbSl2umbEKDEpyojVQhuLh6npbQ5keSvF1mmXZLGZ
	w3TlynFWEd6D4NIB5ava1WOpKs9Znpt4HjRyIY2QslvlYbrXtTmUVAMxliG7V8RD
	02wwks4ydOfQ0aFA+Tv7TWEUXAmSg==
X-ME-Sender: <xms:0-yGXlPtzcPhobaH6w0QVkW61TuQA2lCCgpSKmtO2Hughh1_0oZGcA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrtdehgdduvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdluddtmdenucfjughrpefkuf
    fhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpeftuhhsshgvlhhlucevuhhr
    rhgvhicuoehruhhstghurhesrhhushhsvghllhdrtggtqeenucfkphepuddvuddrgeehrd
    dvuddvrddvfeelnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhf
    rhhomheprhhushgtuhhrsehruhhsshgvlhhlrdgttg
X-ME-Proxy: <xmx:0-yGXlbkRHdsN9uwO3euJeM6NuBwZZFuVtfDvZhK0vjQ9LXEnLDzTg>
    <xmx:0-yGXkM4E9-g0ezGFvXskZjXmycvYKaD1QV8T5pk_fpLdtL5j94p7Q>
    <xmx:0-yGXjW_w6GUSaIwzW2iP6_uRA9GobmiVK3GnXhGgL_hD9H04F1zpg>
    <xmx:1OyGXhE2GSAbViTPmZmsRvt26qwHxc9Dk91KC7oTDrNijvgfvhOUlA>
Message-ID: <c336400d5b7765eb72b3090cd9f8a3c57761d0b6.camel@russell.cc>
Subject: Re: [PATCH v8 2/7] powerpc/kprobes: Mark newly allocated probes as
 RO
From: Russell Currey <ruscur@russell.cc>
To: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>, 
	linuxppc-dev@lists.ozlabs.org
Cc: ajd@linux.ibm.com, dja@axtens.net, kernel-hardening@lists.openwall.com, 
	npiggin@gmail.com
Date: Fri, 03 Apr 2020 18:59:09 +1100
In-Reply-To: <1585852977.oiikywo1jz.naveen@linux.ibm.com>
References: <20200402084053.188537-1-ruscur@russell.cc>
	 <20200402084053.188537-2-ruscur@russell.cc>
	 <1585844035.o235bvxmq0.naveen@linux.ibm.com>
	 <1585852977.oiikywo1jz.naveen@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2020-04-03 at 00:18 +0530, Naveen N. Rao wrote:
> Naveen N. Rao wrote:
> > Russell Currey wrote:
> > > With CONFIG_STRICT_KERNEL_RWX=y and CONFIG_KPROBES=y, there will
> > > be one
> > > W+X page at boot by default.  This can be tested with
> > > CONFIG_PPC_PTDUMP=y and CONFIG_PPC_DEBUG_WX=y set, and checking
> > > the
> > > kernel log during boot.
> > > 
> > > powerpc doesn't implement its own alloc() for kprobes like other
> > > architectures do, but we couldn't immediately mark RO anyway
> > > since we do
> > > a memcpy to the page we allocate later.  After that, nothing
> > > should be
> > > allowed to modify the page, and write permissions are removed
> > > well
> > > before the kprobe is armed.
> > > 
> > > The memcpy() would fail if >1 probes were allocated, so use
> > > patch_instruction() instead which is safe for RO.
> > > 
> > > Reviewed-by: Daniel Axtens <dja@axtens.net>
> > > Signed-off-by: Russell Currey <ruscur@russell.cc>
> > > Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> > > ---
> > >  arch/powerpc/kernel/kprobes.c | 17 +++++++++++++----
> > >  1 file changed, 13 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/arch/powerpc/kernel/kprobes.c
> > > b/arch/powerpc/kernel/kprobes.c
> > > index 81efb605113e..fa4502b4de35 100644
> > > --- a/arch/powerpc/kernel/kprobes.c
> > > +++ b/arch/powerpc/kernel/kprobes.c
> > > @@ -24,6 +24,8 @@
> > >  #include <asm/sstep.h>
> > >  #include <asm/sections.h>
> > >  #include <linux/uaccess.h>
> > > +#include <linux/set_memory.h>
> > > +#include <linux/vmalloc.h>
> > >  
> > >  DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
> > >  DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
> > > @@ -102,6 +104,16 @@ kprobe_opcode_t *kprobe_lookup_name(const
> > > char *name, unsigned int offset)
> > >  	return addr;
> > >  }
> > >  
> > > +void *alloc_insn_page(void)
> > > +{
> > > +	void *page = vmalloc_exec(PAGE_SIZE);
> > > +
> > > +	if (page)
> > > +		set_memory_ro((unsigned long)page, 1);
> > > +
> > > +	return page;
> > > +}
> > > +
> > 
> > This crashes for me with KPROBES_SANITY_TEST during the kretprobe
> > test.  
> 
> That isn't needed to reproduce this. After bootup, disabling
> optprobes 
> also shows the crash with kretprobes:
> 	sysctl debug.kprobes-optimization=0
> 
> The problem happens to be with patch_instruction() in 
> arch_prepare_kprobe(). During boot, on kprobe init, we register a
> probe 
> on kretprobe_trampoline for use with kretprobes (see 
> arch_init_kprobes()). This results in an instruction slot being 
> allocated, and arch_prepare_kprobe() to be called for copying the 
> instruction (nop) at kretprobe_trampoline. patch_instruction() is 
> failing resulting in corrupt instruction which we try to
> emulate/single 
> step causing the crash.

OK I think I've fixed it, KPROBES_SANITY_TEST passes too.  I'd
appreciate it if you could test v9, and thanks again for finding this -
very embarrassing bug on my side.

- Russell

> 
> 
> - Naveen
> 

