Return-Path: <kernel-hardening-return-19582-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 4BA38241359
	for <lists+kernel-hardening@lfdr.de>; Tue, 11 Aug 2020 00:44:12 +0200 (CEST)
Received: (qmail 3179 invoked by uid 550); 10 Aug 2020 22:44:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3157 invoked from network); 10 Aug 2020 22:44:06 -0000
Subject: Re: [PATCH v7 0/7] Add support for O_MAYEXEC
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 Aleksa Sarai <cyphar@cyphar.com>, Alexei Starovoitov <ast@kernel.org>,
 Andy Lutomirski <luto@kernel.org>,
 Christian Brauner <christian.brauner@ubuntu.com>,
 Christian Heimes <christian@python.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 Deven Bowers <deven.desai@linux.microsoft.com>,
 Dmitry Vyukov <dvyukov@google.com>, Eric Biggers <ebiggers@kernel.org>,
 Eric Chiang <ericchiang@google.com>, Florian Weimer <fweimer@redhat.com>,
 James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>,
 Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
 Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
 Matthew Garrett <mjg59@google.com>, Matthew Wilcox <willy@infradead.org>,
 Michael Kerrisk <mtk.manpages@gmail.com>, Mimi Zohar <zohar@linux.ibm.com>,
 =?UTF-8?Q?Philippe_Tr=c3=a9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
 Scott Shell <scottsh@microsoft.com>,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Shuah Khan <shuah@kernel.org>, Steve Dower <steve.dower@python.org>,
 Steve Grubb <sgrubb@redhat.com>,
 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
 Thibaut Sautereau <thibaut.sautereau@clip-os.org>,
 Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
 kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20200723171227.446711-1-mic@digikod.net>
 <202007241205.751EBE7@keescook>
 <0733fbed-cc73-027b-13c7-c368c2d67fb3@digikod.net>
 <20200810202123.GC1236603@ZenIV.linux.org.uk>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <917bb071-8b1a-3ba4-dc16-f8d7b4cc849f@digikod.net>
Date: Tue, 11 Aug 2020 00:43:52 +0200
User-Agent:
MIME-Version: 1.0
In-Reply-To: <20200810202123.GC1236603@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=iso-8859-15
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Antivirus: Dr.Web (R) for Unix mail servers drweb plugin ver.6.0.2.8
X-Antivirus-Code: 0x100000


On 10/08/2020 22:21, Al Viro wrote:
> On Mon, Aug 10, 2020 at 10:11:53PM +0200, Mickaël Salaün wrote:
>> It seems that there is no more complains nor questions. Do you want me
>> to send another series to fix the order of the S-o-b in patch 7?
> 
> There is a major question regarding the API design and the choice of
> hooking that stuff on open().  And I have not heard anything resembling
> a coherent answer.

Hooking on open is a simple design that enables processes to check files
they intend to open, before they open them. From an API point of view,
this series extends openat2(2) with one simple flag: O_MAYEXEC. The
enforcement is then subject to the system policy (e.g. mount points,
file access rights, IMA, etc.).

Checking on open enables to not open a file if it does not meet some
requirements, the same way as if the path doesn't exist or (for whatever
reasons, including execution permission) if access is denied. It is a
good practice to check as soon as possible such properties, and it may
enables to avoid (user space) time-of-check to time-of-use (TOCTOU)
attacks (i.e. misuse of already open resources). It is important to keep
in mind that the use cases we are addressing consider that the (user
space) script interpreters (or linkers) are trusted and unaltered (i.e.
integrity/authenticity checked). These are similar sought defensive
properties as for SUID/SGID binaries: attackers can still launch them
with malicious inputs (e.g. file paths, file descriptors, environment
variables, etc.), but the binaries can then have a way to check if they
can extend their trust to some file paths.

Checking file descriptors may help in some use cases, but not the ones
motivating this series. Checking (already) opened resources could be a
*complementary* way to check execute permission, but it is not in the
scope of this series.
