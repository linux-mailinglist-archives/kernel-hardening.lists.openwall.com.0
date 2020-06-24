Return-Path: <kernel-hardening-return-19081-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id DCB14206A69
	for <lists+kernel-hardening@lfdr.de>; Wed, 24 Jun 2020 05:08:44 +0200 (CEST)
Received: (qmail 30298 invoked by uid 550); 24 Jun 2020 03:08:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 30278 invoked from network); 24 Jun 2020 03:08:37 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1592968106;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZsWu8ZUl1jE3k6DJkKHds2eB9NM/YRkkX3/ygvqR5AE=;
	b=PU7bqkTKTBeVnGVSy2I0PYfBIrSN/3OSFoQtrJbX/B0GijcP0sHeaqYoEVm9DlNDOlJnJ5
	BG0XITGxFK/hJWxvA9kUgaJsMwKTc3KDqc6St7kklIskAZCq6/sJyZNIMZeFbVGHUitIZh
	yFlBnNBJZSGO8xpPw3mYSeq+OGMDEWg=
X-MC-Unique: gIuNpAsLNoSQXCKeSxl5rQ-1
Date: Tue, 23 Jun 2020 22:08:18 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Kristen Carlson Accardi <kristen@linux.intel.com>
Cc: keescook@chromium.org, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, Peter Zijlstra <peterz@infradead.org>,
	arjan@linux.intel.com, x86@kernel.org, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com, rick.p.edgecombe@intel.com
Subject: Re: [PATCH v3 01/10] objtool: Do not assume order of parent/child
 functions
Message-ID: <20200624030818.bvv3kld63sguqxxm@treble>
References: <20200623172327.5701-1-kristen@linux.intel.com>
 <20200623172327.5701-2-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200623172327.5701-2-kristen@linux.intel.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23

On Tue, Jun 23, 2020 at 10:23:18AM -0700, Kristen Carlson Accardi wrote:
> If a .cold function is examined prior to it's parent, the link
> to the parent/child function can be overwritten when the parent
> is examined. Only update pfunc and cfunc if they were previously
> nil to prevent this from happening.
> 
> Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
> Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>

FYI, this patch is now in the tip tree.

-- 
Josh

