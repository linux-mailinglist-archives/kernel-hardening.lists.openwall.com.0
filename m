Return-Path: <kernel-hardening-return-21618-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by mail.lfdr.de (Postfix) with SMTP id 7A54F67E269
	for <lists+kernel-hardening@lfdr.de>; Fri, 27 Jan 2023 11:58:41 +0100 (CET)
Received: (qmail 15859 invoked by uid 550); 27 Jan 2023 10:58:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 15827 invoked from network); 27 Jan 2023 10:58:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1674817100;
	bh=5yeFRjegMFjzUwQix33riQSeMG0naSPmYrlj8IGsT6A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ty/mQCdkfAbrJ6BjTVRqNpIspHZ9G5ptMGC15r09BTJZ9wIuuxRml/R3NfH++3Mt+
	 jdwcYyiaG9l1SlDC1Y7rt9x7nogWsu0YX5MYyI7TwhNY3si/fnNkXk61B5ML41U/Wf
	 m4MzY4SslhuZQAskqNbugyiIkhClTGIY3Vg77v+l1+Z62pukhhk2t6hlXCvgFNzbvJ
	 F2jzWysIlgtV0eiqXeNNPP2ctE5vTwRTIPfuKbBNmBRCL63bnyx6zX1wrmgs3Cm809
	 tU67SVpZZwIkrkz3TPkCSzmCzigaJ54MiZAW2H5TtXuuElHyR2N9PqvafoJiC9zTBV
	 ZEnbHTsDnVxog==
Date: Fri, 27 Jan 2023 11:58:15 +0100
From: Christian Brauner <brauner@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: Jann Horn <jannh@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH] fs: Use CHECK_DATA_CORRUPTION() when kernel bugs are
 detected
Message-ID: <20230127105815.adgqe2opfzruxk7e@wittgenstein>
References: <20230116191425.458864-1-jannh@google.com>
 <202301260835.61F1C2CA4D@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <202301260835.61F1C2CA4D@keescook>

On Thu, Jan 26, 2023 at 08:35:49AM -0800, Kees Cook wrote:
> On Mon, Jan 16, 2023 at 08:14:25PM +0100, Jann Horn wrote:
> > Currently, filp_close() and generic_shutdown_super() use printk() to log
> > messages when bugs are detected. This is problematic because infrastructure
> > like syzkaller has no idea that this message indicates a bug.
> > In addition, some people explicitly want their kernels to BUG() when kernel
> > data corruption has been detected (CONFIG_BUG_ON_DATA_CORRUPTION).
> > And finally, when generic_shutdown_super() detects remaining inodes on a
> > system without CONFIG_BUG_ON_DATA_CORRUPTION, it would be nice if later
> > accesses to a busy inode would at least crash somewhat cleanly rather than
> > walking through freed memory.
> > 
> > To address all three, use CHECK_DATA_CORRUPTION() when kernel bugs are
> > detected.
> 
> Seems reasonable to me. I'll carry this unless someone else speaks up.

I've already picked this into a branch with other fs changes for coming cycle.

Al, please tell me in case you end up picking this up and I'll drop it ofc.

Christian
