Return-Path: <kernel-hardening-return-19883-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id A0AD62676AC
	for <lists+kernel-hardening@lfdr.de>; Sat, 12 Sep 2020 02:04:47 +0200 (CEST)
Received: (qmail 3596 invoked by uid 550); 12 Sep 2020 00:04:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3568 invoked from network); 12 Sep 2020 00:04:39 -0000
Date: Sat, 12 Sep 2020 10:03:23 +1000 (AEST)
From: James Morris <jmorris@namei.org>
To: Kees Cook <keescook@chromium.org>
cc: kernel-hardening@lists.openwall.com, John Wood <john.wood@gmx.com>,
        Matthew Wilcox <willy@infradead.org>, Jonathan Corbet <corbet@lwn.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
        Mel Gorman <mgorman@suse.de>, Luis Chamberlain <mcgrof@kernel.org>,
        Iurii Zaikin <yzaikin@google.com>,
        "Serge E. Hallyn" <serge@hallyn.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [RESEND][RFC PATCH 0/6] Fork brute force attack mitigation
 (fbfam)
In-Reply-To: <20200910202107.3799376-1-keescook@chromium.org>
Message-ID: <alpine.LRH.2.21.2009121002100.17638@namei.org>
References: <20200910202107.3799376-1-keescook@chromium.org>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Thu, 10 Sep 2020, Kees Cook wrote:

> [kees: re-sending this series on behalf of John Wood <john.wood@gmx.com>
>  also visible at https://github.com/johwood/linux fbfam]
> 
> From: John Wood <john.wood@gmx.com>

Why are you resending this? The author of the code needs to be able to 
send and receive emails directly as part of development and maintenance.

-- 
James Morris
<jmorris@namei.org>

