Return-Path: <kernel-hardening-return-18088-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 8E9C217AFFE
	for <lists+kernel-hardening@lfdr.de>; Thu,  5 Mar 2020 21:51:18 +0100 (CET)
Received: (qmail 25933 invoked by uid 550); 5 Mar 2020 20:51:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 25899 invoked from network); 5 Mar 2020 20:51:13 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tycho-ws.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+KkcNSGG4PmqcHf5w0J/0EA5pqzwTNlZhZPBmrmp7lc=;
        b=aGAWUnq2cShWMA0rCbiRWuVCWELljpX3PB/FsEKGMOFKDXpvVY26swvU1c83ciEV+C
         vZfZPwlp/g4NcEdLGqpe73q7GJanZJzUj1PqzqD+1q/UbfbPfMtPUcBQqEQ1NG/baZT1
         Eg84AfRliEdTYVakSs34OEyTVaJcEodqXgcX/1DW2HbALNbr9n7Pe4axB/UldwC8oIhb
         e+LE398BVASwZokiGAXu+1GIxRuQENdZmZk6VIDtumHXmAfZsZufuaoMj2sBsHbO/Pb+
         hA0XbxlRv5htq2DMEsIiN1fAac252TMiClDppHPRIbUbRR8B1EbMDYwB0KsRmeF5LX2H
         gJpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+KkcNSGG4PmqcHf5w0J/0EA5pqzwTNlZhZPBmrmp7lc=;
        b=cS+qQmQVxtpxDknyRPZqQoDmaDljEPiC/wt1r1xYZ3d92FgduXmDIIjVCJA5dwuvTF
         tG9udegqoNsG0sGMwM67eQJS2fGyGtlF4k6rbLf3PFEIGe2iZD1cbd58OFiPWq8E8RDY
         /GGINtA68deSPDijPh5iJA/CpRQnhjf9Gt33oIHYNVSAMMFW84QkfYshHJ4pYjaEG6zW
         fPQ5aEzsUJVaBKvMvGVEckPbiRELAdiq8X5qz06B0KKjaMn9bemulJKrPWOXfvQopBUx
         MjmrjMMNM2cQwgC/EBSp7DSkTHxqR4Za8flTTfq8YL7MqgWmaOUacfzPB3b/3a4gKr+6
         +b5w==
X-Gm-Message-State: ANhLgQ0EjHFqt/coc9uVmaK0YJvQLqmOBGUCx2nj2b1Uxf+GqqJDEc/K
	DZ11se7wvAMMWNnYLQSf9Jt1bw==
X-Google-Smtp-Source: ADFU+vs50RkJRZ4RwwF6XWZXespcdsmaoCqqPgVtO/9DW5s3y9h2GpkJOYvZU+X77or1j5LpSjT7oQ==
X-Received: by 2002:a25:6a45:: with SMTP id f66mr119436ybc.63.1583441461260;
        Thu, 05 Mar 2020 12:51:01 -0800 (PST)
Date: Thu, 5 Mar 2020 13:50:54 -0700
From: Tycho Andersen <tycho@tycho.ws>
To: Arvind Sankar <nivedita@alum.mit.edu>
Cc: Kees Cook <keescook@chromium.org>, "Tobin C . Harding" <me@tobin.cc>,
	kernel-hardening@lists.openwall.com,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Paul Mackerras <paulus@samba.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc/32: Stop printing the virtual memory layout
Message-ID: <20200305205054.GD6506@cisco>
References: <202003021038.8F0369D907@keescook>
 <20200305150837.835083-1-nivedita@alum.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200305150837.835083-1-nivedita@alum.mit.edu>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Thu, Mar 05, 2020 at 10:08:37AM -0500, Arvind Sankar wrote:
> For security, don't display the kernel's virtual memory layout.
> 
> Kees Cook points out:
> "These have been entirely removed on other architectures, so let's
> just do the same for ia32 and remove it unconditionally."
> 
> 071929dbdd86 ("arm64: Stop printing the virtual memory layout")
> 1c31d4e96b8c ("ARM: 8820/1: mm: Stop printing the virtual memory layout")
> 31833332f798 ("m68k/mm: Stop printing the virtual memory layout")
> fd8d0ca25631 ("parisc: Hide virtual kernel memory layout")
> adb1fe9ae2ee ("mm/page_alloc: Remove kernel address exposure in free_reserved_area()")
> 
> Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>

Acked-by: Tycho Andersen <tycho@tycho.ws>
