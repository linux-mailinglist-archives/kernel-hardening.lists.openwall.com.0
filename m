Return-Path: <kernel-hardening-return-17066-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 07754DE03B
	for <lists+kernel-hardening@lfdr.de>; Sun, 20 Oct 2019 21:31:19 +0200 (CEST)
Received: (qmail 25828 invoked by uid 550); 20 Oct 2019 19:31:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 25788 invoked from network); 20 Oct 2019 19:31:14 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=in-reply-to:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=MQO0yS1C5u3Vz5QrUXBas962jxMsl9zmhNl24X0oxMM=;
        b=UV8sNPMWYq/Fen3iyVbJHpCyPztiXQvnkHceWP5heWBbuE2SHe22tqem72u8LP9NFh
         aihLNvZwdp4WlO9v+qT2yyyxAZQyTfmfUFJROzQh3/abNYXfD94en2JnvKauxCLYtvZU
         +lxgmkjZiFi0ZTdM8bqFm7pboku3Ou7uLlIgECnjFUWqSXqMTsGb+D4bfakGrAdrwOxO
         BSMlipFEg5prKrFTp0mZOLW0Cx4k03wbpPfNx0KWhler4fGlp4/9o/8xd+of4uEOeV8x
         Y7R0mzwMn99M6ScHm5h4KnFwhE+JxYZdE52S+sIQ5vSeWF290SOIoLiVngwVt+fUUaRo
         wN8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:in-reply-to:to:cc:from:subject:message-id:date
         :user-agent:mime-version:content-transfer-encoding:content-language;
        bh=MQO0yS1C5u3Vz5QrUXBas962jxMsl9zmhNl24X0oxMM=;
        b=i9iWZHm2KsL3gknF6XFZIfw+3OIlG4wB0waSKUOGFkMbcaFZYAk/LQ2jprnVXzcvUs
         7f98XFsw1/tfeyLvWsJ7xr2tCKsLshNa1MaQ7lJngENtSw5+rvzAIZNZqfLORwP5JYit
         sTFGjAVbSEOM+yjInpLuiByCN4fc3VqvywK2TCP6Vz2ybcdmEShCMu4ZAfYKJA5UD3Zg
         W2JpwT2V+PHkizhHs12pZ1iunk4KoaZA3CRf/ol5UtHnpQ10zyo+zuVeJ/92cQtC5MGH
         v50PTBlGuglTu0QJkmuK/QaFW3VTvEvuc8Skn4ncM3822fs+thLsMUJf1YgW4gTrNyNV
         fnzQ==
X-Gm-Message-State: APjAAAUZxpJZm/jL5rzT51bY2mlYte0hgkMLPqfefpYjcjsiNno1gO6x
	hGKHSnP9TvkoU18bptJv7yg=
X-Google-Smtp-Source: APXvYqxPN12GTfsfpAmMwvB7wsk97LFP6T1Q0YYvoiFoxg4TkajeYyOhviR2UWcIo2uxpmfyTL+mww==
X-Received: by 2002:a17:902:6acb:: with SMTP id i11mr21520243plt.16.1571599862312;
        Sun, 20 Oct 2019 12:31:02 -0700 (PDT)
In-Reply-To:
To: keescook@chromium.org
Cc: kernel-hardening@lists.openwall.com, munisekharrms@gmail.com
From: youling257 <youling257@gmail.com>
Subject: Re: How to get the crash dump if system hangs?
Message-ID: <c4ef59df-2546-f548-a305-6b3e0e96a6b6@gmail.com>
Date: Mon, 21 Oct 2019 03:31:02 +0800
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US

I don't know my ramoops.mem_address, please help me.

what is ramoops.mem_address?

# cat /proc/iomem

00000000-00000fff : Reserved

00001000-0008efff : System RAM

0008f000-0008ffff : ACPI Non-volatile Storage

00090000-0009dfff : System RAM

0009e000-0009ffff : Reserved

000a0000-000bffff : PCI Bus 0000:00

000c0000-000dffff : PCI Bus 0000:00

000e0000-000fffff : PCI Bus 0000:00

   000f0000-000fffff : System ROM

00100000-1fffffff : System RAM

20000000-201fffff : Reserved

   20000000-201fffff : 80860F28:00

20200000-779c5fff : System RAM

   4c800000-4d401150 : Kernel code

   4d401151-4dd1fb3f : Kernel data

   4e212000-4e3fffff : Kernel bss

