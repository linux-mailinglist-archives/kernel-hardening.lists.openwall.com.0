Return-Path: <kernel-hardening-return-21296-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 519BD3A1CA1
	for <lists+kernel-hardening@lfdr.de>; Wed,  9 Jun 2021 20:20:55 +0200 (CEST)
Received: (qmail 1797 invoked by uid 550); 9 Jun 2021 18:20:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1762 invoked from network); 9 Jun 2021 18:20:47 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pMNtPdB4yeaOaJg4oKXM0D8sPt6m955IeGjoIXPrk70=;
        b=PazdJpi79UQEsNsJQD2CIaSYmwpf00Mw0MCZeW5GC2zdnsa0IB92sYjdiUDujBLmOv
         3yiW/7qHaVhsPjbZomfBsLbYDeD+/ig/7taYFSIjA7Cs35U9xgJInZA2nA7XIhz+eX/f
         YAYlYYJX5H3ZqKlrBYtQLFY0ybk6rdc7RljwY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pMNtPdB4yeaOaJg4oKXM0D8sPt6m955IeGjoIXPrk70=;
        b=OewZW6XDHNxtwHdeRTpiOv9I5yaPnj9SaHV8eyEaM9ufHpl/NFKoENAfnebtQgfAAd
         kRBNvxjzHZC/7oU+0M/aKvBnBb1wsN1sXQAptguZ+BqWdRaFp3HefXWwZCIPToP9OAZY
         DfA4whENqSUzgSZzPIBHS9sr3xN3e2T3F+OIwbW4U1bpjX/19B1OTFsKiXFr4kcQ8yKn
         UVe7c4psY+GLhcswvYt09+CXhk/llADJGGRSVPOzfZ5b34pHGQtwYyH+Y3HCQBtP/R0M
         ybuVYZb6Ur8lv4Pl005l/6YOf/scfK9SYIf/xVkEkVMKhUjHT0Uz/x70OtNLyPBP57/J
         Xi/w==
X-Gm-Message-State: AOAM5305MA7qnTNGsHge50F95lLwD3u58HJ+wYbEA7GJeBLvcyk3EP+2
	StSRQi6FQWNVMbdfhRclvHuD2g==
X-Google-Smtp-Source: ABdhPJwLivfhU+7xTPT8sWB9xanESizvLeRBJblRt/PXXDrCMVDmnpcAtkIZk9u/qQeEhmYEwcu4IA==
X-Received: by 2002:a62:3444:0:b029:2ec:9658:a755 with SMTP id b65-20020a6234440000b02902ec9658a755mr1010418pfa.71.1623262835683;
        Wed, 09 Jun 2021 11:20:35 -0700 (PDT)
Date: Wed, 9 Jun 2021 11:20:33 -0700
From: Kees Cook <keescook@chromium.org>
To: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Yonghong Song <yhs@fb.com>,
	Kurt Manucredo <fuzzybritches0@gmail.com>,
	syzbot+bed360704c521841c85d@syzkaller.appspotmail.com,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	"David S. Miller" <davem@davemloft.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Martin KaFai Lau <kafai@fb.com>, KP Singh <kpsingh@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>,
	Song Liu <songliubraving@fb.com>,
	syzkaller-bugs <syzkaller-bugs@googlegroups.com>, nathan@kernel.org,
	Nick Desaulniers <ndesaulniers@google.com>,
	Clang-Built-Linux ML <clang-built-linux@googlegroups.com>,
	linux-kernel-mentees@lists.linuxfoundation.org,
	Shuah Khan <skhan@linuxfoundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	kasan-dev <kasan-dev@googlegroups.com>
Subject: Re: [PATCH v4] bpf: core: fix shift-out-of-bounds in ___bpf_prog_run
Message-ID: <202106091119.84A88B6FE7@keescook>
References: <000000000000c2987605be907e41@google.com>
 <20210602212726.7-1-fuzzybritches0@gmail.com>
 <YLhd8BL3HGItbXmx@kroah.com>
 <87609-531187-curtm@phaethon>
 <6a392b66-6f26-4532-d25f-6b09770ce366@fb.com>
 <CAADnVQKexxZQw0yK_7rmFOdaYabaFpi2EmF6RGs5bXvFHtUQaA@mail.gmail.com>
 <CACT4Y+b=si6NCx=nRHKm_pziXnVMmLo-eSuRajsxmx5+Hy_ycg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+b=si6NCx=nRHKm_pziXnVMmLo-eSuRajsxmx5+Hy_ycg@mail.gmail.com>

