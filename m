Return-Path: <kernel-hardening-return-17774-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 0C8B2158C48
	for <lists+kernel-hardening@lfdr.de>; Tue, 11 Feb 2020 11:00:25 +0100 (CET)
Received: (qmail 25664 invoked by uid 550); 11 Feb 2020 10:00:20 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 25644 invoked from network); 11 Feb 2020 10:00:19 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581415207;
	bh=Rf1cVsXYoyZPTMZMbH8vZlwFAWASWhkCsYObkjMQ9Ko=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ZjYMZLNqPENaRh+mcuqb7UfkV1Eo12AXIsjC468Zej2Z0m3Xd4BRmSMg9JSvvGj5H
	 d9HH7b+bMenMTDHwqZ70TklYjBBZWv2Wy0UHKUXpqRyPPMqRkx8b8FAYDwNKRYW4Ui
	 v81OVzKUWodAvvqpc8bQnpxEao6X/kS36AWJyp8o=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 11 Feb 2020 10:00:01 +0000
From: Marc Zyngier <maz@kernel.org>
To: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>,
 Sami Tolvanen <samitolvanen@google.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Masami
 Hiramatsu <mhiramat@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
 Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, Laura
 Abbott <labbott@redhat.com>, Nick Desaulniers <ndesaulniers@google.com>,
 Jann Horn <jannh@google.com>, Miguel Ojeda
 <miguel.ojeda.sandonis@gmail.com>, Masahiro Yamada
 <yamada.masahiro@socionext.com>, clang-built-linux@googlegroups.com,
 kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 09/11] arm64: disable SCS for hypervisor code
In-Reply-To: <20200211095519.GB8560@willie-the-truck>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20200128184934.77625-1-samitolvanen@google.com>
 <20200128184934.77625-10-samitolvanen@google.com>
 <6f62b3c0-e796-e91c-f53b-23bd80fcb065@arm.com>
 <20200210175214.GA23318@willie-the-truck>
 <20200210180327.GB20840@lakrids.cambridge.arm.com>
 <20200210180740.GA24354@willie-the-truck>
 <43839239237869598b79cab90e100127@kernel.org>
 <20200211095519.GB8560@willie-the-truck>
Message-ID: <fed83df0e9140b9655b00f315814fab8@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: will@kernel.org, mark.rutland@arm.com, james.morse@arm.com, samitolvanen@google.com, catalin.marinas@arm.com, rostedt@goodmis.org, mhiramat@kernel.org, ard.biesheuvel@linaro.org, Dave.Martin@arm.com, keescook@chromium.org, labbott@redhat.com, ndesaulniers@google.com, jannh@google.com, miguel.ojeda.sandonis@gmail.com, yamada.masahiro@socionext.com, clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On 2020-02-11 09:55, Will Deacon wrote:
> On Tue, Feb 11, 2020 at 09:14:52AM +0000, Marc Zyngier wrote:
>> On 2020-02-10 18:07, Will Deacon wrote:
>> > On Mon, Feb 10, 2020 at 06:03:28PM +0000, Mark Rutland wrote:
>> > > On Mon, Feb 10, 2020 at 05:52:15PM +0000, Will Deacon wrote:
>> > > > On Mon, Feb 10, 2020 at 05:18:58PM +0000, James Morse wrote:
>> > > > > On 28/01/2020 18:49, Sami Tolvanen wrote:
>> > > > > > Filter out CC_FLAGS_SCS and -ffixed-x18 for code that runs at a
>> > > > > > different exception level.
>> > > > >
>> > > > > Hmmm, there are two things being disabled here.
>> > > > >
>> > > > > Stashing the lr in memory pointed to by VA won't work transparently at EL2 ... but
>> > > > > shouldn't KVM's C code still treat x18 as a fixed register?
>> > > >
>> > > > My review of v6 suggested dropping the -ffixed-x18 as well, since it's only
>> > > > introduced by SCS (in patch 5) and so isn't required by anything else. Why
>> > > > do you think it's needed?
>> > >
>> > > When EL1 code calls up to hyp, it expects x18 to be preserved across
>> > > the
>> > > call, so hyp needs to either preserve it explicitly across a
>> > > transitions
>> > > from/to EL1 or always preserve it.
>> >
>> > I thought we explicitly saved/restored it across the call after
>> > af12376814a5 ("arm64: kvm: stop treating register x18 as caller save").
>> > Is
>> > that not sufficient?
>> >
>> > > The latter is easiest since any code used by VHE hyp code will need
>> > > x18
>> > > saved anyway (ans so any common hyp code needs to).
>> >
>> > I would personally prefer to split the VHE and non-VHE code so they can
>> > be
>> > compiled with separate options.
>> 
>> This is going to generate a lot of code duplication (or at least 
>> object
>> duplication),
>> as the two code paths are intricately linked and splitting them to 
>> support
>> different
>> compilation options and/or calling conventions.
>> 
>> I'm not fundamentally opposed to that, but it should come with ways to 
>> still
>> manage it as a unified code base as much as possible, as ways to 
>> discard the
>> unused part at runtime (which should become easy to do once we have 
>> two
>> distinct sets of objects).
> 
> Agreed, and I don't want to hold up the SCS patches because of this. 
> I'm
> just nervous about the function attribute because I've only ever had
> terrible experiences with them. Maybe it will work this time (!)

I have the same experience chasing missing __hyp_text attributes. Until 
we
have tooling that picks on this *at compile time*, we'll have to play
wack-a-mole with them...

         M.
-- 
Jazz is not dead. It just smells funny...
