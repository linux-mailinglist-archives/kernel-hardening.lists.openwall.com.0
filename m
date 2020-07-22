Return-Path: <kernel-hardening-return-19403-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 7D55022975F
	for <lists+kernel-hardening@lfdr.de>; Wed, 22 Jul 2020 13:26:47 +0200 (CEST)
Received: (qmail 15806 invoked by uid 550); 22 Jul 2020 11:24:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 6124 invoked from network); 22 Jul 2020 02:35:38 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daurnimator.com; s=daurnimator;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vabpDlkoU/kJ8BojIIe5Ve9vPK2Kt2NAQYVhz9bpinI=;
        b=ONvSKHxX28zKqql0VPKDWT4e/fQMIxT0JhHw7TGTv+Dch5cbmqxgZIusSPqt8IUSM5
         HCjI8bhyaFg08oWFUF1KDZszvb9vmYFqNWGpJGXxfHgRSMfgCtIGmS11Y73TYMbdmU8+
         uiiBopEfnz+Wuf1tHPDMIwFZekfNOWPhhQrOU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vabpDlkoU/kJ8BojIIe5Ve9vPK2Kt2NAQYVhz9bpinI=;
        b=PZ9GV2tHsgWZULH2QBVWsfM39PYYDxYI80VZ/scEEoifn3Ty618z3qfQ8MRKwzQELT
         VhBtFc7GeKUXU4mfFvhwzIsDadJsfYp0DdoQJ7AHwzAeMNFDFu22a/bme72xPa7v6Lmm
         aJJfBGZQYrpQXVHxT//vlL1TapJA970mo986cWOlCZgDnlG8Fk6mUHbyD2MS2lYhIfa3
         zhF664QxCDiTl541R0IptSS26lp93HL55j0I39oBIhom1DXTEeQvRMs5oqXJsIcz0IBy
         /s5Gguze2lpJkrYxntqEUUQ76ubQyDEEqNSqLJr3EMS0RW7FYUs5lwBy3EWw+1h11k7X
         5XJA==
X-Gm-Message-State: AOAM531EwxIXhpkYg5l8fOTuk4srUcxEu8OQ3D4SUO4h4qwzu+Ur5Ecn
	fP0C/lF3fPWN6wVtVJNdsO1UxoGJK1rJBKP5KTkajQ==
X-Google-Smtp-Source: ABdhPJwfCgvHceNJHN8LjCWPt6NW6WkoqvznlurWy5Aso0Evjbq7qPAlCxHm3n3vJUkWvMP/G2V48hN4+lgytDWXXCY=
X-Received: by 2002:adf:f485:: with SMTP id l5mr7095489wro.147.1595385326963;
 Tue, 21 Jul 2020 19:35:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200716124833.93667-1-sgarzare@redhat.com> <20200716124833.93667-3-sgarzare@redhat.com>
 <0fbb0393-c14f-3576-26b1-8bb22d2e0615@kernel.dk> <20200721104009.lg626hmls5y6ihdr@steredhat>
 <15f7fcf5-c5bb-7752-fa9a-376c4c7fc147@kernel.dk>
In-Reply-To: <15f7fcf5-c5bb-7752-fa9a-376c4c7fc147@kernel.dk>
From: Daurnimator <quae@daurnimator.com>
Date: Wed, 22 Jul 2020 12:35:15 +1000
Message-ID: <CAEnbY+fCP-HS_rWfOF2rnUPos-eZRF1dL+m2Q8CZidi_W=a7xw@mail.gmail.com>
Subject: Re: [PATCH RFC v2 2/3] io_uring: add IOURING_REGISTER_RESTRICTIONS opcode
To: Jens Axboe <axboe@kernel.dk>
Cc: Stefano Garzarella <sgarzare@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Kees Cook <keescook@chromium.org>, 
	Aleksa Sarai <asarai@suse.de>, Stefan Hajnoczi <stefanha@redhat.com>, 
	Christian Brauner <christian.brauner@ubuntu.com>, Sargun Dhillon <sargun@sargun.me>, 
	Jann Horn <jannh@google.com>, io-uring <io-uring@vger.kernel.org>, 
	linux-fsdevel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 22 Jul 2020 at 03:11, Jens Axboe <axboe@kernel.dk> wrote:
