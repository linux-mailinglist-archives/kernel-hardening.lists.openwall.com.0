Return-Path: <kernel-hardening-return-21474-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 66A6E44F8D1
	for <lists+kernel-hardening@lfdr.de>; Sun, 14 Nov 2021 16:48:30 +0100 (CET)
Received: (qmail 26398 invoked by uid 550); 14 Nov 2021 15:48:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 26054 invoked from network); 14 Nov 2021 15:45:32 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=1fqt4RZHpU7qFJuzFqI1H78E6IxKKO9+0LC3as8rskQ=;
        b=QLyrd50D2+gddfO/MdBmL6WEqXJM7fq+YotiW1DPonEzTrWt/IxdkOFdbX4AV4uNMw
         Zv+MBHT8wDJJwlmG0e7z0S+FOku9Gj7lrvq8Zcn2plROXeAJTXIGZ8M9tL3C3+mWVHmC
         HSFZ1xCytx56w+Z+Doo13FhtRFhAtoPyX077AUv77/hK/7Pp9tSE1yGw0A2VJ0m0xKMD
         M1CbBOPlqajk49cvrolZQXOx9jkPP0ovJK3y3FJ6NlKfINCCyNFXDa1hNCVW/JsY5HBn
         PtcuM41BThONaap82BWpmhAPXP8t/d5v7eRqjM5uF37ucRwKu3sGi78GhaRqETKmyaYo
         rufA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1fqt4RZHpU7qFJuzFqI1H78E6IxKKO9+0LC3as8rskQ=;
        b=eSX/AoHHfkbXv9VzEg0IqDLfywiyF/FMrqPOeGEkK2vEiIuoGMkdWLwSfaWO7KVpZL
         e03dgKLNwRncqwsDwl5TINhV15dasMbAWdBdGZkC8ipSV/OX8s3C5otLDD7aZLk3niWL
         pwGGz2xLj0Ho5PHPDmmzIuNN/lPeJRFuaO1fNB4JVWiBYLCsQFUu9TSh4nerj4M+gTU6
         HZ3aOPHz9R4E6SIiLDd3nI1QhtaJtkc0EiZfqdrvSfoTzcNujuRJxETLTV3Xe5BdtDXw
         5yTRHFz19+jp2Tq70bfH3s0paZDozWrquqCDCnnVQMR+WZQtsx2I/W7VQqrGjJ9wH5xe
         RNgw==
X-Gm-Message-State: AOAM532NtWpq5HQEPCi+i6yk4/u8uMvM8wlBttAQ55jWOQVzDB/A3giQ
	y04s+s29zZ6iT5lCO3Ld8vo=
X-Google-Smtp-Source: ABdhPJzpK+Kweyt++e3ASXD/8ASda3oraQCNNMZRWMfw5g1bpbfyyMdlIBznIU8unhQD5grLbIISGA==
X-Received: by 2002:a05:600c:3788:: with SMTP id o8mr29757561wmr.82.1636904721156;
        Sun, 14 Nov 2021 07:45:21 -0800 (PST)
Message-ID: <03ddd6e6-55ff-fff4-95f3-8c0b008443f8@gmail.com>
Date: Sun, 14 Nov 2021 16:45:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v16 1/3] fs: Add trusted_for(2) syscall implementation and
 related sysctl
Content-Language: en-US
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>,
 Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton
 <akpm@linux-foundation.org>, Aleksa Sarai <cyphar@cyphar.com>,
 Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
 Casey Schaufler <casey@schaufler-ca.com>,
 Christian Brauner <christian.brauner@ubuntu.com>,
 Christian Heimes <christian@python.org>,
 Deven Bowers <deven.desai@linux.microsoft.com>,
 Dmitry Vyukov <dvyukov@google.com>, Eric Biggers <ebiggers@kernel.org>,
 Eric Chiang <ericchiang@google.com>, Florian Weimer <fweimer@redhat.com>,
 James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>,
 Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
 Kees Cook <keescook@chromium.org>,
 Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
 "Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
 Matthew Garrett <mjg59@google.com>, Matthew Wilcox <willy@infradead.org>,
 Miklos Szeredi <mszeredi@redhat.com>, Mimi Zohar <zohar@linux.ibm.com>,
 Paul Moore <paul@paul-moore.com>,
 =?UTF-8?Q?Philippe_Tr=c3=a9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
 Scott Shell <scottsh@microsoft.com>, Shuah Khan <shuah@kernel.org>,
 Steve Dower <steve.dower@python.org>, Steve Grubb <sgrubb@redhat.com>,
 Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
 Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
 Yin Fengwei <fengwei.yin@intel.com>, kernel-hardening@lists.openwall.com,
 Linux API <linux-api@vger.kernel.org>,
 Linux FS Devel <linux-fsdevel@vger.kernel.org>,
 linux-integrity <linux-integrity@vger.kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 linux-security-module <linux-security-module@vger.kernel.org>,
 =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@linux.microsoft.com>
References: <20211110190626.257017-1-mic@digikod.net>
 <20211110190626.257017-2-mic@digikod.net>
 <8a22a3c2-468c-e96c-6516-22a0f029aa34@gmail.com>
 <5312f022-96ea-5555-8d17-4e60a33cf8f8@digikod.net>
 <34779736-e875-c3e0-75d5-0f0a55d729aa@gmail.com>
 <CAMuHMdXj8fHDq-eFd41GJ4oNwGD5sxhPx82izNwKxE_=x8dqEA@mail.gmail.com>
From: "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
In-Reply-To: <CAMuHMdXj8fHDq-eFd41GJ4oNwGD5sxhPx82izNwKxE_=x8dqEA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Geert,

On 11/14/21 16:32, Geert Uytterhoeven wrote:
> Hi Alejandro,
> 
> On Sat, Nov 13, 2021 at 8:56 PM Alejandro Colomar (man-pages)
> <alx.manpages@gmail.com> wrote:
>> On 11/13/21 14:02, Mickaël Salaün wrote:
>>>> TL;DR:
>>>>
>>>> ISO C specifies that for the following code:
>>>>
>>>>       enum foo {BAR};
>>>>
>>>>       enum foo foobar;
>>>>
>>>> typeof(foo)    shall be int
>>>> typeof(foobar) is implementation-defined
>>>
>>> I tested with some version of GCC (from 4.9 to 11) and clang (10 and 11)
>>> with different optimizations and the related sizes are at least the same
>>> as for the int type.
>>
>> GCC has -fshort-enums to make enum types be as short as possible.  I
>> expected -Os to turn this on, since it saves space, but it doesn't.
> 
> Changing optimization level must not change the ABI, else debugging
> would become even more of a nightmare.

I agree, but if you invoke implementation-defined,
then it's not (only) the compiler's fault.

Instead of not allowing GCC to enable -fshort-enums ever,
one can write ISO C-complying code in the parts that
will be exposed as an interface,
by just using int.

That allows using -fshort-enums
for whatever reasons it might be good.

Not saying that the kernel wants to enable it,
but it costs nothing to write non-implementation-defined code
that doesn't forbid it.


It's comparable to passing a struct (not a pointer to it)
to a function.
If you change the size of the struct,
you screw the interface.
Better pass pointers, or standard types.


Cheers,
Alex

-- 
Alejandro Colomar
Linux man-pages comaintainer; http://www.kernel.org/doc/man-pages/
http://www.alejandro-colomar.es/
