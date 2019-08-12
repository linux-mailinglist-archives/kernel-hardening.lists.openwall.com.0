Return-Path: <kernel-hardening-return-16782-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 6B94C89EEB
	for <lists+kernel-hardening@lfdr.de>; Mon, 12 Aug 2019 14:55:14 +0200 (CEST)
Received: (qmail 25933 invoked by uid 550); 12 Aug 2019 12:55:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 25915 invoked from network); 12 Aug 2019 12:55:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1565614495;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=geGz34k9iIxQmYTYmE4PqJlaSb7O4gvl8nVCqWyChG0=;
	b=QZhHyYQx5/GjizDY76ZoGIOafhImZZQUPDBryQmRi7crZ6NkKghWhdhWvfsUr47YRZuIRp
	l0dWhet/GkUHmjxlwQBRq0ZMzIuJuxvxjwblmWp5zT4lNc4YYQfrP+nW/pWRxzfdb2FcyW
	NcKJdoNGffRUqbw055prm/buvA17VBg=
Date: Mon, 12 Aug 2019 14:55:40 +0200
From: Borislav Petkov <bp@alien8.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Garnier <thgarnie@chromium.org>,
	kernel-hardening@lists.openwall.com, kristen@linux.intel.com,
	keescook@chromium.org, Juergen Gross <jgross@suse.com>,
	Thomas Hellstrom <thellstrom@vmware.com>,
	"VMware, Inc." <pv-drivers@vmware.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org, virtualization@lists.linux-foundation.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 10/11] x86/paravirt: Adapt assembly for PIE support
Message-ID: <20190812125540.GD23772@zn.tnic>
References: <20190730191303.206365-1-thgarnie@chromium.org>
 <20190730191303.206365-11-thgarnie@chromium.org>
 <20190731125306.GU31381@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190731125306.GU31381@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, Jul 31, 2019 at 02:53:06PM +0200, Peter Zijlstra wrote:
> On Tue, Jul 30, 2019 at 12:12:54PM -0700, Thomas Garnier wrote:
> > if PIE is enabled, switch the paravirt assembly constraints to be
> > compatible. The %c/i constrains generate smaller code so is kept by
> > default.
> > 
> > Position Independent Executable (PIE) support will allow to extend the
> > KASLR randomization range below 0xffffffff80000000.
> > 
> > Signed-off-by: Thomas Garnier <thgarnie@chromium.org>
> > Acked-by: Juergen Gross <jgross@suse.com>
> > ---
> >  arch/x86/include/asm/paravirt_types.h | 25 +++++++++++++++++++++----
> >  1 file changed, 21 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
> > index 70b654f3ffe5..fd7dc37d0010 100644
> > --- a/arch/x86/include/asm/paravirt_types.h
> > +++ b/arch/x86/include/asm/paravirt_types.h
> > @@ -338,9 +338,25 @@ extern struct paravirt_patch_template pv_ops;
> >  #define PARAVIRT_PATCH(x)					\
> >  	(offsetof(struct paravirt_patch_template, x) / sizeof(void *))
> >  
> > +#ifdef CONFIG_X86_PIE
> > +#define paravirt_opptr_call "a"
> > +#define paravirt_opptr_type "p"
> > +
> > +/*
> > + * Alternative patching requires a maximum of 7 bytes but the relative call is
> > + * only 6 bytes. If PIE is enabled, add an additional nop to the call
> > + * instruction to ensure patching is possible.
> > + */
> > +#define PARAVIRT_CALL_POST  "nop;"
> 
> I'm confused; where does the 7 come from? The relative call is 6 bytes,

Well, before it, the relative CALL is a CALL reg/mem64, i.e. the target
is mem64. For example:


ffffffff81025c45:       ff 14 25 68 37 02 82    callq  *0xffffffff82023768

That address there is practically pv_ops + offset.

Now, in the opcode bytes you have 0xff opcode, ModRM byte 0x14 and SIB
byte 0x25, and 4 bytes imm32 offset. And this is 7 bytes.

What it becomes is:

ffffffff81025cd0:       ff 15 fa d9 ff 00       callq  *0xffd9fa(%rip)        # ffffffff820236d0 <pv_ops+0x30>
ffffffff81025cd6:       90                      nop

which is a RIP-relative, i.e., opcode 0xff, ModRM byte 0x15 and imm32.
And this is 6 bytes.

And since the paravirt patching doesn't do NOP padding like the
alternatives patching does, you need to pad with a byte.

Thomas, please add the gist of this to the comments because this
incomprehensible machinery better be documented as detailed as possible.

Thx.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
