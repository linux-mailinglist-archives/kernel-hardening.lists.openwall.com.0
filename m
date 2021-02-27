Return-Path: <kernel-hardening-return-20858-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 2A7B2326EA3
	for <lists+kernel-hardening@lfdr.de>; Sat, 27 Feb 2021 19:45:08 +0100 (CET)
Received: (qmail 12263 invoked by uid 550); 27 Feb 2021 18:45:02 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 12231 invoked from network); 27 Feb 2021 18:45:01 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1614451481;
	bh=15q3zwQ7cXEwZeNdqHUiaEAspocOc5rXPvRSWa6sL0I=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GqjcLDSZuVJIlH8V10wsmypH7mdJN7DsaNa9PWZdywDW/WSY9s385W5Uhotb4ZEpY
	 zmBmiUx6s7ydAjj8aRv/AXNoZojSUVdnIQHF6/087w6lj/2+SEL4h1aOwLdvMF8IBd
	 VI6EpZ6Wgf0LrL1lN+LxvO5oHg0XcQ7P/MSaafLA=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Date: Sat, 27 Feb 2021 19:44:28 +0100
From: John Wood <john.wood@gmx.com>
To: Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, James Morris <jmorris@namei.org>,
	Shuah Khan <shuah@kernel.org>
Cc: John Wood <john.wood@gmx.com>, "Serge E. Hallyn" <serge@hallyn.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v5 0/8] Fork brute force attack mitigation
Message-ID: <20210227184428.GA9641@ubuntu>
References: <20210227153013.6747-1-john.wood@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210227153013.6747-1-john.wood@gmx.com>
X-Provags-ID: V03:K1:RoCE3t5+RrvW/W5eGj27hzaWflBslhjVVtsFIKNqkbkQmcLC2L/
 JKPCs+sCtzvo1yQ7WkQ4O2ZuFVdkW17mFu2Spbbz666AzrOelM+keM36YiUDKplAQIjHuTA
 XY1JJAh7Fq45WPG/mvy/uwa8V5dxooxqEasasLp8UpEErZUX5mD5jy8CUK7ccBc6t/oNuzg
 N4cn3mIAUoKYCHRl5cp6w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:H1SqB/m8Fz0=:MV6jGMgavPZGgJlR+YHYNE
 YfkE53PFuIg6og8pJvKwLVJtbP+6ajscZ4GWZW5xUU7toarjg+RkfgzUe9A4UBnuIkZqER/hY
 2ahputXjZEggdiLozJArcHU2KLkurD59GUqwM5mB2UP5p5Fu5lZpb/NfuJ4inqVQOF/ek+t/U
 mAQ06S6THWxbqWI4R+aGf3JBuBsGq2qlcSVc6Lpi/QjJ+yXsmgYwbpNUlRRmJISoPW+oUrIIq
 YeBDYh+zm6IC2ZoAlSzc4y9KDjDHEZdjKe5x7FrWhZcAJ4ETP8VOgIA/OZeJEdok29dCpOjcs
 Bvzff6soW2RDio/kNLrm8OhMeCKr3T/V8bNTyKseLTuAnvg0oZNvC3sM7d6sXbtxOhSfqIqJU
 z5o8qPQXVGb7jxfLfgduRzFKwDZ/ia9q1XASb9qFNB+SofBgbwlA0cUgAnpEXfwEwnfWd7hEK
 68vNGsb6RyVlZrG964dOdTqoVWKtEj5uLsHFXzrHRHD7txd/EOObvMFEPB+c5FVe2qRsIG3KE
 MD8NpC2TqWRu3ZWxMfuEKZRPRVLEFI3D0KT5fLrFCFhkMn91mGh5VktVUWp0BrZldftt3jYts
 e20BzJYhtVnjeFVr2+TuxREplAYpAskY+KQUK14g/2CIpUgD60MB+FaYcssvXvu2c0dZxM6JA
 V1//sMgJuuGbRMNF0PVmTNUkHzTF8HkAcfnpNNRrKGVCfyWwflLP2bHCltT6T8jrKXIc3IzN0
 7ai1j9Tpv2ltVN7IvieYZPpx8MEeOkAQH50jlrIt+UhYweyfG1A3416pYPrNo7O7/9CNsUJhy
 U6vYboqtSZYlFW4NGo3y4xwacpHMKWaoFyzDdGZXQpOCRKOHjnWndtiN3SC1D0IzO/issNrB5
 Z9il+GbiAQc4cZm2nOdg==
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 27, 2021 at 04:30:05PM +0100, John Wood wrote:
>
> This patch serie is a task of the KSPP [1] and can also be accessed from=
 my
> github tree [2] in the "brute_v4" branch.

Sorry. The correct branch is "brute_v5".
Apologies.

John Wood
>
> [1] https://github.com/KSPP/linux/issues/39
> [2] https://github.com/johwood/linux/
>
