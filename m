Return-Path: <kernel-hardening-return-21550-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 28A694DE435
	for <lists+kernel-hardening@lfdr.de>; Fri, 18 Mar 2022 23:47:12 +0100 (CET)
Received: (qmail 11726 invoked by uid 550); 18 Mar 2022 22:47:04 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 11703 invoked from network); 18 Mar 2022 22:47:03 -0000
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.namei.org 2EAFA54E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=namei.org; s=2;
	t=1647642715; bh=BZqDGcl4o9Xdi1tmgY5xW03TbMhpKwFz2zY2lit+duU=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=0TadzwHr15LTwfizUFip6H4pI3PAx0t6kiX1pSKaHZtrSeiTKZ5755Fp9HWxrgvKf
	 4tcy3l8Px/hTrLtlWSPlDj/76pw8p5ovHGT01GTBIurqnG0tBB5aHeOmv4fbMasoMa
	 FEjy5O3FKGFA1pMOWJNUW2KQeAcL7T/rymjP59w0=
Date: Sat, 19 Mar 2022 09:31:55 +1100 (AEDT)
From: James Morris <jmorris@namei.org>
To: linux-security-module@vger.kernel.org
cc: linux-kernel@vger.kernel.org, lwn@lwn.net, fedora-selinux-list@redhat.com, 
    linux-crypto@vger.kernel.org, kernel-hardening@lists.openwall.com, 
    linux-integrity@vger.kernel.org, selinux@vger.kernel.org, 
    Audit-ML <linux-audit@redhat.com>, gentoo-hardened@gentoo.org, 
    keyrings@linux-nfs.org, tpmdd-devel@lists.sourceforge.net, 
    Linux Security Summit Program Committee <lss-pc@lists.linuxfoundation.org>
Subject: Re: [ANNOUNCE][CFP] Linux Security Summit North America 2022
In-Reply-To: <3e5acc67-829-fafb-c82-833fc22b35a@namei.org>
Message-ID: <3f2d2915-b2b9-1646-d0e9-192296327633@namei.org>
References: <3e5acc67-829-fafb-c82-833fc22b35a@namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Tue, 8 Feb 2022, James Morris wrote:

>   * Event:                September 23-24

Correction: This should be 23-24 June per the top of the email.


-- 
James Morris
<jmorris@namei.org>

