Return-Path: <kernel-hardening-return-17968-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 062BF170E0B
	for <lists+kernel-hardening@lfdr.de>; Thu, 27 Feb 2020 02:56:03 +0100 (CET)
Received: (qmail 3424 invoked by uid 550); 27 Feb 2020 01:55:58 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3389 invoked from network); 27 Feb 2020 01:55:57 -0000
Subject: Re: [PATCH v3 0/6] implement KASLR for powerpc/fsl_booke/64
To: Daniel Axtens <dja@axtens.net>, <mpe@ellerman.id.au>,
	<linuxppc-dev@lists.ozlabs.org>, <diana.craciun@nxp.com>,
	<christophe.leroy@c-s.fr>, <benh@kernel.crashing.org>, <paulus@samba.org>,
	<npiggin@gmail.com>, <keescook@chromium.org>,
	<kernel-hardening@lists.openwall.com>, <oss@buserror.net>
CC: <linux-kernel@vger.kernel.org>, <zhaohongjiang@huawei.com>
References: <20200206025825.22934-1-yanaijie@huawei.com>
 <87tv3drf79.fsf@dja-thinkpad.axtens.net>
 <8171d326-5138-4f5c-cff6-ad3ee606f0c2@huawei.com>
 <87r1yhr2x1.fsf@dja-thinkpad.axtens.net>
From: Jason Yan <yanaijie@huawei.com>
Message-ID: <25e995fa-f9f4-8ba6-c62b-dc8bccd28cbe@huawei.com>
Date: Thu, 27 Feb 2020 09:55:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <87r1yhr2x1.fsf@dja-thinkpad.axtens.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.221.195]
X-CFilter-Loop: Reflected



在 2020/2/26 19:41, Daniel Axtens 写道:
> I suspect that you will find it easier to convince people to accept a
> change to %pK than removal:)
> 
> BTW, I have a T4240RDB so I might be able to test this series at some
> point - do I need an updated bootloader to pass in a random seed, or is
> the kernel able to get enough randomness by itself? (Sorry if this is
> explained elsewhere in the series, I have only skimmed it lightly!)
> 

Thanks. It will be great if you have time to test this series.

You do not need an updated bootloader becuase the kernel is
using timer base as a simple source of entropy. This is enough for
testing the KASLR code itself.

Jason

> Regards,
> Daniel

