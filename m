Return-Path: <kernel-hardening-return-18747-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 09FBB1CD1FF
	for <lists+kernel-hardening@lfdr.de>; Mon, 11 May 2020 08:43:18 +0200 (CEST)
Received: (qmail 10067 invoked by uid 550); 11 May 2020 06:43:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 10029 invoked from network); 11 May 2020 06:43:11 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1589179378;
	bh=FMjwOMjxylBJC2IsVL3PthhGR/mOxL+MDe5hmFkgbx4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=xQUzFmdm0JG1IW5ml7/QJnxZ+1n/TW5wR3rHT36+kd5vErvEfwNmXrtZOUxf23ZCw
	 1k+STYSs/a1W1fC+RoI7YPd2M4ZMXIydiVPR7ipEg0llftfiz4VsGLIOX4euQfyw6Y
	 IK2vabJVeKmkA2zRRheuoVMS2xudb5wGqhzozjUo=
Date: Mon, 11 May 2020 08:42:56 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: wzt wzt <wzt.wzt@gmail.com>
Cc: kernel-hardening@lists.openwall.com
Subject: Re: Open source a new kernel harden project
Message-ID: <20200511064256.GB1279905@kroah.com>
References: <CAEQi4beJgmNfZ0NsWSHCok9-5H_qLze_sFJ_G=1j8CBz9qi2rQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEQi4beJgmNfZ0NsWSHCok9-5H_qLze_sFJ_G=1j8CBz9qi2rQ@mail.gmail.com>

On Sun, May 10, 2020 at 10:16:25AM +0800, wzt wzt wrote:
> hi:
>     This is a new kernel harden project called hksp(huawei kernel self
> protection),  hope some of the mitigation ideas may help you, thanks.
>     patch: https://github.com/cloudsec/hksp

<snip>

Interesting.

Are you all going to split this up into submittable pieces so that they
can get proper review and merged upstream?  In the format it currently
is in, it's not going to really go anywhere.

thanks,

greg k-h
