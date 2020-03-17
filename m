Return-Path: <kernel-hardening-return-18146-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id AC6DC18915C
	for <lists+kernel-hardening@lfdr.de>; Tue, 17 Mar 2020 23:27:42 +0100 (CET)
Received: (qmail 13574 invoked by uid 550); 17 Mar 2020 22:27:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 13542 invoked from network); 17 Mar 2020 22:27:35 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1584484043;
	bh=WSXaZv4sBHYHlVj8zTa5shxvXfP6CX+7XiIDcketcUo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=2CQnmxeeLHsCdzqgtAmSYikJb9AbHGeb/jxXXqzH4ZEKKagjBEK/gOiAdnVkUX/Pu
	 7fV8BVw9jfyrQVgpnp2pEZqG9Z5RJbm3HNoA5K/FJW3KwxhlmslXzqu3Cx33OpW0rA
	 NElFjXRUwEy7KPEtGrYSnZxe6FglFSIdfyAQl+Ao=
Date: Tue, 17 Mar 2020 22:27:18 +0000
From: Will Deacon <will@kernel.org>
To: Jann Horn <jannh@google.com>
Cc: Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	kernel list <linux-kernel@vger.kernel.org>,
	Elena Reshetova <elena.reshetova@intel.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Hanjun Guo <guohanjun@huawei.com>,
	Jan Glauber <jglauber@marvell.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: [PATCH v2] lib/refcount: Document interaction with PID_MAX_LIMIT
Message-ID: <20200317222717.GF20788@willie-the-truck>
References: <20200303105427.260620-1-jannh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303105427.260620-1-jannh@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Mar 03, 2020 at 11:54:27AM +0100, Jann Horn wrote:
> Document the circumstances under which refcount_t's saturation mechanism
> works deterministically.
> 
> Signed-off-by: Jann Horn <jannh@google.com>
> ---
> 
> Notes:
>     v2:
>      - write down the math (Kees)
> 
>  include/linux/refcount.h | 23 ++++++++++++++++++-----
>  1 file changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/refcount.h b/include/linux/refcount.h
> index 0ac50cf62d062..0e3ee25eb156a 100644
> --- a/include/linux/refcount.h
> +++ b/include/linux/refcount.h
> @@ -38,11 +38,24 @@
>   * atomic operations, then the count will continue to edge closer to 0. If it
>   * reaches a value of 1 before /any/ of the threads reset it to the saturated
>   * value, then a concurrent refcount_dec_and_test() may erroneously free the
> - * underlying object. Given the precise timing details involved with the
> - * round-robin scheduling of each thread manipulating the refcount and the need
> - * to hit the race multiple times in succession, there doesn't appear to be a
> - * practical avenue of attack even if using refcount_add() operations with
> - * larger increments.
> + * underlying object.
> + * Linux limits the maximum number of tasks to PID_MAX_LIMIT, which is currently
> + * 0x400000 (and can't easily be raised in the future beyond FUTEX_TID_MASK).
> + * With the current PID limit, if no batched refcounting operations are used and
> + * the attacker can't repeatedly trigger kernel oopses in the middle of refcount
> + * operations, this makes it impossible for a saturated refcount to leave the
> + * saturation range, even if it is possible for multiple uses of the same
> + * refcount to nest in the context of a single task:
> + *
> + *     (UINT_MAX+1-REFCOUNT_SATURATED) / PID_MAX_LIMIT =
> + *     0x40000000 / 0x400000 = 0x100 = 256
> + *
> + * If hundreds of references are added/removed with a single refcounting
> + * operation, it may potentially be possible to leave the saturation range; but
> + * given the precise timing details involved with the round-robin scheduling of
> + * each thread manipulating the refcount and the need to hit the race multiple
> + * times in succession, there doesn't appear to be a practical avenue of attack
> + * even if using refcount_add() operations with larger increments.
>   *
>   * Memory ordering
>   * ===============
> 
> base-commit: 98d54f81e36ba3bf92172791eba5ca5bd813989b

Acked-by: Will Deacon <will@kernel.org>

Peter -- would you be able to take this through -tip, please?

Will
