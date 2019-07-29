Return-Path: <kernel-hardening-return-16599-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id E8FC078962
	for <lists+kernel-hardening@lfdr.de>; Mon, 29 Jul 2019 12:14:13 +0200 (CEST)
Received: (qmail 32004 invoked by uid 550); 29 Jul 2019 10:14:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 10108 invoked from network); 29 Jul 2019 07:00:56 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=x68WSHqzgOt8X1v6Nhk9LJIdr20J8mlA0StKGgUt7jU=;
        b=lMZEXZFQjwtoyDt4RSf6Vbz6DgysKTLhtFZubkL/qaKaTRYjLw428Efuv23wnkwqJQ
         GbJk6zGAHEVvHRH5Tw0pKajTYOM2GZbrWTECIQAY+VuQ5QkPGnJQxXpxCFq9Sb5/SVQb
         1hzketwWN4ebgYglRk1PB6+PlXwF1QaH30pAA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=x68WSHqzgOt8X1v6Nhk9LJIdr20J8mlA0StKGgUt7jU=;
        b=K1EhIgnR9HjPxnCQN/+CtlzoJC8UrjggwoZXQHCSdWdOniH6yBjyJE5PMQdRva1NDI
         4+0HQbgswZ4zNnDcXRi7z4GMGztKrymN0DmnvdQTkUZjS678Ts4jWfdAJAxg2K5ESdyL
         2u6+GOY7GJkZOHtwFqUrlbBfJW3+ccowjEvg7fTIs2x6z2Xls/THKPP8frvp5sTLAgY6
         ky8kIfrl1UN2gJKY9HxpXBSd+ek3xFNm9iA3l19/N06GyXAEuTjhWTFnIUpHXpb9ydXV
         z5DGHkLvZnqNr03mzCCRxCOuH1c3tJBqjZdRleRPN5su078kdRxBgjiuW/AObIgi9pAj
         d2lg==
X-Gm-Message-State: APjAAAUsQ3Ur9yziJbxjMfWipEOsmAt/KiArB9co4+9t+CiuHkTberFg
	hiu/da93C4nxw/IOvi8K+cw=
X-Google-Smtp-Source: APXvYqwRCGEBrkNmiEc2N0xdRuhPKQOYoNi2+1tLwh4iQHOeCG61louZm3CHBIJYGiFxgogXP5QSrA==
X-Received: by 2002:a17:90a:30e4:: with SMTP id h91mr106220547pjb.37.1564383643846;
        Mon, 29 Jul 2019 00:00:43 -0700 (PDT)
From: Daniel Axtens <dja@axtens.net>
To: Andrew Donnellan <ajd@linux.ibm.com>, Christopher M Riedl <cmr@informatik.wtf>, linuxppc-dev@ozlabs.org, kernel-hardening@lists.openwall.com
Cc: mjg59@google.com
Subject: Re: [RFC PATCH v2] powerpc/xmon: restrict when kernel is locked down
In-Reply-To: <87h88m2iu4.fsf@dja-thinkpad.axtens.net>
References: <20190524123816.1773-1-cmr@informatik.wtf> <81549d40-e477-6552-9a12-7200933279af@linux.ibm.com> <1146575236.484635.1559617524880@privateemail.com> <57844920-c17b-d93c-66c0-e6822af71929@linux.ibm.com> <87h88m2iu4.fsf@dja-thinkpad.axtens.net>
Date: Mon, 29 Jul 2019 17:00:38 +1000
Message-ID: <87ef29gwa1.fsf@dja-thinkpad.axtens.net>
MIME-Version: 1.0
Content-Type: text/plain

Hi Chris,

>>>> Remind me again why we need to clear breakpoints in integrity mode?
...
>> Integrity mode merely means we are aiming to prevent modifications to 
>> kernel memory. IMHO leaving existing breakpoints in place is fine as 
>> long as when we hit the breakpoint xmon is in read-only mode.
>>
...
> I think ajd is right. 
>
> I think about it like this. There are 2 transitions:
>
>  - into integrity mode
>
>    Here, we need to go into r/o, but do not need to clear breakpoints.
>    You can still insert breakpoints in readonly mode, so clearing them
>    just makes things more irritating rather than safer.
>
>  - into confidentiality mode
>
>    Here we need to purge breakpoints and disable xmon completely.

Would you be able to send a v2 with these changes? (that is, not purging
breakpoints when entering integrity mode)

Regards,
Daniel
