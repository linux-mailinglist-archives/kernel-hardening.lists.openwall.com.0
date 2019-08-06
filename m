Return-Path: <kernel-hardening-return-16717-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 4BC3082AAF
	for <lists+kernel-hardening@lfdr.de>; Tue,  6 Aug 2019 07:09:16 +0200 (CEST)
Received: (qmail 3185 invoked by uid 550); 6 Aug 2019 05:09:09 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3165 invoked from network); 6 Aug 2019 05:09:08 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1565068137;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=7ho8P+Fnfcvv7paRLriK5vOYhc+udgvOKe/v52tpg1A=;
	b=ZLFaZvCV6kq/QGOH2CtzrXfBHP+8MahErOPXRo6sVxDpnbbmw7eNCgLawyYt+Eeg0rYccV
	59FojR04G6GKWUwKX/JMCTSB+/GOFxn8ygSZNpy2AS8cVr1Gl0oitZ4cpxerW/fGNupUC0
	QsEfJsuJX6IRMauElhqIHg5LMfJWhtE=
Date: Tue, 6 Aug 2019 07:08:51 +0200
From: Borislav Petkov <bp@alien8.de>
To: Thomas Garnier <thgarnie@chromium.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Kristen Carlson Accardi <kristen@linux.intel.com>,
	Kees Cook <keescook@chromium.org>,
	Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	the arch/x86 maintainers <x86@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 04/11] x86/entry/64: Adapt assembly for PIE support
Message-ID: <20190806050851.GA25897@zn.tnic>
References: <20190730191303.206365-1-thgarnie@chromium.org>
 <20190730191303.206365-5-thgarnie@chromium.org>
 <20190805172854.GF18785@zn.tnic>
 <CAJcbSZGedSfZZ5rveH2+_3q7pvmMyDGLxmZU41Nno=ZBX8kN=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAJcbSZGedSfZZ5rveH2+_3q7pvmMyDGLxmZU41Nno=ZBX8kN=w@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Aug 05, 2019 at 10:50:30AM -0700, Thomas Garnier wrote:
> I saw that %rdx was used for temporary usage and restored before the
> end so I assumed that it was not an option.

PUSH_AND_CLEAR_REGS saves all regs earlier so I think you should be
able to use others. Like SAVE_AND_SWITCH_TO_KERNEL_CR3/RESTORE_CR3, for
example, uses %r15 and %r14.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
