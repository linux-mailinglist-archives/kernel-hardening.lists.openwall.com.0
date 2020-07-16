Return-Path: <kernel-hardening-return-19353-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 7A817222650
	for <lists+kernel-hardening@lfdr.de>; Thu, 16 Jul 2020 16:59:57 +0200 (CEST)
Received: (qmail 32740 invoked by uid 550); 16 Jul 2020 14:59:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 32720 invoked from network); 16 Jul 2020 14:59:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
	:Reply-To:Content-ID:Content-Description;
	bh=0utnqY8s+MOoo2WbklOSO0CnKqfkeDdOlM8s5Xa1IOA=; b=gczDwv0uJQk5yeRN4+5UTWmgXy
	cHAn5JjOIUtVDoOt8iBk3JQkDtD3g+HBjnj9u0l822Zzxm+3FqOOqiW2+vNWA+lEh2HozyB6E8lLp
	hNIOwq6cuEmZYdf2jf4PynnHzp/RpCX6U6I/nAT/kBBKILiO8lYQW4/GQ8xGad5IB72pRMAFDNuD/
	DQl+aPQkFuBNTCjKLE6WpzWx1lv3CbMCYZDxALR9c+rOObkaeGD659dqAj2iNEEwuPkOXnPbtlWb3
	Vs6dkY6OnnLl3hrsjzl1wWl1kPo/FCG59e8UGEV3bdkSVDlWpLwlOFivRVX0o/qC8Jhg8NfKYldBN
	CimgmZrQ==;
Subject: Re: [PATCH v6 7/7] ima: add policy support for the new file open
 MAY_OPENEXEC flag
To: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>,
 Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>,
 Alexei Starovoitov <ast@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
 Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski
 <luto@kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>,
 Christian Heimes <christian@python.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 Deven Bowers <deven.desai@linux.microsoft.com>,
 Dmitry Vyukov <dvyukov@google.com>, Eric Biggers <ebiggers@kernel.org>,
 Eric Chiang <ericchiang@google.com>, Florian Weimer <fweimer@redhat.com>,
 James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>,
 Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
 Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
 Matthew Garrett <mjg59@google.com>, Matthew Wilcox <willy@infradead.org>,
 Michael Kerrisk <mtk.manpages@gmail.com>,
 =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mickael.salaun@ssi.gouv.fr>,
 Mimi Zohar <zohar@linux.ibm.com>,
 =?UTF-8?Q?Philippe_Tr=c3=a9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
 Scott Shell <scottsh@microsoft.com>,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Shuah Khan <shuah@kernel.org>, Steve Dower <steve.dower@python.org>,
 Steve Grubb <sgrubb@redhat.com>,
 Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
 Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
 Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
 kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20200714181638.45751-1-mic@digikod.net>
 <20200714181638.45751-8-mic@digikod.net> <202007151339.283D7CD@keescook>
 <8df69733-0088-3e3c-9c3d-2610414cea2b@digikod.net>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <61c05cb0-a956-3cc7-5dab-e11ebf0e95bf@infradead.org>
Date: Thu, 16 Jul 2020 07:59:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <8df69733-0088-3e3c-9c3d-2610414cea2b@digikod.net>
Content-Type: text/plain; charset=iso-8859-15
Content-Language: en-US
Content-Transfer-Encoding: 8bit

On 7/16/20 7:40 AM, Micka�l Sala�n wrote:
> 
> On 15/07/2020 22:40, Kees Cook wrote:
>> On Tue, Jul 14, 2020 at 08:16:38PM +0200, Micka�l Sala�n wrote:
>>> From: Mimi Zohar <zohar@linux.ibm.com>
>>>
>>> The kernel has no way of differentiating between a file containing data
>>> or code being opened by an interpreter.  The proposed O_MAYEXEC
>>> openat2(2) flag bridges this gap by defining and enabling the
>>> MAY_OPENEXEC flag.
>>>
>>> This patch adds IMA policy support for the new MAY_OPENEXEC flag.
>>>
>>> Example:
>>> measure func=FILE_CHECK mask=^MAY_OPENEXEC
>>> appraise func=FILE_CHECK appraise_type=imasig mask=^MAY_OPENEXEC
>>>
>>> Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
>>> Reviewed-by: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
>>> Acked-by: Micka�l Sala�n <mic@digikod.net>
>>
>> (Process nit: if you're sending this on behalf of another author, then
>> this should be Signed-off-by rather than Acked-by.)
> 
> I'm not a co-author of this patch.
> 

from Documentation/process/submitting-patches.rst:

The Signed-off-by: tag indicates that the signer was involved in the
development of the patch, or that he/she was in the patch's delivery path.
                             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

-- 
~Randy

