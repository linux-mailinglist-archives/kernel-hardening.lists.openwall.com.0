Return-Path: <kernel-hardening-return-19446-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 6ECE122CE4A
	for <lists+kernel-hardening@lfdr.de>; Fri, 24 Jul 2020 21:04:11 +0200 (CEST)
Received: (qmail 7946 invoked by uid 550); 24 Jul 2020 19:04:05 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 7923 invoked from network); 24 Jul 2020 19:04:04 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=sdXgEvqGYHlymvqSceJ6jkKcKZE63vnTThrEFoJfoJI=;
        b=U21XHuTNZcd9Xi31/xCf87Rkodq7UIatsvvV/UwKN/JzlFCu0PB6GXerCOvF6wBSK+
         SC2WOUDhPlu1q875fotSfx1rUNIyJCPwLsBy0JiUGot5W6Q50r/BPrfciAdVtp7Uwlle
         rtPo4Tole4s/1hOtfMBeGT54AFN8aogMq5g4g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=sdXgEvqGYHlymvqSceJ6jkKcKZE63vnTThrEFoJfoJI=;
        b=uU80vXAuLEr/8WHhiKTsIl9DnD7v/kB4ayhyZKz6Famf6G2E9xvi9Z2ZQr9hSk9u6c
         zVxrP6urTRvjn/zwCCqFDlt5pwM43BTJK+pDQsZtwmqDKdXvThXwutu0+bYDI8tm24ng
         CrOeTsTzL6bQdjcE8kwlYthLMotA3EOxI2PzhXKuB43NQ7hW2YTFG3KT1M48AJEhRAmF
         J6XuwGuFCSpPsrAg9FkHTBHCElXJF7ZlyFabhZ9m24EgAbozV2biFiDlIu2J7S3U0SH4
         LQtkl0LMNJ5uSqaXDqR7NS6c5gh/BtKakdNvV2ozJuH+6RSKlqyoOaUkdQX1YY5TauFK
         jBzg==
X-Gm-Message-State: AOAM531b0VfmzjsH4O+qlsFLrViIgjFWpTLhOwFUDzgBA0EcO6AAlHJ4
	GVU2xJWZunGTmOmaGr3W2tkqkg==
X-Google-Smtp-Source: ABdhPJxz4vuqoUWyBigx8RahhArmNJ84Nut7BOOCsUQANkvjswnwvqIw0Juf0zWwzmKl2+qs8JH6nQ==
X-Received: by 2002:a63:140f:: with SMTP id u15mr9259752pgl.94.1595617432993;
        Fri, 24 Jul 2020 12:03:52 -0700 (PDT)
Date: Fri, 24 Jul 2020 12:03:51 -0700
From: Kees Cook <keescook@chromium.org>
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: linux-kernel@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	Christian Heimes <christian@python.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Deven Bowers <deven.desai@linux.microsoft.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Eric Chiang <ericchiang@google.com>,
	Florian Weimer <fweimer@redhat.com>,
	James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>,
	Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
	Matthew Garrett <mjg59@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Philippe =?iso-8859-1?Q?Tr=E9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
	Scott Shell <scottsh@microsoft.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Shuah Khan <shuah@kernel.org>, Steve Dower <steve.dower@python.org>,
	Steve Grubb <sgrubb@redhat.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Thibaut Sautereau <thibaut.sautereau@clip-os.org>,
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
Subject: Re: [PATCH v7 6/7] selftest/openat2: Add tests for O_MAYEXEC
 enforcing
Message-ID: <202007241203.E4A515733@keescook>
References: <20200723171227.446711-1-mic@digikod.net>
 <20200723171227.446711-7-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200723171227.446711-7-mic@digikod.net>

On Thu, Jul 23, 2020 at 07:12:26PM +0200, Micka�l Sala�n wrote:
> Test propagation of noexec mount points or file executability through
> files open with or without O_MAYEXEC, thanks to the
> fs.open_mayexec_enforce sysctl.
> 
> Signed-off-by: Micka�l Sala�n <mic@digikod.net>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
