Return-Path: <kernel-hardening-return-16022-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 4CF933117E
	for <lists+kernel-hardening@lfdr.de>; Fri, 31 May 2019 17:44:17 +0200 (CEST)
Received: (qmail 3258 invoked by uid 550); 31 May 2019 15:44:09 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3225 invoked from network); 31 May 2019 15:44:08 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KqQpbTTNWdRNfY3j8nXAkHwNJo0ff75+DoANQ/s2C+A=;
        b=qZiS7vzCiAXYDO/GG5SgIDdb6grJATphyYrGihtVgyIh7MHBD7U7Y7mohEZDYPBE6/
         8WF0I/oGmlsgBNEzMx4u80+s21VMHXtYUSUjzusx4WsO8Gqx8Mo4j4fSnThASQjvVSjs
         3IKeAzWCL4qtBx9uZA1zpEeLk9t/OlNed/AvS55hLs8MUfENPP+SR7yJ8EK4AedjHldy
         UgBg/+4ycSujyJC0iup4kbh8DwKOmT4ytj6xTZMD5CsdyiCTB5lm6FPUxe/AWAHGvwz5
         B01SpWC/fCKR4PMKOeQt7FS5RhdqIqOZSD/a2IvdEaoKYVJGCvU5W65VUOhUCO4dwB3M
         HpHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KqQpbTTNWdRNfY3j8nXAkHwNJo0ff75+DoANQ/s2C+A=;
        b=L72RriHgPsxw/gGd8XdXwQEn9XRP6VRlnyl/6T3T1fEj+s+q8/Kmtk27KA1VWkHQ4/
         N92mfquhcuYdAPZfQRbsWrIJjGM+Eag1PwKq7myuYlDB1egkw+57fFTCXkzi8tsSVj4W
         /Y+AF3U5pM6e4Uxx3zIEazGbKWFotFdpSK/jHJ5GXaMeHtXcuby59qpLMNRLv9+NLltf
         wdd4AkSinVXMjW0LTFi9/mSshi6UMTjkAm8fYUMDSW1Z96oLD3hcsc6/W+//zy2lA2jt
         fFm4zh5veMbILIlhY1RtsO/A76asZjj2l/eYLIOd0LLPeB9imcopTo6hi8u9IEVLoLpV
         Yisg==
X-Gm-Message-State: APjAAAWrurSC7bumrgpO8kMqrfwoCls3WsP1UMcnDgNc1oXbs6ac3dkE
	dDYFzJusmFXe/nZlOlLxNnmFmfm1NBZzoDNJ5fofIA==
X-Google-Smtp-Source: APXvYqxFIbglHlvq2/O20Vvzb6Kv58M+E4ONLVoUBlYpbZvVhoqCXOxVLPAWr4NBGeTXR2hR0MKtCPLN3lJtqKUvw78=
X-Received: by 2002:a02:70d6:: with SMTP id f205mr7248213jac.138.1559317436447;
 Fri, 31 May 2019 08:43:56 -0700 (PDT)
MIME-Version: 1.0
References: <20190530170033.GA5739@cisco> <CA+=Sn1kSg-Y8SseUWPTTJi5HRgYYxVtcDGUJvCcCYQQzKeiUQw@mail.gmail.com>
 <20190530192606.GB5739@cisco>
In-Reply-To: <20190530192606.GB5739@cisco>
From: Mark Brand <markbrand@google.com>
Date: Fri, 31 May 2019 17:43:44 +0200
Message-ID: <CAN+XpFRPnt7w5jkadD9ANHA2NTDnjOzjnPWDLY26wOq-jNAW-g@mail.gmail.com>
Subject: Re: unrecognizable insn generated in plugin?
To: Tycho Andersen <tycho@tycho.ws>
Cc: Andrew Pinski <pinskia@gmail.com>, GCC Mailing List <gcc@gcc.gnu.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000ec18b9058a30e170"

--000000000000ec18b9058a30e170
Content-Type: text/plain; charset="UTF-8"

On Thu, May 30, 2019 at 9:26 PM Tycho Andersen <tycho@tycho.ws> wrote:
>
> Hi Andrew,
>
> On Thu, May 30, 2019 at 10:09:44AM -0700, Andrew Pinski wrote:
> > On Thu, May 30, 2019 at 10:01 AM Tycho Andersen <tycho@tycho.ws> wrote:
> > >
> > > Hi all,
> > >
> > > I've been trying to implement an idea Andy suggested recently for
> > > preventing some kinds of ROP attacks. The discussion of the idea is
> > > here:
> > > https://lore.kernel.org/linux-mm/DFA69954-3F0F-4B79-A9B5-893D33D87E51@amacapital.net/
> > >


Hi Tycho,

I realise this is maybe not relevant to the topic of fixing the
plugin; but I'm struggling to understand what this is intending to
protect against.

The idea seems to be to make sure that restored rbp, rsp values are
"close" to the current rbp, rsp values? The only scenario I can see
this providing any benefit is if an attacker can only corrupt a saved
stack/frame pointer, which seems like such an unlikely situation that
it's not really worth adding any complexity to defend against.

An attacker who has control of rip can surely get a controlled value
into rsp in various ways; a quick scan of the current Ubuntu 18.04
kernel image offers the following sequence (which shows up
everywhere):

lea rsp, qword ptr [r10 - 8]
ret

I'd assume that it's not tremendously difficult for an attacker to
chain to this without needing to previously pivot out the stack
pointer, assuming that at the point at which they gain control of rip
they have control over some state somewhere. If you could explain the
exact attack scenario that you have in mind then perhaps I could
provide a better explanation of how one might bypass it.

