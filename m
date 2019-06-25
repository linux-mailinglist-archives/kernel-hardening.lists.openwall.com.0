Return-Path: <kernel-hardening-return-16248-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id BBF5C55BAB
	for <lists+kernel-hardening@lfdr.de>; Wed, 26 Jun 2019 00:53:03 +0200 (CEST)
Received: (qmail 1190 invoked by uid 550); 25 Jun 2019 22:52:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1155 invoked from network); 25 Jun 2019 22:52:56 -0000
Date: Tue, 25 Jun 2019 23:52:01 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: linux-kernel@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>,
	Alexei Starovoitov <ast@kernel.org>,
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
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mickael.salaun@ssi.gouv.fr>,
	Paul Moore <paul@paul-moore.com>, Sargun Dhillon <sargun@sargun.me>,
	"Serge E . Hallyn" <serge@hallyn.com>,
	Shuah Khan <shuah@kernel.org>, Stephen Smalley <sds@tycho.nsa.gov>,
	Tejun Heo <tj@kernel.org>,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	Thomas Graf <tgraf@suug.ch>, Tycho Andersen <tycho@tycho.ws>,
	Will Drewry <wad@chromium.org>, kernel-hardening@lists.openwall.com,
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v9 05/10] bpf,landlock: Add a new map type: inode
Message-ID: <20190625225201.GJ17978@ZenIV.linux.org.uk>
References: <20190625215239.11136-1-mic@digikod.net>
 <20190625215239.11136-6-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190625215239.11136-6-mic@digikod.net>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: Al Viro <viro@ftp.linux.org.uk>

On Tue, Jun 25, 2019 at 11:52:34PM +0200, Mickaël Salaün wrote:
> +/* must call iput(inode) after this call */
> +static struct inode *inode_from_fd(int ufd, bool check_access)
> +{
> +	struct inode *ret;
> +	struct fd f;
> +	int deny;
> +
> +	f = fdget(ufd);
> +	if (unlikely(!f.file || !file_inode(f.file))) {
> +		ret = ERR_PTR(-EBADF);
> +		goto put_fd;
> +	}

Just when does one get a NULL file_inode()?  The reason I'm asking is
that arseloads of code would break if one managed to create such
a beast...

Incidentally, that should be return ERR_PTR(-EBADF); fdput() is wrong there.

> +	}
> +	/* check if the FD is tied to a mount point */
> +	/* TODO: add this check when called from an eBPF program too */
> +	if (unlikely(!f.file->f_path.mnt

Again, the same question - when the hell can that happen?  If you are
sitting on an exploitable roothole, do share it...

 || f.file->f_path.mnt->mnt_flags &
> +				MNT_INTERNAL)) {
> +		ret = ERR_PTR(-EINVAL);
> +		goto put_fd;

What does it have to do with mountpoints, anyway?

> +/* called from syscall */
> +static int sys_inode_map_delete_elem(struct bpf_map *map, struct inode *key)
> +{
> +	struct inode_array *array = container_of(map, struct inode_array, map);
> +	struct inode *inode;
> +	int i;
> +
> +	WARN_ON_ONCE(!rcu_read_lock_held());
> +	for (i = 0; i < array->map.max_entries; i++) {
> +		if (array->elems[i].inode == key) {
> +			inode = xchg(&array->elems[i].inode, NULL);
> +			array->nb_entries--;

Umm...  Is that intended to be atomic in any sense?

> +			iput(inode);
> +			return 0;
> +		}
> +	}
> +	return -ENOENT;
> +}
> +
> +/* called from syscall */
> +int bpf_inode_map_delete_elem(struct bpf_map *map, int *key)
> +{
> +	struct inode *inode;
> +	int err;
> +
> +	inode = inode_from_fd(*key, false);
> +	if (IS_ERR(inode))
> +		return PTR_ERR(inode);
> +	err = sys_inode_map_delete_elem(map, inode);
> +	iput(inode);
> +	return err;
> +}

Wait a sec...  So we have those beasties that can have long-term
references to arbitrary inodes stuck in them?  What will happen
if you get umount(2) called while such a thing exists?
