Return-Path: <kernel-hardening-return-17001-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 6F721D2C52
	for <lists+kernel-hardening@lfdr.de>; Thu, 10 Oct 2019 16:23:00 +0200 (CEST)
Received: (qmail 13781 invoked by uid 550); 10 Oct 2019 14:22:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 13749 invoked from network); 10 Oct 2019 14:22:52 -0000
Date: Thu, 10 Oct 2019 14:22:40 +0000 (UTC)
From: Christopher Lameter <cl@linux.com>
X-X-Sender: cl@www.lameter.com
To: Shyam Saini <mayhs11saini@gmail.com>
cc: linux-mm@kvack.org, kernel-hardening@lists.openwall.com, 
    Matthew Wilcox <willy@infradead.org>, Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] slab: Redefine ZERO_SIZE_PTR to include ERR_PTR range
In-Reply-To: <20191010103151.7708-1-mayhs11saini@gmail.com>
Message-ID: <alpine.DEB.2.21.1910101418500.27284@www.lameter.com>
References: <20191010103151.7708-1-mayhs11saini@gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Thu, 10 Oct 2019, Shyam Saini wrote:

> This will help error related to ERR_PTR stand out better.

Maybe make ZERO_SIZE_PTR an ERRNO value instead? Then allow ERR_PTRs to be
used instead of ZERO_SIZE_PTRs

ERRNO_ZERO_OBJECT

or something like that?

>   */
> -#define ZERO_SIZE_PTR ((void *)16)

#define ZERO_SIZE_PTR ((void *)-ERRNO_ZERO_OBJECT)

> +
> +#define ZERO_OR_NULL_PTR(x) ((unsigned long)(x) - 1 >= \
> +		(unsigned long)ZERO_SIZE_PTR - 1)

And call this something different?

