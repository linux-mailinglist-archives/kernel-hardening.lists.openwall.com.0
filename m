Return-Path: <kernel-hardening-return-18735-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 030DC1C8609
	for <lists+kernel-hardening@lfdr.de>; Thu,  7 May 2020 11:44:37 +0200 (CEST)
Received: (qmail 8086 invoked by uid 550); 7 May 2020 09:44:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 8066 invoked from network); 7 May 2020 09:44:31 -0000
X-MC-Unique: NnifUXbxOzWpb5XrCVK4yA-1
From: David Laight <David.Laight@ACULAB.COM>
To: =?utf-8?B?J01pY2thw6tsIFNhbGHDvG4n?= <mic@digikod.net>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Aleksa Sarai <cyphar@cyphar.com>, Alexei Starovoitov <ast@kernel.org>, "Al
 Viro" <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>,
	"Christian Heimes" <christian@python.org>, Daniel Borkmann
	<daniel@iogearbox.net>, "Deven Bowers" <deven.desai@linux.microsoft.com>,
	Eric Chiang <ericchiang@google.com>, Florian Weimer <fweimer@redhat.com>,
	James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>, Jann Horn
	<jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook
	<keescook@chromium.org>, "Lakshmi Ramasubramanian"
	<nramas@linux.microsoft.com>, Matthew Garrett <mjg59@google.com>, Matthew
 Wilcox <willy@infradead.org>, Michael Kerrisk <mtk.manpages@gmail.com>,
	=?utf-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mickael.salaun@ssi.gouv.fr>, Mimi Zohar
	<zohar@linux.ibm.com>, =?utf-8?B?UGhpbGlwcGUgVHLDqWJ1Y2hldA==?=
	<philippe.trebuchet@ssi.gouv.fr>, Scott Shell <scottsh@microsoft.com>, Sean
 Christopherson <sean.j.christopherson@intel.com>, Shuah Khan
	<shuah@kernel.org>, Steve Dower <steve.dower@python.org>, Steve Grubb
	<sgrubb@redhat.com>, Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
	"kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>,
	"linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
	"linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
	"linux-security-module@vger.kernel.org"
	<linux-security-module@vger.kernel.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>
Subject: RE: [PATCH v5 0/6] Add support for O_MAYEXEC
Thread-Topic: [PATCH v5 0/6] Add support for O_MAYEXEC
Thread-Index: AQHWIvJxeV/0BLZ+8kuLT1dTVkm+SqicRhNg///4h4CAABSTQP//+lUAgAAR6XA=
Date: Thu, 7 May 2020 09:44:18 +0000
Message-ID: <635df0655b644408ac4822def8900383@AcuMS.aculab.com>
References: <20200505153156.925111-1-mic@digikod.net>
 <20b24b9ca0a64afb9389722845738ec8@AcuMS.aculab.com>
 <907109c8-9b19-528a-726f-92c3f61c1563@digikod.net>
 <ad28ab5fe7854b41a575656e95b4da17@AcuMS.aculab.com>
 <64426377-7fc4-6f37-7371-2e2a584e3032@digikod.net>
In-Reply-To: <64426377-7fc4-6f37-7371-2e2a584e3032@digikod.net>
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
Content-Transfer-Encoding: base64

