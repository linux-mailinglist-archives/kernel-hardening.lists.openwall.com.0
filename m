Return-Path: <kernel-hardening-return-18127-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 693C818237B
	for <lists+kernel-hardening@lfdr.de>; Wed, 11 Mar 2020 21:46:19 +0100 (CET)
Received: (qmail 30493 invoked by uid 550); 11 Mar 2020 20:46:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 30470 invoked from network); 11 Mar 2020 20:46:11 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	 bh=lWqnS0cz202pymudp+fi5S2BVavTcKkGDJBwh6JxRl4=; b=Kiv1J97Q8JPE8ZCa5dB851mFp
	W4a0looOhxyYJXowNd7RWtL2s5gl1JqNnoQpNvCjfnx3oMdzxjDkwALD0SK3hJMDW9r+E5netNRw2
	gTa6OnqbDYIr3mEoYzRUvgGElWRkLcCaqPqiInqHIk8QujnuQo+raQFv7Ltv+4td/t4Lk27id2OpA
	Ik1RbOzbuLpGG1Pcs/cOXF4/nX0Pfc+QXXQdwAmI7s0Jn92cKyosaw2vEwSHMfcQbJU/maS0+GPOw
	mA62cq5sKkvh3YDW3uKLukGmsWpKjwuufduP7KtP1o/E4TL0TQbGJsM8lsDNbDAXdsH/8B9TZjnw+
	OTd58mRnA==;
Date: Wed, 11 Mar 2020 20:45:31 +0000
From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
To: Kees Cook <keescook@chromium.org>
Cc: Guenter Roeck <linux@roeck-us.net>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Emese Revfy <re.emese@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
	Laura Abbott <labbott@redhat.com>,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v3] ARM: smp: add support for per-task stack canaries
Message-ID: <20200311204531.GU25745@shell.armlinux.org.uk>
References: <20181206083257.9596-1-ard.biesheuvel@linaro.org>
 <20200309164931.GA23889@roeck-us.net>
 <202003111020.D543B4332@keescook>
 <04a8c31a-3c43-3dcf-c9fd-82ba225a19f6@roeck-us.net>
 <202003111146.E3FC1924@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202003111146.E3FC1924@keescook>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>

On Wed, Mar 11, 2020 at 11:47:20AM -0700, Kees Cook wrote:
> On Wed, Mar 11, 2020 at 11:31:13AM -0700, Guenter Roeck wrote:
> > On 3/11/20 10:21 AM, Kees Cook wrote:
> > > On Mon, Mar 09, 2020 at 09:49:31AM -0700, Guenter Roeck wrote:
> > >> On Thu, Dec 06, 2018 at 09:32:57AM +0100, Ard Biesheuvel wrote:
> > >>> On ARM, we currently only change the value of the stack canary when
> > >>> switching tasks if the kernel was built for UP. On SMP kernels, this
> > >>> is impossible since the stack canary value is obtained via a global
> > >>> symbol reference, which means
> > >>> a) all running tasks on all CPUs must use the same value
> > >>> b) we can only modify the value when no kernel stack frames are live
> > >>>    on any CPU, which is effectively never.
> > >>>
> > >>> So instead, use a GCC plugin to add a RTL pass that replaces each
> > >>> reference to the address of the __stack_chk_guard symbol with an
> > >>> expression that produces the address of the 'stack_canary' field
> > >>> that is added to struct thread_info. This way, each task will use
> > >>> its own randomized value.
> > >>>
> > >>> Cc: Russell King <linux@armlinux.org.uk>
> > >>> Cc: Kees Cook <keescook@chromium.org>
> > >>> Cc: Emese Revfy <re.emese@gmail.com>
> > >>> Cc: Arnd Bergmann <arnd@arndb.de>
> > >>> Cc: Laura Abbott <labbott@redhat.com>
> > >>> Cc: kernel-hardening@lists.openwall.com
> > >>> Acked-by: Nicolas Pitre <nico@linaro.org>
> > >>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > >>
> > >> Since this patch is in the tree, cc-option no longer works on
> > >> the arm architecture if CONFIG_STACKPROTECTOR_PER_TASK is enabled.
> > >>
> > >> Any idea how to fix that ? 
> > > 
> > > I thought Arnd sent a patch to fix it and it got picked up?
> > > 
> > 
> > Yes, but the fix is not upstream (it is only in -next), and I missed it.
> 
> Ah, yes, I found it again now too; it went through rmk's tree.
> 
> For thread posterity:
> 
> ARM: 8961/2: Fix Kbuild issue caused by per-task stack protector GCC plugin
> https://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=8961/2

It's in my fixes branch, waiting for me to do my (now usual) push
of fixes to Linus.

I'm not sure whether the above discussion is suggesting that there's
a problem with this patch, or whether it's trying to encourage me
to send it up to Linus.  I _think_ there's the suggestion that it
causes a regression, hmm?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
