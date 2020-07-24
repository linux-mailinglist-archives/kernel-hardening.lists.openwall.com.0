Return-Path: <kernel-hardening-return-19436-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 6978522CB29
	for <lists+kernel-hardening@lfdr.de>; Fri, 24 Jul 2020 18:35:49 +0200 (CEST)
Received: (qmail 5295 invoked by uid 550); 24 Jul 2020 16:35:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 5274 invoked from network); 24 Jul 2020 16:35:42 -0000
Date: Fri, 24 Jul 2020 12:35:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Oscar Carter <oscar.carter@gmx.com>
Cc: Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
 linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Jann
 Horn <jannh@google.com>
Subject: Re: [PATCH v2 2/2] kernel/trace: Remove function callback casts
Message-ID: <20200724123528.36ea9c9e@oasis.local.home>
In-Reply-To: <20200724161921.GA3123@ubuntu>
References: <20200719155033.24201-1-oscar.carter@gmx.com>
	<20200719155033.24201-3-oscar.carter@gmx.com>
	<20200721140545.445f0258@oasis.local.home>
	<20200724161921.GA3123@ubuntu>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 24 Jul 2020 18:19:21 +0200
Oscar Carter <oscar.carter@gmx.com> wrote:

> > The linker trick is far less intrusive, and I believe less error prone.  
> 
> If we use the linker trick, the warning -Wcast-function-type dissapears,
> but in a way that makes impossible to the compiler to get the necessary
> info about function prototypes to insert the commented check. As far I
> know, this linker trick (redirection of a function) is hidden for the
> CFI build.
> 
> So, in my opinion, the linker trick is not suitable if we want to protect
> the function pointers of the ftrace subsystem against an attack that
> modifiy the normal flow of the kernel.

The linker trick should only affect architectures that don't implement
the needed features. I can make it so the linker trick is only applied
to those archs, and other archs that want more protection only need to
add these features to their architectures.

It's much less intrusive than this patch.

-- Steve
