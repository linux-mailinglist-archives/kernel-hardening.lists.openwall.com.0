Return-Path: <kernel-hardening-return-17394-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 08DF3FF59D
	for <lists+kernel-hardening@lfdr.de>; Sat, 16 Nov 2019 21:51:38 +0100 (CET)
Received: (qmail 27924 invoked by uid 550); 16 Nov 2019 20:51:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 27889 invoked from network); 16 Nov 2019 20:51:30 -0000
Date: Sat, 16 Nov 2019 12:51:16 -0800 (PST)
Message-Id: <20191116.125116.355989617007258357.davem@davemloft.net>
To: keescook@chromium.org
Cc: aelior@marvell.com, skalluru@marvell.com,
 GR-everest-linux-l2@marvell.com, samitolvanen@google.com,
 netdev@vger.kernel.org, kernel-hardening@lists.openwall.com,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] bnx2x: Remove function casts
From: David Miller <davem@davemloft.net>
In-Reply-To: <20191115050715.6247-1-keescook@chromium.org>
References: <20191115050715.6247-1-keescook@chromium.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 16 Nov 2019 12:51:17 -0800 (PST)

From: Kees Cook <keescook@chromium.org>
Date: Thu, 14 Nov 2019 21:07:10 -0800

> In order to make the entire kernel usable under Clang's Control Flow
> Integrity protections, function prototype casts need to be avoided
> because this will trip CFI checks at runtime (i.e. a mismatch between
> the caller's expected function prototype and the destination function's
> prototype). Many of these cases can be found with -Wcast-function-type,
> which found that bnx2x had a bunch of needless (or at least confusing)
> function casts. This series removes them all.

Looks reasonable, series applied to net-next.

Thank you.
