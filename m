Return-Path: <kernel-hardening-return-16085-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 3104C3BDA1
	for <lists+kernel-hardening@lfdr.de>; Mon, 10 Jun 2019 22:41:13 +0200 (CEST)
Received: (qmail 27986 invoked by uid 550); 10 Jun 2019 20:41:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 27947 invoked from network); 10 Jun 2019 20:41:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1bIiiq1tcSBUPb0mAkHhzOcciNt5GC9EVK4d9EOEoME=;
        b=lw2YNlQl9J026XmcbaLozeN5ncERuzyxgk3W2IJmIUEfKS9rgQ3vYBPtyqQFCQ4Scf
         i9jwBI5eZjVn9/APiXXX06/J8TUwr6y+5e92FWMCfExwClayFUOopY7C9sRun53l8kgk
         exQCzEWyXRXRSf9g4uBdFCIxgYBuvJ2hF67No=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1bIiiq1tcSBUPb0mAkHhzOcciNt5GC9EVK4d9EOEoME=;
        b=T8ZlcnlZYZKzhHKwHzeK5C201AG4wmruuoDEQRnszW3BBe5IyZusTAVT1hEcyO/ZqA
         OIl04PawH30a0zeAQzTo6CxXPuEKQOZoN3+dXd/xltC758kTDYBZkTmLchtdc57DVGfU
         NBPqNyayTZnvdlfcKLdd2H3Har8zQXbXjyLLCQQJBRnokVLcsZrcbL/tR+1gPA2wx08h
         HHuBU11ofPKbD/FPxHfWV7G3o+zRp5oV7+MFMuUnF/xzT160RWBTuRRqV2UKonX+6SAX
         Dc9wnDfsYyALLfAtCixRC8nh+xJClA/q36Zvw/u4x9Q/gRt0KkFURzQE1LhpB9+iwzgd
         zGlQ==
X-Gm-Message-State: APjAAAUSXb87oTeuvjCk4QGqDpq9Y83zbcmLMApqIZOL5E8UykSsAIqU
	QIWHEIRxFYc8U/mPTmSeUo3Mew==
X-Google-Smtp-Source: APXvYqyDpLSLCPFjQ8zmnGSsAdX6zCWwCbBUcpH9JlOpZMO3AtcTW7iMbM33HkmVPQwrXtDu0u723A==
X-Received: by 2002:a17:90a:5884:: with SMTP id j4mr24062347pji.142.1560199254664;
        Mon, 10 Jun 2019 13:40:54 -0700 (PDT)
Date: Mon, 10 Jun 2019 13:40:52 -0700
From: Kees Cook <keescook@chromium.org>
To: Andy Lutomirski <luto@kernel.org>
Cc: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/5] x86/vsyscall: Document odd #PF's error code for
 vsyscalls
Message-ID: <201906101340.AE18F49@keescook>
References: <cover.1560198181.git.luto@kernel.org>
 <d28856fff74a385f88c493dafb9d96d2c38d91a2.1560198181.git.luto@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d28856fff74a385f88c493dafb9d96d2c38d91a2.1560198181.git.luto@kernel.org>

On Mon, Jun 10, 2019 at 01:25:29PM -0700, Andy Lutomirski wrote:
>  tools/testing/selftests/x86/test_vsyscall.c | 9 ++++++++-

Did this hunk end up in the wrong patch? (It's not mentioned in the
commit log and the next patch has other selftest changes...)

-- 
Kees Cook
