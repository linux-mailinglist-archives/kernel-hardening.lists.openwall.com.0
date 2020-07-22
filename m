Return-Path: <kernel-hardening-return-19415-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id D11CE229F36
	for <lists+kernel-hardening@lfdr.de>; Wed, 22 Jul 2020 20:25:21 +0200 (CEST)
Received: (qmail 14151 invoked by uid 550); 22 Jul 2020 18:25:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 14124 invoked from network); 22 Jul 2020 18:25:16 -0000
IronPort-SDR: qpdPddNgLewAwfaZCqvCz/5Mcf69WApe2jHCO5vA4BSFaJIlwh3+hPbn/pGQyho8cU0vbcf86r
 0XpTxiw4/xZQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9690"; a="235273172"
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="235273172"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
IronPort-SDR: 0aKlQxXbmxsipBjsWOtrkvAy7O06GfhEqxJVOlVaisFefFtYFu31rglF+d2fWnFGv7uefTvaVh
 x0s8xDK0OrAA==
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="284311422"
Message-ID: <24fedc0f503527ef847a4f534277856388fb6a6a.camel@linux.intel.com>
Subject: Re: [PATCH v4 00/10] Function Granular KASLR
From: Kristen Carlson Accardi <kristen@linux.intel.com>
To: Joe Lawrence <joe.lawrence@redhat.com>, Kees Cook
 <keescook@chromium.org>,  Miroslav Benes <mbenes@suse.cz>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 arjan@linux.intel.com,  x86@kernel.org, linux-kernel@vger.kernel.org, 
 kernel-hardening@lists.openwall.com, rick.p.edgecombe@intel.com, 
 live-patching@vger.kernel.org
Date: Wed, 22 Jul 2020 11:24:46 -0700
In-Reply-To: <b5bc7a92-a11e-d75d-eefb-fc640c87490d@redhat.com>
References: <20200717170008.5949-1-kristen@linux.intel.com>
	 <alpine.LSU.2.21.2007221122110.10163@pobox.suse.cz>
	 <202007220738.72F26D2480@keescook>
	 <aa51eb26-e2a9-c448-a3b8-e9e68deeb468@redhat.com>
	 <b5bc7a92-a11e-d75d-eefb-fc640c87490d@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2020-07-22 at 10:56 -0400, Joe Lawrence wrote:
> On 7/22/20 10:51 AM, Joe Lawrence wrote:
> > On 7/22/20 10:39 AM, Kees Cook wrote:
> > > On Wed, Jul 22, 2020 at 11:27:30AM +0200, Miroslav Benes wrote:
> > > > Let me CC live-patching ML, because from a quick glance this is
> > > > something
> > > > which could impact live patching code. At least it invalidates
> > > > assumptions
> > > > which "sympos" is based on.
> > > 
> > > In a quick skim, it looks like the symbol resolution is using
> > > kallsyms_on_each_symbol(), so I think this is safe? What's a good
> > > selftest for live-patching?
> > > 
> > 
> > Hi Kees,
> > 
> > I don't think any of the in-tree tests currently exercise the
> > kallsyms/sympos end of livepatching.
> > 
> 
> On second thought, I mispoke.. The general livepatch code does use
> it:
> 
> klp_init_object
>    klp_init_object_loaded
>      klp_find_object_symbol
> 
> in which case any of the current kselftests should exercise that.
> 
>    % make -C tools/testing/selftests/livepatch run_tests
> 
> -- Joe
> 

Thanks, it looks like this should work for helping me exercise the live
patch code paths. I will take a look and get back to you all.

