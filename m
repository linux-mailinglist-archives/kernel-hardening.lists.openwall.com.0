Return-Path: <kernel-hardening-return-19467-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 30081230D31
	for <lists+kernel-hardening@lfdr.de>; Tue, 28 Jul 2020 17:13:33 +0200 (CEST)
Received: (qmail 15699 invoked by uid 550); 28 Jul 2020 15:13:27 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 15679 invoked from network); 28 Jul 2020 15:13:26 -0000
X-MC-Unique: JJgRaiMhNeeB2BdH3JMmbA-1
From: David Laight <David.Laight@ACULAB.COM>
To: "'madvenka@linux.microsoft.com'" <madvenka@linux.microsoft.com>,
	"kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>,
	"linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-integrity@vger.kernel.org"
	<linux-integrity@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-security-module@vger.kernel.org"
	<linux-security-module@vger.kernel.org>, "oleg@redhat.com" <oleg@redhat.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: RE: [PATCH v1 0/4] [RFC] Implement Trampoline File Descriptor
Thread-Topic: [PATCH v1 0/4] [RFC] Implement Trampoline File Descriptor
Thread-Index: AQHWZOCQT+e4gDrzGEmP/30MMvDTCqkdFOrw
Date: Tue, 28 Jul 2020 15:13:12 +0000
Message-ID: <c23de6ec47614f489943e1a89a21dfa3@AcuMS.aculab.com>
References: <aefc85852ea518982e74b233e11e16d2e707bc32>
 <20200728131050.24443-1-madvenka@linux.microsoft.com>
In-Reply-To: <20200728131050.24443-1-madvenka@linux.microsoft.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

From:  madvenka@linux.microsoft.com
> Sent: 28 July 2020 14:11
...
> The kernel creates the trampoline mapping without any permissions. When
> the trampoline is executed by user code, a page fault happens and the
> kernel gets control. The kernel recognizes that this is a trampoline
> invocation. It sets up the user registers based on the specified
> register context, and/or pushes values on the user stack based on the
> specified stack context, and sets the user PC to the requested target
> PC. When the kernel returns, execution continues at the target PC.
> So, the kernel does the work of the trampoline on behalf of the
> application.

Isn't the performance of this going to be horrid?

If you don't care that much about performance the fixup can
all be done in userspace within the fault signal handler.

Since whatever you do needs the application changed why
not change the implementation of nested functions to not
need on-stack executable trampolines.

I can think of other alternatives that don't need much more
than an array of 'push constant; jump trampoline' instructions
be created (all jump to the same place).

You might want something to create an executable page of such
instructions.

=09David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1=
PT, UK
Registration No: 1397386 (Wales)

