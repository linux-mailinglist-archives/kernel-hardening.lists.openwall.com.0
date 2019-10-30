Return-Path: <kernel-hardening-return-17170-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id DDD05EA314
	for <lists+kernel-hardening@lfdr.de>; Wed, 30 Oct 2019 19:12:28 +0100 (CET)
Received: (qmail 28571 invoked by uid 550); 30 Oct 2019 18:12:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 28539 invoked from network); 30 Oct 2019 18:12:22 -0000
Date: Wed, 30 Oct 2019 19:12:08 +0100
From: Christoph Hellwig <hch@lst.de>
To: Shyam Saini <mayhs11saini@gmail.com>
Cc: kernel-hardening@lists.openwall.com, iommu@lists.linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Christoph Hellwig <hch@lst.de>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Matthew Wilcox <willy@infradead.org>,
	Christopher Lameter <cl@linux.com>,
	Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH V2] kernel: dma: contigous: Make CMA parameters
 __initdata/__initconst
Message-ID: <20191030181208.GA19513@lst.de>
References: <20191020050322.2634-1-mayhs11saini@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191020050322.2634-1-mayhs11saini@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Applied to the dma-mapping for-next branch after fixing up the commit
message and an overly long line.
