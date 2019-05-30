Return-Path: <kernel-hardening-return-16016-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id F3977302BF
	for <lists+kernel-hardening@lfdr.de>; Thu, 30 May 2019 21:26:28 +0200 (CEST)
Received: (qmail 32093 invoked by uid 550); 30 May 2019 19:26:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 32035 invoked from network); 30 May 2019 19:26:21 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tycho-ws.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=ld021Nb83EedsfBvHDaS/qWbxrISVDgVM7XdWBjsW4s=;
        b=nW0OrGKfWB6W5o8uXqSS6goBGepIU2e2/FWPCmbuZ+bxZxmtjOvhLVgEQTvhQpomHx
         6neCAH6hj98trh5aYJYB01gqdoUe3Wgg5j6ly0Bo3N/yjjisB8I3f9E2B8c6uZxjpckY
         OL//uCnucEcxM7pCGeyqJHKal2i2oxWKI2i2whz8n5bHBYzVg0hs6JfSN/EKZGHkHe+x
         2Y9dTHQWEYCAOmHXBhfqGqVFLA6jEvxy4OIfoFmOrNioXvb0xTGyVlKknNVPNW8ZYIz8
         kcAzT+iayex5sISBF3WK8fbtNktlh0KyrAd08aCI5vH0ogCD4X1sETHb0pRDmflYVdY0
         5a9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=ld021Nb83EedsfBvHDaS/qWbxrISVDgVM7XdWBjsW4s=;
        b=rWGpjeg80X7qot1fc2JlJ12h4jyHZdQFQchQqAjjFLb0ZAInAI6QFBTp6X2pGLEOHv
         j/cyual0sh+tdXehcWO4SOTqoPb7FxovV16QoyKQqhweqxgBhEQd4gaBreNmKn+hQv6Z
         cg4KH9QAZBnArcRNlybllCpYVtJdRzxeg1uA9OPnYVHW9GlrJacrfECk/4l6C/N8jF+V
         MpA1IXCk2If10TCURwr8MiJwTUpe0neiKKyI1nhHBlQcA365m5isNB7JOnP/zvltiwWn
         u8IRVMDFAkSgSmUwYIZotinPe1sySqiSvljdMA61UrK1mnI6P6RN1u9BpOC+M1IMxkv9
         QQLA==
X-Gm-Message-State: APjAAAWoE5jDJlpZezhtBIe23rGELb5w2NIJmpNm27y+j8rlIPl5Sco4
	Ko00z9TcdqJW3H29fVQXJCeocw==
X-Google-Smtp-Source: APXvYqwEeEjv8iCPMQwLjTitE50ZD4RS67WqWe5jYAzAVo3FDBYC0Fqc4QA/zUvot/A8B/QAZKEFrg==
X-Received: by 2002:a0c:d604:: with SMTP id c4mr4974580qvj.27.1559244369391;
        Thu, 30 May 2019 12:26:09 -0700 (PDT)
Date: Thu, 30 May 2019 13:26:06 -0600
From: Tycho Andersen <tycho@tycho.ws>
To: Andrew Pinski <pinskia@gmail.com>
Cc: GCC Mailing List <gcc@gcc.gnu.org>, kernel-hardening@lists.openwall.com
Subject: Re: unrecognizable insn generated in plugin?
Message-ID: <20190530192606.GB5739@cisco>
References: <20190530170033.GA5739@cisco>
 <CA+=Sn1kSg-Y8SseUWPTTJi5HRgYYxVtcDGUJvCcCYQQzKeiUQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+=Sn1kSg-Y8SseUWPTTJi5HRgYYxVtcDGUJvCcCYQQzKeiUQw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Hi Andrew,

On Thu, May 30, 2019 at 10:09:44AM -0700, Andrew Pinski wrote:
> On Thu, May 30, 2019 at 10:01 AM Tycho Andersen <tycho@tycho.ws> wrote:
> >
> > Hi all,
> >
> > I've been trying to implement an idea Andy suggested recently for
> > preventing some kinds of ROP attacks. The discussion of the idea is
> > here:
> > https://lore.kernel.org/linux-mm/DFA69954-3F0F-4B79-A9B5-893D33D87E51@amacapital.net/
> >
> > Right now I'm struggling to get my plugin to compile without crashing. The
> > basic idea is to insert some code before every "pop rbp" and "pop rsp"; I've
> > figured out how to find these instructions, and I'm inserting code using:
> >
> > emit_insn(gen_rtx_XOR(DImode, gen_rtx_REG(DImode, HARD_FRAME_POINTER_REGNUM),
> >                       gen_rtx_MEM(DImode, gen_rtx_REG(DImode, HARD_FRAME_POINTER_REGNUM))));
> 
> Simplely this xor does not set anything.
> I think you want something like:
> emit_insn(gen_rtx_SET(gen_rtx_REG(DImode, HARD_FRAME_POINTER_REGNUM),
>   gen_rtx_XOR(DImode, gen_rtx_REG(DImode, HARD_FRAME_POINTER_REGNUM),
>       gen_rtx_MEM(DImode, gen_rtx_REG(DImode, HARD_FRAME_POINTER_REGNUM)))));
> 
> But that might not work either, you might need some thing more.

Yes, thanks. You're also right that I still see the same problem:

kernel/seccomp.c: In function ‘seccomp_check_filter’:
kernel/seccomp.c:242:1: error: unrecognizable insn:
 }
 ^
(insn 698 645 699 17 (set (reg:DI 6 bp)
        (xor:DI (reg:DI 6 bp)
            (mem:DI (reg:DI 6 bp) [0  S8 A8]))) "kernel/seccomp.c":242 -1
     (nil))
during RTL pass: shorten
kernel/seccomp.c:242:1: internal compiler error: in insn_min_length, at config/i386/i386.md:14714

Thanks,

Tycho
