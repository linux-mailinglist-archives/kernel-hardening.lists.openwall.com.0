Return-Path: <kernel-hardening-return-21628-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by mail.lfdr.de (Postfix) with SMTP id CF2EA682DDF
	for <lists+kernel-hardening@lfdr.de>; Tue, 31 Jan 2023 14:29:44 +0100 (CET)
Received: (qmail 14034 invoked by uid 550); 31 Jan 2023 13:29:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 14014 invoked from network); 31 Jan 2023 13:29:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : content-transfer-encoding : mime-version; s=pp1;
 bh=Oq7b4NckvTknbxBy4DYHz5Z70jm67G/3sful1EeJn/A=;
 b=Ft0jGoWLTQMMkj+OgebjEUUt4KzhERixXi6x9ovgfd4McmEzaBuEdQhAt4iuhIg8fymK
 0eFS8wjxKVIYCQd7v+pXKCnodvOq/yZpNXeR92sNa69zNu3jyFhi1ViEVIYnadG182Lf
 3hprHpXpEtalhUo2oP8ZhkK3cyAHGZkF/v1Bt4ohUZoZEE5ZuX0R00Uqq4O87pCae2HI
 7nhBAlzV5ymjquMDO8p/VlU9HPP5uwRBbpVajGE9qe/5PeX/Pl0PYwVYHNd7nIP0xrIx
 ySSWxmmDNTz5Tj+Bic0STtciuXIeBXGzrJc9OxV/5cppOApw8sNZQpvJRiOy1YZibfRj Sw== 
Message-ID: <261bc99edc43990eecb1aac4fe8005cedc495c20.camel@linux.ibm.com>
Subject: Re: Linux guest kernel threat model for Confidential Computing
From: James Bottomley <jejb@linux.ibm.com>
To: "Reshetova, Elena" <elena.reshetova@intel.com>,
        Leon Romanovsky
	 <leon@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Shishkin, Alexander"
 <alexander.shishkin@intel.com>,
        "Shutemov, Kirill"
 <kirill.shutemov@intel.com>,
        "Kuppuswamy, Sathyanarayanan"
 <sathyanarayanan.kuppuswamy@intel.com>,
        "Kleen, Andi"
 <andi.kleen@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Thomas
 Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "Wunner, Lukas" <lukas.wunner@intel.com>,
        Mika Westerberg
 <mika.westerberg@linux.intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "Poimboe, Josh" <jpoimboe@redhat.com>,
        "aarcange@redhat.com" <aarcange@redhat.com>,
        Cfir Cohen <cfir@google.com>, Marc Orr <marcorr@google.com>,
        "jbachmann@google.com"
 <jbachmann@google.com>,
        "pgonda@google.com" <pgonda@google.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        James Morris
 <jmorris@namei.org>,
        Michael Kelley <mikelley@microsoft.com>,
        "Lange, Jon"
 <jlange@microsoft.com>,
        "linux-coco@lists.linux.dev"
 <linux-coco@lists.linux.dev>,
        Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>,
        Kernel Hardening
 <kernel-hardening@lists.openwall.com>
Date: Tue, 31 Jan 2023 08:28:08 -0500
In-Reply-To: <DM8PR11MB575074D3BCBD02F3DD677A57E7D09@DM8PR11MB5750.namprd11.prod.outlook.com>
References: 
	<DM8PR11MB57505481B2FE79C3D56C9201E7CE9@DM8PR11MB5750.namprd11.prod.outlook.com>
	 <Y9EkCvAfNXnJ+ATo@kroah.com>
	 <DM8PR11MB5750FA4849C3224F597C101AE7CE9@DM8PR11MB5750.namprd11.prod.outlook.com>
	 <Y9Jh2x9XJE1KEUg6@unreal>
	 <DM8PR11MB5750414F6638169C7097E365E7CF9@DM8PR11MB5750.namprd11.prod.outlook.com>
	 <Y9JyW5bUqV7gWmU8@unreal>
	 <DM8PR11MB57507D9C941D77E148EE9E87E7CF9@DM8PR11MB5750.namprd11.prod.outlook.com>
	 <702f22df28e628d41babcf670c909f1fa1bb3c0c.camel@linux.ibm.com>
	 <DM8PR11MB5750F939C0B70939AD3CBC37E7D39@DM8PR11MB5750.namprd11.prod.outlook.com>
	 <220b0be95a8c733f0a6eeddc08e37977ee21d518.camel@linux.ibm.com>
	 <DM8PR11MB575074D3BCBD02F3DD677A57E7D09@DM8PR11MB5750.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: EAlExcun6qSWHXHV8c5yw3LF9GjrnJCP
