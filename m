Return-Path: <kernel-hardening-return-18222-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id B184D192CA8
	for <lists+kernel-hardening@lfdr.de>; Wed, 25 Mar 2020 16:34:45 +0100 (CET)
Received: (qmail 11776 invoked by uid 550); 25 Mar 2020 15:34:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 11756 invoked from network); 25 Mar 2020 15:34:38 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ehziNPeaBvtJLg13Ry2+oGWqU/h8Z30gqipX1jtupZo=;
        b=jf9VMJu8DVs0x+Z49kPRCZTQoMvHgkYdC9Kpmy0uQgm4UR9jFf/L7dIviuoIwP9ZNi
         iiac4DCON+0EuJPysY6VP8AqQwEHrl0R5fMHVBTeNtr8ohxjVd6nOXrFqQDEFIu5CDRY
         fxLV9xf1LaZTggHKl75w0RxgGrxFRHowY8HBM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ehziNPeaBvtJLg13Ry2+oGWqU/h8Z30gqipX1jtupZo=;
        b=l/ED/cpeFnLTy0lxi0szEGaxzhEHqYDcQMyEHe2fVaat4TIdPqkYAcZZRUMpm/HOrB
         M3UCjTSAtkvVtniZOwQEFDhFTyZKtM79DNnCBOz8h5oKFMubdeFGoic5Bn6A3e56gAM1
         KxENvlOglgrSIN/h02aq0FGNjo/dFYGjiYO8vxNJxU7CcJ2Wj9b0eoscVVy+sNitAzVW
         2ZOHr0v5G1WrEfxFfTK/MnMRvmNAGOFRrrRI4pbvy0ZkEO3qeq8xLz/55LhxceaR8OPg
         z18kPM9teT6a7Ss89PRV1c3CrqiI9i1ngen90t9e/998Bjg03nqSIfXUYvUOxNhGdDaV
         rhIw==
X-Gm-Message-State: ANhLgQ1ppA6LFqiTztLcFkMownCEzZSwa9TWPmQfbRc3trdCvUVedvZw
	A4P11kfIcN0E6F8f6EvqlUxpxA==
X-Google-Smtp-Source: ADFU+vuE/OkWaSorz352VE4048NKpohcauVrFpF0sseKDb5HdyB0hC6/0vZ+ltQJWrYg+Ox9ctjKFw==
X-Received: by 2002:a62:7811:: with SMTP id t17mr4024383pfc.268.1585150465380;
        Wed, 25 Mar 2020 08:34:25 -0700 (PDT)
Date: Wed, 25 Mar 2020 08:34:23 -0700
From: Kees Cook <keescook@chromium.org>
To: Kristen Carlson Accardi <kristen@linux.intel.com>
Cc: Arvind Sankar <nivedita@alum.mit.edu>, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
	arjan@linux.intel.com, rick.p.edgecombe@intel.com, x86@kernel.org,
	linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Subject: Re: [RFC PATCH 05/11] x86: Makefile: Add build and config option for
 CONFIG_FG_KASLR
Message-ID: <202003250832.058B12D3@keescook>
References: <20200205223950.1212394-1-kristen@linux.intel.com>
 <20200205223950.1212394-6-kristen@linux.intel.com>
 <20200225175544.GA1385238@rani.riverdale.lan>
 <a01e6b2f0a19f0ace0b5f2c8a50cafccc9b4ef60.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a01e6b2f0a19f0ace0b5f2c8a50cafccc9b4ef60.camel@linux.intel.com>

On Tue, Mar 24, 2020 at 02:24:51PM -0700, Kristen Carlson Accardi wrote:
> On Tue, 2020-02-25 at 12:55 -0500, Arvind Sankar wrote:
> > On Wed, Feb 05, 2020 at 02:39:44PM -0800, Kristen Carlson Accardi
> > wrote:
> > > Allow user to select CONFIG_FG_KASLR if dependencies are met.
> > > Change
> > > the make file to build with -ffunction-sections if CONFIG_FG_KASLR
> > > 
> > > Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
> > > ---
> > >  Makefile         |  4 ++++
> > >  arch/x86/Kconfig | 13 +++++++++++++
> > >  2 files changed, 17 insertions(+)
> > > 
> > > diff --git a/Makefile b/Makefile
> > > index c50ef91f6136..41438a921666 100644
> > > --- a/Makefile
> > > +++ b/Makefile
> > > @@ -846,6 +846,10 @@ ifdef CONFIG_LIVEPATCH
> > >  KBUILD_CFLAGS += $(call cc-option, -flive-patching=inline-clone)
> > >  endif
> > >  
> > > +ifdef CONFIG_FG_KASLR
> > > +KBUILD_CFLAGS += -ffunction-sections
> > > +endif
> > > +
> > 
> > With -ffunction-sections I get a few unreachable code warnings from
> > objtool.
> > 
> > [...]
> > net/mac80211/ibss.o: warning: objtool:
> > ieee80211_ibss_work.cold()+0x157: unreachable instruction
> > drivers/net/ethernet/intel/e1000/e1000_main.o: warning: objtool:
> > e1000_clean.cold()+0x0: unreachable instruction
> > net/core/skbuff.o: warning: objtool: skb_dump.cold()+0x3fd:
> > unreachable instruction
> 
> I'm still working on a solution, but the issue here is that any .cold
> function is going to be in a different section than the related
> function, and when objtool is searching for instructions in
> find_insn(), it assumes that it must be in the same section as the
> caller.

Can we teach objtool about this? It doesn't seem too unreasonable.

-- 
Kees Cook
