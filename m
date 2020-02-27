Return-Path: <kernel-hardening-return-17972-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 5BC531722B6
	for <lists+kernel-hardening@lfdr.de>; Thu, 27 Feb 2020 17:02:59 +0100 (CET)
Received: (qmail 12193 invoked by uid 550); 27 Feb 2020 16:02:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 12173 invoked from network); 27 Feb 2020 16:02:51 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9WYvJWXMZ+rcEfofeSJpHlDz/l6UP/pgxaBPI0bVL+I=;
        b=Qsxn4Hk1uahykr+QWbXHItx2AejCBY1osUAbIGB78L1sCo7B6Il4l6DND0mh7bGD0P
         VEphLT6LKCT7GeIYw8JhWS4IdRBHN9OjLD6OTWcRutDRZdUgwuaqV/hwpz3zxaBidUgO
         ggRjZ0IGbj3DcO3j9UNLtGA9Bagw1dMPj4wqU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9WYvJWXMZ+rcEfofeSJpHlDz/l6UP/pgxaBPI0bVL+I=;
        b=jQo3f2Ld8+IhVOAzHVOjYQ5Tkq0Vhc1OfKSxC+N6biPNvx5tmPza1GQHPmJLPUo2jE
         ZNqdNldmjSG/7edIxp5dL6jNEGjg8cK5c30pH8Hlt2MQSXUpaaIeTJX0Nh3QnOrncDeC
         nQ56OlaEW7fbiNW0eGm3Tz+GOWuik9IIO6NzcBtGyjpWxCPO2lpEsJaQPGL7ISZODVcV
         Mf8GzDm/FM0vDvnpno2nqL0f/tnkj5zLzS+2NYiNMEaAhO4iqTCz6zeJRQbD6kIG1lay
         oBPEcUbMcTZfRVTHhEkCEvLMgNS0KWP1adZJjsEZZrRoZh5GR/hEodAMOAnY6X9eTwIT
         sKwA==
X-Gm-Message-State: APjAAAWv9uA04vUR+V+1cs12jlXEOLC3xW2nSKr6I4c+wLSBL6nGpbDS
	AxRPnzHOx0h+HAaG1AgsMzkaXQ==
X-Google-Smtp-Source: APXvYqwuoISNzfA3MpWinuXHZq6onkj6FotCRgoAwXWcPcaWOvayXN9eZRYUoFiSP4YFJQB9lCtKzA==
X-Received: by 2002:a17:902:265:: with SMTP id 92mr402833plc.292.1582819359541;
        Thu, 27 Feb 2020 08:02:39 -0800 (PST)
Date: Thu, 27 Feb 2020 08:02:37 -0800
From: Kees Cook <keescook@chromium.org>
To: Baoquan He <bhe@redhat.com>
Cc: Kristen Carlson Accardi <kristen@linux.intel.com>, dyoung@redhat.com,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
	arjan@linux.intel.com, rick.p.edgecombe@intel.com, x86@kernel.org,
	linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
	kexec@lists.infradead.org
Subject: Re: [RFC PATCH 09/11] kallsyms: hide layout and expose seed
Message-ID: <202002270802.1CA8B32AC@keescook>
References: <20200205223950.1212394-1-kristen@linux.intel.com>
 <20200205223950.1212394-10-kristen@linux.intel.com>
 <202002060428.08B14F1@keescook>
 <a915e1eb131551aa766fde4c14de5a3e825af667.camel@linux.intel.com>
 <20200227024253.GA5707@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200227024253.GA5707@MiWiFi-R3L-srv>

On Thu, Feb 27, 2020 at 10:42:53AM +0800, Baoquan He wrote:
> On 02/06/20 at 09:51am, Kristen Carlson Accardi wrote:
> > On Thu, 2020-02-06 at 04:32 -0800, Kees Cook wrote:
> 
> > > In the past, making kallsyms entirely unreadable seemed to break
> > > weird
> > > stuff in userspace. How about having an alternative view that just
> > > contains a alphanumeric sort of the symbol names (and they will
> > > continue
> > > to have zeroed addresses for unprivileged users)?
> > > 
> > > Or perhaps we wait to hear about this causing a problem, and deal
> > > with
> > > it then? :)
> > > 
> > 
> > Yeah - I don't know what people want here. Clearly, we can't leave
> > kallsyms the way it is. Removing it entirely is a pretty fast way to
> > figure out how people use it though :).
> 
> Kexec-tools and makedumpfile are the users of /proc/kallsyms currently. 
> We use kallsyms to get page_offset_base and _stext.

AIUI, those run as root so they'd be able to consume the uncensored
output.

-- 
Kees Cook
