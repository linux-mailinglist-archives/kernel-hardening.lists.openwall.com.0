Return-Path: <kernel-hardening-return-18992-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id DB1AA1FB432
	for <lists+kernel-hardening@lfdr.de>; Tue, 16 Jun 2020 16:24:56 +0200 (CEST)
Received: (qmail 32156 invoked by uid 550); 16 Jun 2020 14:24:49 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 26261 invoked from network); 16 Jun 2020 14:08:10 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1592316478;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HKvuP28qkc6MBB6IwSv1PcVS+c7WF6yZntMMdTppL0A=;
	b=bnCvylqfHlI/IxpuiFbbpQoX89e+jTQA8LwHe4Qxz+fmVN44SXg0yIN4huzcVFdJvchDD0
	Wf3EdmKVWiHNnbnwWa3RzbHA07Fdhdx0NkgcJVgYYuYEIdSgBiAPk4Vix/BXOm83DaROls
	8424zsa5R8hKbeEPbkRkucgkana5qzw=
X-MC-Unique: sMM9LzVwNFedxtvGnLxT4w-1
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HKvuP28qkc6MBB6IwSv1PcVS+c7WF6yZntMMdTppL0A=;
        b=KmBhvFKSSLhcSrhXDvAHBjXzwQfank2uL7fbHSpPo/h/EP0nLV9qHLYxBbId/GR1bu
         zN4h569mjJcui/rEaD4c5dMIG2IKtjCLJcvuJMY6f1Pud9szEdhEBCGe0cGmcja29Ho4
         Tbnxbm8dtrxYJ5cxQbuXBD6klzQRLsgChh0kuhXOzcIa9RuIiZ4VxVrEk5MfyTNK24/J
         iVIfnBNrDhK4bOo9u0GGTPPg9g8Xe4eBgKzPNKlqHZ+4mCQTocuiE5/cxn//7o7mRNsh
         2kAslBjOVl/xYqx1P3dICOWl9u6IzJC6zVIuBJaqEi4WuhO+BWV3uCIoBOHtpeEQPcgZ
         3pfg==
X-Gm-Message-State: AOAM530Vg4Ftm/Y1i4q3RzynSa/uftcJs40qwZhgeN7evnM58EWZk8a7
	R7tcibosooXhTABrsW9TN0AXIeM8XoNjJqwCBTtdWt7kCHz0NzSlDGtw/beQfW/dj0BQk0Gj3GJ
	doritI4G0G2ZLewB5B/JwA6UTTQk17sdwZg==
X-Received: by 2002:a5d:4a04:: with SMTP id m4mr3579237wrq.153.1592316474933;
        Tue, 16 Jun 2020 07:07:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwpmdnWvRihlkxQ8tjndHuvUjkBpMvaR9kePdz++dZsEZmSNVLvC/EwxppWTm5SYTTYLOnqTg==
X-Received: by 2002:a5d:4a04:: with SMTP id m4mr3579198wrq.153.1592316474619;
        Tue, 16 Jun 2020 07:07:54 -0700 (PDT)
Date: Tue, 16 Jun 2020 16:07:50 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Jann Horn <jannh@google.com>
Cc: Jens Axboe <axboe@kernel.dk>, Kees Cook <keescook@chromium.org>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	Sargun Dhillon <sargun@sargun.me>, Aleksa Sarai <asarai@suse.de>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Jeff Moyer <jmoyer@redhat.com>, io-uring <io-uring@vger.kernel.org>,
	kernel list <linux-kernel@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: [RFC] io_uring: add restrictions to support untrusted
 applications and guests
