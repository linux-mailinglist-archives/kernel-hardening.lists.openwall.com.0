Return-Path: <kernel-hardening-return-19815-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 140712613A9
	for <lists+kernel-hardening@lfdr.de>; Tue,  8 Sep 2020 17:39:35 +0200 (CEST)
Received: (qmail 10164 invoked by uid 550); 8 Sep 2020 15:39:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 10144 invoked from network); 8 Sep 2020 15:39:27 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=O7XJu38SFyTf1J7F17Pgsezh+TcCF29rZjjKnS09FC4=;
 b=pYExEl4GEir85/Swt3pY2PU9iGqB8dcyGYsI82ZJjGwQGRLzF9mkEp53MznyY4r4vDmx
 /sX1HujoahyPL9VqjGnWudxMPW9mI1xs/37j5Y2bTk9wnGlFZ7ekTMXxwdVAw4CkMXCW
 RwSLMCm/4GRxExwvGpwnQvMiABZjDGYjB6X91q8R3lkYbBCJjWCyzRvAvxBUbfHCMDCd
 hB5w/QLMPlGTxAx6lu8hPwArF6/igmizfH0NSxE5PMYZHUvDtuB8Mn8dSb46R/NmD4GJ
 t5X5Mz4miQWpT3g6A/G6hVqZVqxuH90bSxYBcSJwCeKBdhK4ien0Hk0/cYwrsa4QlOpp Aw== 
Message-ID: <4ba95bc2071185a7819261c4e008ec9aa452b30e.camel@linux.ibm.com>
Subject: Re: [RFC PATCH v8 1/3] fs: Introduce AT_INTERPRETED flag for
 faccessat2(2)
From: Mimi Zohar <zohar@linux.ibm.com>
To: =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
        Stephen Smalley
	 <stephen.smalley.work@gmail.com>,
        Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Aleksa Sarai
 <cyphar@cyphar.com>, Alexei Starovoitov <ast@kernel.org>,
        Al Viro
 <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy
 Lutomirski <luto@kernel.org>,
        Christian Brauner
 <christian.brauner@ubuntu.com>,
        Christian Heimes <christian@python.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Deven Bowers
 <deven.desai@linux.microsoft.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric
 Biggers <ebiggers@kernel.org>,
        Eric Chiang <ericchiang@google.com>,
        Florian
 Weimer <fweimer@redhat.com>, James Morris <jmorris@namei.org>,
        Jan Kara
 <jack@suse.cz>, Jann Horn <jannh@google.com>,
        Jonathan Corbet
 <corbet@lwn.net>, Kees Cook <keescook@chromium.org>,
        Lakshmi
 Ramasubramanian <nramas@linux.microsoft.com>,
        Matthew Garrett
 <mjg59@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Michael Kerrisk
 <mtk.manpages@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Philippe
 =?ISO-8859-1?Q?Tr=E9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
        Scott Shell
 <scottsh@microsoft.com>,
        Sean Christopherson
 <sean.j.christopherson@intel.com>,
        Shuah Khan <shuah@kernel.org>, Steve
 Dower <steve.dower@python.org>,
        Steve Grubb <sgrubb@redhat.com>,
        Tetsuo
 Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Thibaut Sautereau
 <thibaut.sautereau@clip-os.org>,
        Vincent Strubel
 <vincent.strubel@ssi.gouv.fr>,
        kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        LSM List
 <linux-security-module@vger.kernel.org>,
        Linux FS Devel
 <linux-fsdevel@vger.kernel.org>,
        Thibaut Sautereau
 <thibaut.sautereau@ssi.gouv.fr>,
        =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?=
 <mic@linux.microsoft.com>,
        John Johansen <john.johansen@canonical.com>
