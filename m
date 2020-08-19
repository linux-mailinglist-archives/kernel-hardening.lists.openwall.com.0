Return-Path: <kernel-hardening-return-19659-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 0D1B424A9E6
	for <lists+kernel-hardening@lfdr.de>; Thu, 20 Aug 2020 01:24:11 +0200 (CEST)
Received: (qmail 14020 invoked by uid 550); 19 Aug 2020 23:24:04 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 7570 invoked from network); 19 Aug 2020 22:18:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1597875527;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=bjqS+7/ag+GlZL7MDHoI6q1qHsiFIMlTVT+GfWM93es=;
	b=dQRNNAVMS7zgF1kARHRXN/XvkGGO4VHUY0m3xQtfi/RuIkEzLL/OK31yS9r/iZy5E837T+
	dI9/glXAVUBnNFzqcFNbjXMsg/zcj4g0qQdjjxaB04Jw69vQuL2XY2nbk2mXeUhHbcPS6y
	ncrWKVCHbiS8PotaTc8dQlR3Bb5es5A=
X-MC-Unique: Ulev0jeUMOWGUvvwSBAbWg-1
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=bjqS+7/ag+GlZL7MDHoI6q1qHsiFIMlTVT+GfWM93es=;
        b=M3AqD/74M6HiEVQ059YRr9rL6WWAam1DByiXpIsZvU7jDEKL4uD09NyZAJbU7iTSm3
         MCjpVARMJexTVPFqeaKsNSl0pzquiqBN3bmZlUp/OFnGcR21I76r44uGFav+ibhUAuu6
         x9JKvb7ZuzbU6t6stAFn0Z6FOYUYcjKUvTrHQv8NVutbP7wvSaeHs3SQD7eueHswkzM0
         cQDPaYRbvDlDbLrotiTYJRhj9t65ShizMbdjfNrx09+K0VNC2TFGj7r3R4Rv+jOOYyjp
         MkY8/N7Rpxh9qeUgsjcRJ9AIRaGWsd8LNrgsLuKg9hFq5FT/PnO95YPmpW57vgNH+3/F
         gAeg==
X-Gm-Message-State: AOAM5300dbVP898C5j6nFc99DhGSH/et3PnmMEQ2CfTs8VDTGA0tNgc+
	AFm15cnx+VMJ2BKN7wt0FA5W4TOI+kMQj5B8jAk0E/arlV/i8D4fTFvcgKGR62YZsxojy8PVGF6
	NwJhcdmhgFjQnUq0DAD6IVnhY6qfI85VOpGdbqleNDPU6atP6Fw==
X-Received: by 2002:aa7:d85a:: with SMTP id f26mr131681eds.363.1597875523805;
        Wed, 19 Aug 2020 15:18:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwnZye/Q8HkQ4liS+Kqt3asNqB7AE105skhLVQlf7vnO2U3mWIqSDEIdoJ51ctolKi0kmHjHkkCYh4rXfBMZLk=
X-Received: by 2002:aa7:d85a:: with SMTP id f26mr131670eds.363.1597875523651;
 Wed, 19 Aug 2020 15:18:43 -0700 (PDT)
MIME-Version: 1.0
From: Jirka Hladky <jhladky@redhat.com>
Date: Thu, 20 Aug 2020 00:18:33 +0200
Message-ID: <CAE4VaGD8sKqUgOxr0im+OJgwrLxbbXDaKTSqpyAGRx=rr9isUg@mail.gmail.com>
Subject: init_on_alloc/init_on_free boot options
To: Alexander Potapenko <glider@google.com>
Cc: kernel-hardening@lists.openwall.com, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jhladky@redhat.com
X-Mimecast-Spam-Score: 0.001
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"

Hi Alex,

Could you please help me to clarify the purpose of init_on_alloc=1
when init_on_free is enabled?

If I get it right, init_on_free=1 alone guarantees that the memory
returned by the page allocator and SL[AU]B is initialized with zeroes.
What is the purpose of init_on_alloc=1 in that case? We are zeroing
memory twice, or am I missing something?

Thanks a lot!
Jirka

