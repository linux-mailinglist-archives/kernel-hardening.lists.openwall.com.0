Return-Path: <kernel-hardening-return-20472-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 394312C92EC
	for <lists+kernel-hardening@lfdr.de>; Tue,  1 Dec 2020 00:45:03 +0100 (CET)
Received: (qmail 15806 invoked by uid 550); 30 Nov 2020 23:44:56 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 15786 invoked from network); 30 Nov 2020 23:44:56 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ja5iGBqziMZwVeGBVGC3tNT2ITsfFSrpoAOQrYPIRMQ=;
        b=eIXhFNYrQLrGwHzLPxYGVzWJa/DjXZ3+RK17U4inbSIH8/cLDO1KD8N72OM/zUzB53
         8yZIeDx97sYjz1uuAvgXJWY765o7D+jPAp3RstXWhEiYWpp6ZfWnqW3rRJRO93eLdG7N
         2D9TsLZvw7lNns1x8kWHXquH6wydBNpMO2aUV+NR7F+6FAuRbZwFPyrw1V0DxEKSqnp1
         vdA7qZ099dTy0qixQPzpa9880t8pAmy3P49uy+98kt3oenJTnRXEAx2MWqQdTsTmzPcS
         FKM8rzdiYWV3COU/X3eovPeyZKHokoQStzQObR4NRJfYg5/2ZfrRz9fPrSbgCSdilzFy
         91tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ja5iGBqziMZwVeGBVGC3tNT2ITsfFSrpoAOQrYPIRMQ=;
        b=kvD9UWvqfVB4y9h6j91nehxaPhuXiFhHpyMHoCfo7xdf0v1WyBSlt2Q74y/L6LEk+S
         jrAxtcttdVcYuxOhIXDnfU6OpY4cb3A4Zv+4lu+fiyC4KDQ4zk98jzx+p7HRLXz/5nZp
         MjMIQPPbV0eKgDvPMwbDLY0ApAGSgabFblMslu7eEO/ZsUU+P3fOLUZjOImtXwC6M4PQ
         QO/T4RIUlmF4A1ksOdfEI3+gbgwGtnlE+z5o9K3KQEXo9iNAb5WO1QwbcUeMqD7UXj7F
         k8jNv+4ICOEz7aZu+wb669r6pXtXUViKWWGpLG5xV6Y6ziU3vaU4d/Mq0POzwk5U+xbG
         th8Q==
X-Gm-Message-State: AOAM533XKJi1c1NliBmWnKrEkuQDuaO6VB4LVU07mQyjEUFmsDN43dNt
	WdJ9xjpztH8jt8/6AcPZbKSgMpZPxyqvXdpODRHcrg==
X-Google-Smtp-Source: ABdhPJwCzKcJqz39IP46Bo7yz6o/13jgHbjOX0vtta6vuRLC/rbSBznCfSrqxtOCA/emfEwjuB/DVNaoOwhY3XJ9gtU=
X-Received: by 2002:a9f:2595:: with SMTP id 21mr286471uaf.33.1606779883895;
 Mon, 30 Nov 2020 15:44:43 -0800 (PST)
MIME-Version: 1.0
References: <20201118220731.925424-1-samitolvanen@google.com>
 <20201118220731.925424-15-samitolvanen@google.com> <20201130115222.GC24563@willie-the-truck>
In-Reply-To: <20201130115222.GC24563@willie-the-truck>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Mon, 30 Nov 2020 15:44:32 -0800
Message-ID: <CABCJKueSjSdpztOsDExCaLyQ+Pip+r6bY=Y1hR=VTOODmoSZMQ@mail.gmail.com>
Subject: Re: [PATCH v7 14/17] arm64: vdso: disable LTO
To: Will Deacon <will@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Josh Poimboeuf <jpoimboe@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, 
	linux-kbuild <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	linux-pci@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, Nov 30, 2020 at 3:52 AM Will Deacon <will@kernel.org> wrote:
>
> On Wed, Nov 18, 2020 at 02:07:28PM -0800, Sami Tolvanen wrote:
> > Disable LTO for the vDSO by filtering out CC_FLAGS_LTO, as there's no
> > point in using link-time optimization for the small about of C code.
>
> "about" => "amount" ?

Oops, I'll fix that in v8. Thanks!

Sami
