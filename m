Return-Path: <kernel-hardening-return-21188-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id E16F535A377
	for <lists+kernel-hardening@lfdr.de>; Fri,  9 Apr 2021 18:35:03 +0200 (CEST)
Received: (qmail 13478 invoked by uid 550); 9 Apr 2021 16:34:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 9665 invoked from network); 9 Apr 2021 16:27:03 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:references:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=Phuwohh2HbCcjFvp4UIIQp3Pa48Fgzncr9mTT74dDuc=;
        b=OrDC9KNIV2KoycO1UJbjgt3dS7Zq2KuRnckwcv/US0NFH4y5p75lCVm23WaG0rVojv
         HeCavVxA+Ac3nwNniNDRjJlmFDlnmdgTPgutRu8juSbyZercO77k+ZH4K/xP8mSbGVW1
         G++R4TWtflixrhcsAfXommXjVB6yQiFu5TxHopFnit0aQNYVGcJrLop+n3PsSErczidr
         y/BmGlelv/wJ2dwQIZ2BoB9crvw7/JOCylrmSKctjliDydy1Zqwnxq9epeI68cv8qBo7
         aVl4QC/KAnohy1n6qqYkh6J0d4Hco/WOB13ML9dE/SxBO3Wsvj7W0s+HSYU6g8xU0NgX
         fkxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:references:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Phuwohh2HbCcjFvp4UIIQp3Pa48Fgzncr9mTT74dDuc=;
        b=LKB+niTet/Sq7RDUxwkyIF8//2T2kS832LPXrF0ax5VxGmiI+ZvaVO/wwTwBN70kz2
         N/aprU4lWSbtEUY/aNmdR6fsBc0dunzVGzMhaEBXO8Qui3kl9dUlGEfdBlCvOW7Hv8oO
         TCeeGrOodWhNRQx6UmxC2M6kIsUj+9gU8tdlee3dX7NZMh4jizO99wVIt94DO8L7Gdb6
         b5b//Rm6qEtioMYDB1GWfz0gyinC8qxXh8/V8ZuWGa2pvJoagryJFw5PQQ0EDy1aCGJp
         sAxcw7nHpPjsntP12LHrTpXGw8TF3WNYJRDk+SPCOOD+wq86oCjKWYGF+v9GyUpaIoqR
         O/Mg==
X-Gm-Message-State: AOAM532x6EIm7ME3aa9F597hGG0YhihL3cDPXmfINfizkDtmry1E32XP
	cEK6etS+b+nwbNGbiZDosxM=
X-Google-Smtp-Source: ABdhPJwEELsjjLV+hBsfJiej4imi1ND7VZLuZxQpk+R/tkx/cwIMM3GphnH/4bn5zw34pvgfQlwTVg==
X-Received: by 2002:a1c:9853:: with SMTP id a80mr14414819wme.44.1617985611974;
        Fri, 09 Apr 2021 09:26:51 -0700 (PDT)
From: bauen1 <j2468h@googlemail.com>
X-Google-Original-From: bauen1 <j2468h@gmail.com>
To: mic@digikod.net
Cc: akpm@linux-foundation.org, arnd@arndb.de, casey@schaufler-ca.com,
 christian.brauner@ubuntu.com, christian@python.org, corbet@lwn.net,
 cyphar@cyphar.com, deven.desai@linux.microsoft.com, dvyukov@google.com,
 ebiggers@kernel.org, ericchiang@google.com, fweimer@redhat.com,
 geert@linux-m68k.org, jack@suse.cz, jannh@google.com, jmorris@namei.org,
 keescook@chromium.org, kernel-hardening@lists.openwall.com,
 linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, luto@kernel.org,
 madvenka@linux.microsoft.com, mjg59@google.com, mszeredi@redhat.com,
 mtk.manpages@gmail.com, nramas@linux.microsoft.com,
 philippe.trebuchet@ssi.gouv.fr, scottsh@microsoft.com,
 sean.j.christopherson@intel.com, sgrubb@redhat.com, shuah@kernel.org,
 steve.dower@python.org, thibaut.sautereau@clip-os.org,
 vincent.strubel@ssi.gouv.fr, viro@zeniv.linux.org.uk, willy@infradead.org,
 zohar@linux.ibm.com
References: <20201203173118.379271-1-mic@digikod.net>
Subject: Re: [PATCH v12 0/3] Add trusted_for(2) (was O_MAYEXEC)
Message-ID: <d3b0da18-d0f6-3f72-d3ab-6cf19acae6eb@gmail.com>
Date: Fri, 9 Apr 2021 18:26:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20201203173118.379271-1-mic@digikod.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US

Hello,

As a user of SELinux I'm quite interested in the trusted_for / O_MAYEXEC changes in the kernel and userspace.
However the last activity on this patch seems to be this email from 2020-12-03 with no replies, so what is the status of this patchset or is there something that I'm missing ?

https://patchwork.kernel.org/project/linux-security-module/list/?series=395617

https://lore.kernel.org/linux-security-module/20201203173118.379271-1-mic@digikod.net/


