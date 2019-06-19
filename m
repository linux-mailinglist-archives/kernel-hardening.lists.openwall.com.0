Return-Path: <kernel-hardening-return-16190-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 86B594B448
	for <lists+kernel-hardening@lfdr.de>; Wed, 19 Jun 2019 10:43:39 +0200 (CEST)
Received: (qmail 7561 invoked by uid 550); 19 Jun 2019 08:42:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 28272 invoked from network); 19 Jun 2019 06:24:52 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=sujGvoRGZJ3i3KZSIFgr7wBrpESiCcd+VDm4gizC9fs=;
        b=GbiWq5vgFlAN0sNeKdhEmBifg8O5NWyoMcNgY0OqFifufBNe19n5knuKRlq4XnF5vX
         Ld3jJ3pAHShXy0SUi+zWjADEC4rjbmp20xjyeF+NkP6zKrbbj3gs4sUUt4QFryfhHRsu
         5XqmD6e7AxCLyz2+LkSm3vTMrHX16LYMlsBR4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=sujGvoRGZJ3i3KZSIFgr7wBrpESiCcd+VDm4gizC9fs=;
        b=AYz6uHvE6Co87LkXdzro+7QS2LbjB81+JMl2G0NujB0hbKCrhDQAv45UDbUYhGptvm
         RUo9BWfmE073tLoZQcAWbi1JFcebBh0h8DxmIT3kJoFjm6jpYzqewPIl0mSm4gmNP2i4
         hVu1kxlW+G0BRBDSvBPvpzTQt2HmklKe/DPwP6lc4+VbILpNAjrl8gl6ez6u68ZX7jhW
         rzX8vfVFmI5tsk8tMRCzFARSJNVYNlQS01QneAx7m63WqcctNHbYkAlCNuGfJO5yi+HZ
         Gf8zGdx2K4wvlidr3NLm8eb0i/3BYEqRwRCG/Gd0PTKBZwre4QsSVzZVn6D2b9ylVfey
         4zoA==
X-Gm-Message-State: APjAAAW58/+ofLVJP0r24tn+Vd8dEGfygb78T6sb2b20rZ2lLKN2/rQy
	a1JKt6IxXWYafJpez61LTshc8g==
X-Google-Smtp-Source: APXvYqzu7fTlAhAdwUAA5u9aktaFiTv30wSiaYPtCc9idEzMq6pIPcjwS4Sw9C6jvTsPApRo3UNd+Q==
X-Received: by 2002:a62:ab18:: with SMTP id p24mr2987259pff.113.1560925479811;
        Tue, 18 Jun 2019 23:24:39 -0700 (PDT)
From: Daniel Axtens <dja@axtens.net>
To: Andrew Donnellan <ajd@linux.ibm.com>, Christopher M Riedl <cmr@informatik.wtf>, linuxppc-dev@ozlabs.org, kernel-hardening@lists.openwall.com
Cc: mjg59@google.com
Subject: Re: [RFC PATCH v2] powerpc/xmon: restrict when kernel is locked down
In-Reply-To: <57844920-c17b-d93c-66c0-e6822af71929@linux.ibm.com>
References: <20190524123816.1773-1-cmr@informatik.wtf> <81549d40-e477-6552-9a12-7200933279af@linux.ibm.com> <1146575236.484635.1559617524880@privateemail.com> <57844920-c17b-d93c-66c0-e6822af71929@linux.ibm.com>
Date: Wed, 19 Jun 2019 16:24:35 +1000
Message-ID: <87h88m2iu4.fsf@dja-thinkpad.axtens.net>
MIME-Version: 1.0
Content-Type: text/plain

Andrew Donnellan <ajd@linux.ibm.com> writes:

> On 4/6/19 1:05 pm, Christopher M Riedl wrote:>>> +	if (!xmon_is_ro) {
>>>> +		xmon_is_ro = kernel_is_locked_down("Using xmon write-access",
>>>> +						   LOCKDOWN_INTEGRITY);
>>>> +		if (xmon_is_ro) {
>>>> +			printf("xmon: Read-only due to kernel lockdown\n");
>>>> +			clear_all_bpt();
>>>
>>> Remind me again why we need to clear breakpoints in integrity mode?
>>>
>>>
>>> Andrew
>>>
>> 
>> I interpreted "integrity" mode as meaning that any changes made by xmon should
>> be reversed. This also covers the case when a user creates some breakpoint(s)
>> in xmon, exits xmon, and then elevates the lockdown state. Upon hitting the
>> first breakpoint and (re-)entering xmon, xmon will clear all breakpoints.
>> 
>> Xmon can only take action in response to dynamic lockdown level changes when
>> xmon is invoked in some manner - if there is a better way I am all ears :)
>> 
>
> Integrity mode merely means we are aiming to prevent modifications to 
> kernel memory. IMHO leaving existing breakpoints in place is fine as 
> long as when we hit the breakpoint xmon is in read-only mode.
>
> (dja/mpe might have opinions on this)

Apologies for taking so long to get back to you.

I think ajd is right. 

I think about it like this. There are 2 transitions:

 - into integrity mode

   Here, we need to go into r/o, but do not need to clear breakpoints.
   You can still insert breakpoints in readonly mode, so clearing them
   just makes things more irritating rather than safer.

 - into confidentiality mode

   Here we need to purge breakpoints and disable xmon completely.

Kind regards,
Daniel

>
> -- 
> Andrew Donnellan              OzLabs, ADL Canberra
> ajd@linux.ibm.com             IBM Australia Limited