Regards,
Mark

--000000000000ec18b9058a30e170
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIS7QYJKoZIhvcNAQcCoIIS3jCCEtoCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
ghBTMIIEXDCCA0SgAwIBAgIOSBtqDm4P/739RPqw/wcwDQYJKoZIhvcNAQELBQAwZDELMAkGA1UE
BhMCQkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYtc2ExOjA4BgNVBAMTMUdsb2JhbFNpZ24gUGVy
c29uYWxTaWduIFBhcnRuZXJzIENBIC0gU0hBMjU2IC0gRzIwHhcNMTYwNjE1MDAwMDAwWhcNMjEw
NjE1MDAwMDAwWjBMMQswCQYDVQQGEwJCRTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTEiMCAG
A1UEAxMZR2xvYmFsU2lnbiBIViBTL01JTUUgQ0EgMTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCC
AQoCggEBALR23lKtjlZW/17kthzYcMHHKFgywfc4vLIjfq42NmMWbXkNUabIgS8KX4PnIFsTlD6F
GO2fqnsTygvYPFBSMX4OCFtJXoikP2CQlEvO7WooyE94tqmqD+w0YtyP2IB5j4KvOIeNv1Gbnnes
BIUWLFxs1ERvYDhmk+OrvW7Vd8ZfpRJj71Rb+QQsUpkyTySaqALXnyztTDp1L5d1bABJN/bJbEU3
Hf5FLrANmognIu+Npty6GrA6p3yKELzTsilOFmYNWg7L838NS2JbFOndl+ce89gM36CW7vyhszi6
6LqqzJL8MsmkP53GGhf11YMP9EkmawYouMDP/PwQYhIiUO0CAwEAAaOCASIwggEeMA4GA1UdDwEB
/wQEAwIBBjAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwEgYDVR0TAQH/BAgwBgEB/wIB
ADAdBgNVHQ4EFgQUyzgSsMeZwHiSjLMhleb0JmLA4D8wHwYDVR0jBBgwFoAUJiSSix/TRK+xsBtt
r+500ox4AAMwSwYDVR0fBEQwQjBAoD6gPIY6aHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9ncy9n
c3BlcnNvbmFsc2lnbnB0bnJzc2hhMmcyLmNybDBMBgNVHSAERTBDMEEGCSsGAQQBoDIBKDA0MDIG
CCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzANBgkqhkiG
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
QAYIKwYBBQUHMAKGNGh0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzaHZzbWlt
ZWNhMS5jcnQwHQYDVR0OBBYEFMmmNA8o+g7Z9mSplZ2ZlZ3ktjVIMB8GA1UdIwQYMBaAFMs4ErDH
mcB4koyzIZXm9CZiwOA/MEwGA1UdIARFMEMwQQYJKwYBBAGgMgEoMDQwMgYIKwYBBQUHAgEWJmh0
dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMDsGA1UdHwQ0MDIwMKAuoCyGKmh0
dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3NodnNtaW1lY2ExLmNybDAOBgNVHQ8BAf8EBAMCBaAw
HQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMA0GCSqGSIb3DQEBCwUAA4IBAQBC86z9ZdOi
9uWAJJX6Ncjgl09HCPQyzL68RZUZFrBjg3DumxeZJexGUN9Ig/N1efcVulDPemWAwbMNAU2AtU85
IWC1syrCf/ghM7V9s5Up5+qC4GNayOy5ssU3nb5MCoUDfGdFxqHsIeevqqiWm+VYHBcd3r4FAmGS
NrSiRTmzbk4WGCrnfx82zrVJVXZogoMl2t++57cfXFEO90Oa2fkTxVpkBKgU02kHISGl3oYywljs
avEUGS9CQZ7ltEPlOChc61Ku3Z2CcSAerY7OBI51l4U322J9JfpOSObzG8CgZPeZPYrG1/tXEwwm
32LcmdRJWawUb9npagmgYymmS1CYMYICXjCCAloCAQEwXDBMMQswCQYDVQQGEwJCRTEZMBcGA1UE
ChMQR2xvYmFsU2lnbiBudi1zYTEiMCAGA1UEAxMZR2xvYmFsU2lnbiBIViBTL01JTUUgQ0EgMQIM
XWHyBA9I9vBnpY6lMA0GCWCGSAFlAwQCAQUAoIHUMC8GCSqGSIb3DQEJBDEiBCDkb2+2//OO7l9t
/PzZlCQdVqqjCl0G+5cZCQbSwg3sCzAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3
DQEJBTEPFw0xOTA1MzExNTQzNTZaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZIAWUDBAEqMAsGCWCG
SAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEKMAsGCSqGSIb3DQEB
BzALBglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAQLqDPcITt8Tw1HSv7VGcsLhs5IOLPOLP
Qv8XGgREYxyaVFGSxiKVT4OLqvyzUmyqjkYYeiBl4VlCNr0Ec4PTYYheKAKSYt7jA6Q6z/tNi4Eo
D3nMQXOyIgo88RMpbMbARMdabQqCxVsUwstMHKhMbebgUapxJ6LA834EeX73UspC/TdzsyWJJwy8
39/FsLonfFMnD0ZWrk+7N33wxVkeeNRc1/1+UpywXwDvoipfugBnxz+jWI+DY9URHief/W+gJgtb
3MK+Rg3o6tCmFEGy01OVSsVcOEsXLEnGkPfahvgYVsQuQNtIjNAeIWxy2jHLYvxR5Dk6PWcDHjYi
JcpYtQ==
--000000000000ec18b9058a30e170--
