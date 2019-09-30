Return-Path: <kernel-hardening-return-16968-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id A3457C226C
	for <lists+kernel-hardening@lfdr.de>; Mon, 30 Sep 2019 15:50:37 +0200 (CEST)
Received: (qmail 11811 invoked by uid 550); 30 Sep 2019 13:50:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 11788 invoked from network); 30 Sep 2019 13:50:29 -0000
From: Steve Grubb <sgrubb@redhat.com>
To: Paul Moore <paul@paul-moore.com>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, =?ISO-8859-1?Q?J=E9r=E9mie?= Galarneau <jeremie.galarneau@efficios.com>, s.mesoraca16@gmail.com, viro@zeniv.linux.org.uk, dan.carpenter@oracle.com, akpm@linux-foundation.org, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, kernel-hardening@lists.openwall.com, linux-audit@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] audit: Report suspicious O_CREAT usage
Date: Mon, 30 Sep 2019 09:50:00 -0400
Message-ID: <2065829.xbNJnTdZ4q@x2>
Organization: Red Hat
In-Reply-To: <CAHC9VhRNmWw1__-haD1ZEekADTho3EJyXQMd6ETpOv4c8Qn9nw@mail.gmail.com>
References: <201909251348.A1542A52@keescook> <CAHC9VhRNmWw1__-haD1ZEekADTho3EJyXQMd6ETpOv4c8Qn9nw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Mon, 30 Sep 2019 13:50:17 +0000 (UTC)

On Thursday, September 26, 2019 11:31:32 AM EDT Paul Moore wrote:
> On Wed, Sep 25, 2019 at 5:02 PM Kees Cook <keescook@chromium.org> wrote:
> > This renames the very specific audit_log_link_denied() to
> > audit_log_path_denied() and adds the AUDIT_* type as an argument. This
> > allows for the creation of the new AUDIT_ANOM_CREAT that can be used to
> > report the fifo/regular file creation restrictions that were introduced
> > in commit 30aba6656f61 ("namei: allow restricted O_CREAT of FIFOs and
> > regular files"). Without this change, discovering that the restriction
> > is enabled can be very challenging:
> > https://lore.kernel.org/lkml/CA+jJMxvkqjXHy3DnV5MVhFTL2RUhg0WQ-XVFW3ngD=
QO
> > dkFq0PA@mail.gmail.com
> >=20
> > Reported-by: J=E9r=E9mie Galarneau <jeremie.galarneau@efficios.com>
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > ---
> > This is not a complete fix because reporting was broken in commit
> > 15564ff0a16e ("audit: make ANOM_LINK obey audit_enabled and
> > audit_dummy_context")
> > which specifically goes against the intention of these records: they
> > should _always_ be reported. If auditing isn't enabled, they should be
> > ratelimited.
> >=20
> > Instead of using audit, should this just go back to using
> > pr_ratelimited()?
>=20
> I'm going to ignore the rename and other aspects of this patch for the
> moment so we can focus on the topic of if/when/how these records
> should be emitted by the kernel.
>=20
> Unfortunately, people tend to get very upset if audit emits *any*
> records when they haven't explicitly enabled audit, the significance
> of the record doesn't seem to matter, which is why you see patches
> like 15564ff0a16e ("audit: make ANOM_LINK obey audit_enabled and
> audit_dummy_context").  We could consider converting some records to
> printk()s, rate-limited or not, but we need to balance this with the
> various security certifications which audit was created to satisfy.
> In some cases a printk() isn't sufficient.
>=20
> Steve is probably the only one who really keeps track of the various
> auditing requirements of the different security certifications; what
> say you Steve on this issue with ANOM_CREAT records?

Common Criteria and other security standards I track do not call out for=20
anomoly detection. So, there are no requirements on this. That said, we do=
=20
have other anomaly detections because they give early warning that somethin=
g=20
strange is happening. I think adding this event is a nice improvement as lo=
ng=20
as it obeys audit_enabled before emitting an event - for example, look at t=
he=20
AUDIT_ANOM_ABEND event.

=2DSteve