Date: Tue, 08 Sep 2020 11:38:28 -0400
In-Reply-To: <532eefa8-49ca-1c23-1228-d5a4e2d8af90@digikod.net>
References: <20200908075956.1069018-1-mic@digikod.net>
	 <20200908075956.1069018-2-mic@digikod.net>
	 <d216615b48c093ebe9349a9dab3830b646575391.camel@linux.ibm.com>
	 <75451684-58f3-b946-dca4-4760fa0d7440@digikod.net>
	 <CAEjxPJ49_BgGX50ZAhHh79Qy3OMN6sssnUHT_2yXqdmgyt==9w@mail.gmail.com>
	 <CAEjxPJ6ZTKeunzJvWf_kS3QYjca6v1yJq=ad-jCCuDSgG6n60g@mail.gmail.com>
	 <bdc10ab89cf9197e104f02a751009cf0d549ddf5.camel@linux.ibm.com>
	 <CAEjxPJ5evWDSv-T-p=4OX29Pr584ZRAsnYoxSRd4qFDoryB+fQ@mail.gmail.com>
	 <532eefa8-49ca-1c23-1228-d5a4e2d8af90@digikod.net>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-12.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-08_07:2020-09-08,2020-09-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 adultscore=0 mlxscore=0 spamscore=0 mlxlogscore=999 impostorscore=0
 phishscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009080143

[Cc'ing Casey]

On Tue, 2020-09-08 at 16:14 +0200, Micka�l Sala�n wrote:
> On 08/09/2020 15:42, Stephen Smalley wrote:
> > On Tue, Sep 8, 2020 at 9:29 AM Mimi Zohar <zohar@linux.ibm.com> wrote:
> >>
> >> On Tue, 2020-09-08 at 08:52 -0400, Stephen Smalley wrote:
> >>> On Tue, Sep 8, 2020 at 8:50 AM Stephen Smalley
> >>> <stephen.smalley.work@gmail.com> wrote:
> >>>>
> >>>> On Tue, Sep 8, 2020 at 8:43 AM Micka�l Sala�n <mic@digikod.net> wrote:
> >>>>>
> >>>>>
> >>>>> On 08/09/2020 14:28, Mimi Zohar wrote:
> >>>>>> Hi Mickael,
> >>>>>>
> >>>>>> On Tue, 2020-09-08 at 09:59 +0200, Micka�l Sala�n wrote:
> >>>>>>> +                    mode |= MAY_INTERPRETED_EXEC;
> >>>>>>> +                    /*
> >>>>>>> +                     * For compatibility reasons, if the system-wide policy
> >>>>>>> +                     * doesn't enforce file permission checks, then
> >>>>>>> +                     * replaces the execute permission request with a read
> >>>>>>> +                     * permission request.
> >>>>>>> +                     */
> >>>>>>> +                    mode &= ~MAY_EXEC;
> >>>>>>> +                    /* To be executed *by* user space, files must be readable. */
> >>>>>>> +                    mode |= MAY_READ;
> >>>>>>
> >>>>>> After this change, I'm wondering if it makes sense to add a call to
> >>>>>> security_file_permission().  IMA doesn't currently define it, but
> >>>>>> could.
> >>>>>
> >>>>> Yes, that's the idea. We could replace the following inode_permission()
> >>>>> with file_permission(). I'm not sure how this will impact other LSMs though.
> >>
> >> I wasn't suggesting replacing the existing security_inode_permission
> >> hook later, but adding a new security_file_permission hook here.
> >>
> >>>>
> >>>> They are not equivalent at least as far as SELinux is concerned.
> >>>> security_file_permission() was only to be used to revalidate
> >>>> read/write permissions previously checked at file open to support
> >>>> policy changes and file or process label changes.  We'd have to modify
> >>>> the SELinux hook if we wanted to have it check execute access even if
> >>>> nothing has changed since open time.
> >>>
> >>> Also Smack doesn't appear to implement file_permission at all, so it
> >>> would skip Smack checking.
> >>
> >> My question is whether adding a new security_file_permission call here
> >> would break either SELinux or Apparmor?
> > 
> > selinux_inode_permission() has special handling for MAY_ACCESS so we'd
> > need to duplicate that into selinux_file_permission() ->
> > selinux_revalidate_file_permission().  Also likely need to adjust
> > selinux_file_permission() to explicitly check whether the mask
> > includes any permissions not checked at open time.  So some changes
> > would be needed here.  By default, it would be a no-op unless there
> > was a policy reload or the file was relabeled between the open(2) and
> > the faccessat(2) call.
> > 
> 
> We could create a new hook path_permission(struct path *path, int mask)
> as a superset of inode_permission(). To be more convenient, his new hook
> could then just call inode_permission() for every LSMs not implementing
> path_permission().

The LSM maintainers need to chime in here on this suggestion.  In terms
of the name, except for one hook, all the security_path_XXXX() hooks
are dependent on CONFIG_SECURITY_PATH being configured.

Mimi

