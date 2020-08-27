Return-Path: <kernel-hardening-return-19696-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 57720254672
	for <lists+kernel-hardening@lfdr.de>; Thu, 27 Aug 2020 16:08:24 +0200 (CEST)
Received: (qmail 11270 invoked by uid 550); 27 Aug 2020 14:08:19 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 10226 invoked from network); 27 Aug 2020 14:08:18 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1598537286;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CvdhiPhYSGUOeaIN0B943JFU94tDWV4/UOsJxiz1v3Q=;
	b=UHFEckN0fYgnuf0GwXFpAGG704V7cLk2XESvYIhi1FmDM97lxaCznwl7e1KQJY6oYHp+5B
	3PV8HRqkZbjh8TWBxG4DGuecjHFGIK6wLvRrTb5612eEd8yD2A0fSfXHqhKu0/3X72jwLw
	HC39wgLNGXic7MvJJ7nNmvoQmgC1grQ=
X-MC-Unique: Pl48UCipO4S-yQb8cZzVog-1
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CvdhiPhYSGUOeaIN0B943JFU94tDWV4/UOsJxiz1v3Q=;
        b=kf6U2exC5HYM0Li2Z9a1hs8jxLhhj3u90ArcUjvyr3E/IN9VgM6gc/CNjMWahqJzkH
         SqtU5rSfSAqwRBrlMHNibxoI16kuYaOeuPl3hKgaQ/9VwJBg0ufWwaWOSduIEObKrIuQ
         sh/KWbiAxLoeFbcQX+OXSZ1mg1innPC2ljzoixub+n+ovl8rwDNTUCGjtUXbs7yxI9Jp
         RUNMwQM0lLpZMDBA8PLcx+xGuJzXMqqZMo2EsnXwdDHG364KTK2veOhOGj+tn4B8LBDg
         fiWBEvSP1n5WoB9InarS6myPWmzW3qMe21PpoGILqimyZbJWiwPMtev1LFQh+1y/f+36
         t1jw==
X-Gm-Message-State: AOAM530uyfVQDNQI+bnzmz/cELg2tgdPUKxp2SradE6osyYSyKHHXCJM
	at3+F9vi8skjDsTQ6jgivr2+iaZm45R8aonrbNtj7rQ13zI3uN6HaC/76G0IuNz2aCDgQEQhz03
	k4d/cL+CC1xM+i7WqbWmjshbJd+mjQ8nGRw==
X-Received: by 2002:a5d:66c1:: with SMTP id k1mr19971169wrw.8.1598537283953;
        Thu, 27 Aug 2020 07:08:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzWw4gY+gfT3ioYFr28ZoapW9vPXQZrcRf4b8LhwoAGjeKf6Sd713KoEGCbzoU3U0KCeejqiw==
X-Received: by 2002:a5d:66c1:: with SMTP id k1mr19971132wrw.8.1598537283631;
        Thu, 27 Aug 2020 07:08:03 -0700 (PDT)
Date: Thu, 27 Aug 2020 16:07:58 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Aleksa Sarai <asarai@suse.de>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Jann Horn <jannh@google.com>, io-uring@vger.kernel.org,
	Christian Brauner <christian.brauner@ubuntu.com>,
	linux-fsdevel@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Stefan Hajnoczi <stefanha@redhat.com>, linux-kernel@vger.kernel.org,
	Sargun Dhillon <sargun@sargun.me>,
	Kees Cook <keescook@chromium.org>, Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v5 2/3] io_uring: add IOURING_REGISTER_RESTRICTIONS opcode
Message-ID: <20200827140758.mboc7z2us2yqp356@steredhat.lan>
References: <20200827134044.82821-1-sgarzare@redhat.com>
 <20200827134044.82821-3-sgarzare@redhat.com>
 <206a32b6-ba20-fc91-1906-e6bf377798ae@kernel.dk>
