Return-Path: <kernel-hardening-return-16117-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id BF32E430FE
	for <lists+kernel-hardening@lfdr.de>; Wed, 12 Jun 2019 22:27:25 +0200 (CEST)
Received: (qmail 30232 invoked by uid 550); 12 Jun 2019 20:27:20 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 30194 invoked from network); 12 Jun 2019 20:27:19 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=wQSIjj1uz1dtSEsQ8et37d1oi55PupCcmG/N44FomHg=;
        b=dosYpfHyXQnOIHiak4h4vT7DtMsiDthIYDzQhi40A07vw+2UujEnaY2h1t/znWnsFr
         quz6BW2DabQNadx+sDAO2O97r0jLz2nrIHQjYC9CHjraeetUerSWSoTLviI8HPycXoZZ
         EhrCJYG29dvXZxU6C2YJtgjuh1T7f1raROHKgUW3XwqaYfDhqi2gu8n47/JClJNSwZFK
         Cy50WsRvmzOO0Wm82pvIO18xzLdWmPQlSHYbVv4RpfrfhpGtr7WHpa/8Vj6GKkjUbi4J
         I1Lys/X6FYmMf0ochoRNkJNNr7r0V1GDgqmSXn2lH+6rIIfw12YCjQ4hkbB9ywHjoOzK
         tg3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=wQSIjj1uz1dtSEsQ8et37d1oi55PupCcmG/N44FomHg=;
        b=CHUQADWHzgX9Z8VzqZAJRqDy8vwzqgJKPLgabSB5UM/ZiM7JbwhRaxZbgtrSeEjvbu
         9NfGot8mPl3hGaI5kFVWB61bk9UxztJ3+uJqErU80P0h8NCPqruOSvahJwJ2wIMWneRv
         snbachrVI5eXGTqIL4prYonjgLjdDle64z4Fe98D+AqnaT00TAyEiTM1dOa6K1431czw
         C6bJJ/0RuDLe5aWHvPYJReiDMPJflxmJvurqiQFyeG3liL+SEbqDv5ZG7AVRCKm1Z5b8
         b/8fRrmEfbA6LVzzQTiuYDiN1FgEFVk1UzRWZ1Wi+rKlIm1TT8UfEszFTMDIoqRyKLd8
         l+WQ==
X-Gm-Message-State: APjAAAWEyaZNApyXmrYF80nVkHCr8POCUSxafKv526T0LZUNU5XiNkXL
	hABnDseNg9I3LE6JyEckzaMs6Q==
X-Google-Smtp-Source: APXvYqz0dHD5fq+ketC5HFnEXuKjsrvf/JQonYxBDCeP2VEnkY8AJZcbmbqYowRApnU+lnXqwECpog==
X-Received: by 2002:a17:902:760f:: with SMTP id k15mr58881187pll.125.1560371227543;
        Wed, 12 Jun 2019 13:27:07 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [RFC 00/10] Process-local memory allocations for hiding KVM secrets
From: Andy Lutomirski <luto@amacapital.net>
X-Mailer: iPhone Mail (16F203)
In-Reply-To: <eecc856f-7f3f-ed11-3457-ea832351e963@intel.com>
Date: Wed, 12 Jun 2019 13:27:04 -0700
Cc: Marius Hillenbrand <mhillenb@amazon.de>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
 linux-mm@kvack.org, Alexander Graf <graf@amazon.de>,
 David Woodhouse <dwmw@amazon.co.uk>,
 the arch/x86 maintainers <x86@kernel.org>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <A542C98B-486C-4849-9DAC-2355F0F89A20@amacapital.net>
References: <20190612170834.14855-1-mhillenb@amazon.de> <eecc856f-7f3f-ed11-3457-ea832351e963@intel.com>
To: Dave Hansen <dave.hansen@intel.com>



> On Jun 12, 2019, at 12:55 PM, Dave Hansen <dave.hansen@intel.com> wrote:
>=20
>> On 6/12/19 10:08 AM, Marius Hillenbrand wrote:
>> This patch series proposes to introduce a region for what we call
>> process-local memory into the kernel's virtual address space.=20
>=20
> It might be fun to cc some x86 folks on this series.  They might have
> some relevant opinions. ;)
>=20
> A few high-level questions:
>=20
> Why go to all this trouble to hide guest state like registers if all the
> guest data itself is still mapped?
>=20
> Where's the context-switching code?  Did I just miss it?
>=20
> We've discussed having per-cpu page tables where a given PGD is only in
> use from one CPU at a time.  I *think* this scheme still works in such a
> case, it just adds one more PGD entry that would have to context-switched.=


Fair warning: Linus is on record as absolutely hating this idea. He might ch=
ange his mind, but it=E2=80=99s an uphill battle.=
