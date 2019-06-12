Return-Path: <kernel-hardening-return-16119-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 2F82B4313F
	for <lists+kernel-hardening@lfdr.de>; Wed, 12 Jun 2019 22:56:55 +0200 (CEST)
Received: (qmail 11924 invoked by uid 550); 12 Jun 2019 20:56:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 11864 invoked from network); 12 Jun 2019 20:56:47 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=TZPBYSKEoaIkhIv00E3WuJ5aJFmWavGoQVJ9IN5iIvo=;
        b=YKatqYp5ZMD0rZsPMDq0to0PJDreG1XUyrx5SqWGPFgdgJtrZRf5AOIxLF1RFphdWH
         R8Uycb+uWLqjH30x5HeS9diZaO6zEKBi4ehrFWwTQQhEoyWIgNqsqXzSVDTswGRL/9KD
         uhKfahNauFol7O1XFQvxQp5RulEWOEW7iex6oysSu++JNYIgkrqn3WOcSrgDk5zaBXNp
         8B+4btiQ/WZSa7P4mcOyuxUL08dr8X75WN0f9Llk7Bg6kYQ1G/dW5uqsTcyfJCabZyCo
         CSzxOII00f5vEnofzolLz3aqRMf0Y2IeopHbP2PjiAMHgx7OfqBg8uf57PLTsF74jSYO
         KVmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=TZPBYSKEoaIkhIv00E3WuJ5aJFmWavGoQVJ9IN5iIvo=;
        b=RhMV2CjTElhqjFdpsowmbbwSa/6vyQIqGSZwBqm5srKLpp+MDgXW9ai7veSwniD+ro
         yVsX78GSk2dy5uLqOaYbnNWZhMPAj98CYUQo4jKCa0AlciiL9eJIYhdV5D3EEEXgI0sn
         s81exTJplz0SDr6D8TrLI8h1zvEtSFLfGIrQodKBSC0TO6QYOn/M3zUjkwaP9Ypcj41t
         SYrS/qJtUneW4DejXdYRCV43f128hTCSwHgFU5w/afU9FJ/rWIsFoSNqhl4sH3K9hO8h
         Ekru67iTIcQh1pD9LTpUWQNC1KL9S5KpQTpGHvO3AHFVyTDdJhbJgv4YEvquPdabgPo0
         Gc5g==
X-Gm-Message-State: APjAAAW66wwsZAeO+NCcq1FnXS+7I16UvVWviX42rdrJiBq7cB6JrbNf
	6gyWJLzl4aptKXLlDRt6SlB+qQ==
X-Google-Smtp-Source: APXvYqxo/ItMtB3OUs84fhqaf0UCPf/u6DxMcudVwkkrFpAqbneRAxpY8FuZIOMzxuIx2mCUlvJvAg==
X-Received: by 2002:aa7:90ce:: with SMTP id k14mr89000454pfk.239.1560372995458;
        Wed, 12 Jun 2019 13:56:35 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [RFC 00/10] Process-local memory allocations for hiding KVM secrets
From: Andy Lutomirski <luto@amacapital.net>
X-Mailer: iPhone Mail (16F203)
In-Reply-To: <3cd533c1-3f18-a84f-fbb2-264751ed3eeb@intel.com>
Date: Wed, 12 Jun 2019 13:56:31 -0700
Cc: Marius Hillenbrand <mhillenb@amazon.de>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
 linux-mm@kvack.org, Alexander Graf <graf@amazon.de>,
 David Woodhouse <dwmw@amazon.co.uk>,
 the arch/x86 maintainers <x86@kernel.org>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <FD3482AC-3FB0-41DE-9347-5BD7C3DE8B11@amacapital.net>
References: <20190612170834.14855-1-mhillenb@amazon.de> <eecc856f-7f3f-ed11-3457-ea832351e963@intel.com> <A542C98B-486C-4849-9DAC-2355F0F89A20@amacapital.net> <3cd533c1-3f18-a84f-fbb2-264751ed3eeb@intel.com>
To: Dave Hansen <dave.hansen@intel.com>



> On Jun 12, 2019, at 1:41 PM, Dave Hansen <dave.hansen@intel.com> wrote:
>=20
> On 6/12/19 1:27 PM, Andy Lutomirski wrote:
>>> We've discussed having per-cpu page tables where a given PGD is
>>> only in use from one CPU at a time.  I *think* this scheme still
>>> works in such a case, it just adds one more PGD entry that would
>>> have to context-switched.
>> Fair warning: Linus is on record as absolutely hating this idea. He
>> might change his mind, but it=E2=80=99s an uphill battle.
>=20
> Just to be clear, are you referring to the per-cpu PGDs, or to this
> patch set with a per-mm kernel area?

per-CPU PGDs=
