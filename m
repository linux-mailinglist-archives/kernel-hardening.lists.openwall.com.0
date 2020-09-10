Return-Path: <kernel-hardening-return-19851-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id E9A3E264CE9
	for <lists+kernel-hardening@lfdr.de>; Thu, 10 Sep 2020 20:29:58 +0200 (CEST)
Received: (qmail 30355 invoked by uid 550); 10 Sep 2020 18:29:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 30323 invoked from network); 10 Sep 2020 18:29:52 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wjAWuNbVBoEPyXn+QBzLMnCnG3b1YEYkoDZS6EgQpPI=;
        b=UCp+FppW+25RCEWuidrdmD2H7oNwJWAPscXMA2ljdT7Hwfc6emJQQRXJKlonqRXwCr
         ZNZwT1diexj1oIPFx0vZRCKp8ePiBMfI0fNJK+PDlwitnt2/pXVXXfcmv7xMHDx85MGD
         jjgpGgVOnGdOdetQ71hUdu1jBGb560fU84u+I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wjAWuNbVBoEPyXn+QBzLMnCnG3b1YEYkoDZS6EgQpPI=;
        b=JyjvuIVO93EM3XgwOyxV6USwfLZE1UUy9fHgKFbFzWTNTFO1ok420cmWFFWkyNheYz
         /Q/1WyFuBO8P3JRMU5Gq1K22SkY60L9wOGTe7Jm8kTfl72IKgOanot+LiNl2RIUQnp1z
         hwx951ssy6Cp+lLiGIC6xq0FNJksB1J7ywd5ljjx5t2+2NnOINHSooO/4fluxz28JRgd
         /BT3rNKKU0wjjppHwFFcOjQTB7gmE5g/eLhD5h/FU0degI9pO3GUTf8LBe3RfTdbHxNt
         dxz0Qy1robDq7yVh6+n53snBcmtRwomjGjhW1uJz02cwMTgPca6568y/4V1J8VI1SrvX
         bHQw==
X-Gm-Message-State: AOAM530uC3DUb5lvPQmbjKFVQRfV81ZcIQN8k4cgy/4I7yG7yCW5XWs5
	guwaaW5mVzijVd+kIaeQj1nPBw==
X-Google-Smtp-Source: ABdhPJwQHia5IxoItB0v8TFyFBQYaMjt9d9oEodKfnuR8Fqxq3O6+WSooIjqvBiG9AzcqTroMIMGDQ==
X-Received: by 2002:a17:90b:3717:: with SMTP id mg23mr1229702pjb.42.1599762580221;
        Thu, 10 Sep 2020 11:29:40 -0700 (PDT)
Date: Thu, 10 Sep 2020 11:29:38 -0700
From: Kees Cook <keescook@chromium.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Sami Tolvanen <samitolvanen@google.com>, peterz@infradead.org,
	Masahiro Yamada <masahiroy@kernel.org>,
	Will Deacon <will@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux <clang-built-linux@googlegroups.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-arch <linux-arch@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	linux-kbuild <linux-kbuild@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
	X86 ML <x86@kernel.org>
Subject: Re: [PATCH v2 05/28] objtool: Add a pass for generating __mcount_loc
Message-ID: <202009101127.28B4414D2A@keescook>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200903203053.3411268-1-samitolvanen@google.com>
 <20200903203053.3411268-6-samitolvanen@google.com>
 <202009031450.31C71DB@keescook>
 <CABCJKueF1RbpOKHsA8yS_yMujzHi8dzAVz8APwpMJyMTTGhmDA@mail.gmail.com>
 <20200904093104.GH1362448@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200904093104.GH1362448@hirez.programming.kicks-ass.net>

On Fri, Sep 04, 2020 at 11:31:04AM +0200, peterz@infradead.org wrote:
> On Thu, Sep 03, 2020 at 03:03:30PM -0700, Sami Tolvanen wrote:
> > On Thu, Sep 3, 2020 at 2:51 PM Kees Cook <keescook@chromium.org> wrote:
> > >
> > > On Thu, Sep 03, 2020 at 01:30:30PM -0700, Sami Tolvanen wrote:
> > > > From: Peter Zijlstra <peterz@infradead.org>
> > > >
> > > > Add the --mcount option for generating __mcount_loc sections
> > > > needed for dynamic ftrace. Using this pass requires the kernel to
> > > > be compiled with -mfentry and CC_USING_NOP_MCOUNT to be defined
> > > > in Makefile.
> > > >
> > > > Link: https://lore.kernel.org/lkml/20200625200235.GQ4781@hirez.programming.kicks-ass.net/
> > > > Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> > >
> > > Hmm, I'm not sure why this hasn't gotten picked up yet. Is this expected
> > > to go through -tip or something else?
> > 
> > Note that I picked up this patch from Peter's original email, to which
> > I included a link in the commit message, but it wasn't officially
> > submitted as a patch. However, the previous discussion seems to have
> > died, so I included the patch in this series, as it cleanly solves the
> > problem of whitelisting non-call references to __fentry__. I was
> > hoping for Peter and Steven to comment on how they prefer to proceed
> > here.
> 
> Right; so I'm obviously fine with this patch and I suppose I can pick it
> (and the next) into tip/objtool/core, provided Steve is okay with this
> approach.

Hello Steven-of-the-future-after-4000-emails![1] ;)

Getting your Ack on this would be very welcome, and would unblock a
portion of this series.

Thanks! :)

[1] https://twitter.com/srostedt/status/1303697650592755712

-- 
Kees Cook
