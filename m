Return-Path: <kernel-hardening-return-17295-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 4EC83F08CC
	for <lists+kernel-hardening@lfdr.de>; Tue,  5 Nov 2019 22:55:17 +0100 (CET)
Received: (qmail 18347 invoked by uid 550); 5 Nov 2019 21:55:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 18310 invoked from network); 5 Nov 2019 21:55:10 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=dC0txNP98lkR/AeyVbw+ug7nIVFtVKRqgqF3+lbBbTI=;
        b=pBL0Tg/aQMj3dLr3ww+uBbFPQ/NBjzfblKRr64GeVyTUyXJ2hNM31bkIAPRcSA6LPN
         LrnKKiJFv6723CyczJwHO/wfU6ZhGm/qOV4eZWpPOKfayis2aLIKD8R8z5HJ1R98vspU
         /2DpaGxvO50KBQWHDOPz3cgy6zNRGxJ2FC3yEyskRT4zID4R8usx83X1pI/xlFE2695t
         gH2KHamK6i6CtNte0azxKHjj4uqRk/fO5BwmP5KuLCiyP4ztJGNhBN2gsVOv2YUzsVge
         hOG3pWLk4lbKy8aIjAO8xXIDdp5iIhyyxzYmFMKO/oTI91RpLwN1b+JTTKkklDl9LZs3
         GTTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=dC0txNP98lkR/AeyVbw+ug7nIVFtVKRqgqF3+lbBbTI=;
        b=gxXirqCJHMQxoqfkFZOyl8aKgI/rDO40BK5SchqrFlmyfUAA8dCj1G33UhKEZmHQUU
         gxXX2NasONNVpysDAq/WhHMPoNidyYPgXP1NzivpX9EvJOmrK6Ljr/NBI35HIZL1fkmp
         jCGYhAq6rYFNnVuedJjoihFf6CZRJAq9TrI9hOM0Qa0kYEzGryVn/sRoV4Tjn08t8Ezw
         8O/vM02mYC6Ejnt2RBVuuj9bXcHu3uroBYUX42PnyXztOzmSbKVdod/JGyRTmdi/f0HF
         xSfvWE5hlq1iATMT3k9zRSdnCmPwUd1SFCDjvl1qAG75JOznKgPs4bB7JcuWK6RGXn3n
         R07A==
X-Gm-Message-State: APjAAAVFIgx81aZDH5aSJs6DRfzVpIL3pJRT+0BA29N6ET3MfTxue1HL
	U5lAAhWx3+zc2ZPo6oj4nzo=
X-Google-Smtp-Source: APXvYqwAsYjMM0oo9dyOsYCAGNmTpoguNLQCyEmqE8L3PnKhVHWPaTs03SQRTq1JEGxcUzOx5CIg6Q==
X-Received: by 2002:a63:7805:: with SMTP id t5mr4365672pgc.284.1572990898265;
        Tue, 05 Nov 2019 13:54:58 -0800 (PST)
Date: Tue, 5 Nov 2019 13:54:55 -0800
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>,
	linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Daniel Borkmann <daniel@iogearbox.net>,
	David Drysdale <drysdale@google.com>,
	Florent Revest <revest@chromium.org>,
	James Morris <jmorris@namei.org>, Jann Horn <jann@thejh.net>,
	John Johansen <john.johansen@canonical.com>,
	Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>,
	KP Singh <kpsingh@chromium.org>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	=?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mickael.salaun@ssi.gouv.fr>,
	Paul Moore <paul@paul-moore.com>, Sargun Dhillon <sargun@sargun.me>,
	"Serge E . Hallyn" <serge@hallyn.com>,
	Shuah Khan <shuah@kernel.org>, Stephen Smalley <sds@tycho.nsa.gov>,
	Tejun Heo <tj@kernel.org>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Tycho Andersen <tycho@tycho.ws>, Will Drewry <wad@chromium.org>,
	bpf@vger.kernel.org, kernel-hardening@lists.openwall.com,
	linux-api@vger.kernel.org, linux-security-module@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v13 4/7] landlock: Add ptrace LSM hooks
Message-ID: <20191105215453.szhdkrvuekwfz6le@ast-mbp.dhcp.thefacebook.com>
References: <20191104172146.30797-1-mic@digikod.net>
 <20191104172146.30797-5-mic@digikod.net>
 <20191105171824.dfve44gjiftpnvy7@ast-mbp.dhcp.thefacebook.com>
 <c5c6b433-7e6a-c8f8-f063-e704c3df4cc6@schaufler-ca.com>
 <20191105193130.qam2eafnmgvrvjwk@ast-mbp.dhcp.thefacebook.com>
 <637736ef-c48e-ac3b-3eef-8a6a095a96f1@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <637736ef-c48e-ac3b-3eef-8a6a095a96f1@schaufler-ca.com>
