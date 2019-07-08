Return-Path: <kernel-hardening-return-16381-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id DE5E761EA7
	for <lists+kernel-hardening@lfdr.de>; Mon,  8 Jul 2019 14:42:36 +0200 (CEST)
Received: (qmail 5776 invoked by uid 550); 8 Jul 2019 12:42:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 5736 invoked from network); 8 Jul 2019 12:42:29 -0000
From: David Laight <David.Laight@ACULAB.COM>
To: 'Salvatore Mesoraca' <s.mesoraca16@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "kernel-hardening@lists.openwall.com"
	<kernel-hardening@lists.openwall.com>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "linux-security-module@vger.kernel.org"
	<linux-security-module@vger.kernel.org>, Alexander Viro
	<viro@zeniv.linux.org.uk>, Brad Spengler <spender@grsecurity.net>, "Casey
 Schaufler" <casey@schaufler-ca.com>, Christoph Hellwig <hch@infradead.org>,
	James Morris <james.l.morris@oracle.com>, Jann Horn <jannh@google.com>, "Kees
 Cook" <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, "Serge E.
 Hallyn" <serge@hallyn.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: RE: [PATCH v5 06/12] S.A.R.A.: WX protection
Thread-Topic: [PATCH v5 06/12] S.A.R.A.: WX protection
Thread-Index: AQHVM+lhx/3G+gwH+UeGA1TJk0kwgabAq9yQ
Date: Mon, 8 Jul 2019 12:42:15 +0000
Message-ID: <b946dd861874401a910740a9adea8e8e@AcuMS.aculab.com>
References: <1562410493-8661-1-git-send-email-s.mesoraca16@gmail.com>
 <1562410493-8661-7-git-send-email-s.mesoraca16@gmail.com>
In-Reply-To: <1562410493-8661-7-git-send-email-s.mesoraca16@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: dcsia1rtNYyT8xw3SipVDQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

From: Salvatore Mesoraca
> Sent: 06 July 2019 11:55
...
> Executable MMAP prevention works by preventing any new executable
> allocation after the dynamic libraries have been loaded. It works under t=
he
> assumption that, when the dynamic libraries have been finished loading, t=
he
> RELRO section will be marked read only.

What about writing to the file of a dynamic library after it is loaded
but before it is faulted it (or after evicting it from the I$).

...
> +#define find_relro_section(ELFH, ELFP, FILE, RELRO, FOUND) do {=09=09\
> +=09unsigned long i;=09=09=09=09=09=09\
> +=09int _tmp;=09=09=09=09=09=09=09\
> +=09loff_t _pos =3D 0;=09=09=09=09=09=09\
> +=09if (ELFH.e_type =3D=3D ET_DYN || ELFH.e_type =3D=3D ET_EXEC) {=09=09\
> +=09=09for (i =3D 0; i < ELFH.e_phnum; ++i) {=09=09=09\
> +=09=09=09_pos =3D ELFH.e_phoff + i*sizeof(ELFP);=09=09\
> +=09=09=09_tmp =3D kernel_read(FILE, &ELFP, sizeof(ELFP),=09\
> +=09=09=09=09=09   &_pos);=09=09=09\
> +=09=09=09if (_tmp !=3D sizeof(ELFP))=09=09=09\
> +=09=09=09=09break;=09=09=09=09=09\
> +=09=09=09if (ELFP.p_type =3D=3D PT_GNU_RELRO) {=09=09\
> +=09=09=09=09RELRO =3D ELFP.p_offset >> PAGE_SHIFT;=09\
> +=09=09=09=09FOUND =3D true;=09=09=09=09\
> +=09=09=09=09break;=09=09=09=09=09\
> +=09=09=09}=09=09=09=09=09=09\
> +=09=09}=09=09=09=09=09=09=09\
> +=09}=09=09=09=09=09=09=09=09\
> +} while (0)

This is big for a #define.
Since it contains kernel_read() it can't really matter if it is
a real function.

=09David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1=
PT, UK
Registration No: 1397386 (Wales)

