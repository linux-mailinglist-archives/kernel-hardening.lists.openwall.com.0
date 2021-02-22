Return-Path: <kernel-hardening-return-20779-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 9D90C3219C4
	for <lists+kernel-hardening@lfdr.de>; Mon, 22 Feb 2021 15:10:02 +0100 (CET)
Received: (qmail 21998 invoked by uid 550); 22 Feb 2021 14:09:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 21978 invoked from network); 22 Feb 2021 14:09:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RGQ4/qtHx2bjdFvrHFwyUEeeg/OYwFG54DfzAdrz3+k=;
        b=EDxEVjCtWelZXXeakBVsc8YZubZAU7JLWC6I7/OEx0f857/LgLETMq2fSvd0Wn33yE
         wiNVbR26+rzROP7lOyk1NiniRyN+Tmbx8/TX8kUI+QAHy6SevnynVy4AGjUvS8A4HNrW
         pCv74qIdjzWQJCKOnvqy1CtOlM+Htf3hJJLYYpYvUvMeRVWcDo2x4kYK1hQBYffhJNDX
         gi7OqwkkSeb95SI+OmGKyu1MupaXsqM4zM0NuhjC07//HtEiHCLN43G57FjVdjPqlySD
         jcg+iqtDSpZdyO0qXAId3gbjT0UNioWIR2BzYToAWmT+Iw+GUQRlPAmX5CiWPPei1CwV
         2GzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RGQ4/qtHx2bjdFvrHFwyUEeeg/OYwFG54DfzAdrz3+k=;
        b=ptqWvde7CDqK21AHfVfuDmtgUuDqKjRLz0YS/tHAYJRDs9d3GiA8kQ3FAVjxwoMr4k
         WXv8pM8WQ7Z/Tn9QXmwt6uGyKIIlkiTZLt+46IVKUTuAuQPiR/hLmGpfHCDluRB2y2Zs
         bPP8mFiftZCtJCQdzaeHDqDoYDU8GNfyxz4qZS7sW0SvdOjw3PywiBqP0uM5wvfbknhK
         JdkM91/GF8J87M8K1KcfLHikUPPXo3fYxZ7dyuJ+hQPMEDAM/33+AXRDiv8hOrd8sIOo
         CYFfRsnjHzXON7rq6gP6vvzkmPPa624jLcZTCEaEz8kO+sqHc/Ia1AsJT9GCPZ6eSqzJ
         QYbg==
X-Gm-Message-State: AOAM530j03H91xizOB4xOtpiTV60hRUUqj+xc+4XWcaYE8zXyJtEJ9ab
	9WLog3xuDCPINIzdUUq1btQIJg==
X-Google-Smtp-Source: ABdhPJwfv5KNzqsw67r+b7VQyZku80bYaY0gjNcsmqJnjU4Ord9470UDNCt6Qu3Xn1tHFTovcoFSOA==
X-Received: by 2002:a05:6e02:1d8a:: with SMTP id h10mr14087421ila.224.1614002982921;
        Mon, 22 Feb 2021 06:09:42 -0800 (PST)
Subject: Re: [PATCH v6 3/7] Reimplement RLIMIT_NPROC on top of ucounts
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org,
 Kernel Hardening <kernel-hardening@lists.openwall.com>,
 Linux Containers <containers@lists.linux-foundation.org>,
 linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Christian Brauner <christian.brauner@ubuntu.com>,
 "Eric W . Biederman" <ebiederm@xmission.com>, Jann Horn <jannh@google.com>,
 Kees Cook <keescook@chromium.org>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Oleg Nesterov <oleg@redhat.com>
References: <cover.1613392826.git.gladkov.alexey@gmail.com>
 <72fdcd154bec7e0dfad090f1af65ddac1e767451.1613392826.git.gladkov.alexey@gmail.com>
 <72214339-57fc-e47f-bb57-d1b39c69e38e@kernel.dk>
 <20210222101141.uve6hnftsakf4u7n@example.org>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <73b37a89-79d2-9c04-0626-2b164e91c3a8@kernel.dk>
Date: Mon, 22 Feb 2021 07:09:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210222101141.uve6hnftsakf4u7n@example.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 2/22/21 3:11 AM, Alexey Gladkov wrote:
> On Sun, Feb 21, 2021 at 04:38:10PM -0700, Jens Axboe wrote:
>> On 2/15/21 5:41 AM, Alexey Gladkov wrote:
>>> diff --git a/fs/io-wq.c b/fs/io-wq.c
>>> index a564f36e260c..5b6940c90c61 100644
>>> --- a/fs/io-wq.c
>>> +++ b/fs/io-wq.c
>>> @@ -1090,10 +1091,7 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
>>>  		wqe->node = alloc_node;
>>>  		wqe->acct[IO_WQ_ACCT_BOUND].max_workers = bounded;
>>>  		atomic_set(&wqe->acct[IO_WQ_ACCT_BOUND].nr_running, 0);
>>> -		if (wq->user) {
>>> -			wqe->acct[IO_WQ_ACCT_UNBOUND].max_workers =
>>> -					task_rlimit(current, RLIMIT_NPROC);
>>> -		}
>>> +		wqe->acct[IO_WQ_ACCT_UNBOUND].max_workers = task_rlimit(current, RLIMIT_NPROC);
>>
>> This doesn't look like an equivalent transformation. But that may be
>> moot if we merge the io_uring-worker.v3 series, as then you would not
>> have to touch io-wq at all.
> 
> In the current code the wq->user is always set to current_user():
> 
> io_uring_create [1]
> `- io_sq_offload_create
>    `- io_init_wq_offload [2]
>       `-io_wq_create [3]

current vs other wasn't my concern, but we're always setting ->user so
the test was pointless. So looks fine to me.

-- 
Jens Axboe

