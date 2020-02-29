Return-Path: <kernel-hardening-return-18027-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 5D389174A45
	for <lists+kernel-hardening@lfdr.de>; Sun,  1 Mar 2020 00:52:05 +0100 (CET)
Received: (qmail 18241 invoked by uid 550); 29 Feb 2020 23:52:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 18209 invoked from network); 29 Feb 2020 23:51:59 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :in-reply-to;
        bh=JCx5kM2FMe+phgvKiMpcu0iiorhySMfHXJQpD4PHwa8=;
        b=P/Nsf2a2wOYy7D1u146YWjS1s0ujxd2TAgYMb/LLAdf9b3eCgjLNdXrDZV2mViHn+a
         WmdqTo54POm0wJbKOda2WLgKO23AX8ZVC56n86ceOp/d7nQqrv40YovrJ9GeywHUeIDu
         muZunWBfnMGLQSnTUszHU82kX6t5xpQt2TdhQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:in-reply-to;
        bh=JCx5kM2FMe+phgvKiMpcu0iiorhySMfHXJQpD4PHwa8=;
        b=UtrFLoesZR8/nncvdm83ZTmGx8WyEGUTLGJD0xScE7r9n6t6nMFyIAf1H4HehTf5uN
         cOnxGLL18LNjIq59LiyKeuOBptkOxAcO1Fi/VKPgev65tjLSmFzDu8Fc3AzZaTfzWRnM
         xqGVemAmvzbHA8Wkk5SjikclAgzg1II358aJw/yDRnIWUvxYnXmD3642WUiftZfLKttm
         fZKu27TJ0dRrUNYkrXndteX65o8w1X8woLBKeYs+AvvebdNDBM+i2S+YR8KcTbw7+3d/
         YtAjsYyqV3XC5Vb/mpVPlT8bS/P/r+zNZOF9hEb7izK+x3+67XQnk1jWcMUTpZG+ziUk
         mylA==
X-Gm-Message-State: APjAAAUvTqZD2n3Y2QIwSzSBJioizsYu9AOwepCVDShOj+jhTxW0GG4i
	+SJpLv/jCIw0+Nrqt04X73hgjA==
X-Google-Smtp-Source: APXvYqxsx1i0sHqA2KvbaHmgfpHOZ+FRmZ9YIX/ymQrfriesl+tjije02HUpoRd4OXIwmBiGs6tUyQ==
X-Received: by 2002:a17:90b:11d0:: with SMTP id gv16mr12761318pjb.109.1583020307505;
        Sat, 29 Feb 2020 15:51:47 -0800 (PST)
Date: Sat, 29 Feb 2020 15:51:45 -0800
From: Kees Cook <keescook@chromium.org>
To: Arvind Sankar <nivedita@alum.mit.edu>
Cc: dave.hansen@linux.intel.com, kernel-hardening@lists.openwall.com,
	linux-kernel@vger.kernel.org, luto@kernel.org, me@tobin.cc,
	peterz@infradead.org, tycho@tycho.ws, x86@kernel.org
Subject: Re: [PATCH] x86/mm/init_32: Don't print out kernel memory layout if
 KASLR
Message-ID: <202002291534.ED372CC@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200226215039.2842351-1-nivedita@alum.mit.edu>

Arvind Sankar said:
> For security, only show the virtual kernel memory layout if KASLR is
> disabled.

These have been entirely removed on other architectures, so let's
just do the same for ia32 and remove it unconditionally.

071929dbdd86 ("arm64: Stop printing the virtual memory layout")
1c31d4e96b8c ("ARM: 8820/1: mm: Stop printing the virtual memory layout")
31833332f798 ("m68k/mm: Stop printing the virtual memory layout")
fd8d0ca25631 ("parisc: Hide virtual kernel memory layout")
adb1fe9ae2ee ("mm/page_alloc: Remove kernel address exposure in free_reserved_area()")

-Kees

-- 
Kees Cook
