Return-Path: <kernel-hardening-return-16538-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 5F2BC70C8C
	for <lists+kernel-hardening@lfdr.de>; Tue, 23 Jul 2019 00:28:23 +0200 (CEST)
Received: (qmail 9655 invoked by uid 550); 22 Jul 2019 22:28:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 9623 invoked from network); 22 Jul 2019 22:28:18 -0000
Date: Mon, 22 Jul 2019 16:28:04 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Joe Perches <joe@perches.com>
Cc: Stephen Kitt <steve@sk2.org>, Kees Cook <keescook@chromium.org>, Nitin
 Gote <nitin.r.gote@intel.com>, jannh@google.com,
 kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Rasmus
 Villemoes <rasmus.villemoes@prevas.dk>
Subject: Re: [PATCH] checkpatch: Added warnings in favor of strscpy().
Message-ID: <20190722162804.754943bc@lwn.net>
In-Reply-To: <512d8977fb0d0b3eef7b6ea1753fb4c33fbc43e8.camel@perches.com>
References: <1561722948-28289-1-git-send-email-nitin.r.gote@intel.com>
	<20190629181537.7d524f7d@sk2.org>
	<201907021024.D1C8E7B2D@keescook>
	<20190706144204.15652de7@heffalump.sk2.org>
	<201907221047.4895D35B30@keescook>
	<15f2be3cde69321f4f3a48d60645b303d66a600b.camel@perches.com>
	<20190722230102.442137dc@heffalump.sk2.org>
	<d96cf801c5cf68e785e8dfd9dba0994fcff20017.camel@perches.com>
	<20190722155730.08dfd4e3@lwn.net>
	<512d8977fb0d0b3eef7b6ea1753fb4c33fbc43e8.camel@perches.com>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit

On Mon, 22 Jul 2019 15:24:33 -0700
Joe Perches <joe@perches.com> wrote:

> > If the functions themselves are fully defined in the .h file, I'd just add
> > the kerneldoc there as well.  That's how it's usually done, and you want
> > to keep the documentation and the prototypes together.  
> 
> In this case, it's a macro and yes, the kernel-doc could
> easily be set around the macro in the .h, but my desire
> is to keep all the string function kernel-doc output
> together so it should be added to lib/string.c
> 
> Are you suggesting I move all the lib/string.c kernel-doc
> to include/linux/string.h ?

If you want the *output* together, just put the kernel-doc directives
together in the RST file that pulls it all in.  Or am I missing something
here?

Thanks,

jon
