Return-Path: <kernel-hardening-return-20607-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id EE22E2DA7F8
	for <lists+kernel-hardening@lfdr.de>; Tue, 15 Dec 2020 07:10:02 +0100 (CET)
Received: (qmail 30718 invoked by uid 550); 15 Dec 2020 06:09:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 30685 invoked from network); 15 Dec 2020 06:09:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qTC/ZFdBV4bfFnGdBAMxOiVS8IVB9B7BDasYdtfr3Kk=;
        b=Pe6FVTkSbDl3k1ES+hAL5ydvu6Fd6KWauGwno8sPnJm6uCYVkoVoayxm5VCvNan2Bh
         a7Kf+q5YLohn1ptNHBk0G+9elIzHtHgQ1/l03bFbhI8ae6obbdebOC4hbn/iaU8rszg0
         u9YlDBPaxWMiMmZRaXpKRdOFE9PnJF360OCsShddqZR+KRZ2WKfUcpWnB0R0lt3q8d7d
         F5X1+DY78eMpdrRs9e94ShYE8QNy5VGsKIql+eABk/KsSfjN0joKxZ3bYxGRLUad30Jg
         7frXmqhjXsdfTP9WQs6OJAO8Y6s/1n0jDS94817VsOId2yYJSSgOBoPqWzKZRG8TI4Vo
         7Ieg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qTC/ZFdBV4bfFnGdBAMxOiVS8IVB9B7BDasYdtfr3Kk=;
        b=VlBl1uVLx3I70o9GYX7Uev+tpMMMp69jiNqX4W2x4DUHWAm8kKMgM/f1Pzm5y0lI6g
         uXl3w4SLxx0rKxmtlw4D1jfd1qIdPDPCEPk16q2KiZcUl7Z8Aqo4S3Mqd0HSKYaSvKWX
         NqX43lbG6ep1ANtEzIP8/sxMzfdOzUiLHlmOwrmRWB/LBi2UQn2ZSnWTHGVRm6vWCq/q
         z2QJt252q6uhjO+8Mw3A0TO29GKKKgi9krSoaAtZVtTCkhmVDPHyRgH6v6Nhr3haZYLO
         r7kOkRP5vlq903R3jI/bh6hvWjWjV7duLSGqRQNwUEs9YFbg229S1S2KGwAmDPC5trFL
         AGQg==
X-Gm-Message-State: AOAM530OYUmaizh70RooyCkXVni242kq8F2J8KzDgQAGNLrt+FnqUAE/
	54DRwKVwTn9TUWb/3azmfjH98PVq1GHCnmqU75k=
X-Google-Smtp-Source: ABdhPJwGbzWHZ05gHw1j32jLgtdFdWbst+7Qdh9hLzKs+B2cmL1gz9UqDF0J2hkj9RmcUASDgSduK19wiId5c5MrGXw=
X-Received: by 2002:a1c:c305:: with SMTP id t5mr31602285wmf.63.1608012582793;
 Mon, 14 Dec 2020 22:09:42 -0800 (PST)
MIME-Version: 1.0
References: <X9UjVOuTgwuQwfFk@mailbox.org>
In-Reply-To: <X9UjVOuTgwuQwfFk@mailbox.org>
From: Sandy Harris <sandyinchina@gmail.com>
Date: Tue, 15 Dec 2020 14:09:30 +0800
Message-ID: <CACXcFmnrQmQO38yBXh25eD9QgtvjKHTg=oCtJm8Kq6coK+WspA@mail.gmail.com>
Subject: Re: Kernel complexity
To: stefan.bavendiek@mailbox.org
Cc: kernel-hardening@lists.openwall.com, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> I am currently doing a research project that aims to identify risk areas in the kernel by measuring code complexity metrics ...

Another aspect of complexity that might be worth a look is
modularisation, interface definitions for kernel components, etc. One
classic paper is "Ifdef Considered Harmful".
https://www.usenix.org/legacy/publications/library/proceedings/sa92/spencer.pdf