On Mon, Jun 07, 2021 at 09:38:43AM +0200, 'Dmitry Vyukov' via Clang Built Linux wrote:
> On Sat, Jun 5, 2021 at 9:10 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> > On Sat, Jun 5, 2021 at 10:55 AM Yonghong Song <yhs@fb.com> wrote:
> > > On 6/5/21 8:01 AM, Kurt Manucredo wrote:
> > > > Syzbot detects a shift-out-of-bounds in ___bpf_prog_run()
> > > > kernel/bpf/core.c:1414:2.
> > >
> > > This is not enough. We need more information on why this happens
> > > so we can judge whether the patch indeed fixed the issue.
> > >
> > > >
> > > > I propose: In adjust_scalar_min_max_vals() move boundary check up to avoid
> > > > missing them and return with error when detected.
> > > >
> > > > Reported-and-tested-by: syzbot+bed360704c521841c85d@syzkaller.appspotmail.com
> > > > Signed-off-by: Kurt Manucredo <fuzzybritches0@gmail.com>
> > > > ---
> > > >
> > > > https://syzkaller.appspot.com/bug?id=edb51be4c9a320186328893287bb30d5eed09231
> > > >
> > > > Changelog:
> > > > ----------
> > > > v4 - Fix shift-out-of-bounds in adjust_scalar_min_max_vals.
> > > >       Fix commit message.
> > > > v3 - Make it clearer what the fix is for.
> > > > v2 - Fix shift-out-of-bounds in ___bpf_prog_run() by adding boundary
> > > >       check in check_alu_op() in verifier.c.
> > > > v1 - Fix shift-out-of-bounds in ___bpf_prog_run() by adding boundary
> > > >       check in ___bpf_prog_run().
> > > >
> > > > thanks
> > > >
> > > > kind regards
> > > >
> > > > Kurt
> > > >
> > > >   kernel/bpf/verifier.c | 30 +++++++++---------------------
> > > >   1 file changed, 9 insertions(+), 21 deletions(-)
> > > >
> > > > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > > > index 94ba5163d4c5..ed0eecf20de5 100644
> > > > --- a/kernel/bpf/verifier.c
> > > > +++ b/kernel/bpf/verifier.c
> > > > @@ -7510,6 +7510,15 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
> > > >       u32_min_val = src_reg.u32_min_value;
> > > >       u32_max_val = src_reg.u32_max_value;
> > > >
> > > > +     if ((opcode == BPF_LSH || opcode == BPF_RSH || opcode == BPF_ARSH) &&
> > > > +                     umax_val >= insn_bitness) {
> > > > +             /* Shifts greater than 31 or 63 are undefined.
> > > > +              * This includes shifts by a negative number.
> > > > +              */
> > > > +             verbose(env, "invalid shift %lld\n", umax_val);
> > > > +             return -EINVAL;
> > > > +     }
> > >
> > > I think your fix is good. I would like to move after
> >
> > I suspect such change will break valid programs that do shift by register.
> >
> > > the following code though:
> > >
> > >          if (!src_known &&
> > >              opcode != BPF_ADD && opcode != BPF_SUB && opcode != BPF_AND) {
> > >                  __mark_reg_unknown(env, dst_reg);
> > >                  return 0;
> > >          }
> > >
> > > > +
> > > >       if (alu32) {
> > > >               src_known = tnum_subreg_is_const(src_reg.var_off);
> > > >               if ((src_known &&
> > > > @@ -7592,39 +7601,18 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
> > > >               scalar_min_max_xor(dst_reg, &src_reg);
> > > >               break;
> > > >       case BPF_LSH:
> > > > -             if (umax_val >= insn_bitness) {
> > > > -                     /* Shifts greater than 31 or 63 are undefined.
> > > > -                      * This includes shifts by a negative number.
> > > > -                      */
> > > > -                     mark_reg_unknown(env, regs, insn->dst_reg);
> > > > -                     break;
> > > > -             }
> > >
> > > I think this is what happens. For the above case, we simply
> > > marks the dst reg as unknown and didn't fail verification.
> > > So later on at runtime, the shift optimization will have wrong
> > > shift value (> 31/64). Please correct me if this is not right
> > > analysis. As I mentioned in the early please write detailed
> > > analysis in commit log.
> >
> > The large shift is not wrong. It's just undefined.
> > syzbot has to ignore such cases.
> 
> Hi Alexei,
> 
> The report is produced by KUBSAN. I thought there was an agreement on
> cleaning up KUBSAN reports from the kernel (the subset enabled on
> syzbot at least).
> What exactly cases should KUBSAN ignore?
> +linux-hardening/kasan-dev for KUBSAN false positive

Can check_shl_overflow() be used at all? Best to just make things
readable and compiler-happy, whatever the implementation. :)

-- 
Kees Cook