X-Proofpoint-GUID: bELjeWjqTJMfKOo77xJyr3s4HwA5z6JA
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-31_08,2023-01-31_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 clxscore=1015
 suspectscore=0 priorityscore=1501 lowpriorityscore=0 malwarescore=0
 mlxscore=0 impostorscore=0 bulkscore=0 adultscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301310116

On Tue, 2023-01-31 at 11:31 +0000, Reshetova, Elena wrote:
> > On Mon, 2023-01-30 at 07:42 +0000, Reshetova, Elena wrote:
> > [...]
> > > > The big threat from most devices (including the thunderbolt
> > > > classes) is that they can DMA all over memory.  However, this
> > > > isn't really a threat in CC (well until PCI becomes able to do
> > > > encrypted DMA) because the device has specific unencrypted
> > > > buffers set aside for the expected DMA. If it writes outside
> > > > that CC integrity will detect it and if it reads outside that
> > > > it gets unintelligible ciphertext.  So we're left with the
> > > > device trying to trick secrets out of us by returning
> > > > unexpected data.
> > > 
> > > Yes, by supplying the input that hasn’t been expected. This is
> > > exactly the case we were trying to fix here for example:
> > > https://lore.kernel.org/all/20230119170633.40944-2-
> > alexander.shishkin@linux.intel.com/
> > > I do agree that this case is less severe when others where memory
> > > corruption/buffer overrun can happen, like here:
> > > https://lore.kernel.org/all/20230119135721.83345-6-
> > alexander.shishkin@linux.intel.com/
> > > But we are trying to fix all issues we see now (prioritizing the
> > > second ones though).
> > 
> > I don't see how MSI table sizing is a bug in the category we've
> > defined.  The very text of the changelog says "resulting in a
> > kernel page fault in pci_write_msg_msix()."  which is a crash,
> > which I thought we were agreeing was out of scope for CC attacks?
> 
> As I said this is an example of a crash and on the first look
> might not lead to the exploitable condition (albeit attackers are
> creative). But we noticed this one while fuzzing and it was common
> enough that prevented fuzzer going deeper into the virtio devices
> driver fuzzing. The core PCI/MSI doesn’t seem to have that many
> easily triggerable Other examples in virtio patchset are more severe.

You cited this as your example.  I'm pointing out it seems to be an
event of the class we've agreed not to consider because it's an oops
not an exploit.  If there are examples of fixing actual exploits to CC
VMs, what are they?

This patch is, however, an example of the problem everyone else on the
thread is complaining about: a patch which adds an unnecessary check to
the MSI subsystem; unnecessary because it doesn't fix a CC exploit and
in the real world the tables are correct (or the manufacturer is
quickly chastened), so it adds overhead to no benefit.


[...]
> > see what else it could detect given the signal will be smothered by
> > oopses and secondly I think the PCI interface is likely the wrong
> > place to begin and you should probably begin on the virtio bus and
> > the hypervisor generated configuration space.
> 
> This is exactly what we do. We don’t fuzz from the PCI config space,
> we supply inputs from the host/vmm via the legitimate interfaces that
> it can inject them to the guest: whenever guest requests a pci config
> space (which is controlled by host/hypervisor as you said) read
> operation, it gets input injected by the kafl fuzzer.  Same for other
> interfaces that are under control of host/VMM (MSRs, port IO, MMIO,
> anything that goes via #VE handler in our case). When it comes to
> virtio, we employ  two different fuzzing techniques: directly
> injecting kafl fuzz input when virtio core or virtio drivers gets the
> data received from the host (via injecting input in functions
> virtio16/32/64_to_cpu and others) and directly fuzzing DMA memory
> pages using kfx fuzzer. More information can be found in 
> https://intel.github.io/ccc-linux-guest-hardening-docs/tdx-guest-hardening.html#td-guest-fuzzing

Given that we previously agreed that oppses and other DoS attacks are
out of scope for CC, I really don't think fuzzing, which primarily
finds oopses, is at all a useful tool unless you filter the results by
the question "could we exploit this in a CC VM to reveal secrets". 
Without applying that filter you're sending a load of patches which
don't really do much to reduce the CC attack surface and which do annoy
non-CC people because they add pointless checks to things they expect
the cards and config tables to get right.

James

