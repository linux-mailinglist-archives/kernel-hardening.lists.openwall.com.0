Return-Path: <kernel-hardening-return-16177-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id D2B6F498A2
	for <lists+kernel-hardening@lfdr.de>; Tue, 18 Jun 2019 07:27:14 +0200 (CEST)
Received: (qmail 5394 invoked by uid 550); 18 Jun 2019 05:27:09 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 5366 invoked from network); 18 Jun 2019 05:27:08 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KBk0vI4RQMrq25uWSdJ+2ep8omPhMVPkB3j/qaHLhoE=;
        b=Y3HKJITKouhlh1TaWa8IWuAVIdnIJ3wgmjU7crc90t1KDNlYYvSLwj18Z0zor9/CM7
         15NCMxEnt9WljXbe3UmAHttwdlrKLaCbiCPf0CFYydlVSL+a5h3Fnj5GWUqU2aBl0lft
         KhcoBYkCUzUb3OOk5cRxE9pLL16NEkLvSrj6I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KBk0vI4RQMrq25uWSdJ+2ep8omPhMVPkB3j/qaHLhoE=;
        b=pXRsVAV7+HQTXi1HzEqUCcorL9Fg4SX1Rx4MQ7SjRiSyYqYQom3Jm0DGjyCbROd4pR
         E1NQdj9flhzt65UJ8ucsmg3fwFkRG0urYUf1OSaeNVdniEzeDs+gr6itjpCXtHYl0+st
         ojHzt2CZwVOtrSR5V6HabbTQBjAvODVR2Z17jqGAmH/LqcsKF6HutKV9yVZyavbZg6mu
         dw7WLdSZJ0TRGeq7mJQIQqf62uUy57Hi1M5u+9kG5Wh8g6jb44KLP38nTplernnZpzYW
         dg+RLwlg5zgikgyPswUUJF4A5azRXVxEQc/pEH3spVtBEOCb/jekS1xkhOt+nT9ZctJz
         +n1g==
X-Gm-Message-State: APjAAAVnV0EQ34I64RKl6ea5gko+8T4o8kR6jLhzYpLjA91Uf7HD01V/
	EAm8QVLLSHp5AfSaKmhbSCGEsw==
X-Google-Smtp-Source: APXvYqxsGDOAjuyeiUBQQfKlHRpkhzSzNh4pYCucZFBzZqr6L06keNW+FE4qiWVrESZjwyeODy5DBQ==
X-Received: by 2002:a63:1d1d:: with SMTP id d29mr956576pgd.259.1560835616920;
        Mon, 17 Jun 2019 22:26:56 -0700 (PDT)
Date: Mon, 17 Jun 2019 22:26:54 -0700
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Potapenko <glider@google.com>,
	Christoph Lameter <cl@linux.com>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	Michal Hocko <mhocko@kernel.org>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Kostya Serebryany <kcc@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Sandeep Patil <sspatil@android.com>,
	Laura Abbott <labbott@redhat.com>,
	Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>,
	Mark Rutland <mark.rutland@arm.com>, Marco Elver <elver@google.com>,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v7 1/2] mm: security: introduce init_on_alloc=1 and
 init_on_free=1 boot options
Message-ID: <201906172225.4645462F1E@keescook>
References: <20190617151050.92663-1-glider@google.com>
 <20190617151050.92663-2-glider@google.com>
 <20190617151027.6422016d74a7dc4c7a562fc6@linux-foundation.org>
 <201906172157.8E88196@keescook>
 <20190617221932.7406c74b6a8114a406984b70@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617221932.7406c74b6a8114a406984b70@linux-foundation.org>

On Mon, Jun 17, 2019 at 10:19:32PM -0700, Andrew Morton wrote:
> On Mon, 17 Jun 2019 22:07:41 -0700 Kees Cook <keescook@chromium.org> wrote:
> 
> > This is expected to be on-by-default on Android and Chrome
> > OS. And it gives the opportunity for anyone else to use it under distros
> > too via the boot args. (The init_on_free feature is regularly requested
> > by folks where memory forensics is included in their thread models.)
> 
> Thanks.  I added the above to the changelog.  I assumed s/thread/threat/

Heh whoops, yes, "threat" was intended. Thanks! :)

-- 
Kees Cook
