Return-Path: <kernel-hardening-return-16680-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id ABC097CD4F
	for <lists+kernel-hardening@lfdr.de>; Wed, 31 Jul 2019 21:58:25 +0200 (CEST)
Received: (qmail 30196 invoked by uid 550); 31 Jul 2019 19:58:20 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 30161 invoked from network); 31 Jul 2019 19:58:19 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NfIspcnc/2t7LWXrdNE+ubsJCC83+V9yAq4B7B5lNHE=;
        b=Q4jgwY+JqY8cWP5Ba3AUxsKHoDBJfSroGhiXbMR6OrTJimuIBMapLxpymuNCBbRYxm
         ncoDEJL5taLB4w3SrlTtacnLIUIGo18Ay/EoIuMP3Iq+TOLJs1WFQHKC2FYJFAYTKqjY
         XJ9EHmGJnbi6QNDD4KlOHD+Wnl3OqbAoM7DXQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NfIspcnc/2t7LWXrdNE+ubsJCC83+V9yAq4B7B5lNHE=;
        b=sNnewRn9HqyjgMjhlIBaSFjh+4zVcK5Trn7p1lPUTe/uEFCiMPjzdrH3R8DUKpk7aC
         5ruUjqwvAXSCYR/x9s4h6Bi5R30Vq2qVD0sFTu50ivXuCfZNimqmtY6DLP/ck4KtnOLo
         1BaNjQTT5HPWXfPy2reH3Fl4O4bzozhqtoRFpAVccc7+u+ah3fbOLE0dN2ZAOkqN99Rf
         uySXjZKI1dS5xMhiX7L8wvW1IAa7WsXuUvJGaMOcqnCiluI2rTtQSdVGaeLztPCmAFMC
         PeS7qeP5XebbbaWAI4bf2IJBd0MB9f9tAEJkjOwSZcM6EZiNhybJxryvO0hYxWj0tdLx
         L/NQ==
X-Gm-Message-State: APjAAAVNrktolCjqPzUPWnKqcdl0gmf7C4gc/AbnvIZJD2Yfa7Nc0g0g
	IIsEhFH/abL0U3LUiTADeisf5A==
X-Google-Smtp-Source: APXvYqw+WHzdDfbYGy29+WSP8iMiYjFhVylC6I4hxMOf3DMb3RNqGFamdATEt9zqoJx2J75sr60bUA==
X-Received: by 2002:a17:902:8205:: with SMTP id x5mr123929051pln.279.1564603088343;
        Wed, 31 Jul 2019 12:58:08 -0700 (PDT)
Date: Wed, 31 Jul 2019 12:58:06 -0700
From: Kees Cook <keescook@chromium.org>
To: Joonwon Kang <kjw1627@gmail.com>
Cc: re.emese@gmail.com, kernel-hardening@lists.openwall.com,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	jinb.park7@gmail.com
Subject: Re: [PATCH 1/2] randstruct: fix a bug in is_pure_ops_struct()
Message-ID: <201907311257.8436E997A4@keescook>
References: <cover.1564595346.git.kjw1627@gmail.com>
 <2ba5ebfa2c622ece4952b5068b4154213794e5c4.1564595346.git.kjw1627@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ba5ebfa2c622ece4952b5068b4154213794e5c4.1564595346.git.kjw1627@gmail.com>

On Thu, Aug 01, 2019 at 03:01:10AM +0900, Joonwon Kang wrote:
> Before this, there were false negatives in the case where a struct
> contains other structs which contain only function pointers because
> of unreachable code in is_pure_ops_struct().
> 
> Signed-off-by: Joonwon Kang <kjw1627@gmail.com>

I've applied this (with some commit log tweaks) and it should be visible
in linux-next soon. I'll send this on to Linus before -rc3.

-- 
Kees Cook
