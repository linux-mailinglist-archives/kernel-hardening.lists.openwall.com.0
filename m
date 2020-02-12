Return-Path: <kernel-hardening-return-17785-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 7A3F015A4B2
	for <lists+kernel-hardening@lfdr.de>; Wed, 12 Feb 2020 10:27:47 +0100 (CET)
Received: (qmail 28634 invoked by uid 550); 12 Feb 2020 09:27:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 28597 invoked from network); 12 Feb 2020 09:27:39 -0000
Date: Wed, 12 Feb 2020 09:27:23 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Kees Cook <keescook@chromium.org>
Cc: Ingo Molnar <mingo@kernel.org>, Hector Marco-Gisbert <hecmargi@upv.es>,
	Will Deacon <will.deacon@arm.com>,
	Jason Gunthorpe <jgg@mellanox.com>, Jann Horn <jannh@google.com>,
	Russell King <linux@armlinux.org.uk>, x86@kernel.org,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 4/7] arm32/64, elf: Add tables to document
 READ_IMPLIES_EXEC
Message-ID: <20200212092723.GB488264@arrakis.emea.arm.com>
References: <20200210193049.64362-1-keescook@chromium.org>
 <20200210193049.64362-5-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200210193049.64362-5-keescook@chromium.org>

On Mon, Feb 10, 2020 at 11:30:46AM -0800, Kees Cook wrote:
> Add tables to document the current behavior of READ_IMPLIES_EXEC in
> preparation for changing the behavior for both arm64 and arm.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
