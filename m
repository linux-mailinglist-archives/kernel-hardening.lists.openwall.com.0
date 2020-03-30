Return-Path: <kernel-hardening-return-18299-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 6F5C4197DBA
	for <lists+kernel-hardening@lfdr.de>; Mon, 30 Mar 2020 16:00:09 +0200 (CEST)
Received: (qmail 15858 invoked by uid 550); 30 Mar 2020 14:00:02 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 15826 invoked from network); 30 Mar 2020 14:00:01 -0000
Subject: Re: [RFC PATCH] arm64: remove CONFIG_DEBUG_ALIGN_RODATA feature
To: Ard Biesheuvel <ardb@kernel.org>, Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>,
 kernel-hardening@lists.openwall.com
References: <20200329141258.31172-1-ardb@kernel.org>
 <20200330135121.GD10633@willie-the-truck>
 <CAMj1kXEZARZ1FYZFt4CZ33b-A64zj1JswR0OAHw-eZdzkxiEOQ@mail.gmail.com>
From: Robin Murphy <robin.murphy@arm.com>
Message-ID: <3d23aa1f-d92c-5e39-733d-ebd135757b8e@arm.com>
Date: Mon, 30 Mar 2020 14:59:47 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CAMj1kXEZARZ1FYZFt4CZ33b-A64zj1JswR0OAHw-eZdzkxiEOQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit

On 2020-03-30 2:53 pm, Ard Biesheuvel wrote:
> On Mon, 30 Mar 2020 at 15:51, Will Deacon <will@kernel.org> wrote:
>>
>> On Sun, Mar 29, 2020 at 04:12:58PM +0200, Ard Biesheuvel wrote:
>>> When CONFIG_DEBUG_ALIGN_RODATA is enabled, kernel segments mapped with
>>> different permissions (r-x for .text, r-- for .rodata, rw- for .data,
>>> etc) are rounded up to 2 MiB so they can be mapped more efficiently.
>>> In particular, it permits the segments to be mapped using level 2
>>> block entries when using 4k pages, which is expected to result in less
>>> TLB pressure.
>>>
>>> However, the mappings for the bulk of the kernel will use level 2
>>> entries anyway, and the misaligned fringes are organized such that they
>>> can take advantage of the contiguous bit, and use far fewer level 3
>>> entries than would be needed otherwise.
>>>
>>> This makes the value of this feature dubious at best, and since it is not
>>> enabled in defconfig or in the distro configs, it does not appear to be
>>> in wide use either. So let's just remove it.
>>>
>>> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>>> ---
>>>   arch/arm64/Kconfig.debug                  | 13 -------------
>>>   arch/arm64/include/asm/memory.h           | 12 +-----------
>>>   drivers/firmware/efi/libstub/arm64-stub.c |  8 +++-----
>>>   3 files changed, 4 insertions(+), 29 deletions(-)
>>
>> Acked-by: Will Deacon <will@kernel.org>
>>
>> But I would really like to go a step further and rip out the block mapping
>> support altogether so that we can fix non-coherent DMA aliases:
>>
>> https://lore.kernel.org/lkml/20200224194446.690816-1-hch@lst.de
>>
> 
> I'm not sure I follow - is this about mapping parts of the static
> kernel Image for non-coherent DMA?

Yikes, I hope not!

The concern there is about block entries in the linear map; I'd assume 
kernel text/data means not-linear-map, and is thus a different kettle of 
fish anyway.

Robin.
