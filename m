Return-Path: <kernel-hardening-return-18727-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 9C1531C6F1C
	for <lists+kernel-hardening@lfdr.de>; Wed,  6 May 2020 13:19:39 +0200 (CEST)
Received: (qmail 17834 invoked by uid 550); 6 May 2020 11:19:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 17802 invoked from network); 6 May 2020 11:19:31 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=uS7BPtWwSRd5nNIMbQduL14pkjtbqWTQ/9jHoj36JYA=;
        b=SiSRZCAWzVk7eAn3Flmf03l9e3rbczTeI8DEI3Axwpr2AXNVmmpsi7D+5s/rHO0Y2d
         SRifqeLKx7gZqe/1QJDvqIZSfxVZcxm/FsB0qVE3E5G9yIhHvk4CrDGLEVsUvNan1vKE
         lBLRSliA4JTE1TV7tS7e4B0bo8jfR4NXS/MUsJkT+aj2h+ZQFoGWclwHdfPP1VziN1LJ
         7vVoQ/sVQOS7H98mNmoQWvOBaTA7z1hsWNrCrWNwdVKLA/FACRi5lOrXleqMxKnDUPvy
         Krcs/pmvAixTzNbrgQo4oWusqhSymFsv7XBgJP7COAYqajwbAB1TKpbh37P91ew/p4F5
         qAMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=uS7BPtWwSRd5nNIMbQduL14pkjtbqWTQ/9jHoj36JYA=;
        b=BIfbd3oqa2wgT1q0Uz2qlqO7jOTqB2glnVz+v4ZZ/0VzAI6BJdFGTEJodJudqEYIZb
         IUkoNmebGiCe+GpyhEDE9hSpFBzKPParIC3MbYjWqTkBE230zSSdQosATBLTF9UYBx7l
         12bdqAj6MIakLwP2dJ2bo2Xa0avCCbnlvhOXv42m2dZliQ3zgGJE3pCx/jwNY40EVq2v
         hw/yu8u7yJqLGWIrknoAmbOOuPdWGuQTxz/VPUsKZbqn8cwcv4vS59MtpTdzM6qu+X92
         Xm/bJDCczj0Vx7/tRJ0poIjNkQ8Gt1WtotzaFrVcmFJnfdVUDA6Zh8wLUV/Jj9P44Sz5
         qptA==
X-Gm-Message-State: AGi0Pub00C6c6jNmq+5NH5F0scRDim1AFcdSD768QSlIkdDGoZtk2RHh
	Jk8PEFgrTEOByHZqG6NYX3KGlHA4nR4NbOwZiTMOoRHbr38=
X-Google-Smtp-Source: APiQypJsIz2fNORCmXsSFKTgdko7Edxy2g+LikBcMcnqXY38eT+5hiPUxIibNKEQTrQj3a0bsiTYKo3OOhk24gwxILs=
X-Received: by 2002:a37:4b0c:: with SMTP id y12mr7874336qka.43.1588763959572;
 Wed, 06 May 2020 04:19:19 -0700 (PDT)
MIME-Version: 1.0
From: Dmitry Vyukov <dvyukov@google.com>
Date: Wed, 6 May 2020 13:19:08 +0200
Message-ID: <CACT4Y+YpNSK6-uLv5dLDNjgFzxgAtu-7uN9eC_H-BND7X9zzug@mail.gmail.com>
Subject: FYI: NGI POINTER OSS Funding
To: syzkaller <syzkaller@googlegroups.com>, 
	syzkaller-bugs <syzkaller-bugs@googlegroups.com>, kernel-hardening@lists.openwall.com
Content-Type: text/plain; charset="UTF-8"

Hi kernel-hardening/syzkaller crowd,

I wanted to forward to you as FYI info re NGI POINTER: Funding The
Next Generation Ecosystem of Internet Architects program:
https://ngi-pointer.fundingbox.com
The program aims at funding development of Internet infrastructure,
including "Industrial Internet Security" in particular. I would assume
any work on security of the Linux kernel should fully qualify as Linux
is at the very heart of the Internet. In particular KSPP project:
https://kernsec.org/wiki/index.php/Kernel_Self_Protection_Project/Work
and/or fixing upstream kernel bugs and/or improving fuzzing coverage:
https://syzkaller.appspot.com/upstream
https://github.com/google/syzkaller/issues

Just to clarify, I am not affiliated with the program, nor proxying
requests. If you are interested, you may find contact info on the
site. But I would like to hear about applications and I can provide
some "justification data" :)
https://events19.linuxfoundation.org/wp-content/uploads/2017/11/Syzbot-and-the-Tale-of-Thousand-Kernel-Bugs-Dmitry-Vyukov-Google.pdf

Thanks
