Return-Path: <kernel-hardening-return-18052-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 5BA391777EA
	for <lists+kernel-hardening@lfdr.de>; Tue,  3 Mar 2020 14:58:25 +0100 (CET)
Received: (qmail 1675 invoked by uid 550); 3 Mar 2020 13:58:20 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1638 invoked from network); 3 Mar 2020 13:58:19 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jbcRkVBxSbJptVd45Z925xp04oFQnSe/xFiehp4Z2HY=;
        b=DwhrlK2SAnNEc310PFtb/wtiEb9o2QG+UHkXx02enw/+bZgoV6Vd5k8t+bCxIS1KL0
         CiIHCR8bIHYIzYgCbotrzwPNaxWcGCBo6bso4emMvUjLbFuXSSHRESWkUWD1Uu5k7FRM
         4Vp1SoFKTD3zxA2iouOs+1gHuAxgPAHCjdmx9y3Z64VomIGs1W9TJARAEn9XvapU495J
         4uzCui4iWa676vBWfxjW4CTO6BjHIQ1Lckvx+aAJsinjy77isJjFM9chRYG35xDZGopB
         KL5XmcSMPD2RhSW0TpDuMNH3knppvSaAvflJgJyYCfpOQQnkPBwctXg5GgtAQnOfAh4L
         8qCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jbcRkVBxSbJptVd45Z925xp04oFQnSe/xFiehp4Z2HY=;
        b=WTOI58v2aEWCrdjAiSl0Vp134gIKV8bNExUmJEVPYYvLqHGZik05vBDZcImmyYPfl3
         NBgFh5kAxpiZxIkyhM4H6MuxVwA9zEfMBEZ123/35zm8qaoXFIosY/zB9WMLSDOiPgn6
         zxhC8WSOh5mP4f6NAiPz9pc9WRI59Oz8DPISK2poyFUuld/+h8QTcJcxBIIQuqWusoOB
         NGL9Y7+qrHZ8MrEZPucop3hR6jL64MyRiH0MaSpJqwY6OoP/ScnmRX1AZqi2kU3E+4aQ
         sPhUOv1fjcGBfIS8QWznjUiXhBRCoEuAMZAgR8x+nWRJDq8dybfEjwR5LJFzAyHV0fa1
         NiBQ==
X-Gm-Message-State: ANhLgQ2T3ccEj24dMpms3IrJKJvduCK2sZbauBesEwm3Fre+zX+MlzgN
	1wZh1x4VBamezH0yLzd9v5oT3JRNm0AzKwGu0nu2uQ==
X-Google-Smtp-Source: ADFU+vsOF73UPQUHQMvLyMi287mQvulbkayIZkhYFakbOdqU0mvsrMAl1bBqLrnm9Y8XjItDIaCeUz4e0WfTPYOhbTA=
X-Received: by 2002:a05:6830:11a:: with SMTP id i26mr3553549otp.180.1583243886992;
 Tue, 03 Mar 2020 05:58:06 -0800 (PST)
MIME-Version: 1.0
References: <20200303105427.260620-1-jannh@google.com> <CAKv+Gu82eEpZFz5Qto+BnKifM4duv8sBTx3YhLXU8ZPPsND+Rg@mail.gmail.com>
In-Reply-To: <CAKv+Gu82eEpZFz5Qto+BnKifM4duv8sBTx3YhLXU8ZPPsND+Rg@mail.gmail.com>
From: Jann Horn <jannh@google.com>
Date: Tue, 3 Mar 2020 14:57:40 +0100
Message-ID: <CAG48ez1u-CB8dW4iaH8zpdaUxb-kY4VDPVWPAoNOQKhnhsZkkg@mail.gmail.com>
Subject: Re: [PATCH v2] lib/refcount: Document interaction with PID_MAX_LIMIT
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Will Deacon <will@kernel.org>, Kees Cook <keescook@chromium.org>, 
	Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	kernel list <linux-kernel@vger.kernel.org>, Elena Reshetova <elena.reshetova@intel.com>, 
	Hanjun Guo <guohanjun@huawei.com>, Jan Glauber <jglauber@marvell.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Mar 3, 2020 at 2:07 PM Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> On Tue, 3 Mar 2020 at 11:54, Jann Horn <jannh@google.com> wrote:
> >
> > Document the circumstances under which refcount_t's saturation mechanism
> > works deterministically.
> >
> > Signed-off-by: Jann Horn <jannh@google.com>
>
> I /think/ the main point of Kees's suggestion was that FUTEX_TID_MASK
> is UAPI, so unlikely to change.

Yeah, but it has already changed three times in git history:

76b81e2b0e224 ("[PATCH] lightweight robust futexes updates 2"):
0x1fffffff -> 0x3fffffff
d0aa7a70bf03b ("futex_requeue_pi optimization"): 0x3fffffff -> 0x0fffffff
bd197234b0a6 ("Revert "futex_requeue_pi optimization""): 0x0fffffff ->
0x3fffffff

I just sent a patch to fix up a comment that still claimed the mask
was 0x1fffffff... so I didn't want to explicitly write the new value
here.

While making the value *bigger* would probably be a bit hard (and
unnecessary), making it smaller would be fairly easy here - the field
is populated by userspace, so even though the mask is 0x3fffffff,
userspace will never set the upper bits, so they're effectively
reserved bits with value 0.
