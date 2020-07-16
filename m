Return-Path: <kernel-hardening-return-19371-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 54A8C222DDE
	for <lists+kernel-hardening@lfdr.de>; Thu, 16 Jul 2020 23:27:11 +0200 (CEST)
Received: (qmail 5176 invoked by uid 550); 16 Jul 2020 21:27:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 5153 invoked from network); 16 Jul 2020 21:27:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oQxCrdBDFS2fRH6xFMh6bKNwdL/lOdhX2TcgbTw/bOw=;
        b=X1bKofa1qS2JEqLt0jom2OGXcSEoy9mscvmqkSKw8hFEy0fixVyEp97RLhJBv0e25M
         5JKdMVDMSTsC5WlnjOSPEo/tHM7cdH3CZ9iJLQBDMXVrv18QtAElSGku/OwZib6w+YDZ
         DPMZ8zhKkmKok/aW7E+USmDemh/OhbI+MFhZDrPjUCoVLLS8sCH6uu61kaFE8LqZrslC
         +nno3iWJZm1lbiDJXPvnuDBIJyTCQRgTVEJMwwqfZZqcxhsf4+9PRJ+/vK22/BTtxuEB
         LK5CvgOZLaUAjsWE48ccQb8xKsqoO2DrM/MEbnYL7Fyo5JpyMmYLeZBXl7GCDwrWKoSG
         2sWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oQxCrdBDFS2fRH6xFMh6bKNwdL/lOdhX2TcgbTw/bOw=;
        b=ZuZSRU3QyKd8AFS5LpF5UVNH7TH6+l7EhOlhmSCC7PUnMgOjQ9zsGdFByR0xVMJP20
         5sIEMSGG1hqWt2s5xuONj6ZhnQqNRYABLLOwtanwVuL4HFkgvV5e6j5Dmvgnp65Oiz2h
         eIWdZElh1dpNkRdo/l2BJ7WDWH64xvkVgJA7yyURszTiRswJDb3WAmjmGc6cdiEhAvpF
         lRnHNDF4XdiWzNgh0wGJo9j0YKpN8cwWaLGlsW6CGgfMStPdA5dG6mLGFc5nm+4kf/B5
         ZkM+V0lhexvmspncDX5zXPoWLWrHsKMFdfBawn0DfWhHR+CErCqxr0b9J4oe38RS/JsA
         sQXA==
X-Gm-Message-State: AOAM531Q3PVh5Mki2g3tKYfaBnuaoxI45mO/nvCD5FdWKO+bo7AaksDH
	6rgbBUpBkLftY0e9Qks4mQsl+g==
X-Google-Smtp-Source: ABdhPJziyVuAkAxLvealhwn98eWxfMZWbG1ZmYnENKBM0t128sCt9/8AqZ3b6rF3HvTsRxWrjCRABQ==
X-Received: by 2002:a05:6602:2103:: with SMTP id x3mr6450447iox.130.1594934813535;
        Thu, 16 Jul 2020 14:26:53 -0700 (PDT)
Subject: Re: [PATCH RFC v2 2/3] io_uring: add IOURING_REGISTER_RESTRICTIONS
 opcode
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
 Kernel Hardening <kernel-hardening@lists.openwall.com>,
 Kees Cook <keescook@chromium.org>, Aleksa Sarai <asarai@suse.de>,
 Stefan Hajnoczi <stefanha@redhat.com>,
 Christian Brauner <christian.brauner@ubuntu.com>,
 Sargun Dhillon <sargun@sargun.me>, Jann Horn <jannh@google.com>,
 io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org
References: <20200716124833.93667-1-sgarzare@redhat.com>
 <20200716124833.93667-3-sgarzare@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <0fbb0393-c14f-3576-26b1-8bb22d2e0615@kernel.dk>
Date: Thu, 16 Jul 2020 15:26:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200716124833.93667-3-sgarzare@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 7/16/20 6:48 AM, Stefano Garzarella wrote:
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index efc50bd0af34..0774d5382c65 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -265,6 +265,7 @@ enum {
>  	IORING_REGISTER_PROBE,
>  	IORING_REGISTER_PERSONALITY,
>  	IORING_UNREGISTER_PERSONALITY,
> +	IORING_REGISTER_RESTRICTIONS,
>  
>  	/* this goes last */
>  	IORING_REGISTER_LAST
> @@ -293,4 +294,30 @@ struct io_uring_probe {
>  	struct io_uring_probe_op ops[0];
>  };
>  
> +struct io_uring_restriction {
> +	__u16 opcode;
> +	union {
> +		__u8 register_op; /* IORING_RESTRICTION_REGISTER_OP */
> +		__u8 sqe_op;      /* IORING_RESTRICTION_SQE_OP */
> +	};
> +	__u8 resv;
> +	__u32 resv2[3];
> +};
> +
> +/*
> + * io_uring_restriction->opcode values
> + */
> +enum {
> +	/* Allow an io_uring_register(2) opcode */
> +	IORING_RESTRICTION_REGISTER_OP,
> +
> +	/* Allow an sqe opcode */
> +	IORING_RESTRICTION_SQE_OP,
> +
> +	/* Only allow fixed files */
> +	IORING_RESTRICTION_FIXED_FILES_ONLY,
> +
> +	IORING_RESTRICTION_LAST
> +};
> +

Not sure I totally love this API. Maybe it'd be cleaner to have separate
ops for this, instead of muxing it like this. One for registering op
code restrictions, and one for disallowing other parts (like fixed
files, etc).

I think that would look a lot cleaner than the above.

-- 
Jens Axboe

