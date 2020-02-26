Return-Path: <kernel-hardening-return-17962-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 1B1ED1708E4
	for <lists+kernel-hardening@lfdr.de>; Wed, 26 Feb 2020 20:26:27 +0100 (CET)
Received: (qmail 32113 invoked by uid 550); 26 Feb 2020 19:26:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 32093 invoked from network); 26 Feb 2020 19:26:21 -0000
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
X-IronPort-AV: E=Sophos;i="5.70,489,1574150400"; 
   d="scan'208";a="256437340"
Message-ID: <fc82a40dbc269bf1b4f9c9ca1b56e8115783edbb.camel@linux.intel.com>
Subject: Re: [RFC PATCH 08/11] x86: Add support for finer grained KASLR
From: Kristen Carlson Accardi <kristen@linux.intel.com>
To: Arvind Sankar <nivedita@alum.mit.edu>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, 
	arjan@linux.intel.com, keescook@chromium.org, rick.p.edgecombe@intel.com, 
	x86@kernel.org, linux-kernel@vger.kernel.org, 
	kernel-hardening@lists.openwall.com
Date: Wed, 26 Feb 2020 11:26:08 -0800
In-Reply-To: <20200225174951.GA1373392@rani.riverdale.lan>
References: <20200205223950.1212394-1-kristen@linux.intel.com>
	 <20200205223950.1212394-9-kristen@linux.intel.com>
	 <20200225174951.GA1373392@rani.riverdale.lan>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Tue, 2020-02-25 at 12:49 -0500, Arvind Sankar wrote:
> On Wed, Feb 05, 2020 at 02:39:47PM -0800, Kristen Carlson Accardi
> wrote:
> > At boot time, find all the function sections that have separate
> > .text
> > sections, shuffle them, and then copy them to new locations. Adjust
> > any relocations accordingly.
> > 
> > Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
> > ---
> >  arch/x86/boot/compressed/Makefile        |   1 +
> >  arch/x86/boot/compressed/fgkaslr.c       | 751
> > +++++++++++++++++++++++
> >  arch/x86/boot/compressed/misc.c          | 106 +++-
> >  arch/x86/boot/compressed/misc.h          |  26 +
> >  arch/x86/boot/compressed/vmlinux.symbols |  15 +
> >  arch/x86/include/asm/boot.h              |  15 +-
> >  arch/x86/include/asm/kaslr.h             |   1 +
> >  arch/x86/lib/kaslr.c                     |  15 +
> >  scripts/kallsyms.c                       |  14 +-
> >  scripts/link-vmlinux.sh                  |   4 +
> >  10 files changed, 939 insertions(+), 9 deletions(-)
> >  create mode 100644 arch/x86/boot/compressed/fgkaslr.c
> >  create mode 100644 arch/x86/boot/compressed/vmlinux.symbols
> > 
> > diff --git a/arch/x86/boot/compressed/Makefile
> > b/arch/x86/boot/compressed/Makefile
> > index b7e5ea757ef4..60d4c4e59c05 100644
> > --- a/arch/x86/boot/compressed/Makefile
> > +++ b/arch/x86/boot/compressed/Makefile
> > @@ -122,6 +122,7 @@ OBJCOPYFLAGS_vmlinux.bin :=  -R .comment -S
> >  
> >  ifdef CONFIG_FG_KASLR
> >  	RELOCS_ARGS += --fg-kaslr
> > +	OBJCOPYFLAGS += --keep-symbols=$(obj)/vmlinux.symbols
> 
> I think this should be $(srctree)/$(src) rather than $(obj)? Using a
> separate build directory fails currently.

Thanks, I'll add this to my test plan for v1.


