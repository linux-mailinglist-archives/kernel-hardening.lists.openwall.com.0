Return-Path: <kernel-hardening-return-16334-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id C1C2C5C9FF
	for <lists+kernel-hardening@lfdr.de>; Tue,  2 Jul 2019 09:35:49 +0200 (CEST)
Received: (qmail 3518 invoked by uid 550); 2 Jul 2019 07:35:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3486 invoked from network); 2 Jul 2019 07:35:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=UztNMccl0WiLmITcvK2m4vAhgC+1vUstbM1WMEPWXZM=;
        b=meDG9xOAU3+g3i2i7hBKLCpNjKknGMH89NlyjSmTOA8cBX87eUXanJCQdj92CexygH
         d5vX3Q0qoy9xNIEjE02vOtiR/M9Yy6oT6T1vYxhXIFxYKuHsuQsUd7Qt/3f5eGJq03MW
         RQvGz5KkTXKNwdhq2UKIZ7n5ZXaiJQDUDM7CAinfaUVoNmtc2795oRp+BbAr0nqoil6I
         I1HDXby54aujj6kqUCFe+iGVsaSjm6cUlWOwK+3LyHyN0beaCZA3AxjHQZ6dvjE7NtzA
         kMaVNS8RpP9WjY4ow1ulYChuE3Akre1znIEOQB2D7OCqJRW0ahpPA263ZvmTOOWAr/Kk
         7FEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=UztNMccl0WiLmITcvK2m4vAhgC+1vUstbM1WMEPWXZM=;
        b=VdmBKvI1z1+RauP+zP51M3meptLN3/+vRSdTFj4HE12hIh4iewIPzmUF6b4Z66zCqN
         Dx/2MBqMzScIvDv6YcEWLWN2/ZZyKyV+SYhJ5wYxA9ImF1MOAlhKDKjnIkvhPXgXJZ7k
         COIA9eaLCLoI+tSJqtHYxU+ox4TWgaFIQWU0nDpGujRzy9OiNhWU8aYWfvhwqIBuZeyS
         C/0SBNRvnv/eFfvnnt6hWVlneWRE2vG9Sj8Fi1K2G2d1GeapKTlh9OJ9Y2xzjr+wHEDY
         F2I8hKB/jaha8+m1gXLOr4fTKBpNKh/h+BvXRHZ2AqsN0zShLU3dteQZF4vD6IInI8/l
         hPRg==
X-Gm-Message-State: APjAAAXmuHy14Ix2xYfMCzmI4EXRgad60aciEdOszNPE7dE++oHTAEE8
	iiVIJ/l0S+e03z0KgkgPL0PchgVb56SSbyQIzOHBlg==
X-Google-Smtp-Source: APXvYqxNggjPTR/dpV08LVodMPTarUF/XZ3tnUqT/0MEb+NIT72CeeQS6oMgXdVykhFLGzVXipe3zaYooyNTkfupdK8=
X-Received: by 2002:a63:7a4f:: with SMTP id j15mr29845091pgn.427.1562052928920;
 Tue, 02 Jul 2019 00:35:28 -0700 (PDT)
MIME-Version: 1.0
From: Romain Perier <romain.perier@gmail.com>
Date: Tue, 2 Jul 2019 09:35:17 +0200
Message-ID: <CABgxDoJzu-Pfq78AYJmf61KqJ2A3YXNJ7jMSS6p3kCzhFox0=w@mail.gmail.com>
Subject: refactor tasklets to avoid unsigned long argument
To: Kernel Hardening <kernel-hardening@lists.openwall.com>, Kees Cook <keescook@chromium.org>, 
	Shyam Saini <mayhs11saini@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Hi,

I would be interested by this task (so I will mark it as "WIP" on the
wiki). I just need context :)

Thanks,
Regards,
Romain
