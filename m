Return-Path: <kernel-hardening-return-19530-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id E4E9D23A0F0
	for <lists+kernel-hardening@lfdr.de>; Mon,  3 Aug 2020 10:23:23 +0200 (CEST)
Received: (qmail 22125 invoked by uid 550); 3 Aug 2020 08:23:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 22093 invoked from network); 3 Aug 2020 08:23:17 -0000
X-MC-Unique: jniEonvpM6WuyKoEFdxDSQ-2
From: David Laight <David.Laight@ACULAB.COM>
To: "'Madhavan T. Venkataraman'" <madvenka@linux.microsoft.com>, "Andy
 Lutomirski" <luto@kernel.org>
CC: Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux API
	<linux-api@vger.kernel.org>, linux-arm-kernel
	<linux-arm-kernel@lists.infradead.org>, Linux FS Devel
	<linux-fsdevel@vger.kernel.org>, linux-integrity
	<linux-integrity@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "LSM
 List" <linux-security-module@vger.kernel.org>, Oleg Nesterov
	<oleg@redhat.com>, X86 ML <x86@kernel.org>
Subject: RE: [PATCH v1 0/4] [RFC] Implement Trampoline File Descriptor
Thread-Topic: [PATCH v1 0/4] [RFC] Implement Trampoline File Descriptor
Thread-Index: AQHWaP5tgOpJhgITEEScB0GhgJrbRKkmC0zQ
Date: Mon, 3 Aug 2020 08:23:03 +0000
Message-ID: <a5fb2778a86f45b58ef5dd35228d950b@AcuMS.aculab.com>
References: <20200728131050.24443-1-madvenka@linux.microsoft.com>
 <CALCETrVy5OMuUx04-wWk9FJbSxkrT2vMfN_kANinudrDwC4Cig@mail.gmail.com>
 <3b916198-3a98-bd19-9a1c-f2d8d44febe8@linux.microsoft.com>
In-Reply-To: <3b916198-3a98-bd19-9a1c-f2d8d44febe8@linux.microsoft.com>
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

