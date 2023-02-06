Return-Path: <kernel-hardening-return-21642-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by mail.lfdr.de (Postfix) with SMTP id 5497768C64F
	for <lists+kernel-hardening@lfdr.de>; Mon,  6 Feb 2023 19:59:14 +0100 (CET)
Received: (qmail 9917 invoked by uid 550); 6 Feb 2023 18:59:02 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 9895 invoked from network); 6 Feb 2023 18:59:02 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675709930;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m16OitzwO71nkhwycKeW6iMhsPFeKDcAk5Zf0tX9cZY=;
	b=TwT4o9kV52bL04RBU0cVfTQ376jxUCWoXPGpzxtBctOahrG8tIPR4UPOT+nWeBdDnIE3HD
	MuwTJj1YAEAMj+w5mX1v9CD18Eo7XYBIXvr1gTAJ3WCPijXmOeoaKa1sm2oIsVkIO6+P4x
	GlzyBrtSoxmhpmXkV3Ppe3lkLiH34kE=
X-MC-Unique: MhFxJGf9O3e2QAOnF1d44A-1
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m16OitzwO71nkhwycKeW6iMhsPFeKDcAk5Zf0tX9cZY=;
        b=RjMs/phjM3l9jaKRon8fgH5TZ2XHVlChJN/voI8FvGNrnz9erRvH2gBaRaKRv6BDAt
         5eNkGZ6K9kJ4LUDX5QaKg57/nL9L5cNZJfJbC/bH51UBsQoPJtAM2ADsUfgIAGJuLCki
         AQb8l3Pnt25jJnx0m69MOZKsuVt9Ke2lV62ghAdsoY6hWQr1U5793nDLVzTEFO8B/5wS
         YOsqR2eZZnvhVxoRnrVTMhVrLblESCU2gsLnEm64in6X4YMuvEXQYvMh9o2RyeQscLaK
         5p9sNbjensyWUKrmBrpDBdJYWZv+ZGILqhYfIRFhwPtcDjFFhVGHDDkTZj9nBXDO79Go
         h2Gg==
X-Gm-Message-State: AO0yUKU+3PWO/KrEni8INU+Lk/xTtXYub6KD48DKxjX/kA2WLuoxlVlv
	jrHfoVZ26d/oWNN4rvRneooYTPl20TXSmPxC8/y/oXWyY+80zctA0f0pSWVVOU5HNn36L+6UiOD
	2M/5Xt2wu+rdW4Kzry8eR0oSOU499Zq1CMw==
X-Received: by 2002:a05:6000:69b:b0:2bf:dcdc:afb8 with SMTP id bo27-20020a056000069b00b002bfdcdcafb8mr20030046wrb.64.1675709927235;
        Mon, 06 Feb 2023 10:58:47 -0800 (PST)
X-Google-Smtp-Source: AK7set8UHg3rrYoack96/+Aen7rLx+dOSRGVf2dLJL6sX4SVrvCzEJO1dTlVfmXxYWw3BHd7tf86MA==
X-Received: by 2002:a05:6000:69b:b0:2bf:dcdc:afb8 with SMTP id bo27-20020a056000069b00b002bfdcdcafb8mr20030031wrb.64.1675709926964;
        Mon, 06 Feb 2023 10:58:46 -0800 (PST)
Date: Mon, 6 Feb 2023 18:58:44 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To: Christophe de Dinechin <dinechin@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	James Bottomley <jejb@linux.ibm.com>,
	"Reshetova, Elena" <elena.reshetova@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Shishkin, Alexander" <alexander.shishkin@intel.com>,
	"Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"Kuppuswamy, Sathyanarayanan" <sathyanarayanan.kuppuswamy@intel.com>,
	"Kleen, Andi" <andi.kleen@intel.com>,
	"Hansen, Dave" <dave.hansen@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	"Wunner, Lukas" <lukas.wunner@intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Jason Wang <jasowang@redhat.com>,
	"Poimboe, Josh" <jpoimboe@redhat.com>,
	"aarcange@redhat.com" <aarcange@redhat.com>,
	Cfir Cohen <cfir@google.com>, Marc Orr <marcorr@google.com>,
	"jbachmann@google.com" <jbachmann@google.com>,
	"pgonda@google.com" <pgonda@google.com>,
	"keescook@chromium.org" <keescook@chromium.org>,
	James Morris <jmorris@namei.org>,
	Michael Kelley <mikelley@microsoft.com>,
	"Lange, Jon" <jlange@microsoft.com>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: Linux guest kernel threat model for Confidential Computing