Message-ID: <20200616140750.3eyfsuc4kksyy3sq@steredhat>
References: <20200609142406.upuwpfmgqjeji4lc@steredhat>
 <CAG48ez3kdNKjif==MbX36cKNYDpZwEPMZaJQ1rrpXZZjGZwbKw@mail.gmail.com>
 <20200615133310.qwdmnctrir5zgube@steredhat>
 <f7f2841e-3dbb-377f-f8f8-826506a938a6@kernel.dk>
 <20200616091247.hdmxcrnlrrxih7my@steredhat>
 <CAG48ez2n5t7zkm7H_bPAcxz6KT25TrMp3sLZ3BhpMHaCQqcArQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAG48ez2n5t7zkm7H_bPAcxz6KT25TrMp3sLZ3BhpMHaCQqcArQ@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 16, 2020 at 01:32:54PM +0200, Jann Horn wrote:
> On Tue, Jun 16, 2020 at 11:13 AM Stefano Garzarella <sgarzare@redhat.com> wrote:
> > On Mon, Jun 15, 2020 at 11:00:25AM -0600, Jens Axboe wrote:
> > > On 6/15/20 7:33 AM, Stefano Garzarella wrote:
> > > > On Mon, Jun 15, 2020 at 11:04:06AM +0200, Jann Horn wrote:
> > > >> +Kees, Christian, Sargun, Aleksa, kernel-hardening for their opinions
> > > >> on seccomp-related aspects
> > > >>
> > > >> On Tue, Jun 9, 2020 at 4:24 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
> > > >>> Hi Jens,
> > > >>> Stefan and I have a proposal to share with io_uring community.
> > > >>> Before implementing it we would like to discuss it to receive feedbacks and
> > > >>> to see if it could be accepted:
> > > >>>
> > > >>> Adding restrictions to io_uring
> > > >>> =====================================
> > > >>> The io_uring API provides submission and completion queues for performing
> > > >>> asynchronous I/O operations. The queues are located in memory that is
> > > >>> accessible to both the host userspace application and the kernel, making it
> > > >>> possible to monitor for activity through polling instead of system calls. This
> > > >>> design offers good performance and this makes exposing io_uring to guests an
> > > >>> attractive idea for improving I/O performance in virtualization.
> > > >> [...]
> > > >>> Restrictions
> > > >>> ------------
> > > >>> This document proposes io_uring API changes that safely allow untrusted
> > > >>> applications or guests to use io_uring. io_uring's existing security model is
> > > >>> that of kernel system call handler code. It is designed to reject invalid
> > > >>> inputs from host userspace applications. Supporting guests as io_uring API
> > > >>> clients adds a new trust domain with access to even fewer resources than host
> > > >>> userspace applications.
> > > >>>
> > > >>> Guests do not have direct access to host userspace application file descriptors
> > > >>> or memory. The host userspace application, a Virtual Machine Monitor (VMM) such
> > > >>> as QEMU, grants access to a subset of its file descriptors and memory. The
> > > >>> allowed file descriptors are typically the disk image files belonging to the
> > > >>> guest. The memory is typically the virtual machine's RAM that the VMM has
> > > >>> allocated on behalf of the guest.
> > > >>>
> > > >>> The following extensions to the io_uring API allow the host application to
> > > >>> grant access to some of its file descriptors.
> > > >>>
> > > >>> These extensions are designed to be applicable to other use cases besides
> > > >>> untrusted guests and are not virtualization-specific. For example, the
> > > >>> restrictions can be used to allow only a subset of sqe operations available to
> > > >>> an application similar to seccomp syscall whitelisting.
> > > >>>
> > > >>> An address translation and memory restriction mechanism would also be
> > > >>> necessary, but we can discuss this later.
> > > >>>
> > > >>> The IOURING_REGISTER_RESTRICTIONS opcode
> > > >>> ----------------------------------------
> > > >>> The new io_uring_register(2) IOURING_REGISTER_RESTRICTIONS opcode permanently
> > > >>> installs a feature whitelist on an io_ring_ctx. The io_ring_ctx can then be
> > > >>> passed to untrusted code with the knowledge that only operations present in the
> > > >>> whitelist can be executed.
> > > >>
> > > >> This approach of first creating a normal io_uring instance and then
> > > >> installing restrictions separately in a second syscall means that it
> > > >> won't be possible to use seccomp to restrict newly created io_uring
> > > >> instances; code that should be subject to seccomp restrictions and
> > > >> uring restrictions would only be able to use preexisting io_uring
> > > >> instances that have already been configured by trusted code.
> > > >>
> > > >> So I think that from the seccomp perspective, it might be preferable
> > > >> to set up these restrictions in the io_uring_setup() syscall. It might
> > > >> also be a bit nicer from a code cleanliness perspective, since you
> > > >> won't have to worry about concurrently changing restrictions.
> > > >>
> > > >
> > > > Thank you for these details!
> > > >
> > > > It seems feasible to include the restrictions during io_uring_setup().
> > > >
> > > > The only doubt concerns the possibility of allowing the trusted code to
> > > > do some operations, before passing queues to the untrusted code, for
> > > > example registering file descriptors, buffers, eventfds, etc.
> > > >
> > > > To avoid this, I should include these operations in io_uring_setup(),
> > > > adding some code that I wanted to avoid by reusing io_uring_register().
> > > >
> > > > If I add restrictions in io_uring_setup() and then add an operation to
> > > > go into safe mode (e.g. a flag in io_uring_enter()), we would have the same
> > > > problem, right?
> > > >
> > > > Just to be clear, I mean something like this:
> > > >
> > > >     /* params will include restrictions */
> > > >     fd = io_uring_setup(entries, params);
> > > >
> > > >     /* trusted code */
> > > >     io_uring_register_files(fd, ...);
> > > >     io_uring_register_buffers(fd, ...);
> > > >     io_uring_register_eventfd(fd, ...);
> > > >
> > > >     /* enable safe mode */
> > > >     io_uring_enter(fd, ..., IORING_ENTER_ENABLE_RESTRICTIONS);
> > > >
> > > >
> > > > Anyway, including a list of things to register in the 'params', passed
> > > > to io_uring_setup(), should be feasible, if Jens agree :-)
> > >
> > > I wonder how best to deal with this, in terms of ring visibility vs
> > > registering restrictions. We could potentially start the ring in a
> > > disabled mode, if asked to. It'd still be visible in terms of having
> > > the fd installed, but it'd just error requests. That'd leave you with
> > > time to do the various setup routines needed before then flagging it
> > > as enabled. My only worry on that would be adding overhead for doing
> > > that. It'd be cheap enough to check for IORING_SETUP_DISABLED in
> > > ctx->flags in io_uring_enter(), and return -EBADFD or something if
> > > that's the case. That doesn't cover the SQPOLL case though, but maybe we
> > > just don't start the sq thread if IORING_SETUP_DISABLED is set.
> >
> > It seems to me a very good approach and easy to implement. In this way
> > we can reuse io_uring_register() without having to modify too much
> > io_uring_setup().
> >
> > >
> > > We'd need a way to clear IORING_SETUP_DISABLED through
> > > io_uring_register(). When clearing, that could then start the sq thread
> > > as well, when SQPOLL is set.
> >
> > Could we do it using io_uring_enter() since we have a flag field or
> > do you think it's semantically incorrect?
> >
> > @Jann, do you think this could work with seccomp?
> 
> To clarify that I understood your proposal correctly: Is the idea to
> have two types of mostly orthogonal restrictions; one type being
> restrictions on the opcode (supplied in io_uring_setup() and enforced
> immediately) and the other type being restrictions on
> io_uring_register() (enabled via IORING_ENTER_ENABLE_RESTRICTIONS)?

Slightly different. The idea is to start the ring in a disabled mode,
where all submission ops are not allowed.

In this way the trusted code can do the various setups (e.g. using
io_uring_register() to register fd, buffers, restrictions, etc.).
When the setup phase is finished, the trusted code can enable the ring
using io_uring_register() or io_uring_enter() with a special flag.

After this last syscall, submissions are enabled and restricted
(if restrictions have been registered).

I hope that's a little bit clearer. I'm sorry it's not.

Stefano

