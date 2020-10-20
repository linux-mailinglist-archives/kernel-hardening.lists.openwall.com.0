Return-Path: <kernel-hardening-return-20112-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id C5051284D81
	for <lists+kernel-hardening@lfdr.de>; Tue,  6 Oct 2020 16:21:51 +0200 (CEST)
Received: (qmail 11717 invoked by uid 550); 6 Oct 2020 14:21:45 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 11592 invoked from network); 6 Oct 2020 14:21:31 -0000
Date: Tue, 6 Oct 2020 16:21:27 +0200
From: Solar Designer <solar@openwall.com>
To: Kees Cook <keescook@chromium.org>
Cc: Jann Horn <jannh@google.com>, "Theodore Y. Ts'o" <tytso@mit.edu>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-hardening@vger.kernel.org
Subject: Re: Linux-specific kernel hardening
Message-ID: <20201006142127.GA10613@openwall.com>
References: <202009281907.946FBE7B@keescook> <20200929192517.GA2718@openwall.com> <202009291558.04F4D35@keescook> <20200930090232.GA5067@openwall.com> <20201005141456.GA6528@openwall.com> <20201005160255.GA4540@mit.edu> <20201005164818.GA6878@openwall.com> <CAG48ez0MWfA8zPxh5s5i2w9W7F+MxfjMXf6ryvfTqooomg1HUQ@mail.gmail.com> <202010051538.55725193C7@keescook>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202010051538.55725193C7@keescook>
User-Agent: Mutt/1.4.2.3i

On Mon, Oct 05, 2020 at 03:39:26PM -0700, Kees Cook wrote:
> On Tue, Oct 06, 2020 at 12:26:50AM +0200, Jann Horn wrote:
> > On Mon, Oct 5, 2020 at 6:48 PM Solar Designer <solar@openwall.com> wrote:
> > > If 100% of the topics on linux-hardening are supposed to be a subset of
> > > what was on kernel-hardening, I think it'd be OK for me to provide the
> > > subscriber list to a vger admin, who would subscribe those people to
> > > linux-hardening.
> > 
> > (if folks want to go that route, probably easier to subscribe the list
> > linux-hardening@ itself to kernel-hardening@ instead of syncing
> > subscriber lists?)
> 
> Yeah, that would make things a bit simpler. Solar, would you be willing
> to do that? (Then I can tweak the wiki instructions a bit more.)

Sure, I can do that.  Should I?

Per http://vger.kernel.org/vger-lists.html#linux-hardening there are
currently 39 subscribers on the new list.  I guess most of those are
also on kernel-hardening, and would start receiving two copies of
messages that are posted to kernel-hardening.  I guess they would then
need to unsubscribe from kernel-hardening if they want to see the
content of both lists, or to unsubscribe from linux-hardening if they
changed their mind and only want the content of kernel-hardening.  I
think this is still not too many people, so this is reasonable; if we
were to do it later, we'd inconvenience more people.

Alexander
