Return-Path: <kernel-hardening-return-16224-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 0F26C5530C
	for <lists+kernel-hardening@lfdr.de>; Tue, 25 Jun 2019 17:15:52 +0200 (CEST)
Received: (qmail 3804 invoked by uid 550); 25 Jun 2019 15:15:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3785 invoked from network); 25 Jun 2019 15:15:44 -0000
From: Florian Weimer <fweimer@redhat.com>
To: linux-api@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-x86_64@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, Carlos O'Donell <carlos@redhat.com>
Subject: Detecting the availability of VSYSCALL
Date: Tue, 25 Jun 2019 17:15:27 +0200
Message-ID: <87v9wty9v4.fsf@oldenburg2.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Tue, 25 Jun 2019 15:15:32 +0000 (UTC)

We're trying to create portable binaries which use VSYSCALL on older
kernels (to avoid performance regressions), but gracefully degrade to
full system calls on kernels which do not have VSYSCALL support compiled
in (or disabled at boot).

For technical reasons, we cannot use vDSO fallback.  Trying vDSO first
and only then use VSYSCALL is the way this has been tackled in the past,
which is why this userspace ABI breakage goes generally unnoticed.  But
we don't have a dynamic linker in our scenario.

Is there any reliable way to detect that VSYSCALL is unavailable,
without resorting to parsing /proc/self/maps or opening file
descriptors?

Should we try mapping something at the magic address (without MAP_FIXED)
and see if we get back a different address?  Something in the auxiliary
vector would work for us, too, but nothing seems to exists there
unfortunately.

Thanks,
Florian
