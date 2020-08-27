Return-Path: <kernel-hardening-return-19694-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 584B7254645
	for <lists+kernel-hardening@lfdr.de>; Thu, 27 Aug 2020 15:50:05 +0200 (CEST)
Received: (qmail 31885 invoked by uid 550); 27 Aug 2020 13:49:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 31863 invoked from network); 27 Aug 2020 13:49:59 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ummG6Am4WVVHwG6OsEcF+5DXkgqqBrieiDmLqcZ52gg=;
        b=i2xtwAqsurDUjdtcPOaRrUkN3kpRZdtKTDcjz9HwCGEOxQ6uuUwwioX2ctbvc+wVAg
         +yIMBIVx4k5ydmaIA9+tRqrgESalSpR4HUJeavh/6+Z6tCm5LqgyImSd2vkjqiCjv0i/
         +6uLeOZI/DQgZjzXsYQeAHPmy35xX0EdHohzYOUyUox6E65KaArNi4HMiwvJ4k44Z61m
         1jj6+YKH+IbuKTnNTTYDGnWG5gtcgWxE/NmKF5V2XVaOu+5mig9Gz8SswY2+rgZCbn2D
         J4sE12JGv+dI7ZhKQKveG/+f0eQ5+zgP+N7m8entyPNUh5ztEe9hGXqr6UnmXdFWHAaO
         8A3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ummG6Am4WVVHwG6OsEcF+5DXkgqqBrieiDmLqcZ52gg=;
        b=mJYJWi9t/2x23IOITa/99nOLC9SLUBn4OQ2WIfZXTHu0voYKe97bzssVsqqhAw9Jmx
         TfQm5LPDD/CrUIiqzFVfELV4QCZ4w/2pUdr+M3HjrTIY+i4ecLg0VmLekDlK4djmLOcj
         vr3ZgBOIcn7bAMRVli72UZdx844DCT8pOmarKigz1MBRxeaOyOW5xeWe5HovH/JSuYpM
         ESMkPZNCh0IJsBuOaMenCHK7GukkUK1lMUZfiwHSJjLwDHyUafFu29HUvHDB/9N6N0Nc
         EagVV503zl5ZxdOsPcaGu84m/Bo9cpzLC5YF0v840u+YNKtWHfOKaBIHEN5pcfh+4shS
         HqiQ==
X-Gm-Message-State: AOAM5335hJk88iGmCt8mOQlAraItQrcx7I04uleEIB9Ay94xUQR4H08M
	H/wozjwzRBmcZNx3/KBv3wDoPg==
X-Google-Smtp-Source: ABdhPJxg8EFdtE5lch9P7WZZq4szMfYAPC4FnMVG1t1FuT14x/ja8mX6J3/sRpVLkRSFUHuqrwmpSg==
X-Received: by 2002:a92:1b84:: with SMTP id f4mr17224386ill.180.1598536187325;
        Thu, 27 Aug 2020 06:49:47 -0700 (PDT)
Subject: Re: [PATCH v5 2/3] io_uring: add IOURING_REGISTER_RESTRICTIONS opcode
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: Aleksa Sarai <asarai@suse.de>,
 Kernel Hardening <kernel-hardening@lists.openwall.com>,
 Jann Horn <jannh@google.com>, io-uring@vger.kernel.org,
 Christian Brauner <christian.brauner@ubuntu.com>,
 linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 Stefan Hajnoczi <stefanha@redhat.com>, linux-kernel@vger.kernel.org,
 Sargun Dhillon <sargun@sargun.me>, Kees Cook <keescook@chromium.org>,
 Jeff Moyer <jmoyer@redhat.com>
References: <20200827134044.82821-1-sgarzare@redhat.com>
 <20200827134044.82821-3-sgarzare@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <206a32b6-ba20-fc91-1906-e6bf377798ae@kernel.dk>
Date: Thu, 27 Aug 2020 07:49:45 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200827134044.82821-3-sgarzare@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 8/27/20 7:40 AM, Stefano Garzarella wrote:
> @@ -6414,6 +6425,19 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
>  	if (unlikely(sqe_flags & ~SQE_VALID_FLAGS))
>  		return -EINVAL;
>  
> +	if (unlikely(ctx->restricted)) {
> +		if (!test_bit(req->opcode, ctx->restrictions.sqe_op))
> +			return -EACCES;
> +
> +		if ((sqe_flags & ctx->restrictions.sqe_flags_required) !=
> +		    ctx->restrictions.sqe_flags_required)
> +			return -EACCES;
> +
> +		if (sqe_flags & ~(ctx->restrictions.sqe_flags_allowed |
> +				  ctx->restrictions.sqe_flags_required))
> +			return -EACCES;
> +	}
> +

This should be a separate function, ala:

if (unlikely(ctx->restricted)) {
	ret = io_check_restriction(ctx, req);
	if (ret)
		return ret;
}

to move it totally out of the (very) hot path.

>  	if ((sqe_flags & IOSQE_BUFFER_SELECT) &&
>  	    !io_op_defs[req->opcode].buffer_select)
>  		return -EOPNOTSUPP;
> @@ -8714,6 +8738,71 @@ static int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id)
>  	return -EINVAL;
>  }
>  
> +static int io_register_restrictions(struct io_ring_ctx *ctx, void __user *arg,
> +				    unsigned int nr_args)
> +{
> +	struct io_uring_restriction *res;
> +	size_t size;
> +	int i, ret;
> +
> +	/* We allow only a single restrictions registration */
> +	if (ctx->restricted)
> +		return -EBUSY;
> +
> +	if (!arg || nr_args > IORING_MAX_RESTRICTIONS)
> +		return -EINVAL;
> +
> +	size = array_size(nr_args, sizeof(*res));
> +	if (size == SIZE_MAX)
> +		return -EOVERFLOW;
> +
> +	res = memdup_user(arg, size);
> +	if (IS_ERR(res))
> +		return PTR_ERR(res);
> +
> +	for (i = 0; i < nr_args; i++) {
> +		switch (res[i].opcode) {
> +		case IORING_RESTRICTION_REGISTER_OP:
> +			if (res[i].register_op >= IORING_REGISTER_LAST) {
> +				ret = -EINVAL;
> +				goto out;
> +			}
> +
> +			__set_bit(res[i].register_op,
> +				  ctx->restrictions.register_op);
> +			break;
> +		case IORING_RESTRICTION_SQE_OP:
> +			if (res[i].sqe_op >= IORING_OP_LAST) {
> +				ret = -EINVAL;
> +				goto out;
> +			}
> +
> +			__set_bit(res[i].sqe_op, ctx->restrictions.sqe_op);
> +			break;
> +		case IORING_RESTRICTION_SQE_FLAGS_ALLOWED:
> +			ctx->restrictions.sqe_flags_allowed = res[i].sqe_flags;
> +			break;
> +		case IORING_RESTRICTION_SQE_FLAGS_REQUIRED:
> +			ctx->restrictions.sqe_flags_required = res[i].sqe_flags;
> +			break;
> +		default:
> +			ret = -EINVAL;
> +			goto out;
> +		}
> +	}
> +
> +	ctx->restricted = 1;
> +
> +	ret = 0;

I'd set ret = 0 above the switch, that's the usual idiom - start at
zero, have someone set it to -ERROR if something fails.

-- 
Jens Axboe

