Return-Path: <kernel-hardening-return-18862-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 4894C1DF522
	for <lists+kernel-hardening@lfdr.de>; Sat, 23 May 2020 08:10:56 +0200 (CEST)
Received: (qmail 7744 invoked by uid 550); 23 May 2020 06:10:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 7678 invoked from network); 23 May 2020 06:10:48 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1590214235;
	bh=0ftU1TTGfhFEpNW3NsbgYUbiFGGQHnZ3H3HOeSMeYD4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LITQkm19MZP146obm5P6vkC9xld35coDBA1g8vKO6/E+elDtZwY3jC4Hmew8a+eAP
	 oWyKx01bUx/e+iFq8Zmsx59bpMeroPipa4jiZoms+az3hHYq0YQQ88KQoUKyT6jNak
	 UH+SIwYpV+e+o83w34Hi8YuKyAC4XOPoCHF4FBiM=
Date: Sat, 23 May 2020 08:10:33 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Oscar Carter <oscar.carter@gmx.com>
Cc: stable <stable@vger.kernel.org>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Kees Cook <keescook@chromium.org>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Clemens Ladisch <clemens@ladisch.de>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
	kernel-hardening@lists.openwall.com,
	linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
	"Lev R . Oshvang ." <levonshe@gmail.com>
Subject: Re: [PATCH v2] firewire: Remove function callback casts
Message-ID: <20200523061033.GB3131938@kroah.com>
References: <20200519173425.4724-1-oscar.carter@gmx.com>
 <20200520061624.GA25690@workstation>
 <20200522174308.GB3059@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522174308.GB3059@ubuntu>

On Fri, May 22, 2020 at 07:43:08PM +0200, Oscar Carter wrote:
> Hi,
> 
> On Wed, May 20, 2020 at 03:16:24PM +0900, Takashi Sakamoto wrote:
> > Hi,
> >
> > I'm an author of ALSA firewire stack and thanks for the patch. I agree with
> > your intention to remove the cast of function callback toward CFI build.
> >
> > Practically, the isochronous context with FW_ISO_CONTEXT_RECEIVE_MULTICHANNEL
> > is never used by in-kernel drivers. Here, I propose to leave current
> > kernel API (fw_iso_context_create() with fw_iso_callback_t) as is.

If it's not used by anyone, why is it still there?  Can't we just delete
it?

thanks,

greg k-h
