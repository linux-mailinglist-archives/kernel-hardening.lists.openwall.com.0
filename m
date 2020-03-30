Return-Path: <kernel-hardening-return-18292-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id BD70A19768E
	for <lists+kernel-hardening@lfdr.de>; Mon, 30 Mar 2020 10:35:13 +0200 (CEST)
Received: (qmail 22488 invoked by uid 550); 30 Mar 2020 08:35:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 22468 invoked from network); 30 Mar 2020 08:35:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1585557294;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VI4VJLvwA2Wnz1xcO7Y+Io0RjGUfdGgCzJ2iSp2r2DU=;
	b=UVTYvaIbt2iDpPLSd2wUCrP3FiEX6kqqmi4YuSkKZ9ayKSRgPjmzdVKZ0kypiA8IPvwi81
	SBL/vN+8G4hMRG8epabS/KiZLsuYA4RRYcV4nYurWr5AHRk3/cpbuQco0h+SZQ+KfChiyd
	hwbZ/k5aB9wfJnZTAFxBBWtTSp1cQX0=
X-MC-Unique: VzhFc2_pNWWc7DodrKjNHA-1
Date: Mon, 30 Mar 2020 10:34:46 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: Adam Zabrocki <pi3@pi3.com.pl>, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com, Jann Horn <jannh@google.com>,
	Andy Lutomirski <luto@amacapital.net>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Bernd Edlinger <bernd.edlinger@hotmail.de>
Subject: Re: Curiosity around 'exec_id' and some problems associated with it
Message-ID: <20200330083446.GA13522@redhat.com>
References: <20200324215049.GA3710@pi3.com.pl>
 <202003291528.730A329@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202003291528.730A329@keescook>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22

On 03/29, Kees Cook wrote:
>
> On Tue, Mar 24, 2020 at 10:50:49PM +0100, Adam Zabrocki wrote:
> >
> > In short, if you hold the file descriptor open over an execve() (e.g. share it
> > with child) the old VM is preserved (refcounted) and might be never released.
> > Essentially, mother process' VM will be still in memory (and pointer to it is
> > valid) even if the mother process passed an execve().

This was true after e268337dfe26dfc7efd422a804dbb27977a3cccc, but please see
6d08f2c7139790c ("proc: make sure mem_open() doesn't pin the target's memory"),
iir it was merged soon after the 1st commit.

Oleg.

