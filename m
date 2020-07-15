Return-Path: <kernel-hardening-return-19334-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 96A3E22166B
	for <lists+kernel-hardening@lfdr.de>; Wed, 15 Jul 2020 22:40:33 +0200 (CEST)
Received: (qmail 1049 invoked by uid 550); 15 Jul 2020 20:40:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1029 invoked from network); 15 Jul 2020 20:40:28 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=3RdpnHt4YFQNegHM71xCSPo+5hGEKA55j9DzkLX+zEI=;
        b=W6JWWMnCCKRoZOrZTqxAVNCpWdse7JHrhl955F5ofkWIbY8yj0WiYEYIrzGnCpQmPr
         nebzAR1cLp77bQPydJtMWmGvGL1DOx/5b1SD2FJ+owpHkt8+SixM1Gqmi5haJ+ZpVK/l
         ohTNaS/ycfxJ7NhhCYIL+fq/TdpwR9jTHXNUw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=3RdpnHt4YFQNegHM71xCSPo+5hGEKA55j9DzkLX+zEI=;
        b=J+KN18wv2uRs38v8rVj4O+oXTv20LTSWniiDTihWzy8+mZNpX85+E3jmeGUDnvNQen
         IM3LI1kg7oGUTtcZKTAnoMfFvG8Flww7baRuHvdJUpvkFYFrzemBpdi0rAGUI07H52M4
         Pex5eO/BpE2hOCG/37QJWisUIvaXjMvUEMeHVCOYWHytwri6hSOOTK86Q+UNYhQoZPYm
         DXEgx2sBCCqpuP1XIvZI7/O1/pvQfz5uVdIC8bFc3KHMrMaEMGcb+4KiShcigReITfNl
         mdu5FyhtlcUFGzHBoyUHxQshjPxQ+llERS5cEiHmdGcO6JtbDYv4se1E1eiUDh0G/qOW
         dpiA==
X-Gm-Message-State: AOAM5319nCJD+rpFg8HOXOK9XQM2ghieU8r4o/8oDUCqgeOcOTGgoPq9
	sXE2mIJQWeR3k46beiHGvcFy8g==
X-Google-Smtp-Source: ABdhPJy0QMC5q+2qYD6o7SHOebREIiw8ISqB8EjezF/XGzbblfIdGbOr3hMolHLPO5Yp/fgvt7Nt3A==
X-Received: by 2002:a17:90b:8d7:: with SMTP id ds23mr1507273pjb.148.1594845616072;
        Wed, 15 Jul 2020 13:40:16 -0700 (PDT)
Date: Wed, 15 Jul 2020 13:40:14 -0700
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
Subject: Re: [PATCH v6 7/7] ima: add policy support for the new file open
 MAY_OPENEXEC flag
Message-ID: <202007151339.283D7CD@keescook>
References: <20200714181638.45751-1-mic@digikod.net>
 <20200714181638.45751-8-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200714181638.45751-8-mic@digikod.net>

On Tue, Jul 14, 2020 at 08:16:38PM +0200, Micka�l Sala�n wrote:
> From: Mimi Zohar <zohar@linux.ibm.com>
> 
> The kernel has no way of differentiating between a file containing data
> or code being opened by an interpreter.  The proposed O_MAYEXEC
> openat2(2) flag bridges this gap by defining and enabling the
> MAY_OPENEXEC flag.
> 
> This patch adds IMA policy support for the new MAY_OPENEXEC flag.
> 
> Example:
> measure func=FILE_CHECK mask=^MAY_OPENEXEC
> appraise func=FILE_CHECK appraise_type=imasig mask=^MAY_OPENEXEC
> 
> Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
> Reviewed-by: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
> Acked-by: Micka�l Sala�n <mic@digikod.net>

(Process nit: if you're sending this on behalf of another author, then
this should be Signed-off-by rather than Acked-by.)

-- 
Kees Cook
