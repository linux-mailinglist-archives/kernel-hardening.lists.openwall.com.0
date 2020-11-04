Return-Path: <kernel-hardening-return-20353-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 8D8AA2A6308
	for <lists+kernel-hardening@lfdr.de>; Wed,  4 Nov 2020 12:13:58 +0100 (CET)
Received: (qmail 17580 invoked by uid 550); 4 Nov 2020 11:11:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 24394 invoked from network); 4 Nov 2020 05:41:56 -0000
Subject: Re: [PATCH 0/4] aarch64: avoid mprotect(PROT_BTI|PROT_EXEC) [BZ
 #26831]
To: Mark Brown <broonie@kernel.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>
Cc: libc-alpha@sourceware.org, Catalin Marinas <catalin.marinas@arm.com>,
 Mark Rutland <mark.rutland@arm.com>, Will Deacon <will@kernel.org>,
 Florian Weimer <fweimer@redhat.com>, Kees Cook <keescook@chromium.org>,
 Salvatore Mesoraca <s.mesoraca16@gmail.com>,
 Lennart Poettering <mzxreary@0pointer.de>,
 Topi Miettinen <toiwoton@gmail.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com,
 linux-hardening@vger.kernel.org
References: <cover.1604393169.git.szabolcs.nagy@arm.com>
 <20201103173438.GD5545@sirena.org.uk>
From: Jeremy Linton <jeremy.linton@arm.com>
Message-ID: <8c99cc8e-41af-d066-b786-53ac13c2af8a@arm.com>
Date: Tue, 3 Nov 2020 23:41:42 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201103173438.GD5545@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit

Hi,

On 11/3/20 11:34 AM, Mark Brown wrote:
> On Tue, Nov 03, 2020 at 10:25:37AM +0000, Szabolcs Nagy wrote:
> 
>> Re-mmap executable segments instead of mprotecting them in
>> case mprotect is seccomp filtered.
> 
>> For the kernel mapped main executable we don't have the fd
>> for re-mmap so linux needs to be updated to add BTI. (In the
>> presence of seccomp filters for mprotect(PROT_EXEC) the libc
>> cannot change BTI protection at runtime based on user space
>> policy so it is better if the kernel maps BTI compatible
>> binaries with PROT_BTI by default.)
> 
> Given that there were still some ongoing discussions on a more robust
> kernel interface here and there seem to be a few concerns with this
> series should we perhaps just take a step back and disable this seccomp
> filter in systemd on arm64, at least for the time being?  That seems
> safer than rolling out things that set ABI quickly, a big part of the

So, that's a bigger hammer than I think is needed and punishes !BTI 
machines. I'm going to suggest that if we need to carry a temp patch its 
more like the glibc patch I mentioned in the Fedora defect. That patch 
simply logs a message, on the mprotect failures rather than aborting. 
Its fairly non-intrusive.

That leaves seccomp functional, and BTI generally functional except when 
seccomp is restricting it. I've also been asked that if a patch like 
that is needed, its (temporary?) merged to the glibc trunk, rather than 
just being carried by the distro's.

Thanks,

> reason we went with having the dynamic linker enable PROT_BTI in the
> first place was to give us more flexibility to handle any unforseen
> consequences of enabling BTI that we run into.  We are going to have
> similar issues with other features like MTE so we need to make sure that
> whatever we're doing works with them too.
> 
> Also updated to Will's current e-mail address - Will, do you have
> thoughts on what we should do here?
> 

