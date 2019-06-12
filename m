Return-Path: <kernel-hardening-return-16101-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 80B174193C
	for <lists+kernel-hardening@lfdr.de>; Wed, 12 Jun 2019 02:05:37 +0200 (CEST)
Received: (qmail 7640 invoked by uid 550); 12 Jun 2019 00:05:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 7609 invoked from network); 12 Jun 2019 00:05:29 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=twnhTVYd7tn35O7vvlIa3XEgKYk2/zieh7kgQ5Ms1VY=;
        b=iDBd+Nyh60vWHvSGtVHWVETugM2fnnm+FqmmiJZ56NZHl6V9Aty9AmjFW8CRdEnVVB
         aGKuXc3BMI1WRmMN59ZmT1r6kVO7qzb4q1bDpYmpS/ZUrVuenxbQGoF2Qv4WS5P5xTYu
         MgUGL2vvXlsZ04GvxKv4oWOnyz8mNGE24H+bdBFJTo0aHTJ0k0u+7bh9tcE9VNAMwAtH
         iKtxqCy1DSmKDdJUUU93WbsyygyX8RtwvZ5Owd5cCDJ9ZU6yAlx8+gKU6PDNIGy1Yrds
         5FOvUqOWwAWAd5bt0eEYz6DGK7Ot7sHrl6lNbuwYOmPXTEQ7T1WTuP7Qnyr0A/A07xpx
         QkCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=twnhTVYd7tn35O7vvlIa3XEgKYk2/zieh7kgQ5Ms1VY=;
        b=PL+gDD7LEvbGT1TEMDxKbJEr5dXL6RhPoCSxa1G6cYLTj2mU+vC1dVJvC+kDC9rcFd
         DomrCA1LxddgPBQUe7sMr9LxmW6Dv5lKHScnemjoA/8s5Ihsnyjx/MgyI2unEl3tWObi
         +8deYhluv6uHFM32lis5OlnbU84iVuyDxj//oYi+PxIIpj4ukmJ+BUTJkilwoCXEhcb6
         rhmuJXQ1dKz4h2qiS69HvSFNeZjATqAJQB0xEBKP58WoB9fAOUCSPu6Q/Ub6sXvJM+Y3
         17lyd/kbFhB/MhxZM/9tUmWUbqIjIx4fv50c8rRXf+iP6ZReow7//MoIRNmE9Yo7rfXW
         M1wg==
X-Gm-Message-State: APjAAAVOQSbJZKk6qVoRaD56mpcEEJ2EjIT4QuK9nwABfchtnGViHHoh
	6C9O3maB/iO8Xf7D0yzQMtZh8EarTsNEWdV0mYY=
X-Google-Smtp-Source: APXvYqyO/Oi3PmoK5iJ0YzdPrMw5xZcqUF1R75rhMCOs6SLJy8NUkUXX4LUB1wFJr6ZxPQT0SJAlgxYZrwxAPMCixo8=
X-Received: by 2002:a2e:298a:: with SMTP id p10mr12710225ljp.74.1560297918252;
 Tue, 11 Jun 2019 17:05:18 -0700 (PDT)
MIME-Version: 1.0
References: <20190611193836.2772-1-shyam.saini@amarulasolutions.com>
In-Reply-To: <20190611193836.2772-1-shyam.saini@amarulasolutions.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Tue, 11 Jun 2019 17:05:06 -0700
Message-ID: <CAADnVQKwvfuoyDEu+rB8=btOi33LdrUvk4EkQM86sDpDG61kew@mail.gmail.com>
Subject: Re: [PATCH V2] include: linux: Regularise the use of FIELD_SIZEOF macro
To: Shyam Saini <shyam.saini@amarulasolutions.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kees Cook <keescook@chromium.org>, linux-arm-kernel@lists.infradead.org, 
	linux-mips@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org, 
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	Network Development <netdev@vger.kernel.org>, linux-ext4@vger.kernel.org, 
	devel@lists.orangefs.org, linux-mm <linux-mm@kvack.org>, linux-sctp@vger.kernel.org, 
	bpf <bpf@vger.kernel.org>, kvm@vger.kernel.org, mayhs11saini@gmail.com
Content-Type: text/plain; charset="UTF-8"

On Tue, Jun 11, 2019 at 5:00 PM Shyam Saini
<shyam.saini@amarulasolutions.com> wrote:
>
> Currently, there are 3 different macros, namely sizeof_field, SIZEOF_FIELD
> and FIELD_SIZEOF which are used to calculate the size of a member of
> structure, so to bring uniformity in entire kernel source tree lets use
> FIELD_SIZEOF and replace all occurrences of other two macros with this.
>
> For this purpose, redefine FIELD_SIZEOF in include/linux/stddef.h and
> tools/testing/selftests/bpf/bpf_util.h and remove its defination from
> include/linux/kernel.h

please dont. bpf_util.h is a user space header.
Please leave it as-is.
