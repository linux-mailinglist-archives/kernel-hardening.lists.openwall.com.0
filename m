Return-Path: <kernel-hardening-return-21118-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id E7B9C352076
	for <lists+kernel-hardening@lfdr.de>; Thu,  1 Apr 2021 22:14:29 +0200 (CEST)
Received: (qmail 30265 invoked by uid 550); 1 Apr 2021 20:14:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 30242 invoked from network); 1 Apr 2021 20:14:23 -0000
Date: Thu, 1 Apr 2021 16:13:21 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Roy Yang <royyang@google.com>, keescook@chromium.org,
        akpm@linux-foundation.org, alex.popov@linux.com,
        ard.biesheuvel@linaro.org, catalin.marinas@arm.com, corbet@lwn.net,
        david@redhat.com, elena.reshetova@intel.com, glider@google.com,
        jannh@google.com, kernel-hardening@lists.openwall.com,
        linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, luto@kernel.org,
        mark.rutland@arm.com, peterz@infradead.org, rdunlap@infradead.org,
        rppt@linux.ibm.com, tglx@linutronix.de, vbabka@suse.cz,
        will@kernel.org, x86@kernel.org
Subject: Re: [PATCH] Where we are for this patch?
Message-ID: <YGYpYUqIf9rdJqRi@mit.edu>
References: <20210330205750.428816-1-keescook@chromium.org>
 <20210401191744.1685896-1-royyang@google.com>
 <YGYjjpoj1uMn1VEd@zeniv-ca.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YGYjjpoj1uMn1VEd@zeniv-ca.linux.org.uk>

On Thu, Apr 01, 2021 at 07:48:30PM +0000, Al Viro wrote:
> On Thu, Apr 01, 2021 at 12:17:44PM -0700, Roy Yang wrote:
> > Both Android and Chrome OS really want this feature; For Container-Optimized OS, we have customers
> > interested in the defense too.
> > 
> > Thank you very much.
> > 
> > Change-Id: I1eb1b726007aa8f9c374b934cc1c690fb4924aa3
> 
> 	You forgot to tell what patch you are refering to.  Your
> Change-Id (whatever the hell that is) doesn't help at all.  Don't
> assume that keys in your internal database make sense for the
> rest of the world, especially when they appear to contain a hash
> of something...

The Change-Id fails to have any direct search hits at lore.kernel.org.
However, it turn up Roy's original patch, and clicking on the
message-Id in the "In-Reply-Field", it apperas Roy was replying to
this message:

https://lore.kernel.org/lkml/20210330205750.428816-1-keescook@chromium.org/

which is the head of this patch series:

Subject: [PATCH v8 0/6] Optionally randomize kernel stack offset each syscall

That being said, it would have been better if the original subject
line had been preserved, and it's yet another example of how the
lore.kernel.org URL is infinitely better than the Change-Id.  :-)

		       		  	      - Ted
