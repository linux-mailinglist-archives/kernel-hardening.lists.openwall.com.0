Return-Path: <kernel-hardening-return-20096-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id AC18928429A
	for <lists+kernel-hardening@lfdr.de>; Tue,  6 Oct 2020 00:39:46 +0200 (CEST)
Received: (qmail 11406 invoked by uid 550); 5 Oct 2020 22:39:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 11348 invoked from network); 5 Oct 2020 22:39:40 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fIoPd7FinJm3q9ARvRH5Nl20y+MTyHzjskcOjhWw2XA=;
        b=ibqSmXVNNpgEoMq7K2TPcLI5XyaBqb9Xn8O7+WEcFmp2w4hBzhSbqBpBIWx7crQnT2
         KdfUoVeK/AwG6EQ9tnopcO32zNyb5OARlnLg2h27D3K26NcdoFjGdFNF5JXfEOzkIQke
         1jdUU2u5KmJb3bZA3iZSI+Wl1aS5kD+2ItDQM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fIoPd7FinJm3q9ARvRH5Nl20y+MTyHzjskcOjhWw2XA=;
        b=Mx2Yse+C5pJ7Bx/wfp2Vwh1ToCZQrVy8msC1f7T94eaECOl5HhSxeSii05b+ZDDHkz
         SjW3K9Gsx+dh0+/UR32m/Y6LDWJezIMmZgHdWA5XqlEcOMAkEGes4ffFGjk9otBjFFYj
         n5XEsirRotslmascqYkzIAI04tZBDY4J+lYbXfD19spo6AQHsTlEQoItIFJf6MBQQKbc
         t6/R4YCiYNSCKKsBZAKbG9He0rnHaLuUyTrG4EeBsXsmrSCxCMohAi3vD4s/VkuHfvVt
         a6twYQ6ZqQi2JV5rLx4N8sCHeRvnvabXcFp3wSZOMbWUnehzthc82yHQFII4tHG73YLE
         VSVQ==
X-Gm-Message-State: AOAM532C/tkN+oG/kGKn0e7XaB2EFhU7J3hjAVf8JhSSvBSoH8KoUsht
	YhdJmdrjAGEiCfySfVOIcbeBmQ==
X-Google-Smtp-Source: ABdhPJxL9pSB42Fin8DjVFQfTJrdQvlaceXjGATgKNwGQSMexY8o2CgeQC6hXJAlCIXrypZAhK+80A==
X-Received: by 2002:a17:902:9b8f:b029:d3:89e2:7956 with SMTP id y15-20020a1709029b8fb02900d389e27956mr598517plp.18.1601937567876;
        Mon, 05 Oct 2020 15:39:27 -0700 (PDT)
Date: Mon, 5 Oct 2020 15:39:26 -0700
From: Kees Cook <keescook@chromium.org>
To: Jann Horn <jannh@google.com>
Cc: Solar Designer <solar@openwall.com>, "Theodore Y. Ts'o" <tytso@mit.edu>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-hardening@vger.kernel.org
Subject: Re: Linux-specific kernel hardening
Message-ID: <202010051538.55725193C7@keescook>
References: <202009281907.946FBE7B@keescook>
 <20200929192517.GA2718@openwall.com>
 <202009291558.04F4D35@keescook>
 <20200930090232.GA5067@openwall.com>
 <20201005141456.GA6528@openwall.com>
 <20201005160255.GA4540@mit.edu>
 <20201005164818.GA6878@openwall.com>
 <CAG48ez0MWfA8zPxh5s5i2w9W7F+MxfjMXf6ryvfTqooomg1HUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez0MWfA8zPxh5s5i2w9W7F+MxfjMXf6ryvfTqooomg1HUQ@mail.gmail.com>

On Tue, Oct 06, 2020 at 12:26:50AM +0200, Jann Horn wrote:
> On Mon, Oct 5, 2020 at 6:48 PM Solar Designer <solar@openwall.com> wrote:
> > If 100% of the topics on linux-hardening are supposed to be a subset of
> > what was on kernel-hardening, I think it'd be OK for me to provide the
> > subscriber list to a vger admin, who would subscribe those people to
> > linux-hardening.
> 
> (if folks want to go that route, probably easier to subscribe the list
> linux-hardening@ itself to kernel-hardening@ instead of syncing
> subscriber lists?)

Yeah, that would make things a bit simpler. Solar, would you be willing
to do that? (Then I can tweak the wiki instructions a bit more.)

-- 
Kees Cook
