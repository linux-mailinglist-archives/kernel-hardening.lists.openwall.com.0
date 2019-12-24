Return-Path: <kernel-hardening-return-17522-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 2D74F129FF1
	for <lists+kernel-hardening@lfdr.de>; Tue, 24 Dec 2019 11:04:47 +0100 (CET)
Received: (qmail 5282 invoked by uid 550); 24 Dec 2019 10:04:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 5262 invoked from network); 24 Dec 2019 10:04:40 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1577181868;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=lZBp7WJCTDYPOomy6Za4skPEqciE2e9sbtVlgHLZuQw=;
	b=F7NfYjT8T7RuQTVZZX4JYza98gxXNuJUZSmRdHlZ12yiRY3KZJgYpmHVLQEFgOXjwQ5QCy
	1MFaouSTNo2iWf5/mbdUyCgmtdmVAYiNH0Ulj8Ci2/PlEXzNg8dFZvEBKlzjSehTG9UuR6
	3QEBi6606+OQuFC3xIJ5Ft4HG7Fk0eY=
Date: Tue, 24 Dec 2019 11:04:23 +0100
From: Borislav Petkov <bp@alien8.de>
To: Thomas Garnier <thgarnie@chromium.org>
Cc: kernel-hardening@lists.openwall.com, kristen@linux.intel.com,
	keescook@chromium.org, Juergen Gross <jgross@suse.com>,
	Thomas Hellstrom <thellstrom@vmware.com>,
	"VMware, Inc." <pv-drivers@vmware.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org, virtualization@lists.linux-foundation.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 10/11] x86/paravirt: Adapt assembly for PIE support
Message-ID: <20191224100423.GC21017@zn.tnic>
References: <20191205000957.112719-1-thgarnie@chromium.org>
 <20191205000957.112719-11-thgarnie@chromium.org>
 <20191223172350.GH16710@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191223172350.GH16710@zn.tnic>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Dec 23, 2019 at 06:23:50PM +0100, Borislav Petkov wrote:
> On Wed, Dec 04, 2019 at 04:09:47PM -0800, Thomas Garnier wrote:
> > If PIE is enabled, switch the paravirt assembly constraints to be
> > compatible. The %c/i constrains generate smaller code so is kept by
> > default.
> > 
> > Position Independent Executable (PIE) support will allow to extend the
> > KASLR randomization range below 0xffffffff80000000.
> > 
> > Signed-off-by: Thomas Garnier <thgarnie@chromium.org>
> > Acked-by: Juergen Gross <jgross@suse.com>
> > ---
> >  arch/x86/include/asm/paravirt_types.h | 32 +++++++++++++++++++++++----
> >  1 file changed, 28 insertions(+), 4 deletions(-)
> 
> More missed feedback:
> 
> https://lkml.kernel.org/r/CAJcbSZG-JhBC9b1JMv1zq2r5uRQipYLtkNjM67sd7=eqy_iOaA@mail.gmail.com

Whoops, it is in the comment above PARAVIRT_CALL_POST. I must've been
blind yesterday. Forget what I said and sorry.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
