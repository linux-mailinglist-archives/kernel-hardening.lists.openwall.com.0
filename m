Return-Path: <kernel-hardening-return-16659-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 4AA297BCC6
	for <lists+kernel-hardening@lfdr.de>; Wed, 31 Jul 2019 11:18:38 +0200 (CEST)
Received: (qmail 3349 invoked by uid 550); 31 Jul 2019 09:18:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3292 invoked from network); 31 Jul 2019 09:18:32 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1564564700;
	bh=ktGwNt+CwJ8vHJa23N3cYQHsAYq7kHsNQNIt7YKx9UU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HS6FKyjKAnyLX5vcOGCrG3zIXdnLIR4ccNtYPsDX/imntp93Z+9JRTwnpwFNvvB4Q
	 C04EpuzuqiX2//AqoWS9WS5EeEyaxLuWRPuUlwrhp8VTysIrnggwZwgB6nKtrD84Ty
	 Za1BaZU48wfRN+Oshb5pkF2APYb07l3OdmwpqwlE=
Date: Wed, 31 Jul 2019 11:18:18 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Rick Mark <rickmark@outlook.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Subject: Re: Hello Kernel Hardening
Message-ID: <20190731091818.GB29294@kroah.com>
References: <BYAPR07MB5782E8E1F2105AD154035E10DADF0@BYAPR07MB5782.namprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR07MB5782E8E1F2105AD154035E10DADF0@BYAPR07MB5782.namprd07.prod.outlook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)

On Wed, Jul 31, 2019 at 06:52:04AM +0000, Rick Mark wrote:
> Per the instructions in the get involved I'm here saying hello.
> 
> My name is Rick Mark, currently a security engineer at Dropbox in SF.
> 
> I've been toying around with various things I've found in the wild
> over the years and recently put together this CC Attribution paper
> 'Security Critical Kernel Object Confidentiality and Integrity'
> (https://dbx.link/sckoci).

Link needs permissions to view it :(

thanks,

greg k-h