MIME-Version: 1.0
In-Reply-To: <206a32b6-ba20-fc91-1906-e6bf377798ae@kernel.dk>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=sgarzare@redhat.com
X-Mimecast-Spam-Score: 0.002
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 27, 2020 at 07:49:45AM -0600, Jens Axboe wrote:
> On 8/27/20 7:40 AM, Stefano Garzarella wrote:
> > @@ -6414,6 +6425,19 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
> >  	if (unlikely(sqe_flags & ~SQE_VALID_FLAGS))
> >  		return -EINVAL;
> >  
> > +	if (unlikely(ctx->restricted)) {
> > +		if (!test_bit(req->opcode, ctx->restrictions.sqe_op))
> > +			return -EACCES;
> > +
> > +		if ((sqe_flags & ctx->restrictions.sqe_flags_required) !=
> > +		    ctx->restrictions.sqe_flags_required)
> > +			return -EACCES;
> > +
> > +		if (sqe_flags & ~(ctx->restrictions.sqe_flags_allowed |
> > +				  ctx->restrictions.sqe_flags_required))
> > +			return -EACCES;
> > +	}
> > +
> 
> This should be a separate function, ala:
> 
> if (unlikely(ctx->restricted)) {
> 	ret = io_check_restriction(ctx, req);
> 	if (ret)
> 		return ret;
> }
> 
> to move it totally out of the (very) hot path.

I'll fix.

> 
> >  	if ((sqe_flags & IOSQE_BUFFER_SELECT) &&
> >  	    !io_op_defs[req->opcode].buffer_select)
> >  		return -EOPNOTSUPP;
> > @@ -8714,6 +8738,71 @@ static int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id)
> >  	return -EINVAL;
> >  }
> >  
> > +static int io_register_restrictions(struct io_ring_ctx *ctx, void __user *arg,
> > +				    unsigned int nr_args)
> > +{
> > +	struct io_uring_restriction *res;
> > +	size_t size;
> > +	int i, ret;
> > +
> > +	/* We allow only a single restrictions registration */
> > +	if (ctx->restricted)
> > +		return -EBUSY;
> > +
> > +	if (!arg || nr_args > IORING_MAX_RESTRICTIONS)
> > +		return -EINVAL;
> > +
> > +	size = array_size(nr_args, sizeof(*res));
> > +	if (size == SIZE_MAX)
> > +		return -EOVERFLOW;
> > +
> > +	res = memdup_user(arg, size);
> > +	if (IS_ERR(res))
> > +		return PTR_ERR(res);
> > +
> > +	for (i = 0; i < nr_args; i++) {
> > +		switch (res[i].opcode) {
> > +		case IORING_RESTRICTION_REGISTER_OP:
> > +			if (res[i].register_op >= IORING_REGISTER_LAST) {
> > +				ret = -EINVAL;
> > +				goto out;
> > +			}
> > +
> > +			__set_bit(res[i].register_op,
> > +				  ctx->restrictions.register_op);
> > +			break;
> > +		case IORING_RESTRICTION_SQE_OP:
> > +			if (res[i].sqe_op >= IORING_OP_LAST) {
> > +				ret = -EINVAL;
> > +				goto out;
> > +			}
> > +
> > +			__set_bit(res[i].sqe_op, ctx->restrictions.sqe_op);
> > +			break;
> > +		case IORING_RESTRICTION_SQE_FLAGS_ALLOWED:
> > +			ctx->restrictions.sqe_flags_allowed = res[i].sqe_flags;
> > +			break;
> > +		case IORING_RESTRICTION_SQE_FLAGS_REQUIRED:
> > +			ctx->restrictions.sqe_flags_required = res[i].sqe_flags;
> > +			break;
> > +		default:
> > +			ret = -EINVAL;
> > +			goto out;
> > +		}
> > +	}
> > +
> > +	ctx->restricted = 1;
> > +
> > +	ret = 0;
> 
> I'd set ret = 0 above the switch, that's the usual idiom - start at
> zero, have someone set it to -ERROR if something fails.

Yes, it is better. I'll fix it.

Thanks,
Stefano

