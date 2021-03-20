Return-Path: <kernel-hardening-return-21021-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id CD7B3342DF7
	for <lists+kernel-hardening@lfdr.de>; Sat, 20 Mar 2021 16:50:14 +0100 (CET)
Received: (qmail 19840 invoked by uid 550); 20 Mar 2021 15:50:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 19808 invoked from network); 20 Mar 2021 15:50:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1616255380;
	bh=AD3PrN+vf2mQ+8MKDbQ8ZeCfvzIHl3vXZnPV0wZtj5o=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZrpfWcx4qLiCVKdBZb9jsRreKGVU4XjsPhtS8dJj3xCXnBUEUeyx/fZsqQR0D6dcK
	 Rw498Q7k36nJ7r7QHR2kERzsmrjxD9JpHjTJc7HcBGzOmwV1wZRWx21IeZ7//+jdvB
	 kLQqvxnPw++zbDxm55SGU0buSzhELsMb6M98jH1w=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Date: Sat, 20 Mar 2021 16:49:36 +0100
From: John Wood <john.wood@gmx.com>
To: Kees Cook <keescook@chromium.org>
Cc: John Wood <john.wood@gmx.com>, Jann Horn <jannh@google.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, James Morris <jmorris@namei.org>,
	Shuah Khan <shuah@kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andi Kleen <ak@linux.intel.com>,
	kernel test robot <oliver.sang@intel.com>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v6 6/8] selftests/brute: Add tests for the Brute LSM
Message-ID: <20210320154936.GE3023@ubuntu>
References: <20210307113031.11671-1-john.wood@gmx.com>
 <20210307113031.11671-7-john.wood@gmx.com>
 <202103172105.F88F6745@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202103172105.F88F6745@keescook>
X-Provags-ID: V03:K1:EeL7EnPKcSmX1if1wHYmRNesWmU0Wkazr3PMeRYXhdRSg1a6ggo
 yg+MD7nT2DiQJFysClafW8A2qO7MROy7qBtV1CF5wMWNamxAw6lxq4IEoThIWCO6V1O70Y5
 kGY5YGfnxojkkC5RA12bes65ZPxFKQoI8rR8XZeyoTCNgpHcNwkveOTvMis/bODP2lrk1UH
 8JOAdenmseC/yktwz1TRw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:qAfb5bWlDgc=:FV7wh3gVsW21/3bpO8jU48
 AWXiqMbRLm4bToSaVxj0FvuYscejs0zbeSfh2406n1c12nQg8CRGqsGBY9fqh+ccmLIRxLZVL
 rgsp5u2VX6ozU8r1ui1zsMBM533kyjusDC/aTQJHglGIm1Ql2S6YoKX/z6246SpZdSy+jRf2E
 9YDttU6eMqro5/fz0jDWtv7XKgGWNYh1rKtyjC8PmXZdFVtW193aV1+PaV3OSUt4o++glqw/J
 XFnIoOP+k5/c5bxbuHT3IxuwSCZM7212buofgkJe0QqMGGXL0usR7dmrkoesv7EHvTEp/ssKZ
 D55mgYertyJ5rZ+Y3QaYeoBDt+cPPF6P+hOl39cUWivHtC2Vydex/eYM1wIywoqSaKyhwEXbf
 UaYB7XnBRvq/00GkZ5BnptLXvcCGVcmxC6cIaIt2Qxi1wXIKcSAE630zj4ASvqWPqsNnZ192q
 Ceasnba1iRxtP3qxNkN3oRf1EHd5eaS0vhC96aXVUssZOK4ifGLtpxaTSW1amI6z2AOm6WY5T
 KDCe0UQT29IefWG8c0Y5QLnUcENiPbsfOsOpnrCV+L1Jf5UsrZKc9SEH8UHJBiwBLFSZ3aT9B
 h2X712bfatiB5B3nnFIKbeNBgssH8eaEvU7PQHL/QTryrnO4LOge7IcGaZZ2tTjoBqYBJsEAL
 h49Fl3f5IBNBLaahEgSaaFhON6D6oBs2mpdg1DgzElIsOVGHHdFLH9Z8506WV7RfM8dHW5HDb
 o2HHpcrVQbOgYZ79qSnfH6ds7djMbfVRIdYP5tDwK1Zc6p7qjyXKABjwTA7q9Dlh0KPD8Hkfo
 DKR+ynm20ZsgaNAnpTKXQMeFH/OmvqR9ZLDWGxxDrOHFfxNmtmSVD4FDt5nTCJ1mNwICuuXTd
 VTlTQpw5QZg5AWNxfKUA==
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 17, 2021 at 09:08:17PM -0700, Kees Cook wrote:
> On Sun, Mar 07, 2021 at 12:30:29PM +0100, John Wood wrote:
> > +
> > +count_fork_matches()
> > +{
> > +	dmesg | grep "brute: Fork brute force attack detected" | wc -l
>
> This may be unstable if the dmesg scrolls past, etc. See how
> lkdtm/run.sh handles this with a temp file and "comm".

Thanks, I will correct this for the next version.

John Wood
