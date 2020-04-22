Return-Path: <kernel-hardening-return-18611-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id C900D1B4FFF
	for <lists+kernel-hardening@lfdr.de>; Thu, 23 Apr 2020 00:18:01 +0200 (CEST)
Received: (qmail 1550 invoked by uid 550); 22 Apr 2020 22:17:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1521 invoked from network); 22 Apr 2020 22:17:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1587593862;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/cWGqNrwRUi86LXOam7nhjqgeV8uCuXewweugzrbGz8=;
	b=LSTEpZBeAIadbFWzI9rNJbDHLn0btciauA5oreAFIPc/Zekg11BqTnd7TbQ225RaoA1122
	XiEOqECpsi/PUAAEJxYBTcMHxtrtHGvsEbLvzOAlJhqrdNYFcMgL3MKtjWBvUf4zGOm+Jn
	OT4Q4iX5gWmkx6HwxDA/UH+O4KZ/zZQ=
X-MC-Unique: etYuuQxEORWvQuObNkoVTA-1
Date: Wed, 22 Apr 2020 17:17:32 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Kristen Carlson Accardi <kristen@linux.intel.com>
Cc: keescook@chromium.org, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, hpa@zytor.com, Peter Zijlstra <peterz@infradead.org>,
	arjan@linux.intel.com, x86@kernel.org, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com, rick.p.edgecomb@intel.com
Subject: Re: [PATCH 1/9] objtool: do not assume order of parent/child
 functions
Message-ID: <20200422221732.wmih73qrdh4fksog@treble>
References: <20200415210452.27436-1-kristen@linux.intel.com>
 <20200415210452.27436-2-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200415210452.27436-2-kristen@linux.intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12

On Wed, Apr 15, 2020 at 02:04:43PM -0700, Kristen Carlson Accardi wrote:
> If a .cold function is examined prior to it's parent, the link
> to the parent/child function can be overwritten when the parent
> is examined. Only update pfunc and cfunc if they were previously
> nil to prevent this from happening.
> 
> Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
> Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>

Hi Kristen,

I grabbed this one and it will be merged into the -tip tree soon.
Thanks!

-- 
Josh

