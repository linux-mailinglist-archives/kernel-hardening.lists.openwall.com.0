Return-Path: <kernel-hardening-return-18974-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 563011F9398
	for <lists+kernel-hardening@lfdr.de>; Mon, 15 Jun 2020 11:35:14 +0200 (CEST)
Received: (qmail 26096 invoked by uid 550); 15 Jun 2020 09:35:09 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 11497 invoked from network); 15 Jun 2020 08:07:51 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1592208459;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BeGGnxeP+9Ph9j16Zyt+G5pj4OrBDsCw7yZLIS0o8yM=;
	b=OJtSD4VryR7taP3fXrbaIO73SmntkmvJBGOsxLvLtXSTt8tnqOaUMo6mJJMppKEAdYBoik
	/ytpGIBhiHbjP1EMH4wfSqLjWHANv+zqjS7z23rCbtpkwfWP4r67NlSO6qxt8MzmfkWX6d
	Y2gKLTtd5IY42E8iBrptO//yYBuotGg=
X-MC-Unique: 8WceioPEOJCZlcRrQNay2w-1
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=+QGlrYD7CnoOZ2xHryUMQtseNDSspP2GFuEENx6xWTg=;
        b=YXk6K8Z+8gYBr79jevkBoAAXWZkwvQHjTMr/Sb2513dphWb8Kq6YzzW9HoWsUL++of
         AKK+Js3QnAnjS8dtkLYCA6H8WGU3B2IVTjyey/ZCgGrbBFBGDPZHmarNvCSou4D2rlld
         ppV3BPqnaCUH3yBwVM56lNX02zFjFoHIKlctb01biUBIiY7RRs1/7/jtnUfXb63DPSuc
         MlI+mdjmo0uE9XyxkzDTYksG4FAWYr4o1YcxReXN35iW8AgG3KHOAv13BlbK3tkgN8+P
         ypQYY/d2rSiGDL5Qa1vkBy7A/6Pld7qR5Xr8xZsjSLv5JMOFwIPpXHtFwhDKX7UrVw5s
         90wg==
X-Gm-Message-State: AOAM5333ueBobrFIgLciPiWAfa+0lCSRtXRrqU15P/OVv2wf9wpswpYN
	7ybifFHeNdBFpljHk7oZeCGNc3Gst22FpF9zdN7UkgIBUlguPzMZFqvH/Ge5lsNaW30SS2SwrVs
	3pdDGBT2kXs7fqmzBV916ZohI6AMG7E/lBw==
X-Received: by 2002:a17:90a:ad03:: with SMTP id r3mr11041334pjq.104.1592208446577;
        Mon, 15 Jun 2020 01:07:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzzQIhf04M46QfAh9dC0OF2x3Gg0pBCHU0ZNkauVlVtPuKKppWZqX7qMQYC9uA7dNku9F6pOQ==
X-Received: by 2002:a17:90a:ad03:: with SMTP id r3mr11041302pjq.104.1592208446284;
        Mon, 15 Jun 2020 01:07:26 -0700 (PDT)
Date: Mon, 15 Jun 2020 16:07:14 +0800
From: Gao Xiang <hsiangkao@redhat.com>
To: Jason Yan <yanaijie@huawei.com>
Cc: xiang@kernel.org, chao@kernel.org, gregkh@linuxfoundation.org,
	linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	Kees Cook <keescook@chromium.org>,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH] erofs: Eliminate usage of uninitialized_var() macro
Message-ID: <20200615080714.GB25317@xiangao.remote.csb>
References: <20200615040141.3627746-1-yanaijie@huawei.com>
 <20200615072521.GA25317@xiangao.remote.csb>
 <783fe4f9-fb1f-7f5e-c900-7e30d5c85222@huawei.com>
MIME-Version: 1.0
In-Reply-To: <783fe4f9-fb1f-7f5e-c900-7e30d5c85222@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: 8bit
Content-Disposition: inline

On Mon, Jun 15, 2020 at 03:43:09PM +0800, Jason Yan wrote:
> 
> 
> 在 2020/6/15 15:25, Gao Xiang 写道:
> > Hi Jason,
> > 
> > On Mon, Jun 15, 2020 at 12:01:41PM +0800, Jason Yan wrote:
> > > This is an effort to eliminate the uninitialized_var() macro[1].
> > > 
> > > The use of this macro is the wrong solution because it forces off ANY
> > > analysis by the compiler for a given variable. It even masks "unused
> > > variable" warnings.
> > > 
> > > Quoted from Linus[2]:
> > > 
> > > "It's a horrible thing to use, in that it adds extra cruft to the
> > > source code, and then shuts up a compiler warning (even the _reliable_
> > > warnings from gcc)."
> > > 
> > > The gcc option "-Wmaybe-uninitialized" has been disabled and this change
> > > will not produce any warnnings even with "make W=1".
> > > 
> > > [1] https://github.com/KSPP/linux/issues/81
> > > [2] https://lore.kernel.org/lkml/CA+55aFz2500WfbKXAx8s67wrm9=yVJu65TpLgN_ybYNv0VEOKA@mail.gmail.com/
> > > 
> > > Cc: Kees Cook <keescook@chromium.org>
> > > Cc: Chao Yu <yuchao0@huawei.com>
> > > Signed-off-by: Jason Yan <yanaijie@huawei.com>
> > > ---
> > 
> > I'm fine with the patch since "-Wmaybe-uninitialized" has been disabled and
> > I've also asked Kees for it in private previously.
> > 
> > I still remembered that Kees sent out a treewide patch. Sorry about that
> > I don't catch up it... But what is wrong with the original patchset?
> > 
> 
> Yes, Kees has remind me of that and I will let him handle it. So you can
> ignore this patch.

Okay, I was just wondering if this part should be send out via EROFS tree
for this cycle. However if there was an automatic generated patch by Kees,
I think perhaps Linus could pick them out directly. But anyway, both ways
are fine with me. ;) Ping me when needed.

Thanks,
Gao Xiang

> 
> Thanks,
> Jason
> 
> > Thanks,
> > Gao Xiang
> > 
> > 
> > .
> > 
> 

