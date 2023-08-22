Return-Path: <kernel-hardening-return-21676-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by mail.lfdr.de (Postfix) with SMTP id 294ED784486
	for <lists+kernel-hardening@lfdr.de>; Tue, 22 Aug 2023 16:39:52 +0200 (CEST)
Received: (qmail 22414 invoked by uid 550); 22 Aug 2023 14:39:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 22379 invoked from network); 22 Aug 2023 14:39:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
	s=20191114; t=1692715169;
	bh=WhKqI2kevlKwnL5CJURW6uf2fK2kg2ZhcCAl/i9YR4g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=smWH8KPMfbDOycf2gMO0WxHUv3sIeJv5uV7ag24TsMekyl0xMSh8ZhUTuetwjar2A
	 pR45D5vGJNRH4cjHkKRNOMI1UPsjXLFNyZDGwFod9OOwTXiUI1X0Fyd7e4qw2+8gPq
	 zbSzhnE4zDTy9SnQQ2hYfqf7loqIa+0eEd6SkLgc=
Date: Tue, 22 Aug 2023 16:39:27 +0200
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: =?utf-8?Q?G=C3=BCnther?= Noack <gnoack@google.com>
Cc: linux-security-module@vger.kernel.org, Jeff Xu <jeffxu@google.com>, 
	Jorge Lucangeli Obes <jorgelo@chromium.org>, Allen Webb <allenwebb@google.com>, 
	Dmitry Torokhov <dtor@google.com>, Paul Moore <paul@paul-moore.com>, 
	Konstantin Meskhidze <konstantin.meskhidze@huawei.com>, Matt Bobrowski <repnop@google.com>, 
	linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>, 
	Greg KH <gregkh@linuxfoundation.org>, Hanno =?utf-8?B?QsO2Y2s=?= <hanno@hboeck.de>, 
	kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, 
	Jiri Slaby <jirislaby@kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	Samuel Thibault <samuel@ens-lyon.org>, David Laight <David.Laight@aculab.com>, 
	Simon Brand <simon.brand@postadigitale.de>, Dave Mielke <Dave@mielke.cc>
Subject: Re: [PATCH v3 0/5] Landlock: IOCTL support - TTY restrictions RFC
Message-ID: <20230822.ua3aib8Zaile@digikod.net>
References: <20230814172816.3907299-1-gnoack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230814172816.3907299-1-gnoack@google.com>
X-Infomaniak-Routing: alpha

Here is a proposal to restrict TTY with Landlock, complementary to this
patch series (which should land before any other IOCTL-related
features).

CCing folks part of TIOCSTI discussions, as a complementary approach to
https://lore.kernel.org/all/ZN+X6o3cDWcLoviq@google.com/

On Mon, Aug 14, 2023 at 07:28:11PM +0200, G�nther Noack wrote:
> Hello!
> 
> These patches add simple ioctl(2) support to Landlock.
> 
> Objective
> ~~~~~~~~~
> 
> Make ioctl(2) requests restrictable with Landlock,
> in a way that is useful for real-world applications.
> 
> Proposed approach
> ~~~~~~~~~~~~~~~~~
> 
> Introduce the LANDLOCK_ACCESS_FS_IOCTL right, which restricts the use
> of ioctl(2) on file descriptors.
> 
> We attach the LANDLOCK_ACCESS_FS_IOCTL right to opened file
> descriptors, as we already do for LANDLOCK_ACCESS_FS_TRUNCATE.
> 
> We make an exception for the common and known-harmless IOCTL commands FIOCLEX,
> FIONCLEX, FIONBIO, FIOASYNC and FIONREAD.  These IOCTL commands are always
> permitted.  The functionality of the first four is already available through
> fcntl(2), and FIONREAD only returns the number of ready-to-read bytes.
> 
> I believe that this approach works for the majority of use cases, and
> offers a good trade-off between Landlock API and implementation
> complexity and flexibility when the feature is used.
> 
> Current limitations
> ~~~~~~~~~~~~~~~~~~~
> 
> With this patch set, ioctl(2) requests can *not* be filtered based on
> file type, device number (dev_t) or on the ioctl(2) request number.
> 
> On the initial RFC patch set [1], we have reached consensus to start
> with this simpler coarse-grained approach, and build additional IOCTL
> restriction capabilities on top in subsequent steps.
> 
> [1] https://lore.kernel.org/linux-security-module/d4f1395c-d2d4-1860-3a02-2a0c023dd761@digikod.net/
> 
> Notable implications of this approach
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> * Existing inherited file descriptors stay unaffected
>   when a program enables Landlock.
> 
>   This means in particular that in common scenarios,
>   the terminal's IOCTLs (ioctl_tty(2)) continue to work.
> 
> * ioctl(2) continues to be available for file descriptors acquired
>   through means other than open(2).  Example: Network sockets,
>   memfd_create(2), file descriptors that are already open before the
>   Landlock ruleset is enabled.

