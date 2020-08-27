Return-Path: <kernel-hardening-return-19689-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id A3F602545AC
	for <lists+kernel-hardening@lfdr.de>; Thu, 27 Aug 2020 15:07:28 +0200 (CEST)
Received: (qmail 5923 invoked by uid 550); 27 Aug 2020 13:07:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 5792 invoked from network); 27 Aug 2020 13:06:57 -0000
Date: Thu, 27 Aug 2020 15:06:53 +0200
From: Solar Designer <solar@openwall.com>
To: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com,
	Mrinal Pandey <mrinalmni@gmail.com>
Subject: Re: [PATCH] scripts: Add intended executable mode and SPDX license
Message-ID: <20200827130653.GA25408@openwall.com>
References: <20200827092405.b6hymjxufn2nvgml@mrinalpandey>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200827092405.b6hymjxufn2nvgml@mrinalpandey>
User-Agent: Mutt/1.4.2.3i

[CC list trimmed]

On Thu, Aug 27, 2020 at 02:54:05PM +0530, Mrinal Pandey wrote:
>  mode change 100644 => 100755 scripts/gcc-plugins/gen-random-seed.sh

This is basically the only change relevant to the contribution initially
made via kernel-hardening, and in my opinion (and I am list admin) isn't
worth bringing to the list.  Now we have this bikeshed thread in here
(and I'm guilty for adding to it), and would have more (which I hope
this message of mine will prevent) if changes to something else in the
patch(es) are requested (which Greg KH sort of already did).

I recall we previously had lots of "similar" bikeshedding in here when
someone was converting the documentation to rST.  The more bikeshedding
we have, the less actual kernel-hardening work is going to happen,
because the list gets the reputation of yet another kernel maintenance
list rather than the place where actual/potential new contributions to
improve the kernel's security are discussed, and because bikeshedding
makes the most capable people unsubscribe or stop paying attention.

How about we remove kernel-hardening from the MAINTAINERS entries it's
currently in? -

GCC PLUGINS
M:      Kees Cook <keescook@chromium.org>
R:      Emese Revfy <re.emese@gmail.com>
L:      kernel-hardening@lists.openwall.com
S:      Maintained
F:      Documentation/kbuild/gcc-plugins.rst
F:      scripts/Makefile.gcc-plugins
F:      scripts/gcc-plugin.sh
F:      scripts/gcc-plugins/

LEAKING_ADDRESSES
M:      Tobin C. Harding <me@tobin.cc>
M:      Tycho Andersen <tycho@tycho.ws>
L:      kernel-hardening@lists.openwall.com
S:      Maintained
T:      git git://git.kernel.org/pub/scm/linux/kernel/git/tobin/leaks.git
F:      scripts/leaking_addresses.pl

Alternatively, would this be acceptable? -

L:      kernel-hardening@lists.openwall.com (only for messages focused on core functionality, not for maintenance detail)

I think the latter would be best, if allowed.

Kees, please comment (so that we'd hopefully not need that next time),
and if you agree please make a change to MAINTAINERS.

Mrinal, we appreciate your contribution, and the problem above isn't
yours - it's with the way MAINTAINERS doesn't fit this group well.

Thanks,

Alexander