779c6000-77a12fff : Reserved

77a13000-77a1bfff : Unknown E820 type

77a1c000-77afffff : Reserved

77b00000-7bb6dfff : System RAM

7bb6e000-7bbcdfff : Unknown E820 type

7bbce000-7bdcdfff : Reserved

7bdce000-7bdcefff : System RAM

7bdcf000-7bdcffff : Reserved

7bdd0000-7bdd1fff : System RAM

7bdd2000-7bdd2fff : Reserved

7bdd3000-7c7fffff : System RAM

7c800000-7cbfffff : RAM buffer

7cc00000-7cc3afff : System RAM

7cc3b000-7cc47fff : Reserved

7cc48000-7ccb7fff : ACPI Non-volatile Storage

7ccb8000-7ccf7fff : ACPI Tables

7ccf8000-7ccfffff : System RAM

7cd00000-7cefffff : RAM buffer

7cf00000-7ef00000 : Reserved

   7cf00001-7ef00000 : PCI Bus 0000:00

     7cf00001-7eeffffe : Graphics Stolen Memory

7ef00001-7fefffff : RAM buffer

7ff00000-7ff00fff : MSFT0101:00

7ff01000-7fffffff : RAM buffer

80000000-90affffe : PCI Bus 0000:00

   80000000-8fffffff : 0000:00:02.0

   90000000-903fffff : 0000:00:02.0

     901e5000-901e5fff : hdmi-lpe-audio-mmio

   90400000-905fffff : dwc_usb3

     90400000-905fffff : 0000:00:16.0

       9040c100-905fffff : dwc3.3.auto

   90800000-908fffff : 0000:00:1a.0

   90900000-909fffff : 0000:00:1a.0

   90a00000-90a0ffff : 0000:00:14.0

     90a00000-90a0ffff : xhci-hcd

   90a2c000-90a2cfff : 0000:00:16.0

90b00000-90b00fff : 80860F28:00

90b01000-90b01fff : INT33BB:00

   90b01000-90b01fff : INT33BB:00

90b04000-90b07fff : INTL9C60:01

   90b04000-90b07fff : INTL9C60:01

90b08000-90b08fff : 80860F41:00

   90b08000-90b08fff : 80860F41:00

90b0a000-90b0afff : 80860F41:01

   90b0a000-90b0afff : 80860F41:01

90b0c000-90b0cfff : 80860F41:02

   90b0c000-90b0cfff : 80860F41:02

90b0e000-90b0efff : 80860F41:03

   90b0e000-90b0efff : 80860F41:03

90b10000-90b10fff : 80860F41:04

   90b10000-90b10fff : 80860F41:04

90b13000-90b13fff : 80860F09:00

   90b13000-90b13fff : 80860F09:00

90b14000-90b17fff : INTL9C60:00

   90b14000-90b17fff : INTL9C60:00

90b19000-90b19fff : 80860F0A:00

   90b19000-90b1901f : serial

90b1b000-90b1bfff : 80860F0A:01

   90b1b000-90b1b01f : serial

90b1d000-90b1dfff : 80860F14:02

   90b1d000-90b1dfff : 80860F14:02

90b1f000-90b1ffff : 80860F14:00

   90b1f000-90b1ffff : 80860F14:00

90c00000-90ffffff : PCI Bus 0000:00

91000000-911fffff : 80860F28:00

e00000d0-e00000db : INT33BD:00

e00f8000-e00f8fff : Reserved

fec00000-fec003ff : IOAPIC 0

fed00000-fed003ff : HPET 0

   fed00000-fed003ff : PNP0103:00

fed01000-fed01fff : Reserved

   fed01000-fed011ff : intel-spi

fed03008-fed0300c : iTCO_wdt.2.auto

fed05000-fed057ff : INT3401:00

fed0c000-fed0cfff : INT33FC:00

   fed0c000-fed0cfff : INT33FC:00

fed0d000-fed0dfff : INT33FC:01

   fed0d000-fed0dfff : INT33FC:01

fed0e000-fed0efff : INT33FC:02

   fed0e000-fed0efff : INT33FC:02

fed40000-fed40fff : PCI Bus 0000:00

fee00000-fee00fff : Local APIC

ff000000-ffffffff : INT0800:00

   ffd00000-ffffffff : Reserved

