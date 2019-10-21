Return-Path: <kernel-hardening-return-17076-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 14697DE8C4
	for <lists+kernel-hardening@lfdr.de>; Mon, 21 Oct 2019 11:59:08 +0200 (CEST)
Received: (qmail 5543 invoked by uid 550); 21 Oct 2019 09:59:02 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 32370 invoked from network); 21 Oct 2019 08:39:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FkZf1mfTenAZ5npBk4cn+CQbe3jHovWF76KrgyJLx8w=;
        b=N4ooVlfl4foXWzVkWo8gSeubv40tW0YIyHY3xEPdiwZPEYHvahXTxq+HtCJjGtbCs3
         cQ4Qc3B9rsi+XX5vpjJHkCgf6lBYaIwE9hWgETGfISr4gFJTQ9D6/snqkZYmU7wsH0lZ
         Hmt7EK+mxcM3j4nAg7kB7jMbFekfupwTK4JacGRkicGNsbGrDoxws89ezq4TBsXQMSoA
         +18WygtUYupUsH8Cl4FJCzQ6Ax+qMV+NRH+gQV6+VONtX8D5Zj3iklxhgNbxy8BN7CGH
         V3Vx+gBHH97z+5Oiz8kIj2UxjRNd8jNkcKI45df5YazbjDuPccFg26h0nPSyOjgzDsqn
         knZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FkZf1mfTenAZ5npBk4cn+CQbe3jHovWF76KrgyJLx8w=;
        b=Ce1tB+GRUJvQ6yMDhRyKpKHFUF+7W4bg3B+ZcZOg/tcTVklSqAKeywDHNY7tD31arQ
         4AFykR+QoQspAYlrGCegYVrlfOH7sTFY00PpO2THK71EGPQ8LdR0UHspAr2zTfwS3rAv
         MVaM2xK6ksS/YtcZIE4FBLsO7WjP46IQUvqixRK10O3FiEyl5ZSuGCklVytWNgKqzpI2
         l3cN7BSaaRMmdHYK6yLkxsFgUVP2NQTXyn1QhDoUGZGthXuxjRAP+l0licmE1hb3tB8C
         9/aFDgbpMgwbdcb2zuTc3JGQGeSAt5Ypcc8KoLgU4DyDuoxOAvpTqaobZHrAp97LQrA7
         4yTA==
X-Gm-Message-State: APjAAAU2rxfIFzQYoVfLn773hbCPdXmbEh1oUF3MseRvDt3NjNJ2r8aO
	aCGYbWwYzxcQMELP0/yzEk0DLCYgY/ee7O3AZfk=
X-Google-Smtp-Source: APXvYqwNfXi6vPia0wYEhJoDqFDYarMj2Ho89gTHurkA9MgMItETpMuiOuhkUlvkHwv9/wEXXply+DCQQn7pbyTo2gE=
X-Received: by 2002:aa7:8210:: with SMTP id k16mr21585016pfi.84.1571647177398;
 Mon, 21 Oct 2019 01:39:37 -0700 (PDT)
MIME-Version: 1.0
References: <2e2a3d3c-872e-3d07-5585-92734a532ef2@gmail.com>
In-Reply-To: <2e2a3d3c-872e-3d07-5585-92734a532ef2@gmail.com>
From: Lukas Odzioba <lukas.odzioba@gmail.com>
Date: Mon, 21 Oct 2019 10:39:26 +0200
Message-ID: <CABob6iq_N8He+ORZuRVqdDhBCuymSwVyRHCsW8GAzXcM8+_tuA@mail.gmail.com>
Subject: Re: How to get the crash dump if system hangs?
To: youling257 <youling257@gmail.com>
Cc: keescook@chromium.org, kernel-hardening@lists.openwall.com, 
	munisekharrms@gmail.com
Content-Type: text/plain; charset="UTF-8"

youling257 <youling257@gmail.com> wrote:
>
> I don't know my ramoops.mem_address, please help me.
>
> what is ramoops.mem_address?

It is a Linux kernel parameter, see documentation below:
https://www.kernel.org/doc/Documentation/admin-guide/ramoops.rst

It requires memory which can hold data between reboots, so i'm not
sure how it will suit your case.

Thanks,
Lukas
