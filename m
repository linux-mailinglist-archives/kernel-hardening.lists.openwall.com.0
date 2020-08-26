Return-Path: <kernel-hardening-return-19667-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id B30D625386D
	for <lists+kernel-hardening@lfdr.de>; Wed, 26 Aug 2020 21:41:08 +0200 (CEST)
Received: (qmail 30488 invoked by uid 550); 26 Aug 2020 19:41:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 30462 invoked from network); 26 Aug 2020 19:41:02 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dSakW77xCiSA5fE92SUgWSBVc4QxiTq31NeLlsC4iFg=;
        b=VWhtWvqrmDlLgP5IoVdxqiPa54SABR3BHMz8veK4DE7RS5r9FdBeTxrta0h0MeqBNj
         MtlYu0R3sWrjlNeBq2vpa4ed25Es3FS2palRH/FeV8ZVJ7p0W3xyPaDQTfr24TqanHmn
         LFLB1QRKPHSwsqeXR/wncpgGF5/+A4Dm3qZ7A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dSakW77xCiSA5fE92SUgWSBVc4QxiTq31NeLlsC4iFg=;
        b=iS95q6i9hO+dNjyUVYHwGwoQhyHszxldyu0vggdvtsknl5XD1tH2HdG76eUKtf+JBP
         3l4hlJFcXfPWpkiM0/cZHTGsIYFeQzq9000Zs5Lha0S10zfrvitbp9Gk2N8+hCfxyefe
         2IlEXd9z6OTu8wstbhbPp+E+8CtNlaez666ml1K0+XjZ2EkLyy9aIueIF2h1yJBq/fv4
         vvuvfpc5sjVyHNi7WPNlHQViPFF214eMJRUIDcLbQPBeie4p4+tRcm5hAF8GCGfSkbiL
         B39q8hNkUjx38d748VqzNOan9I9i5loXXuQ3nSeLlmybXrshY9qzvCp3FFriNO2K6lwz
         XLJQ==
X-Gm-Message-State: AOAM531ihkHrdK6qb9IxYFjfo8LtswuDUCpZkIYe2ZaJoW6q6dpEO/NY
	//eLtg5EthNTLQPsmgjrm48EuA==
X-Google-Smtp-Source: ABdhPJyXEKxXHXf5cRg3/3OzMrYtkIyhnNNSdxI6Puywl/QUiLpeWpXICM+kla3UsLYeJUISDEHNYg==
X-Received: by 2002:a63:cd56:: with SMTP id a22mr11535786pgj.259.1598470850778;
        Wed, 26 Aug 2020 12:40:50 -0700 (PDT)
Date: Wed, 26 Aug 2020 12:40:48 -0700
From: Kees Cook <keescook@chromium.org>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	Jann Horn <jannh@google.com>, Jeff Moyer <jmoyer@redhat.com>,
	linux-fsdevel@vger.kernel.org, Sargun Dhillon <sargun@sargun.me>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Stefan Hajnoczi <stefanha@redhat.com>, linux-kernel@vger.kernel.org,
	Aleksa Sarai <asarai@suse.de>, io-uring@vger.kernel.org
Subject: Re: [PATCH v4 1/3] io_uring: use an enumeration for
 io_uring_register(2) opcodes
Message-ID: <202008261240.CC4BAB0CBD@keescook>
References: <20200813153254.93731-1-sgarzare@redhat.com>
 <20200813153254.93731-2-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200813153254.93731-2-sgarzare@redhat.com>

On Thu, Aug 13, 2020 at 05:32:52PM +0200, Stefano Garzarella wrote:
> The enumeration allows us to keep track of the last
> io_uring_register(2) opcode available.
> 
> Behaviour and opcodes names don't change.
> 
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