RnJvbTogTWFkaGF2YW4gVC4gVmVua2F0YXJhbWFuDQo+IFNlbnQ6IDAyIEF1Z3VzdCAyMDIwIDE5
OjU1DQo+IFRvOiBBbmR5IEx1dG9taXJza2kgPGx1dG9Aa2VybmVsLm9yZz4NCj4gQ2M6IEtlcm5l
bCBIYXJkZW5pbmcgPGtlcm5lbC1oYXJkZW5pbmdAbGlzdHMub3BlbndhbGwuY29tPjsgTGludXgg
QVBJIDxsaW51eC1hcGlAdmdlci5rZXJuZWwub3JnPjsNCj4gbGludXgtYXJtLWtlcm5lbCA8bGlu
dXgtYXJtLWtlcm5lbEBsaXN0cy5pbmZyYWRlYWQub3JnPjsgTGludXggRlMgRGV2ZWwgPGxpbnV4
LQ0KPiBmc2RldmVsQHZnZXIua2VybmVsLm9yZz47IGxpbnV4LWludGVncml0eSA8bGludXgtaW50
ZWdyaXR5QHZnZXIua2VybmVsLm9yZz47IExLTUwgPGxpbnV4LQ0KPiBrZXJuZWxAdmdlci5rZXJu
ZWwub3JnPjsgTFNNIExpc3QgPGxpbnV4LXNlY3VyaXR5LW1vZHVsZUB2Z2VyLmtlcm5lbC5vcmc+
OyBPbGVnIE5lc3Rlcm92DQo+IDxvbGVnQHJlZGhhdC5jb20+OyBYODYgTUwgPHg4NkBrZXJuZWwu
b3JnPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHYxIDAvNF0gW1JGQ10gSW1wbGVtZW50IFRyYW1w
b2xpbmUgRmlsZSBEZXNjcmlwdG9yDQo+IA0KPiBNb3JlIHJlc3BvbnNlcyBpbmxpbmUuLg0KPiAN
Cj4gT24gNy8yOC8yMCAxMjozMSBQTSwgQW5keSBMdXRvbWlyc2tpIHdyb3RlOg0KPiA+PiBPbiBK
dWwgMjgsIDIwMjAsIGF0IDY6MTEgQU0sIG1hZHZlbmthQGxpbnV4Lm1pY3Jvc29mdC5jb20gd3Jv
dGU6DQo+ID4+DQo+ID4+IO+7v0Zyb206ICJNYWRoYXZhbiBULiBWZW5rYXRhcmFtYW4iIDxtYWR2
ZW5rYUBsaW51eC5taWNyb3NvZnQuY29tPg0KPiA+Pg0KPiA+DQo+ID4gMi4gVXNlIGV4aXN0aW5n
IGtlcm5lbCBmdW5jdGlvbmFsaXR5LiAgUmFpc2UgYSBzaWduYWwsIG1vZGlmeSB0aGUNCj4gPiBz
dGF0ZSwgYW5kIHJldHVybiBmcm9tIHRoZSBzaWduYWwuICBUaGlzIGlzIHZlcnkgZmxleGlibGUg
YW5kIG1heSBub3QNCj4gPiBiZSBhbGwgdGhhdCBtdWNoIHNsb3dlciB0aGFuIHRyYW1wZmQuDQo+
IA0KPiBMZXQgbWUgdW5kZXJzdGFuZCB0aGlzLiBZb3UgYXJlIHNheWluZyB0aGF0IHRoZSB0cmFt
cG9saW5lIGNvZGUNCj4gd291bGQgcmFpc2UgYSBzaWduYWwgYW5kLCBpbiB0aGUgc2lnbmFsIGhh
bmRsZXIsIHNldCB1cCB0aGUgY29udGV4dA0KPiBzbyB0aGF0IHdoZW4gdGhlIHNpZ25hbCBoYW5k
bGVyIHJldHVybnMsIHdlIGVuZCB1cCBpbiB0aGUgdGFyZ2V0DQo+IGZ1bmN0aW9uIHdpdGggdGhl
IGNvbnRleHQgY29ycmVjdGx5IHNldCB1cC4gQW5kLCB0aGlzIHRyYW1wb2xpbmUgY29kZQ0KPiBj
YW4gYmUgZ2VuZXJhdGVkIHN0YXRpY2FsbHkgYXQgYnVpbGQgdGltZSBzbyB0aGF0IHRoZXJlIGFy
ZSBubw0KPiBzZWN1cml0eSBpc3N1ZXMgdXNpbmcgaXQuDQo+IA0KPiBIYXZlIEkgdW5kZXJzdG9v
ZCB5b3VyIHN1Z2dlc3Rpb24gY29ycmVjdGx5Pw0KDQpJIHdhcyB0aGlua2luZyB0aGF0IHlvdSdk
IGp1c3QgbGV0IHRoZSAnbm90IGV4ZWN1dGFibGUnIHBhZ2UgZmF1bHQNCnNpZ25hbCBoYXBwZW4g
KFNJR1NFR1Y/KSB3aGVuIHRoZSBjb2RlIGp1bXBzIHRvIG9uLXN0YWNrIHRyYW1wb2xpbmUNCmlz
IGV4ZWN1dGVkLg0KDQpUaGUgdXNlciBzaWduYWwgaGFuZGxlciBjYW4gdGhlbiBkZWNvZGUgdGhl
IGZhdWx0aW5nIGluc3RydWN0aW9uDQphbmQsIGlmIGl0IG1hdGNoZXMgdGhlIGV4cGVjdGVkIG9u
LXN0YWNrIHRyYW1wb2xpbmUsIG1vZGlmeSB0aGUNCnNhdmVkIHJlZ2lzdGVycyBiZWZvcmUgcmV0
dXJuaW5nIGZyb20gdGhlIHNpZ25hbC4NCg0KTm8ga2VybmVsIGNoYW5nZXMgYW5kIGFsbCB5b3Ug
bmVlZCB0byBhZGQgdG8gdGhlIHByb2dyYW0gaXMNCmFuIGFyY2hpdGVjdHVyZS1kZXBlbmRhbnQg
c2lnbmFsIGhhbmRsZXIuDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNp
ZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsN
ClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

