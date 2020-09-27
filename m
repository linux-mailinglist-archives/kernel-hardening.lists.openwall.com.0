Return-Path: <kernel-hardening-return-20014-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 55AB127A253
	for <lists+kernel-hardening@lfdr.de>; Sun, 27 Sep 2020 20:25:46 +0200 (CEST)
Received: (qmail 24270 invoked by uid 550); 27 Sep 2020 18:25:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 24223 invoked from network); 27 Sep 2020 18:25:39 -0000
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8DA9420B7178
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1601231127;
	bh=NZJ93BWQdNdtnup4P68DjyJ2f4J6Q7RZaGDO8Xn2+3I=;
	h=Subject:From:To:Cc:References:Date:In-Reply-To:From;
	b=DpS0rOFX9c2GsPc1PEXzlWFOu+1KBs4zeUS1aH7fAkW2jf062lNBLwoWEkVn5uF63
	 pmFvWTR0KD5a1Tp6TJYLSMtw+URTbe8DcbBwZSJ/h6Z6gwbOHMPn/CL/wf/tULcEjl
	 e/MX1aKmZY/E641oQi2DMMrk1AYIHKfwxVOEDCe0=
Subject: Re: [PATCH v2 0/4] [RFC] Implement Trampoline File Descriptor
From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
To: Florian Weimer <fw@deneb.enyo.de>
Cc: Arvind Sankar <nivedita@alum.mit.edu>,
 kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, oleg@redhat.com, x86@kernel.org,
 libffi-discuss@sourceware.org, luto@kernel.org, David.Laight@ACULAB.COM,
 mark.rutland@arm.com, mic@digikod.net, pavel@ucw.cz
References: <20200916150826.5990-1-madvenka@linux.microsoft.com>
 <87v9gdz01h.fsf@mid.deneb.enyo.de>
 <96ea02df-4154-5888-1669-f3beeed60b33@linux.microsoft.com>
 <20200923014616.GA1216401@rani.riverdale.lan>
 <20200923091125.GB1240819@rani.riverdale.lan>
 <a742b9cd-4ffb-60e0-63b8-894800009700@linux.microsoft.com>
 <20200923195147.GA1358246@rani.riverdale.lan>
 <2ed2becd-49b5-7e76-9836-6a43707f539f@linux.microsoft.com>
 <87o8luvqw9.fsf@mid.deneb.enyo.de>
 <3fe7ba84-b719-b44d-da87-6eda60543118@linux.microsoft.com>
Message-ID: <fdfe73d3-d735-4bdc-4790-7feb7fecece5@linux.microsoft.com>
Date: Sun, 27 Sep 2020 13:25:25 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <3fe7ba84-b719-b44d-da87-6eda60543118@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

Before I implement the user land solution recommended by reviewers, I just want
an opinion on where the code should reside.

I am thinking glibc. The other choice would be a separate library, say, libtramp.
What do you recommend?

Madhavan
