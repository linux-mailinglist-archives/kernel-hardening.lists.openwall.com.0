Return-Path: <kernel-hardening-return-19606-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id AA60F242206
	for <lists+kernel-hardening@lfdr.de>; Tue, 11 Aug 2020 23:33:33 +0200 (CEST)
Received: (qmail 31787 invoked by uid 550); 11 Aug 2020 21:33:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 31755 invoked from network); 11 Aug 2020 21:33:27 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1XmU1UxtFoX+JxWRWBVQUmWx0SHpCQU0BLn06Acf+NU=;
        b=nO3gYAQ3UHUw7olEjw932d3zFLqOCCUdnacl9cVKrUgmFx2PGjAFNp8CQwEB7V4Hmy
         FGOy733ZHh3A1xH6oKC3op8DvO/HEaTRYWhxchiQa9h8rnO5vamgJzN81P21hsQ5n8I3
         t7TvIriH92cU2JNs0mnOTN8SDZ89gDDMfKKUs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1XmU1UxtFoX+JxWRWBVQUmWx0SHpCQU0BLn06Acf+NU=;
        b=BSN1Bg6Zk1yV0iR6XRLszq8Kjne3LbbUhs54sNMEqxPVCzuAC3qwchFt/37PYxNTBM
         JypTbuhY/oBXQNzATm4v4/vpnrrCfrfUGm8RIOjGKx9jps6HNHPryU2OHklHJvEn7ST+
         JwnLH+uWyZUoi5dM+jxTESJ3n0fSr/tT5Ms+gfy/obyByAyc51csq3O9soMNbpy3fY2a
         j8wIZFqZPossoRg5I3bblMLuska1sDGYqsPcCT+eWgXq9uR1HlYNhjxCeHgNXDBklj6q
         qPJOwXRf8s4sKrU7XF1oA1j4Hz61xJDBmE/IkNh7rOqqDReU0rGMdPYpNTtrLYoIKyH5
         Jb2g==
X-Gm-Message-State: AOAM532G1XcsNJ506adYA0OBW2MJp5VFj5/0a+RKfkLC7SQeMDamd60A
	35BaJ6sbMhoxyNEa2JaRgGHjsg==
X-Google-Smtp-Source: ABdhPJzVUgwczR2LI6waXoChEBBAZmQiyV+rznpXD/j383hrrCcUrIvWs+lVRQIEgQVz81ia6sNYwg==
X-Received: by 2002:a17:90a:ccd:: with SMTP id 13mr2785480pjt.123.1597181595355;
        Tue, 11 Aug 2020 14:33:15 -0700 (PDT)
Date: Tue, 11 Aug 2020 14:33:13 -0700
From: Kees Cook <keescook@chromium.org>
To: Allen <allen.lkml@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Oscar Carter <oscar.carter@gmx.com>,
	Romain Perier <romain.perier@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Peter Zijlstra <peterz@infradead.org>,
	Will Deacon <will@kernel.org>, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	linux-s390@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-usb@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
	alsa-devel@alsa-project.org,
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: [PATCH 0/3] Modernize tasklet callback API
Message-ID: <202008111427.D00FCCF@keescook>
References: <20200716030847.1564131-1-keescook@chromium.org>
 <87h7tpa3hg.fsf@nanos.tec.linutronix.de>
 <202007301113.45D24C9D@keescook>
 <CAOMdWSJQKHAWY1P297b9koOLd8sVtezEYEyWGtymN1YeY27M6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMdWSJQKHAWY1P297b9koOLd8sVtezEYEyWGtymN1YeY27M6A@mail.gmail.com>

On Mon, Aug 03, 2020 at 02:16:15PM +0530, Allen wrote:
> Here's the series re-based on top of 5.8
> https://github.com/allenpais/tasklets/tree/V3

Great!

> Let me know how you would want these to be reviewed.

Was a Coccinelle script used for any of these conversions? I wonder if
it'd be easier to do a single treewide patch for the more mechanical
changes.

And, actually, I still think the "prepare" patches should just be
collapsed into the actual "covert" patches -- there are only a few.

After those, yeah, I think getting these sent to their respective
maintainers is the next step.

> Also, I was thinking if removing tasklets completely could be a task
> on KSPP wiki. If yes, I did like to take ownership of that task. I have a
> couple of ideas in mind, which could be discussed in a separate email.

Sure! I will add it to the tracker. Here's for the refactoring:
https://github.com/KSPP/linux/issues/30

and here's for the removal:
https://github.com/KSPP/linux/issues/94

if you can added details/examples of how they should be removed, that'd
help other folks too, if they wanted to jump in. :)

-Kees

-- 
Kees Cook
