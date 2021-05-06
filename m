Return-Path: <kernel-hardening-return-21252-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 640AE3751E1
	for <lists+kernel-hardening@lfdr.de>; Thu,  6 May 2021 12:00:54 +0200 (CEST)
Received: (qmail 32104 invoked by uid 550); 6 May 2021 10:00:47 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 13977 invoked from network); 6 May 2021 00:00:26 -0000
IronPort-SDR: 6G/usTMvxCNn8b4rv5+3Gl3z+sH1E6iEnsBr79BmZiCykYGnfKNWWMWbJNU4ktJnrVjNKhkxCr
 sNOhaJXXBNJQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9975"; a="177892109"
X-IronPort-AV: E=Sophos;i="5.82,276,1613462400"; 
   d="scan'208";a="177892109"
IronPort-SDR: MiDK5L27NDfnkfqXtcDSsGy9F7Qhs4bjmOfsa/ErInC4zma1y9qyA9ODJsTla/3FvmBKW0Hy6q
 GDYgAOEtWbKw==
X-IronPort-AV: E=Sophos;i="5.82,276,1613462400"; 
   d="scan'208";a="430179714"
Date: Wed, 5 May 2021 17:00:13 -0700
From: Ira Weiny <ira.weiny@intel.com>
To: Kees Cook <keescook@chromium.org>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, dave.hansen@intel.com,
	luto@kernel.org, peterz@infradead.org, linux-mm@kvack.org,
	x86@kernel.org, akpm@linux-foundation.org,
	linux-hardening@vger.kernel.org,
	kernel-hardening@lists.openwall.com, rppt@kernel.org,
	dan.j.williams@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 0/9] PKS write protected page tables
Message-ID: <20210506000013.GE1068722@iweiny-DESK2.sc.intel.com>
References: <20210505003032.489164-1-rick.p.edgecombe@intel.com>
 <202105042253.ECBBF6B6@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <202105042253.ECBBF6B6@keescook>
User-Agent: Mutt/1.11.1 (2018-12-01)

On Tue, May 04, 2021 at 11:25:31PM -0700, Kees Cook wrote:
> On Tue, May 04, 2021 at 05:30:23PM -0700, Rick Edgecombe wrote:
> 
> > Performance impacts
> > ===================
> > Setting direct map permissions on whatever random page gets allocated for a 
> > page table would result in a lot of kernel range shootdowns and direct map 
> > large page shattering. So the way the PKS page table memory is created is 
> > similar to this module page clustering series[2], where a cache of pages is 
> > replenished from 2MB pages such that the direct map permissions and associated 
> > breakage is localized on the direct map. In the PKS page tables case, a PKS 
> > key is pre-applied to the direct map for pages in the cache.
> > 
> > There would be some costs of memory overhead in order to protect the direct 
> > map page tables. There would also be some extra kernel range shootdowns to 
> > replenish the cache on occasion, from setting the PKS key on the direct map of 
> > the new pages. I don’t have any actual performance data yet.
> 
> What CPU models are expected to have PKS?


Supervisor Memory Protection Keys (PKS) is a feature which is found on Intel’s
Sapphire Rapids (and later) “Scalable Processor” Server CPUs.  It will also be
available in future non-server Intel parts.

Also qemu has some support as well.

https://www.qemu.org/2021/04/30/qemu-6-0-0/

Ira
