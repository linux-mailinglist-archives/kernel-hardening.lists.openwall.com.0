Return-Path: <kernel-hardening-return-19794-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 1757D25F07D
	for <lists+kernel-hardening@lfdr.de>; Sun,  6 Sep 2020 22:26:07 +0200 (CEST)
Received: (qmail 23592 invoked by uid 550); 6 Sep 2020 20:26:01 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 23555 invoked from network); 6 Sep 2020 20:26:00 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=l/Nzg0LsZhaL8h9g22ccJx5bs/Ywcx5BAEp+GJwHt50=;
        b=GV/8+PN4RN9yClYKPSCcivacyZbK/k3jQC7ksTAYhg0tpOiH6h6pRAO1kHP4asQ7eX
         xv4f5oWgF9TROAik8VhvKZ51rmeoGTUNF+xJO2mDvFLBDQUBpkdFQOarGDynTk6Vlttx
         bsJS21S75gwJU63ZqIltGVzrscUXYpOhIWgVU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=l/Nzg0LsZhaL8h9g22ccJx5bs/Ywcx5BAEp+GJwHt50=;
        b=oX//kp3Kk2yv5zmPTtg1z5IDVssQ7FIcC1c7HRm+ARNHSUP4Zdgyv4ZuqVabPtIE8Z
         +6TYJ8LGug9YkzHN28wMpxdCbx8l+3+OqKU/m5MfejK+exCvUmJZWqFOp4ACTd6QaiV+
         6nGulfVFJfVfTntL3Z1Ac/C9iPJ9dEeDBDjrxwF3hnVqVtmq7DckTWM0MMs9b2n+U8yx
         AB1soPBkSf3v2LoSZ+Sthu5cp8pPlAchYjXPnhteZh4eFzE1XYaaABfcbW05Ch2bdlsg
         VkAbVSnWK4J1qz84KmRnV2YNbt3C8AyuzTlpFiZ5VE4HVtsc0JaakJIzGy4iduEMsCqI
         VgcA==
X-Gm-Message-State: AOAM533+4uIo4i5ERChkqsA3fnb4EqgBjiQZGOBJf7LQMlvzjvmuCIee
	fkls+jlcMy1uwiRYn0SSGqmE0tIbekc4Uw==
X-Google-Smtp-Source: ABdhPJwa0sWfu9zXUqXpRX5oI6dkfu8ZXo2Ej8KE99AawmhVUvy0/rnpllqd0lX537VUumrgegzTvg==
X-Received: by 2002:a05:6a00:1688:: with SMTP id k8mr17715914pfc.33.1599423949046;
        Sun, 06 Sep 2020 13:25:49 -0700 (PDT)
Date: Sun, 6 Sep 2020 13:25:47 -0700
From: Kees Cook <keescook@chromium.org>
To: John Wood <john.wood@gmx.com>
Cc: kernel-hardening@lists.openwall.com
Subject: Re: [RFC PATCH 0/9] Fork brute force attack mitigation (fbfam)
Message-ID: <202009061323.75C4EC509F@keescook>
References: <20200906142029.6348-1-john.wood@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200906142029.6348-1-john.wood@gmx.com>

On Sun, Sep 06, 2020 at 04:20:20PM +0200, John Wood wrote:
> The goal of this patch serie is to detect and mitigate a fork brute force
> attack.

I look forward to reviewing it on the list! :) In the meantime, you
could try adding this series as a branch on github (or whatever git
host) tree you have access to. That would allow contextual commenting
there too, if email continues to be a blocker.

-- 
Kees Cook
