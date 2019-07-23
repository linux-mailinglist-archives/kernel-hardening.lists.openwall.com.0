Return-Path: <kernel-hardening-return-16545-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 78F9971156
	for <lists+kernel-hardening@lfdr.de>; Tue, 23 Jul 2019 07:46:24 +0200 (CEST)
Received: (qmail 24309 invoked by uid 550); 23 Jul 2019 05:44:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 24243 invoked from network); 23 Jul 2019 05:44:51 -0000
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,297,1559545200"; 
   d="scan'208";a="163392678"
From: "Gote, Nitin R" <nitin.r.gote@intel.com>
To: Ondrej Mosnacek <omosnace@redhat.com>
CC: Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com"
	<kernel-hardening@lists.openwall.com>, Paul Moore <paul@paul-moore.com>,
	Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>,
	SElinux list <selinux@vger.kernel.org>, Linux kernel mailing list
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] selinux: convert struct sidtab count to refcount_t
Thread-Topic: [PATCH] selinux: convert struct sidtab count to refcount_t
Thread-Index: AQHVQIGaAIpBwRsLTUq40fonHwZflqbWQoqAgAFqC9A=
Date: Tue, 23 Jul 2019 05:44:30 +0000
Message-ID: <12356C813DFF6F479B608F81178A561587AAD1@BGSMSX101.gar.corp.intel.com>
References: <20190722113151.1584-1-nitin.r.gote@intel.com>
 <CAFqZXNs5vdQwoy2k=_XLiGRdyZCL=n8as6aL01Dw-U62amFREA@mail.gmail.com>
