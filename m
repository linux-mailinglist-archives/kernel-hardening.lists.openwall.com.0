Return-Path: <kernel-hardening-return-19666-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 5A555253868
	for <lists+kernel-hardening@lfdr.de>; Wed, 26 Aug 2020 21:40:46 +0200 (CEST)
Received: (qmail 28634 invoked by uid 550); 26 Aug 2020 19:40:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 28613 invoked from network); 26 Aug 2020 19:40:39 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OG8uhnCA9kG3csdFryFQgnoVrLmqM/Aisjk2iXjlTO4=;
        b=CCtjUjayr/qntPIykQMCTBeZZeCK50TmOXnltMMVDBp3CR9A65E334WHfJcIaB+qj5
         lM0Ab5TQ23N8QqsdlltlQODO+OGXq6MmQcJBd+tA7A5w2hgKBd/HXsYX/JCZnPLsvU76
         Fc4t/yR7DlFMji9jHEtdubrTqLh5q1Ob78A9U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OG8uhnCA9kG3csdFryFQgnoVrLmqM/Aisjk2iXjlTO4=;
        b=l9x+ztjS4vVBFux8DI260/Zs3TsiZFJmn0eWnCY9HS0ntrlFs3F8PzsDVrsmQDUTbu
         LAC26jppjWZAaJ2hXTOoxaMPnzSSUv0tJzxNU0v/XEJ0N0fOLO2jSCE7W9BOmWzaRwgl
         0lUwniDjwZ8Bd3s09WcVDpAqCNJdHoTHS34m0TcTfcgPmCtWIDPKjSoyzVCE45L+Bx3p
         lHIlGJcMKGMIZWA/ThmscRuUKOpoCzRRcyOjOtXQpn5A1C/l6GBLdODAPouGdJJaH/7E
         25AVJUbJArIbhLUs+Ohu25LY+loWfTobpu9ZveXs+AtIHVHGKLzUWwzdr/8nCqJnG4DM
         ruoA==
X-Gm-Message-State: AOAM530zoWcmX0SAjw1cB/F56p4CtH7cSVpPfzzWeAw7R5DM9djxKlty
	7J8+UJhmPkfxK3vWmIUB+tqkoA==
X-Google-Smtp-Source: ABdhPJwoFPtYUC9LMuzuxI/JkcSQzWHlHT55l/323/HECz8Y1hZ6XBGrFMmE05TvFRpD7eDwLUE2Aw==
X-Received: by 2002:a63:516:: with SMTP id 22mr12143709pgf.316.1598470827209;
        Wed, 26 Aug 2020 12:40:27 -0700 (PDT)
Date: Wed, 26 Aug 2020 12:40:24 -0700
From: Kees Cook <keescook@chromium.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Stefano Garzarella <sgarzare@redhat.com>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	Jann Horn <jannh@google.com>, Jeff Moyer <jmoyer@redhat.com>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	Sargun Dhillon <sargun@sargun.me>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	kernel list <linux-kernel@vger.kernel.org>,
	Aleksa Sarai <asarai@suse.de>, io-uring <io-uring@vger.kernel.org>
Subject: Re: [PATCH v4 0/3] io_uring: add restrictions to support untrusted
 applications and guests
Message-ID: <202008261237.904C1E6@keescook>
References: <20200813153254.93731-1-sgarzare@redhat.com>
 <CAGxU2F55zzMzc043P88TWJNr2poUTVwrRmu86qyh0uM-8gimng@mail.gmail.com>
 <82061082-42c8-1e1c-1f36-6f42e7dd10cb@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82061082-42c8-1e1c-1f36-6f42e7dd10cb@kernel.dk>

On Wed, Aug 26, 2020 at 10:47:36AM -0600, Jens Axboe wrote:
> On 8/25/20 9:20 AM, Stefano Garzarella wrote:
> > Hi Jens,
> > this is a gentle ping.
> > 
> > I'll respin, using memdup_user() for restriction registration.
> > I'd like to get some feedback to see if I should change anything else.
> > 
> > Do you think it's in good shape?
> 
> As far as I'm concerned, this is fine. But I want to make sure that Kees
> is happy with it, as he's the one that's been making noise on this front.

Oop! Sorry, I didn't realize this was blocked on me. Once I saw how
orthogonal io_uring was to "regular" process trees, I figured this
series didn't need seccomp input. (I mean, I am still concerned about
attack surface reduction, but that seems like a hard problem given
io_uring's design -- it is, however, totally covered by the LSMs, so I'm
satisfied from that perspective.)

I'll go review... thanks for the poke. :)

-- 
Kees Cook
