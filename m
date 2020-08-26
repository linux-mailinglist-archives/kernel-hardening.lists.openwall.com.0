Return-Path: <kernel-hardening-return-19669-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 8FB6F25387D
	for <lists+kernel-hardening@lfdr.de>; Wed, 26 Aug 2020 21:46:43 +0200 (CEST)
Received: (qmail 3647 invoked by uid 550); 26 Aug 2020 19:46:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3624 invoked from network); 26 Aug 2020 19:46:37 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lIC466wcHw5fR4eYEVc57sBZjLUX/gzzPPg8yLp1ZZU=;
        b=WFkrzFpr1SUiFaPbGhhpAKHAmVxv3wzkj4tDR+4PHOR9/MlIRPYJGnmI664QGeO/Cx
         jh56BsF4d4+yUYLb3tteEQtrETtrsW7Vukw+0hQQ46Y1kVm7YzGQ12QR8x1BVWPj5ZyL
         5rDrqojD9sPXkIKEP7O2wCAa1fCxfWjqV9Rc4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lIC466wcHw5fR4eYEVc57sBZjLUX/gzzPPg8yLp1ZZU=;
        b=dTr6iXNI3JPcV758i4zA+zN8I7UFM6wXwo7MzTxJzV2H4Fshdjd02Gu1cQlGc+UqAu
         8IMsKhhjRTrZv0llc4wGjoceO7Ga+FR7pSU4W8qfIURv6cbku8mA880ODh06z8wC/wpu
         Mq+Sjdh7+bnqgSq9xLIEHGFPL8ntTgCRBejzZJwmDy+fBq29lahwf3q6na79R5r+haxy
         adS3rBDTzriJKMZQkAeQ4v9mlnjHD0s6d1ji18PcdCk/9HKghy4CsUvVHtewpHpX9eH3
         0GyX6efKoSo3Ipk6jVqkluD9AWSwQ/YZdX1LqGlxhqhjeo9Ch9JXVMl+D/i6PoG3OjHX
         lA7w==
X-Gm-Message-State: AOAM533fbxibBXaFxkHYacZxT/kZwlNi2kXM3Z0b6ISUC++qkBecjPDg
	49dR2kFvN8W3uRs7a9pfyJLrtQ==
X-Google-Smtp-Source: ABdhPJzfdv5XUXwJl1UOhKF/pH+9I5ADCLKzvf0FKe3PbEuFazJPlW1HymFX95ObV8KRL+rwcPkouA==
X-Received: by 2002:a62:5212:: with SMTP id g18mr8576508pfb.8.1598471186120;
        Wed, 26 Aug 2020 12:46:26 -0700 (PDT)
Date: Wed, 26 Aug 2020 12:46:24 -0700
From: Kees Cook <keescook@chromium.org>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	Jann Horn <jannh@google.com>, Jeff Moyer <jmoyer@redhat.com>,
	linux-fsdevel@vger.kernel.org, Sargun Dhillon <sargun@sargun.me>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Stefan Hajnoczi <stefanha@redhat.com>, linux-kernel@vger.kernel.org,
	Aleksa Sarai <asarai@suse.de>, io-uring@vger.kernel.org
Subject: Re: [PATCH v4 2/3] io_uring: add IOURING_REGISTER_RESTRICTIONS opcode
Message-ID: <202008261245.245E36654@keescook>
References: <20200813153254.93731-1-sgarzare@redhat.com>
 <20200813153254.93731-3-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200813153254.93731-3-sgarzare@redhat.com>

On Thu, Aug 13, 2020 at 05:32:53PM +0200, Stefano Garzarella wrote:
> +/*
> + * io_uring_restriction->opcode values
> + */
> +enum {
> +	/* Allow an io_uring_register(2) opcode */
> +	IORING_RESTRICTION_REGISTER_OP,
> +
> +	/* Allow an sqe opcode */
> +	IORING_RESTRICTION_SQE_OP,
> +
> +	/* Allow sqe flags */
> +	IORING_RESTRICTION_SQE_FLAGS_ALLOWED,
> +
> +	/* Require sqe flags (these flags must be set on each submission) */
> +	IORING_RESTRICTION_SQE_FLAGS_REQUIRED,
> +
> +	IORING_RESTRICTION_LAST
> +};

Same thought on enum literals, but otherwise, looks good:

Reviewed-by: Kees Cook <keescook@chromium.org>


-- 
Kees Cook
