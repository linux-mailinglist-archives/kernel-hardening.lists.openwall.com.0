Return-Path: <kernel-hardening-return-21512-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 29798464EA3
	for <lists+kernel-hardening@lfdr.de>; Wed,  1 Dec 2021 14:16:05 +0100 (CET)
Received: (qmail 3838 invoked by uid 550); 1 Dec 2021 13:15:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3809 invoked from network); 1 Dec 2021 13:15:57 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=o7MU5ZEW3BlvRrPu95u+FYlzxn/o3dCRZhGlSHuRGvs=;
 b=EQbqU93mjERx4tytUgOTiHfb/lGWvW4J+OdQxiFYvTJWsC9Vey7ux6eqqUnHWQJ9Ai9O
 g/wRbQgnAFsSFPnc/XoUuIDZj3ekriraPETjJ4J/tSi9r8nwllxlrbPqJ8zVxHppZBDL
 AjKLO5zZgQy3InnVnUXy7CNWjK2EBI0vc0oKVOLOBTOwzzJZXQ9coo5EZlDugBy5CfTj
 OdpSsG5IWScTeMLAZdSB/JScFrGrYBr3uDP6LU/V48PKwScFi+wmMEIFqjX1lHcEGhIB
 YgRfaMkqpNiilRRfjr/frM0L9e4sThP4RLpWDxEZqzygsR49fInvTUDAOPZIUyOf1U3I aw== 
Message-ID: <e91d238422f8df139acf84cc2df6ddb4fd300b87.camel@linux.ibm.com>
Subject: Re: [PATCH v17 0/3] Add trusted_for(2) (was O_MAYEXEC)
From: Mimi Zohar <zohar@linux.ibm.com>
To: =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
        Florian Weimer
	 <fweimer@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton
 <akpm@linux-foundation.org>,
        Alejandro Colomar <alx.manpages@gmail.com>,
        Aleksa Sarai <cyphar@cyphar.com>, Andy Lutomirski <luto@kernel.org>,
        Arnd
 Bergmann <arnd@arndb.de>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Christian Heimes
 <christian@python.org>,
        Deven Bowers <deven.desai@linux.microsoft.com>,
        Dmitry Vyukov <dvyukov@google.com>, Eric Biggers <ebiggers@kernel.org>,
        Eric Chiang <ericchiang@google.com>,
        Geert Uytterhoeven
 <geert@linux-m68k.org>,
        James Morris <jmorris@namei.org>, Jan Kara
 <jack@suse.cz>,
        Jann Horn <jannh@google.com>, Jonathan Corbet
 <corbet@lwn.net>,
        Kees Cook <keescook@chromium.org>,
        Lakshmi
 Ramasubramanian <nramas@linux.microsoft.com>,
        "Madhavan T . Venkataraman"
 <madvenka@linux.microsoft.com>,
        Matthew Garrett <mjg59@google.com>,
        Matthew
 Wilcox <willy@infradead.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Paul
 Moore <paul@paul-moore.com>,
        Philippe =?ISO-8859-1?Q?Tr=E9buchet?=
 <philippe.trebuchet@ssi.gouv.fr>,
        Scott Shell <scottsh@microsoft.com>, Shuah Khan <shuah@kernel.org>,
        Steve Dower <steve.dower@python.org>, Steve
 Grubb <sgrubb@redhat.com>,
        Thibaut Sautereau
 <thibaut.sautereau@ssi.gouv.fr>,
        Vincent Strubel
 <vincent.strubel@ssi.gouv.fr>,
        Yin Fengwei <fengwei.yin@intel.com>,
        kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Date: Wed, 01 Dec 2021 08:14:54 -0500
In-Reply-To: <4a88f95b-d54d-ad70-fb49-e3c3f1d097f2@digikod.net>
References: <20211115185304.198460-1-mic@digikod.net>
	 <87sfvd8k4c.fsf@oldenburg.str.redhat.com>
	 <4a88f95b-d54d-ad70-fb49-e3c3f1d097f2@digikod.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-16.el8) 
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 4_DbnL0LEYui2lYeqbE8yT4i3z_a1Jb2
X-Proofpoint-GUID: 9Log-g6aWaMUBg8JjxhDYCR2BbjEsiMa
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-30_10,2021-12-01_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 adultscore=0 lowpriorityscore=0 mlxscore=0 priorityscore=1501
 mlxlogscore=999 impostorscore=0 bulkscore=0 phishscore=0 clxscore=1011
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112010076

On Wed, 2021-12-01 at 10:23 +0100, Mickaël Salaün wrote:
> On 30/11/2021 21:27, Florian Weimer wrote:
> > * Mickaël Salaün:
> > 
> >> Primary goal of trusted_for(2)
> >> ==============================
> >>
> >> This new syscall enables user space to ask the kernel: is this file
> >> descriptor's content trusted to be used for this purpose?  The set of
> >> usage currently only contains execution, but other may follow (e.g.
> >> configuration, sensitive data).  If the kernel identifies the file
> >> descriptor as trustworthy for this usage, user space should then take
> >> this information into account.  The "execution" usage means that the
> >> content of the file descriptor is trusted according to the system policy
> >> to be executed by user space, which means that it interprets the content
> >> or (try to) maps it as executable memory.
> > 
> > I sketched my ideas about “IMA gadgets” here:
> > 
> >    IMA gadgets
> >    <https://www.openwall.com/lists/oss-security/2021/11/30/1>
> > 
> > I still don't think the proposed trusted_for interface is sufficient.
> > The example I gave is a Perl module that does nothing (on its own) when
> > loaded as a Perl module (although you probably don't want to sign it
> > anyway, given what it implements), but triggers an unwanted action when
> > sourced (using .) as a shell script.
> 
> The fact that IMA doesn't cover all metadata, file names nor the file 
> hierarchies is well known and the solution can be implemented with 
> dm-verity (which has its own drawbacks).

Thanks, Mickaël, for responding.  I'll go even farther and say that IMA
wasn't ever meant to protect file metadata.  Another option is EVM,
which addresses some, but not all of the issues.

thanks,

Mimi

> 
> trusted_for is a tool for interpreters to enforce a security policy 
> centralized by the kernel. The kind of file confusion attacks you are 
> talking about should be addressed by a system policy. If the mount point 
> options are not enough to express such policy, then we need to rely on 
> IMA, SELinux or IPE to reduce the scope of legitimate mapping between 
> scripts and interpreters.

