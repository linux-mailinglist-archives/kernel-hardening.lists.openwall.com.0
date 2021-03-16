Return-Path: <kernel-hardening-return-20951-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id DEF2433DD0E
	for <lists+kernel-hardening@lfdr.de>; Tue, 16 Mar 2021 20:04:53 +0100 (CET)
Received: (qmail 16249 invoked by uid 550); 16 Mar 2021 19:04:47 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 16229 invoked from network); 16 Mar 2021 19:04:47 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4xmctPJghbzCxK0UlOH+Mq1rZavHE0MB6cGIt7/nfNk=;
        b=Fvq3zYIWJXqeliEpcPw2DlNd4Z7cuzmPSXt5zH7IOtyT/4qCHkCM2dQv/y3Pg7SCE+
         4fVIx1+gg2iqyDqKxbYreKbYwuAFUwcQCCfb4rwfKEPe1n4XNUFRrJI8fcrdQlE+H9zH
         5+4OO7YkHLl0ikW3SmS5/GqFseKPGqkKzafSDtVFeURjUbqMK+DW56fyPKUQ5IMboY82
         x3JzGW+Oy76GhErg03A187ggg/ZAdsMbNoIxe+HVyi4lXCn0+3q2EalQBlrhGdYx5hxz
         SYyZeuVlO7rUzqKw0jFxB1Pwt6DkBDK6+wvFOkr7GGiSd9iAdQIIh+dlEAyKxYAQfTPd
         UPxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4xmctPJghbzCxK0UlOH+Mq1rZavHE0MB6cGIt7/nfNk=;
        b=CQSsPHoD0WuWVsQqJtmXswaN9PhK/ttW+x/aI+ENiF/DNQc4N8/ckuNtw6t4kT9+JH
         Aoown2JlZwOu2LNARfGgFWdBOPBa2+DMqMAMgR6Ve8u9VBAQq5udELka+/BnrZqKxH/Q
         8KXnRMf6js1vg9JluYluwf2v8zq0ucoUoi85IU07yLFZBJAkBLSvOG9B3UZRXIfzMGit
         LV79ahoOIm0WQqWpCwlThT7JmUSB2+mN1rHUA1N3VumZ2JXcons7eS6ftkjEAhVVFyrw
         Tkfp4C8WctZgCCBzpqtbXdxlEssuyFRYBCFIqxnW3JpLrRRqi3KsvMUvUL3neRfuNjvX
         cApA==
X-Gm-Message-State: AOAM533ifC3G/cb9zMbWTrMIkoADGSP9t2TbbH3sSS61/8LI96TgfHgI
	hyIHMhLo9Yff7DoRGj1BPxt4mjn09Hk3mmotawxf1A==
X-Google-Smtp-Source: ABdhPJyrmH/LPRVMNYATc6gz2AQWx1xdP/yG9jsDmCICyaqlhjb5tCgnL8iOgRomqeM5yTRgmisqkZy0ib5HNjKNj5M=
X-Received: by 2002:a05:651c:1134:: with SMTP id e20mr76134ljo.385.1615921475761;
 Tue, 16 Mar 2021 12:04:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210316170135.226381-1-mic@digikod.net> <20210316170135.226381-2-mic@digikod.net>
In-Reply-To: <20210316170135.226381-2-mic@digikod.net>
From: Jann Horn <jannh@google.com>
Date: Tue, 16 Mar 2021 20:04:09 +0100
Message-ID: <CAG48ez3=M-5WT73HqmFJr6UHwO0+2FJXxcAgRzp6wcd0P3TN=Q@mail.gmail.com>
Subject: Re: [PATCH v4 1/1] fs: Allow no_new_privs tasks to call chroot(2)
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>, 
	Serge Hallyn <serge@hallyn.com>, Andy Lutomirski <luto@amacapital.net>, 
	Casey Schaufler <casey@schaufler-ca.com>, Christian Brauner <christian.brauner@ubuntu.com>, 
	Christoph Hellwig <hch@lst.de>, David Howells <dhowells@redhat.com>, 
	Dominik Brodowski <linux@dominikbrodowski.net>, "Eric W . Biederman" <ebiederm@xmission.com>, 
	John Johansen <john.johansen@canonical.com>, Kees Cook <keescook@chromium.org>, 
	Kentaro Takeda <takedakn@nttdata.co.jp>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>, 
	linux-security-module <linux-security-module@vger.kernel.org>, 
	=?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 16, 2021 at 6:02 PM Micka=C3=ABl Sala=C3=BCn <mic@digikod.net> =
wrote:
> One could argue that chroot(2) is useless without a properly populated
> root hierarchy (i.e. without /dev and /proc).  However, there are
> multiple use cases that don't require the chrooting process to create
> file hierarchies with special files nor mount points, e.g.:
> * A process sandboxing itself, once all its libraries are loaded, may
>   not need files other than regular files, or even no file at all.
> * Some pre-populated root hierarchies could be used to chroot into,
>   provided for instance by development environments or tailored
>   distributions.
> * Processes executed in a chroot may not require access to these special
>   files (e.g. with minimal runtimes, or by emulating some special files
>   with a LD_PRELOADed library or seccomp).
>
> Unprivileged chroot is especially interesting for userspace developers
> wishing to harden their applications.  For instance, chroot(2) and Yama
> enable to build a capability-based security (i.e. remove filesystem
> ambient accesses) by calling chroot/chdir with an empty directory and
> accessing data through dedicated file descriptors obtained with
> openat2(2) and RESOLVE_BENEATH/RESOLVE_IN_ROOT/RESOLVE_NO_MAGICLINKS.

I don't entirely understand. Are you writing this with the assumption
that a future change will make it possible to set these RESOLVE flags
process-wide, or something like that?


As long as that doesn't exist, I think that to make this safe, you'd
have to do something like the following - let a child process set up a
new mount namespace for you, and then chroot() into that namespace's
root:

struct shared_data {
  int root_fd;
};
int helper_fn(void *args) {
  struct shared_data *shared =3D args;
  mount("none", "/tmp", "tmpfs", MS_NOSUID|MS_NODEV, "");
  mkdir("/tmp/old_root", 0700);
  pivot_root("/tmp", "/tmp/old_root");
  umount("/tmp/old_root", "");
  shared->root_fd =3D open("/", O_PATH);
}
void setup_chroot() {
  struct shared_data shared =3D {};
  prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
  clone(helper_fn, my_stack,
CLONE_VFORK|CLONE_VM|CLONE_FILES|CLONE_NEWUSER|CLONE_NEWNS|SIGCHLD,
NULL);
  fchdir(shared.root_fd);
  chroot(".");
}

[...]
> diff --git a/fs/open.c b/fs/open.c
[...]
> +static inline int current_chroot_allowed(void)
> +{
> +       /*
> +        * Changing the root directory for the calling task (and its futu=
re
> +        * children) requires that this task has CAP_SYS_CHROOT in its
> +        * namespace, or be running with no_new_privs and not sharing its
> +        * fs_struct and not escaping its current root (cf. create_user_n=
s()).
> +        * As for seccomp, checking no_new_privs avoids scenarios where
> +        * unprivileged tasks can affect the behavior of privileged child=
ren.
> +        */
> +       if (task_no_new_privs(current) && current->fs->users =3D=3D 1 &&

this read of current->fs->users should be using READ_ONCE()

> +                       !current_chrooted())
> +               return 0;
> +       if (ns_capable(current_user_ns(), CAP_SYS_CHROOT))
> +               return 0;
> +       return -EPERM;
> +}
[...]

Overall I think this change is a good idea.
