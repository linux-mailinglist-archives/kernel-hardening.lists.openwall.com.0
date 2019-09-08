Return-Path: <kernel-hardening-return-16877-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 4E424AD108
	for <lists+kernel-hardening@lfdr.de>; Mon,  9 Sep 2019 00:20:58 +0200 (CEST)
Received: (qmail 32258 invoked by uid 550); 8 Sep 2019 22:20:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 32226 invoked from network); 8 Sep 2019 22:20:52 -0000
Date: Sun, 8 Sep 2019 23:19:54 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mickael.salaun@ssi.gouv.fr>,
	linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	David Drysdale <drysdale@google.com>,
	"David S . Miller" <davem@davemloft.net>,
	"Eric W . Biederman" <ebiederm@xmission.com>,
	James Morris <jmorris@namei.org>, Jann Horn <jann@thejh.net>,
	John Johansen <john.johansen@canonical.com>,
	Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	Paul Moore <paul@paul-moore.com>, Sargun Dhillon <sargun@sargun.me>,
	"Serge E . Hallyn" <serge@hallyn.com>,
	Shuah Khan <shuah@kernel.org>, Stephen Smalley <sds@tycho.nsa.gov>,
	Tejun Heo <tj@kernel.org>,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	Thomas Graf <tgraf@suug.ch>, Tycho Andersen <tycho@tycho.ws>,
	Will Drewry <wad@chromium.org>, kernel-hardening@lists.openwall.com,
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v10 06/10] bpf,landlock: Add a new map type:
 inode
Message-ID: <20190908221954.GD1131@ZenIV.linux.org.uk>
References: <20190721213116.23476-1-mic@digikod.net>
 <20190721213116.23476-7-mic@digikod.net>
 <20190727014048.3czy3n2hi6hfdy3m@ast-mbp.dhcp.thefacebook.com>
 <a870c2c9-d2f7-e0fa-c8cc-35dbf8b5b87d@ssi.gouv.fr>
 <894922a2-1150-366c-3f08-c8b759da0742@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <894922a2-1150-366c-3f08-c8b759da0742@digikod.net>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: Al Viro <viro@ftp.linux.org.uk>

On Mon, Sep 09, 2019 at 12:09:57AM +0200, Micka�l Sala�n wrote:

> >>> +    rcu_read_lock();
> >>> +    ptr = htab_map_lookup_elem(map, &inode);
> >>> +    iput(inode);

Wait a sec.  You are doing _what_ under rcu_read_lock()?

> >>> +    if (IS_ERR(ptr)) {
> >>> +            ret = PTR_ERR(ptr);
> >>> +    } else if (!ptr) {
> >>> +            ret = -ENOENT;
> >>> +    } else {
> >>> +            ret = 0;
> >>> +            copy_map_value(map, value, ptr);
> >>> +    }
> >>> +    rcu_read_unlock();
