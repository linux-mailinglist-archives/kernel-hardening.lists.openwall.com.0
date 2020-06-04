Return-Path: <kernel-hardening-return-18934-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 67EB51EED65
	for <lists+kernel-hardening@lfdr.de>; Thu,  4 Jun 2020 23:39:24 +0200 (CEST)
Received: (qmail 18243 invoked by uid 550); 4 Jun 2020 21:39:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 18220 invoked from network); 4 Jun 2020 21:39:17 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GxmJqfLXObgDK+KB4PktwKQFJAVJiTIxba9sH+6Najs=;
        b=IL8PqzrsuWRpBzyTHT6o67zwSfyJJ6H/YAm4mMD8v7ox1q08sv6wEjeO8FYLb+b+u5
         T4TxLa3f+a7JsAat6XVteKXKr50/vz9U4bbt2xSwSoxPwJWsrOWNwCr12xX1XiqWyjlD
         ifUVNqz6+Xm3SeIrbKJESfeN0Va5dTiUHsfug=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GxmJqfLXObgDK+KB4PktwKQFJAVJiTIxba9sH+6Najs=;
        b=iErgSlUuhPxr7VZbYj6TcjdByulj+/WTVE24o99BycHCdMiAur12WBCOpu2SGlu8H+
         g1umEK3ig+0Cks2cgfL0uAuwwSvke5YZyhGKDl3TuIhW92HMX5aGtScDa/TAf4I3aph5
         TTzwHMWKgWMLfioDzg6qpJWMU8d2UqKGCzEiTxK42ZZs5YL/Z/zOoPd8YGOKVVlgMNvy
         8zJLG732O6NELoo3HTtkAg00fYMXGHb9BrCB3n9CKYN+H2XmMraRr+NPOXumTQIYNyPG
         pMtIFXE6JpX2M1TGaQPwHW6rgdA2OU3TR8/tBM/o8uSjH+oErUmbOwQKzxNJ+YVwD55s
         699A==
X-Gm-Message-State: AOAM532RwjIpGyRqYJDjwDSMtNsRy/PqChYfkg6sxvEaL0h2VIU5gKD+
	sbzF2fjfV8LoB1bWENWORuB+dQ==
X-Google-Smtp-Source: ABdhPJwqmO+s5Ayfmro9mp6aw3eLObX16a9Bk2z2nYF2A6vjUV7vUQolmxGSqZ4qFoJVLF9U3yhHpg==
X-Received: by 2002:a62:1d89:: with SMTP id d131mr6161118pfd.294.1591306745710;
        Thu, 04 Jun 2020 14:39:05 -0700 (PDT)
Date: Thu, 4 Jun 2020 14:39:03 -0700
From: Kees Cook <keescook@chromium.org>
To: Alexander Popov <alex.popov@linux.com>
Cc: Emese Revfy <re.emese@gmail.com>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Michal Marek <michal.lkml@markovi.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	Thiago Jung Bauermann <bauerman@linux.ibm.com>,
	Luis Chamberlain <mcgrof@kernel.org>, Jessica Yu <jeyu@kernel.org>,
	Sven Schnelle <svens@stackframe.org>,
	Iurii Zaikin <yzaikin@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Collingbourne <pcc@google.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Alexander Monakov <amonakov@ispras.ru>,
	Mathias Krause <minipli@googlemail.com>,
	PaX Team <pageexec@freemail.hu>,
	Brad Spengler <spender@grsecurity.net>,
	Laura Abbott <labbott@redhat.com>,
	Florian Weimer <fweimer@redhat.com>,
	kernel-hardening@lists.openwall.com, linux-kbuild@vger.kernel.org,
	x86@kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, gcc@gcc.gnu.org, notify@kernel.org
Subject: Re: [PATCH 0/5] Improvements of the stackleak gcc plugin
Message-ID: <202006041437.F63645F390@keescook>
References: <20200604134957.505389-1-alex.popov@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200604134957.505389-1-alex.popov@linux.com>

On Thu, Jun 04, 2020 at 04:49:52PM +0300, Alexander Popov wrote:
> In this patch series I collected various improvements of the stackleak
> gcc plugin.

Great; thank you! I'll take a closer look at this shortly!

-- 
Kees Cook