>
> On 7/21/20 4:40 AM, Stefano Garzarella wrote:
> > On Thu, Jul 16, 2020 at 03:26:51PM -0600, Jens Axboe wrote:
> >> On 7/16/20 6:48 AM, Stefano Garzarella wrote:
> >>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> >>> index efc50bd0af34..0774d5382c65 100644
> >>> --- a/include/uapi/linux/io_uring.h
> >>> +++ b/include/uapi/linux/io_uring.h
> >>> @@ -265,6 +265,7 @@ enum {
> >>>     IORING_REGISTER_PROBE,
> >>>     IORING_REGISTER_PERSONALITY,
> >>>     IORING_UNREGISTER_PERSONALITY,
> >>> +   IORING_REGISTER_RESTRICTIONS,
> >>>
> >>>     /* this goes last */
> >>>     IORING_REGISTER_LAST
> >>> @@ -293,4 +294,30 @@ struct io_uring_probe {
> >>>     struct io_uring_probe_op ops[0];
> >>>  };
> >>>
> >>> +struct io_uring_restriction {
> >>> +   __u16 opcode;
> >>> +   union {
> >>> +           __u8 register_op; /* IORING_RESTRICTION_REGISTER_OP */
> >>> +           __u8 sqe_op;      /* IORING_RESTRICTION_SQE_OP */
> >>> +   };
> >>> +   __u8 resv;
> >>> +   __u32 resv2[3];
> >>> +};
> >>> +
> >>> +/*
> >>> + * io_uring_restriction->opcode values
> >>> + */
> >>> +enum {
> >>> +   /* Allow an io_uring_register(2) opcode */
> >>> +   IORING_RESTRICTION_REGISTER_OP,
> >>> +
> >>> +   /* Allow an sqe opcode */
> >>> +   IORING_RESTRICTION_SQE_OP,
> >>> +
> >>> +   /* Only allow fixed files */
> >>> +   IORING_RESTRICTION_FIXED_FILES_ONLY,
> >>> +
> >>> +   IORING_RESTRICTION_LAST
> >>> +};
> >>> +
> >>
> >> Not sure I totally love this API. Maybe it'd be cleaner to have separate
> >> ops for this, instead of muxing it like this. One for registering op
> >> code restrictions, and one for disallowing other parts (like fixed
> >> files, etc).
> >>
> >> I think that would look a lot cleaner than the above.
> >>
> >
> > Talking with Stefan, an alternative, maybe more near to your suggestion,
> > would be to remove the 'struct io_uring_restriction' and add the
> > following register ops:
> >
> >     /* Allow an sqe opcode */
> >     IORING_REGISTER_RESTRICTION_SQE_OP
> >
> >     /* Allow an io_uring_register(2) opcode */
> >     IORING_REGISTER_RESTRICTION_REG_OP
> >
> >     /* Register IORING_RESTRICTION_*  */
> >     IORING_REGISTER_RESTRICTION_OP
> >
> >
> >     enum {
> >         /* Only allow fixed files */
> >         IORING_RESTRICTION_FIXED_FILES_ONLY,
> >
> >         IORING_RESTRICTION_LAST
> >     }
> >
> >
> > We can also enable restriction only when the rings started, to avoid to
> > register IORING_REGISTER_ENABLE_RINGS opcode. Once rings are started,
> > the restrictions cannot be changed or disabled.
>
> My concerns are largely:
>
> 1) An API that's straight forward to use
> 2) Something that'll work with future changes
>
> The "allow these opcodes" is straightforward, and ditto for the register
> opcodes. The fixed file I guess is the odd one out. So if we need to
> disallow things in the future, we'll need to add a new restriction
> sub-op. Should this perhaps be "these flags must be set", and that could
> easily be augmented with "these flags must not be set"?
>
> --
> Jens Axboe
>

This is starting to sound a lot like seccomp filtering.
Perhaps we should go straight to adding a BPF hook that fires when
reading off the submission queue?
