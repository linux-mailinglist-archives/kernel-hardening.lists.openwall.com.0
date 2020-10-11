Return-Path: <kernel-hardening-return-20167-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 64CD228A5E4
	for <lists+kernel-hardening@lfdr.de>; Sun, 11 Oct 2020 08:24:51 +0200 (CEST)
Received: (qmail 1186 invoked by uid 550); 11 Oct 2020 06:24:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1150 invoked from network); 11 Oct 2020 06:24:43 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=zegky+Rq+o8gqkwuaNNc9MiixR/91JzID9lMBKd1E5s=;
        b=aB8IV3i4HHkN71iTTI+J+tAUbGO1LD90ziI/GL8uL5f/CUb+vIEcygS4ZSpFNDxxLU
         bRz/2mB5lSTU58Q/7Pb+vQ5St5mgdbeYIEqiyMflXkZ4jL8L1SIwDnn3EPgRQZMOoodW
         xNsNlviqL59n7xsrs0aGZ8nJ9BhMPznWA5GLKMKYdRTx1KGzEM/CDy/33dkD3vhPGBUS
         FmN85V6nALARET4OzoM2pODNLMTqGtPtQgnCZ7/uOOLaPLMRWr/QMEdJzzfZLBlcqaBB
         KLffgvc1O2xOFhM/ZlbGuT46Cx68h1oKRRV6We7boZO6YVEzQ3RUFe51ddusyCF0dbJ8
         /mIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=zegky+Rq+o8gqkwuaNNc9MiixR/91JzID9lMBKd1E5s=;
        b=mtXaGh42M1KfIQ0379bs6nFNxWffzIVSbJZec7ur3+lMddewF5NYsNuByia4PuWctd
         ak95adV+r/llQfSvy2Aq9sHbsExENQ5LXWLJovl/uNXyo9YGqDG9f+zfe9oqc0m6Il5r
         7vg/gsptZrod+3LEj77MahrEiEemvjiKlTQ80lv/2HT7M4jm+5IeXkrz9K4v2hKUbcjq
         qJFr/YisGbo+RYYqSsFiSEeS209XN9lqFuJco8ceelUNG4NN/ldGfb/yqnsdijgG7xuA
         2c6uUJ8ASWLK/+j8cCGYhB7L3Lfunn12EabWDLzDgABmqpAeHhbNmzLLpOEc+tx0G3UQ
         Bn0A==
X-Gm-Message-State: AOAM5309h19D6/DqPTvoX0POVOGBkyn5srZBHd/UCFDp4xEGC96vFChJ
	QnPyID2KMSl1N8fMhhlGuMb3obUYcdIXlmkFe8l+iwez
X-Google-Smtp-Source: ABdhPJyoSbN1t4Q1CYhG55OkCaU7g9hrVFtDI1oryQTfJJUqf3+5mqjKhIIJJ0YDgnhWaend7zrJ5HwYVEHBq/hli6Y=
X-Received: by 2002:a02:1cc1:: with SMTP id c184mr15696179jac.29.1602397470349;
 Sat, 10 Oct 2020 23:24:30 -0700 (PDT)
MIME-Version: 1.0
From: Romain Perier <romain.perier@gmail.com>
Date: Sun, 11 Oct 2020 08:24:19 +0200
Message-ID: <CABgxDoJwP+5Z3qUKuv3Tr=P24eGidk2cjO+yq0y_NwNmSbvQKA@mail.gmail.com>
Subject: Remove all strlcpy() uses in favor of strscpy() (#89)
To: Kernel Hardening <kernel-hardening@lists.openwall.com>
Cc: Kees Cook <keescook@chromium.org>
Content-Type: multipart/alternative; boundary="000000000000025e9e05b15f3c22"

--000000000000025e9e05b15f3c22
Content-Type: text/plain; charset="UTF-8"

Hi,

That's just to let you know that I start to work on this task,
I have also added a comment on the bugtracker.

Regards,
Romain

--000000000000025e9e05b15f3c22
Content-Type: text/html; charset="UTF-8"

<div dir="ltr"><div>Hi,</div><div><br></div><div>That&#39;s just to let you know that I start to work on this task,</div><div>I have also added a comment on the bugtracker.</div><div><br></div><div>Regards,</div><div>Romain<br></div></div>

--000000000000025e9e05b15f3c22--
