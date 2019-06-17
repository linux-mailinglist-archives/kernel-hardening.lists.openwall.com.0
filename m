Return-Path: <kernel-hardening-return-16166-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 672CF48CF4
	for <lists+kernel-hardening@lfdr.de>; Mon, 17 Jun 2019 20:50:56 +0200 (CEST)
Received: (qmail 16208 invoked by uid 550); 17 Jun 2019 18:50:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 16161 invoked from network); 17 Jun 2019 18:50:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=YT9HuF+UAL5f5ci7H4JzJ/S6XavqO8+S9ops45crT04=;
        b=Zfpt3uunBLYcSG089usKV8UfK0qMkW9RgZ/ht+cK7fx45yQdRXzuM4k6DPI6zvCSfi
         0b3jkIINqBOHb/zU/1f0XcGlK9C4FAg1iZvHzrqz40G30DXvdJOSbiC4XdmQGerLkQoR
         aT5EgFrx3EcOeDl7CDlpQ/A7/rYmh9HJ3rnFe7W2D9/WpSraIO3SQSjJc5BPwRcg+dHw
         SPuWuixjDd2kTd8bJJKGjPMpHwnDksjI2b6kT33SjyErxJAJ+adv5BIpRJz1FUgmsg31
         WMNCDArPFaqyMrcsw7wSYB32SF083r7pR7XN3BQJ2niCYfBu5lNlOnPi4o+qmzNvSq00
         xS6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=YT9HuF+UAL5f5ci7H4JzJ/S6XavqO8+S9ops45crT04=;
        b=bkQqEDmhq3sMZLvJEdGbmsacTJQMhtFlySLvLf6jwoGB0wWhhTyKq9YMQLHQZQG3e0
         thWXa+SAUiwjSyllE1C4JhKi/IEV7qDMGGRaxT80VpTB1rDVq/6PHkp19wfk5qvy/IuR
         T2PdZwcpUvfmYYcUbaCMj8jno5K4ml5Rv1lJEUc1f2UpRBulYiOWNqtEo9NizJ31Bodm
         cOLkH70fMSE5DdK9Tq0DqniCFXyHBTbDsDcJp3MHMDVDhv6wIare/0G/MzqHxKX865tb
         qzkd0Rn4mN8FmTq+kunX+wp1k9JyRO1BbxO6dbZCuGa+kkV1yrBdq1Rtp27PGOS1bLjP
         8OYA==
X-Gm-Message-State: APjAAAX0WHg9EPOLUKQzS5daPdu59aly8D1CeQLRoTex4lKPOF6WZd71
	JlQJ/hoffnRsJHiHIpkatbA=
X-Google-Smtp-Source: APXvYqx5UAroLnXpaBq2i2aaY3z6bqvsMT+mzSSAf5PPJfwRApihHPP0h7obDCWJIslPN6lv94WgXg==
X-Received: by 2002:a17:902:2862:: with SMTP id e89mr110159490plb.258.1560797436896;
        Mon, 17 Jun 2019 11:50:36 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [RFC 00/10] Process-local memory allocations for hiding KVM
 secrets
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <f6f352ed-750e-d735-a1c9-7ff133ca8aea@intel.com>
Date: Mon, 17 Jun 2019 11:50:34 -0700
Cc: Andy Lutomirski <luto@kernel.org>,
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
Content-Transfer-Encoding: quoted-printable
Message-Id: <3131CDA2-F6CF-43AC-A9FC-448DC6983596@gmail.com>
References: <20190612170834.14855-1-mhillenb@amazon.de>
 <eecc856f-7f3f-ed11-3457-ea832351e963@intel.com>
 <A542C98B-486C-4849-9DAC-2355F0F89A20@amacapital.net>
 <alpine.DEB.2.21.1906141618000.1722@nanos.tec.linutronix.de>
 <58788f05-04c3-e71c-12c3-0123be55012c@amazon.com>
 <63b1b249-6bc7-ffd9-99db-d36dd3f1a962@intel.com>
 <CALCETrXph3Zg907kWTn6gAsZVsPbCB3A2XuNf0hy5Ez2jm2aNQ@mail.gmail.com>
 <698ca264-123d-46ae-c165-ed62ea149896@intel.com>
 <CALCETrVt=X+FB2cM5hMN9okvbcROFfT4_KMwaKaN2YVvc7UQTw@mail.gmail.com>
 <5AA8BF10-8987-4FCB-870C-667A5228D97B@gmail.com>
 <f6f352ed-750e-d735-a1c9-7ff133ca8aea@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
X-Mailer: Apple Mail (2.3445.104.11)

> On Jun 17, 2019, at 11:07 AM, Dave Hansen <dave.hansen@intel.com> =
wrote:
>=20
> On 6/17/19 9:53 AM, Nadav Amit wrote:
>>>> For anyone following along at home, I'm going to go off into crazy
>>>> per-cpu-pgds speculation mode now...  Feel free to stop reading =
now. :)
>>>>=20
>>>> But, I was thinking we could get away with not doing this on =
_every_
>>>> context switch at least.  For instance, couldn't 'struct =
tlb_context'
>>>> have PGD pointer (or two with PTI) in addition to the TLB info?  =
That
>>>> way we only do the copying when we change the context.  Or does =
that tie
>>>> the implementation up too much with PCIDs?
>>> Hmm, that seems entirely reasonable.  I think the nasty bit would be
>>> figuring out all the interactions with PV TLB flushing.  PV TLB
>>> flushes already don't play so well with PCID tracking, and this will
>>> make it worse.  We probably need to rewrite all that code =
regardless.
>> How is PCID (as you implemented) related to TLB flushing of kernel =
(not
>> user) PTEs? These kernel PTEs would be global, so they would be =
invalidated
>> from all the address-spaces using INVLPG, I presume. No?
>=20
> The idea is that you have a per-cpu address space.  Certain kernel
> virtual addresses would map to different physical address based on =
where
> you are running.  Each of the physical addresses would be "owned" by a
> single CPU and would, by convention, never use a PGD that mapped an
> address unless that CPU that "owned" it.
>=20
> In that case, you never really invalidate those addresses.

I understand, but as I see it, this is not related directly to PCIDs.

