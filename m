Return-Path: <kernel-hardening-return-16163-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 6A4164895B
	for <lists+kernel-hardening@lfdr.de>; Mon, 17 Jun 2019 18:54:16 +0200 (CEST)
Received: (qmail 3457 invoked by uid 550); 17 Jun 2019 16:54:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3423 invoked from network); 17 Jun 2019 16:54:09 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=5GIOr0j5QD0GGMq5iNvz4pmaxjrJeMOWrcA3ngAjb7A=;
        b=WK8FGkjUVKq18qGzWscm8ahQHW1GUCF+ILUXe63ay3w9JUKolPUj+3YphhK0E8VUiO
         D3VHOeRgF69Os5dNYBD+3tBeL+QGWRxe4O1lUNffI+ciOxTZnQUOovBJ8QJgdVFafc4r
         vr9ia4ySytk0IJYT5noK89/yQrr24KTxwjB0P6wOHHrL6IXBMlSQnoyT65V9bcz8SQCW
         DT5wZDEmNGYbA9YuMMPBYvx3OLXoNdO+ZjLbq7Clkt9R8M322Au0gCU1XYbms5dQt9A3
         L+pOus4Fm3NyuNx6wxOGaBpjSeM0X2q/+qEIzrCnDdowFRbhBFU73gJDmUhuaF/pQcMj
         BBUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=5GIOr0j5QD0GGMq5iNvz4pmaxjrJeMOWrcA3ngAjb7A=;
        b=rIVovGIGJ+TZYa/0UAcWKdaDc9bs140ItPaTtZuwQBbSGE9cCpBhSV0+bQlL9IUH5X
         sGmyYLD/6ngM7SvsMTjgFnRHrDqyj5cSbVL0yZZ1LMvLIAMt7ubB7wUCj0oFlD8gIjof
         WEiN/52WCWmv6ULxEOVsIcSUAgujhxYHg0RfM+SdfMKzMUk8VzGtXSmggvPbcbEpmcjz
         P54zgskh+KZfNgUX4YiLlVApJL0sprwyuR1wOrL2aBq/eU4Mhq5nQ3LiIcdGpOHVxW6g
         k+pq4WOrAmbKsy83kbCX0UTtJwH8+0ypLGadhy9rui6wRPfsGOdlb/OcnmoBVorZqfpc
         iskQ==
X-Gm-Message-State: APjAAAXm1XNwwbByh8+sbd0BivM6rhBRB1xgMDlOhnZFaHd87eFOhYVn
	Qa/z2hMAVKFDI+De1Hue6wA=
X-Google-Smtp-Source: APXvYqxQvlJR/5/Ch56UVr+neR0wtCeYjFoYvDMw4Dtm/ZsiOnsiu5rpaDFdeLO8KgOLgtgCCaiS3A==
X-Received: by 2002:a63:5211:: with SMTP id g17mr46491750pgb.405.1560790437276;
        Mon, 17 Jun 2019 09:53:57 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [RFC 00/10] Process-local memory allocations for hiding KVM
 secrets
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <CALCETrVt=X+FB2cM5hMN9okvbcROFfT4_KMwaKaN2YVvc7UQTw@mail.gmail.com>
Date: Mon, 17 Jun 2019 09:53:54 -0700
Cc: Dave Hansen <dave.hansen@intel.com>,
 Alexander Graf <graf@amazon.com>,
 Thomas Gleixner <tglx@linutronix.de>,
 Marius Hillenbrand <mhillenb@amazon.de>,
 kvm list <kvm@vger.kernel.org>,
 LKML <linux-kernel@vger.kernel.org>,
 Kernel Hardening <kernel-hardening@lists.openwall.com>,
 Linux-MM <linux-mm@kvack.org>,
 Alexander Graf <graf@amazon.de>,
 David Woodhouse <dwmw@amazon.co.uk>,
 the arch/x86 maintainers <x86@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>
Content-Transfer-Encoding: 7bit
Message-Id: <5AA8BF10-8987-4FCB-870C-667A5228D97B@gmail.com>
References: <20190612170834.14855-1-mhillenb@amazon.de>
 <eecc856f-7f3f-ed11-3457-ea832351e963@intel.com>
 <A542C98B-486C-4849-9DAC-2355F0F89A20@amacapital.net>
 <alpine.DEB.2.21.1906141618000.1722@nanos.tec.linutronix.de>
 <58788f05-04c3-e71c-12c3-0123be55012c@amazon.com>
 <63b1b249-6bc7-ffd9-99db-d36dd3f1a962@intel.com>
 <CALCETrXph3Zg907kWTn6gAsZVsPbCB3A2XuNf0hy5Ez2jm2aNQ@mail.gmail.com>
 <698ca264-123d-46ae-c165-ed62ea149896@intel.com>
 <CALCETrVt=X+FB2cM5hMN9okvbcROFfT4_KMwaKaN2YVvc7UQTw@mail.gmail.com>
To: Andy Lutomirski <luto@kernel.org>
X-Mailer: Apple Mail (2.3445.104.11)

> On Jun 17, 2019, at 9:14 AM, Andy Lutomirski <luto@kernel.org> wrote:
> 
> On Mon, Jun 17, 2019 at 9:09 AM Dave Hansen <dave.hansen@intel.com> wrote:
>> On 6/17/19 8:54 AM, Andy Lutomirski wrote:
>>>>> Would that mean that with Meltdown affected CPUs we open speculation
>>>>> attacks against the mmlocal memory from KVM user space?
>>>> Not necessarily.  There would likely be a _set_ of local PGDs.  We could
>>>> still have pair of PTI PGDs just like we do know, they'd just be a local
>>>> PGD pair.
>>> Unfortunately, this would mean that we need to sync twice as many
>>> top-level entries when we context switch.
>> 
>> Yeah, PTI sucks. :)
>> 
>> For anyone following along at home, I'm going to go off into crazy
>> per-cpu-pgds speculation mode now...  Feel free to stop reading now. :)
>> 
>> But, I was thinking we could get away with not doing this on _every_
>> context switch at least.  For instance, couldn't 'struct tlb_context'
>> have PGD pointer (or two with PTI) in addition to the TLB info?  That
>> way we only do the copying when we change the context.  Or does that tie
>> the implementation up too much with PCIDs?
> 
> Hmm, that seems entirely reasonable.  I think the nasty bit would be
> figuring out all the interactions with PV TLB flushing.  PV TLB
> flushes already don't play so well with PCID tracking, and this will
> make it worse.  We probably need to rewrite all that code regardless.

How is PCID (as you implemented) related to TLB flushing of kernel (not
user) PTEs? These kernel PTEs would be global, so they would be invalidated
from all the address-spaces using INVLPG, I presume. No?

Having said that, the fact that every hypervisor implements PV-TLB
completely differently might be unwarranted.
