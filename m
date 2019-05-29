Return-Path: <kernel-hardening-return-16007-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 988242E6FD
	for <lists+kernel-hardening@lfdr.de>; Wed, 29 May 2019 23:03:33 +0200 (CEST)
Received: (qmail 32574 invoked by uid 550); 29 May 2019 21:03:21 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 32547 invoked from network); 29 May 2019 21:03:21 -0000
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAG48ez0R-R3Xs+3Xg9T9qcV3Xv6r4pnx1Z2y=Ltx7RGOayte_w@mail.gmail.com>
References: <CAG48ez0R-R3Xs+3Xg9T9qcV3Xv6r4pnx1Z2y=Ltx7RGOayte_w@mail.gmail.com> <20190528162603.GA24097@kroah.com> <155905930702.7587.7100265859075976147.stgit@warthog.procyon.org.uk> <155905931502.7587.11705449537368497489.stgit@warthog.procyon.org.uk> <4031.1559064620@warthog.procyon.org.uk> <20190528231218.GA28384@kroah.com> <31936.1559146000@warthog.procyon.org.uk>
To: Jann Horn <jannh@google.com>
Cc: dhowells@redhat.com, Greg KH <gregkh@linuxfoundation.org>,
    Al Viro <viro@zeniv.linux.org.uk>, raven@themaw.net,
    linux-fsdevel <linux-fsdevel@vger.kernel.org>,
    Linux API <linux-api@vger.kernel.org>, linux-block@vger.kernel.org,
    keyrings@vger.kernel.org,
    linux-security-module <linux-security-module@vger.kernel.org>,
    kernel list <linux-kernel@vger.kernel.org>,
    Kees Cook <keescook@chromium.org>,
    Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: [PATCH 1/7] General notification queue with user mmap()'able ring buffer
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <16192.1559163763.1@warthog.procyon.org.uk>
Date: Wed, 29 May 2019 22:02:43 +0100
Message-ID: <16193.1559163763@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Wed, 29 May 2019 21:03:04 +0000 (UTC)

Jann Horn <jannh@google.com> wrote:

> Does this mean that refcount_read() isn't sufficient for what you want
> to do with tracing (because for some reason you actually need to know
> the values atomically at the time of increment/decrement)?

Correct.  There's a gap and if an interrupt or something occurs, it's
sufficiently big for the refcount trace to go weird.

I've seen it in afs/rxrpc where the incoming network packets that are part of
the rxrpc call flow disrupt the refcounts noted in trace lines.

David