Message-ID: <Y+FN5B9VIKNFijCO@work-vm>
References: <220b0be95a8c733f0a6eeddc08e37977ee21d518.camel@linux.ibm.com>
 <DM8PR11MB575074D3BCBD02F3DD677A57E7D09@DM8PR11MB5750.namprd11.prod.outlook.com>
 <261bc99edc43990eecb1aac4fe8005cedc495c20.camel@linux.ibm.com>
 <m2h6w6k5on.fsf@redhat.com>
 <20230131123033-mutt-send-email-mst@kernel.org>
 <6BCC3285-ACA3-4E38-8811-1A91C9F03852@redhat.com>
 <20230201055412-mutt-send-email-mst@kernel.org>
 <4B78D161-2712-434A-8E6F-9D8BA468BB3A@redhat.com>
 <20230201105305-mutt-send-email-mst@kernel.org>
 <m2zg9xi8gr.fsf@redhat.com>
MIME-Version: 1.0
In-Reply-To: <m2zg9xi8gr.fsf@redhat.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

* Christophe de Dinechin (dinechin@redhat.com) wrote:
> 
> On 2023-02-01 at 11:02 -05, "Michael S. Tsirkin" <mst@redhat.com> wrote...
> > On Wed, Feb 01, 2023 at 02:15:10PM +0100, Christophe de Dinechin Dupont de Dinechin wrote:
> >>
> >>
> >> > On 1 Feb 2023, at 12:01, Michael S. Tsirkin <mst@redhat.com> wrote:
> >> >
> >> > On Wed, Feb 01, 2023 at 11:52:27AM +0100, Christophe de Dinechin Dupont de Dinechin wrote:
> >> >>
> >> >>
> >> >>> On 31 Jan 2023, at 18:39, Michael S. Tsirkin <mst@redhat.com> wrote:
> >> >>>
> >> >>> On Tue, Jan 31, 2023 at 04:14:29PM +0100, Christophe de Dinechin wrote:
> >> >>>> Finally, security considerations that apply irrespective of whether the
> >> >>>> platform is confidential or not are also outside of the scope of this
> >> >>>> document. This includes topics ranging from timing attacks to social
> >> >>>> engineering.
> >> >>>
> >> >>> Why are timing attacks by hypervisor on the guest out of scope?
> >> >>
> >> >> Good point.
> >> >>
> >> >> I was thinking that mitigation against timing attacks is the same
> >> >> irrespective of the source of the attack. However, because the HV
> >> >> controls CPU time allocation, there are presumably attacks that
> >> >> are made much easier through the HV. Those should be listed.
> >> >
> >> > Not just that, also because it can and does emulate some devices.
> >> > For example, are disk encryption systems protected against timing of
> >> > disk accesses?
> >> > This is why some people keep saying "forget about emulated devices, require
> >> > passthrough, include devices in the trust zone".
> >> >
> >> >>>
> >> >>>> </doc>
> >> >>>>
> >> >>>> Feel free to comment and reword at will ;-)
> >> >>>>
> >> >>>>
> >> >>>> 3/ PCI-as-a-threat: where does that come from
> >> >>>>
> >> >>>> Isn't there a fundamental difference, from a threat model perspective,
> >> >>>> between a bad actor, say a rogue sysadmin dumping the guest memory (which CC
> >> >>>> should defeat) and compromised software feeding us bad data? I think there
> >> >>>> is: at leats inside the TCB, we can detect bad software using measurements,
> >> >>>> and prevent it from running using attestation.  In other words, we first
> >> >>>> check what we will run, then we run it. The security there is that we know
> >> >>>> what we are running. The trust we have in the software is from testing,
> >> >>>> reviewing or using it.
> >> >>>>
> >> >>>> This relies on a key aspect provided by TDX and SEV, which is that the
> >> >>>> software being measured is largely tamper-resistant thanks to memory
> >> >>>> encryption. In other words, after you have measured your guest software
> >> >>>> stack, the host or hypervisor cannot willy-nilly change it.
> >> >>>>
> >> >>>> So this brings me to the next question: is there any way we could offer the
> >> >>>> same kind of service for KVM and qemu? The measurement part seems relatively
> >> >>>> easy. Thetamper-resistant part, on the other hand, seems quite difficult to
> >> >>>> me. But maybe someone else will have a brilliant idea?
> >> >>>>
> >> >>>> So I'm asking the question, because if you could somehow prove to the guest
> >> >>>> not only that it's running the right guest stack (as we can do today) but
> >> >>>> also a known host/KVM/hypervisor stack, we would also switch the potential
> >> >>>> issues with PCI, MSRs and the like from "malicious" to merely "bogus", and
> >> >>>> this is something which is evidently easier to deal with.
> >> >>>
> >> >>> Agree absolutely that's much easier.
> >> >>>
> >> >>>> I briefly discussed this with James, and he pointed out two interesting
> >> >>>> aspects of that question:
> >> >>>>
> >> >>>> 1/ In the CC world, we don't really care about *virtual* PCI devices. We
> >> >>>>  care about either virtio devices, or physical ones being passed through
> >> >>>>  to the guest. Let's assume physical ones can be trusted, see above.
> >> >>>>  That leaves virtio devices. How much damage can a malicious virtio device
> >> >>>>  do to the guest kernel, and can this lead to secrets being leaked?
> >> >>>>
> >> >>>> 2/ He was not as negative as I anticipated on the possibility of somehow
> >> >>>>  being able to prevent tampering of the guest. One example he mentioned is
> >> >>>>  a research paper [1] about running the hypervisor itself inside an
> >> >>>>  "outer" TCB, using VMPLs on AMD. Maybe something similar can be achieved
> >> >>>>  with TDX using secure enclaves or some other mechanism?
> >> >>>
> >> >>> Or even just secureboot based root of trust?
> >> >>
> >> >> You mean host secureboot? Or guest?
> >> >>
> >> >> If it’s host, then the problem is detecting malicious tampering with
> >> >> host code (whether it’s kernel or hypervisor).
> >> >
> >> > Host.  Lots of existing systems do this.  As an extreme boot a RO disk,
> >> > limit which packages are allowed.
> >>
> >> Is that provable to the guest?
> >>
> >> Consider a cloud provider doing that: how do they prove to their guest:
> >>
> >> a) What firmware, kernel and kvm they run
> >>
> >> b) That what they booted cannot be maliciouly modified, e.g. by a rogue
> >>    device driver installed by a rogue sysadmin
> >>
> >> My understanding is that SecureBoot is only intended to prevent non-verified
> >> operating systems from booting. So the proof is given to the cloud provider,
> >> and the proof is that the system boots successfully.
> >
> > I think I should have said measured boot not secure boot.
> 
> The problem again is how you prove to the guest that you are not lying?
> 
> We know how to do that from a guest [1], but you will note that in the
> normal process, a trusted hardware component (e.g. the PSP for AMD SEV)
> proves the validity of the measurements of the TCB by encrypting it with an
> attestation signing key derived from some chip-unique secret. For AMD, this
> is called the VCEK, and TDX has something similar. In the case of SEV, this
> goes through firmware, and you have to tell the firmware each time you
> insert data in the original TCB (using SNP_LAUNCH_UPDATE). This is all tied
> to a VM execution context. I do not believe there is any provision to do the
> same thing to measure host data. And again, it would be somewhat pointless
> if there isn't also a mechanism to ensure the host data is not changed after
> the measurement.
> 
> Now, I don't think it would be super-difficult to add a firmware service
> that would let the host do some kind of equivalent to PVALIDATE, setting
> some physical pages aside that then get measured and become inaccessible to
> the host. The PSP or similar could then integrate these measurements as part
> of the TCB, and the fact that the pages were "transferred" to this special
> invariant block would ensure the guests that the code will not change after
> being measured.
> 
> I am not aware that such a mechanism exists on any of the existing CC
> platforms. Please feel free to enlighten me if I'm wrong.
> 
> [1] https://www.redhat.com/en/blog/understanding-confidential-containers-attestation-flow
> >
> >>
> >> After that, I think all bets are off. SecureBoot does little AFAICT
> >> to prevent malicious modifications of the running system by someone with
> >> root access, including deliberately loading a malicious kvm-zilog.ko
> >
> > So disable module loading then or don't allow root access?
> 
> Who would do that?
> 
> The problem is that we have a host and a tenant, and the tenant does not
> trust the host in principle. So it is not sufficient for the host to disable
> module loading or carefully control root access. It is also necessary to
> prove to the tenant(s) that this was done.
> 
> >
> >>
> >> It does not mean it cannot be done, just that I don’t think we
> >> have the tools at the moment.
> >
> > Phones, chromebooks do this all the time ...
> 
> Indeed, but there, this is to prove to the phone's real owner (which,
> surprise, is not the naive person who thought they'd get some kind of
> ownership by buying the phone) that the software running on the phone has
> not been replaced by some horribly jailbreaked goo.
> 
> In other words, the user of the phone gets no proof whatsoever of anything,
> except that the phone appears to work. This is somewhat the situation in the
> cloud today: the owners of the hardware get all sorts of useful checks, from
> SecureBoot to error-correction for memory or I/O devices. However, someone
> running in a VM on the cloud gets none of that, just like the user of your
> phone.

Assuming you do a measured boot, the host OS and firmware is measured into the host TPM;
people have thought in the past about triggering attestations of the
host from the guest; then you could have something external attest the
host and only release keys to the guests disks if the attestation is
correct; or a key for the guests disks held in the hosts TPM.

Dave

> --
> Cheers,
> Christophe de Dinechin (https://c3d.github.io)
> Theory of Incomplete Measurements (https://c3d.github.io/TIM)
> 
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

