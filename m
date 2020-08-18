Return-Path: <kernel-hardening-return-19652-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 25211247C3A
	for <lists+kernel-hardening@lfdr.de>; Tue, 18 Aug 2020 04:35:03 +0200 (CEST)
Received: (qmail 32156 invoked by uid 550); 18 Aug 2020 02:34:56 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 32124 invoked from network); 18 Aug 2020 02:34:56 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=r6qSDDP/+NWHJZKderJIH858SQwGSgMaSdTfSSplKro=;
        b=hoRdVrRj7S0l3dE5Znd3rWrha+Kk/c/W5+JH35D3RFo5tVfMJpWzQO2rYTmzRlWfMp
         uqi+TB4+BhVLFC/nTVmsvPGxdFJ9VGha+6IhQay1raDhsVqSJ2Ikm5GE0YgvFt6poOVj
         1QHnNDfUdxeIUcN+oBFbfW0T8nB+jlEe+7yopI1QdffNUFTsmV4t54IRXOfQdT/JnJko
         FC1xC4t+rpLCd3fV6SkWsHa7Xs8ALmJ6p2KgZNrKjVsWBFLieen1T25jRNQZzkFUZ6JV
         coQPACXyRgpwNQCo7070KHH0q1JyoqPn8Rv6bTQusR3RPXEwAz3V3wzpvkSuoJiff8lU
         hPYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=r6qSDDP/+NWHJZKderJIH858SQwGSgMaSdTfSSplKro=;
        b=CPn4F+XSfV+xT2LCz76hyfxJfaLePQiw+MmTNh1O5B8rqjHBatVhy3FgnZaMc9/GrG
         /aCfuNChzI9YvOIsVEC2eF9gwqXhKxsZ0ofZYb6Yj7oiIf156ILHFBLm21HtBK20s+x4
         Bs9kmguct4lm+XnVc2criL6l0mFEvj8TTj1c5ELImLq/a5jyGEwR4iGqhGv5zcEq2rGk
         jp8HvKIGz433xhV8d40B89r9jtNy85DHDNZPcNTuJwr6AakdfX3zzcLjWvCwH2+l9m6O
         lwyJJEzrQcYDJWwDi8ZzLW+eIwjNTHKQONHbrKVU+kFuVdU6qxvHc1cI79FIOFBa/IEt
         0PhQ==
X-Gm-Message-State: AOAM532KHvCFBKPIT+94akeIddhX9b6qGbT3MflEmRGZbl79cNqeeDzV
	kmj7zJCW36X19AJjCZkZrbvU2rYVa/qg2Iev8L0sVBGXKk51FQ==
X-Google-Smtp-Source: ABdhPJxvlq0T3hmi3QKxQPQGKQKk5PRsrcegDKQyB4xkKBZjCCMnV4dpMGYKEDtgJ/RsSkvgVuAe5MuPfY7ReUGG+pQ=
X-Received: by 2002:ac2:5f48:: with SMTP id 8mr8521934lfz.157.1597718084208;
 Mon, 17 Aug 2020 19:34:44 -0700 (PDT)
MIME-Version: 1.0
From: Jann Horn <jannh@google.com>
Date: Tue, 18 Aug 2020 04:34:18 +0200
Message-ID: <CAG48ez00pYAER-RrXPBkiw=3W7NkkQ+hNxNXzY-XdXV7JEFBMg@mail.gmail.com>
Subject: usercopy arch_within_stack_frames() is a no-op in almost all modern
 kernel configurations
To: Kernel Hardening <kernel-hardening@lists.openwall.com>, Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"

I was looking at some usercopy stuff and noticed that
arch_within_stack_frames() (the helper used by the usercopy
bounds-checking logic to detect copies that cross stack frames) seems
to be a no-op on almost all modern kernel configurations.

It is only defined for x86 - no implementation for e.g. arm64 exists
at all. The x86 version requires CONFIG_FRAME_POINTER, which is only
selected by CONFIG_UNWINDER_FRAME_POINTER (whereas the more modern
choice, and default, for x86-64 is CONFIG_UNWINDER_ORC).

Personally, I don't feel very attached to that check; but if people
are interested in keeping it, it should probably be reworked to use
the proper x86 unwinder API: unwind_start(), unwind_next_frame(),
unwind_get_return_address_ptr() and unwind_done() together would
probably help with this. Otherwise, it should probably be removed,
since in that case it's pretty much going to just be bitrot?
