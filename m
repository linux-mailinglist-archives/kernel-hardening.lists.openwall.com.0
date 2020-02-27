Return-Path: <kernel-hardening-return-17969-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 70D42170E91
	for <lists+kernel-hardening@lfdr.de>; Thu, 27 Feb 2020 03:43:24 +0100 (CET)
Received: (qmail 20208 invoked by uid 550); 27 Feb 2020 02:43:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 20188 invoked from network); 27 Feb 2020 02:43:18 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1582771386;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jIzd+MZl1AvxRGDWe7UFrELxx/1RAKgj7dqtWoVC2q8=;
	b=Mgi9fTI/uvphhap4G471Bu3u/RNoMiheHdubY/vM9O0PpB30YcAD8pL+76ssFtTaUZR6kz
	hc3xZlWRFbAOm9fdxfkd+2GXh/fPgQFnULZ8Ekjv5w10Pb0a+eQZR6ImH2DthwWtrUespp
	AvuYrgJZa6MyhQ1ARb73oie+iza8ax0=
X-MC-Unique: OiqDfqPvP-WvbDkjQd8jmA-1
Date: Thu, 27 Feb 2020 10:42:53 +0800
From: Baoquan He <bhe@redhat.com>
To: Kees Cook <keescook@chromium.org>,
	Kristen Carlson Accardi <kristen@linux.intel.com>,
	dyoung@redhat.com
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
	arjan@linux.intel.com, rick.p.edgecombe@intel.com, x86@kernel.org,
	linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
	kexec@lists.infradead.org
Subject: Re: [RFC PATCH 09/11] kallsyms: hide layout and expose seed
Message-ID: <20200227024253.GA5707@MiWiFi-R3L-srv>
References: <20200205223950.1212394-1-kristen@linux.intel.com>
 <20200205223950.1212394-10-kristen@linux.intel.com>
 <202002060428.08B14F1@keescook>
 <a915e1eb131551aa766fde4c14de5a3e825af667.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a915e1eb131551aa766fde4c14de5a3e825af667.camel@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12

On 02/06/20 at 09:51am, Kristen Carlson Accardi wrote:
> On Thu, 2020-02-06 at 04:32 -0800, Kees Cook wrote:

> > In the past, making kallsyms entirely unreadable seemed to break
> > weird
> > stuff in userspace. How about having an alternative view that just
> > contains a alphanumeric sort of the symbol names (and they will
> > continue
> > to have zeroed addresses for unprivileged users)?
> > 
> > Or perhaps we wait to hear about this causing a problem, and deal
> > with
> > it then? :)
> > 
> 
> Yeah - I don't know what people want here. Clearly, we can't leave
> kallsyms the way it is. Removing it entirely is a pretty fast way to
> figure out how people use it though :).

Kexec-tools and makedumpfile are the users of /proc/kallsyms currently. 
We use kallsyms to get page_offset_base and _stext.

