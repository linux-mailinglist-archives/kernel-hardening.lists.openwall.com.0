Return-Path: <kernel-hardening-return-19984-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id BF531275F7D
	for <lists+kernel-hardening@lfdr.de>; Wed, 23 Sep 2020 20:11:22 +0200 (CEST)
Received: (qmail 5458 invoked by uid 550); 23 Sep 2020 18:11:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 5409 invoked from network); 23 Sep 2020 18:11:15 -0000
Date: Thu, 24 Sep 2020 04:10:44 +1000 (AEST)
From: James Morris <jmorris@namei.org>
To: Pavel Machek <pavel@ucw.cz>
cc: madvenka@linux.microsoft.com, kernel-hardening@lists.openwall.com,
        linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        oleg@redhat.com, x86@kernel.org, luto@kernel.org,
        David.Laight@ACULAB.COM, fweimer@redhat.com, mark.rutland@arm.com,
        mic@digikod.net
Subject: Re: [PATCH v2 0/4] [RFC] Implement Trampoline File Descriptor
In-Reply-To: <20200923081426.GA30279@amd>
Message-ID: <alpine.LRH.2.21.2009240409130.26225@namei.org>
References: <210d7cd762d5307c2aa1676705b392bd445f1baa> <20200922215326.4603-1-madvenka@linux.microsoft.com> <20200923081426.GA30279@amd>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Wed, 23 Sep 2020, Pavel Machek wrote:

> This is not first crazy patch from your company. Perhaps you should
> have a person with strong Unix/Linux experience performing "straight
> face test" on outgoing patches?

Just for the record: the author of the code has 30+ years experience in 
SunOS, Solaris, Unixware, Realtime, SVR4, and Linux.


-- 
James Morris
<jmorris@namei.org>

