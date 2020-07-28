Return-Path: <kernel-hardening-return-19466-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id D982A230CBB
	for <lists+kernel-hardening@lfdr.de>; Tue, 28 Jul 2020 16:50:42 +0200 (CEST)
Received: (qmail 32144 invoked by uid 550); 28 Jul 2020 14:50:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 32124 invoked from network); 28 Jul 2020 14:50:36 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1595947824;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SWjykGqBMInyrV21RjBwz09v26RfChOpFP7bkHaZWz0=;
	b=gL5GVj/1Sh/8xRJw5I5V5ugR3rF5SX7ApolewQ5v8l+CqxPmRkEddfBM2fWKmPr5o+xPcN
	PO6qbLkt9MGtlOYHlicpnJv6zjgDQ5AuueMDgHom+I/0sfySeNluYbmZPiFsddK1nz64LJ
	V/D+dzbLdGSR7NAT/pKGzovSnc4LnMk=
X-MC-Unique: Zrerl_7zO_amUtxi0bg-EA-1
Date: Tue, 28 Jul 2020 16:50:14 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: madvenka@linux.microsoft.com
Cc: kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v1 1/4] [RFC] fs/trampfd: Implement the trampoline file
 descriptor API
Message-ID: <20200728145013.GA9972@redhat.com>
References: <aefc85852ea518982e74b233e11e16d2e707bc32>
 <20200728131050.24443-1-madvenka@linux.microsoft.com>
 <20200728131050.24443-2-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200728131050.24443-2-madvenka@linux.microsoft.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16

On 07/28, madvenka@linux.microsoft.com wrote:
>
> +bool is_trampfd_vma(struct vm_area_struct *vma)
> +{
> +	struct file	*file = vma->vm_file;
> +
> +	if (!file)
> +		return false;
> +	return !strcmp(file->f_path.dentry->d_name.name, trampfd_name);

Hmm, this looks obviously wrong or I am totally confused. A user can
create a file named "[trampfd]", mmap it, and fool trampfd_fault() ?

Why not

	return file->f_op == trampfd_fops;

?

> +EXPORT_SYMBOL_GPL(is_trampfd_vma);

why is it exported?

Oleg.

