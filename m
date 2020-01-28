Return-Path: <kernel-hardening-return-17634-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id A190114C335
	for <lists+kernel-hardening@lfdr.de>; Wed, 29 Jan 2020 00:02:15 +0100 (CET)
Received: (qmail 30659 invoked by uid 550); 28 Jan 2020 23:02:09 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 30637 invoked from network); 28 Jan 2020 23:02:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+dg91h5BizLIOhJtrfPoQX1PBXFzRkzG/EccKIP5g+k=;
        b=SLEtsTXM5HHL6KRx3hcUWmwHu6WOPgN0CNP8fHNTI+FAT+8rXdOFNHQ4Yag2eY0oom
         MxIjkObrnioymch5q5MyrzGbWNjwhgMUswCx/M+MVBVQAe23jccXfrAxinTI930p2387
         D9bys2Kwzdd099/FcXPhmwL9QuGCzxCyDD8ZA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+dg91h5BizLIOhJtrfPoQX1PBXFzRkzG/EccKIP5g+k=;
        b=N6M7qqZuUCen84aGtx0YARSEaf7EO1heqJA0Tc8gIWkoZdsvMPDIGVWr2gCGDwICJd
         kY+KY6k5SZ+OO0KSjvExbNF0KeNDIRbS8jbS3aAtWlC6wwQBVgrB/QevTk6jCdAR/+WY
         Di3OMln34OxnxHyqyRRKz6ktcSY8O+fE19ULAokAgp8fzQWSe2xRNUi3mtnkRQKTJ3Hk
         TBZqo2I0ezAXG5ReEP0klbZzfGyZswJ51fzsZDThgw8AAelYE3XUgrmNLG72KUHVg0eo
         ijTqB5PNVzlZ5+nBYOAJeGgAkyIdtOtPu1P2TORkZT7J3Jn49DjqSGJUPxZYm4+2u9B8
         6YWQ==
X-Gm-Message-State: APjAAAXyo8iLxgSKpasqBtlUDCNBvyX2eVvoXP77TS9lhvBr9aCSCln9
	J052xsF/5PDigmKqMJC3GyV+4w==
X-Google-Smtp-Source: APXvYqxW3ZrU4wM0/mAVtxUyqtcw5VzYRKNT21IpKIlpAgs8GJ04bta0GGU8Rs7byefZaonYLylsnQ==
X-Received: by 2002:aa7:82d5:: with SMTP id f21mr6360681pfn.245.1580252515843;
        Tue, 28 Jan 2020 15:01:55 -0800 (PST)
Date: Tue, 28 Jan 2020 15:01:53 -0800
From: Kees Cook <keescook@chromium.org>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Jiri Slaby <jslaby@suse.cz>, Julian Wiedmann <jwi@linux.ibm.com>,
	Ursula Braun <ubraun@linux.ibm.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-kernel@vger.kernel.org, David Windsor <dave@nullcore.net>,
	Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Christoph Lameter <cl@linux.com>,
	"David S. Miller" <davem@davemloft.net>,
	Laura Abbott <labbott@redhat.com>,
	Mark Rutland <mark.rutland@arm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Christoffer Dall <christoffer.dall@linaro.org>,
	Dave Kleikamp <dave.kleikamp@oracle.com>, Jan Kara <jack@suse.cz>,
	Luis de Bethencourt <luisbg@kernel.org>,
	Marc Zyngier <marc.zyngier@arm.com>, Rik van Riel <riel@redhat.com>,
	Matthew Garrett <mjg59@google.com>, linux-fsdevel@vger.kernel.org,
	linux-arch@vger.kernel.org, netdev@vger.kernel.org,
	kernel-hardening@lists.openwall.com,
	Vlastimil Babka <vbabka@suse.cz>, Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [kernel-hardening] [PATCH 09/38] usercopy: Mark kmalloc caches
 as usercopy caches
Message-ID: <202001281457.FA11CC313A@keescook>
References: <1515636190-24061-1-git-send-email-keescook@chromium.org>
 <1515636190-24061-10-git-send-email-keescook@chromium.org>
 <9519edb7-456a-a2fa-659e-3e5a1ff89466@suse.cz>
 <201911121313.1097D6EE@keescook>
 <201911141327.4DE6510@keescook>
 <bfca96db-bbd0-d958-7732-76e36c667c68@suse.cz>
 <202001271519.AA6ADEACF0@keescook>
 <5861936c-1fe1-4c44-d012-26efa0c8b6e7@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5861936c-1fe1-4c44-d012-26efa0c8b6e7@de.ibm.com>

On Tue, Jan 28, 2020 at 08:58:31AM +0100, Christian Borntraeger wrote:
> 
> 
> On 28.01.20 00:19, Kees Cook wrote:
> > On Thu, Jan 23, 2020 at 09:14:20AM +0100, Jiri Slaby wrote:
> >> On 14. 11. 19, 22:27, Kees Cook wrote:
> >>> On Tue, Nov 12, 2019 at 01:21:54PM -0800, Kees Cook wrote:
> >>>> How is iucv the only network protocol that has run into this? Do others
> >>>> use a bounce buffer?
> >>>
> >>> Another solution would be to use a dedicated kmem cache (instead of the
> >>> shared kmalloc dma one)?
> >>
> >> Has there been any conclusion to this thread yet? For the time being, we
> >> disabled HARDENED_USERCOPY on s390...
> >>
> >> https://lore.kernel.org/kernel-hardening/9519edb7-456a-a2fa-659e-3e5a1ff89466@suse.cz/
> > 
> > I haven't heard anything new. What did people think of a separate kmem
> > cache?
> > 
> 
> Adding Julian and Ursula. A separate kmem cache for iucv might be indeed
> a solution for the user hardening issue.

It should be very clean -- any existing kmallocs already have to be
"special" in the sense that they're marked with the DMA flag. So
converting these to a separate cache should be mostly mechanical.

> On the other hand not marking the DMA caches still seems questionable.

My understanding is that exposing DMA memory to userspace copies can
lead to unexpected results, especially for misbehaving hardware, so I'm
not convinced this is a generically bad hardening choice.

-Kees

> 
> For reference
> https://bugzilla.suse.com/show_bug.cgi?id=1156053
> the kernel hardening now triggers a warning.
> 

-- 
Kees Cook
