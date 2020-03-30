Return-Path: <kernel-hardening-return-18312-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id D3AB3198788
	for <lists+kernel-hardening@lfdr.de>; Tue, 31 Mar 2020 00:41:24 +0200 (CEST)
Received: (qmail 28346 invoked by uid 550); 30 Mar 2020 22:41:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 28314 invoked from network); 30 Mar 2020 22:41:18 -0000
Subject: Re: CONFIG_DEBUG_INFO_BTF and CONFIG_GCC_PLUGIN_RANDSTRUCT
To: Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
 bpf <bpf@vger.kernel.org>,
 Kernel Hardening <kernel-hardening@lists.openwall.com>
References: <CAG48ez2sZ58VQ4+LJu39H1M0Y98LhRYR19G_fDAPJPBf7imxuw@mail.gmail.com>
 <CAADnVQ+Ux3-D_7ytRJx_Pz4fStRLS1vkM=-tGZ0paoD7n+JCLQ@mail.gmail.com>
 <CAG48ez0ajun-ujQQqhDRooha1F0BZd3RYKvbJ=8SsRiHAQjUzw@mail.gmail.com>
 <202003301016.D0E239A0@keescook>
From: Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c332da87-a770-8cf9-c252-5fb64c06c17e@iogearbox.net>
Date: Tue, 31 Mar 2020 00:41:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <202003301016.D0E239A0@keescook>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25767/Mon Mar 30 15:08:30 2020)

On 3/30/20 7:20 PM, Kees Cook wrote:
> On Mon, Mar 30, 2020 at 06:17:32PM +0200, Jann Horn wrote:
>> On Mon, Mar 30, 2020 at 5:59 PM Alexei Starovoitov
>> <alexei.starovoitov@gmail.com> wrote:
>>> On Mon, Mar 30, 2020 at 8:14 AM Jann Horn <jannh@google.com> wrote:
>>>>
>>>> I noticed that CONFIG_DEBUG_INFO_BTF seems to partly defeat the point
>>>> of CONFIG_GCC_PLUGIN_RANDSTRUCT.
>>>
>>> Is it a theoretical stmt or you have data?
>>> I think it's the other way around.
>>> gcc-plugin breaks dwarf and breaks btf.
>>> But I only looked at gcc patches without applying them.
>>
>> Ah, interesting - I haven't actually tested it, I just assumed
>> (perhaps incorrectly) that the GCC plugin would deal with DWARF info
>> properly.
> 
> Yeah, GCC appears to create DWARF before the plugin does the
> randomization[1], so it's not an exposure, but yes, struct randomization
> is pretty completely incompatible with a bunch of things in the kernel
> (by design). I'm happy to add negative "depends" in the Kconfig if it
> helps clarify anything.

Is this expected to get fixed at some point wrt DWARF? Perhaps would make
sense then to add a negative "depends" for both DWARF and BTF if the option
GCC_PLUGIN_RANDSTRUCT is set given both would be incompatible/broken.

Thanks,
Daniel

> -Kees
> 
> [1] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=84052
> 

