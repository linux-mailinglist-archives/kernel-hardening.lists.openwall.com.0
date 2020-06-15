Return-Path: <kernel-hardening-return-18989-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id E7F991FA417
	for <lists+kernel-hardening@lfdr.de>; Tue, 16 Jun 2020 01:26:53 +0200 (CEST)
Received: (qmail 24027 invoked by uid 550); 15 Jun 2020 23:26:47 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 24007 invoked from network); 15 Jun 2020 23:26:47 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t36AfAxmVUPgFShxugWx8vpo7Nh3/W7qrT3GE6ix9Cw=;
        b=v6geb5iM6AHcjCpEZnHGSzpWg0GuVfHjaK68MaNpr+UGU6zR41cP8Y1jAAQ3lbEilz
         VlN8zU7ncNIKGy7DDFyPb/Yj8s2JKFfSEtczq6oK1znWXgRqulKDeortwlvoAhmwFXmg
         QmJA3c9gtahBDqLrkBiBKeaVQjgyVZI4O1cOwY8E4mVk0mQqkpkedKpROhIdk/MsNmiv
         T/J9mwsxBHzba/0pmSDxdj5nPHTYjkqdQ0HURBvm7puPYmZt7PqqchJYmyqdUt8HHiYp
         DQC2GJ07KRu5R6krZ0q7ZPBjU9bK3Q/qGBevJpIFgnaa9MTEZDQNSOy56uyOiBnodppU
         WmWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t36AfAxmVUPgFShxugWx8vpo7Nh3/W7qrT3GE6ix9Cw=;
        b=FeL5+0DZGXDTVDbOlFEgAuySeB33bluujEgOcUByCQOJc21yBEKtawAPJJ/Cgw6DqN
         biYCndrjl9e8yU8z2gerZRD+HQBwn1hYNeiPyOCwzochnP0k+NWE+Q7/+4wlyqhqU69B
         +FrONG1WFanmaTgJ818dI59GiEmFdmyzCtzXF3/W2uMvjr+0EX7sQDmoPcvI6WdzvlNH
         kyiAzLx7Jw3aLv956Lg6vRYH7E8SKwkePfMSwFVK3KrVMgcZ60b9YpD85l3tu5U6zSBw
         1uGA9lq0XH0tG9xdtexSuVibO9X22p6DgUR4l9LIH2mMTqOYvNffFmIcA55Uwowsh5CQ
         vmOw==
X-Gm-Message-State: AOAM533nDdn4TXvouT+Jk3lr3QFv2ArUgVdurhp0UZopsh0BZRKE64EY
	F9ymbBCR8rHIblAJONlWnLK0t4fwh7ttZjMUIALi1A==
X-Google-Smtp-Source: ABdhPJy4UCD34ksC6HjtziYgqG6/oUIJyz4mVdKKfo9S8Dn3XQi1qU2VgKJpOgYlopCK36rFQ+Eukt7xq4Ylp48oJyo=
X-Received: by 2002:a2e:7f02:: with SMTP id a2mr44239ljd.138.1592263595797;
 Mon, 15 Jun 2020 16:26:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200609142406.upuwpfmgqjeji4lc@steredhat> <CAG48ez3kdNKjif==MbX36cKNYDpZwEPMZaJQ1rrpXZZjGZwbKw@mail.gmail.com>
 <20200615220143.qrm4ffbkpaew4xdv@wittgenstein>
In-Reply-To: <20200615220143.qrm4ffbkpaew4xdv@wittgenstein>
From: Jann Horn <jannh@google.com>
Date: Tue, 16 Jun 2020 01:26:09 +0200
Message-ID: <CAG48ez17MLcj83JDOr6_GeQZ8orqL3EKHt6X=0wfr5RODVqqDA@mail.gmail.com>
Subject: Re: [RFC] io_uring: add restrictions to support untrusted
 applications and guests
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Stefano Garzarella <sgarzare@redhat.com>, Kees Cook <keescook@chromium.org>, 
	Sargun Dhillon <sargun@sargun.me>, Aleksa Sarai <asarai@suse.de>, Jens Axboe <axboe@kernel.dk>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Jeff Moyer <jmoyer@redhat.com>, 
	io-uring <io-uring@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Jun 16, 2020 at 12:01 AM Christian Brauner
