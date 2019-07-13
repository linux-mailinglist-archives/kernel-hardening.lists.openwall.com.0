Return-Path: <kernel-hardening-return-16446-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 34FE56772F
	for <lists+kernel-hardening@lfdr.de>; Sat, 13 Jul 2019 02:15:24 +0200 (CEST)
Received: (qmail 16106 invoked by uid 550); 13 Jul 2019 00:15:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 16069 invoked from network); 13 Jul 2019 00:15:17 -0000
Date: Sat, 13 Jul 2019 10:14:41 +1000 (AEST)
From: James Morris <jmorris@namei.org>
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>
cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
        linux-mm@kvack.org, linux-security-module@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Brad Spengler <spender@grsecurity.net>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Christoph Hellwig <hch@infradead.org>, Jann Horn <jannh@google.com>,
        Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v5 01/12] S.A.R.A.: add documentation
In-Reply-To: <1562410493-8661-2-git-send-email-s.mesoraca16@gmail.com>
Message-ID: <alpine.LRH.2.21.1907130953130.21853@namei.org>
References: <1562410493-8661-1-git-send-email-s.mesoraca16@gmail.com> <1562410493-8661-2-git-send-email-s.mesoraca16@gmail.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Sat, 6 Jul 2019, Salvatore Mesoraca wrote:

> Adding documentation for S.A.R.A. LSM.

It would be good if you could add an operational overview to help people 
understand how it works in practice, e.g. setting policies for binaries 
via sara-xattr and global config via saractl (IIUC). It's difficult to 
understand if you have to visit several links to piece things together.

> +S.A.R.A.'s Submodules
> +=====================
> +
> +WX Protection
> +-------------
> +WX Protection aims to improve user-space programs security by applying:
> +
> +- `W^X enforcement`_
> +- `W!->X (once writable never executable) mprotect restriction`_
> +- `Executable MMAP prevention`_
> +
> +All of the above features can be enabled or disabled both system wide
> +or on a per executable basis through the use of configuration files managed by
> +`saractl` [2]_.

How complete is the WX protection provided by this module? How does it 
compare with other implementations (such as PaX's restricted mprotect).

> +Parts of WX Protection are inspired by some of the features available in PaX.

Some critical aspects are copied (e.g. trampoline emulation), so it's 
more than just inspired. Could you include more information in the 
description about what's been ported from PaX to SARA?
	

-- 
James Morris
<jmorris@namei.org>

