Return-Path: <kernel-hardening-return-19440-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id AB6DD22CC50
	for <lists+kernel-hardening@lfdr.de>; Fri, 24 Jul 2020 19:40:39 +0200 (CEST)
Received: (qmail 1688 invoked by uid 550); 24 Jul 2020 17:40:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1666 invoked from network); 24 Jul 2020 17:40:34 -0000
Date: Fri, 24 Jul 2020 13:40:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Oscar Carter <oscar.carter@gmx.com>
Cc: Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
 linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Jann
 Horn <jannh@google.com>
Subject: Re: [PATCH v2 2/2] kernel/trace: Remove function callback casts
Message-ID: <20200724134020.3160dc7c@oasis.local.home>
In-Reply-To: <20200724133656.76c75629@oasis.local.home>
References: <20200719155033.24201-1-oscar.carter@gmx.com>
	<20200719155033.24201-3-oscar.carter@gmx.com>
	<20200721140545.445f0258@oasis.local.home>
	<20200724161921.GA3123@ubuntu>
	<20200724123528.36ea9c9e@oasis.local.home>
	<20200724171418.GB3123@ubuntu>
	<20200724133656.76c75629@oasis.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 24 Jul 2020 13:36:56 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> Which BTW, is supported by the following architectures:
> 
>   arm
>   arm64
>   csky
>   parisc
>   powerpc
>   riscv
>   s390
>   x86

And here's a list of architectures that have function tracing but need
to be updated:

  ia64
  microblaze
  mips
  nds32
  sh
  sparc
  xtensa

> 
> All of the above architectures should not even be hitting the code
> that does the function cast. What architecture are you doing all this
> for?

Which one of the above is this patch set for?

-- Steve
