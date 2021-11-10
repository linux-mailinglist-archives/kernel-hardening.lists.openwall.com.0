Return-Path: <kernel-hardening-return-21455-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 5CB7944BD59
	for <lists+kernel-hardening@lfdr.de>; Wed, 10 Nov 2021 09:52:55 +0100 (CET)
Received: (qmail 31856 invoked by uid 550); 10 Nov 2021 08:52:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 31831 invoked from network); 10 Nov 2021 08:52:47 -0000
Subject: Re: [fs] a0918006f9: netperf.Throughput_tps -11.6% regression
To: Kees Cook <keescook@chromium.org>,
 kernel test robot <oliver.sang@intel.com>
Cc: lkp@lists.01.org, lkp@intel.com, ying.huang@intel.com,
 feng.tang@intel.com, zhengjun.xing@linux.intel.com, fengwei.yin@intel.com,
 Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton
 <akpm@linux-foundation.org>, Aleksa Sarai <cyphar@cyphar.com>,
 Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
 Casey Schaufler <casey@schaufler-ca.com>,
 Christian Brauner <christian.brauner@ubuntu.com>,
 Christian Heimes <christian@python.org>,
 Deven Bowers <deven.desai@linux.microsoft.com>,
 Dmitry Vyukov <dvyukov@google.com>, Eric Biggers <ebiggers@kernel.org>,
 Eric Chiang <ericchiang@google.com>, Florian Weimer <fweimer@redhat.com>,
 Geert Uytterhoeven <geert@linux-m68k.org>, James Morris <jmorris@namei.org>,
 Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>,
 Jonathan Corbet <corbet@lwn.net>,
 Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
 "Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
 Matthew Garrett <mjg59@google.com>, Matthew Wilcox <willy@infradead.org>,
 Miklos Szeredi <mszeredi@redhat.com>, Mimi Zohar <zohar@linux.ibm.com>,
 Paul Moore <paul@paul-moore.com>,
 =?UTF-8?Q?Philippe_Tr=c3=a9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
 Scott Shell <scottsh@microsoft.com>, Shuah Khan <shuah@kernel.org>,
 Steve Dower <steve.dower@python.org>, Steve Grubb <sgrubb@redhat.com>,
 Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
 Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
 kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
 =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@linux.microsoft.com>
References: <20211012192410.2356090-2-mic@digikod.net>
 <20211105064159.GB17949@xsang-OptiPlex-9020>
 <202111090920.4958E610D1@keescook>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <95966337-b36e-f45e-6b16-f433bcb90c4d@digikod.net>
Date: Wed, 10 Nov 2021 09:52:51 +0100
User-Agent:
MIME-Version: 1.0
In-Reply-To: <202111090920.4958E610D1@keescook>
Content-Type: text/plain; charset=iso-8859-15
Content-Language: en-US
Content-Transfer-Encoding: 8bit


On 09/11/2021 18:21, Kees Cook wrote:
> On Fri, Nov 05, 2021 at 02:41:59PM +0800, kernel test robot wrote:
>>
>>
>> Greeting,
>>
>> FYI, we noticed a -11.6% regression of netperf.Throughput_tps due to commit:
>>
>>
>> commit: a0918006f9284b77397ae4f163f055c3e0f987b2 ("[PATCH v15 1/3] fs: Add trusted_for(2) syscall implementation and related sysctl")
>> url: https://github.com/0day-ci/linux/commits/Micka-l-Sala-n/Add-trusted_for-2-was-O_MAYEXEC/20211013-032533
>> patch link: https://lore.kernel.org/kernel-hardening/20211012192410.2356090-2-mic@digikod.net
>>
>> in testcase: netperf
>> on test machine: 192 threads 4 sockets Intel(R) Xeon(R) Platinum 9242 CPU @ 2.30GHz with 192G memory
>> with following parameters:
>>
>> 	ip: ipv4
>> 	runtime: 300s
>> 	nr_threads: 16
>> 	cluster: cs-localhost
>> 	test: TCP_CRR
>> 	cpufreq_governor: performance
>> 	ucode: 0x5003006
>>
>> test-description: Netperf is a benchmark that can be use to measure various aspect of networking performance.
>> test-url: http://www.netperf.org/netperf/
>>
>>
>> please be noted we made out some further analysis/tests, as Fengwei mentioned:
>> ==============================================================================
>> Here is my investigation result of this regression:
>>
>> If I add patch to make sure the kernel function address and data address is
>> almost same even with this patch, there is almost no performance delta(0.1%)
>> w/o the patch.
>>
>> And if I only make sure function address same w/o the patch, the performance
>> delta is about 5.1%.
>>
>> So suppose this regression is triggered by different function and data address.
>> We don't know why the different address could bring such kind of regression yet
>> ===============================================================================
>>
>>
>> we also tested on other platforms.
>> on a Cooper Lake (Intel(R) Xeon(R) Gold 5318H CPU @ 2.50GHz with 128G memory),
>> we also observed regression but the gap is smaller:
>> =========================================================================================
>> cluster/compiler/cpufreq_governor/ip/kconfig/nr_threads/rootfs/runtime/tbox_group/test/testcase/ucode:
>>   cs-localhost/gcc-9/performance/ipv4/x86_64-rhel-8.3/16/debian-10.4-x86_64-20200603.cgz/300s/lkp-cpl-4sp1/TCP_CRR/netperf/0x700001e
>>
>> commit:
>>   v5.15-rc4
>>   a0918006f9284b77397ae4f163f055c3e0f987b2
>>
>>        v5.15-rc4 a0918006f9284b77397ae4f163f
>> ---------------- ---------------------------
>>          %stddev     %change         %stddev
>>              \          |                \
>>     333492            -5.7%     314346 �  2%  netperf.Throughput_total_tps
>>      20843            -4.5%      19896        netperf.Throughput_tps
>>
>>
>> but no regression on a 96 threads 2 sockets Ice Lake with 256G memory:
>> =========================================================================================
>> cluster/compiler/cpufreq_governor/ip/kconfig/nr_threads/rootfs/runtime/tbox_group/test/testcase/ucode:
>>   cs-localhost/gcc-9/performance/ipv4/x86_64-rhel-8.3/16/debian-10.4-x86_64-20200603.cgz/300s/lkp-icl-2sp1/TCP_CRR/netperf/0xb000280
>>
>> commit:
>>   v5.15-rc4
>>   a0918006f9284b77397ae4f163f055c3e0f987b2
>>
>>        v5.15-rc4 a0918006f9284b77397ae4f163f
>> ---------------- ---------------------------
>>          %stddev     %change         %stddev
>>              \          |                \
>>     555600            -0.1%     555305        netperf.Throughput_total_tps
>>      34725            -0.1%      34706        netperf.Throughput_tps
>>
>>
>> Fengwei also helped review these results and commented:
>> I suppose these three CPUs have different cache policy. It also could be
>> related with netperf throughput testing.
> 
> Does moving the syscall implementation somewhere else change things?
> That's a _huge_ performance change for something that isn't even called.
> What's going on here?

This regression doesn't make sense. I guess this is the result of a
flaky netperf test, maybe because the test machine was overloaded at
that time.