User-Agent: NeoMutt/20180223

On Tue, Nov 05, 2019 at 11:55:17AM -0800, Casey Schaufler wrote:
> On 11/5/2019 11:31 AM, Alexei Starovoitov wrote:
> > On Tue, Nov 05, 2019 at 09:55:42AM -0800, Casey Schaufler wrote:
> >> On 11/5/2019 9:18 AM, Alexei Starovoitov wrote:
> >>> On Mon, Nov 04, 2019 at 06:21:43PM +0100, Micka�l Sala�n wrote:
> >>>> Add a first Landlock hook that can be used to enforce a security policy
> >>>> or to audit some process activities.  For a sandboxing use-case, it is
> >>>> needed to inform the kernel if a task can legitimately debug another.
> >>>> ptrace(2) can also be used by an attacker to impersonate another task
> >>>> and remain undetected while performing malicious activities.
> >>>>
> >>>> Using ptrace(2) and related features on a target process can lead to a
> >>>> privilege escalation.  A sandboxed task must then be able to tell the
> >>>> kernel if another task is more privileged, via ptrace_may_access().
> >>>>
> >>>> Signed-off-by: Micka�l Sala�n <mic@digikod.net>
> >>> ...
> >>>> +static int check_ptrace(struct landlock_domain *domain,
> >>>> +		struct task_struct *tracer, struct task_struct *tracee)
> >>>> +{
> >>>> +	struct landlock_hook_ctx_ptrace ctx_ptrace = {
> >>>> +		.prog_ctx = {
> >>>> +			.tracer = (uintptr_t)tracer,
> >>>> +			.tracee = (uintptr_t)tracee,
> >>>> +		},
> >>>> +	};
> >>> So you're passing two kernel pointers obfuscated as u64 into bpf program
> >>> yet claiming that the end goal is to make landlock unprivileged?!
> >>> The most basic security hole in the tool that is aiming to provide security.
> >>>
> >>> I think the only way bpf-based LSM can land is both landlock and KRSI
> >>> developers work together on a design that solves all use cases. BPF is capable
> >>> to be a superset of all existing LSMs
> >> I can't agree with this. Nope. There are many security models
> >> for which BPF introduces excessive complexity. You don't need
> >> or want the generality of a general purpose programming language
> >> to implement Smack or TOMOYO. Or a simple Bell & LaPadula for
> >> that matter. SELinux? I can't imagine anyone trying to do that
> >> in eBPF, although I'm willing to be surprised. Being able to
> >> enforce a policy isn't the only criteria for an LSM. 
> > what are the other criteria?
> 
> They include, but are not limited to, performance impact
> and the ability to be analyzed. 

Right and BPF is the only thing that exists in the kernel where the verifier
knows precisely the number of instructions the critical path through the
program will take. Currently we don't quantify this cost for bpf helpers, but
it's easy to add. Can you do this for smack? Can you tell upfront the longest
execution time for all security rules?

> It has to be fast, or the networking people are
> going to have fits. You can't require the addition
> of a pointer into the skb because it'll get rejected
> out of hand. You can't completely refactor the vfs locking
> to accommodate you needs.

I'm not sure why you got such impression. I'm not proposing to refactor vfs or
add fields to skb. Once we have equivalent to smack policy implemented in
bpf-based lsm let's do performance benchmarking and compare actual numbers
instead of hypothesizing about them. Which policy do you think would be
the most representative of smack use case?

> 
> >
> >> I see many issues with a BPF <-> vfs interface.
> > There is no such interface today. What do you have in mind?
> 
> You can't implement SELinux or Smack using BPF without a way
> to manipulate inode data.

Are you talking about inode->i_security ? That's not manipulating inode data.
It's attaching extra metadata to inode object without changing inode itself.
BPF can do it already via hash maps. It's not as fast as direct pointer access,
but for many use cases it's good enough. If it turns out to be a performance
limiting factor we will accelerate it.

> >> the mechanisms needed for the concerns of the day. Ideally,
> >> we should be able to drop mechanisms when we decide that they
> >> no longer add value.
> > Exactly. bpf-based lsm must not add to kernel abi.
> 
> Huh? I have no idea where that came from.

It sounds to me that some folks in the community got wrong impression that
anything that BPF accesses is magically turning that thing into stable kernel
ABI. That is not true. BPF progs had access _all_ kernel data pointers and
structures for years without turning the whole kernel into stable ABI. I want
to make sure that this part is understood. This is also a requirement for
bpf-based LSM. It must not make LSM hooks into stable ABI.

