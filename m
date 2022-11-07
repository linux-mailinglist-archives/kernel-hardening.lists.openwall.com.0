Return-Path: <kernel-hardening-return-21579-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by mail.lfdr.de (Postfix) with SMTP id A6BD66200CB
	for <lists+kernel-hardening@lfdr.de>; Mon,  7 Nov 2022 22:15:29 +0100 (CET)
Received: (qmail 3449 invoked by uid 550); 7 Nov 2022 21:15:20 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 3224 invoked from network); 7 Nov 2022 21:15:02 -0000
Date: Mon, 7 Nov 2022 22:14:40 +0100
From: Solar Designer <solar@openwall.com>
To: Jann Horn <jannh@google.com>
Cc: Kees Cook <keescook@chromium.org>, linux-hardening@vger.kernel.org,
	kernel-hardening@lists.openwall.com,
	Greg KH <gregkh@linuxfoundation.org>,
	Linus Torvalds <torvalds@linuxfoundation.org>,
	Seth Jenkins <sethjenkins@google.com>,
	"Eric W . Biederman" <ebiederm@xmission.com>,
	Andy Lutomirski <luto@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] exit: Put an upper limit on how often we can oops
Message-ID: <20221107211440.GA4233@openwall.com>
References: <20221107201317.324457-1-jannh@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221107201317.324457-1-jannh@google.com>
User-Agent: Mutt/1.4.2.3i

On Mon, Nov 07, 2022 at 09:13:17PM +0100, Jann Horn wrote:
> +oops_limit
> +==========
> +
> +Number of kernel oopses after which the kernel should panic when
> +``panic_on_oops`` is not set.

Rather than introduce this separate oops_limit, how about making
panic_on_oops (and maybe all panic_on_*) take the limit value(s) instead
of being Boolean?  I think this would preserve the current behavior at
panic_on_oops = 0 and panic_on_oops = 1, but would introduce your
desired behavior at panic_on_oops = 10000.  We can make 10000 the new
default.  If a distro overrides panic_on_oops, it probably sets it to 1
like RHEL does.

Are there distros explicitly setting panic_on_oops to 0?  If so, that
could be a reason to introduce the separate oops_limit.

I'm not advocating one way or the other - I just felt this should be
explicitly mentioned and decided on.

Alexander
