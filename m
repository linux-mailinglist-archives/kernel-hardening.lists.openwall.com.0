Return-Path: <kernel-hardening-return-16003-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 9BE272E3E3
	for <lists+kernel-hardening@lfdr.de>; Wed, 29 May 2019 19:47:40 +0200 (CEST)
Received: (qmail 20291 invoked by uid 550); 29 May 2019 17:47:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 20270 invoked from network); 29 May 2019 17:47:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AmI4EFzZ6VT9TOg1cFEHsMHt6YDKL3frdwtue1WA3MQ=;
        b=rqEGFjkUEFmWfe+Bt5MYFJ/f/Ul+aHmqapx7HwxPLddDX0XutuICprcxl2IRBB+2wZ
         FBRhjkQhq0l8FGGPbG9iYTwcvG1L0zqWGnLkyYD0QUHtOHVFLuFexbbvf8DTq2cAJwIc
         qGAeqR/R7WWTblsPDHtqemkbqR/RjKHsE/rp1eLjwVmSOkWL+HLfgGJwRyW90asobQJ4
         db628CyWRP0Gbo529Eq/uBkkm0ATyy/7jo4gyJbVRwGvSHZ4DHrUenMmRW4i+hfsltwh
         /NisW02kiqi8fqH+L1vXF6yr7Zpf/a9SpygycxZqARJe1E3v94fpOSgoJmPU9/JrJi49
         HCeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AmI4EFzZ6VT9TOg1cFEHsMHt6YDKL3frdwtue1WA3MQ=;
        b=SS1ZGU8yJ9xKAyN6U/5WfCjV/UKGnGahabt5hvx1CLy75b1eVdVXkegWMS4p4FQvjy
         SbV81D5jPZv0McHPxCQTQ48A/aDQ4OND8Ck7lory+PnVHh4GtNIUNBmqpRJI4aDTCoaK
         MopD3QVg5fX8nYwG2dQmUHJyRAxJOVkCam9B812HRHXgpDqLTOUeIeVgQIuWXms2lptr
         obaeDH83dbPpmN6hMz/wYn/zXoj/ZwnSfzuelEmBJub6PL2m+tEsHR9wsjvhCy62rg/s
         RL3rkt2S6BIFOEsi/ERZofytHUZ5z+8T+IYACEJ7h8rdfgvNWvY8Wl9hK6BbQLRp5SlF
         8dwA==
X-Gm-Message-State: APjAAAXeK3SOccjqjyzJDgc13oq31zURPgQLFA7WDRSKg/3lraqiNPbz
	HLCyFSUtmhAixp3ynbqOuht1qPKQnDGLZ6KufppPmw==
X-Google-Smtp-Source: APXvYqwAXrQMKCV8uFA/kbPzCqsEnH0/t77faf/fiPhDVfNPi7ZFtM6fgNmEGcbRFh238jXq6XZ6wItg04BAO70Npc4=
X-Received: by 2002:aca:5943:: with SMTP id n64mr58380oib.175.1559152041282;
 Wed, 29 May 2019 10:47:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190528162603.GA24097@kroah.com> <155905930702.7587.7100265859075976147.stgit@warthog.procyon.org.uk>
 <155905931502.7587.11705449537368497489.stgit@warthog.procyon.org.uk>
 <4031.1559064620@warthog.procyon.org.uk> <20190528231218.GA28384@kroah.com> <31936.1559146000@warthog.procyon.org.uk>
In-Reply-To: <31936.1559146000@warthog.procyon.org.uk>
From: Jann Horn <jannh@google.com>
Date: Wed, 29 May 2019 19:46:54 +0200
Message-ID: <CAG48ez0R-R3Xs+3Xg9T9qcV3Xv6r4pnx1Z2y=Ltx7RGOayte_w@mail.gmail.com>
Subject: Re: [PATCH 1/7] General notification queue with user mmap()'able ring buffer
To: David Howells <dhowells@redhat.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	raven@themaw.net, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	Linux API <linux-api@vger.kernel.org>, linux-block@vger.kernel.org, 
	keyrings@vger.kernel.org, 
	linux-security-module <linux-security-module@vger.kernel.org>, 
	kernel list <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, May 29, 2019 at 6:07 PM David Howells <dhowells@redhat.com> wrote:
> Greg KH <gregkh@linuxfoundation.org> wrote:
> > everyone should use
> > it.  It saves us having to audit the same pattern over and over again.
> > And, even nicer, it uses a refcount now, and as you are trying to
> > reference count an object, it is exactly what this was written for.
> >
> > So yes, I do think it should be used here, unless it is deemed to not
> > fit the pattern/usage model.
>
> kref_put() enforces a very specific destructor signature.  I know of places
> where that doesn't work because the destructor takes more than one argument
> (granted that this is not the case here).  So why does kref_put() exist at
> all?  Why not kref_dec_and_test()?
>
> Why doesn't refcount_t get merged into kref, or vice versa?  Having both would
> seem redundant.
>
> Mind you, I've been gradually reverting atomic_t-to-refcount_t conversions
> because it seems I'm not allowed refcount_inc/dec_return() and I want to get
> at the point refcount for tracing purposes.

Yeeech, that's horrible, please don't do that.

Does this mean that refcount_read() isn't sufficient for what you want
to do with tracing (because for some reason you actually need to know
the values atomically at the time of increment/decrement)?
