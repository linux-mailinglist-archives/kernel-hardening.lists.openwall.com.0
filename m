Return-Path: <kernel-hardening-return-17399-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 3C665102E54
	for <lists+kernel-hardening@lfdr.de>; Tue, 19 Nov 2019 22:39:32 +0100 (CET)
Received: (qmail 13341 invoked by uid 550); 19 Nov 2019 21:39:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 13321 invoked from network); 19 Nov 2019 21:39:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	 bh=AgTBdHkU4FBPDqoTvXaZxMTMO2lJifTMoE3YdoPlxUk=; b=QvfH76kmGcXCd92qhTMCTja8Q
	6u3HRtHN57DhQsca1oWJY9WTwBUroL5TkZtADTHEVAJoIXkXpMEZaN/2ctDJMsWK1aGs1X4WRrOzL
	lHe1Dgs4ADcPmjWXTrwwg7P8A/GRQpPaLCzmBwvEyjYKANxdOXpEd/rQsy4LsruiEbIzCRvNrJAuA
	Gj1JrPVDvcxDSgCIHClLZKTqe4+eBh9N4gl7TdbB76qfL/rTfAfd98NHYfXvWSvRqqrbSEaciir9p
	QgLtha7JMrFD1Z+lojpOFUW4zcm3fIekf3VVohp6TXk+EPI3IMDMhZ45zaASBN6cp9m2pMMee/i35
	iFiZo5dAw==;
Date: Tue, 19 Nov 2019 22:38:54 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Tianlin Li <tli@digitalocean.com>
Cc: kernel-hardening@lists.openwall.com, keescook@chromium.org,
	Steven Rostedt <rostedt@goodmis.org>,
	Ingo Molnar <mingo@redhat.com>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Greentime Hu <green.hu@gmail.com>,
	Vincent Chen <deanbo422@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>, "H . Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org, Jessica Yu <jeyu@kernel.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: [RFC PATCH] kernel/module: have the callers of set_memory_*()
 check the return value
Message-ID: <20191119213854.GP3079@worktop.programming.kicks-ass.net>
References: <20191119155149.20396-1-tli@digitalocean.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191119155149.20396-1-tli@digitalocean.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Nov 19, 2019 at 09:51:49AM -0600, Tianlin Li wrote:
> Right now several architectures allow their set_memory_*() family of 
> functions to fail, but callers may not be checking the return values. We 
> need to fix the callers and add the __must_check attribute. They also may
> not provide any level of atomicity, in the sense that the memory 
> protections may be left incomplete on failure. This issue likely has a few 
> steps on effects architectures[1]:
> 1)Have all callers of set_memory_*() helpers check the return value.
> 2)Add __much_check to all set_memory_*() helpers so that new uses do not 
> ignore the return value.
> 3)Add atomicity to the calls so that the memory protections aren't left in 
> a partial state.
> 
> Ideally, the failure of set_memory_*() should be passed up the call stack, 
> and callers should examine the failure and deal with it. But currently, 
> some callers just have void return type.
> 
> We need to fix the callers to handle the return all the way to the top of 
> stack, and it will require a large series of patches to finish all the three 
> steps mentioned above. I start with kernel/module, and will move onto other 
> subsystems. I am not entirely sure about the failure modes for each caller. 
> So I would like to get some comments before I move forward. This single 
> patch is just for fixing the return value of set_memory_*() function in 
> kernel/module, and also the related callers. Any feedback would be greatly 
> appreciated.

Please have a look here:

  https://lkml.kernel.org/r/20191111131252.921588318@infradead.org

Much of the code you're patching is slated for removal.

Josh also has patches reworking KLP and there's some ARM64 patches
pending at which point we can also delete module_disable_ro().


