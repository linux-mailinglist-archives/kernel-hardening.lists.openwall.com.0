Return-Path: <kernel-hardening-return-19473-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id BD358230ED9
	for <lists+kernel-hardening@lfdr.de>; Tue, 28 Jul 2020 18:07:14 +0200 (CEST)
Received: (qmail 1966 invoked by uid 550); 28 Jul 2020 16:07:09 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1939 invoked from network); 28 Jul 2020 16:07:08 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1595952417;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=z+gquV6V93SZjNhpxmQp1P7xpjOdqg2rKp5124tI0vU=;
	b=VYlA/t8ATUl2/Bv+xtBHeDu/KBNcItxQ7WF4YHiVLsh8i7QYj08fKDXw5sTt05Bngf/OvU
	RVjo3R/K7tmv4/ucj51fzhPAbFLRyJ3mj596lDOZxdHDxa3aiKYGIcXd4fzc+hUpIKlJ2N
	nbZVU+M6XWz0+O65QE9mzuUGAZCnVmE=
X-MC-Unique: wqHAHkFqOp6s6jbiuk_hkA-1
Date: Tue, 28 Jul 2020 18:06:49 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc: kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v1 1/4] [RFC] fs/trampfd: Implement the trampoline file
 descriptor API
Message-ID: <20200728160649.GB9972@redhat.com>
References: <aefc85852ea518982e74b233e11e16d2e707bc32>
 <20200728131050.24443-1-madvenka@linux.microsoft.com>
 <20200728131050.24443-2-madvenka@linux.microsoft.com>
 <20200728145013.GA9972@redhat.com>
 <dc41589a-647a-ba59-5376-abbf5d07c6e7@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc41589a-647a-ba59-5376-abbf5d07c6e7@linux.microsoft.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22

On 07/28, Madhavan T. Venkataraman wrote:
>
> I guess since the symbol is not used by any modules, I don't need to
> export it.

Yes,

Oleg.