<christian.brauner@ubuntu.com> wrote:
>
> On Mon, Jun 15, 2020 at 11:04:06AM +0200, Jann Horn wrote:
> > +Kees, Christian, Sargun, Aleksa, kernel-hardening for their opinions
> > on seccomp-related aspects
>
> Just fyi, I'm on holiday this week so my responses have some
> non-significant lag into early next week.
>
> >
> > On Tue, Jun 9, 2020 at 4:24 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
> > > Hi Jens,
> > > Stefan and I have a proposal to share with io_uring community.
> > > Before implementing it we would like to discuss it to receive feedbacks and
> > > to see if it could be accepted:
> > >
> > > Adding restrictions to io_uring
> > > =====================================
> > > The io_uring API provides submission and completion queues for performing
> > > asynchronous I/O operations. The queues are located in memory that is
> > > accessible to both the host userspace application and the kernel, making it
> > > possible to monitor for activity through polling instead of system calls. This
> > > design offers good performance and this makes exposing io_uring to guests an
> > > attractive idea for improving I/O performance in virtualization.
> > [...]
> > > Restrictions
> > > ------------
> > > This document proposes io_uring API changes that safely allow untrusted
> > > applications or guests to use io_uring. io_uring's existing security model is
> > > that of kernel system call handler code. It is designed to reject invalid
> > > inputs from host userspace applications. Supporting guests as io_uring API
> > > clients adds a new trust domain with access to even fewer resources than host
> > > userspace applications.
> > >
> > > Guests do not have direct access to host userspace application file descriptors
> > > or memory. The host userspace application, a Virtual Machine Monitor (VMM) such
> > > as QEMU, grants access to a subset of its file descriptors and memory. The
> > > allowed file descriptors are typically the disk image files belonging to the
> > > guest. The memory is typically the virtual machine's RAM that the VMM has
> > > allocated on behalf of the guest.
> > >
> > > The following extensions to the io_uring API allow the host application to
> > > grant access to some of its file descriptors.
> > >
> > > These extensions are designed to be applicable to other use cases besides
> > > untrusted guests and are not virtualization-specific. For example, the
> > > restrictions can be used to allow only a subset of sqe operations available to
> > > an application similar to seccomp syscall whitelisting.
> > >
> > > An address translation and memory restriction mechanism would also be
> > > necessary, but we can discuss this later.
> > >
> > > The IOURING_REGISTER_RESTRICTIONS opcode
> > > ----------------------------------------
> > > The new io_uring_register(2) IOURING_REGISTER_RESTRICTIONS opcode permanently
> > > installs a feature whitelist on an io_ring_ctx. The io_ring_ctx can then be
> > > passed to untrusted code with the knowledge that only operations present in the
> > > whitelist can be executed.
> >
> > This approach of first creating a normal io_uring instance and then
> > installing restrictions separately in a second syscall means that it
> > won't be possible to use seccomp to restrict newly created io_uring
> > instances; code that should be subject to seccomp restrictions and
> > uring restrictions would only be able to use preexisting io_uring
> > instances that have already been configured by trusted code.
> >
> > So I think that from the seccomp perspective, it might be preferable
> > to set up these restrictions in the io_uring_setup() syscall. It might
>
> So from what I can gather from this proposal, this would be a separate
> security model for io_uring? I'm not to thrilled about that tbh. (There's
> some discussion around extending seccomp - also at kernel summit.)
> But doing the whole restriction setup in io_uring_setup() would at least
> mean that if seccomp is extended to filter first-level pointers it could
> know about all the security restrictions that apply to this io_uring
> instance (Which I think you were getting at, Jann?).

Yeah.

> Hm, would it make sense that if a task has a seccomp filter installed
> that blocks openat syscalls that io_uring should automatically block
> openat() calls as well or is the expectation "just block all of io_uring
> if you're worried about that"?

I mean, if we could make that automagic, that'd be kinda neat; but I'm
slightly worried that an automated translation might end up being
slightly inaccurate. (But maybe that's acceptable?)