Digging through all potential malicious use of TTYs and because TTYs are
part of process management (e.g. signaling) and mediated by the kernel,
I changed my mind and I think we should investigate on protecting shared
TTY thanks to Landlock, but not without context and not only against
TIOCSTI and TIOCLINUX IOCTLs.

TIOCSTI is abused since a few decades [1] [2], and as G�nther said, it
is still the case [3] as with TIOCLINUX [4] [5]. Since Linux 6.2,
CONFIG_LEGACY_TIOCSTI (and the corresponding sysctl knob) can be set to
deny all use of TIOCSTI. This kernel configuration is a good step
forward but it may not be enabled everywhere because it is a
system-wide restriction. Moreover, it is not a sandboxing feature which
means developers cannot safely protect users from their applications
without impacting the whole system. Making Landlock able to protect
against this kind of attack and other TTY-based ones (e.g. snoop
keystrokes [6]) is definitely something worth it.

The behavior change should only affect a TTY which is shared (same
session or not) with a set of processes containing at least one
sandboxed process.

The simplest and more generic solution I came up with is to tie the TTY
(e.g. PTY slave) with the Landlock domain (if any) of the
*first process* to be a session leader with this TTY. For all sandboxed
processes, if the TTY's domain is more privileged than the process's
domain, then any TIOCSTI should be denied.

For the snooping protection, I think we could enforce that only the
(current) session leader can read the TTY. Same goes for writing to the
TTY (but this should already be covered).

Basically, all IOCTLs that enable, one way or another, to fool a user
should be restricted as TIOCSTI. This includes copy/paste requests
(TIOCLINUX subcommands), but also potentially font change (e.g.
PIO_FONT), keyboard mapping change, all CAP_SYS_TTY_CONFIG-checked
IOCTLs, and probably more. The goal is not to protect against
potentially annoying features such as keyboard light changes though, but
really to protect integrity and confidentiality of data going through
the TTY.

The goal is to enforce Landlock security boundaries across TTY's
clients. In a nutshell, if a process is sandboxed, only allow read,
write and most IOCTL requests if the TTY's domain would be ptracable
(see security/landlock/ptrace.c), otherwise deny such action. I think
this algorithm would fit well:
* if the current process is not sandboxed, then allow
* else if the TTY's domain is the same or a child of the current
  process's domain, then allow (including the TIOCSTI IOCTL)
* else if the current process is the session leader of this TTY, then
  allow read/write/non-TIOCSTI-IOCTLs
* else deny

The challenge would be to make these checks efficient, especially for
the read and write syscalls.

When setting the session leader, we could update the TTY's domain with
the highest-privileged one, or the NULL domain (i.e. the
root/unsandboxed). However, this would mean that previous TIOCSTI
requests could have been allowed and could now impact the current
(higher privileged) session leader. I think this cannot be properly
mitigated solely at the access control level. I'd prefer to properly
document this limitation for which I don't see any valid use case.
We should test if this theory works in practice with real-world
applications though. The question is: are they any programs that pass a
TTY FD to a (potentially malicious but sandboxed) process, and *then*
switch for the first time to a session leader with this TTY?

We might also not want to return EPERM for all kind of requests but EIO
instead.

Because of compatibility reasons, and different use cases, these
restrictions should only be enforced between Landlock domains that
opt-in for this feature thanks to a new ruleset's flag, something like
LANDLOCK_RULESET_SCOPE_TTY. So all mentions of Landlock domains should
in fact only refer to TTY-restricted-domains. As for the upcoming
Landlock network restrictions, these TTY restrictions should be
independent from any FS-related actions (e.g. mount).

BTW, the TIOCSTI would be useful to test (cf. kselftest) this kind of
restrictions.

What do you think?

[1] https://isopenbsdsecu.re/mitigations/tiocsti/
[2] https://jdebp.uk/FGA/TIOCSTI-is-a-kernel-problem.html
[3] https://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=TIOCSTI
[4] https://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=TIOCLINUX
[5] https://lore.kernel.org/all/ZN+X6o3cDWcLoviq@google.com/
[6] https://gist.github.com/thejh/e163071dfe4c96a9f9b589b7a2c24fc6
