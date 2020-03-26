Return-Path: <kernel-hardening-return-18230-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id F3164193591
	for <lists+kernel-hardening@lfdr.de>; Thu, 26 Mar 2020 03:06:17 +0100 (CET)
Received: (qmail 18193 invoked by uid 550); 26 Mar 2020 02:06:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 18161 invoked from network); 26 Mar 2020 02:06:11 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=vlnuxU0Jd+J1XTS9gyIBvTWZ9T9coN3Nnt26SgcjdEs=;
        b=fGTyR1bNh6v3jArHJ+uGOudV2B8Z3SE7Mdp59SLHxcWMD/Mes3HtcrHkrBxG2R4PrX
         xbNG1DiksQ+r1yAFwlA0JPvXUrqFA2FrnP8nFtHCA+4aC8TdijG0wgJbK8W3xCij0a9t
         i2wFwnT//qGc/PmWytoQQM551ctE44xKeNmpo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=vlnuxU0Jd+J1XTS9gyIBvTWZ9T9coN3Nnt26SgcjdEs=;
        b=cqomASm71c1RaHbexI9bShrBRBtNTWCtuFfcyJyrVu3UQ87bfa0CQm3flrK2xXv2Cc
         JcqVEEXjnxmCgQpS+XERKbF3WOQxOUd8+5O6sTgpHEK3fHM8vnq3lNVGD1G7RxARN4su
         IaRtI65w5W0yqLQ7cKDLYA8Dz39fUceugZYc9izV6kVzGlFjaMFf9d83+WeiWttgye2x
         O7DYoIByAtqy9KZwjcaCbp9U0ZkYg2J5zaJKo/i5WrY1+7kzmWw63tb/mFEPhM3RNZxk
         F9F2YmBwWHe7ekx2uXc+BL1tOkCEDs8innXGqPx5awtxdLZOvxpJy9ga1ku5EWq1lDOQ
         OTzg==
X-Gm-Message-State: ANhLgQ3DYFoJtkErgw/3TdDN2U02GYmnRBsBwQPKS3UNHVmzsVEl4ZlY
	YTqHpeX003E0xN5uVK6L0TLmew==
X-Google-Smtp-Source: ADFU+vtwLOI88fBSQtGyR5JaoTXCXFGWWVq1JDhtNRplpCnxPeq1UQjoFZ8pj7Gc2W6YDWdBID3pfg==
X-Received: by 2002:a17:90a:d3d5:: with SMTP id d21mr514689pjw.27.1585188359074;
        Wed, 25 Mar 2020 19:05:59 -0700 (PDT)
Date: Wed, 25 Mar 2020 19:05:57 -0700
From: Kees Cook <keescook@chromium.org>
To: Masahiro Yamada <masahiroy@kernel.org>
Cc: linux-kbuild@vger.kernel.org, kernel-hardening@lists.openwall.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] kconfig: remove unused variable in qconf.cc
Message-ID: <202003251905.6D43E64@keescook>
References: <20200325031433.28223-1-masahiroy@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200325031433.28223-1-masahiroy@kernel.org>

On Wed, Mar 25, 2020 at 12:14:31PM +0900, Masahiro Yamada wrote:
> If this file were compiled with -Wall, the following warning would be
> reported:
> 
> scripts/kconfig/qconf.cc:312:6: warning: unused variable ‘i’ [-Wunused-variable]
>   int i;
>       ^
> 
> The commit prepares to turn on -Wall for C++ host programs.
> 
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
> 
>  scripts/kconfig/qconf.cc | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/scripts/kconfig/qconf.cc b/scripts/kconfig/qconf.cc
> index 82773cc35d35..50a5245d87bb 100644
> --- a/scripts/kconfig/qconf.cc
> +++ b/scripts/kconfig/qconf.cc
> @@ -309,8 +309,6 @@ ConfigList::ConfigList(ConfigView* p, const char *name)
>  	  showName(false), showRange(false), showData(false), mode(singleMode), optMode(normalOpt),
>  	  rootEntry(0), headerPopup(0)
>  {
> -	int i;
> -
>  	setObjectName(name);
>  	setSortingEnabled(false);
>  	setRootIsDecorated(true);
> -- 
> 2.17.1
> 

-- 
Kees Cook
