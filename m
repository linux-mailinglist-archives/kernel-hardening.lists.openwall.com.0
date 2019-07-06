Return-Path: <kernel-hardening-return-16370-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 72D4061260
	for <lists+kernel-hardening@lfdr.de>; Sat,  6 Jul 2019 19:33:13 +0200 (CEST)
Received: (qmail 13578 invoked by uid 550); 6 Jul 2019 17:33:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 13543 invoked from network); 6 Jul 2019 17:33:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SEvZkE5vJAPhuJRsrqZsuhS+PD5Zgh6qAYTfG4/9RWg=;
        b=nWzW0LYp8W1LDGaS//1OA1RobxIc5VU0heFAxlgRyqaRrd+E2vAbJ4IWUqPpzxC2NP
         bKxbljkcUx7zP1VqQoZ//yBYx5ZTuHeYNIf4AayhBSngZ3bQdhLc/WHHnhKGTTJLvjS6
         93hrs6Cmz8+cxn3rWw4bx5pAEk8hwA/RlID/aaMy9V1EtaLHrJil1i9raoOLYqwLqkab
         UVl8m8aB3oFCRjd8RLByYm/s1DnzV+V9DBXfXeS8YRUtWDdyroDxYWReVoDcXVz7Tub9
         PRKECViw+UqsNKcfLdE9qKgy5flzI/E4UCiF1ey1IluSuOVuvdYTTkNK7mVigb7uFnfw
         mBQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SEvZkE5vJAPhuJRsrqZsuhS+PD5Zgh6qAYTfG4/9RWg=;
        b=H8R82mD259rpjqXGV7j123x4qGz7h9gbleVmx3XCJKALbXKWdi0OSteA1P3UQ/rQJf
         S9ESf8vLIVo8nHAG4QvTzECYXO9LaIl0jK7KxKw+b/Lr/N7m/EMubhyGXGc3UwG3bDiL
         QCb7iolZlyoVO5h7A8ETBNoIxw0KEGVgBU1tSd5zYBsuByXsjmjf/wMiPj6+mt0IuPQk
         w1tAJmv/G1PGAp8//CimRMb/MgWBcLNw3zmy3q9m0N+WGKljCqIKru7ZyEGhCHUpedMR
         B268SViWHXz3A3PgTEye/72sbmmH0mlAeUkoBaTRJGl8ENB+L44EGq5f1BTqdgCVFomM
         GVVw==
X-Gm-Message-State: APjAAAWZYvTOF24xXBRwYcNjGMGoaz3woykZ5l5242sEKgNz/0wdBJjF
	/LgBFDY4/HSqz7MomQLQURNepkh9vUri/kIhmdo=
X-Google-Smtp-Source: APXvYqyZhsWPUJypEBlw3iOzCCnc0Z8Ysl6psPw4ayKhk+owN6/VPWptNgnm20i2NBMKtNRWNVS5yDY40eR5lXoOP6Y=
X-Received: by 2002:a5d:940b:: with SMTP id v11mr2834210ion.69.1562434375888;
 Sat, 06 Jul 2019 10:32:55 -0700 (PDT)
MIME-Version: 1.0
References: <1562410493-8661-1-git-send-email-s.mesoraca16@gmail.com>
 <1562410493-8661-2-git-send-email-s.mesoraca16@gmail.com> <4d943e67-2e81-93fa-d3f9-e3877403b94d@infradead.org>
In-Reply-To: <4d943e67-2e81-93fa-d3f9-e3877403b94d@infradead.org>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Sat, 6 Jul 2019 19:32:44 +0200
Message-ID: <CAJHCu1+hmA6cPH78KArA2PYwWcTy6US3Ja5XcNVy1bkamddjfQ@mail.gmail.com>
Subject: Re: [PATCH v5 01/12] S.A.R.A.: add documentation
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Brad Spengler <spender@grsecurity.net>, 
	Casey Schaufler <casey@schaufler-ca.com>, Christoph Hellwig <hch@infradead.org>, 
	James Morris <james.l.morris@oracle.com>, Jann Horn <jannh@google.com>, 
	Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"

Randy Dunlap <rdunlap@infradead.org> wrote:
>
> Hi,
>
> Just a few typo fixes (inline).

Hi Randy,
thank you for your help!
I'll address these and the other fixes in the next version of the patchset.

Best,

Salvatore
