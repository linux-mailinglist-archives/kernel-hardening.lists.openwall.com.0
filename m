Return-Path: <kernel-hardening-return-18490-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 2B7AC1A49C0
	for <lists+kernel-hardening@lfdr.de>; Fri, 10 Apr 2020 20:16:09 +0200 (CEST)
Received: (qmail 25884 invoked by uid 550); 10 Apr 2020 18:16:02 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 25843 invoked from network); 10 Apr 2020 18:16:02 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=iIGXHIyp/vpwPANUOULy+0pzQ2AadckQgHiuob/5vnCLagMk61fHJAOcrBV1SjkgP1
         nD38G4Ddvysgf7fOW/z+m8rfxHTxI61+VSUSi+7Wr9d3MeUPNCEjclLiKWyw8ghReXgM
         GEHD4Y6fO3nHkWdD2O0ETUzCKsz+/v5uxUlbyPBNkuqE9r8LZWxkxxgZSDp4NVKnu9rt
         /k7nyadXXtss5OPvItWEL/j4VSBsRebdLrapigDJ9O5Xq698XVl7UikOKjuCbOg14Swo
         AuaEgWvFr4FmBTXyxqF5iNf+CljFOhiZDHzDr3oMJYiW/tp0OBpyNFISQspY0Z7aTgL7
         0RuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=pUzDDd3mNeDka1Kbo7eCxhDePJo1VnLaH1lXNsHgSAUPWQRic6GLVLryxpXt6QjttY
         nzeymscq/n9Us6z9lt5ftvAYXzSCxFTAamfxGaxEAfOHzK4kY+Hel5UNWZuIyX167joj
         bq0UAwmD8UY51qly99U2ORSiW2NZOT2RjdvG8M4/VmAaLg+ODs0MCz3NHTl1EhTMjPZ5
         kttfsGSH6uLu1GPlP2MOiaVWT2CdVARXUB9sAKfrq75p9phXxac+FpeILmVltKGyF+b2
         nh/UKwQinmCOMGslOHFixOYTeeS0iu2gXTnmMQEEJHm+60BcwgSW4A89ODjMDq/Im5Fi
         THmg==
X-Gm-Message-State: AGi0Pua6KSaN2U/0rx/4YwZrvqlyh+AETRBQUNzPXEPxqAmclkdutLha
	bI55twhxoyx144rpzUZjXqk=
X-Google-Smtp-Source: APiQypLLFTLoJadYeF4SRQsycxRFaDIiDJK2w30rAjU2P1LY3LgfjNdOyYaU9ila+seA6uwrsDdkrA==
X-Received: by 2002:adf:c506:: with SMTP id q6mr5960870wrf.142.1586542550653;
        Fri, 10 Apr 2020 11:15:50 -0700 (PDT)
Date: Fri, 10 Apr 2020 21:15:48 +0300
From: Lev Olshvang <levonshe@gmail.com>
To: keescook@chromum.org, kernel-hardening@lists.openwall.com
Subject: [PATCH v1] prevent write to proces's read-only pages
Message-ID: <20200410181548.GA23661@kl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)

