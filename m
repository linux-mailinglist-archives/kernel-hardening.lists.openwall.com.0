Return-Path: <kernel-hardening-return-19717-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 079C62594B6
	for <lists+kernel-hardening@lfdr.de>; Tue,  1 Sep 2020 17:42:41 +0200 (CEST)
Received: (qmail 1564 invoked by uid 550); 1 Sep 2020 15:42:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1541 invoked from network); 1 Sep 2020 15:42:34 -0000
Date: Tue, 1 Sep 2020 16:42:17 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
Cc: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, oleg@redhat.com,
	x86@kernel.org
Subject: Re: [PATCH v1 0/4] [RFC] Implement Trampoline File Descriptor
Message-ID: <20200901154217.GD95447@C02TD0UTHF1T.local>
References: <aefc85852ea518982e74b233e11e16d2e707bc32>
 <20200728131050.24443-1-madvenka@linux.microsoft.com>
 <20200731180955.GC67415@C02TD0UTHF1T.local>
 <6236adf7-4bed-534e-0956-fddab4fd96b6@linux.microsoft.com>
 <20200804143018.GB7440@C02TD0UTHF1T.local>
 <b3368692-afe6-89b5-d634-12f4f0a601f8@linux.microsoft.com>
 <20200812100650.GB28154@C02TD0UTHF1T.local>
 <41c4de64-68d0-6fcb-e5c3-63ebd459262e@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <41c4de64-68d0-6fcb-e5c3-63ebd459262e@digikod.net>

On Wed, Aug 19, 2020 at 08:53:42PM +0200, Mickaël Salaün wrote:
> On 12/08/2020 12:06, Mark Rutland wrote:
> > Contemporary W^X means that a given virtual alias cannot be writeable
> > and executeable simultaneously, permitting (a) and (b). If you read the
> > references on the Wikipedia page for W^X you'll see the OpenBSD 3.3
> > release notes and related presentation make this clear, and further they
> > expect (b) to occur with JITS flipping W/X with mprotect().
> 
> W^X (with "permanent" mprotect restrictions [1]) goes back to 2000 with
> PaX [2] (which predates partial OpenBSD implementation from 2003).
> 
> [1] https://pax.grsecurity.net/docs/mprotect.txt
> [2] https://undeadly.org/cgi?action=article;sid=20030417082752

Thanks for the pointers!

Mark.
