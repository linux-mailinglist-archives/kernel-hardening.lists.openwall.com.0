Return-Path: <kernel-hardening-return-19333-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 26457221651
	for <lists+kernel-hardening@lfdr.de>; Wed, 15 Jul 2020 22:39:04 +0200 (CEST)
Received: (qmail 31929 invoked by uid 550); 15 Jul 2020 20:38:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 31906 invoked from network); 15 Jul 2020 20:38:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=qTkObtIP1JOxTsAafQAu4JRP/2PqoQenw/nsfCYT+XA=;
        b=ijKpH2WTKasm1SeJa7YfW41RoND4SGhxfWW8WIrBUyWAJo5mncDz3F6DsdpLNbN9yM
         zimIQJdAwdsoIuaoAmdGi8bqgFGbI1ImDdJTj84SXvxwzifKGWR/ToGmegNpJJRYxabz
         0Mzoe5AOfjDlUoukmWy/DGwdgH+42OpxYqawc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=qTkObtIP1JOxTsAafQAu4JRP/2PqoQenw/nsfCYT+XA=;
        b=fBalP0p4PfurVq+nNLSPEOOknuZj6sg2V2AAauYQuNMNukbFRuet/+VRZfCw+sC6ue
         8Hi0LpMzCcxkbTKQ/q3bMG9gOm1Qp3x+YJ91bnqoNSMwg+lkkzz3RzhVH79+URpwBel+
         oMoCmUTey7Bn9WwRukDVp77nS8aFyt37SqhCtsj9/7vINK0tL72ELBbBoB2XC2WO5OLo
         2ZqeV7rEt3k62BAGz3eWeZkq/GHU62q+fzGN8CamGSFy8rD5e4+Huu72oucRbSeZCvkA
         r3Ba0Wrtl1bQ/qr6a9LVu6TB9hh+YROCdbT/WRITGcqYwW26E557g3iC/wD2FZZdnQFv
         FAzQ==
X-Gm-Message-State: AOAM532pj9J3WAW7bAAxGUE0eTc80IYyuowHVYb+ci1Przw1DbblsVdu
	2Vqi49QEypwwxxBC1nqs+pa7Ng==
X-Google-Smtp-Source: ABdhPJyOe9mUdiu/xb+eBR+7MVDzMD0v9uEBAElvlLK4fUJtk8fgRzbG6NWh1tQpT587gudq9JBjRg==
X-Received: by 2002:a62:cdc4:: with SMTP id o187mr922387pfg.200.1594845526528;
        Wed, 15 Jul 2020 13:38:46 -0700 (PDT)
Date: Wed, 15 Jul 2020 13:38:44 -0700
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
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mickael.salaun@ssi.gouv.fr>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Philippe =?iso-8859-1?Q?Tr=E9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
	Scott Shell <scottsh@microsoft.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Shuah Khan <shuah@kernel.org>, Steve Dower <steve.dower@python.org>,
	Steve Grubb <sgrubb@redhat.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v6 6/7] selftest/openat2: Add tests for O_MAYEXEC
 enforcing
Message-ID: <202007151337.2A113F8C@keescook>
References: <20200714181638.45751-1-mic@digikod.net>
 <20200714181638.45751-7-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200714181638.45751-7-mic@digikod.net>

On Tue, Jul 14, 2020 at 08:16:37PM +0200, Mickaël Salaün wrote:
> Test propagation of noexec mount points or file executability through
> files open with or without O_MAYEXEC, thanks to the
> fs.open_mayexec_enforce sysctl.
> 
> Signed-off-by: Mickaël Salaün <mic@digikod.net>
> Reviewed-by: Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
> Cc: Aleksa Sarai <cyphar@cyphar.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Shuah Khan <shuah@kernel.org>

Yay variants! :)

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