RnJvbTogTWlja2HDq2wgU2FsYcO8biA8bWljQGRpZ2lrb2QubmV0Pg0KPiBTZW50OiAwNyBNYXkg
MjAyMCAxMDozMA0KPiBPbiAwNy8wNS8yMDIwIDExOjAwLCBEYXZpZCBMYWlnaHQgd3JvdGU6DQo+
ID4gRnJvbTogTWlja2HDq2wgU2FsYcO8bg0KPiA+PiBTZW50OiAwNyBNYXkgMjAyMCAwOTozNw0K
PiA+IC4uLg0KPiA+Pj4gTm9uZSBvZiB0aGF0IGRlc2NyaXB0aW9uIGFjdHVhbGx5IHNheXMgd2hh
dCB0aGUgcGF0Y2ggYWN0dWFsbHkgZG9lcy4NCj4gPj4NCj4gPj4gIkFkZCBzdXBwb3J0IGZvciBP
X01BWUVYRUMiICJ0byBlbmFibGUgdG8gY29udHJvbCBzY3JpcHQgZXhlY3V0aW9uIi4NCj4gPj4g
V2hhdCBpcyBub3QgY2xlYXIgaGVyZT8gVGhpcyBzZWVtcyB3ZWxsIHVuZGVyc3Rvb2QgYnkgb3Ro
ZXIgY29tbWVudGVycy4NCj4gPj4gVGhlIGRvY3VtZW50YXRpb24gcGF0Y2ggYW5kIHRoZSB0YWxr
cyBjYW4gYWxzbyBoZWxwLg0KPiA+DQo+ID4gSSdtIGd1ZXNzaW5nIHRoYXQgcGFzc2luZyBPX01B
WUVYRUMgdG8gb3BlbigpIHJlcXVlc3RzIHRoZSBrZXJuZWwNCj4gPiBjaGVjayBmb3IgZXhlY3V0
ZSAneCcgcGVybWlzc2lvbnMgKGFzIHdlbGwgYXMgcmVhZCkuDQo+IA0KPiBZZXMsIGJ1dCBvbmx5
IHdpdGggb3BlbmF0MigpLg0KDQpJdCBjYW4ndCBtYXR0ZXIgaWYgdGhlIGZsYWcgaXMgaWdub3Jl
ZC4NCkl0IGp1c3QgbWVhbnMgdGhlIGtlcm5lbCBpc24ndCBlbmZvcmNpbmcgdGhlIHBvbGljeS4N
CklmIG9wZW5hdDIoKSBmYWlsIGJlY2F1c2UgdGhlIGZsYWcgaXMgdW5zdXBwb3J0ZWQgdGhlbg0K
dGhlIGFwcGxpY2F0aW9uIHdpbGwgbmVlZCB0byByZXRyeSB3aXRob3V0IHRoZSBmbGFnLg0KDQpT
byBpZiB0aGUgdXNlciBoYXMgYW55IGFiaWxpdHkgY3JlYXRlIGV4ZWN1dGFibGUgZmlsZXMgdGhp
cw0KaXMgYWxsIHBvaW50bGVzcyAoZnJvbSBhIHNlY3VyaXR5IHBvaW50IG9mIHZpZXcpLg0KVGhl
IHVzZXIgY2FuIGVpdGhlciBjb3B5IHRoZSBmaWxlIG9yIGNvcHkgaW4gYW4gaW50ZXJwcmV0ZXIN
CnRoYXQgZG9lc24ndCByZXF1ZXN0IE9fTUFZRVhFQy4NCg0KSXQgbWlnaHQgc3RvcCBhY2NpZGVu
dGFsIGlzc3VlcywgYnV0IG5vdGhpbmcgbWFsaWNpb3VzLg0KDQo+ID4gVGhlbiBrZXJuZWwgcG9s
aWN5IGRldGVybWluZXMgd2hldGhlciAncmVhZCcgYWNjZXNzIGlzIGFjdHVhbGx5IGVub3VnaCwN
Cj4gPiBvciB3aGV0aGVyICd4JyBhY2Nlc3MgKHBvc3NpYmx5IG1hc2tlZCBieSBtb3VudCBwZXJt
aXNzaW9ucykgaXMgbmVlZGVkLg0KPiA+DQo+ID4gSWYgdGhhdCBpcyB0cnVlLCB0d28gbGluZXMg
c2F5IHdoYXQgaXMgZG9lcy4NCj4gDQo+IFRoZSAiQSBzaW1wbGUgc3lzdGVtLXdpZGUgc2VjdXJp
dHkgcG9saWN5IiBwYXJhZ3JhcGggaW50cm9kdWNlIHRoYXQsIGJ1dA0KPiBJJ2xsIGhpZ2hsaWdo
dCBpdCBpbiB0aGUgbmV4dCBjb3ZlciBsZXR0ZXIuDQoNCk5vIGl0IGRvZXNuJ3QuDQpJdCBqdXN0
IHNheXMgdGhlcmUgaXMgc29tZSBraW5kIG9mIHBvbGljeSB0aGF0IHNvbWUgZmxhZ3MgY2hhbmdl
Lg0KSXQgZG9lc24ndCBzYXkgd2hhdCBpcyBiZWluZyBjaGVja2VkIGZvci4NCg0KPiBUaGUgbW9z
dCBpbXBvcnRhbnQgcG9pbnQgaXMNCj4gdG8gdW5kZXJzdGFuZCB3aHkgaXQgaXMgcmVxdWlyZWQs
IGJlZm9yZSBnZXR0aW5nIHRvIGhvdyBpdCB3aWxsIGJlDQo+IGltcGxlbWVudGVkLg0KDQpCdXQg
eW91IGRvbid0IHNheSB3aGF0IGlzIHJlcXVpcmVkLg0KSnVzdCBhIGxvYWQgb2YgYnV6endvcmQg
cmFtYmxpbmdzLg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBC
cmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdp
c3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

