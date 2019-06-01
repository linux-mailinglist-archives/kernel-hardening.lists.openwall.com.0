Return-Path: <kernel-hardening-return-16027-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 9E859318DF
	for <lists+kernel-hardening@lfdr.de>; Sat,  1 Jun 2019 03:18:52 +0200 (CEST)
Received: (qmail 3694 invoked by uid 550); 1 Jun 2019 01:18:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3673 invoked from network); 1 Jun 2019 01:18:45 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1559351913;
	bh=Mw+rwVSb5/LlCGeIAUzZqfm3N9lHZ+uRIKyeNP4lOrc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=hmQkX4JgC4RQPwCWS/q6Lhztvd36ltD9nSqkvNqDwcDBMkal7ZMQKuGocYdzPTTi6
	 4HPz2jp+h9SSimOqoRsErp/iGmTRfQv94QDo2tDoRmL5FtqaLgcYEii7jT2kHe0iPt
	 0dVdmLkCd4cUB2fzkLts29ZCEQThZy/jQYS9KAG0=
Date: Fri, 31 May 2019 18:18:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexander Potapenko <glider@google.com>
Cc: Christoph Lameter <cl@linux.com>, Kees Cook <keescook@chromium.org>,
 Dmitry Vyukov <dvyukov@google.com>, James Morris <jmorris@namei.org>, Jann
 Horn <jannh@google.com>, Kostya Serebryany <kcc@google.com>, Laura Abbott
 <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Masahiro Yamada
 <yamada.masahiro@socionext.com>, Matthew Wilcox <willy@infradead.org>, Nick
 Desaulniers <ndesaulniers@google.com>, Randy Dunlap
 <rdunlap@infradead.org>, Sandeep Patil <sspatil@android.com>,
 "Serge E. Hallyn" <serge@hallyn.com>, Souptick Joarder
 <jrdr.linux@gmail.com>, Marco Elver <elver@google.com>,
 kernel-hardening@lists.openwall.com, linux-mm@kvack.org,
 linux-security-module@vger.kernel.org
Subject: Re: [PATCH v5 2/3] mm: init: report memory auto-initialization
 features at boot time
Message-Id: <20190531181832.e7c3888870ce9e50db9f69e6@linux-foundation.org>
In-Reply-To: <20190529123812.43089-3-glider@google.com>
References: <20190529123812.43089-1-glider@google.com>
	<20190529123812.43089-3-glider@google.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 29 May 2019 14:38:11 +0200 Alexander Potapenko <glider@google.com> wrote:

> Print the currently enabled stack and heap initialization modes.
> 
> The possible options for stack are:
>  - "all" for CONFIG_INIT_STACK_ALL;
>  - "byref_all" for CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL;
>  - "byref" for CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF;
>  - "__user" for CONFIG_GCC_PLUGIN_STRUCTLEAK_USER;
>  - "off" otherwise.
> 
> Depending on the values of init_on_alloc and init_on_free boottime
> options we also report "heap alloc" and "heap free" as "on"/"off".

Why?

Please fully describe the benefit to users so that others can judge the
desirability of the patch.  And so they can review it effectively, etc.

Always!

> In the init_on_free mode initializing pages at boot time may take some
> time, so print a notice about that as well.

How much time?
