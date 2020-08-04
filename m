Return-Path: <kernel-hardening-return-19553-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id EEE6023BC37
	for <lists+kernel-hardening@lfdr.de>; Tue,  4 Aug 2020 16:33:27 +0200 (CEST)
Received: (qmail 19552 invoked by uid 550); 4 Aug 2020 14:33:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 19524 invoked from network); 4 Aug 2020 14:33:21 -0000
X-MC-Unique: oxN4WAsRPH-FrBjdql4G-A-1
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
Thread-Index: AQHWamb6T+e4gDrzGEmP/30MMvDTCqkoApyQ
Date: Tue, 4 Aug 2020 14:33:06 +0000
Message-ID: <c898918d18f34fd5b004cd1549b6a99e@AcuMS.aculab.com>
References: <20200728131050.24443-1-madvenka@linux.microsoft.com>
 <CALCETrVy5OMuUx04-wWk9FJbSxkrT2vMfN_kANinudrDwC4Cig@mail.gmail.com>
 <6540b4b7-3f70-adbf-c922-43886599713a@linux.microsoft.com>
 <CALCETrWnNR5v3ZCLfBVQGYK8M0jAvQMaAc9uuO05kfZuh-4d6w@mail.gmail.com>
 <46a1adef-65f0-bd5e-0b17-54856fb7e7ee@linux.microsoft.com>
 <20200731183146.GD67415@C02TD0UTHF1T.local>
 <86625441-80f3-2909-2f56-e18e2b60957d@linux.microsoft.com>
 <20200804135558.GA7440@C02TD0UTHF1T.local>
In-Reply-To: <20200804135558.GA7440@C02TD0UTHF1T.local>
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
Content-Transfer-Encoding: base64

PiA+IElmIHlvdSBsb29rIGF0IHRoZSBsaWJmZmkgcmVmZXJlbmNlIHBhdGNoIEkgaGF2ZSBpbmNs
dWRlZCwgdGhlIGFyY2hpdGVjdHVyZQ0KPiA+IHNwZWNpZmljIGNoYW5nZXMgdG8gdXNlIHRyYW1w
ZmQganVzdCBpbnZvbHZlIGEgc2luZ2xlIEMgZnVuY3Rpb24gY2FsbCB0bw0KPiA+IGEgY29tbW9u
IGNvZGUgZnVuY3Rpb24uDQoNCk5vIGlkZWEgd2hhdCBsaWJmZmkgaXMsIGJ1dCBpdCBtdXN0IHN1
cmVseSBiZSBzaW1wbGVyIHRvDQpyZXdyaXRlIGl0IHRvIGF2b2lkIG5lc3RlZCBmdW5jdGlvbiBk
ZWZpbml0aW9ucy4NCg0KT3IgZmluZCBhIGJvb2sgZnJvbSB0aGUgMTk2MHMgb24gaG93IHRvIGRv
IHJlY3Vyc2l2ZQ0KY2FsbHMgYW5kIG5lc3RlZCBmdW5jdGlvbnMgaW4gRk9SVFJBTi1JVi4NCg0K
CURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBN
b3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAx
Mzk3Mzg2IChXYWxlcykNCg==