In-Reply-To: <CAFqZXNs5vdQwoy2k=_XLiGRdyZCL=n8as6aL01Dw-U62amFREA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMjRmYTYxNzItYTgyYS00ZWY0LTlmNDEtN2Q3MWMxMzk3ZmQ2IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiUXR5T2NaYVliaVlzMG9aZ2tIQTBWbkNjOWpRR1ZXS1BiQnZLNWlCMmxVaEJHelhNdWFIS2UxdFwvTXI5T3M5WXMifQ==
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogT25kcmVqIE1vc25hY2Vr
IFttYWlsdG86b21vc25hY2VAcmVkaGF0LmNvbV0NCj4gU2VudDogTW9uZGF5LCBKdWx5IDIyLCAy
MDE5IDY6NDggUE0NCj4gVG86IEdvdGUsIE5pdGluIFIgPG5pdGluLnIuZ290ZUBpbnRlbC5jb20+
DQo+IENjOiBLZWVzIENvb2sgPGtlZXNjb29rQGNocm9taXVtLm9yZz47IGtlcm5lbC0NCj4gaGFy
ZGVuaW5nQGxpc3RzLm9wZW53YWxsLmNvbTsgUGF1bCBNb29yZSA8cGF1bEBwYXVsLW1vb3JlLmNv
bT47DQo+IFN0ZXBoZW4gU21hbGxleSA8c2RzQHR5Y2hvLm5zYS5nb3Y+OyBFcmljIFBhcmlzIDxl
cGFyaXNAcGFyaXNwbGFjZS5vcmc+Ow0KPiBTRWxpbnV4IGxpc3QgPHNlbGludXhAdmdlci5rZXJu
ZWwub3JnPjsgTGludXgga2VybmVsIG1haWxpbmcgbGlzdCA8bGludXgtDQo+IGtlcm5lbEB2Z2Vy
Lmtlcm5lbC5vcmc+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0hdIHNlbGludXg6IGNvbnZlcnQgc3Ry
dWN0IHNpZHRhYiBjb3VudCB0byByZWZjb3VudF90DQo+IA0KPiBPbiBNb24sIEp1bCAyMiwgMjAx
OSBhdCAxOjM1IFBNIE5pdGluR290ZSA8bml0aW4uci5nb3RlQGludGVsLmNvbT4gd3JvdGU6DQo+
ID4gcmVmY291bnRfdCB0eXBlIGFuZCBjb3JyZXNwb25kaW5nIEFQSSBzaG91bGQgYmUgdXNlZCBp
bnN0ZWFkIG9mDQo+ID4gYXRvbWljX3Qgd2hlbiB0aGUgdmFyaWFibGUgaXMgdXNlZCBhcyBhIHJl
ZmVyZW5jZSBjb3VudGVyLiBUaGlzIGFsbG93cw0KPiA+IHRvIGF2b2lkIGFjY2lkZW50YWwgcmVm
Y291bnRlciBvdmVyZmxvd3MgdGhhdCBtaWdodCBsZWFkIHRvDQo+ID4gdXNlLWFmdGVyLWZyZWUg
c2l0dWF0aW9ucy4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IE5pdGluR290ZSA8bml0aW4uci5n
b3RlQGludGVsLmNvbT4NCj4gDQo+IE5hY2suDQo+IA0KPiBUaGUgJ2NvdW50JyB2YXJpYWJsZSBp
cyBub3QgdXNlZCBhcyBhIHJlZmVyZW5jZSBjb3VudGVyIGhlcmUuIEl0IHRyYWNrcyB0aGUNCj4g
bnVtYmVyIG9mIGVudHJpZXMgaW4gc2lkdGFiLCB3aGljaCBpcyBhIHZlcnkgc3BlY2lmaWMgbG9v
a3VwIHRhYmxlIHRoYXQgY2FuDQo+IG9ubHkgZ3JvdyAodGhlIGNvdW50IG5ldmVyIGRlY3JlYXNl
cykuIEkgb25seSBtYWRlIGl0IGF0b21pYyBiZWNhdXNlIHRoZQ0KPiB2YXJpYWJsZSBpcyByZWFk
IG91dHNpZGUgb2YgdGhlIHNpZHRhYidzIHNwaW4gbG9jayBhbmQgdGh1cyB0aGUgcmVhZHMgYW5k
DQo+IHdyaXRlcyB0byBpdCBuZWVkIHRvIGJlIGd1YXJhbnRlZWQgdG8gYmUgYXRvbWljLiBUaGUg
Y291bnRlciBpcyBvbmx5IHVwZGF0ZWQNCj4gdW5kZXIgdGhlIHNwaW4gbG9jaywgc28gaW5zZXJ0
aW9ucyBkbyBub3QgcmFjZSB3aXRoIGVhY2ggb3RoZXIuDQoNCkFncmVlZC4gVGhhbmtzIGZvciBj
bGFyaWZpY2F0aW9uLiANCkknbSBnb2luZyB0byBkaXNjb250aW51ZSB0aGlzIHBhdGNoLg0KDQo+
IA0KPiBZb3VyIHBhdGNoLCBob3dldmVyLCBsZWFkIG1lIHRvIHJlYWxpemUgdGhhdCBJIGZvcmdv
dCB0byBndWFyZCBhZ2FpbnN0DQo+IG92ZXJmbG93IGFib3ZlIFNJRFRBQl9NQVggd2hlbiBhIG5l
dyBlbnRyeSBpcyBiZWluZyBpbnNlcnRlZC4gSXQgaXMNCj4gZXh0cmVtZWx5IHVubGlrZWx5IHRv
IGhhcHBlbiBpbiBwcmFjdGljZSwgYnV0IHNob3VsZCBiZSBmaXhlZCBhbnl3YXkuDQo+IEknbGwg
c2VuZCBhIHBhdGNoIHNob3J0bHkuDQo+IA0KDQpUaGFuayB5b3UuDQoNCj4gPiAtLS0NCj4gPiAg
c2VjdXJpdHkvc2VsaW51eC9zcy9zaWR0YWIuYyB8IDE2ICsrKysrKysrLS0tLS0tLS0NCj4gPiBz
ZWN1cml0eS9zZWxpbnV4L3NzL3NpZHRhYi5oIHwgIDIgKy0NCj4gPiAgMiBmaWxlcyBjaGFuZ2Vk
LCA5IGluc2VydGlvbnMoKyksIDkgZGVsZXRpb25zKC0pDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEv
c2VjdXJpdHkvc2VsaW51eC9zcy9zaWR0YWIuYw0KPiA+IGIvc2VjdXJpdHkvc2VsaW51eC9zcy9z
aWR0YWIuYyBpbmRleCBlNjNhOTBmZjI3MjguLjIwZmUyMzVjNmM3MSAxMDA2NDQNCj4gPiAtLS0g
YS9zZWN1cml0eS9zZWxpbnV4L3NzL3NpZHRhYi5jDQo+ID4gKysrIGIvc2VjdXJpdHkvc2VsaW51
eC9zcy9zaWR0YWIuYw0KPiA+IEBAIC0yOSw3ICsyOSw3IEBAIGludCBzaWR0YWJfaW5pdChzdHJ1
Y3Qgc2lkdGFiICpzKQ0KPiA+ICAgICAgICAgZm9yIChpID0gMDsgaSA8IFNFQ0lOSVRTSURfTlVN
OyBpKyspDQo+ID4gICAgICAgICAgICAgICAgIHMtPmlzaWRzW2ldLnNldCA9IDA7DQo+ID4NCj4g
PiAtICAgICAgIGF0b21pY19zZXQoJnMtPmNvdW50LCAwKTsNCj4gPiArICAgICAgIHJlZmNvdW50
X3NldCgmcy0+Y291bnQsIDApOw0KPiA+DQo+ID4gICAgICAgICBzLT5jb252ZXJ0ID0gTlVMTDsN
Cj4gPg0KPiA+IEBAIC0xMzAsNyArMTMwLDcgQEAgc3RhdGljIHN0cnVjdCBjb250ZXh0ICpzaWR0
YWJfZG9fbG9va3VwKHN0cnVjdA0KPiA+IHNpZHRhYiAqcywgdTMyIGluZGV4LCBpbnQgYWxsb2Mp
DQo+ID4NCj4gPiAgc3RhdGljIHN0cnVjdCBjb250ZXh0ICpzaWR0YWJfbG9va3VwKHN0cnVjdCBz
aWR0YWIgKnMsIHUzMiBpbmRleCkgIHsNCj4gPiAtICAgICAgIHUzMiBjb3VudCA9ICh1MzIpYXRv
bWljX3JlYWQoJnMtPmNvdW50KTsNCj4gPiArICAgICAgIHUzMiBjb3VudCA9IHJlZmNvdW50X3Jl
YWQoJnMtPmNvdW50KTsNCj4gPg0KPiA+ICAgICAgICAgaWYgKGluZGV4ID49IGNvdW50KQ0KPiA+
ICAgICAgICAgICAgICAgICByZXR1cm4gTlVMTDsNCj4gPiBAQCAtMjQ1LDcgKzI0NSw3IEBAIHN0
YXRpYyBpbnQgc2lkdGFiX3JldmVyc2VfbG9va3VwKHN0cnVjdCBzaWR0YWIgKnMsDQo+IHN0cnVj
dCBjb250ZXh0ICpjb250ZXh0LA0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IHUzMiAqaW5kZXgpDQo+ID4gIHsNCj4gPiAgICAgICAgIHVuc2lnbmVkIGxvbmcgZmxhZ3M7DQo+
ID4gLSAgICAgICB1MzIgY291bnQgPSAodTMyKWF0b21pY19yZWFkKCZzLT5jb3VudCk7DQo+ID4g
KyAgICAgICB1MzIgY291bnQgPSAodTMyKXJlZmNvdW50X3JlYWQoJnMtPmNvdW50KTsNCj4gPiAg
ICAgICAgIHUzMiBjb3VudF9sb2NrZWQsIGxldmVsLCBwb3M7DQo+ID4gICAgICAgICBzdHJ1Y3Qg
c2lkdGFiX2NvbnZlcnRfcGFyYW1zICpjb252ZXJ0Ow0KPiA+ICAgICAgICAgc3RydWN0IGNvbnRl
eHQgKmRzdCwgKmRzdF9jb252ZXJ0Ow0KPiA+IEBAIC0yNzIsNyArMjcyLDcgQEAgc3RhdGljIGlu
dCBzaWR0YWJfcmV2ZXJzZV9sb29rdXAoc3RydWN0IHNpZHRhYiAqcywNCj4gc3RydWN0IGNvbnRl
eHQgKmNvbnRleHQsDQo+ID4gICAgICAgICBzcGluX2xvY2tfaXJxc2F2ZSgmcy0+bG9jaywgZmxh
Z3MpOw0KPiA+DQo+ID4gICAgICAgICBjb252ZXJ0ID0gcy0+Y29udmVydDsNCj4gPiAtICAgICAg
IGNvdW50X2xvY2tlZCA9ICh1MzIpYXRvbWljX3JlYWQoJnMtPmNvdW50KTsNCj4gPiArICAgICAg
IGNvdW50X2xvY2tlZCA9ICh1MzIpcmVmY291bnRfcmVhZCgmcy0+Y291bnQpOw0KPiA+ICAgICAg
ICAgbGV2ZWwgPSBzaWR0YWJfbGV2ZWxfZnJvbV9jb3VudChjb3VudF9sb2NrZWQpOw0KPiA+DQo+
ID4gICAgICAgICAvKiBpZiBjb3VudCBoYXMgY2hhbmdlZCBiZWZvcmUgd2UgYWNxdWlyZWQgdGhl
IGxvY2ssIHRoZW4gY2F0Y2ggdXAgKi8NCj4gPiBAQCAtMzE1LDcgKzMxNSw3IEBAIHN0YXRpYyBp
bnQgc2lkdGFiX3JldmVyc2VfbG9va3VwKHN0cnVjdCBzaWR0YWIgKnMsDQo+IHN0cnVjdCBjb250
ZXh0ICpjb250ZXh0LA0KPiA+ICAgICAgICAgICAgICAgICB9DQo+ID4NCj4gPiAgICAgICAgICAg
ICAgICAgLyogYXQgdGhpcyBwb2ludCB3ZSBrbm93IHRoZSBpbnNlcnQgd29uJ3QgZmFpbCAqLw0K
PiA+IC0gICAgICAgICAgICAgICBhdG9taWNfc2V0KCZjb252ZXJ0LT50YXJnZXQtPmNvdW50LCBj
b3VudCArIDEpOw0KPiA+ICsgICAgICAgICAgICAgICByZWZjb3VudF9zZXQoJmNvbnZlcnQtPnRh
cmdldC0+Y291bnQsIGNvdW50ICsgMSk7DQo+ID4gICAgICAgICB9DQo+ID4NCj4gPiAgICAgICAg
IGlmIChjb250ZXh0LT5sZW4pDQo+ID4gQEAgLTMyOCw3ICszMjgsNyBAQCBzdGF0aWMgaW50IHNp
ZHRhYl9yZXZlcnNlX2xvb2t1cChzdHJ1Y3Qgc2lkdGFiICpzLA0KPiBzdHJ1Y3QgY29udGV4dCAq
Y29udGV4dCwNCj4gPiAgICAgICAgIC8qIHdyaXRlIGVudHJpZXMgYmVmb3JlIHdyaXRpbmcgbmV3
IGNvdW50ICovDQo+ID4gICAgICAgICBzbXBfd21iKCk7DQo+ID4NCj4gPiAtICAgICAgIGF0b21p
Y19zZXQoJnMtPmNvdW50LCBjb3VudCArIDEpOw0KPiA+ICsgICAgICAgcmVmY291bnRfc2V0KCZz
LT5jb3VudCwgY291bnQgKyAxKTsNCj4gPg0KPiA+ICAgICAgICAgcmMgPSAwOw0KPiA+ICBvdXRf
dW5sb2NrOg0KPiA+IEBAIC00MTgsNyArNDE4LDcgQEAgaW50IHNpZHRhYl9jb252ZXJ0KHN0cnVj
dCBzaWR0YWIgKnMsIHN0cnVjdA0KPiBzaWR0YWJfY29udmVydF9wYXJhbXMgKnBhcmFtcykNCj4g
PiAgICAgICAgICAgICAgICAgcmV0dXJuIC1FQlVTWTsNCj4gPiAgICAgICAgIH0NCj4gPg0KPiA+
IC0gICAgICAgY291bnQgPSAodTMyKWF0b21pY19yZWFkKCZzLT5jb3VudCk7DQo+ID4gKyAgICAg
ICBjb3VudCA9ICh1MzIpcmVmY291bnRfcmVhZCgmcy0+Y291bnQpOw0KPiA+ICAgICAgICAgbGV2
ZWwgPSBzaWR0YWJfbGV2ZWxfZnJvbV9jb3VudChjb3VudCk7DQo+ID4NCj4gPiAgICAgICAgIC8q
IGFsbG9jYXRlIGxhc3QgbGVhZiBpbiB0aGUgbmV3IHNpZHRhYiAodG8gYXZvaWQgcmFjZSB3aXRo
DQo+ID4gQEAgLTQzMSw3ICs0MzEsNyBAQCBpbnQgc2lkdGFiX2NvbnZlcnQoc3RydWN0IHNpZHRh
YiAqcywgc3RydWN0DQo+IHNpZHRhYl9jb252ZXJ0X3BhcmFtcyAqcGFyYW1zKQ0KPiA+ICAgICAg
ICAgfQ0KPiA+DQo+ID4gICAgICAgICAvKiBzZXQgY291bnQgaW4gY2FzZSBubyBuZXcgZW50cmll
cyBhcmUgYWRkZWQgZHVyaW5nIGNvbnZlcnNpb24gKi8NCj4gPiAtICAgICAgIGF0b21pY19zZXQo
JnBhcmFtcy0+dGFyZ2V0LT5jb3VudCwgY291bnQpOw0KPiA+ICsgICAgICAgcmVmY291bnRfc2V0
KCZwYXJhbXMtPnRhcmdldC0+Y291bnQsIGNvdW50KTsNCj4gPg0KPiA+ICAgICAgICAgLyogZW5h
YmxlIGxpdmUgY29udmVydCBvZiBuZXcgZW50cmllcyAqLw0KPiA+ICAgICAgICAgcy0+Y29udmVy
dCA9IHBhcmFtczsNCj4gPiBkaWZmIC0tZ2l0IGEvc2VjdXJpdHkvc2VsaW51eC9zcy9zaWR0YWIu
aCBiL3NlY3VyaXR5L3NlbGludXgvc3Mvc2lkdGFiLmgNCj4gPiBpbmRleCBiYmQ1YzBkMWYzYmQu
LjY4ZGQ5NmE1YmViYSAxMDA2NDQNCj4gPiAtLS0gYS9zZWN1cml0eS9zZWxpbnV4L3NzL3NpZHRh
Yi5oDQo+ID4gKysrIGIvc2VjdXJpdHkvc2VsaW51eC9zcy9zaWR0YWIuaA0KPiA+IEBAIC03MCw3
ICs3MCw3IEBAIHN0cnVjdCBzaWR0YWJfY29udmVydF9wYXJhbXMgew0KPiA+DQo+ID4gIHN0cnVj
dCBzaWR0YWIgew0KPiA+ICAgICAgICAgdW5pb24gc2lkdGFiX2VudHJ5X2lubmVyIHJvb3RzW1NJ
RFRBQl9NQVhfTEVWRUwgKyAxXTsNCj4gPiAtICAgICAgIGF0b21pY190IGNvdW50Ow0KPiA+ICsg
ICAgICAgcmVmY291bnRfdCBjb3VudDsNCj4gPiAgICAgICAgIHN0cnVjdCBzaWR0YWJfY29udmVy
dF9wYXJhbXMgKmNvbnZlcnQ7DQo+ID4gICAgICAgICBzcGlubG9ja190IGxvY2s7DQo+ID4NCj4g
PiAtLQ0KPiA+IDIuMTcuMQ0KPiA+DQo+IA0KPiBUaGFua3MsDQo+IA0KPiAtLQ0KPiBPbmRyZWog
TW9zbmFjZWsgPG9tb3NuYWNlIGF0IHJlZGhhdCBkb3QgY29tPg0KPiBTb2Z0d2FyZSBFbmdpbmVl
ciwgU2VjdXJpdHkgVGVjaG5vbG9naWVzDQo+IFJlZCBIYXQsIEluYy4NCg==
