Return-Path: <kernel-hardening-return-21763-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by mail.lfdr.de (Postfix) with SMTP id 93C4592AAA9
	for <lists+kernel-hardening@lfdr.de>; Mon,  8 Jul 2024 22:37:05 +0200 (CEST)
Received: (qmail 5255 invoked by uid 550); 8 Jul 2024 20:36:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 5230 invoked from network); 8 Jul 2024 20:36:47 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	message-id:subject:from:to:cc:date:in-reply-to:references
	:content-type:content-transfer-encoding:mime-version; s=pp1; bh=
	CxgxLsMfcgEUGG2AWRuuw2fi5FzNeGA6j6CPtR3F6bc=; b=GJxdClp3WxyMXnqE
	bBREpQh9CN6I51cP+LBGgngbCtNdpuo13librI+ftvNXrMdPGc75VePQ5Y3hlSGM
	sYJNjvaSz5CblUOF+jyeefhrB3UOaZWNLZznFo1Ym4hAodwaU2yFFB50VUOyeVMx
	SG8YeeTPwpoBaL1uA1rDZtrxp57/XGQFEkL+Wvx5VaW7sArZku7RsphqCEbZ+2Uj
	SoEWNlA73iM+/kwaFLfGT4a0dgayWX+liRqMp8bYHnGH/nKSHICTGOAHgOQBqtK5
	kofUhF9jTVpxBiCinq3Yox6wOYsYLHWROqqgjcVpIwHp9Md5V9FA5A4MLUbVXWdg
	XtzGwA==
Message-ID: <55b4f6291e8d83d420c7d08f4233b3d304ce683d.camel@linux.ibm.com>
Subject: Re: [RFC PATCH v19 0/5] Script execution control (was O_MAYEXEC)
From: Mimi Zohar <zohar@linux.ibm.com>
To: =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
        Al Viro
 <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        Kees
 Cook <keescook@chromium.org>,
        Linus Torvalds
 <torvalds@linux-foundation.org>,
        Paul Moore <paul@paul-moore.com>, "Theodore Ts'o" <tytso@mit.edu>
Cc: Alejandro Colomar <alx.manpages@gmail.com>,
        Aleksa Sarai
 <cyphar@cyphar.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy
 Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Casey
 Schaufler <casey@schaufler-ca.com>,
        Christian Heimes
 <christian@python.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Biggers
 <ebiggers@kernel.org>,
        Eric Chiang <ericchiang@google.com>,
        Fan Wu
 <wufan@linux.microsoft.com>,
        Florian Weimer <fweimer@redhat.com>,
        Geert
 Uytterhoeven <geert@linux-m68k.org>,
        James Morris
 <jamorris@linux.microsoft.com>, Jan Kara <jack@suse.cz>,
        Jann Horn
 <jannh@google.com>, Jeff Xu <jeffxu@google.com>,
        Jonathan Corbet
 <corbet@lwn.net>,
        Jordan R Abrahams <ajordanr@google.com>,
        Lakshmi
 Ramasubramanian <nramas@linux.microsoft.com>,
        Luca Boccassi
 <bluca@debian.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        "Madhavan T .
 Venkataraman" <madvenka@linux.microsoft.com>,
        Matt Bobrowski
 <mattbobrowski@google.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Matthew
 Wilcox <willy@infradead.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Nicolas
 Bouchinet <nicolas.bouchinet@ssi.gouv.fr>,
        Scott Shell
 <scottsh@microsoft.com>, Shuah Khan <shuah@kernel.org>,
        Stephen Rothwell
 <sfr@canb.auug.org.au>,
        Steve Dower <steve.dower@python.org>, Steve Grubb
 <sgrubb@redhat.com>,
        Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
        Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
        Xiaoming Ni
 <nixiaoming@huawei.com>,
        Yin Fengwei <fengwei.yin@intel.com>,
        kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Date: Mon, 08 Jul 2024 16:35:38 -0400
