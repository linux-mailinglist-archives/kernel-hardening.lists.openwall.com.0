Return-Path: <kernel-hardening-return-20095-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 4F9A928427E
	for <lists+kernel-hardening@lfdr.de>; Tue,  6 Oct 2020 00:27:34 +0200 (CEST)
Received: (qmail 3836 invoked by uid 550); 5 Oct 2020 22:27:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3803 invoked from network); 5 Oct 2020 22:27:28 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s1mfjLEDGEzWlccxnSMQEr7jNWf7euYCoYzxl2zCems=;
        b=RkKssiqHlG8Ofs/kGT7I6glvfRARgo8371PQIo6lDOxaDBDCLhPpSpudvcMAeYWbk5
         bmOkuzC2IrILpZKOZBXXB3QWraCQ1PEpL6C4EgsNb9TwSC7rAs1sL7KAgW3OH9Vqb04e
         XyRKO3935rMtgweMc7i+Ll3SUo3iyAh2nD+QWfavaK4RO3OZ2yIms5jtXpiiuri4AGj0
         97icN5ESgWsCBKJkFt9cSN5OSn4K9ZCOvxe/Ykv1EfuXMaTHtqO5jLbb5kXDxvFOzpEm
         ZAASmLzmmK3N4k20KmPkF3nZ7hW1Q5lsxFJch7+kx5WqjOUfmlsnfncJinq/XM23NCEf
         TCeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s1mfjLEDGEzWlccxnSMQEr7jNWf7euYCoYzxl2zCems=;
        b=HW9qRAZuRzRhWuzPIzgMYf9hgM1s/mphhJQ6Vmr5xUB3pv+toZDtwVbWFMq7T9W5cb
         rake11Kuh2kik9svqams7SdJi3e+yHdFfiVOv4VySEYEG0zesjWPNQs3GQaLPTODZ8zo
         102BSB9E5zqYxtbbWgVhkJXAZfCsvpCuWLVclFPLAl1t7KZGdmEaDbLHVwCYIzr6xeBJ
         +tFxoRnCo+fTVjZT8SIBCxklhS9xU8iN/CqqWfJkDV+EdIXE6mC8Uckv5VEPp/ExBUmB
         SSYDmhyIi9arjI8KFaHqnjo+f4a+ZkqwZbnm+wYbNCkX1HV1hiAz3JeSQljAE27y3c1D
         ec0A==
X-Gm-Message-State: AOAM5324j/M4/77N6KwB0tOLiMe+FZjNFRw+JZhY0kAkYE9hCM0UDlQp
	LZqZ+/Q6turE9+RKiIiD5i17m2Au9GWHyyG5/lnFfQ==
X-Google-Smtp-Source: ABdhPJyviSfinqf2/Q4zwP/9ZqeAoiARX7ogGuTHGIzGBdPGBlosoYOw9O1TBXzd7Y+CwYLTK/GJ7VI20IR90sLo6j8=
X-Received: by 2002:a17:906:86c3:: with SMTP id j3mr1977865ejy.493.1601936836914;
 Mon, 05 Oct 2020 15:27:16 -0700 (PDT)
MIME-Version: 1.0
References: <202009281907.946FBE7B@keescook> <20200929192517.GA2718@openwall.com>
 <202009291558.04F4D35@keescook> <20200930090232.GA5067@openwall.com>
 <20201005141456.GA6528@openwall.com> <20201005160255.GA4540@mit.edu> <20201005164818.GA6878@openwall.com>
In-Reply-To: <20201005164818.GA6878@openwall.com>
From: Jann Horn <jannh@google.com>
Date: Tue, 6 Oct 2020 00:26:50 +0200
Message-ID: <CAG48ez0MWfA8zPxh5s5i2w9W7F+MxfjMXf6ryvfTqooomg1HUQ@mail.gmail.com>
Subject: Re: Linux-specific kernel hardening
To: Solar Designer <solar@openwall.com>
Cc: "Theodore Y. Ts'o" <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, Oct 5, 2020 at 6:48 PM Solar Designer <solar@openwall.com> wrote:
> If 100% of the topics on linux-hardening are supposed to be a subset of
> what was on kernel-hardening, I think it'd be OK for me to provide the
> subscriber list to a vger admin, who would subscribe those people to
> linux-hardening.

(if folks want to go that route, probably easier to subscribe the list
linux-hardening@ itself to kernel-hardening@ instead of syncing
subscriber lists?)
