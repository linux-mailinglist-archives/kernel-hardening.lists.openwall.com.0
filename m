Return-Path: <kernel-hardening-return-16683-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 2B6217D50E
	for <lists+kernel-hardening@lfdr.de>; Thu,  1 Aug 2019 07:54:35 +0200 (CEST)
Received: (qmail 14266 invoked by uid 550); 1 Aug 2019 05:54:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 14231 invoked from network); 1 Aug 2019 05:54:28 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1564638856;
	bh=vPTm0+7/hJa5qvqjNs2fHzMIJZdDsPyySouLphJObn8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Fq+zeya4CNUjM3Gmbxdia375Y1Bt7/nmJsV425xelOsoXWJ6pZfHWFI6unosdVn8U
	 rLqOMFxsz44WOhVYCmdbhm1hetOn5Pn+nOGz/Offl1svoPLB/MFIsk7b4zXJQ9StIF
	 KF0OHqko2agV1waWYFQJ51pwE1NkclPnG2iWkizY=
Date: Thu, 1 Aug 2019 07:54:13 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Rick Mark <rickmark@outlook.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Subject: Re: Hello Kernel Hardening
Message-ID: <20190801055413.GA24062@kroah.com>
References: <20190731091818.GB29294@kroah.com>
 <BYAPR07MB5782A0925C97FBCB172BD3C0DADF0@BYAPR07MB5782.namprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BYAPR07MB5782A0925C97FBCB172BD3C0DADF0@BYAPR07MB5782.namprd07.prod.outlook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)

On Wed, Jul 31, 2019 at 08:33:59PM +0000, Rick Mark wrote:
> Sorry, didn’t realize the Dropbox link shortener required login.  Full link:
> 
> 
> https://paper.dropbox.com/doc/Security-Critical-Kernel-Object-Confidentiality-and-Integrity-akFs9yNQ8YxLKP3BEaHZ8

That works better, thanks!

As always, why not knock up a working prototype of your idea first and
post it?  That's how we work with kernel development.  Lots of people
have random ideas, but to see if they actually work you need a working
patch.

good luck!

greg k-h