In-Reply-To: <20240704190137.696169-1-mic@digikod.net>
References: <20240704190137.696169-1-mic@digikod.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-26.el8_10) 
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: xfgBL0ZavfhoiN98qDf8nNW4jFF4_Skx
X-Proofpoint-ORIG-GUID: 0zv7xLsYvghyVjWtpLVEhBOkEbPIHn4V
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-08_11,2024-07-05_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 suspectscore=0 spamscore=0 bulkscore=0 lowpriorityscore=0 impostorscore=0
 clxscore=1015 malwarescore=0 priorityscore=1501 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2406140001
 definitions=main-2407080151

Hi Mickaël,

On Thu, 2024-07-04 at 21:01 +0200, Mickaël Salaün wrote:
> Hi,
> 
> The ultimate goal of this patch series is to be able to ensure that
> direct file execution (e.g. ./script.sh) and indirect file execution
> (e.g. sh script.sh) lead to the same result, especially from a security
> point of view.
> 
> Overview
> --------
> 
> This patch series is a new approach of the initial O_MAYEXEC feature,
> and a revamp of the previous patch series.  Taking into account the last
> reviews [1], we now stick to the kernel semantic for file executability.
> One major change is the clear split between access check and policy
> management.
> 
> The first patch brings the AT_CHECK flag to execveat(2).  The goal is to
> enable user space to check if a file could be executed (by the kernel).
> Unlike stat(2) that only checks file permissions, execveat2(2) +
> AT_CHECK take into account the full context, including mount points
> (noexec), caller's limits, and all potential LSM extra checks (e.g.
> argv, envp, credentials).
> 
> The second patch brings two new securebits used to set or get a security
> policy for a set of processes.  For this to be meaningful, all
> executable code needs to be trusted.  In practice, this means that
> (malicious) users can be restricted to only run scripts provided (and
> trusted) by the system.
> 
> [1] https://lore.kernel.org/r/CAHk-=wjPGNLyzeBMWdQu+kUdQLHQugznwY7CvWjmvNW47D5sog@mail.gmail.com
> 
> Script execution
> ----------------
> 
> One important thing to keep in mind is that the goal of this patch
> series is to get the same security restrictions with these commands:
> * ./script.py
> * python script.py
> * python < script.py
> * python -m script.pyT

This is really needed, but is it the "only" purpose of this patch set or can it
be used to also monitor files the script opens (for read) with the intention of
executing.

> 
> However, on secure systems, we should be able to forbid these commands
> because there is no way to reliably identify the origin of the script:
> * xargs -a script.py -d '\r' -- python -c
> * cat script.py | python
> * python
> 
> Background
> ----------
> 
> Compared to the previous patch series, there is no more dedicated
> syscall nor sysctl configuration.  This new patch series only add new
> flags: one for execveat(2) and four for prctl(2).
> 
> This kind of script interpreter restriction may already be used in
> hardened systems, which may need to fork interpreters and install
> different versions of the binaries.  This mechanism should enable to
> avoid the use of duplicate binaries (and potential forked source code)
> for secure interpreters (e.g. secure Python [2]) by making it possible
> to dynamically enforce restrictions or not.
> 
> The ability to control script execution is also required to close a
> major IMA measurement/appraisal interpreter integrity [3].

Definitely.  But it isn't limited to controlling script execution, but also
measuring the script.  Will it be possible to measure and appraise the indirect
script calls with this patch set?

Mimi

> This new execveat + AT_CHECK should not be confused with the O_EXEC flag
> (for open) which is intended for execute-only, which obviously doesn't
> work for scripts.
> 
> I gave a talk about controlling script execution where I explain the
> previous approaches [4].  The design of the WIP RFC I talked about
> changed quite a bit since then.
> 
> [2] https://github.com/zooba/spython
> [3] https://lore.kernel.org/lkml/20211014130125.6991-1-zohar@linux.ibm.com/
> [4] https://lssna2023.sched.com/event/1K7bO
> 

