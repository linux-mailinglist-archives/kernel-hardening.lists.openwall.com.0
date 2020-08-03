Return-Path: <kernel-hardening-return-19531-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 5C50323A101
	for <lists+kernel-hardening@lfdr.de>; Mon,  3 Aug 2020 10:27:45 +0200 (CEST)
Received: (qmail 25967 invoked by uid 550); 3 Aug 2020 08:27:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 25947 invoked from network); 3 Aug 2020 08:27:40 -0000
X-MC-Unique: 5RDLBwWzPy-44Oq5Oxj5QQ-1
From: David Laight <David.Laight@ACULAB.COM>
To: 'Mark Rutland' <mark.rutland@arm.com>, "Madhavan T. Venkataraman"
	<madvenka@linux.microsoft.com>
CC: Andy Lutomirski <luto@kernel.org>, Kernel Hardening
	<kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Linux FS Devel
	<linux-fsdevel@vger.kernel.org>, linux-integrity
	<linux-integrity@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "LSM
 List" <linux-security-module@vger.kernel.org>, Oleg Nesterov
	<oleg@redhat.com>, X86 ML <x86@kernel.org>
Subject: RE: [PATCH v1 0/4] [RFC] Implement Trampoline File Descriptor
Thread-Topic: [PATCH v1 0/4] [RFC] Implement Trampoline File Descriptor
Thread-Index: AQHWZ2jYT+e4gDrzGEmP/30MMvDTCqkmD9qg
Date: Mon, 3 Aug 2020 08:27:25 +0000
Message-ID: <a3068e3126a942c7a3e7ac115499deb1@AcuMS.aculab.com>
References: <20200728131050.24443-1-madvenka@linux.microsoft.com>
 <CALCETrVy5OMuUx04-wWk9FJbSxkrT2vMfN_kANinudrDwC4Cig@mail.gmail.com>
 <6540b4b7-3f70-adbf-c922-43886599713a@linux.microsoft.com>
 <CALCETrWnNR5v3ZCLfBVQGYK8M0jAvQMaAc9uuO05kfZuh-4d6w@mail.gmail.com>
 <46a1adef-65f0-bd5e-0b17-54856fb7e7ee@linux.microsoft.com>
 <20200731183146.GD67415@C02TD0UTHF1T.local>
In-Reply-To: <20200731183146.GD67415@C02TD0UTHF1T.local>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

From: Mark Rutland
> Sent: 31 July 2020 19:32
...
> > It requires PC-relative data references. I have not worked on all archi=
tectures.
> > So, I need to study this. But do all ISAs support PC-relative data refe=
rences?
>=20
> Not all do, but pretty much any recent ISA will as it's a practical
> necessity for fast position-independent code.

i386 has neither PC-relative addressing nor moves from %pc.
The cpu architecture knows that the sequence:
=09call=091f =20
1:=09pop=09%reg =20
is used to get the %pc value so is treated specially so that
it doesn't 'trash' the return stack.

So PIC code isn't too bad, but you have to use the correct
sequence.

=09David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1=
PT, UK
Registration No: 1397386 (Wales)

