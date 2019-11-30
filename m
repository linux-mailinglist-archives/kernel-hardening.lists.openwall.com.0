Return-Path: <kernel-hardening-return-17451-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 1861510DE4F
	for <lists+kernel-hardening@lfdr.de>; Sat, 30 Nov 2019 17:48:46 +0100 (CET)
Received: (qmail 29758 invoked by uid 550); 30 Nov 2019 16:48:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 29724 invoked from network); 30 Nov 2019 16:48:37 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nl2tg34sKyANUXC9hMeNmDIJkV8UJx1WQQjhyDTkegg=;
        b=K4iW6DrGGCVtaSvQHMUxIYcgJOXTzahbpBbT1QnuNvhLXblUSU/tYp5BEp7R2Bnvk7
         vGbJZDFG8tzIAMpNx/t4hRQ4d5atYPjV6PQxQC9VRxw3UYSI38zFT2iedeLm/HaHQX9K
         ZBLJCy6iu1+r0aCx4J9Qb/DWR9pqXscxacJNc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nl2tg34sKyANUXC9hMeNmDIJkV8UJx1WQQjhyDTkegg=;
        b=K9QY869DiYYMIXi/fpTGdk3td/N94QXUyDi4AenfeFF3K6HVI9DwZm8B4kPX/qp4pU
         f4Q+tkAhC08Y5fV27yW0Z90Wd1g5lUT5rcfe5c83CMN8q4WfR2L2ty71v/+9SDxHVbnn
         eevuh/E5o/fzfaiN/dBS4ElbEiUXoCBsg14eJtnW05hcYxy5JeJBCvsW0nSJd7g1sMt1
         KLPmBtL8rT3UBkHpfYQ5c8rNDstBo6b0iBfr0fBloQOvglu7zrIigMPLrIpGV70KAT9+
         tA/ILt/638H22+1FSyt98rc41zjYrNzEsRMuOq+88zIMiiBNM/Qn39lsLEWanpFVbUoS
         iL8g==
X-Gm-Message-State: APjAAAWOyZDQ3M0IVbOhpJezHJ7fA+fvYrv2h0jZwFzHHc5d7of6WBHC
	IzkiHNKs8nGOPamQdL/W9UakpQ==
X-Google-Smtp-Source: APXvYqwDkiPe9QcC56HDzKbFpSDcux+/szyMRAC1FrI8vCpRXJZ+Zvk6cVAbLDnkgDUk8X+BUPgSdQ==
X-Received: by 2002:aa7:9839:: with SMTP id q25mr3393369pfl.161.1575132505642;
        Sat, 30 Nov 2019 08:48:25 -0800 (PST)
Date: Sat, 30 Nov 2019 08:48:23 -0800
From: Kees Cook <keescook@chromium.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Kassad <aashad940@gmail.com>, kernel-hardening@lists.openwall.com
Subject: Re: Contributing to KSPP newbie
Message-ID: <201911300846.E8606B5B2@keescook>
References: <CA+OAcEM94aAcaXB17Z2q9_iMWVEepCR8SycY6WSTcKYd+5rCAg@mail.gmail.com>
 <20191129112825.GA27873@lakrids.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191129112825.GA27873@lakrids.cambridge.arm.com>

On Fri, Nov 29, 2019 at 11:29:13AM +0000, Mark Rutland wrote:
> On Thu, Nov 28, 2019 at 11:39:11PM -0500, Kassad wrote:
> > Hey Kees,
> > 
> > I'm 3rd university student interested in learning more about the linux kernel.
> > I'm came across this subsystem, since it aligns with my interest in security.
> > Do you think as a newbie this task https://github.com/KSPP/linux/issues/11 will
> > be a good starting point?
> 
> I think this specific task (Disable arm32 kuser helpers) has already
> been done, and the ticket is stale.

Oh, thank you! I entirely missed both of these commits. I've added
notes to the bug and closed it.

> 
> On arm CONFIG_KUSER_HELPERS can be disabled on kernels that don't need
> to run on HW prior to ARMv6. See commit:
> 
>   f6f91b0d9fd971c6 ("ARM: allow kuser helpers to be removed from the vector page")
> 
> On arm64, CONFIG_KUSER_HELPERS can be disabled on any kernel. See
> commit:
> 
>   1b3cf2c2a3f42b ("arm64: compat: Add KUSER_HELPERS config option")

(Typo: a1b3cf2c2a3f42b)

-Kees

> 
> Thanks,
> Mark.

-- 
Kees Cook
