Return-Path: <kernel-hardening-return-16837-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 6DD60A2E62
	for <lists+kernel-hardening@lfdr.de>; Fri, 30 Aug 2019 06:30:21 +0200 (CEST)
Received: (qmail 23610 invoked by uid 550); 30 Aug 2019 04:30:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 23574 invoked from network); 30 Aug 2019 04:30:14 -0000
Date: Fri, 30 Aug 2019 14:29:58 +1000
From: Dave Chinner <david@fromorbit.com>
To: Kees Cook <keescook@chromium.org>
Cc: Jason Yan <yanaijie@huawei.com>, kernel-hardening@lists.openwall.com,
	linux-fsdevel@vger.kernel.org
Subject: Re: CONFIG_HARDENED_USERCOPY
Message-ID: <20190830042958.GC7777@dread.disaster.area>
References: <6e02a518-fea9-19fe-dca7-0323a576750d@huawei.com>
 <201908290914.F0F929EA@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201908290914.F0F929EA@keescook>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
	a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
	a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
	a=7-415B0cAAAA:8 a=hzK9nwXln0vweuEjbcYA:9 a=CjuIK1q_8ugA:10
	a=biEYGPWJfzWAr4FL6Ov7:22

On Thu, Aug 29, 2019 at 09:15:36AM -0700, Kees Cook wrote:
> On Thu, Aug 29, 2019 at 08:42:30PM +0800, Jason Yan wrote:
> > We found an issue of kernel bug related to HARDENED_USERCOPY.
> > When copying an IO buffer to userspace, HARDENED_USERCOPY thought it is
> > illegal to copy this buffer. Actually this is because this IO buffer was
> > merged from two bio vectors, and the two bio vectors buffer was allocated
> > with kmalloc() in the filesystem layer.
> 
> Ew. I thought the FS layer was always using page_alloc?

No, they don't. It's perfectly legal to use heap memory for bio
buffers - we've been doing it since, at least, XFS got merged all
those years ago.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
